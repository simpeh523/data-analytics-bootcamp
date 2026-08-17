-- =====================================================================================
-- capstone_segmentation.sql
-- Colorado Medicare Part D (2024) — cost-percentile segmentation and outlier detection
-- Author: Caleb Edwards | Stage 2 | Written 2026-08-12
--
-- WHAT THIS FILE DOES
--   Ten commented queries that rank and bucket Colorado Part D prescribing cost at four
--   levels: individual prescriber, specialty, region (city), and age group (under-65 vs
--   65+). Percentile buckets are built with NTILE(); outliers are the members that land
--   in the top bucket.
--
-- SYSTEM OF RECORD
--   The cleaned dataset is outputs\part_d_co_clean.csv (390,473 rows x 24 columns).
--   SQL runs against outputs\part_d.sqlite, table part_d, which holds the same 390,473
--   rows. The two were checked against each other before this file was written and are
--   identical on every field this script touches:
--       rows 390,473 | drug cost $2,737,455,388.61 | claims 16,573,710 |
--       30-day fills 33,119,594.5 | 19,390 NPIs | 97 specialties | 1,177 generics |
--       226 cities
--   The clean CSV's two derived columns (cost_per_claim, cost_per_30day_fill) are not
--   stored in the database; they are recomputed here as cost * 1.0 / denominator, which
--   reproduces the CSV values exactly (0 mismatches across all 390,473 rows).
--
-- HOW TO RUN
--   sqlite3 part_d.sqlite < capstone_segmentation.sql
--   or, to get the markdown result tables:  python run_segmentation_sql.py
--   (no manual edits, no temp tables, no writes — every statement is read-only.
--    All ten statements were executed and returned rows; the python path is the one
--    that was verified, because the sqlite3 command-line shell was not available in
--    the environment this file was written in.)
--
-- PRIMARY METRICS
--   cost_per_claim      = total drug cost / total claims
--   cost_per_30day_fill = total drug cost / total 30-day fills
--   Cost per beneficiary is NOT used: Tot_Benes is blank on 58.9% of rows.
--
-- WITHIN-SPECIALTY RULE
--   Any comparison made inside or across specialties is restricted to specialties with
--   at least 30 distinct prescribers (46 of 97 qualify). Below that, one unusual
--   prescriber moves the whole specialty average.
--
-- CURRICULUM SUBSTITUTIONS (see CALIBRATION.md)
--   1. Percentiles use NTILE(), not PERCENTILE_CONT() — NTILE is the taught construct.
--   2. Float division uses * 1.0, not CAST() — CAST is never taught.
--   3. No CASE WHEN anywhere. The age-group comparison would normally stack "65+" and
--      "under 65" as labelled rows via UNION; UNION is not taught either, so the two age
--      groups are presented as parallel columns on one row instead. Same numbers,
--      taught constructs only.
--   4. Zero denominators are not trapped with COALESCE/NULLIF (not taught); they are
--      excluded with HAVING, or left as SQL's own NULL result.
--
-- HOW THE PERCENTILE BUCKETS ARE SIZED
--   NTILE(n) can only fill n buckets if the group being cut has at least n members;
--   with fewer members every row lands in its own bucket and "bucket 100" never exists.
--   Bucket count is therefore matched to group size:
--       NTILE(100) — 19,390 prescribers statewide (Q2, Q3) and 226 cities (Q7)
--       NTILE(20)  — prescribers inside one specialty (Q5, Q6); bucket 20 = top 5%
--       NTILE(4)   — the 46 qualifying specialties (Q4, Q10) and 60 qualifying
--                    cities (Q8); bucket 4 = top quartile
--   This is the one place the script departs from a literal reading of "percentile":
--   a 46-row table cannot support 100 percentiles, so it is cut into quartiles instead.
--
-- KNOWN DATA LIMIT ON THE AGE-GROUP QUERIES (8, 9, 10)
--   GE65_* columns are suppressed by CMS on 122,906 rows (flag '#') and are blank on a
--   further 41,290 (flag '*'), 42.1% of the file in total. Queries 8-10 therefore run on
--   the 226,277 rows where CMS reported the 65+ split (GE65_Sprsn_Flag = ''), which is
--   $1,949,327,500.29 of the $2,737,455,388.61 statewide total. These are NOT statewide
--   age figures. Whether to impute the suppressed cells is QUESTIONS.md Q9 and is still
--   open — nothing is imputed here.
-- =====================================================================================


