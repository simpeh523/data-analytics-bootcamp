CATEGORY: SOLELY CAPSTONE — graded deliverable. Paste-ready tables for the written report. Not a working file.

# Profiling and Aggregate Statistics

Source: `Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv`, 390,473 rows, 22
columns, 100% Colorado. All figures below are computed directly from the raw file
(`encoding='utf-8-sig'`) after the type coercion in `CLEANING.md` Step 5. No rows are
excluded.

## 1. File and load verification

*Confirms the loaded file matches the source on row count, column count, and
geographic scope.*

| Check | Result |
|---|---|
| Row count | 390,473 |
| Column count | 22 |
| Distinct `Prscrbr_State_Abrvtn` values | 1 (`CO`, 100.0%) |
| Non-numeric values in numeric columns (10 columns checked) | 0 |
| Exact duplicate rows | 0 |
| Duplicate rows on grain (NPI + Brnd_Name + Gnrc_Name) | 0 |
| `Tot_Drug_Cst` sum | $2,737,455,388.61 |

## 2. Distinct entity counts

*Count of distinct values per key dimension, one pass over the full file.*

| Dimension | Distinct count |
|---|---|
| Prescriber NPI | 19,390 |
| Specialty (`Prscrbr_Type`) | 97 |
| Generic drug (`Gnrc_Name`) | 1,177 |
| Brand name (`Brnd_Name`) | 1,662 |
| City (`Prscrbr_City`) | 226 |

## 3. Null and suppression profile

*True SQL/pandas nulls per column, and empty-string ("blank") counts per column. All
390,473 rows checked.*

| Column | True nulls | Empty strings | % empty |
|---|---|---|---|
| `Prscrbr_NPI` | 0 | 0 | 0.0% |
| `Prscrbr_Last_Org_Name` | 0 | 0 | 0.0% |
| `Prscrbr_First_Name` | 0 | 0 | 0.0% |
| `Prscrbr_City` | 0 | 0 | 0.0% |
| `Prscrbr_State_Abrvtn` | 0 | 0 | 0.0% |
| `Prscrbr_State_FIPS` | 0 | 0 | 0.0% |
| `Prscrbr_Type` | 0 | 0 | 0.0% |
| `Prscrbr_Type_Src` | 0 | 0 | 0.0% |
| `Brnd_Name` | 0 | 0 | 0.0% |
| `Gnrc_Name` | 0 | 0 | 0.0% |
| `Tot_Clms` | 0 | 0 | 0.0% |
| `Tot_30day_Fills` | 0 | 0 | 0.0% |
| `Tot_Day_Suply` | 0 | 0 | 0.0% |
| `Tot_Drug_Cst` | 0 | 0 | 0.0% |
| `Tot_Benes` | 0 | 229,912 | 58.9% |
| `GE65_Sprsn_Flag` | 0 | 226,277 | 58.0% |
| `GE65_Tot_Clms` | 0 | 164,196 | 42.1% |
| `GE65_Tot_30day_Fills` | 0 | 164,196 | 42.1% |
| `GE65_Tot_Drug_Cst` | 0 | 164,196 | 42.1% |
| `GE65_Tot_Day_Suply` | 0 | 164,196 | 42.1% |
| `GE65_Bene_Sprsn_Flag` | 0 | 53,317 | 13.7% |
| `GE65_Tot_Benes` | 0 | 337,156 | 86.3% |

## 4. Numeric column summary

*Min, max, mean, median, mode, sample standard deviation, and percentiles, computed
over non-blank values only. n varies by column per the suppression profile in
Section 3.*

