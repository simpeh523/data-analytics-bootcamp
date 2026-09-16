-- Title: SQL Query Report - DAB04272026 Midterm 
-- Database: sqlite3 CAHosp_Staffing.db
-- Dataset: labor_hrs.csv; cost_centers.csv
-- Text Editor: VSCode

-- Table schema as defined in Data Dictionary
CREATE TABLE labor_hrs (
    year INTEGER,
    facility_number INTEGER,
    facility_name TEXT,
    begin_date TEXT,
    end_date TEXT,
    county_name TEXT,
    region TEXT,
    type_of_control TEXT,
    hours_type TEXT,
    productive_hours INTEGER,
    productive_hours_per_adjusted_patient_day REAL,
    phapd_missing TEXT,
    PRIMARY KEY (facility_number, year, hours_type)
);

CREATE TABLE cost_centers (
    year INTEGER,
    facility_number INTEGER,
    facility_name TEXT,
    begin_date TEXT,
    end_date TEXT,
    county_name TEXT,
    region TEXT,
    type_of_control TEXT,
    hours_type TEXT,
    productive_hours INTEGER,
    productive_hours_per_adjusted_patient_day REAL,
    phapd_missing TEXT,
    PRIMARY KEY (facility_number, year, hours_type)
);
.tables

-- Importing data from .csv into labor_hrs and cost_centers tables
.mode csv
.import --skip 1 labor_hrs.csv labor_hrs
.import --skip 1 cost_centers.csv cost_centers

-- Data Integrity Checks
PRAGMA table_info(labor_hrs);
-- Sample: 12 columns confirmed (year, facility_number, facility_name, begin_date, end_date, county_name, region, type_of_control, hours_type, productive_hours, productive_hours_per_adjusted_patient_day, phapd_missing) (12 rows)
PRAGMA table_info(cost_centers);
-- Sample: same 12-column layout as labor_hrs, PK (facility_number, year, hours_type) (12 rows)
PRAGMA integrity_check;
-- Sample: ok (1 row)
SELECT *
FROM labor_hrs
LIMIT 5;
-- Sample: 106010735 | ALAMEDA HOSPITAL | 2009 | Aides & Orderlies | 97205 hrs | 1.79 PHAPD | N
-- ...4 more rows, all Alameda County / Bay Area, District & Non-Profit facilities (5 rows)
SELECT *
FROM cost_centers
LIMIT 5;
-- Sample: 106010735 | ALAMEDA HOSPITAL | 2009 | Administrative Services Cost Centers | 78579 hrs | 1.45 PHAPD | N
-- ...4 more rows, same 5 facilities as labor_hrs LIMIT 5 (5 rows)
SELECT COUNT(*)
FROM labor_hrs
WHERE productive_hours_per_adjusted_patient_day = '';
-- Sample: 10 (10 rows blank PHAPD out of 20,490 total rows)
SELECT COUNT(*)
FROM cost_centers
WHERE productive_hours_per_adjusted_patient_day = '';
-- Sample: 7 (7 rows blank PHAPD out of 14,343 total rows)

-- Data Verification
SELECT COUNT(*)
FROM labor_hrs;
-- Sample: 20,490 (1 row)
SELECT COUNT(*)
FROM cost_centers;
-- Sample: 14,343 (1 row)

SELECT
    MIN(year),
    MAX(year),
    COUNT(DISTINCT year)
FROM labor_hrs;
-- Sample: 2009 | 2013 | 5 (1 row)
SELECT
    MIN(year),
    MAX(year),
    COUNT(DISTINCT year)
FROM cost_centers;
-- Sample: 2009 | 2013 | 5 (1 row)

SELECT
    year,
    COUNT(DISTINCT facility_number) AS facility_count,
    COUNT(hours_type) AS total_hours_types
FROM labor_hrs
GROUP BY year
ORDER BY year;
-- Sample: 2009 | 410 | 4,100
-- 2010 | 409 | 4,090
-- 2011 | 414 | 4,140
-- 2012 | 414 | 4,140
-- 2013 | 402 | 4,020 (5 rows)
SELECT
    year,
    COUNT(DISTINCT facility_number) AS facility_count,
    COUNT(hours_type) AS total_hours_types
FROM cost_centers
GROUP BY year
ORDER BY year;
-- Sample: 2009 | 410 | 2,870
-- 2010 | 409 | 2,863
-- 2011 | 414 | 2,898
-- 2012 | 414 | 2,898
-- 2013 | 402 | 2,814 (5 rows)

SELECT
    facility_name,
    COUNT(DISTINCT facility_number) AS num_facility_numbers
FROM labor_hrs
GROUP BY facility_name
HAVING COUNT(DISTINCT facility_number) > 1;
-- Sample: 0 rows (no facility_name maps to more than one facility_number)
SELECT
    facility_name,
    COUNT(DISTINCT facility_number) AS num_facility_numbers
FROM cost_centers
GROUP BY facility_name
HAVING COUNT(DISTINCT facility_number) > 1;
-- Sample: 0 rows (no facility_name maps to more than one facility_number)