-- ==== QUERY 1 | Reconciliation to the Stage 1 Excel workbook ====
-- WHAT: counts the rows, sums the three additive columns, and counts the distinct
--       prescribers, specialties, generic drugs and cities in the table.
-- WHY:  Stage 1 (CAPSTONE_EXCEL_AGGREGATES.xlsx) tied to 390,473 rows,
--       $2,737,455,388.61, 16,573,710 claims, 33,119,594.5 fills, and 19,390 / 97 /
--       1,177 groups. This query has to return those same numbers before any
--       segmentation below can be compared to the workbook. It is the tie-out.
SELECT COUNT(*)                          AS rows_in_file,
       ROUND(SUM(Tot_Drug_Cst), 2)       AS total_drug_cost,
       SUM(Tot_Clms)                     AS total_claims,
       ROUND(SUM(Tot_30day_Fills), 1)    AS total_30day_fills,
       COUNT(DISTINCT Prscrbr_NPI)       AS prescribers,
       COUNT(DISTINCT Prscrbr_Type)      AS specialties,
       COUNT(DISTINCT Gnrc_Name)         AS generic_drugs,
       COUNT(DISTINCT Prscrbr_City)      AS cities
FROM part_d;


-- ==== QUERY 2 | Prescriber level — cost-per-claim percentile, top-bucket outliers ====
-- WHAT: rolls the file up to one row per prescriber, works out that prescriber's cost
--       per claim, sorts all 19,390 prescribers by it, cuts them into 100 equal-sized
--       percentile buckets with NTILE(100), and returns the 25 most expensive members
--       of the top bucket.
-- WHY:  the file's grain is prescriber x brand x generic, so a prescriber appears on
--       many rows. Rolling up first is what makes "this prescriber's cost per claim"
--       a real number. NTILE(100) turns that number into a rank position, so an
--       outlier is defined by where the prescriber sits relative to every other
--       Colorado prescriber rather than by an arbitrary dollar cutoff.
WITH prescriber_totals AS (
    -- one row per prescriber, with their statewide totals
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           SUM(Tot_Drug_Cst)    AS total_cost,
           SUM(Tot_Clms)        AS total_claims,
           SUM(Tot_30day_Fills) AS total_fills
    FROM part_d
    GROUP BY Prscrbr_NPI, Prscrbr_Last_Org_Name, Prscrbr_Type, Prscrbr_City
),
prescriber_metrics AS (
    -- the two primary unit-cost metrics; * 1.0 forces decimal division
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           total_cost,
           total_claims,
           total_fills,
           total_cost * 1.0 / total_claims AS cost_per_claim,
           total_cost * 1.0 / total_fills  AS cost_per_30day_fill
    FROM prescriber_totals
    WHERE total_claims > 0
),
prescriber_percentiles AS (
    -- percentile position of each prescriber on each metric, plus a spend rank
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           total_cost,
           total_claims,
           cost_per_claim,
           cost_per_30day_fill,
           NTILE(100) OVER (ORDER BY cost_per_claim)      AS cost_per_claim_pctile,
           NTILE(100) OVER (ORDER BY cost_per_30day_fill) AS cost_per_fill_pctile,
           NTILE(100) OVER (ORDER BY total_cost)          AS total_cost_pctile
    FROM prescriber_metrics
)
SELECT Prscrbr_NPI,
       Prscrbr_Last_Org_Name,
       Prscrbr_Type,
       Prscrbr_City,
       ROUND(total_cost, 2)          AS total_cost,
       total_claims,
       ROUND(cost_per_claim, 2)      AS cost_per_claim,
       ROUND(cost_per_30day_fill, 2) AS cost_per_30day_fill,
       cost_per_claim_pctile,
       total_cost_pctile