| Column | n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `Tot_Clms` | 390,473 | 11 | 21,631 | 42.45 | 23 | 11 | 80.39 | 15 | 23 | 43 | 88 | 307 |
| `Tot_30day_Fills` | 390,473 | 11 | 21,631 | 84.82 | 39.9 | 12 | 157.34 | 21.8 | 39.9 | 82.7 | 183.2 | 750 |
| `Tot_Day_Suply` | 390,473 | 11 | 112,491 | 2,408.01 | 1,103 | 360 | 4,447.67 | 502 | 1,103 | 2,368 | 5,370 | 22,256 |
| `Tot_Drug_Cst` | 390,473 | 0 | 10,210,321.85 | 7,010.61 | 442.71 | 0 | 59,190.41 | 185.76 | 442.71 | 1,347.48 | 7,885.14 | 124,277.12 |
| `Tot_Benes` | 160,561 | 11 | 16,313 | 27.95 | 19 | 11 | 76.67 | 13 | 19 | 30 | 52 | 140 |
| `GE65_Tot_Clms` | 226,277 | 0 | 20,053 | 38.41 | 20 | 11 | 89.01 | 13 | 20 | 38 | 79 | 305 |
| `GE65_Tot_30day_Fills` | 226,277 | 0 | 20,053 | 78.67 | 37 | 0 | 160.22 | 19 | 37 | 75 | 167.3 | 733.9 |
| `GE65_Tot_Drug_Cst` | 226,277 | 0 | 9,915,014.40 | 7,091.56 | 395.73 | 0 | 59,500.67 | 158.92 | 395.73 | 1,234.16 | 7,827.38 | 131,890.69 |
| `GE65_Tot_Day_Suply` | 226,277 | 0 | 107,221 | 2,253.41 | 1,065 | 0 | 4,371.06 | 450 | 1,065 | 2,160 | 4,897 | 21,692 |
| `GE65_Tot_Benes` | 53,317 | 0 | 15,104 | 25.39 | 17 | 11 | 121.47 | 13 | 17 | 25 | 41 | 127 |

Note: `Tot_Drug_Cst` mode of 0 reflects 596 rows reporting $0.00 total cost with
`Tot_Clms` ≥ 11 (nonzero claims). See `CLEANING.md` Data Limitations.

## 5. Categorical distribution — Prscrbr_Type (specialty)

*All 97 distinct values, row count and % of 390,473 total rows, ordered by frequency
descending.*