SELECT
    facility_number,
    year,
    begin_date,
    end_date,
    CAST(julianday(
        substr(end_date,-4)||'-'||
        substr('00'||substr(end_date,1,instr(end_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(end_date,instr(end_date,'/')+1),1,
          instr(substr(end_date,instr(end_date,'/')+1),'/')-1),-2)
      ) - julianday(
        substr(begin_date,-4)||'-'||
        substr('00'||substr(begin_date,1,instr(begin_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(begin_date,instr(begin_date,'/')+1),1,
          instr(substr(begin_date,instr(begin_date,'/')+1),'/')-1),-2)
      ) AS INTEGER) + 1 AS reporting_days
FROM labor_hrs
WHERE CAST(julianday(
        substr(end_date,-4)||'-'||
        substr('00'||substr(end_date,1,instr(end_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(end_date,instr(end_date,'/')+1),1,
          instr(substr(end_date,instr(end_date,'/')+1),'/')-1),-2)
      ) - julianday(
        substr(begin_date,-4)||'-'||
        substr('00'||substr(begin_date,1,instr(begin_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(begin_date,instr(begin_date,'/')+1),1,
          instr(substr(begin_date,instr(begin_date,'/')+1),'/')-1),-2)
      ) AS INTEGER) + 1 NOT BETWEEN 364 AND 366;
-- Sample: 0 rows (all reporting periods fall within 364-366 days; validated pass)
SELECT
    facility_number,
    year,
    begin_date,
    end_date,
    CAST(julianday(
        substr(end_date,-4)||'-'||
        substr('00'||substr(end_date,1,instr(end_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(end_date,instr(end_date,'/')+1),1,
          instr(substr(end_date,instr(end_date,'/')+1),'/')-1),-2)
      ) - julianday(
        substr(begin_date,-4)||'-'||
        substr('00'||substr(begin_date,1,instr(begin_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(begin_date,instr(begin_date,'/')+1),1,
          instr(substr(begin_date,instr(begin_date,'/')+1),'/')-1),-2)
      ) AS INTEGER) + 1 AS reporting_days
FROM cost_centers
WHERE CAST(julianday(
        substr(end_date,-4)||'-'||
        substr('00'||substr(end_date,1,instr(end_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(end_date,instr(end_date,'/')+1),1,
          instr(substr(end_date,instr(end_date,'/')+1),'/')-1),-2)
      ) - julianday(
        substr(begin_date,-4)||'-'||
        substr('00'||substr(begin_date,1,instr(begin_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(begin_date,instr(begin_date,'/')+1),1,
          instr(substr(begin_date,instr(begin_date,'/')+1),'/')-1),-2)
      ) AS INTEGER) + 1 NOT BETWEEN 364 AND 366;
-- Sample: 0 rows (all reporting periods fall within 364-366 days; validated pass)

SELECT
    county_name,
    COUNT(DISTINCT region) AS num_regions
FROM labor_hrs
GROUP BY county_name
HAVING COUNT(DISTINCT region) <> 1;
-- Sample: 0 rows (every county maps to exactly one region)
SELECT
    county_name,
    COUNT(DISTINCT region) AS num_regions
FROM cost_centers
GROUP BY county_name
HAVING COUNT(DISTINCT region) <> 1;
-- Sample: 0 rows (every county maps to exactly one region)

SELECT
    region,
    COUNT(DISTINCT county_name) AS num_counties
FROM labor_hrs
GROUP BY region
ORDER BY region;
-- Sample: Bay Area | 11
-- Central Coast | 3
-- Central Sierra | 6
-- Greater Sacramento | 6
-- Northern California | 10
-- Northern Sacramento Valley | 5
-- San Joaquin Valley | 8
-- Southern Border | 2
-- Southern California | 5 (9 rows)
SELECT
    region,
    COUNT(DISTINCT county_name) AS num_counties
FROM cost_centers
GROUP BY region
ORDER BY region;
-- Sample: identical to labor_hrs region/county breakdown above (9 rows)

SELECT
    type_of_control,
    COUNT(*) AS row_count,
    COUNT(DISTINCT facility_number) AS facility_count
FROM labor_hrs
GROUP BY type_of_control
ORDER BY type_of_control;
-- Sample: City/County | 1,060 | 24
-- District | 2,160 | 47
-- Investor | 6,060 | 137
-- Non-Profit | 11,210 | 236 (4 rows)
SELECT
    type_of_control,
    COUNT(*) AS row_count,
    COUNT(DISTINCT facility_number) AS facility_count
FROM cost_centers
GROUP BY type_of_control
ORDER BY type_of_control;
-- Sample: City/County | 742 | 24
-- District | 1,512 | 47
-- Investor | 4,242 | 137
-- Non-Profit | 7,847 | 236 (4 rows)

SELECT COUNT(DISTINCT hours_type)
FROM labor_hrs;
-- Sample: 10 (1 row)
SELECT COUNT(DISTINCT hours_type)
FROM cost_centers;
-- Sample: 7 (1 row)

SELECT
    hours_type,
    COUNT(*)
FROM labor_hrs
GROUP BY hours_type
ORDER BY hours_type;
-- Sample: Aides & Orderlies | 2,049
-- Clerical & Other Administrative | 2,049
-- Contracted Other | 2,049
-- Contracted Registry Nursing | 2,049
-- Environmental & Food Services | 2,049
-- ...5 more hours_types, all 2,049 rows each (10 rows)
SELECT
    hours_type,
    COUNT(*)
FROM cost_centers
GROUP BY hours_type
ORDER BY hours_type;
-- Sample: Administrative Services Cost Centers | 2,049
-- Ambulatory Cost Centers | 2,049
-- Ancillary Cost Centers | 2,049
-- Daily Cost Centers | 2,049
-- Education Cost Centers | 2,049
-- ...2 more hours_types, all 2,049 rows each (7 rows)

SELECT
    MIN(productive_hours),
    MAX(productive_hours),
    MIN(productive_hours_per_adjusted_patient_day),
    MAX(productive_hours_per_adjusted_patient_day)
FROM labor_hrs
WHERE phapd_missing = "N";
-- Sample: 0 | 11,310,724 | 0.0 | 106.13 (1 row)
SELECT
    MIN(productive_hours),
    MAX(productive_hours),
    MIN(productive_hours_per_adjusted_patient_day),
    MAX(productive_hours_per_adjusted_patient_day)
FROM cost_centers
WHERE phapd_missing = "N";
-- Sample: 0 | 11,419,982 | 0.0 | 75.01 (1 row)

SELECT *
FROM labor_hrs
WHERE phapd_missing = "N" AND productive_hours_per_adjusted_patient_day = '';
-- Sample: 0 rows (no violations found — no row is flagged "N" with a blank PHAPD)
SELECT *
FROM cost_centers
WHERE phapd_missing = "N" AND productive_hours_per_adjusted_patient_day = '';
-- Sample: 0 rows (no violations found — no row is flagged "N" with a blank PHAPD)

SELECT *
FROM labor_hrs
WHERE phapd_missing = "Y" AND productive_hours_per_adjusted_patient_day != '';
-- Sample: 0 rows (no violations found — no row flagged "Y" carries a non-blank PHAPD value)
SELECT *
FROM cost_centers
WHERE phapd_missing = "Y" AND productive_hours_per_adjusted_patient_day != '';
-- Sample: 0 rows (no violations found — no row flagged "Y" carries a non-blank PHAPD value)


-- Exploratory Query Analysis
-- facility count by clinical-type keyword
WITH facilities AS (
    SELECT DISTINCT facility_number, facility_name FROM labor_hrs
)
SELECT
    SUM(CASE WHEN facility_name LIKE '%PSYCH%' OR facility_name LIKE '%BEHAVIORAL%' THEN 1 ELSE 0 END) AS psych_behavioral,
    SUM(CASE WHEN facility_name LIKE '%REHAB%' THEN 1 ELSE 0 END) AS rehab,
    SUM(CASE WHEN facility_name LIKE '%CHILDREN%' THEN 1 ELSE 0 END) AS childrens,
    SUM(CASE WHEN facility_name LIKE '%SURGICAL%' THEN 1 ELSE 0 END) AS surgical,
    SUM(CASE WHEN facility_name LIKE '%RECOVERY%' THEN 1 ELSE 0 END) AS recovery
FROM facilities;
-- Sample: 22/10/10/6/5 of 430 facilities (psych_behavioral/rehab/childrens/surgical/recovery), not mutually exclusive (1 row)

-- facility count by health-system keyword
WITH facilities AS (
    SELECT DISTINCT facility_number, facility_name FROM labor_hrs
)
SELECT
    SUM(CASE WHEN facility_name LIKE '%KAISER%' THEN 1 ELSE 0 END) AS kaiser,
    SUM(CASE WHEN facility_name LIKE 'ST.%' OR facility_name LIKE '%SAINT%' THEN 1 ELSE 0 END) AS st_saint,
    SUM(CASE WHEN facility_name LIKE '%SUTTER%' THEN 1 ELSE 0 END) AS sutter,
    SUM(CASE WHEN facility_name LIKE '%KINDRED%' THEN 1 ELSE 0 END) AS kindred,
    SUM(CASE WHEN facility_name LIKE '%SHARP%' THEN 1 ELSE 0 END) AS sharp,
    SUM(CASE WHEN facility_name LIKE '%PROVIDENCE%' THEN 1 ELSE 0 END) AS providence,
    SUM(CASE WHEN facility_name LIKE '%AURORA%' THEN 1 ELSE 0 END) AS aurora,
    SUM(CASE WHEN facility_name LIKE '%CRESTWOOD%' THEN 1 ELSE 0 END) AS crestwood,
    SUM(CASE WHEN facility_name LIKE '%TELECARE%' THEN 1 ELSE 0 END) AS telecare,
    SUM(CASE WHEN facility_name LIKE '%SCRIPPS%' THEN 1 ELSE 0 END) AS scripps,
    SUM(CASE WHEN facility_name LIKE '%ADVENTIST%' THEN 1 ELSE 0 END) AS adventist,
    SUM(CASE WHEN facility_name LIKE '%WESTERN MEDICAL CENTER%' THEN 1 ELSE 0 END) AS western_medical_center
FROM facilities;
-- Sample: 32/23/14/9/6/5/5/5/4/4/3/2 of 430 facilities (kaiser/st_saint/sutter/kindred/sharp/providence/
-- aurora/crestwood/telecare/scripps/adventist/western_medical_center), not mutually exclusive (1 row)

-- begin_date month distribution, facility-year deduped
WITH facility_year AS (
    SELECT DISTINCT facility_number, year, begin_date FROM labor_hrs
)
SELECT
    CAST(substr(
        substr(begin_date,-4)||'-'||
        substr('00'||substr(begin_date,1,instr(begin_date,'/')-1),-2)||'-'||
        substr('00'||substr(substr(begin_date,instr(begin_date,'/')+1),1,
          instr(substr(begin_date,instr(begin_date,'/')+1),'/')-1),-2)
      ,6,2) AS INTEGER) AS begin_month,
    COUNT(*) AS facility_year_count
FROM facility_year
GROUP BY begin_month
ORDER BY facility_year_count DESC;
-- Sample: January 1,044 | July 786 | October 117 | September 59 | November 10
-- April 10 | February 8 | December 5 | June 5 | May 5 (10 rows); bimodal, dominated by January/July starts

-- county frequency + % share
WITH county_counts AS (
    SELECT county_name, COUNT(*) AS row_count FROM labor_hrs GROUP BY county_name
)
SELECT
    county_name,
    row_count,
    ROUND(100.0 * row_count / SUM(row_count) OVER (), 1) AS pct_of_total
FROM county_counts
ORDER BY row_count DESC;
-- Sample: Los Angeles | 5,260 | 25.7%
-- Orange | 1,520 | 7.4%
-- San Diego | 1,280 | 6.2%
-- San Bernardino | 1,040 | 5.1%
-- Riverside | 900 | 4.4%
-- ...51 more counties, share highly skewed to LA at 25.7%; only 4 counties above 5% (56 rows)

-- zero-productive_hours by hours_type for labor_hrs table
SELECT
    hours_type,
    COUNT(*) AS zero_hour_rows,
    COUNT(DISTINCT facility_number) AS facility_count
FROM labor_hrs
WHERE productive_hours = 0
GROUP BY hours_type
ORDER BY zero_hour_rows DESC;
-- Sample: Other | 477 | 164
-- Contracted Other | 473 | 174
-- Contracted Registry Nursing | 345 | 124
-- Environmental & Food Services | 296 | 86
-- Clerical & Other Administrative | 173 | 42
-- ...5 more hours_types (10 rows); totals 2,269 rows (11.1%), 305 facilities

-- zero-productive_hours by hours_type for cost_centers table
SELECT
    hours_type,
    COUNT(*) AS zero_hour_rows,
    COUNT(DISTINCT facility_number) AS facility_count
FROM cost_centers
WHERE productive_hours = 0
GROUP BY hours_type
ORDER BY zero_hour_rows DESC;
-- Sample: Education Cost Centers | 1,533 | 344
-- Ambulatory Cost Centers | 235 | 72
-- Ancillary Cost Centers | 161 | 40
-- Fiscal Services Cost Centers | 120 | 49
-- General Services Cost Centers | 13 | 3
-- ...2 more hours_types (7 rows); totals 2,074 rows (14.5%), 354 facilities, ~74% in Education Cost Centers

-- type_of_control vs avg PHAPD for labor_hrs
SELECT
    type_of_control,
    ROUND(AVG(productive_hours_per_adjusted_patient_day), 2) AS avg_phapd_row_level,
    COUNT(*) AS row_count
FROM labor_hrs
WHERE phapd_missing = "N"
GROUP BY type_of_control
ORDER BY avg_phapd_row_level DESC;
-- Sample: Non-Profit | 3.17 | 11,200
-- City/County | 2.87 | 1,060
-- Investor | 2.34 | 6,060
-- District | 2.22 | 2,160 (4 rows); row-level only

-- type_of_control vs avg PHAPD for cost_centers
SELECT
    type_of_control,
    ROUND(AVG(productive_hours_per_adjusted_patient_day), 2) AS avg_phapd_row_level,
    COUNT(*) AS row_count
FROM cost_centers
WHERE phapd_missing = "N"
GROUP BY type_of_control
ORDER BY avg_phapd_row_level DESC;
-- Sample: Non-Profit | 4.46 | 7,840
-- City/County | 4.09 | 742
-- Investor | 3.34 | 4,242
-- District | 3.17 | 1,512 (4 rows); same ownership ranking as labor_hrs

-- productive_hours vs PHAPD correlation for labor_hrs
WITH stats AS (
    SELECT
        AVG(productive_hours) AS mx, AVG(productive_hours_per_adjusted_patient_day) AS my,
        AVG(productive_hours * productive_hours_per_adjusted_patient_day) AS mxy,
        AVG(productive_hours * 1.0 * productive_hours) AS mx2,
        AVG(productive_hours_per_adjusted_patient_day * productive_hours_per_adjusted_patient_day) AS my2
    FROM labor_hrs WHERE phapd_missing = "N"
)
SELECT ROUND((mxy - mx*my) / (SQRT(mx2 - mx*mx) * SQRT(my2 - my*my)), 3) AS pearson_r FROM stats;
-- SQLite no built-in correlation function, so (mxy - mx*my) / (SQRT(mx2 - mx*mx) * SQRT(my2 - my*my)) is formula workaround I found
-- Sample: r = 0.615 (1 row); hypothesis only, confounded by facility size/hours_type mix

-- productive_hours vs PHAPD correlation from cost_centers
WITH stats AS (
    SELECT
        AVG(productive_hours) AS mx, AVG(productive_hours_per_adjusted_patient_day) AS my,
        AVG(productive_hours * productive_hours_per_adjusted_patient_day) AS mxy,
        AVG(productive_hours * 1.0 * productive_hours) AS mx2,
        AVG(productive_hours_per_adjusted_patient_day * productive_hours_per_adjusted_patient_day) AS my2
    FROM cost_centers WHERE phapd_missing = "N"
)
SELECT ROUND((mxy - mx*my) / (SQRT(mx2 - mx*mx) * SQRT(my2 - my*my)), 3) AS pearson_r FROM stats;
-- Sample: r = 0.546 (1 row); coarser grouping than labor_hrs given 7 hours_types, therefore not directly comparable to labor_hrs correlation

-- who-vs-where reconciliation match rate
WITH labor_totals AS (
    SELECT facility_number, year, SUM(productive_hours) AS labor_total_hours
    FROM labor_hrs GROUP BY facility_number, year
),
cost_totals AS (
    SELECT facility_number, year, SUM(productive_hours) AS cost_total_hours
    FROM cost_centers GROUP BY facility_number, year
),
reconciled AS (
    SELECT l.facility_number, l.year,
        ROUND(100.0 * (l.labor_total_hours - c.cost_total_hours) / NULLIF(l.labor_total_hours, 0), 2) AS pct_diff
    FROM labor_totals l JOIN cost_totals c ON l.facility_number = c.facility_number AND l.year = c.year
)
SELECT
    SUM(CASE WHEN ABS(pct_diff) <= 1 THEN 1 ELSE 0 END) AS match_within_1pct,
    SUM(CASE WHEN ABS(pct_diff) > 1 THEN 1 ELSE 0 END) AS diverge_over_1pct,
    SUM(CASE WHEN ABS(pct_diff) > 5 THEN 1 ELSE 0 END) AS diverge_over_5pct,
    COUNT(*) AS total_facility_years
FROM reconciled;
-- Sample: match_within_1pct 1,914 | diverge_over_1pct 135 | diverge_over_5pct 30 | total_facility_years 2,049 (1 row)
-- i.e. 1,914/2,049 (93%) within 1%, 135 (6.6%) diverge >1%, 30 (1.5%) diverge >5%

-- direction of the >5% divergences
WITH labor_totals AS (
    SELECT facility_number, year, SUM(productive_hours) AS labor_total_hours
    FROM labor_hrs GROUP BY facility_number, year
),
cost_totals AS (
    SELECT facility_number, year, SUM(productive_hours) AS cost_total_hours
    FROM cost_centers GROUP BY facility_number, year
),
reconciled AS (
    SELECT l.facility_number, l.year,
        ROUND(100.0 * (l.labor_total_hours - c.cost_total_hours) / NULLIF(l.labor_total_hours, 0), 2) AS pct_diff
    FROM labor_totals l JOIN cost_totals c ON l.facility_number = c.facility_number AND l.year = c.year
)
SELECT
    SUM(CASE WHEN pct_diff > 5 THEN 1 ELSE 0 END) AS labor_higher,
    SUM(CASE WHEN pct_diff < -5 THEN 1 ELSE 0 END) AS cost_higher
FROM reconciled
WHERE ABS(pct_diff) > 5;
-- Sample: labor_higher 30 | cost_higher 0 (1 row); all 30 go one direction, labor_total_hours > cost_total_hours, zero the other way


-- Business Query Analysis
/*
==========================================================================================================
BQ1 - How much labor does the average California hospital use, and did that change between 2009 and 2013?
==========================================================================================================
*/
-- Average productive hours per facility by year, labor_hrs
WITH labor_totals AS (
    SELECT year, SUM(productive_hours) AS total_hours
    FROM labor_hrs
    GROUP BY year
)
SELECT
    year,
    total_hours,
    ROUND(total_hours / (SELECT COUNT(DISTINCT facility_number) FROM labor_hrs WHERE year = l.year), 2) AS avg_hours_per_facility
FROM labor_totals l
ORDER BY year;
-- Sample: 2009 | 794,852,610 | 1,938,664.90
-- 2010 | 782,702,384 | 1,913,697.76
-- 2011 | 791,742,657 | 1,912,421.88
-- 2012 | 791,049,408 | 1,910,747.36
-- 2013 | 784,656,474 | 1,951,881.78 (5 rows)
-- Average productive hours per adjusted patient day per facility by year, labor_hrs
WITH labor_totals AS (
    SELECT year, SUM(productive_hours_per_adjusted_patient_day) AS total_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY year
)
SELECT
    year,
    total_phapd,
    ROUND(total_phapd / (SELECT COUNT(DISTINCT facility_number) FROM labor_hrs WHERE year = l.year AND phapd_missing = "N"), 2) AS avg_phapd_per_facility
FROM labor_totals l
ORDER BY year;
-- Sample: 2009 | 11,610.51 | 28.32
-- 2010 | 11,182.02 | 27.34
-- 2011 | 11,609.52 | 28.04
-- 2012 | 11,697.93 | 28.32
-- 2013 | 11,401.91 | 28.36 (5 rows)

-- YoY % change in avg productive hours per facility, labor_hrs
WITH labor_totals AS (
    SELECT year, SUM(productive_hours) AS total_hours
    FROM labor_hrs
    GROUP BY year
),
avg_by_year AS (
    SELECT
        year,
        ROUND(total_hours * 1.0 / (SELECT COUNT(DISTINCT facility_number) FROM labor_hrs WHERE year = labor_totals.year), 2) AS avg_hours_per_facility
    FROM labor_totals
)
SELECT
    year,
    avg_hours_per_facility,
    ROUND(100.0 * (avg_hours_per_facility - LAG(avg_hours_per_facility) OVER (ORDER BY year))  -- LAG() is window function to get previous row's value
          / LAG(avg_hours_per_facility) OVER (ORDER BY year), 2) AS yoy_pct_change
FROM avg_by_year
ORDER BY year;
-- Sample: 2009 | 1,938,664.90 | (blank, no prior year)
-- 2010 | 1,913,697.76 | -1.29
-- 2011 | 1,912,421.88 | -0.07
-- 2012 | 1,910,747.36 | -0.09
-- 2013 | 1,951,881.78 | 2.15 (5 rows)
-- YoY % change in avg PHAPD per facility, labor_hrs
WITH labor_totals AS (
    SELECT year, SUM(productive_hours_per_adjusted_patient_day) AS total_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY year
),
avg_by_year AS (
    SELECT
        year,
        ROUND(total_phapd / (SELECT COUNT(DISTINCT facility_number) FROM labor_hrs WHERE year = labor_totals.year AND phapd_missing = "N"), 2) AS avg_phapd_per_facility
    FROM labor_totals
)
SELECT
    year,
    avg_phapd_per_facility,
    ROUND(100.0 * (avg_phapd_per_facility - LAG(avg_phapd_per_facility) OVER (ORDER BY year))
          / LAG(avg_phapd_per_facility) OVER (ORDER BY year), 2) AS yoy_pct_change
FROM avg_by_year
ORDER BY year;
-- Sample: 2009 | 28.32 | (blank, no prior year)
-- 2010 | 27.34 | -3.46
-- 2011 | 28.04 | 2.56
-- 2012 | 28.32 | 1.0
-- 2013 | 28.36 | 0.14 (5 rows)

-- Dispersion of facility productive hours by year measured by standard deviation and coefficient of variation, labor_hrs
WITH facility_year_hours AS (
    SELECT year, facility_number, SUM(productive_hours) AS fac_hours
    FROM labor_hrs
    GROUP BY year, facility_number
),
stats AS (
    SELECT
        year,
        AVG(fac_hours) AS mean_hours,
        AVG(fac_hours * 1.0 * fac_hours) - (AVG(fac_hours * 1.0) * AVG(fac_hours * 1.0)) AS variance -- variance = E[X^2] - (E[X])^2; replace fac_hours with X
    FROM facility_year_hours
    GROUP BY year
)
SELECT
    year,
    ROUND(mean_hours, 2) AS mean_hours,
    ROUND(SQRT(variance), 2) AS sd_hours,
    ROUND(100.0 * SQRT(variance) / mean_hours, 2) AS cv_pct
FROM stats
ORDER BY year;
-- Sample: 2009 | 1,938,664.90 | 2,295,697.62 | 118.42
-- 2010 | 1,913,697.76 | 2,273,699.11 | 118.81
-- 2011 | 1,912,421.88 | 2,328,772.86 | 121.77
-- 2012 | 1,910,747.36 | 2,366,608.08 | 123.86
-- 2013 | 1,951,881.78 | 2,490,228.71 | 127.58 (5 rows)
-- Dispersion of facility productive hours per adjusted patient day by year measured by standard deviation and coefficient of variation, labor_hrs
WITH facility_year_phapd AS (
    SELECT year, facility_number, SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY year, facility_number
),
stats AS (
    SELECT
        year,
        AVG(fac_phapd) AS mean_phapd,
        AVG(fac_phapd * 1.0 * fac_phapd) - (AVG(fac_phapd * 1.0) * AVG(fac_phapd * 1.0)) AS variance
    FROM facility_year_phapd
    GROUP BY year
)
SELECT
    year,
    ROUND(mean_phapd, 2) AS mean_phapd,
    ROUND(SQRT(variance), 2) AS sd_phapd,
    ROUND(100.0 * SQRT(variance) / mean_phapd, 2) AS cv_pct
FROM stats
ORDER BY year;
-- Sample: 2009 | 28.32 | 15.77 | 55.68
-- 2010 | 27.34 | 12.87 | 47.09
-- 2011 | 28.04 | 14.03 | 50.04
-- 2012 | 28.32 | 14.56 | 51.39
-- 2013 | 28.36 | 15.88 | 55.98 (5 rows)


/*
=======================================================================================================================================================
BQ2 - Which regions of California consistently staff above or below the statewide average, and how large is the gap?
=======================================================================================================================================================
*/
-- H1a: region avg facility productive_hours vs statewide average, ranked
WITH facility_stats AS (
    SELECT
        facility_number,
        year,
        region,
        SUM(productive_hours) AS fac_hours
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY facility_number, year, region
),
region_avg AS (
    SELECT
        region,
        AVG(fac_hours) AS region_hours
    FROM facility_stats
    GROUP BY region
)
SELECT
    region,
    ROUND(region_hours, 0) AS region_hours,
    ROUND(AVG(region_hours) OVER (), 0) AS statewide_hours,
    ROUND(region_hours - AVG(region_hours) OVER (), 0) AS gap,
    RANK() OVER (ORDER BY region_hours DESC) AS rank_desc
FROM region_avg
ORDER BY region_hours DESC;
-- Sample: Southern Border | 2,439,313 | 1,583,117 | 856,196 | 1
-- Bay Area | 2,177,980 | 1,583,117 | 594,863 | 2
-- Greater Sacramento | 2,112,007 | 1,583,117 | 528,889 | 3
-- Southern California | 2,056,997 | 1,583,117 | 473,879 | 4
-- San Joaquin Valley | 1,765,813 | 1,583,117 | 182,695 | 5
-- ...4 more regions (9 rows)
-- Note: the statewide reference here is the unweighted mean of the 9 region means (28.94 PHAPD),
--   not the facility-level statewide mean (28.08) used in the Excel pivots. Ranking is identical;
--   gap magnitudes differ by ~0.9.
-- H1b: region avg facility PHAPD vs statewide average, ranked
WITH facility_stats AS (
    SELECT
        facility_number,
        year,
        region,
        SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY facility_number, year, region
),
region_avg AS (
    SELECT
        region,
        AVG(fac_phapd) AS region_phapd
    FROM facility_stats
    GROUP BY region
)
SELECT
    region,
    ROUND(region_phapd, 2) AS region_phapd,
    ROUND(AVG(region_phapd) OVER (), 2) AS statewide_phapd,
    ROUND(region_phapd - AVG(region_phapd) OVER (), 2) AS gap,
    RANK() OVER (ORDER BY region_phapd DESC) AS rank_desc
FROM region_avg
ORDER BY region_phapd DESC;
-- Sample: Central Sierra | 38.74 | 28.94 | 9.81 | 1
-- Bay Area | 31.0 | 28.94 | 2.06 | 2
-- Northern Sacramento Valley | 29.6 | 28.94 | 0.66 | 3
-- San Joaquin Valley | 28.5 | 28.94 | -0.44 | 4
-- Greater Sacramento | 27.3 | 28.94 | -1.63 | 5
-- ...4 more regions (9 rows)
-- Note: the statewide reference here is the unweighted mean of the 9 region means (28.94 PHAPD),
--   not the facility-level statewide mean (28.08) used in the Excel pivots. Ranking is identical;
--   gap magnitudes differ by ~0.9.

-- H2a: region avg facility productive_hours by year, vs that year's statewide average
WITH facility_stats AS (
    SELECT
        facility_number,
        year,
        region,
        SUM(productive_hours) AS fac_hours
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY facility_number, year, region
),
region_year AS (
    SELECT
        region,
        year,
        AVG(fac_hours) AS region_hours
    FROM facility_stats
    GROUP BY region, year
),
region_year_flagged AS (
    SELECT
        region,
        year,
        ROUND(region_hours, 0) AS region_hours,
        ROUND(AVG(region_hours) OVER (PARTITION BY year), 0) AS statewide_hours_that_year,  -- PARTITION ensures average calculated separately for each year
        CASE WHEN region_hours > AVG(region_hours) OVER (PARTITION BY year) THEN 1 ELSE 0 END AS above_statewide 
    FROM region_year
)
SELECT
    region,
    SUM(above_statewide) AS years_above_statewide
FROM region_year_flagged
GROUP BY region
ORDER BY years_above_statewide DESC;
-- Sample: Southern California | 5
-- Southern Border | 5
-- San Joaquin Valley | 5
-- Greater Sacramento | 5
-- Bay Area | 5
-- Northern Sacramento Valley | 0
-- Northern California | 0
-- Central Sierra | 0
-- Central Coast | 0 (9 rows)
-- H2b: region avg facility PHAPD by year, vs that year's statewide average
WITH facility_stats AS (
    SELECT
        facility_number,
        year,
        region,
        SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
    GROUP BY facility_number, year, region
),
region_year AS (
    SELECT
        region,
        year,
        AVG(fac_phapd) AS region_phapd
    FROM facility_stats
    GROUP BY region, year
),
region_year_flagged AS (
    SELECT
        region,
        year,
        ROUND(region_phapd, 2) AS region_phapd,
        ROUND(AVG(region_phapd) OVER (PARTITION BY year), 2) AS statewide_phapd_that_year,
        CASE WHEN region_phapd > AVG(region_phapd) OVER (PARTITION BY year) THEN 1 ELSE 0 END AS above_statewide
    FROM region_year
)
SELECT
    region,
    SUM(above_statewide) AS years_above_statewide
FROM region_year_flagged
GROUP BY region
ORDER BY years_above_statewide DESC;
-- Sample: Central Sierra | 5
-- Bay Area | 5
-- Northern Sacramento Valley | 4
-- San Joaquin Valley | 1
-- Greater Sacramento | 1
-- Southern California | 0
-- Southern Border | 0
-- Northern California | 0
-- Central Coast | 0 (9 rows)
/*
=======================================================================================================================================================
BQ3 - Do California's highest- and lowest-volume regions employ different kinds of workers, or the same workers in different parts of the hospital?
=======================================================================================================================================================
*/
-- BQ3.H1 - labor_hrs: tier x hours_type % share ("who")
WITH tiered AS (
    SELECT *,
        CASE region
            WHEN 'Southern Border' THEN 'High'
            WHEN 'Bay Area' THEN 'High'
            WHEN 'Greater Sacramento' THEN 'High'
            WHEN 'Southern California' THEN 'Medium'
            WHEN 'San Joaquin Valley' THEN 'Medium'
            WHEN 'Central Coast' THEN 'Medium'
            WHEN 'Northern Sacramento Valley' THEN 'Low'
            WHEN 'Northern California' THEN 'Low'
            WHEN 'Central Sierra' THEN 'Low'
        END AS tier
    FROM labor_hrs
),
tier_hours AS (
    SELECT tier, hours_type, SUM(productive_hours) AS hours_sum
    FROM tiered
    GROUP BY tier, hours_type
)
SELECT
    tier,
    hours_type,
    hours_sum,
    ROUND(100.0 * hours_sum / SUM(hours_sum) OVER (PARTITION BY tier), 2) AS pct_of_tier
FROM tier_hours
ORDER BY
    CASE tier WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Low' THEN 3 END,  -- custom sort for tier
    pct_of_tier DESC;
-- Sample: High | Registered Nurse | 399,392,707 | 28.16
-- High | Technician & Specialist | 297,938,762 | 21.0
-- High | Other | 197,178,907 | 13.9
-- High | Clerical & Other Administrative | 192,019,558 | 13.54
-- High | Management & Supervision | 102,965,376 | 7.26
-- Medium | Registered Nurse | 664,696,637 | 27.97
-- Medium | Technician & Specialist | 507,296,028 | 21.35
-- Low | Registered Nurse | 35,708,528 | 23.76
-- ...22 more rows across all 3 tiers x 10 hours_types (30 rows)

-- BQ3.H2 - cost_centers: tier x hours_type % share ("where")
WITH tiered AS (
    SELECT *,
        CASE region
            WHEN 'Southern Border' THEN 'High'
            WHEN 'Bay Area' THEN 'High'
            WHEN 'Greater Sacramento' THEN 'High'
            WHEN 'Southern California' THEN 'Medium'
            WHEN 'San Joaquin Valley' THEN 'Medium'
            WHEN 'Central Coast' THEN 'Medium'
            WHEN 'Northern Sacramento Valley' THEN 'Low'
            WHEN 'Northern California' THEN 'Low'
            WHEN 'Central Sierra' THEN 'Low'
        END AS tier
    FROM cost_centers
),
tier_hours AS (
    SELECT tier, hours_type, SUM(productive_hours) AS hours_sum
    FROM tiered
    GROUP BY tier, hours_type
)
SELECT
    tier,
    hours_type,
    hours_sum,
    ROUND(100.0 * hours_sum / SUM(hours_sum) OVER (PARTITION BY tier), 2) AS pct_of_tier
FROM tier_hours
ORDER BY
    CASE tier WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Low' THEN 3 END,
    pct_of_tier DESC;
-- Sample: High | Daily Cost Centers | 425,009,107 | 30.1
-- High | Ancillary Cost Centers | 318,283,427 | 22.54
-- High | General Services Cost Centers | 252,414,046 | 17.88
-- Medium | Daily Cost Centers | 749,407,217 | 31.74
-- Medium | Ancillary Cost Centers | 546,118,608 | 23.13
-- Low | Ancillary Cost Centers | 36,175,542 | 24.18
-- Low | Daily Cost Centers | 34,433,058 | 23.02
-- ...14 more rows across all 3 tiers x 7 hours_types (21 rows)
-- BQ3.H2-PHAPD - cost_centers: tier x hours_type, sum of facility-year PHAPD ("where", intensity view)
WITH tiered AS (
    SELECT *,
        CASE region
            WHEN 'Southern Border' THEN 'High'
            WHEN 'Bay Area' THEN 'High'
            WHEN 'Greater Sacramento' THEN 'High'
            WHEN 'Southern California' THEN 'Medium'
            WHEN 'San Joaquin Valley' THEN 'Medium'
            WHEN 'Central Coast' THEN 'Medium'
            WHEN 'Northern Sacramento Valley' THEN 'Low'
            WHEN 'Northern California' THEN 'Low'
            WHEN 'Central Sierra' THEN 'Low'
        END AS tier
    FROM cost_centers
    WHERE phapd_missing = "N"
),
tier_phapd AS (
    SELECT tier, hours_type, ROUND(SUM(productive_hours_per_adjusted_patient_day), 2) AS phapd_sum
    FROM tiered
    GROUP BY tier, hours_type
)
SELECT
    tier,
    hours_type,
    phapd_sum,
    ROUND(100.0 * phapd_sum / SUM(phapd_sum) OVER (PARTITION BY tier), 2) AS pct_of_tier
FROM tier_phapd
ORDER BY
    CASE tier WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Low' THEN 3 END,
    pct_of_tier DESC;
-- Sample: High | Daily Cost Centers | 5,858.71 | 31.83
-- High | Ancillary Cost Centers | 3,923.17 | 21.31
-- High | General Services Cost Centers | 3,454.10 | 18.76
-- Medium | Daily Cost Centers | 10,940.99 | 33.67
-- Medium | Ancillary Cost Centers | 7,108.00 | 21.88
-- Low | Ancillary Cost Centers | 1,481.78 | 24.34
-- Low | Daily Cost Centers | 1,184.94 | 19.46
-- ...14 more rows across all 3 tiers x 7 hours_types (21 rows)


/*
==========================================================================================================
BQ4 - Do larger California hospitals use more labor hours per patient day than smaller ones?
==========================================================================================================
*/
-- Q4.1: facility-year hours quartiles vs avg PHAPD
WITH facility_year AS (
    SELECT
        facility_number,
        year,
        SUM(productive_hours) AS fac_hours,
        SUM(CASE WHEN phapd_missing = "N" THEN productive_hours_per_adjusted_patient_day ELSE 0 END) AS fac_phapd,
        MAX(phapd_missing) AS any_missing
    FROM labor_hrs
    GROUP BY facility_number, year
),
quartiled AS (
    SELECT
        facility_number,
        year,
        fac_hours,
        fac_phapd,
        NTILE(4) OVER (ORDER BY fac_hours) AS hours_quartile
    FROM facility_year
    WHERE any_missing = "N"
)
SELECT
    hours_quartile,
    COUNT(*) AS facility_years,
    ROUND(AVG(fac_hours), 0) AS avg_fac_hours,
    ROUND(AVG(fac_phapd), 2) AS avg_fac_phapd
FROM quartiled
GROUP BY hours_quartile
ORDER BY hours_quartile;
-- Sample: 1 | 512 | 275,075 | 21.01
-- 2 | 512 | 761,247 | 25.55
-- 3 | 512 | 1,812,342 | 30.31
-- 4 | 512 | 4,855,232 | 35.44 (4 rows); n=2,048 facility-year grain, avg_fac_phapd rises with hours quartile

-- Q4.2: 25th/50th/75th percentile PHAPD bands via NTILE-inside-NTILE
WITH facility_year AS (
    SELECT
        facility_number,
        year,
        SUM(productive_hours) AS fac_hours,
        SUM(CASE WHEN phapd_missing = "N" THEN productive_hours_per_adjusted_patient_day ELSE 0 END) AS fac_phapd,
        MAX(phapd_missing) AS any_missing
    FROM labor_hrs
    GROUP BY facility_number, year
),
banded AS (
    SELECT
        facility_number,
        year,
        fac_hours,
        fac_phapd,
        NTILE(4) OVER (ORDER BY fac_phapd) AS phapd_band 
    FROM facility_year
    WHERE any_missing = "N"
)
SELECT
    phapd_band,
    COUNT(*) AS facility_years,
    MIN(fac_phapd) AS band_min,
    MAX(fac_phapd) AS band_max,
    ROUND(AVG(fac_hours), 0) AS avg_fac_hours
FROM banded
GROUP BY phapd_band
ORDER BY phapd_band;
-- Sample: 1 | 512 | 2.04 | 19.55 | 597,623
-- 2 | 512 | 19.55 | 26.66 | 1,505,412
-- 3 | 512 | 26.67 | 34.29 | 2,240,037
-- 4 | 512 | 34.30 | 163.88 | 3,360,824 (4 rows)
-- band 2 max (26.66) = approx median, band 1/3 boundaries (19.55 / 34.29 approx) = approx 25th/75th percentile PHAPD


/*
=======================================================================================================================================================
BQ5 - Is staffing intensity consistent across counties and facilities within a volume peer group, or driven by a small number of outliers?
=======================================================================================================================================================
*/
-- BQ5 - low-tier facility-year PHAPD: five-number summary + Tukey fences
WITH facility_year AS (
    SELECT
        facility_number, year, region,
        SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
      AND region IN ('Northern Sacramento Valley', 'Northern California', 'Central Sierra')
    GROUP BY facility_number, year
),
ranked AS (
    SELECT
        fac_phapd,
        NTILE(4) OVER (ORDER BY fac_phapd) AS quartile
    FROM facility_year
),
quartile_bounds AS (
    SELECT
        MIN(fac_phapd) AS min_val,
        MAX(fac_phapd) AS max_val,
        MAX(CASE WHEN quartile = 1 THEN fac_phapd END) AS q1,
        MAX(CASE WHEN quartile = 2 THEN fac_phapd END) AS q2_approx,
        MIN(CASE WHEN quartile = 4 THEN fac_phapd END) AS q3  -- why not max? b/c first value in top quarter, closer to true Q3 boundary than last value in Q3
    FROM ranked
)
SELECT
    min_val,
    q1,
    q2_approx AS median_approx,
    q3,
    max_val,
    ROUND(q3 - q1, 2) AS iqr,
    ROUND(q1 - 1.5*(q3-q1), 2) AS inner_fence_low,  -- Tukey (1977) fences: standard boxplot outlier convention
    ROUND(q3 + 1.5*(q3-q1), 2) AS inner_fence_high, -- rule for flagging outliers with skewed data
    ROUND(q1 - 3*(q3-q1), 2) AS outer_fence_low,    -- uses interquartile ranges multiplied by ± 1.5×IQR (inner) and ±3×IQR (outer)
    ROUND(q3 + 3*(q3-q1), 2) AS outer_fence_high    -- 1.5xIQR is the standard boxplot convention for flagging outliers, 3xIQR is a more extreme threshold
FROM quartile_bounds;
-- Sample: min_val 4.08 | q1 12.78 | median_approx 29.72 | q3 37.47 | max_val 130.58
-- iqr 24.69 | inner_fence_low -24.25 | inner_fence_high 74.5 | outer_fence_low -61.29 | outer_fence_high 111.54
-- (1 row; pooled n=203 across the 3 low-tier regions)

-- BQ5 - low-tier facility-year PHAPD by individual region: five-number summary + Tukey fences
WITH facility_year AS (
    SELECT
        facility_number, year, region,
        SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
      AND region IN ('Northern Sacramento Valley', 'Northern California', 'Central Sierra')
    GROUP BY facility_number, year
),
ranked AS (
    SELECT
        region,
        fac_phapd,
        NTILE(4) OVER (PARTITION BY region ORDER BY fac_phapd) AS quartile
    FROM facility_year
),
quartile_bounds AS (
    SELECT
        region,
        COUNT(*) AS n,
        MIN(fac_phapd) AS min_val,
        MAX(fac_phapd) AS max_val,
        MAX(CASE WHEN quartile = 1 THEN fac_phapd END) AS q1,
        MAX(CASE WHEN quartile = 2 THEN fac_phapd END) AS q2_approx,
        MIN(CASE WHEN quartile = 4 THEN fac_phapd END) AS q3
    FROM ranked
    GROUP BY region
)
SELECT
    region,
    n,
    min_val,
    q1,
    q2_approx AS median_approx,
    q3,
    max_val,
    ROUND(q3 - q1, 2) AS iqr,
    ROUND(q3 + 1.5*(q3-q1), 2) AS inner_fence_high,
    ROUND(q3 + 3*(q3-q1), 2) AS outer_fence_high
FROM quartile_bounds
ORDER BY region;
-- Sample: Central Sierra | 38 | 5.59 | 8.4 | 29.14 | 66.18 | 130.58 | 57.78 | 152.85 | 239.52
-- Northern California | 105 | 4.08 | 11.51 | 28.33 | 38.51 | 60.88 | 27.0 | 79.01 | 119.51
-- Northern Sacramento Valley | 60 | 5.39 | 17.12 | 30.15 | 33.67 | 74.36 | 16.55 | 58.5 | 83.32 (3 rows; n's sum to 203)

-- BQ5 - med/high-tier facility-year PHAPD: five-number summary + Tukey fences
WITH facility_year AS (
    SELECT
        facility_number, year, region,
        SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
      AND region IN ('Southern Border', 'Bay Area', 'Greater Sacramento', 'Southern California', 'San Joaquin Valley', 'Central Coast')
    GROUP BY facility_number, year
),
ranked AS (
    SELECT
        fac_phapd,
        NTILE(4) OVER (ORDER BY fac_phapd) AS quartile
    FROM facility_year
),
quartile_bounds AS (
    SELECT
        MIN(fac_phapd) AS min_val,
        MAX(fac_phapd) AS max_val,
        MAX(CASE WHEN quartile = 1 THEN fac_phapd END) AS q1,
        MAX(CASE WHEN quartile = 2 THEN fac_phapd END) AS q2_approx,
        MIN(CASE WHEN quartile = 4 THEN fac_phapd END) AS q3
    FROM ranked
)
SELECT
    min_val,
    q1,
    q2_approx AS median_approx,
    q3,
    max_val,
    ROUND(q3 - q1, 2) AS iqr,
    ROUND(q1 - 1.5*(q3-q1), 2) AS inner_fence_low,
    ROUND(q3 + 1.5*(q3-q1), 2) AS inner_fence_high,
    ROUND(q1 - 3*(q3-q1), 2) AS outer_fence_low,
    ROUND(q3 + 3*(q3-q1), 2) AS outer_fence_high
FROM quartile_bounds;
-- Sample: min_val 2.04 | q1 19.67 | median_approx 26.33 | q3 34.1 | max_val 163.88
-- iqr 14.43 | inner_fence_low -1.98 | inner_fence_high 55.75 | outer_fence_low -23.62 | outer_fence_high 77.39
-- (1 row; pooled n=1,845 across the 6 med/high-tier regions)

-- BQ5 - med/high-tier facility-year PHAPD by individual region: five-number summary + Tukey fences
WITH facility_year AS (
    SELECT
        facility_number, year, region,
        SUM(productive_hours_per_adjusted_patient_day) AS fac_phapd
    FROM labor_hrs
    WHERE phapd_missing = "N"
      AND region IN ('Southern Border', 'Bay Area', 'Greater Sacramento', 'Southern California', 'San Joaquin Valley', 'Central Coast')
    GROUP BY facility_number, year
),
ranked AS (
    SELECT
        region,
        fac_phapd,
        NTILE(4) OVER (PARTITION BY region ORDER BY fac_phapd) AS quartile
    FROM facility_year
),
quartile_bounds AS (
    SELECT
        region,
        COUNT(*) AS n,
        MIN(fac_phapd) AS min_val,
        MAX(fac_phapd) AS max_val,
        MAX(CASE WHEN quartile = 1 THEN fac_phapd END) AS q1,
        MAX(CASE WHEN quartile = 2 THEN fac_phapd END) AS q2_approx,
        MIN(CASE WHEN quartile = 4 THEN fac_phapd END) AS q3
    FROM ranked
    GROUP BY region
)
SELECT
    region,
    n,
    min_val,
    q1,
    q2_approx AS median_approx,
    q3,
    max_val,
    ROUND(q3 - q1, 2) AS iqr,
    ROUND(q3 + 1.5*(q3-q1), 2) AS inner_fence_high,
    ROUND(q3 + 3*(q3-q1), 2) AS outer_fence_high
FROM quartile_bounds
ORDER BY region;
-- Sample: Bay Area | 391 | 5.28 | 21.14 | 29.16 | 39.38 | 130.5 | 18.24 | 66.74 | 94.1
-- Central Coast | 67 | 7.27 | 20.1 | 26.51 | 34.78 | 45.18 | 14.68 | 56.8 | 78.82
-- Greater Sacramento | 109 | 9.1 | 16.48 | 25.52 | 31.26 | 80.56 | 14.78 | 53.43 | 75.6
-- San Joaquin Valley | 221 | 5.49 | 21.27 | 26.91 | 35.73 | 86.06 | 14.46 | 57.42 | 79.11
-- Southern Border | 138 | 4.62 | 14.18 | 25.26 | 32.56 | 55.6 | 18.38 | 60.13 | 87.7
-- Southern California | 919 | 2.04 | 19.61 | 25.23 | 33.02 | 163.88 | 13.41 | 53.13 | 73.25 (6 rows; n's sum to 1,845)



/*
============================================================================
SUMMARY OF ANALYSIS PERFORMED
============================================================================
Five business questions were answered using two SQLite tables imported from labor_hrs.csv (20,490 rows, 10 labor-classification hours_types) and cost_centers.csv (14,343 rows, 7 cost-center hours_types),
 at the facility-year grain (2,049 facility-years, 2009-2013) 
 
Methods used:
- Trend analysis (BQ1): year-over-year % change and coefficient of variation on statewide average facility labor hours and PHAPD
- Ranked comparison (BQ2): region-level averages vs. statewide mean, with a per-year above/below flag counted across all 5 years
- Compositional analysis (BQ3): hours_type % share of total, computed separately for three volume tiers (High/Medium/Low, 3 regions each) and for both taxonomies (labor_hrs = "who," cost_centers = "where")
- Quartile/correlation analysis (BQ4): NTILE(4) on facility-year hours, average PHAPD per quartile, cross-checked with a reverse NTILE(4) on PHAPD to confirm the relationship holds from both directions
- Distribution/outlier analysis (BQ5): five-number summaries and Tukey fence (1.5x/3x IQR) outlier detection, computed for a low-volume peer group vs. a med/high-volume peer group, both pooled and by region

============================================================================
TOP SIGNIFICANT INSIGHTS
============================================================================
1. Volume and intensity move in opposite directions. The regions with the most total labor hours are not the most staffing-intensive per patient day, and vice versa
   Central Sierra is the smallest region by volume, but the most intensive (38.74 PHAPD)
   Southern Border is the largest by volume but the least intensive (24.53 PHAPD)

2. Size predicts intensity for most, but not all, ownership types
   Across all facilities, larger facility-years average higher PHAPD in a stepwise pattern (21.01 -> 25.55 -> 30.31 -> 35.44 across hours quartiles)
   But split by ownership, the relationship is flat for Investor-owned facilities (R^2 ~0.0001) while holding for City/County, District, and Non-Profit

3. Composition is nearly identical across volume tiers except for one category
   High- and Medium-volume tiers are statistically indistinguishable on almost every labor category, except for Clerical & Other Administrative share, which rises monotonically as volume falls
   (13.3-14.0% High, 14.5-16.7% Medium, 18.2-24.4% Low), suggesting administrative overhead does not scale down with facility volume

4. Statewide staffing intensity is flat over time, but its spread is widening
   Mean facility PHAPD barely moved 2009-2013 (28.32 -> 28.36), but the coefficient of variation rose from 55.7% to 56.0% after dipping to 47.1% in 2010, 
   meaning facilities are diverging from each other even as the average holds steady

5. Low-volume outliers are concentrated in a handful of facilities, not spread across the tier
   All 6 low-tier facility-years above the statewide outlier threshold (>=80 PHAPD) come from just two Central Sierra facilities
   The med-/high-volume peer group's outlier rate is lower (2.9% vs. 4.4%) but drawn from more facilities (28 vs. 3),
   meaning the low-tier's instability is a facility-specific risk, while the med-/high tier's is more distributed

============================================================================
BUSINESS DECISION IMPLICATIONS
============================================================================
The five queries build one argument: volume and staffing intensity are independent axes, with variation driven by factors at the region, county, and facility level

BQ2 shows the independence. Southern Border has the state's highest labor volume (2.44M hours) and lowest intensity (24.53 PHAPD)
Central Sierra has the lowest volume and highest intensity (38.74)
Volume is not an efficiency proxy — score the two axes separately

BQ4 shows a flat benchmark fails within an axis too
Average PHAPD climbs from 21.01 to 35.44 across hours quartiles, so one statewide target flags large facilities as overstaffed and small ones as understaffed
    Fix: volume-matched peers
    Constraint: the size relationship holds more for City/County (R-squared 0.401) than for Investor-owned (0.0001), so segment by ownership might be necessary before applying the size adjustment

BQ5 routes investigation
Low-tier outliers come from 3 facilities, med/high from 28 — concentrated risk calls for facility-level review, distributed risk for peer review
It also limits regional inference: Central Sierra's average is two hospitals, not a practice pattern

BQ1 and BQ3 set maintenance terms
Intensity stayed flat (28.32 to 28.36) while the coefficient of variation rose 55.7% to 56.0% 
    Norms need scheduled recalibration, not indefinite use
Clerical & Other Administrative share rises as volume falls (13.3-14.0% High, 18.2-24.4% Low) making administrative overhead the first target for cost reduction at small facilities

Limitation: adjusted patient days are revenue-derived, so differences in pricing for outpatient services as well as case mix may drive part of the PHAPD variation independent of staffing decisions
*/