FROM prescriber_percentiles
WHERE cost_per_claim_pctile = 100          -- the top 1% of prescribers by unit cost
ORDER BY cost_per_claim DESC
LIMIT 25;


-- ==== QUERY 3 | Prescriber level — highest total spend, and how concentrated it is ====
-- WHAT: same prescriber rollup, but ranked by total dollars rather than unit cost, with
--       each prescriber's share of the $2.74B statewide total. Returns the top 25.
-- WHY:  cost per claim and total spend answer different questions. A prescriber can be
--       expensive per claim while barely moving the budget, or ordinary per claim and
--       still be one of the largest line items in the state. Both belong in an outlier
--       review. The scalar subquery supplies the statewide denominator.
WITH prescriber_totals AS (
    -- one row per prescriber, with their statewide totals
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           SUM(Tot_Drug_Cst) AS total_cost,
           SUM(Tot_Clms)     AS total_claims
    FROM part_d
    GROUP BY Prscrbr_NPI, Prscrbr_Last_Org_Name, Prscrbr_Type, Prscrbr_City
),
prescriber_ranked AS (
    -- rank by dollars; RANK() so genuine ties share a position
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           total_cost,
           total_claims,
           RANK()     OVER (ORDER BY total_cost DESC) AS spend_rank,
           NTILE(100) OVER (ORDER BY total_cost)      AS total_cost_pctile
    FROM prescriber_totals
)
SELECT spend_rank,
       Prscrbr_NPI,
       Prscrbr_Last_Org_Name,
       Prscrbr_Type,
       Prscrbr_City,
       ROUND(total_cost, 2)                          AS total_cost,
       total_claims,
       ROUND(total_cost * 1.0 / total_claims, 2)     AS cost_per_claim,
       ROUND(total_cost * 100.0 /
             (SELECT SUM(Tot_Drug_Cst) FROM part_d), 3) AS pct_of_state_spend,
       total_cost_pctile
FROM prescriber_ranked
WHERE spend_rank <= 25
ORDER BY spend_rank;


-- ==== QUERY 4 | Specialty level — cost-per-claim quartile, >= 30 prescribers ====
-- WHAT: rolls up to one row per specialty, keeps only specialties with at least 30
--       distinct prescribers, and buckets those into quartiles by cost per claim.
-- WHY:  this is the headline within-specialty comparison. The HAVING clause is the
--       >= 30 prescribers rule: 46 of the 97 specialties clear it. Without that guard a
--       one-prescriber specialty prescribing a single high-cost biologic would top the
--       table and mean nothing.
WITH specialty_totals AS (
    -- one row per specialty; the HAVING clause applies the >= 30 prescribers rule
    SELECT Prscrbr_Type,
           COUNT(DISTINCT Prscrbr_NPI) AS prescribers,
           SUM(Tot_Drug_Cst)           AS total_cost,
           SUM(Tot_Clms)               AS total_claims,
           SUM(Tot_30day_Fills)        AS total_fills
    FROM part_d
    GROUP BY Prscrbr_Type
    HAVING COUNT(DISTINCT Prscrbr_NPI) >= 30
),
specialty_percentiles AS (
    -- quartile position of each qualifying specialty on unit cost and on total spend
    -- (4 buckets, not 100 — only 46 specialties clear the >= 30 prescribers bar)
    SELECT Prscrbr_Type,
           prescribers,
           total_cost,
           total_claims,
           total_cost * 1.0 / total_claims                AS cost_per_claim,
           total_cost * 1.0 / total_fills                 AS cost_per_30day_fill,
           NTILE(4) OVER (ORDER BY total_cost * 1.0 / total_claims) AS cost_per_claim_quartile,
           NTILE(4) OVER (ORDER BY total_cost)                      AS total_cost_quartile,
           RANK()   OVER (ORDER BY total_cost DESC)                 AS spend_rank
    FROM specialty_totals
)
SELECT Prscrbr_Type,
       prescribers,
       ROUND(total_cost, 2)          AS total_cost,
       total_claims,
       ROUND(cost_per_claim, 2)      AS cost_per_claim,
       ROUND(cost_per_30day_fill, 2) AS cost_per_30day_fill,
       cost_per_claim_quartile,
       total_cost_quartile,
       spend_rank