| Specialty | Rows | % of total |
|---|---|---|
| Family Practice | 112,120 | 28.71% |
| Nurse Practitioner | 80,078 | 20.51% |
| Internal Medicine | 62,451 | 15.99% |
| Physician Assistant | 50,431 | 12.92% |
| Cardiology | 6,222 | 1.59% |
| Psychiatry | 6,210 | 1.59% |
| Neurology | 5,444 | 1.39% |
| Dentist | 3,970 | 1.02% |
| Emergency Medicine | 3,932 | 1.01% |
| Ophthalmology | 3,529 | 0.90% |
| Dermatology | 3,407 | 0.87% |
| Geriatric Medicine | 2,936 | 0.75% |
| Endocrinology | 2,885 | 0.74% |
| Hematology-Oncology | 2,640 | 0.68% |
| Pulmonary Disease | 2,510 | 0.64% |
| Urology | 2,479 | 0.63% |
| Rheumatology | 2,405 | 0.62% |
| Nephrology | 2,319 | 0.59% |
| Hospitalist | 2,306 | 0.59% |
| Gastroenterology | 2,305 | 0.59% |
| Optometry | 2,297 | 0.59% |
| Interventional Cardiology | 2,276 | 0.58% |
| Physical Medicine and Rehabilitation | 1,765 | 0.45% |
| Orthopedic Surgery | 1,711 | 0.44% |
| Psychiatry & Neurology | 1,692 | 0.43% |
| Infectious Disease | 1,593 | 0.41% |
| Obstetrics & Gynecology | 1,451 | 0.37% |
| Otolaryngology | 1,390 | 0.36% |
| Student in an Organized Health Care Education/Training Program | 1,271 | 0.33% |
| Medical Oncology | 1,108 | 0.28% |
| Critical Care (Intensivists) | 1,065 | 0.27% |
| General Practice | 1,053 | 0.27% |
| Allergy/ Immunology | 976 | 0.25% |
| Clinical Cardiac Electrophysiology | 956 | 0.24% |
| Podiatry | 833 | 0.21% |
| Osteopathic Manipulative Medicine | 785 | 0.20% |
| General Surgery | 740 | 0.19% |
| Certified Clinical Nurse Specialist | 723 | 0.19% |
| Oral Surgery (Dentist only) | 636 | 0.16% |
| Pediatric Medicine | 553 | 0.14% |
| Pain Management | 464 | 0.12% |
| Family Medicine | 422 | 0.11% |
| Hospice and Palliative Care | 373 | 0.10% |
| Anesthesiology | 302 | 0.08% |
| Neuropsychiatry | 299 | 0.08% |
| Pharmacist | 273 | 0.07% |
| Advanced Heart Failure and Transplant Cardiology | 239 | 0.06% |
| Hematopoietic Cell Transplantation and Cellular Therapy | 192 | 0.05% |
| Interventional Pain Management | 189 | 0.05% |
| Radiation Oncology | 180 | 0.05% |
| Vascular Surgery | 139 | 0.04% |
| Sleep Medicine | 139 | 0.04% |
| Specialist | 118 | 0.03% |
| Program of All-Inclusive Care for the Elderly (PACE) Provider Organization | 117 | 0.03% |
| Sports Medicine | 115 | 0.03% |
| Certified Registered Nurse Anesthetist (CRNA) | 115 | 0.03% |
| Registered Nurse | 101 | 0.03% |
| Plastic and Reconstructive Surgery | 95 | 0.02% |
| Neurosurgery | 87 | 0.02% |
| Adult Congenital Heart Disease | 82 | 0.02% |
| Certified Nurse Midwife | 75 | 0.02% |
| Oral & Maxillofacial Surgery | 71 | 0.02% |
| Micrographic Dermatologic Surgery | 64 | 0.02% |
| Colorectal Surgery (Proctology) | 61 | 0.02% |
| Gynecological Oncology | 57 | 0.01% |
| Orthopaedic Surgery | 52 | 0.01% |
| Plastic Surgery | 51 | 0.01% |
| Hematology | 47 | 0.01% |
| Hand Surgery | 46 | 0.01% |
| Interventional Radiology | 42 | 0.01% |
| Surgical Oncology | 41 | 0.01% |
| Preventive Medicine | 41 | 0.01% |
| Addiction Medicine | 40 | 0.01% |
| Nuclear Medicine | 36 | 0.01% |
| Epileptologists | 34 | 0.01% |
| Pathology | 25 | 0.01% |
| Geriatric Psychiatry | 25 | 0.01% |
| Clinic/Center | 23 | 0.01% |
| Licensed Professional Counselor | 22 | 0.01% |
| Maxillofacial Surgery | 20 | 0.01% |
| Thoracic Surgery | 19 | 0.00% |
| Diagnostic Radiology | 15 | 0.00% |
| Neurological Surgery | 14 | 0.00% |
| Medical Genetics and Genomics | 12 | 0.00% |
| Oral Medicinist | 11 | 0.00% |
| Cardiac Surgery | 10 | 0.00% |
| Legal Medicine | 5 | 0.00% |
| Surgery | 4 | 0.00% |
| Medical Toxicology | 3 | 0.00% |
| Psychologist, Clinical | 2 | 0.00% |
| Physical Medicine & Rehabilitation | 2 | 0.00% |
| Neuromusculoskeletal Medicine, Sports Medicine | 2 | 0.00% |
| Dental Hygienist | 2 | 0.00% |
| Counselor | 2 | 0.00% |
| Pediatrics | 1 | 0.00% |
| Naturopath | 1 | 0.00% |
| Licensed Practical Nurse | 1 | 0.00% |

## 6. Categorical distribution — Prscrbr_Type_Src (specialty label source)

| Source | Rows | % of total |
|---|---|---|
| Claim-Specialty | 344,460 | 88.22% |
| NPPES-Specialty | 40,016 | 10.25% |
| NPPES-Taxonomy | 5,997 | 1.54% |

## 7. Categorical distribution — Prscrbr_City (top 20 of 226)

*Ordered by row count descending. Remaining 206 cities account for 97,938 rows
(25.1% of total).*

