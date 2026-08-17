-- =====================================================================
-- outputs/part_d_profiling.sql
-- Profiling queries for the 2024 CMS Medicare Part D Prescribers by
-- Provider and Drug dataset (Colorado only), loaded via load_part_d.py
-- into outputs/part_d.sqlite (table: part_d).
--
-- Self-contained and rerunnable: run against outputs/part_d.sqlite with
-- the sqlite3 CLI (`sqlite3 outputs/part_d.sqlite < outputs/part_d_profiling.sql`)
-- or `sqlite3 -header -column`. Requires SQLite's ceil() math function
-- (built in to Python's bundled sqlite3 / modern sqlite3 CLI builds).
--
-- Calculations only -- no interpretation. See outputs/SQL_FLAGS.md for
-- data-quality notes, foreseeable transformations, and ambiguities.
-- =====================================================================


-- =======================================================================
-- SECTION 1: IMPORT & VERIFICATION
-- =======================================================================

-- [1.1] Row count
-- Purpose: Confirm the loaded row count matches the source CSV (390,473 rows).
SELECT COUNT(*) AS row_count FROM part_d;
-- Sample result:
-- row_count
-- 390473

-- [1.2] Column count
-- Purpose: Confirm the table has the expected 22 columns.
SELECT COUNT(*) AS column_count FROM pragma_table_info('part_d');
-- Sample result:
-- column_count
-- 22

-- [1.3] State value check
-- Purpose: Confirm Prscrbr_State_Abrvtn contains only the value CO, with a row count and % of total per value.
SELECT
    Prscrbr_State_Abrvtn AS state,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Prscrbr_State_Abrvtn
ORDER BY n_rows DESC;
-- Sample result:
-- state | n_rows | pct_of_total
-- CO | 390473 | 100

-- [1.4] Distinct entity counts
-- Purpose: Count distinct NPIs, specialties, generic drug names, and cities in one pass.
SELECT
    COUNT(DISTINCT Prscrbr_NPI)  AS distinct_npi,
    COUNT(DISTINCT Prscrbr_Type) AS distinct_specialty,
    COUNT(DISTINCT Gnrc_Name)    AS distinct_generic,
    COUNT(DISTINCT Prscrbr_City) AS distinct_city
FROM part_d;
-- Sample result:
-- distinct_npi | distinct_specialty | distinct_generic | distinct_city
-- 19390 | 97 | 1177 | 226

-- [1.5] Per-column NULL counts
-- Purpose: Count true SQL NULLs per column (distinct from empty-string blanks, checked next).
SELECT
    SUM(CASE WHEN Prscrbr_NPI IS NULL THEN 1 ELSE 0 END) AS Prscrbr_NPI_nulls,
    SUM(CASE WHEN Prscrbr_Last_Org_Name IS NULL THEN 1 ELSE 0 END) AS Prscrbr_Last_Org_Name_nulls,
    SUM(CASE WHEN Prscrbr_First_Name IS NULL THEN 1 ELSE 0 END) AS Prscrbr_First_Name_nulls,
    SUM(CASE WHEN Prscrbr_City IS NULL THEN 1 ELSE 0 END) AS Prscrbr_City_nulls,
    SUM(CASE WHEN Prscrbr_State_Abrvtn IS NULL THEN 1 ELSE 0 END) AS Prscrbr_State_Abrvtn_nulls,
    SUM(CASE WHEN Prscrbr_State_FIPS IS NULL THEN 1 ELSE 0 END) AS Prscrbr_State_FIPS_nulls,
    SUM(CASE WHEN Prscrbr_Type IS NULL THEN 1 ELSE 0 END) AS Prscrbr_Type_nulls,
    SUM(CASE WHEN Prscrbr_Type_Src IS NULL THEN 1 ELSE 0 END) AS Prscrbr_Type_Src_nulls,
    SUM(CASE WHEN Brnd_Name IS NULL THEN 1 ELSE 0 END) AS Brnd_Name_nulls,
    SUM(CASE WHEN Gnrc_Name IS NULL THEN 1 ELSE 0 END) AS Gnrc_Name_nulls,
    SUM(CASE WHEN Tot_Clms IS NULL THEN 1 ELSE 0 END) AS Tot_Clms_nulls,
    SUM(CASE WHEN Tot_30day_Fills IS NULL THEN 1 ELSE 0 END) AS Tot_30day_Fills_nulls,
    SUM(CASE WHEN Tot_Day_Suply IS NULL THEN 1 ELSE 0 END) AS Tot_Day_Suply_nulls,
    SUM(CASE WHEN Tot_Drug_Cst IS NULL THEN 1 ELSE 0 END) AS Tot_Drug_Cst_nulls,
    SUM(CASE WHEN Tot_Benes IS NULL THEN 1 ELSE 0 END) AS Tot_Benes_nulls,
    SUM(CASE WHEN GE65_Sprsn_Flag IS NULL THEN 1 ELSE 0 END) AS GE65_Sprsn_Flag_nulls,
    SUM(CASE WHEN GE65_Tot_Clms IS NULL THEN 1 ELSE 0 END) AS GE65_Tot_Clms_nulls,
    SUM(CASE WHEN GE65_Tot_30day_Fills IS NULL THEN 1 ELSE 0 END) AS GE65_Tot_30day_Fills_nulls,
    SUM(CASE WHEN GE65_Tot_Drug_Cst IS NULL THEN 1 ELSE 0 END) AS GE65_Tot_Drug_Cst_nulls,
    SUM(CASE WHEN GE65_Tot_Day_Suply IS NULL THEN 1 ELSE 0 END) AS GE65_Tot_Day_Suply_nulls,
    SUM(CASE WHEN GE65_Bene_Sprsn_Flag IS NULL THEN 1 ELSE 0 END) AS GE65_Bene_Sprsn_Flag_nulls,
    SUM(CASE WHEN GE65_Tot_Benes IS NULL THEN 1 ELSE 0 END) AS GE65_Tot_Benes_nulls
FROM part_d;
-- Sample result:
-- Prscrbr_NPI_nulls | Prscrbr_Last_Org_Name_nulls | Prscrbr_First_Name_nulls | Prscrbr_City_nulls | Prscrbr_State_Abrvtn_nulls | Prscrbr_State_FIPS_nulls | Prscrbr_Type_nulls | Prscrbr_Type_Src_nulls | Brnd_Name_nulls | Gnrc_Name_nulls | Tot_Clms_nulls | Tot_30day_Fills_nulls | Tot_Day_Suply_nulls | Tot_Drug_Cst_nulls | Tot_Benes_nulls | GE65_Sprsn_Flag_nulls | GE65_Tot_Clms_nulls | GE65_Tot_30day_Fills_nulls | GE65_Tot_Drug_Cst_nulls | GE65_Tot_Day_Suply_nulls | GE65_Bene_Sprsn_Flag_nulls | GE65_Tot_Benes_nulls
-- 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0

-- [1.6] Per-column empty-string counts
-- Purpose: Count empty-string blanks per column, as loaded from the source CSV.
SELECT
    SUM(CASE WHEN Prscrbr_NPI = '' THEN 1 ELSE 0 END) AS Prscrbr_NPI_empty,
    SUM(CASE WHEN Prscrbr_Last_Org_Name = '' THEN 1 ELSE 0 END) AS Prscrbr_Last_Org_Name_empty,
    SUM(CASE WHEN Prscrbr_First_Name = '' THEN 1 ELSE 0 END) AS Prscrbr_First_Name_empty,
    SUM(CASE WHEN Prscrbr_City = '' THEN 1 ELSE 0 END) AS Prscrbr_City_empty,
    SUM(CASE WHEN Prscrbr_State_Abrvtn = '' THEN 1 ELSE 0 END) AS Prscrbr_State_Abrvtn_empty,
    SUM(CASE WHEN Prscrbr_State_FIPS = '' THEN 1 ELSE 0 END) AS Prscrbr_State_FIPS_empty,
    SUM(CASE WHEN Prscrbr_Type = '' THEN 1 ELSE 0 END) AS Prscrbr_Type_empty,
    SUM(CASE WHEN Prscrbr_Type_Src = '' THEN 1 ELSE 0 END) AS Prscrbr_Type_Src_empty,
    SUM(CASE WHEN Brnd_Name = '' THEN 1 ELSE 0 END) AS Brnd_Name_empty,
    SUM(CASE WHEN Gnrc_Name = '' THEN 1 ELSE 0 END) AS Gnrc_Name_empty,
    SUM(CASE WHEN Tot_Clms = '' THEN 1 ELSE 0 END) AS Tot_Clms_empty,
    SUM(CASE WHEN Tot_30day_Fills = '' THEN 1 ELSE 0 END) AS Tot_30day_Fills_empty,
    SUM(CASE WHEN Tot_Day_Suply = '' THEN 1 ELSE 0 END) AS Tot_Day_Suply_empty,
    SUM(CASE WHEN Tot_Drug_Cst = '' THEN 1 ELSE 0 END) AS Tot_Drug_Cst_empty,
    SUM(CASE WHEN Tot_Benes = '' THEN 1 ELSE 0 END) AS Tot_Benes_empty,
    SUM(CASE WHEN GE65_Sprsn_Flag = '' THEN 1 ELSE 0 END) AS GE65_Sprsn_Flag_empty,
    SUM(CASE WHEN GE65_Tot_Clms = '' THEN 1 ELSE 0 END) AS GE65_Tot_Clms_empty,
    SUM(CASE WHEN GE65_Tot_30day_Fills = '' THEN 1 ELSE 0 END) AS GE65_Tot_30day_Fills_empty,
    SUM(CASE WHEN GE65_Tot_Drug_Cst = '' THEN 1 ELSE 0 END) AS GE65_Tot_Drug_Cst_empty,
    SUM(CASE WHEN GE65_Tot_Day_Suply = '' THEN 1 ELSE 0 END) AS GE65_Tot_Day_Suply_empty,
    SUM(CASE WHEN GE65_Bene_Sprsn_Flag = '' THEN 1 ELSE 0 END) AS GE65_Bene_Sprsn_Flag_empty,
    SUM(CASE WHEN GE65_Tot_Benes = '' THEN 1 ELSE 0 END) AS GE65_Tot_Benes_empty
FROM part_d;
-- Sample result:
-- Prscrbr_NPI_empty | Prscrbr_Last_Org_Name_empty | Prscrbr_First_Name_empty | Prscrbr_City_empty | Prscrbr_State_Abrvtn_empty | Prscrbr_State_FIPS_empty | Prscrbr_Type_empty | Prscrbr_Type_Src_empty | Brnd_Name_empty | Gnrc_Name_empty | Tot_Clms_empty | Tot_30day_Fills_empty | Tot_Day_Suply_empty | Tot_Drug_Cst_empty | Tot_Benes_empty | GE65_Sprsn_Flag_empty | GE65_Tot_Clms_empty | GE65_Tot_30day_Fills_empty | GE65_Tot_Drug_Cst_empty | GE65_Tot_Day_Suply_empty | GE65_Bene_Sprsn_Flag_empty | GE65_Tot_Benes_empty
-- 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 229912 | 226277 | 164196 | 164196 | 164196 | 164196 | 53317 | 337156

-- [1.7] Numeric column parse check
-- Purpose: For each numeric column, count non-blank values that did NOT parse as integer/real (should be 0 for all).
SELECT
    SUM(CASE WHEN Tot_Clms <> '' AND typeof(Tot_Clms) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS Tot_Clms_non_numeric,
    SUM(CASE WHEN Tot_30day_Fills <> '' AND typeof(Tot_30day_Fills) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS Tot_30day_Fills_non_numeric,
    SUM(CASE WHEN Tot_Day_Suply <> '' AND typeof(Tot_Day_Suply) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS Tot_Day_Suply_non_numeric,
    SUM(CASE WHEN Tot_Drug_Cst <> '' AND typeof(Tot_Drug_Cst) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS Tot_Drug_Cst_non_numeric,
    SUM(CASE WHEN Tot_Benes <> '' AND typeof(Tot_Benes) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS Tot_Benes_non_numeric,
    SUM(CASE WHEN GE65_Tot_Clms <> '' AND typeof(GE65_Tot_Clms) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS GE65_Tot_Clms_non_numeric,
    SUM(CASE WHEN GE65_Tot_30day_Fills <> '' AND typeof(GE65_Tot_30day_Fills) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS GE65_Tot_30day_Fills_non_numeric,
    SUM(CASE WHEN GE65_Tot_Drug_Cst <> '' AND typeof(GE65_Tot_Drug_Cst) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS GE65_Tot_Drug_Cst_non_numeric,
    SUM(CASE WHEN GE65_Tot_Day_Suply <> '' AND typeof(GE65_Tot_Day_Suply) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS GE65_Tot_Day_Suply_non_numeric,
    SUM(CASE WHEN GE65_Tot_Benes <> '' AND typeof(GE65_Tot_Benes) NOT IN ('integer','real') THEN 1 ELSE 0 END) AS GE65_Tot_Benes_non_numeric
FROM part_d;
-- Sample result:
-- Tot_Clms_non_numeric | Tot_30day_Fills_non_numeric | Tot_Day_Suply_non_numeric | Tot_Drug_Cst_non_numeric | Tot_Benes_non_numeric | GE65_Tot_Clms_non_numeric | GE65_Tot_30day_Fills_non_numeric | GE65_Tot_Drug_Cst_non_numeric | GE65_Tot_Day_Suply_non_numeric | GE65_Tot_Benes_non_numeric
-- 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0

-- [1.8] Total drug cost tie-out
-- Purpose: Confirm the sum of Tot_Drug_Cst ties to the verified total of $2,737,500,000.
SELECT ROUND(SUM(Tot_Drug_Cst), 2) AS total_drug_cost FROM part_d;
-- Sample result:
-- total_drug_cost
-- 2737455388.61


-- =======================================================================
-- SECTION 2: UNIVARIATE PROFILING
-- =======================================================================

-- [2.1] Categorical distribution: Prscrbr_State_Abrvtn
-- Purpose: Distinct values of Prscrbr_State_Abrvtn (prescriber state) with row count and % of total, ordered by frequency descending.
SELECT
    Prscrbr_State_Abrvtn AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Prscrbr_State_Abrvtn
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- CO | 390473 | 100

-- [2.2] Categorical distribution: Prscrbr_City
-- Purpose: Distinct values of Prscrbr_City (prescriber city) with row count and % of total, ordered by frequency descending.
SELECT
    Prscrbr_City AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Prscrbr_City
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- Denver | 48634 | 12.4552
-- Colorado Springs | 40743 | 10.4343
-- Aurora | 34301 | 8.7845
-- Fort Collins | 17572 | 4.5002
-- Pueblo | 17230 | 4.4126
-- Grand Junction | 12318 | 3.1546
-- Lakewood | 12080 | 3.0937
-- Littleton | 11890 | 3.045
-- Westminster | 11368 | 2.9113
-- Parker | 9865 | 2.5264
-- ... (226 rows total)

-- [2.3] Categorical distribution: Prscrbr_Type
-- Purpose: Distinct values of Prscrbr_Type (prescriber specialty) with row count and % of total, ordered by frequency descending.
SELECT
    Prscrbr_Type AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Prscrbr_Type
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- Family Practice | 112120 | 28.7139
-- Nurse Practitioner | 80078 | 20.5079
-- Internal Medicine | 62451 | 15.9937
-- Physician Assistant | 50431 | 12.9154
-- Cardiology | 6222 | 1.5935
-- Psychiatry | 6210 | 1.5904
-- Neurology | 5444 | 1.3942
-- Dentist | 3970 | 1.0167
-- Emergency Medicine | 3932 | 1.007
-- Ophthalmology | 3529 | 0.9038
-- ... (97 rows total)

-- [2.4] Categorical distribution: Prscrbr_Type_Src
-- Purpose: Distinct values of Prscrbr_Type_Src (specialty source) with row count and % of total, ordered by frequency descending.
SELECT
    Prscrbr_Type_Src AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Prscrbr_Type_Src
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- Claim-Specialty | 344460 | 88.2161
-- NPPES-Specialty | 40016 | 10.2481
-- NPPES-Taxonomy | 5997 | 1.5358

-- [2.5] Categorical distribution: Brnd_Name
-- Purpose: Distinct values of Brnd_Name (drug brand name) with row count and % of total, ordered by frequency descending.
SELECT
    Brnd_Name AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Brnd_Name
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- Gabapentin | 6447 | 1.6511
-- Atorvastatin Calcium | 6131 | 1.5701
-- Lisinopril | 5504 | 1.4096
-- Amlodipine Besylate | 5479 | 1.4032
-- Levothyroxine Sodium | 5305 | 1.3586
-- Losartan Potassium | 5146 | 1.3179
-- Omeprazole | 4968 | 1.2723
-- Prednisone | 4728 | 1.2108
-- Trazodone Hcl | 4641 | 1.1886
-- Rosuvastatin Calcium | 4544 | 1.1637
-- ... (1662 rows total)

-- [2.6] Categorical distribution: Gnrc_Name
-- Purpose: Distinct values of Gnrc_Name (drug generic name) with row count and % of total, ordered by frequency descending.
SELECT
    Gnrc_Name AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY Gnrc_Name
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- Levothyroxine Sodium | 7007 | 1.7945
-- Metformin Hcl | 6959 | 1.7822
-- Gabapentin | 6460 | 1.6544
-- Atorvastatin Calcium | 6132 | 1.5704
-- Lisinopril | 5504 | 1.4096
-- Amlodipine Besylate | 5480 | 1.4034
-- Albuterol Sulfate | 5347 | 1.3694
-- Losartan Potassium | 5146 | 1.3179
-- Omeprazole | 4968 | 1.2723
-- Prednisone | 4729 | 1.2111
-- ... (1177 rows total)

-- [2.7] Categorical distribution: GE65_Sprsn_Flag
-- Purpose: Distinct values of GE65_Sprsn_Flag (GE65 claims/cost suppression flag) with row count and % of total, ordered by frequency descending.
SELECT
    GE65_Sprsn_Flag AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY GE65_Sprsn_Flag
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
--  | 226277 | 57.9495
-- # | 122906 | 31.4762
-- * | 41290 | 10.5744

-- [2.8] Categorical distribution: GE65_Bene_Sprsn_Flag
-- Purpose: Distinct values of GE65_Bene_Sprsn_Flag (GE65 beneficiary suppression flag) with row count and % of total, ordered by frequency descending.
SELECT
    GE65_Bene_Sprsn_Flag AS value,
    COUNT(*) AS n_rows,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM part_d), 4) AS pct_of_total
FROM part_d
GROUP BY GE65_Bene_Sprsn_Flag
ORDER BY n_rows DESC;
-- Sample result:
-- value | n_rows | pct_of_total
-- * | 238726 | 61.1376
-- # | 98430 | 25.2079
--  | 53317 | 13.6545

-- [2.9] Numeric summary: Tot_Clms
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Clms (non-blank values only).
WITH vals AS (
    SELECT CAST(Tot_Clms AS REAL) AS v
    FROM part_d
    WHERE Tot_Clms IS NOT NULL AND Tot_Clms <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 390473 | 11 | 21631 | 42.4452 | 23 | 11 | 80.3944 | 15 | 23 | 43 | 88 | 307

-- [2.10] Numeric summary: Tot_30day_Fills
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_30day_Fills (non-blank values only).
WITH vals AS (
    SELECT CAST(Tot_30day_Fills AS REAL) AS v
    FROM part_d
    WHERE Tot_30day_Fills IS NOT NULL AND Tot_30day_Fills <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 390473 | 11 | 21631 | 84.8192 | 39.9 | 12 | 157.3359 | 21.8 | 39.9 | 82.7 | 183.2 | 750

-- [2.11] Numeric summary: Tot_Day_Suply
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Day_Suply (non-blank values only).
WITH vals AS (
    SELECT CAST(Tot_Day_Suply AS REAL) AS v
    FROM part_d
    WHERE Tot_Day_Suply IS NOT NULL AND Tot_Day_Suply <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 390473 | 11 | 112491 | 2408.0078 | 1103 | 360 | 4447.6687 | 502 | 1103 | 2368 | 5370 | 22256

-- [2.12] Numeric summary: Tot_Drug_Cst
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Drug_Cst (non-blank values only).
WITH vals AS (
    SELECT CAST(Tot_Drug_Cst AS REAL) AS v
    FROM part_d
    WHERE Tot_Drug_Cst IS NOT NULL AND Tot_Drug_Cst <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 390473 | 0 | 10210321.85 | 7010.6138 | 442.71 | 0 | 59190.4134 | 185.76 | 442.71 | 1347.48 | 7885.14 | 124277.12

-- [2.13] Numeric summary: Tot_Benes
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Benes (non-blank values only).
WITH vals AS (
    SELECT CAST(Tot_Benes AS REAL) AS v
    FROM part_d
    WHERE Tot_Benes IS NOT NULL AND Tot_Benes <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 160561 | 11 | 16313 | 27.9489 | 19 | 11 | 76.671 | 13 | 19 | 30 | 52 | 140

-- [2.14] Numeric summary: GE65_Tot_Clms
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Clms (non-blank values only).
WITH vals AS (
    SELECT CAST(GE65_Tot_Clms AS REAL) AS v
    FROM part_d
    WHERE GE65_Tot_Clms IS NOT NULL AND GE65_Tot_Clms <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 226277 | 0 | 20053 | 38.412 | 20 | 11 | 89.0139 | 13 | 20 | 38 | 79 | 305

-- [2.15] Numeric summary: GE65_Tot_30day_Fills
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_30day_Fills (non-blank values only).
WITH vals AS (
    SELECT CAST(GE65_Tot_30day_Fills AS REAL) AS v
    FROM part_d
    WHERE GE65_Tot_30day_Fills IS NOT NULL AND GE65_Tot_30day_Fills <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 226277 | 0 | 20053 | 78.6697 | 37 | 0 | 160.2212 | 19 | 37 | 75 | 167.3 | 733.9

-- [2.16] Numeric summary: GE65_Tot_Drug_Cst
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Drug_Cst (non-blank values only).
WITH vals AS (
    SELECT CAST(GE65_Tot_Drug_Cst AS REAL) AS v
    FROM part_d
    WHERE GE65_Tot_Drug_Cst IS NOT NULL AND GE65_Tot_Drug_Cst <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 226277 | 0 | 9915014.4 | 7091.5598 | 395.73 | 0 | 59500.6704 | 158.92 | 395.73 | 1234.16 | 7827.38 | 131890.69

-- [2.17] Numeric summary: GE65_Tot_Day_Suply
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Day_Suply (non-blank values only).
WITH vals AS (
    SELECT CAST(GE65_Tot_Day_Suply AS REAL) AS v
    FROM part_d
    WHERE GE65_Tot_Day_Suply IS NOT NULL AND GE65_Tot_Day_Suply <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 226277 | 0 | 107221 | 2253.4143 | 1065 | 0 | 4371.0606 | 450 | 1065 | 2160 | 4897 | 21692

-- [2.18] Numeric summary: GE65_Tot_Benes
-- Purpose: Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Benes (non-blank values only).
WITH vals AS (
    SELECT CAST(GE65_Tot_Benes AS REAL) AS v
    FROM part_d
    WHERE GE65_Tot_Benes IS NOT NULL AND GE65_Tot_Benes <> ''
),
ranked AS (
    SELECT v, ROW_NUMBER() OVER (ORDER BY v) AS rn, COUNT(*) OVER () AS n
    FROM vals
),
agg AS (
    SELECT COUNT(*) AS n, MIN(v) AS min_v, MAX(v) AS max_v, AVG(v) AS mean_v,
           SUM(v) AS sum_v, SUM(v * v) AS sumsq_v
    FROM vals
),
modev AS (
    SELECT v AS mode_v
    FROM vals
    GROUP BY v
    ORDER BY COUNT(*) DESC, v ASC
    LIMIT 1
)
SELECT
    agg.n AS n,
    ROUND(agg.min_v, 4) AS min,
    ROUND(agg.max_v, 4) AS max,
    ROUND(agg.mean_v, 4) AS mean,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median,
    modev.mode_v AS mode,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 4) AS stddev,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS p50,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99
FROM agg, modev;
-- Sample result:
-- n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99
-- 53317 | 0 | 15104 | 25.3859 | 17 | 11 | 121.4703 | 13 | 17 | 25 | 41 | 127


-- =======================================================================
-- SECTION 3: BIVARIATE PROFILING (distribution shape only)
-- =======================================================================

-- [3.1] Crosstab sample: specialty x city
-- Purpose: Top 20 specialty x city combinations by total drug cost, with row count and total claims (sample, not full enumeration).
SELECT
    Prscrbr_Type AS dim1,
    Prscrbr_City AS dim2,
    COUNT(*) AS n_rows,
    ROUND(SUM(Tot_Clms), 2) AS total_claims,
    ROUND(SUM(Tot_Drug_Cst), 2) AS total_drug_cost
FROM part_d
GROUP BY Prscrbr_Type, Prscrbr_City
ORDER BY total_drug_cost DESC
LIMIT 20;
-- Sample result:
-- dim1 | dim2 | n_rows | total_claims | total_drug_cost
-- Internal Medicine | Denver | 13530 | 623739 | 72124029.05
-- Nurse Practitioner | Colorado Springs | 11191 | 416359 | 59585798.64
-- Nurse Practitioner | Aurora | 5932 | 205177 | 52789737.84
-- Nurse Practitioner | Denver | 7795 | 263274 | 51376805.46
-- Pulmonary Disease | Denver | 786 | 31001 | 46120672.78
-- Hematology-Oncology | Denver | 552 | 16780 | 40230325.5
-- Hematology-Oncology | Aurora | 208 | 7219 | 33371249.04
-- Medical Oncology | Aurora | 438 | 12217 | 33239488.84
-- Nurse Practitioner | Pueblo | 5814 | 234438 | 32899442.21
-- Family Practice | Colorado Springs | 10334 | 441477 | 32471627.5
-- Physician Assistant | Colorado Springs | 5889 | 215801 | 31037673.33
-- Rheumatology | Denver | 764 | 40024 | 30634437.7
-- Critical Care (Intensivists) | Denver | 268 | 10580 | 29674113.31
-- Physician Assistant | Aurora | 4343 | 136299 | 29369453.29
-- Neurology | Aurora | 943 | 33265 | 28230717.23
-- Internal Medicine | Aurora | 6346 | 297040 | 27458107.19
-- Family Practice | Denver | 9090 | 327707 | 27404776.73
-- Hematology-Oncology | Colorado Springs | 355 | 10790 | 24317365.87
-- Infectious Disease | Aurora | 804 | 23768 | 22488974.52
-- Hematology-Oncology | Fort Collins | 233 | 8772 | 20711917.75

-- [3.2] Distribution shape: total claims by specialty x city
-- Purpose: Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total claims across all populated specialty x city combinations.
WITH grp AS (
    SELECT Prscrbr_Type, Prscrbr_City, SUM(Tot_Clms) AS grp_total, COUNT(*) AS grp_rows
    FROM part_d
    GROUP BY Prscrbr_Type, Prscrbr_City
),
ranked AS (
    SELECT grp_total AS v, ROW_NUMBER() OVER (ORDER BY grp_total) AS rn, COUNT(*) OVER () AS n
    FROM grp
),
agg AS (
    SELECT COUNT(*) AS n, MIN(grp_total) AS min_v, MAX(grp_total) AS max_v, AVG(grp_total) AS mean_v,
           SUM(grp_total) AS sum_v, SUM(grp_total * grp_total) AS sumsq_v
    FROM grp
)
SELECT
    agg.n AS n_groups,
    ROUND(agg.min_v, 2) AS min_group_total,
    ROUND(agg.max_v, 2) AS max_group_total,
    ROUND(agg.mean_v, 2) AS mean_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median_group_total,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 2) AS stddev_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99_group_total
FROM agg;
-- Sample result:
-- n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total
-- 2118 | 11 | 623739 | 7825.17 | 774 | 30523.53 | 150 | 3907 | 13292 | 136299

-- [3.3] Distribution shape: total drug cost by specialty x city
-- Purpose: Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total drug cost across all populated specialty x city combinations.
WITH grp AS (
    SELECT Prscrbr_Type, Prscrbr_City, SUM(Tot_Drug_Cst) AS grp_total, COUNT(*) AS grp_rows
    FROM part_d
    GROUP BY Prscrbr_Type, Prscrbr_City
),
ranked AS (
    SELECT grp_total AS v, ROW_NUMBER() OVER (ORDER BY grp_total) AS rn, COUNT(*) OVER () AS n
    FROM grp
),
agg AS (
    SELECT COUNT(*) AS n, MIN(grp_total) AS min_v, MAX(grp_total) AS max_v, AVG(grp_total) AS mean_v,
           SUM(grp_total) AS sum_v, SUM(grp_total * grp_total) AS sumsq_v
    FROM grp
)
SELECT
    agg.n AS n_groups,
    ROUND(agg.min_v, 2) AS min_group_total,
    ROUND(agg.max_v, 2) AS max_group_total,
    ROUND(agg.mean_v, 2) AS mean_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median_group_total,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 2) AS stddev_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99_group_total
FROM agg;
-- Sample result:
-- n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total
-- 2118 | 7.83 | 72124029.05 | 1292471.85 | 44230.21 | 4427124.23 | 2505.02 | 553587.77 | 3210593.96 | 19574232.47

-- [3.4] Crosstab sample: specialty x generic drug
-- Purpose: Top 20 specialty x generic drug combinations by total drug cost, with row count and total claims (sample, not full enumeration).
SELECT
    Prscrbr_Type AS dim1,
    Gnrc_Name AS dim2,
    COUNT(*) AS n_rows,
    ROUND(SUM(Tot_Clms), 2) AS total_claims,
    ROUND(SUM(Tot_Drug_Cst), 2) AS total_drug_cost
FROM part_d
GROUP BY Prscrbr_Type, Gnrc_Name
ORDER BY total_drug_cost DESC
LIMIT 20;
-- Sample result:
-- dim1 | dim2 | n_rows | total_claims | total_drug_cost
-- Hematology-Oncology | Lenalidomide | 92 | 3394 | 54475740.75
-- Family Practice | Apixaban | 1141 | 56402 | 49235652.23
-- Internal Medicine | Apixaban | 709 | 51024 | 45171200.11
-- Cardiology | Apixaban | 181 | 35872 | 45039627.76
-- Family Practice | Semaglutide | 1083 | 33224 | 40391260.63
-- Rheumatology | Adalimumab | 120 | 4350 | 36431817.29
-- Nurse Practitioner | Apixaban | 884 | 41991 | 35895873.32
-- Rheumatology | Etanercept | 108 | 4676 | 33712339.89
-- Family Practice | Empagliflozin | 1013 | 33032 | 32727057.34
-- Internal Medicine | Semaglutide | 572 | 23646 | 28721657.47
-- Internal Medicine | Empagliflozin | 538 | 24218 | 22009008.74
-- Family Practice | Dulaglutide | 615 | 16472 | 20688636.84
-- Nurse Practitioner | Semaglutide | 525 | 15987 | 19862308.84
-- Gastroenterology | Ustekinumab | 30 | 729 | 19810825.66
-- Physician Assistant | Apixaban | 494 | 20015 | 19764041.08
-- Pulmonary Disease | Nintedanib Esylate | 39 | 1476 | 19558368.89
-- Nurse Practitioner | Empagliflozin | 583 | 19667 | 19387386.17
-- Family Practice | Rivaroxaban | 673 | 19119 | 18238899.87
-- Infectious Disease | Bictegrav/Emtricit/Tenofov Ala | 58 | 4038 | 18221976.33
-- Family Practice | Tirzepatide | 474 | 14302 | 17950092.7

-- [3.5] Distribution shape: total claims by specialty x generic drug
-- Purpose: Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total claims across all populated specialty x generic drug combinations.
WITH grp AS (
    SELECT Prscrbr_Type, Gnrc_Name, SUM(Tot_Clms) AS grp_total, COUNT(*) AS grp_rows
    FROM part_d
    GROUP BY Prscrbr_Type, Gnrc_Name
),
ranked AS (
    SELECT grp_total AS v, ROW_NUMBER() OVER (ORDER BY grp_total) AS rn, COUNT(*) OVER () AS n
    FROM grp
),
agg AS (
    SELECT COUNT(*) AS n, MIN(grp_total) AS min_v, MAX(grp_total) AS max_v, AVG(grp_total) AS mean_v,
           SUM(grp_total) AS sum_v, SUM(grp_total * grp_total) AS sumsq_v
    FROM grp
)
SELECT
    agg.n AS n_groups,
    ROUND(agg.min_v, 2) AS min_group_total,
    ROUND(agg.max_v, 2) AS max_group_total,
    ROUND(agg.mean_v, 2) AS mean_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median_group_total,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 2) AS stddev_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99_group_total
FROM agg;
-- Sample result:
-- n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total
-- 10800 | 11 | 349454 | 1534.6 | 65 | 9200.21 | 22 | 315 | 1817 | 31848

-- [3.6] Distribution shape: total drug cost by specialty x generic drug
-- Purpose: Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total drug cost across all populated specialty x generic drug combinations.
WITH grp AS (
    SELECT Prscrbr_Type, Gnrc_Name, SUM(Tot_Drug_Cst) AS grp_total, COUNT(*) AS grp_rows
    FROM part_d
    GROUP BY Prscrbr_Type, Gnrc_Name
),
ranked AS (
    SELECT grp_total AS v, ROW_NUMBER() OVER (ORDER BY grp_total) AS rn, COUNT(*) OVER () AS n
    FROM grp
),
agg AS (
    SELECT COUNT(*) AS n, MIN(grp_total) AS min_v, MAX(grp_total) AS max_v, AVG(grp_total) AS mean_v,
           SUM(grp_total) AS sum_v, SUM(grp_total * grp_total) AS sumsq_v
    FROM grp
)
SELECT
    agg.n AS n_groups,
    ROUND(agg.min_v, 2) AS min_group_total,
    ROUND(agg.max_v, 2) AS max_group_total,
    ROUND(agg.mean_v, 2) AS mean_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median_group_total,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 2) AS stddev_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99_group_total
FROM agg;
-- Sample result:
-- n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total
-- 10800 | 0 | 54475740.75 | 253468.09 | 4593.12 | 1676537.37 | 772.52 | 41034.38 | 290137.75 | 5163591.75

-- [3.7] Crosstab sample: city x generic drug
-- Purpose: Top 20 city x generic drug combinations by total drug cost, with row count and total claims (sample, not full enumeration).
SELECT
    Prscrbr_City AS dim1,
    Gnrc_Name AS dim2,
    COUNT(*) AS n_rows,
    ROUND(SUM(Tot_Clms), 2) AS total_claims,
    ROUND(SUM(Tot_Drug_Cst), 2) AS total_drug_cost
FROM part_d
GROUP BY Prscrbr_City, Gnrc_Name
ORDER BY total_drug_cost DESC
LIMIT 20;
-- Sample result:
-- dim1 | dim2 | n_rows | total_claims | total_drug_cost
-- Denver | Elexacaftor/Tezacaftor/Ivacaft | 8 | 1047 | 28899560.58
-- Colorado Springs | Apixaban | 379 | 23630 | 26599983.58
-- Aurora | Apixaban | 406 | 25604 | 24994394.78
-- Denver | Apixaban | 448 | 20256 | 19596006.15
-- Littleton | Apixaban | 129 | 15738 | 18655117.56
-- Denver | Nintedanib Esylate | 20 | 1382 | 18139944.16
-- Aurora | Lenalidomide | 10 | 973 | 17930142.16
-- Denver | Lenalidomide | 34 | 1152 | 17020105.49
-- Fort Collins | Apixaban | 164 | 14525 | 16908018.77
-- Aurora | Tafamidis | 5 | 672 | 15770802.81
-- Denver | Empagliflozin | 384 | 15327 | 14326654.74
-- Denver | Semaglutide | 339 | 11748 | 13943238.64
-- Denver | Adalimumab | 57 | 1504 | 12587556.05
-- Colorado Springs | Empagliflozin | 301 | 10824 | 12464103.82
-- Aurora | Bictegrav/Emtricit/Tenofov Ala | 33 | 3170 | 12259964.32
-- Denver | Bictegrav/Emtricit/Tenofov Ala | 38 | 2627 | 11725574.11
-- Colorado Springs | Semaglutide | 255 | 8560 | 11514950.55
-- Lakewood | Apixaban | 132 | 11106 | 11415073.92
-- Aurora | Semaglutide | 242 | 8577 | 11276221.9
-- Denver | Etanercept | 43 | 1517 | 10955793.34

-- [3.8] Distribution shape: total claims by city x generic drug
-- Purpose: Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total claims across all populated city x generic drug combinations.
WITH grp AS (
    SELECT Prscrbr_City, Gnrc_Name, SUM(Tot_Clms) AS grp_total, COUNT(*) AS grp_rows
    FROM part_d
    GROUP BY Prscrbr_City, Gnrc_Name
),
ranked AS (
    SELECT grp_total AS v, ROW_NUMBER() OVER (ORDER BY grp_total) AS rn, COUNT(*) OVER () AS n
    FROM grp
),
agg AS (
    SELECT COUNT(*) AS n, MIN(grp_total) AS min_v, MAX(grp_total) AS max_v, AVG(grp_total) AS mean_v,
           SUM(grp_total) AS sum_v, SUM(grp_total * grp_total) AS sumsq_v
    FROM grp
)
SELECT
    agg.n AS n_groups,
    ROUND(agg.min_v, 2) AS min_group_total,
    ROUND(agg.max_v, 2) AS max_group_total,
    ROUND(agg.mean_v, 2) AS mean_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median_group_total,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 2) AS stddev_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99_group_total
FROM agg;
-- Sample result:
-- n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total
-- 34992 | 11 | 105242 | 473.64 | 55 | 2200.1 | 20 | 207 | 801 | 8078

-- [3.9] Distribution shape: total drug cost by city x generic drug
-- Purpose: Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total drug cost across all populated city x generic drug combinations.
WITH grp AS (
    SELECT Prscrbr_City, Gnrc_Name, SUM(Tot_Drug_Cst) AS grp_total, COUNT(*) AS grp_rows
    FROM part_d
    GROUP BY Prscrbr_City, Gnrc_Name
),
ranked AS (
    SELECT grp_total AS v, ROW_NUMBER() OVER (ORDER BY grp_total) AS rn, COUNT(*) OVER () AS n
    FROM grp
),
agg AS (
    SELECT COUNT(*) AS n, MIN(grp_total) AS min_v, MAX(grp_total) AS max_v, AVG(grp_total) AS mean_v,
           SUM(grp_total) AS sum_v, SUM(grp_total * grp_total) AS sumsq_v
    FROM grp
)
SELECT
    agg.n AS n_groups,
    ROUND(agg.min_v, 2) AS min_group_total,
    ROUND(agg.max_v, 2) AS max_group_total,
    ROUND(agg.mean_v, 2) AS mean_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.50 * agg.n) AS INTEGER)) AS median_group_total,
    ROUND(SQRT((agg.sumsq_v - agg.sum_v * agg.sum_v / agg.n) / (agg.n - 1)), 2) AS stddev_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.25 * agg.n) AS INTEGER)) AS p25_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.75 * agg.n) AS INTEGER)) AS p75_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.90 * agg.n) AS INTEGER)) AS p90_group_total,
    (SELECT v FROM ranked WHERE rn = CAST(ceil(0.99 * agg.n) AS INTEGER)) AS p99_group_total
FROM agg;
-- Sample result:
-- n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total
-- 34992 | 0 | 28899560.58 | 78230.89 | 2663.33 | 554559.43 | 618.31 | 16198.47 | 93608.24 | 1467847.38