FROM specialty_percentiles
ORDER BY cost_per_claim DESC;


-- ==== QUERY 5 | Within-specialty outliers — prescriber's cost band inside their own specialty ====
-- WHAT: buckets every prescriber into 20 equal bands by cost per claim *within their
--       own specialty* (PARTITION BY Prscrbr_Type), restricted to specialties with at
--       least 30 prescribers, and returns the 25 highest members of band 20 — the top
--       5% of their own specialty.
-- WHY:  a $900-per-claim oncologist is normal; a $900-per-claim family physician is not.
--       Partitioning the window by specialty removes the specialty-mix effect, so what
--       is left is a prescriber who is expensive compared with peers doing the same job.
--       This is the query that supports any "unusual prescribing pattern" claim.
WITH specialty_size AS (
    -- the 46 specialties that clear the >= 30 prescribers bar
    SELECT Prscrbr_Type,
           COUNT(DISTINCT Prscrbr_NPI) AS prescribers_in_specialty
    FROM part_d
    GROUP BY Prscrbr_Type
    HAVING COUNT(DISTINCT Prscrbr_NPI) >= 30
),
prescriber_totals AS (
    -- one row per prescriber
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           SUM(Tot_Drug_Cst) AS total_cost,
           SUM(Tot_Clms)     AS total_claims
    FROM part_d
    GROUP BY Prscrbr_NPI, Prscrbr_Last_Org_Name, Prscrbr_Type, Prscrbr_City
),
prescriber_in_qualifying_specialty AS (
    -- inner join drops prescribers whose specialty is too small to compare within
    SELECT p.Prscrbr_NPI,
           p.Prscrbr_Last_Org_Name,
           p.Prscrbr_Type,
           p.Prscrbr_City,
           p.total_cost,
           p.total_claims,
           p.total_cost * 1.0 / p.total_claims AS cost_per_claim,
           s.prescribers_in_specialty
    FROM prescriber_totals AS p
    INNER JOIN specialty_size AS s
            ON p.Prscrbr_Type = s.Prscrbr_Type
    WHERE p.total_claims > 0
),
within_specialty_percentiles AS (
    -- the band is computed separately inside each specialty; 20 bands, so band 20 is
    -- the specialty's most expensive 5% of prescribers
    SELECT Prscrbr_NPI,
           Prscrbr_Last_Org_Name,
           Prscrbr_Type,
           Prscrbr_City,
           total_cost,
           total_claims,
           cost_per_claim,
           prescribers_in_specialty,
           NTILE(20) OVER (PARTITION BY Prscrbr_Type ORDER BY cost_per_claim) AS cost_band_in_specialty,
           RANK()    OVER (PARTITION BY Prscrbr_Type ORDER BY cost_per_claim DESC) AS rank_in_specialty
    FROM prescriber_in_qualifying_specialty
)
SELECT Prscrbr_Type,
       prescribers_in_specialty,
       rank_in_specialty,
       Prscrbr_NPI,
       Prscrbr_Last_Org_Name,
       Prscrbr_City,
       ROUND(total_cost, 2)     AS total_cost,
       total_claims,
       ROUND(cost_per_claim, 2) AS cost_per_claim,
       cost_band_in_specialty
FROM within_specialty_percentiles
WHERE cost_band_in_specialty = 20      -- most expensive 5% inside their own specialty
ORDER BY cost_per_claim DESC
LIMIT 25;