| City | Rows | % of total |
|---|---|---|
| Denver | 48,634 | 12.46% |
| Colorado Springs | 40,743 | 10.43% |
| Aurora | 34,301 | 8.78% |
| Fort Collins | 17,572 | 4.50% |
| Pueblo | 17,230 | 4.41% |
| Grand Junction | 12,318 | 3.15% |
| Lakewood | 12,080 | 3.09% |
| Littleton | 11,890 | 3.05% |
| Westminster | 11,368 | 2.91% |
| Parker | 9,865 | 2.53% |
| Boulder | 9,586 | 2.46% |
| Greeley | 9,508 | 2.44% |
| Golden | 8,302 | 2.13% |
| Wheat Ridge | 8,294 | 2.12% |
| Longmont | 8,058 | 2.06% |
| Lone Tree | 7,285 | 1.87% |
| Loveland | 6,966 | 1.78% |
| Englewood | 6,482 | 1.66% |
| Centennial | 6,166 | 1.58% |
| Lafayette | 5,887 | 1.51% |

## 8. Categorical distribution — Brnd_Name (top 20 of 1,662)

*Ordered by row count descending. Remaining 1,642 brand names account for 295,193
rows (75.6% of total).*

| Brand name | Rows | % of total |
|---|---|---|
| Gabapentin | 6,447 | 1.65% |
| Atorvastatin Calcium | 6,131 | 1.57% |
| Lisinopril | 5,504 | 1.41% |
| Amlodipine Besylate | 5,479 | 1.40% |
| Levothyroxine Sodium | 5,305 | 1.36% |
| Losartan Potassium | 5,146 | 1.32% |
| Omeprazole | 4,968 | 1.27% |
| Prednisone | 4,728 | 1.21% |
| Trazodone Hcl | 4,641 | 1.19% |
| Rosuvastatin Calcium | 4,544 | 1.16% |
| Albuterol Sulfate Hfa | 4,504 | 1.15% |
| Pantoprazole Sodium | 4,426 | 1.13% |
| Oxycodone Hcl | 4,352 | 1.11% |
| Furosemide | 4,308 | 1.10% |
| Metoprolol Succinate | 4,288 | 1.10% |
| Metformin Hcl | 4,242 | 1.09% |
| Tramadol Hcl | 4,105 | 1.05% |
| Tamsulosin Hcl | 4,094 | 1.05% |
| Hydrocodone-Acetaminophen | 4,094 | 1.05% |
| Duloxetine Hcl | 3,974 | 1.02% |

## 9. Categorical distribution — Gnrc_Name (top 20 of 1,177, by row count)

*Ordered by row count descending. Remaining 1,157 generic names account for 289,384
rows (74.1% of total).*

| Generic name | Rows | % of total |
|---|---|---|
| Levothyroxine Sodium | 7,007 | 1.79% |
| Metformin Hcl | 6,959 | 1.78% |
| Gabapentin | 6,460 | 1.65% |
| Atorvastatin Calcium | 6,132 | 1.57% |
| Lisinopril | 5,504 | 1.41% |
| Amlodipine Besylate | 5,480 | 1.40% |
| Albuterol Sulfate | 5,347 | 1.37% |
| Losartan Potassium | 5,146 | 1.32% |
| Omeprazole | 4,968 | 1.27% |
| Prednisone | 4,729 | 1.21% |
| Oxycodone Hcl | 4,669 | 1.20% |
| Trazodone Hcl | 4,641 | 1.19% |
| Rosuvastatin Calcium | 4,548 | 1.16% |
| Pantoprazole Sodium | 4,426 | 1.13% |
| Furosemide | 4,310 | 1.10% |
| Metoprolol Succinate | 4,309 | 1.10% |
| Tramadol Hcl | 4,288 | 1.10% |
| Tamsulosin Hcl | 4,094 | 1.05% |
| Hydrocodone/Acetaminophen | 4,094 | 1.05% |
| Duloxetine Hcl | 3,978 | 1.02% |

## 10. Suppression flag distributions

*`GE65_Sprsn_Flag`: blank = not suppressed (GE65 claims/cost/fills/day-supply
populated), `#` = a related field suppressed, `*` = claim count suppressed.*

| Value | Rows | % of total |
|---|---|---|
| (blank) | 226,277 | 57.95% |
| `#` | 122,906 | 31.48% |
| `*` | 41,290 | 10.57% |

*`GE65_Bene_Sprsn_Flag`: blank = not suppressed (`GE65_Tot_Benes` populated).*

| Value | Rows | % of total |
|---|---|---|
| `*` | 238,726 | 61.14% |
| `#` | 98,430 | 25.21% |
| (blank) | 53,317 | 13.65% |

## 11. Generic-drug-level rollup (top 20 by total cost, of 1,177)

*Sum of `Tot_Clms`, `Tot_30day_Fills`, and `Tot_Drug_Cst` across all rows sharing a
`Gnrc_Name`, per the project's generic-drug analysis grain. `cost_per_claim` =
tot_cost / tot_clms; `cost_per_fill` = tot_cost / tot_fills. Sum of `tot_cost` across
all 1,177 generics ties to $2,737,455,388.61 (Section 1).*

| Generic name | Rows | Distinct NPIs | Tot claims | Tot 30-day fills | Tot cost | Cost/claim | Cost/fill |
|---|---|---|---|---|---|---|---|
| Apixaban | 3,970 | 3,970 | 251,325 | 447,173.5 | $244,196,696.45 | $971.64 | $546.09 |
| Semaglutide | 2,731 | 2,521 | 93,812 | 130,936.3 | $117,273,307.10 | $1,250.09 | $895.65 |
| Empagliflozin | 2,922 | 2,922 | 111,517 | 235,451.8 | $112,690,707.54 | $1,010.52 | $478.61 |
| Lenalidomide | 170 | 123 | 5,814 | 5,818.7 | $92,447,408.69 | $15,900.83 | $15,887.98 |
| Rivaroxaban | 2,278 | 2,278 | 75,419 | 143,472.3 | $75,261,499.44 | $997.91 | $524.57 |
| Dulaglutide | 1,637 | 1,637 | 50,205 | 67,525.2 | $64,168,615.24 | $1,278.13 | $950.29 |
| Tirzepatide | 1,296 | 1,296 | 49,215 | 60,049.6 | $63,335,483.66 | $1,286.91 | $1,054.72 |
| Adalimumab | 275 | 209 | 7,410 | 7,749.2 | $62,895,533.90 | $8,487.93 | $8,116.39 |
| Fluticasone/Umeclidin/Vilanter | 1,143 | 1,143 | 49,441 | 71,063.1 | $45,187,885.91 | $913.98 | $635.88 |
| Etanercept | 148 | 103 | 5,553 | 5,873.4 | $40,348,531.57 | $7,266.08 | $6,869.71 |
| Tafamidis | 45 | 45 | 1,633 | 1,714.0 | $39,818,739.97 | $24,383.80 | $23,231.47 |
| Bictegrav/Emtricit/Tenofov Ala | 116 | 116 | 8,413 | 9,374.1 | $35,459,892.12 | $4,214.89 | $3,782.75 |
| Dupilumab | 358 | 299 | 8,445 | 8,707.2 | $33,517,915.49 | $3,968.97 | $3,849.45 |
| Ruxolitinib Phosphate | 76 | 76 | 2,259 | 2,270.2 | $33,438,304.35 | $14,802.26 | $14,729.23 |
| Nintedanib Esylate | 68 | 68 | 2,470 | 2,520.0 | $32,853,051.61 | $13,300.83 | $13,036.93 |
| Enzalutamide | 79 | 79 | 2,502 | 2,544.0 | $32,525,675.52 | $12,999.87 | $12,785.25 |
| Ustekinumab | 52 | 52 | 1,189 | 1,827.8 | $31,717,380.59 | $26,675.68 | $17,352.76 |
| Dapagliflozin Propanediol | 1,152 | 1,118 | 32,180 | 58,920.4 | $31,623,076.92 | $982.69 | $536.71 |
| Mirabegron | 1,207 | 1,138 | 43,489 | 69,415.4 | $29,037,515.03 | $667.70 | $418.32 |
| Elexacaftor/Tezacaftor/Ivacaft | 8 | 8 | 1,047 | 1,077.6 | $28,899,560.58 | $27,602.25 | $26,818.45 |