-- ==== QUERY 6 | Within-specialty outlier concentration — how much does the top 5% carry? ====
-- WHAT: for each qualifying specialty, counts how many prescribers sit in the top
--       within-specialty cost band and what share of that specialty's dollars they
--       account for. The correlated subquery supplies each specialty's own total.
-- WHY:  Query 5 names individuals; this one says whether those individuals matter. A
--       specialty where the top 5% carries 30% of the spend is a different management
--       problem from one where they carry 6%.
WITH specialty_size AS (
    -- the >= 30 prescribers rule again
    SELECT Prscrbr_Type,
           COUNT(DISTINCT Prscrbr_NPI) AS prescribers_in_specialty
    FROM part_d
    GROUP BY Prscrbr_Type
    HAVING COUNT(DISTINCT Prscrbr_NPI) >= 30
),
prescriber_totals AS (
    SELECT Prscrbr_NPI,
           Prscrbr_Type,
           SUM(Tot_Drug_Cst) AS total_cost,
           SUM(Tot_Clms)     AS total_claims
    FROM part_d
    GROUP BY Prscrbr_NPI, Prscrbr_Type
),
within_specialty_percentiles AS (
    SELECT p.Prscrbr_NPI,
           p.Prscrbr_Type,
           p.total_cost,
           p.total_claims,
           s.prescribers_in_specialty,
           NTILE(20) OVER (PARTITION BY p.Prscrbr_Type
                           ORDER BY p.total_cost * 1.0 / p.total_claims) AS cost_band_in_specialty
    FROM prescriber_totals AS p
    INNER JOIN specialty_size AS s
            ON p.Prscrbr_Type = s.Prscrbr_Type
    WHERE p.total_claims > 0
)
SELECT Prscrbr_Type,
       prescribers_in_specialty,
       COUNT(*)                    AS prescribers_in_top_band,
       ROUND(SUM(total_cost), 2)   AS top_band_cost,
       SUM(total_claims)           AS top_band_claims,
       ROUND(SUM(total_cost) * 1.0 / SUM(total_claims), 2) AS top_band_cost_per_claim,
       ROUND(SUM(total_cost) * 100.0 /
             (SELECT SUM(Tot_Drug_Cst)
                FROM part_d
               WHERE part_d.Prscrbr_Type = within_specialty_percentiles.Prscrbr_Type), 2)
                                   AS pct_of_specialty_spend
FROM within_specialty_percentiles
WHERE cost_band_in_specialty = 20
GROUP BY Prscrbr_Type, prescribers_in_specialty
ORDER BY pct_of_specialty_spend DESC;


-- ==== QUERY 7 | Region level — city cost-per-claim and spend percentiles ====
-- WHAT: rolls up to one row per prescriber city, buckets cities into percentiles on
--       cost per claim and on total spend, and returns the 20 largest cities by spend
--       plus, separately below, the unit-cost outliers among cities with at least 30
--       prescribers.
-- WHY:  region is the proposal's geographic cut, and the city field is the only
--       geography in the file. The prescriber-count column is shown so a reader can see
--       which city figures rest on a handful of prescribers.
-- NOTE: city strings are used exactly as CMS supplied them. 28 of the 226 strings are
--       spelling variants of another string (1,856 rows, 0.48%) and several are military
--       installations or neighbourhoods rather than municipalities. Normalising them is
--       QUESTIONS.md Q1/Q2 and is still open, so nothing is merged here.
WITH city_totals AS (
    -- one row per city
    SELECT Prscrbr_City,
           COUNT(DISTINCT Prscrbr_NPI) AS prescribers,
           SUM(Tot_Drug_Cst)           AS total_cost,
           SUM(Tot_Clms)               AS total_claims,
           SUM(Tot_30day_Fills)        AS total_fills
    FROM part_d
    GROUP BY Prscrbr_City
),
city_percentiles AS (
    -- percentile position of each city against all 226 cities
    SELECT Prscrbr_City,
           prescribers,
           total_cost,
           total_claims,
           total_cost * 1.0 / total_claims AS cost_per_claim,
           total_cost * 1.0 / total_fills  AS cost_per_30day_fill,
           NTILE(100) OVER (ORDER BY total_cost * 1.0 / total_claims) AS cost_per_claim_pctile,
           NTILE(100) OVER (ORDER BY total_cost)                      AS total_cost_pctile,
           RANK()     OVER (ORDER BY total_cost DESC)                 AS spend_rank
    FROM city_totals
    WHERE total_claims > 0
)
SELECT spend_rank,
       Prscrbr_City,
       prescribers,
       ROUND(total_cost, 2)          AS total_cost,
       total_claims,
       ROUND(cost_per_claim, 2)      AS cost_per_claim,
       ROUND(cost_per_30day_fill, 2) AS cost_per_30day_fill,
       cost_per_claim_pctile,
       total_cost_pctile
FROM city_percentiles
WHERE spend_rank <= 20
ORDER BY spend_rank;


-- ==== QUERY 8 | Region level — unit-cost outlier cities, >= 30 prescribers ====
-- WHAT: same city rollup, restricted to the 60 cities with at least 30 prescribers,
--       cut into quartiles (60 cities cannot support 100 percentile buckets), ranked
--       by cost per claim, returning the top 15.
-- WHY:  the >= 30 guard from the specialty rule is applied to region as well, because a
--       city with four prescribers has the same small-cell fragility a tiny specialty
--       does. This is the defensible version of "which parts of Colorado are expensive
--       per prescription".
WITH city_totals AS (
    -- one row per city, keeping only cities with >= 30 distinct prescribers
    SELECT Prscrbr_City,
           COUNT(DISTINCT Prscrbr_NPI) AS prescribers,
           SUM(Tot_Drug_Cst)           AS total_cost,
           SUM(Tot_Clms)               AS total_claims,
           SUM(Tot_30day_Fills)        AS total_fills
    FROM part_d
    GROUP BY Prscrbr_City
    HAVING COUNT(DISTINCT Prscrbr_NPI) >= 30
),
city_percentiles AS (
    SELECT Prscrbr_City,
           prescribers,
           total_cost,
           total_claims,
           total_cost * 1.0 / total_claims AS cost_per_claim,
           total_cost * 1.0 / total_fills  AS cost_per_30day_fill,
           NTILE(4) OVER (ORDER BY total_cost * 1.0 / total_claims) AS cost_per_claim_quartile,
           NTILE(4) OVER (ORDER BY total_cost)                      AS total_cost_quartile
    FROM city_totals
)
SELECT Prscrbr_City,
       prescribers,
       ROUND(total_cost, 2)          AS total_cost,
       total_claims,
       ROUND(cost_per_claim, 2)      AS cost_per_claim,
       ROUND(cost_per_30day_fill, 2) AS cost_per_30day_fill,
       cost_per_claim_quartile,
       total_cost_quartile
FROM city_percentiles
ORDER BY cost_per_claim DESC
LIMIT 15;


-- ==== QUERY 9 | Age group — statewide 65+ vs under-65 split, reported rows only ====
-- WHAT: on the 226,277 rows where CMS reported the 65+ breakout, totals claims, fills
--       and dollars for the 65+ group directly from the GE65_* columns, and derives the
--       under-65 group by subtracting 65+ from the row total. Returns one row with both
--       age groups side by side.
-- WHY:  age is the fourth segmentation level in the proposal. The subtraction is only
--       valid where the 65+ figure is actually reported, hence the WHERE clause on the
--       suppression flag. Age groups appear as parallel columns rather than stacked
--       labelled rows because UNION and CASE WHEN are both outside the taught set.
SELECT COUNT(*)                                              AS reported_rows,
       ROUND(SUM(Tot_Drug_Cst), 2)                           AS cost_all_ages,
       ROUND(SUM(GE65_Tot_Drug_Cst), 2)                      AS cost_ge65,
       ROUND(SUM(Tot_Drug_Cst) - SUM(GE65_Tot_Drug_Cst), 2)  AS cost_under65,
       SUM(Tot_Clms)                                         AS claims_all_ages,
       SUM(GE65_Tot_Clms)                                    AS claims_ge65,
       SUM(Tot_Clms) - SUM(GE65_Tot_Clms)                    AS claims_under65,
       ROUND(SUM(Tot_Drug_Cst)      * 1.0 / SUM(Tot_Clms), 2)       AS cpc_all_ages,
       ROUND(SUM(GE65_Tot_Drug_Cst) * 1.0 / SUM(GE65_Tot_Clms), 2)  AS cpc_ge65,
       ROUND((SUM(Tot_Drug_Cst) - SUM(GE65_Tot_Drug_Cst)) * 1.0 /
             (SUM(Tot_Clms)     - SUM(GE65_Tot_Clms)), 2)           AS cpc_under65,
       ROUND(SUM(GE65_Tot_Drug_Cst) * 100.0 / SUM(Tot_Drug_Cst), 1) AS pct_of_cost_ge65
FROM part_d
WHERE GE65_Sprsn_Flag = '';   -- '' = CMS reported the 65+ figures for this row


-- ==== QUERY 10 | Age group by specialty — quartile outliers in each age band ====
-- WHAT: within the reported rows, rolls up to specialty, keeps specialties with at
--       least 30 prescribers, and buckets each specialty into quartiles twice: once
--       on its 65+ cost per claim and once on its under-65 cost per claim.
-- WHY:  this is the age-group outlier query. Two quartile columns on the same row let
--       a reader see a specialty that is an outlier for older patients but ordinary for
--       younger ones, or the reverse — which a single blended cost-per-claim hides. The
--       HAVING clause also drops specialties with no under-65 claims left after the
--       subtraction, since their under-65 cost per claim would be undefined.
WITH age_split_by_specialty AS (
    -- specialty totals split into the two age groups, reported rows only
    SELECT Prscrbr_Type,
           COUNT(DISTINCT Prscrbr_NPI)                      AS prescribers,
           SUM(GE65_Tot_Drug_Cst)                           AS cost_ge65,
           SUM(GE65_Tot_Clms)                               AS claims_ge65,
           SUM(Tot_Drug_Cst) - SUM(GE65_Tot_Drug_Cst)       AS cost_under65,
           SUM(Tot_Clms)     - SUM(GE65_Tot_Clms)           AS claims_under65
    FROM part_d
    WHERE GE65_Sprsn_Flag = ''
    GROUP BY Prscrbr_Type
    HAVING COUNT(DISTINCT Prscrbr_NPI) >= 30
       AND SUM(GE65_Tot_Clms) > 0
       AND SUM(Tot_Clms) - SUM(GE65_Tot_Clms) > 0
),
age_percentiles AS (
    -- one quartile per age group, computed independently of the other
    SELECT Prscrbr_Type,
           prescribers,
           cost_ge65,
           claims_ge65,
           cost_under65,
           claims_under65,
           cost_ge65    * 1.0 / claims_ge65    AS cpc_ge65,
           cost_under65 * 1.0 / claims_under65 AS cpc_under65,
           NTILE(4) OVER (ORDER BY cost_ge65    * 1.0 / claims_ge65)    AS cpc_ge65_quartile,
           NTILE(4) OVER (ORDER BY cost_under65 * 1.0 / claims_under65) AS cpc_under65_quartile
    FROM age_split_by_specialty
)
SELECT Prscrbr_Type,
       prescribers,
       ROUND(cost_ge65, 2)    AS cost_ge65,
       claims_ge65,
       ROUND(cpc_ge65, 2)     AS cpc_ge65,
       cpc_ge65_quartile,
       ROUND(cost_under65, 2) AS cost_under65,
       claims_under65,
       ROUND(cpc_under65, 2)  AS cpc_under65,
       cpc_under65_quartile,
       ROUND(cpc_ge65 - cpc_under65, 2) AS cpc_gap_ge65_minus_under65
FROM age_percentiles
ORDER BY cpc_ge65 DESC;
