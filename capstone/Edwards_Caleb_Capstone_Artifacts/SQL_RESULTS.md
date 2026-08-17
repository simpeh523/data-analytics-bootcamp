# SQL Profiling Results

2024 CMS Medicare Part D Prescribers by Provider and Drug -- Colorado only.
Generated from `outputs/part_d_profiling.sql` against `outputs/part_d.sqlite`.

## SECTION 1: IMPORT & VERIFICATION

### [1.1] Row count

Confirm the loaded row count matches the source CSV (390,473 rows).

| row_count |
|---|
| 390473 |

_1 row(s) returned._

### [1.2] Column count

Confirm the table has the expected 22 columns.

| column_count |
|---|
| 22 |

_1 row(s) returned._

### [1.3] State value check

Confirm Prscrbr_State_Abrvtn contains only the value CO, with a row count and % of total per value.

| state | n_rows | pct_of_total |
|---|---|---|
| CO | 390473 | 100 |

_1 row(s) returned._

### [1.4] Distinct entity counts

Count distinct NPIs, specialties, generic drug names, and cities in one pass.

| distinct_npi | distinct_specialty | distinct_generic | distinct_city |
|---|---|---|---|
| 19390 | 97 | 1177 | 226 |

_1 row(s) returned._

### [1.5] Per-column NULL counts

Count true SQL NULLs per column (distinct from empty-string blanks, checked next).

| Prscrbr_NPI_nulls | Prscrbr_Last_Org_Name_nulls | Prscrbr_First_Name_nulls | Prscrbr_City_nulls | Prscrbr_State_Abrvtn_nulls | Prscrbr_State_FIPS_nulls | Prscrbr_Type_nulls | Prscrbr_Type_Src_nulls | Brnd_Name_nulls | Gnrc_Name_nulls | Tot_Clms_nulls | Tot_30day_Fills_nulls | Tot_Day_Suply_nulls | Tot_Drug_Cst_nulls | Tot_Benes_nulls | GE65_Sprsn_Flag_nulls | GE65_Tot_Clms_nulls | GE65_Tot_30day_Fills_nulls | GE65_Tot_Drug_Cst_nulls | GE65_Tot_Day_Suply_nulls | GE65_Bene_Sprsn_Flag_nulls | GE65_Tot_Benes_nulls |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

_1 row(s) returned._

### [1.6] Per-column empty-string counts

Count empty-string blanks per column, as loaded from the source CSV.

| Prscrbr_NPI_empty | Prscrbr_Last_Org_Name_empty | Prscrbr_First_Name_empty | Prscrbr_City_empty | Prscrbr_State_Abrvtn_empty | Prscrbr_State_FIPS_empty | Prscrbr_Type_empty | Prscrbr_Type_Src_empty | Brnd_Name_empty | Gnrc_Name_empty | Tot_Clms_empty | Tot_30day_Fills_empty | Tot_Day_Suply_empty | Tot_Drug_Cst_empty | Tot_Benes_empty | GE65_Sprsn_Flag_empty | GE65_Tot_Clms_empty | GE65_Tot_30day_Fills_empty | GE65_Tot_Drug_Cst_empty | GE65_Tot_Day_Suply_empty | GE65_Bene_Sprsn_Flag_empty | GE65_Tot_Benes_empty |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 229912 | 226277 | 164196 | 164196 | 164196 | 164196 | 53317 | 337156 |

_1 row(s) returned._

### [1.7] Numeric column parse check

For each numeric column, count non-blank values that did NOT parse as integer/real (should be 0 for all).

| Tot_Clms_non_numeric | Tot_30day_Fills_non_numeric | Tot_Day_Suply_non_numeric | Tot_Drug_Cst_non_numeric | Tot_Benes_non_numeric | GE65_Tot_Clms_non_numeric | GE65_Tot_30day_Fills_non_numeric | GE65_Tot_Drug_Cst_non_numeric | GE65_Tot_Day_Suply_non_numeric | GE65_Tot_Benes_non_numeric |
|---|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

_1 row(s) returned._

### [1.8] Total drug cost tie-out

Confirm the sum of Tot_Drug_Cst ties to the verified total of $2,737,500,000.

| total_drug_cost |
|---|
| 2737455388.61 |

_1 row(s) returned._

## SECTION 2: UNIVARIATE PROFILING

### [2.1] Categorical distribution: Prscrbr_State_Abrvtn

Distinct values of Prscrbr_State_Abrvtn (prescriber state) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| CO | 390473 | 100 |

_1 row(s) returned._

### [2.2] Categorical distribution: Prscrbr_City

Distinct values of Prscrbr_City (prescriber city) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| Denver | 48634 | 12.4552 |
| Colorado Springs | 40743 | 10.4343 |
| Aurora | 34301 | 8.7845 |
| Fort Collins | 17572 | 4.5002 |
| Pueblo | 17230 | 4.4126 |
| Grand Junction | 12318 | 3.1546 |
| Lakewood | 12080 | 3.0937 |
| Littleton | 11890 | 3.045 |
| Westminster | 11368 | 2.9113 |
| Parker | 9865 | 2.5264 |
| Boulder | 9586 | 2.455 |
| Greeley | 9508 | 2.435 |
| Golden | 8302 | 2.1261 |
| Wheat Ridge | 8294 | 2.1241 |
| Longmont | 8058 | 2.0637 |
| Lone Tree | 7285 | 1.8657 |
| Loveland | 6966 | 1.784 |
| Englewood | 6482 | 1.66 |
| Centennial | 6166 | 1.5791 |
| Lafayette | 5887 | 1.5077 |
| Durango | 5020 | 1.2856 |
| Highlands Ranch | 4679 | 1.1983 |
| Thornton | 4667 | 1.1952 |
| Greenwood Village | 4176 | 1.0695 |
| Montrose | 4019 | 1.0293 |
| Castle Rock | 3561 | 0.912 |
| Arvada | 3561 | 0.912 |
| Brighton | 2952 | 0.756 |
| Canon City | 2420 | 0.6198 |
| Broomfield | 2071 | 0.5304 |
| Delta | 1943 | 0.4976 |
| Alamosa | 1781 | 0.4561 |
| Windsor | 1777 | 0.4551 |
| Sterling | 1735 | 0.4443 |
| Fruita | 1710 | 0.4379 |
| Louisville | 1626 | 0.4164 |
| Glenwood Springs | 1544 | 0.3954 |
| Salida | 1529 | 0.3916 |
| Woodland Park | 1351 | 0.346 |
| Steamboat Springs | 1296 | 0.3319 |
| Evergreen | 1223 | 0.3132 |
| La Junta | 1221 | 0.3127 |
| Cortez | 1215 | 0.3112 |
| Erie | 1102 | 0.2822 |
| Johnstown | 1091 | 0.2794 |
| Pagosa Springs | 1078 | 0.2761 |
| Monument | 1064 | 0.2725 |
| Lamar | 1036 | 0.2653 |
| Northglenn | 1017 | 0.2605 |
| Pueblo West | 962 | 0.2464 |
| Rifle | 911 | 0.2333 |
| Fort Lupton | 884 | 0.2264 |
| Fort Morgan | 857 | 0.2195 |
| Craig | 826 | 0.2115 |
| Estes Park | 791 | 0.2026 |
| Evans | 763 | 0.1954 |
| Avon | 736 | 0.1885 |
| Commerce City | 729 | 0.1867 |
| Brush | 725 | 0.1857 |
| Trinidad | 699 | 0.179 |
| Walsenburg | 661 | 0.1693 |
| Conifer | 655 | 0.1677 |
| Grand Jct | 644 | 0.1649 |
| Gunnison | 635 | 0.1626 |
| Hugo | 624 | 0.1598 |
| Monte Vista | 603 | 0.1544 |
| Aspen | 557 | 0.1426 |
| Del Norte | 550 | 0.1409 |
| Basalt | 530 | 0.1357 |
| Frisco | 525 | 0.1345 |
| Rocky Ford | 510 | 0.1306 |
| Castle Pines | 495 | 0.1268 |
| Springfield | 480 | 0.1229 |
| Buena Vista | 477 | 0.1222 |
| Fort Carson | 474 | 0.1214 |
| Burlington | 473 | 0.1211 |
| Firestone | 465 | 0.1191 |
| Superior | 464 | 0.1188 |
| Julesburg | 452 | 0.1158 |
| Wray | 433 | 0.1109 |
| Edwards | 430 | 0.1101 |
| Carbondale | 430 | 0.1101 |
| Fountain | 425 | 0.1088 |
| La Jara | 407 | 0.1042 |
| Cedaredge | 387 | 0.0991 |
| Vail | 385 | 0.0986 |
| Peyton | 369 | 0.0945 |
| Kremmling | 358 | 0.0917 |
| Frederick | 350 | 0.0896 |
| Eckert | 333 | 0.0853 |
| Eagle | 321 | 0.0822 |
| Yuma | 319 | 0.0817 |
| Holyoke | 319 | 0.0817 |
| Florence | 318 | 0.0814 |
| Mancos | 301 | 0.0771 |
| Leadville | 286 | 0.0732 |
| Parachute | 281 | 0.072 |
| Glendale | 277 | 0.0709 |
| Lonetree | 245 | 0.0627 |
| Timnath | 243 | 0.0622 |
| Eaton | 235 | 0.0602 |
| Akron | 235 | 0.0602 |
| Calhan | 234 | 0.0599 |
| Collbran | 230 | 0.0589 |
| Meeker | 228 | 0.0584 |
| Usaf Academy | 227 | 0.0581 |
| Eads | 218 | 0.0558 |
| Hotchkiss | 217 | 0.0556 |
| Ft Carson | 215 | 0.0551 |
| Cheyenne Wells | 215 | 0.0551 |
| Niwot | 209 | 0.0535 |
| Norwood | 198 | 0.0507 |
| Rangely | 196 | 0.0502 |
| Granby | 193 | 0.0494 |
| Elizabeth | 185 | 0.0474 |
| Colorado City | 181 | 0.0464 |
| Silverthorne | 177 | 0.0453 |
| Keenesburg | 168 | 0.043 |
| Telluride | 150 | 0.0384 |
| Ridgway | 148 | 0.0379 |
| Strasburg | 136 | 0.0348 |
| Naturita | 131 | 0.0335 |
| Colorado Spgs | 131 | 0.0335 |
| Walsh | 130 | 0.0333 |
| Westcliffe | 123 | 0.0315 |
| Las Animas | 123 | 0.0315 |
| Creede | 123 | 0.0315 |
| Peterson Afb | 117 | 0.03 |
| Breckenridge | 112 | 0.0287 |
| Bayfield | 109 | 0.0279 |
| Limon | 105 | 0.0269 |
| Lajunta | 103 | 0.0264 |
| Wellington | 101 | 0.0259 |
| Ignacio | 98 | 0.0251 |
| Palisade | 97 | 0.0248 |
| Florissant | 97 | 0.0248 |
| Winter Park | 95 | 0.0243 |
| Lovlenad | 95 | 0.0243 |
| Nederland | 87 | 0.0223 |
| Divide | 83 | 0.0213 |
| Oak Creek | 80 | 0.0205 |
| Glenwood Spgs | 77 | 0.0197 |
| Federal Heights | 71 | 0.0182 |
| Crested Butte | 70 | 0.0179 |
| Franktown | 69 | 0.0177 |
| Dacono | 68 | 0.0174 |
| Hudson | 67 | 0.0172 |
| Dillon | 66 | 0.0169 |
| Lone Treet | 65 | 0.0166 |
| Haxton | 64 | 0.0164 |
| Wheatridge | 63 | 0.0161 |
| Clifton | 62 | 0.0159 |
| Palmer Lake | 60 | 0.0154 |
| Towaoc | 59 | 0.0151 |
| Sheridan | 55 | 0.0141 |
| Morrison | 55 | 0.0141 |
| Cripple Creek | 51 | 0.0131 |
| Laporte | 50 | 0.0128 |
| San Luis | 42 | 0.0108 |
| Peterson Space Force Base | 40 | 0.0102 |
| Haxtun | 36 | 0.0092 |
| Ft Collins | 36 | 0.0092 |
| Byers | 30 | 0.0077 |
| Wiley | 29 | 0.0074 |
| Lake City | 28 | 0.0072 |
| Kiowa | 25 | 0.0064 |
| Black Hawk | 25 | 0.0064 |
| Livermore | 24 | 0.0061 |
| Dolores | 24 | 0.0061 |
| Falcon | 22 | 0.0056 |
| Colo Sprgs | 22 | 0.0056 |
| Holly | 21 | 0.0054 |
| Fairplay | 21 | 0.0054 |
| Snowmass Village | 17 | 0.0044 |
| Berthoud | 15 | 0.0038 |
| Fraser | 14 | 0.0036 |
| Milliken | 13 | 0.0033 |
| Ft. Carson | 12 | 0.0031 |
| Bennett | 12 | 0.0031 |
| Edgewater | 11 | 0.0028 |
| Ft. Collins | 10 | 0.0026 |
| Cimarron | 10 | 0.0026 |
| Steamboat Spgs | 9 | 0.0023 |
| Silt | 9 | 0.0023 |
| Colo Springs | 9 | 0.0023 |
| Usafa | 8 | 0.002 |
| Keenesberg | 8 | 0.002 |
| Greenwood Vlg | 8 | 0.002 |
| Colorado Spings | 8 | 0.002 |
| Greenley | 7 | 0.0018 |
| Apple Valley | 7 | 0.0018 |
| Vona | 6 | 0.0015 |
| Greely | 6 | 0.0015 |
| Idaho Springs | 5 | 0.0013 |
| Highland Ranch | 5 | 0.0013 |
| Dove Creek | 5 | 0.0013 |
| Tabernash | 4 | 0.001 |
| La Salle | 4 | 0.001 |
| Gypsum | 4 | 0.001 |
| Buckley Afb | 4 | 0.001 |
| Bellvue | 4 | 0.001 |
| Dublin | 3 | 0.0008 |
| Penrose | 2 | 0.0005 |
| Guffey | 2 | 0.0005 |
| Foxfield | 2 | 0.0005 |
| Co Springs | 2 | 0.0005 |
| Bailey | 2 | 0.0005 |
| Antonito | 2 | 0.0005 |
| U S A F Academy | 1 | 0.0003 |
| Stratton | 1 | 0.0003 |
| Severance | 1 | 0.0003 |
| Security | 1 | 0.0003 |
| Paonia | 1 | 0.0003 |
| Olathe | 1 | 0.0003 |
| Northgelnn | 1 | 0.0003 |
| North Glenn | 1 | 0.0003 |
| Montebello | 1 | 0.0003 |
| Lyons | 1 | 0.0003 |
| Lovleand | 1 | 0.0003 |
| Keystone | 1 | 0.0003 |
| Georgetown | 1 | 0.0003 |
| Fowler | 1 | 0.0003 |
| El Jebel | 1 | 0.0003 |
| Crestone | 1 | 0.0003 |
| Cascade | 1 | 0.0003 |
| Alma | 1 | 0.0003 |

_226 row(s) returned._

### [2.3] Categorical distribution: Prscrbr_Type

Distinct values of Prscrbr_Type (prescriber specialty) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| Family Practice | 112120 | 28.7139 |
| Nurse Practitioner | 80078 | 20.5079 |
| Internal Medicine | 62451 | 15.9937 |
| Physician Assistant | 50431 | 12.9154 |
| Cardiology | 6222 | 1.5935 |
| Psychiatry | 6210 | 1.5904 |
| Neurology | 5444 | 1.3942 |
| Dentist | 3970 | 1.0167 |
| Emergency Medicine | 3932 | 1.007 |
| Ophthalmology | 3529 | 0.9038 |
| Dermatology | 3407 | 0.8725 |
| Geriatric Medicine | 2936 | 0.7519 |
| Endocrinology | 2885 | 0.7388 |
| Hematology-Oncology | 2640 | 0.6761 |
| Pulmonary Disease | 2510 | 0.6428 |
| Urology | 2479 | 0.6349 |
| Rheumatology | 2405 | 0.6159 |
| Nephrology | 2319 | 0.5939 |
| Hospitalist | 2306 | 0.5906 |
| Gastroenterology | 2305 | 0.5903 |
| Optometry | 2297 | 0.5883 |
| Interventional Cardiology | 2276 | 0.5829 |
| Physical Medicine and Rehabilitation | 1765 | 0.452 |
| Orthopedic Surgery | 1711 | 0.4382 |
| Psychiatry & Neurology | 1692 | 0.4333 |
| Infectious Disease | 1593 | 0.408 |
| Obstetrics & Gynecology | 1451 | 0.3716 |
| Otolaryngology | 1390 | 0.356 |
| Student in an Organized Health Care Education/Training Program | 1271 | 0.3255 |
| Medical Oncology | 1108 | 0.2838 |
| Critical Care (Intensivists) | 1065 | 0.2727 |
| General Practice | 1053 | 0.2697 |
| Allergy/ Immunology | 976 | 0.25 |
| Clinical Cardiac Electrophysiology | 956 | 0.2448 |
| Podiatry | 833 | 0.2133 |
| Osteopathic Manipulative Medicine | 785 | 0.201 |
| General Surgery | 740 | 0.1895 |
| Certified Clinical Nurse Specialist | 723 | 0.1852 |
| Oral Surgery (Dentist only) | 636 | 0.1629 |
| Pediatric Medicine | 553 | 0.1416 |
| Pain Management | 464 | 0.1188 |
| Family Medicine | 422 | 0.1081 |
| Hospice and Palliative Care | 373 | 0.0955 |
| Anesthesiology | 302 | 0.0773 |
| Neuropsychiatry | 299 | 0.0766 |
| Pharmacist | 273 | 0.0699 |
| Advanced Heart Failure and Transplant Cardiology | 239 | 0.0612 |
| Hematopoietic Cell Transplantation and Cellular Therapy | 192 | 0.0492 |
| Interventional Pain Management | 189 | 0.0484 |
| Radiation Oncology | 180 | 0.0461 |
| Vascular Surgery | 139 | 0.0356 |
| Sleep Medicine | 139 | 0.0356 |
| Specialist | 118 | 0.0302 |
| Program of All-Inclusive Care for the Elderly (PACE) Provider Organization | 117 | 0.03 |
| Sports Medicine | 115 | 0.0295 |
| Certified Registered Nurse Anesthetist (CRNA) | 115 | 0.0295 |
| Registered Nurse | 101 | 0.0259 |
| Plastic and Reconstructive Surgery | 95 | 0.0243 |
| Neurosurgery | 87 | 0.0223 |
| Adult Congenital Heart Disease | 82 | 0.021 |
| Certified Nurse Midwife | 75 | 0.0192 |
| Oral & Maxillofacial Surgery | 71 | 0.0182 |
| Micrographic Dermatologic Surgery | 64 | 0.0164 |
| Colorectal Surgery (Proctology) | 61 | 0.0156 |
| Gynecological Oncology | 57 | 0.0146 |
| Orthopaedic Surgery | 52 | 0.0133 |
| Plastic Surgery | 51 | 0.0131 |
| Hematology | 47 | 0.012 |
| Hand Surgery | 46 | 0.0118 |
| Interventional Radiology | 42 | 0.0108 |
| Surgical Oncology | 41 | 0.0105 |
| Preventive Medicine | 41 | 0.0105 |
| Addiction Medicine | 40 | 0.0102 |
| Nuclear Medicine | 36 | 0.0092 |
| Epileptologists | 34 | 0.0087 |
| Pathology | 25 | 0.0064 |
| Geriatric Psychiatry | 25 | 0.0064 |
| Clinic/Center | 23 | 0.0059 |
| Licensed Professional Counselor | 22 | 0.0056 |
| Maxillofacial Surgery | 20 | 0.0051 |
| Thoracic Surgery | 19 | 0.0049 |
| Diagnostic Radiology | 15 | 0.0038 |
| Neurological Surgery | 14 | 0.0036 |
| Medical Genetics and Genomics | 12 | 0.0031 |
| Oral Medicinist | 11 | 0.0028 |
| Cardiac Surgery | 10 | 0.0026 |
| Legal Medicine | 5 | 0.0013 |
| Surgery | 4 | 0.001 |
| Medical Toxicology | 3 | 0.0008 |
| Psychologist, Clinical | 2 | 0.0005 |
| Physical Medicine & Rehabilitation | 2 | 0.0005 |
| Neuromusculoskeletal Medicine, Sports Medicine | 2 | 0.0005 |
| Dental Hygienist | 2 | 0.0005 |
| Counselor | 2 | 0.0005 |
| Pediatrics | 1 | 0.0003 |
| Naturopath | 1 | 0.0003 |
| Licensed Practical Nurse | 1 | 0.0003 |

_97 row(s) returned._

### [2.4] Categorical distribution: Prscrbr_Type_Src

Distinct values of Prscrbr_Type_Src (specialty source) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| Claim-Specialty | 344460 | 88.2161 |
| NPPES-Specialty | 40016 | 10.2481 |
| NPPES-Taxonomy | 5997 | 1.5358 |

_3 row(s) returned._

### [2.5] Categorical distribution: Brnd_Name

Distinct values of Brnd_Name (drug brand name) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| Gabapentin | 6447 | 1.6511 |
| Atorvastatin Calcium | 6131 | 1.5701 |
| Lisinopril | 5504 | 1.4096 |
| Amlodipine Besylate | 5479 | 1.4032 |
| Levothyroxine Sodium | 5305 | 1.3586 |
| Losartan Potassium | 5146 | 1.3179 |
| Omeprazole | 4968 | 1.2723 |
| Prednisone | 4728 | 1.2108 |
| Trazodone Hcl | 4641 | 1.1886 |
| Rosuvastatin Calcium | 4544 | 1.1637 |
| Albuterol Sulfate Hfa | 4504 | 1.1535 |
| Pantoprazole Sodium | 4426 | 1.1335 |
| Oxycodone Hcl | 4352 | 1.1145 |
| Furosemide | 4308 | 1.1033 |
| Metoprolol Succinate | 4288 | 1.0982 |
| Metformin Hcl | 4242 | 1.0864 |
| Tramadol Hcl | 4105 | 1.0513 |
| Tamsulosin Hcl | 4094 | 1.0485 |
| Hydrocodone-Acetaminophen | 4094 | 1.0485 |
| Duloxetine Hcl | 3974 | 1.0177 |
| Hydrochlorothiazide | 3972 | 1.0172 |
| Eliquis | 3970 | 1.0167 |
| Sertraline Hcl | 3900 | 0.9988 |
| Potassium Chloride | 3598 | 0.9214 |
| Escitalopram Oxalate | 3442 | 0.8815 |
| Meloxicam | 3341 | 0.8556 |
| Metoprolol Tartrate | 3270 | 0.8374 |
| Simvastatin | 3263 | 0.8357 |
| Amoxicillin-Clavulanate Potass | 3184 | 0.8154 |
| Carvedilol | 3040 | 0.7785 |
| Fluoxetine Hcl | 3016 | 0.7724 |
| Allopurinol | 2978 | 0.7627 |
| Cephalexin | 2941 | 0.7532 |
| Jardiance | 2922 | 0.7483 |
| Amoxicillin | 2907 | 0.7445 |
| Fluticasone Propionate | 2906 | 0.7442 |
| Alendronate Sodium | 2897 | 0.7419 |
| Spironolactone | 2883 | 0.7383 |
| Bupropion Xl | 2832 | 0.7253 |
| Famotidine | 2808 | 0.7191 |
| Pregabalin | 2756 | 0.7058 |
| Metformin Hcl Er | 2697 | 0.6907 |
| Montelukast Sodium | 2655 | 0.6799 |
| Clopidogrel | 2572 | 0.6587 |
| Zolpidem Tartrate | 2570 | 0.6582 |
| Cyclobenzaprine Hcl | 2553 | 0.6538 |
| Citalopram Hbr | 2527 | 0.6472 |
| Lorazepam | 2514 | 0.6438 |
| Venlafaxine Hcl Er | 2472 | 0.6331 |
| Ozempic | 2459 | 0.6297 |
| Lisinopril-Hydrochlorothiazide | 2336 | 0.5982 |
| Ondansetron Odt | 2285 | 0.5852 |
| Celecoxib | 2283 | 0.5847 |
| Xarelto | 2278 | 0.5834 |
| Triamcinolone Acetonide | 2254 | 0.5772 |
| Mirtazapine | 2220 | 0.5685 |
| Doxycycline Hyclate | 2215 | 0.5673 |
| Pravastatin Sodium | 2184 | 0.5593 |
| Finasteride | 2178 | 0.5578 |
| Alprazolam | 2172 | 0.5562 |
| Clonazepam | 2164 | 0.5542 |
| Azithromycin | 2149 | 0.5504 |
| Estradiol | 2126 | 0.5445 |
| Quetiapine Fumarate | 2103 | 0.5386 |
| Oxycodone-Acetaminophen | 2085 | 0.534 |
| Ezetimibe | 2046 | 0.524 |
| Buspirone Hcl | 1979 | 0.5068 |
| Losartan-Hydrochlorothiazide | 1915 | 0.4904 |
| Tizanidine Hcl | 1816 | 0.4651 |
| Hydroxyzine Hcl | 1773 | 0.4541 |
| Atenolol | 1771 | 0.4536 |
| Warfarin Sodium | 1753 | 0.4489 |
| Propranolol Hcl | 1676 | 0.4292 |
| Lantus Solostar | 1661 | 0.4254 |
| Trulicity | 1637 | 0.4192 |
| Synthroid | 1609 | 0.4121 |
| Nitrofurantoin Mono-Macro | 1607 | 0.4116 |
| Methocarbamol | 1563 | 0.4003 |
| Baclofen | 1523 | 0.39 |
| Diclofenac Sodium | 1499 | 0.3839 |
| Donepezil Hcl | 1494 | 0.3826 |
| Lamotrigine | 1468 | 0.376 |
| Sulfamethoxazole-Trimethoprim | 1425 | 0.3649 |
| Acyclovir | 1405 | 0.3598 |
| Ibuprofen | 1385 | 0.3547 |
| Amitriptyline Hcl | 1378 | 0.3529 |
| Fluticasone-Salmeterol | 1375 | 0.3521 |
| Valacyclovir | 1318 | 0.3375 |
| Glipizide | 1308 | 0.335 |
| Mounjaro | 1296 | 0.3319 |
| Diazepam | 1257 | 0.3219 |
| Methylprednisolone | 1200 | 0.3073 |
| Triamterene-Hydrochlorothiazid | 1183 | 0.303 |
| Ondansetron Hcl | 1179 | 0.3019 |
| Trelegy Ellipta | 1143 | 0.2927 |
| Ropinirole Hcl | 1132 | 0.2899 |
| Myrbetriq | 1121 | 0.2871 |
| Aripiprazole | 1109 | 0.284 |
| Paroxetine Hcl | 1103 | 0.2825 |
| Oxybutynin Chloride Er | 1087 | 0.2784 |
| Farxiga | 1085 | 0.2779 |
| Latanoprost | 1083 | 0.2774 |
| Topiramate | 1062 | 0.272 |
| Olanzapine | 1015 | 0.2599 |
| Diltiazem 24hr Er (Cd) | 1004 | 0.2571 |
| Sumatriptan Succinate | 994 | 0.2546 |
| Lovastatin | 981 | 0.2512 |
| Nystatin | 963 | 0.2466 |
| Morphine Sulfate Er | 963 | 0.2466 |
| Ipratropium Bromide | 943 | 0.2415 |
| Chlorthalidone | 939 | 0.2405 |
| Levetiracetam | 935 | 0.2395 |
| Symbicort | 925 | 0.2369 |
| Memantine Hcl | 897 | 0.2297 |
| Hydralazine Hcl | 895 | 0.2292 |
| Valsartan | 889 | 0.2277 |
| Pioglitazone Hcl | 879 | 0.2251 |
| Olmesartan Medoxomil | 857 | 0.2195 |
| Fenofibrate | 854 | 0.2187 |
| Risperidone | 851 | 0.2179 |
| Spiriva Respimat | 826 | 0.2115 |
| Fluconazole | 821 | 0.2103 |
| Glipizide Er | 809 | 0.2072 |
| Ciprofloxacin Hcl | 809 | 0.2072 |
| Mupirocin | 783 | 0.2005 |
| Ventolin Hfa | 776 | 0.1987 |
| Clobetasol Propionate | 755 | 0.1934 |
| Cefuroxime | 745 | 0.1908 |
| Pramipexole Dihydrochloride | 741 | 0.1898 |
| Bupropion Hcl Sr | 740 | 0.1895 |
| Januvia | 737 | 0.1887 |
| Esomeprazole Magnesium | 734 | 0.188 |
| Clonidine Hcl | 727 | 0.1862 |
| Doxazosin Mesylate | 724 | 0.1854 |
| Ketoconazole | 712 | 0.1823 |
| Lidocaine | 708 | 0.1813 |
| Paxlovid | 680 | 0.1741 |
| Azelastine Hcl | 680 | 0.1741 |
| Dextroamphetamine-Amphetamine | 669 | 0.1713 |
| Chlorhexidine Gluconate | 643 | 0.1647 |
| Hydrocortisone | 641 | 0.1642 |
| Oxybutynin Chloride | 640 | 0.1639 |
| Dicyclomine Hcl | 626 | 0.1603 |
| Naproxen | 623 | 0.1596 |
| Divalproex Sodium | 620 | 0.1588 |
| Bumetanide | 619 | 0.1585 |
| Breo Ellipta | 602 | 0.1542 |
| Carbidopa-Levodopa | 593 | 0.1519 |
| Irbesartan | 579 | 0.1483 |
| Isosorbide Mononitrate Er | 563 | 0.1442 |
| Doxycycline Monohydrate | 563 | 0.1442 |
| Repatha Sureclick | 561 | 0.1437 |
| Shingrix | 554 | 0.1419 |
| Temazepam | 553 | 0.1416 |
| Solifenacin Succinate | 541 | 0.1385 |
| Glimepiride | 535 | 0.137 |
| Dexamethasone | 535 | 0.137 |
| Hydromorphone Hcl | 533 | 0.1365 |
| Linzess | 514 | 0.1316 |
| Entresto | 513 | 0.1314 |
| Timolol Maleate | 509 | 0.1304 |
| Nitroglycerin | 505 | 0.1293 |
| Eszopiclone | 505 | 0.1293 |
| Amiodarone Hcl | 505 | 0.1293 |
| Arexvy | 497 | 0.1273 |
| Prazosin Hcl | 492 | 0.126 |
| Propranolol Hcl Er | 484 | 0.124 |
| Nortriptyline Hcl | 481 | 0.1232 |
| Progesterone | 479 | 0.1227 |
| Wixela Inhub | 477 | 0.1222 |
| Prednisolone Acetate | 477 | 0.1222 |
| Torsemide | 475 | 0.1216 |
| Testosterone Cypionate | 473 | 0.1211 |
| Sucralfate | 471 | 0.1206 |
| Divalproex Sodium Er | 470 | 0.1204 |
| Dorzolamide-Timolol | 461 | 0.1181 |
| Spiriva Handihaler | 453 | 0.116 |
| Anoro Ellipta | 443 | 0.1135 |
| Clindamycin Hcl | 423 | 0.1083 |
| Liothyronine Sodium | 422 | 0.1081 |
| Pradaxa | 419 | 0.1073 |
| Brimonidine Tartrate | 418 | 0.107 |
| Benazepril Hcl | 416 | 0.1065 |
| Nebivolol Hcl | 412 | 0.1055 |
| Levofloxacin | 412 | 0.1055 |
| Primidone | 388 | 0.0994 |
| Colchicine | 380 | 0.0973 |
| Insulin Glargine-Yfgn | 379 | 0.0971 |
| Advair Hfa | 376 | 0.0963 |
| Dextroamphetamine-Amphet Er | 371 | 0.095 |
| Fentanyl | 368 | 0.0942 |
| Methylphenidate Hcl | 366 | 0.0937 |
| Cefdinir | 366 | 0.0937 |
| Metronidazole | 362 | 0.0927 |
| Buprenorphine-Naloxone | 361 | 0.0925 |
| Morphine Sulfate | 360 | 0.0922 |
| Verapamil Er | 354 | 0.0907 |
| Digoxin | 352 | 0.0901 |
| Adacel Tdap | 351 | 0.0899 |
| Acetaminophen-Codeine | 350 | 0.0896 |
| Doxepin Hcl | 346 | 0.0886 |
| Oxcarbazepine | 342 | 0.0876 |
| Stiolto Respimat | 339 | 0.0868 |
| Buprenorphine | 339 | 0.0868 |
| Tradjenta | 336 | 0.086 |
| Benztropine Mesylate | 336 | 0.086 |
| Terazosin Hcl | 334 | 0.0855 |
| Midodrine Hcl | 330 | 0.0845 |
| Desvenlafaxine Succinate Er | 322 | 0.0825 |
| Lactulose | 319 | 0.0817 |
| Oxycontin | 316 | 0.0809 |
| Lurasidone Hcl | 316 | 0.0809 |
| Methenamine Hippurate | 315 | 0.0807 |
| Restasis | 314 | 0.0804 |
| Hydroxychloroquine Sulfate | 312 | 0.0799 |
| Clozapine | 312 | 0.0799 |
| Breztri Aerosphere | 312 | 0.0799 |
| Testosterone | 310 | 0.0794 |
| Nano 2nd Gen Pen Needle | 310 | 0.0794 |
| Incruse Ellipta | 305 | 0.0781 |
| Gemtesa | 305 | 0.0781 |
| Erythromycin | 303 | 0.0776 |
| Anastrozole | 303 | 0.0776 |
| Meclizine Hcl | 302 | 0.0773 |
| Nifedipine Er | 300 | 0.0768 |
| Fluorouracil | 294 | 0.0753 |
| Valsartan-Hydrochlorothiazide | 292 | 0.0748 |
| Basaglar Kwikpen U-100 | 292 | 0.0748 |
| Promethazine Hcl | 288 | 0.0738 |
| Insulin Syringe | 286 | 0.0732 |
| Hydroxyzine Pamoate | 286 | 0.0732 |
| Lantus | 285 | 0.073 |
| Methotrexate | 284 | 0.0727 |
| Rizatriptan | 283 | 0.0725 |
| Lacosamide | 282 | 0.0722 |
| Flecainide Acetate | 280 | 0.0717 |
| Alvesco | 279 | 0.0715 |
| Neomycin-Polymyxin-Dexameth | 277 | 0.0709 |
| Tresiba Flextouch U-100 | 272 | 0.0697 |
| Prochlorperazine Maleate | 267 | 0.0684 |
| Methadone Hcl | 263 | 0.0674 |
| Lithium Carbonate | 260 | 0.0666 |
| Carbamazepine | 258 | 0.0661 |
| Vraylar | 255 | 0.0653 |
| Humulin N | 253 | 0.0648 |
| Trospium Chloride | 249 | 0.0638 |
| Creon | 245 | 0.0627 |
| Dupixent Pen | 243 | 0.0622 |
| Vitamin D2 | 241 | 0.0617 |
| Bupropion Hcl | 241 | 0.0617 |
| Xtampza Er | 239 | 0.0612 |
| Alfuzosin Hcl Er | 238 | 0.061 |
| Humalog Kwikpen U-100 | 236 | 0.0604 |
| Butalbital-Acetaminophen-Caffe | 235 | 0.0602 |
| Ibandronate Sodium | 234 | 0.0599 |
| Naloxone Hcl | 233 | 0.0597 |
| Ofloxacin | 232 | 0.0594 |
| Bisoprolol Fumarate | 232 | 0.0594 |
| Novolog Flexpen | 231 | 0.0592 |
| Ketorolac Tromethamine | 231 | 0.0592 |
| Lithium Carbonate Er | 230 | 0.0589 |
| Ramipril | 228 | 0.0584 |
| Rybelsus | 227 | 0.0581 |
| Telmisartan | 226 | 0.0579 |
| Calcitriol | 226 | 0.0579 |
| Lumigan | 220 | 0.0563 |
| Clindamycin Phosphate | 220 | 0.0563 |
| Amlodipine Besylate-Benazepril | 220 | 0.0563 |
| Insulin Lispro Kwikpen U-100 | 218 | 0.0558 |
| Dorzolamide Hcl | 213 | 0.0545 |
| Mycophenolate Mofetil | 212 | 0.0543 |
| Ziprasidone Hcl | 211 | 0.054 |
| Terbinafine Hcl | 211 | 0.054 |
| Dutasteride | 210 | 0.0538 |
| Azathioprine | 210 | 0.0538 |
| Letrozole | 209 | 0.0535 |
| Lansoprazole | 208 | 0.0533 |
| Enalapril Maleate | 208 | 0.0533 |
| Arnuity Ellipta | 208 | 0.0533 |
| Nurtec Odt | 206 | 0.0528 |
| Methimazole | 205 | 0.0525 |
| Ciclopirox | 204 | 0.0522 |
| Venlafaxine Hcl | 202 | 0.0517 |
| Minoxidil | 202 | 0.0517 |
| Haloperidol | 202 | 0.0517 |
| Carbamazepine Er | 196 | 0.0502 |
| Combivent Respimat | 194 | 0.0497 |
| Fluocinonide | 192 | 0.0492 |
| Cyclosporine | 191 | 0.0489 |
| Belsomra | 191 | 0.0489 |
| Sotalol | 190 | 0.0487 |
| Sildenafil Citrate | 190 | 0.0487 |
| Naltrexone Hcl | 190 | 0.0487 |
| Estradiol (Twice Weekly) | 190 | 0.0487 |
| Boostrix Tdap | 190 | 0.0487 |
| Hydroxyurea | 188 | 0.0481 |
| Dulera | 188 | 0.0481 |
| Budesonide Dr | 188 | 0.0481 |
| Diphenoxylate-Atropine | 187 | 0.0479 |
| Invega Sustenna | 186 | 0.0476 |
| Tramadol Hcl Er | 183 | 0.0469 |
| Belbuca | 182 | 0.0466 |
| Xifaxan | 181 | 0.0464 |
| Carbidopa-Levodopa Er | 181 | 0.0464 |
| Varenicline Tartrate | 180 | 0.0461 |
| Levocetirizine Dihydrochloride | 180 | 0.0461 |
| Labetalol Hcl | 178 | 0.0456 |
| Fluorometholone | 173 | 0.0443 |
| Amantadine | 173 | 0.0443 |
| Metoclopramide Hcl | 169 | 0.0433 |
| Tadalafil | 168 | 0.043 |
| Enoxaparin Sodium | 168 | 0.043 |
| Budesonide-Formoterol Fumarate | 168 | 0.043 |
| Gemfibrozil | 167 | 0.0428 |
| Tacrolimus | 165 | 0.0423 |
| Praluent Pen | 165 | 0.0423 |
| Humira(Cf) Pen | 164 | 0.042 |
| Tresiba Flextouch U-200 | 163 | 0.0417 |
| Quetiapine Fumarate Er | 163 | 0.0417 |
| Potassium Citrate Er | 163 | 0.0417 |
| Clotrimazole-Betamethasone | 163 | 0.0417 |
| Lidocaine-Prilocaine | 161 | 0.0412 |
| Buprenorphine Hcl | 160 | 0.041 |
| Aimovig Autoinjector | 159 | 0.0407 |
| Modafinil | 158 | 0.0405 |
| Cholestyramine | 158 | 0.0405 |
| Ursodiol | 157 | 0.0402 |
| Zonisamide | 156 | 0.04 |
| Sevelamer Carbonate | 156 | 0.04 |
| Folic Acid | 156 | 0.04 |
| Breyna | 156 | 0.04 |
| Dabigatran Etexilate | 155 | 0.0397 |
| Carisoprodol | 155 | 0.0397 |
| Brimonidine Tartrate-Timolol | 155 | 0.0397 |
| Trintellix | 153 | 0.0392 |
| Rexulti | 152 | 0.0389 |
| Abrysvo | 151 | 0.0387 |
| Dexlansoprazole Dr | 149 | 0.0382 |
| Paliperidone Er | 148 | 0.0379 |
| Ranolazine Er | 146 | 0.0374 |
| Ingrezza | 146 | 0.0374 |
| Toujeo Solostar | 145 | 0.0371 |
| Emgality Pen | 145 | 0.0371 |
| Zolpidem Tartrate Er | 144 | 0.0369 |
| Mesalamine | 144 | 0.0369 |
| Ultra-Fine Short Pen Needle | 142 | 0.0364 |
| Droplet Pen Needle | 142 | 0.0364 |
| Premarin | 141 | 0.0361 |
| Tamoxifen Citrate | 140 | 0.0359 |
| Lubiprostone | 139 | 0.0356 |
| Humalog | 138 | 0.0353 |
| Moxifloxacin | 136 | 0.0348 |
| Vascepa | 133 | 0.0341 |
| Levemir Flexpen | 132 | 0.0338 |
| Abiraterone Acetate | 132 | 0.0338 |
| Rivastigmine | 131 | 0.0335 |
| Nitrofurantoin | 131 | 0.0335 |
| Colestipol Hcl | 131 | 0.0335 |
| Phenytoin Sodium Extended | 128 | 0.0328 |
| Olmesartan-Hydrochlorothiazide | 128 | 0.0328 |
| Mometasone Furoate | 128 | 0.0328 |
| Loperamide | 127 | 0.0325 |
| Penicillin V Potassium | 126 | 0.0323 |
| Metolazone | 126 | 0.0323 |
| Cefadroxil | 126 | 0.0323 |
| Klor-Con M20 | 125 | 0.032 |
| Movantik | 124 | 0.0318 |
| Armour Thyroid | 123 | 0.0315 |
| Ipratropium-Albuterol | 120 | 0.0307 |
| Methylphenidate Er | 119 | 0.0305 |
| Diltiazem 24hr Er | 119 | 0.0305 |
| Xiidra | 118 | 0.0302 |
| Humulin R | 118 | 0.0302 |
| Gavilyte-C | 118 | 0.0302 |
| Biktarvy | 116 | 0.0297 |
| Atomoxetine Hcl | 116 | 0.0297 |
| Ultra-Fine Mini Pen Needle | 115 | 0.0295 |
| Raloxifene Hcl | 115 | 0.0295 |
| Omega-3 Acid Ethyl Esters | 115 | 0.0295 |
| Dupixent Syringe | 115 | 0.0295 |
| Leflunomide | 113 | 0.0289 |
| Ubrelvy | 112 | 0.0287 |
| Sod Sulf-Potass Sulf-Mag Sulf | 112 | 0.0287 |
| Travoprost | 110 | 0.0282 |
| Fludrocortisone Acetate | 110 | 0.0282 |
| Vilazodone Hcl | 109 | 0.0279 |
| Sulfasalazine | 108 | 0.0277 |
| Eplerenone | 107 | 0.0274 |
| Combigan | 103 | 0.0264 |
| Fluvoxamine Maleate | 102 | 0.0261 |
| Peg 3350-Electrolyte | 101 | 0.0259 |
| Cefpodoxime Proxetil | 101 | 0.0259 |
| Tobramycin-Dexamethasone | 97 | 0.0248 |
| Pilocarpine Hcl | 97 | 0.0248 |
| Memantine Hcl Er | 97 | 0.0248 |
| Insulin Lispro | 97 | 0.0248 |
| Zenpep | 96 | 0.0246 |
| Rytary | 96 | 0.0246 |
| Qulipta | 96 | 0.0246 |
| Estradiol (Once Weekly) | 96 | 0.0246 |
| Enbrel Sureclick | 94 | 0.0241 |
| Olanzapine Odt | 93 | 0.0238 |
| Lisdexamfetamine Dimesylate | 93 | 0.0238 |
| Lenalidomide | 92 | 0.0236 |
| Brilinta | 91 | 0.0233 |
| Toujeo Max Solostar | 90 | 0.023 |
| Dofetilide | 89 | 0.0228 |
| Abilify Maintena | 89 | 0.0228 |
| Repatha Syringe | 88 | 0.0225 |
| Lokelma | 88 | 0.0225 |
| Ibu | 88 | 0.0225 |
| Mirabegron Er | 86 | 0.022 |
| Cinacalcet Hcl | 85 | 0.0218 |
| Calcium Acetate | 85 | 0.0218 |
| Ultra-Fine Nano Pen Needle | 84 | 0.0215 |
| Sodium Chloride | 84 | 0.0215 |
| Imiquimod | 84 | 0.0215 |
| Sutab | 83 | 0.0213 |
| Semglee (Yfgn) Pen | 83 | 0.0213 |
| Betamethasone Dipropionate | 83 | 0.0213 |
| Atropine Sulfate | 82 | 0.021 |
| Tolterodine Tartrate Er | 81 | 0.0207 |
| Tiotropium Bromide | 81 | 0.0207 |
| Prolia | 81 | 0.0207 |
| Desmopressin Acetate | 80 | 0.0205 |
| Xtandi | 79 | 0.0202 |
| Imbruvica | 79 | 0.0202 |
| Revlimid | 78 | 0.02 |
| Lidocaine Hcl Viscous | 78 | 0.02 |
| Invokana | 78 | 0.02 |
| Phenobarbital | 77 | 0.0197 |
| Lamotrigine Er | 77 | 0.0197 |
| Diltiazem Hcl | 77 | 0.0197 |
| Medroxyprogesterone Acetate | 76 | 0.0195 |
| Rinvoq | 75 | 0.0192 |
| Omnipod 5 Dexg7g6 Pods (Gen 5) | 75 | 0.0192 |
| Guanfacine Hcl Er | 75 | 0.0192 |
| Exemestane | 75 | 0.0192 |
| Descovy | 75 | 0.0192 |
| Clotrimazole | 75 | 0.0192 |
| Levetiracetam Er | 74 | 0.019 |
| Gavilyte-G | 74 | 0.019 |
| Betamethasone Diprop Augmented | 74 | 0.019 |
| Austedo | 74 | 0.019 |
| Simbrinza | 73 | 0.0187 |
| Pyridostigmine Bromide | 73 | 0.0187 |
| Nabumetone | 73 | 0.0187 |
| Indomethacin | 73 | 0.0187 |
| Clonidine | 73 | 0.0187 |
| Tymlos | 72 | 0.0184 |
| Tretinoin | 72 | 0.0184 |
| Tivicay | 72 | 0.0184 |
| Peg-3350 And Electrolytes | 72 | 0.0184 |
| Otezla | 72 | 0.0184 |
| Vyvanse | 71 | 0.0182 |
| Multaq | 71 | 0.0182 |
| Haloperidol Decanoate | 71 | 0.0182 |
| Dotti | 70 | 0.0179 |
| Trihexyphenidyl Hcl | 69 | 0.0177 |
| Ramelteon | 69 | 0.0177 |
| Jakafi | 69 | 0.0177 |
| Cilostazol | 69 | 0.0177 |
| Prasugrel Hcl | 68 | 0.0174 |
| Ofev | 68 | 0.0174 |
| Novolog | 68 | 0.0174 |
| Clobazam | 68 | 0.0174 |
| Calquence | 68 | 0.0174 |
| Ajovy Autoinjector | 68 | 0.0174 |
| Advair Diskus | 68 | 0.0174 |
| Dapagliflozin | 67 | 0.0172 |
| Valproic Acid | 66 | 0.0169 |
| Orgovyx | 66 | 0.0169 |
| Np Thyroid | 66 | 0.0169 |
| Ceftriaxone | 66 | 0.0169 |
| Albuterol Sulfate | 66 | 0.0169 |
| Caplyta | 65 | 0.0166 |
| Brukinsa | 65 | 0.0166 |
| Risedronate Sodium | 64 | 0.0164 |
| Minocycline Hcl | 64 | 0.0164 |
| Epinephrine | 64 | 0.0164 |
| Zaleplon | 63 | 0.0161 |
| Trimethoprim | 63 | 0.0161 |
| Triazolam | 63 | 0.0161 |
| Forteo | 63 | 0.0161 |
| Ammonium Lactate | 63 | 0.0161 |
| Rhopressa | 62 | 0.0159 |
| Ibrance | 62 | 0.0159 |
| Qvar Redihaler | 61 | 0.0156 |
| Humira Pen | 61 | 0.0156 |
| Glycopyrrolate | 61 | 0.0156 |
| Dalfampridine Er | 61 | 0.0156 |
| Yuvafem | 60 | 0.0154 |
| Dropsafe Prep Pads | 60 | 0.0154 |
| Acetazolamide | 60 | 0.0154 |
| Vancomycin Hcl | 59 | 0.0151 |
| Fiasp Flextouch | 59 | 0.0151 |
| Silodosin | 58 | 0.0149 |
| Rabeprazole Sodium | 58 | 0.0149 |
| Teriparatide | 57 | 0.0146 |
| Roflumilast | 57 | 0.0146 |
| Janumet | 57 | 0.0146 |
| Febuxostat | 57 | 0.0146 |
| Cosentyx Sensoready (2 Pens) | 57 | 0.0146 |
| Perphenazine | 56 | 0.0143 |
| Briviact | 56 | 0.0143 |
| Atrovent Hfa | 56 | 0.0143 |
| Venclexta | 55 | 0.0141 |
| Imatinib Mesylate | 54 | 0.0138 |
| Fluphenazine Hcl | 54 | 0.0138 |
| Colesevelam Hcl | 54 | 0.0138 |
| Autoshield Duo Pen Needle | 54 | 0.0138 |
| Nucynta | 53 | 0.0136 |
| Suflave | 52 | 0.0133 |
| Stelara | 52 | 0.0133 |
| Rocklatan | 52 | 0.0133 |
| Mesalamine Er | 52 | 0.0133 |
| Fluticasone Propionate Hfa | 52 | 0.0133 |
| Candesartan Cilexetil | 52 | 0.0133 |
| Trulance | 51 | 0.0131 |
| Rasagiline Mesylate | 51 | 0.0131 |
| Klor-Con 10 | 50 | 0.0128 |
| Bisoprolol-Hydrochlorothiazide | 50 | 0.0128 |
| Scopolamine | 49 | 0.0125 |
| Enbrel | 49 | 0.0125 |
| Dextroamphetamine Sulfate | 49 | 0.0125 |
| Dayvigo | 49 | 0.0125 |
| Armodafinil | 49 | 0.0125 |
| Verapamil Hcl | 48 | 0.0123 |
| Tagrisso | 48 | 0.0123 |
| Polymyxin B Sul-Trimethoprim | 48 | 0.0123 |
| Naratriptan Hcl | 48 | 0.0123 |
| Isosorbide Dinitrate | 48 | 0.0123 |
| Sulfasalazine Dr | 47 | 0.012 |
| Orencia Clickject | 47 | 0.012 |
| Nucynta Er | 47 | 0.012 |
| Megestrol Acetate | 47 | 0.012 |
| Cyanocobalamin Injection | 47 | 0.012 |
| Ciprofloxacin-Dexamethasone | 47 | 0.012 |
| Cartia Xt | 47 | 0.012 |
| Nuedexta | 46 | 0.0118 |
| Motegrity | 46 | 0.0118 |
| Guanfacine Hcl | 46 | 0.0118 |
| Alphagan P | 46 | 0.0118 |
| Xeljanz | 45 | 0.0115 |
| Wegovy | 45 | 0.0115 |
| Vyndamax | 45 | 0.0115 |
| Tramadol Hcl-Acetaminophen | 45 | 0.0115 |
| Levalbuterol Tartrate Hfa | 45 | 0.0115 |
| Chlorpromazine Hcl | 45 | 0.0115 |
| Pentoxifylline | 44 | 0.0113 |
| Oseltamivir Phosphate | 44 | 0.0113 |
| Dovato | 44 | 0.0113 |
| Daptomycin | 44 | 0.0113 |
| Calcipotriene | 44 | 0.0113 |
| Triumeq | 43 | 0.011 |
| Taltz Autoinjector | 43 | 0.011 |
| Retin-A | 43 | 0.011 |
| Loteprednol Etabonate | 43 | 0.011 |
| Irbesartan-Hydrochlorothiazide | 43 | 0.011 |
| Bydureon Bcise | 43 | 0.011 |
| Suboxone | 42 | 0.0108 |
| Nuplazid | 42 | 0.0108 |
| Humulin N Kwikpen | 42 | 0.0108 |
| Cyproheptadine Hcl | 42 | 0.0108 |
| Vyzulta | 41 | 0.0105 |
| Pomalyst | 41 | 0.0105 |
| Felodipine Er | 41 | 0.0105 |
| Etodolac | 41 | 0.0105 |
| Erleada | 41 | 0.0105 |
| Dilt-Xr | 41 | 0.0105 |
| Cevimeline Hcl | 41 | 0.0105 |
| Bevespi Aerosphere | 41 | 0.0105 |
| Amlodipine-Olmesartan | 41 | 0.0105 |
| Calcitonin-Salmon | 40 | 0.0102 |
| Ambrisentan | 40 | 0.0102 |
| Sodium Fluoride | 39 | 0.01 |
| Nystop | 39 | 0.01 |
| Kerendia | 39 | 0.01 |
| Genvoya | 39 | 0.01 |
| Estring | 39 | 0.01 |
| Velphoro | 38 | 0.0097 |
| Lamictal | 38 | 0.0097 |
| Insulin Aspart Flexpen | 38 | 0.0097 |
| Icosapent Ethyl | 38 | 0.0097 |
| Humira(Cf) | 38 | 0.0097 |
| Fesoterodine Fumarate Er | 38 | 0.0097 |
| Xcopri | 37 | 0.0095 |
| Pirfenidone | 37 | 0.0095 |
| Mycophenolic Acid | 37 | 0.0095 |
| Gentamicin Sulfate | 37 | 0.0095 |
| Desonide | 37 | 0.0095 |
| Xeljanz Xr | 36 | 0.0092 |
| Verzenio | 36 | 0.0092 |
| Teriflunomide | 36 | 0.0092 |
| Leucovorin Calcium | 36 | 0.0092 |
| Austedo Xr | 36 | 0.0092 |
| Dimethyl Fumarate | 35 | 0.009 |
| Valganciclovir Hcl | 34 | 0.0087 |
| Soliqua 100-33 | 34 | 0.0087 |
| Nubeqa | 34 | 0.0087 |
| Imipramine Hcl | 34 | 0.0087 |
| Botox | 34 | 0.0087 |
| Amiloride Hcl | 34 | 0.0087 |
| Unithroid | 33 | 0.0085 |
| Sure Comfort Pen Needle | 33 | 0.0085 |
| Pen Needle | 33 | 0.0085 |
| Opsumit | 33 | 0.0085 |
| Humulin R U-500 Kwikpen | 33 | 0.0085 |
| Fluticasone-Vilanterol | 33 | 0.0085 |
| Diltiazem 24hr Er (Xr) | 33 | 0.0085 |
| Cefazolin Sodium | 33 | 0.0085 |
| Verapamil Sr | 32 | 0.0082 |
| Vemlidy | 32 | 0.0082 |
| Veltassa | 32 | 0.0082 |
| Spironolactone-Hctz | 32 | 0.0082 |
| Serevent Diskus | 32 | 0.0082 |
| Juluca | 32 | 0.0082 |
| Janumet Xr | 32 | 0.0082 |
| Emgality Syringe | 32 | 0.0082 |
| Clomipramine Hcl | 32 | 0.0082 |
| Kesimpta Pen | 31 | 0.0079 |
| Fluocinolone Acetonide | 31 | 0.0079 |
| Brinzolamide | 31 | 0.0079 |
| Bicalutamide | 31 | 0.0079 |
| Asenapine Maleate | 31 | 0.0079 |
| Tirosint | 30 | 0.0077 |
| Nucala | 30 | 0.0077 |
| Lybalvi | 30 | 0.0077 |
| Glyburide | 30 | 0.0077 |
| Entacapone | 30 | 0.0077 |
| Dilantin | 30 | 0.0077 |
| Difluprednate | 30 | 0.0077 |
| Climara | 30 | 0.0077 |
| Cholestyramine Light | 30 | 0.0077 |
| Budesonide | 30 | 0.0077 |
| Amlodipine-Valsartan | 30 | 0.0077 |
| Xolair | 29 | 0.0074 |
| Odefsey | 29 | 0.0074 |
| Neomycin Sulfate | 29 | 0.0074 |
| Miebo | 29 | 0.0074 |
| Jantoven | 29 | 0.0074 |
| Humalog Kwikpen U-200 | 29 | 0.0074 |
| Ertapenem | 29 | 0.0074 |
| Diltiazem 12hr Er | 29 | 0.0074 |
| Dapsone | 29 | 0.0074 |
| Aristada | 29 | 0.0074 |
| Adempas | 29 | 0.0074 |
| Actemra Actpen | 29 | 0.0074 |
| Ztlido | 28 | 0.0072 |
| Orencia | 28 | 0.0072 |
| Loxapine | 28 | 0.0072 |
| Enulose | 28 | 0.0072 |
| Diclofenac Potassium | 28 | 0.0072 |
| Clozapine Odt | 28 | 0.0072 |
| Balsalazide Disodium | 28 | 0.0072 |
| Zubsolv | 27 | 0.0069 |
| Risperdal Consta | 27 | 0.0069 |
| Quviviq | 27 | 0.0069 |
| Procto-Med Hc | 27 | 0.0069 |
| Prezcobix | 27 | 0.0069 |
| Humulin 70/30 Kwikpen | 27 | 0.0069 |
| Adderall Xr | 27 | 0.0069 |
| Tobramycin | 26 | 0.0067 |
| Gammagard Liquid | 26 | 0.0067 |
| Fycompa | 26 | 0.0067 |
| Fluocinolone Acetonide Oil | 26 | 0.0067 |
| Epidiolex | 26 | 0.0067 |
| Butalb-Acetaminoph-Caff-Codein | 26 | 0.0067 |
| Trospium Chloride Er | 25 | 0.0064 |
| Synjardy Xr | 25 | 0.0064 |
| Savella | 25 | 0.0064 |
| Nivestym | 25 | 0.0064 |
| Lidocaine Hcl | 25 | 0.0064 |
| Entecavir | 25 | 0.0064 |
| Diltiazem 24hr Er (La) | 25 | 0.0064 |
| Dextroamphetamine Sulfate Er | 25 | 0.0064 |
| Clorazepate Dipotassium | 25 | 0.0064 |
| Cabergoline | 25 | 0.0064 |
| Famciclovir | 24 | 0.0061 |
| Eletriptan Hbr | 24 | 0.0061 |
| Diphenhydramine Hcl | 24 | 0.0061 |
| Butrans | 24 | 0.0061 |
| Tafluprost | 23 | 0.0059 |
| Nyamyc | 23 | 0.0059 |
| Methotrexate Sodium | 23 | 0.0059 |
| Kisqali | 23 | 0.0059 |
| Amjevita(Cf) Autoinjector | 23 | 0.0059 |
| Rifampin | 22 | 0.0056 |
| Posaconazole | 22 | 0.0056 |
| Lynparza | 22 | 0.0056 |
| Fasenra Pen | 22 | 0.0056 |
| Benlysta | 22 | 0.0056 |
| Acamprosate Calcium | 22 | 0.0056 |
| Symtuza | 21 | 0.0054 |
| Selegiline Hcl | 21 | 0.0054 |
| Ritonavir | 21 | 0.0054 |
| Relistor | 21 | 0.0054 |
| Pitavastatin Calcium | 21 | 0.0054 |
| Neupro | 21 | 0.0054 |
| Lyrica | 21 | 0.0054 |
| Levoxyl | 21 | 0.0054 |
| Kevzara | 21 | 0.0054 |
| Fluphenazine Decanoate | 21 | 0.0054 |
| Fanapt | 21 | 0.0054 |
| Everolimus | 21 | 0.0054 |
| Victoza 3-Pak | 20 | 0.0051 |
| Tyrvaya | 20 | 0.0051 |
| Silver Sulfadiazine | 20 | 0.0051 |
| Repaglinide | 20 | 0.0051 |
| Novolog Mix 70-30 Flexpen | 20 | 0.0051 |
| Isentress | 20 | 0.0051 |
| Imvexxy | 20 | 0.0051 |
| Gamunex-C | 20 | 0.0051 |
| Fluticasone-Salmeterol Hfa | 20 | 0.0051 |
| Dicloxacillin Sodium | 20 | 0.0051 |
| Cromolyn Sodium | 20 | 0.0051 |
| Baqsimi | 20 | 0.0051 |
| Atovaquone-Proguanil Hcl | 20 | 0.0051 |
| Alprazolam Er | 20 | 0.0051 |
| Uptravi | 19 | 0.0049 |
| Tasigna | 19 | 0.0049 |
| Sprycel | 19 | 0.0049 |
| Rufinamide | 19 | 0.0049 |
| Nexlizet | 19 | 0.0049 |
| Nadolol | 19 | 0.0049 |
| Indapamide | 19 | 0.0049 |
| Fosinopril Sodium | 19 | 0.0049 |
| Aptiom | 19 | 0.0049 |
| Acitretin | 19 | 0.0049 |
| Xigduo Xr | 18 | 0.0046 |
| Veo Insulin Syringe | 18 | 0.0046 |
| Tetrabenazine | 18 | 0.0046 |
| Simponi | 18 | 0.0046 |
| Ropinirole Er | 18 | 0.0046 |
| Niacin Er | 18 | 0.0046 |
| Nayzilam | 18 | 0.0046 |
| Mexiletine Hcl | 18 | 0.0046 |
| Levemir | 18 | 0.0046 |
| Insulin Degludec Pen (U-100) | 18 | 0.0046 |
| Hysingla Er | 18 | 0.0046 |
| Felbamate | 18 | 0.0046 |
| Ethambutol Hcl | 18 | 0.0046 |
| Dexmethylphenidate Hcl Er | 18 | 0.0046 |
| Darunavir | 18 | 0.0046 |
| Cresemba | 18 | 0.0046 |
| Butalbital-Aspirin-Caffeine | 18 | 0.0046 |
| Betamethasone Valerate | 18 | 0.0046 |
| Vivitrol | 17 | 0.0044 |
| Veozah | 17 | 0.0044 |
| Theophylline Er | 17 | 0.0044 |
| Pulmicort Flexhaler | 17 | 0.0044 |
| Procrit | 17 | 0.0044 |
| Nexletol | 17 | 0.0044 |
| Keppra | 17 | 0.0044 |
| Jublia | 17 | 0.0044 |
| Fosfomycin Tromethamine | 17 | 0.0044 |
| Fingolimod | 17 | 0.0044 |
| Fetzima | 17 | 0.0044 |
| Copaxone | 17 | 0.0044 |
| Cimzia (2 Pack) | 17 | 0.0044 |
| Bimatoprost | 17 | 0.0044 |
| Bethanechol Chloride | 17 | 0.0044 |
| Benazepril-Hydrochlorothiazide | 17 | 0.0044 |
| Azelastine-Fluticasone | 17 | 0.0044 |
| Ajovy Syringe | 17 | 0.0044 |
| Acetic Acid | 17 | 0.0044 |
| Sulindac | 16 | 0.0041 |
| Ssd | 16 | 0.0041 |
| Risperidone Odt | 16 | 0.0041 |
| Restasis Multidose | 16 | 0.0041 |
| Prosol | 16 | 0.0041 |
| Prolastin C | 16 | 0.0041 |
| Probenecid | 16 | 0.0041 |
| Pifeltro | 16 | 0.0041 |
| Novolin 70-30 | 16 | 0.0041 |
| Lorazepam Intensol | 16 | 0.0041 |
| Livalo | 16 | 0.0041 |
| Levocarnitine | 16 | 0.0041 |
| Invega Trinza | 16 | 0.0041 |
| Hydromorphone Er | 16 | 0.0041 |
| Glatiramer Acetate | 16 | 0.0041 |
| Emtricitabine-Tenofovir Disop | 16 | 0.0041 |
| Droxidopa | 16 | 0.0041 |
| Cimetidine | 16 | 0.0041 |
| Budesonide Ec | 16 | 0.0041 |
| Acetazolamide Er | 16 | 0.0041 |
| Acarbose | 16 | 0.0041 |
| Xdemvy | 15 | 0.0038 |
| Vimpat | 15 | 0.0038 |
| Tolterodine Tartrate | 15 | 0.0038 |
| Riluzole | 15 | 0.0038 |
| Prevident | 15 | 0.0038 |
| Nystatin-Triamcinolone | 15 | 0.0038 |
| Kapspargo Sprinkle | 15 | 0.0038 |
| Hizentra | 15 | 0.0038 |
| Ezetimibe-Simvastatin | 15 | 0.0038 |
| Cosentyx Sensoready Pen | 15 | 0.0038 |
| Tezspire | 14 | 0.0036 |
| Spravato | 14 | 0.0036 |
| Skyrizi Pen | 14 | 0.0036 |
| Sirolimus | 14 | 0.0036 |
| Single Use Swab | 14 | 0.0036 |
| Promacta | 14 | 0.0036 |
| Prempro | 14 | 0.0036 |
| Phenytoin | 14 | 0.0036 |
| Norethindrone Acetate | 14 | 0.0036 |
| Metformin Er Osmotic | 14 | 0.0036 |
| Humulin 70-30 | 14 | 0.0036 |
| Cabometyx | 14 | 0.0036 |
| Auvelity | 14 | 0.0036 |
| Alecensa | 14 | 0.0036 |
| Viberzi | 13 | 0.0033 |
| Ultra-Fine Micro Pen Needle | 13 | 0.0033 |
| Ulticare Pen Needle | 13 | 0.0033 |
| Tranexamic Acid | 13 | 0.0033 |
| Tenofovir Disoproxil Fumarate | 13 | 0.0033 |
| Santyl | 13 | 0.0033 |
| Propafenone Hcl | 13 | 0.0033 |
| Pimecrolimus | 13 | 0.0033 |
| Oxtellar Xr | 13 | 0.0033 |
| Ocaliva | 13 | 0.0033 |
| Neomycin-Polymyxin-Hc | 13 | 0.0033 |
| Gammaked | 13 | 0.0033 |
| Galantamine Hbr | 13 | 0.0033 |
| Elmiron | 13 | 0.0033 |
| Dantrolene Sodium | 13 | 0.0033 |
| Constulose | 13 | 0.0033 |
| Carvedilol Er | 13 | 0.0033 |
| Vumerity | 12 | 0.0031 |
| Topamax | 12 | 0.0031 |
| Tegretol Xr | 12 | 0.0031 |
| Sumatriptan | 12 | 0.0031 |
| Sublocade | 12 | 0.0031 |
| Risperidone Er | 12 | 0.0031 |
| Propafenone Hcl Er | 12 | 0.0031 |
| Lagevrio (Eua) | 12 | 0.0031 |
| Klayesta | 12 | 0.0031 |
| Hydrocodone-Ibuprofen | 12 | 0.0031 |
| Humira | 12 | 0.0031 |
| Humalog Mix 75-25 Kwikpen | 12 | 0.0031 |
| Dexmethylphenidate Hcl | 12 | 0.0031 |
| Denta 5000 Plus | 12 | 0.0031 |
| Carbidopa | 12 | 0.0031 |
| Camzyos | 12 | 0.0031 |
| Butorphanol Tartrate | 12 | 0.0031 |
| Zolmitriptan | 11 | 0.0028 |
| Topiramate Er | 11 | 0.0028 |
| Radicava Ors | 11 | 0.0028 |
| Prolensa | 11 | 0.0028 |
| Privigen | 11 | 0.0028 |
| Oxymorphone Hcl Er | 11 | 0.0028 |
| Orenitram Er | 11 | 0.0028 |
| Misoprostol | 11 | 0.0028 |
| Methylphenidate Er (La) | 11 | 0.0028 |
| Lanthanum Carbonate | 11 | 0.0028 |
| Lamotrigine Odt | 11 | 0.0028 |
| Envarsus Xr | 11 | 0.0028 |
| Econazole Nitrate | 11 | 0.0028 |
| Disulfiram | 11 | 0.0028 |
| Dexamethasone Sodium Phosphate | 11 | 0.0028 |
| Clenpiq | 11 | 0.0028 |
| Cequa | 11 | 0.0028 |
| Avonex (4 Pack) | 11 | 0.0028 |
| Anagrelide Hcl | 11 | 0.0028 |
| Actemra | 11 | 0.0028 |
| Zafirlukast | 10 | 0.0026 |
| Tyvaso Dpi | 10 | 0.0026 |
| Telmisartan-Hydrochlorothiazid | 10 | 0.0026 |
| Synjardy | 10 | 0.0026 |
| Repatha Pushtronex | 10 | 0.0026 |
| Novolin N | 10 | 0.0026 |
| Namzaric | 10 | 0.0026 |
| Lyumjev Kwikpen U-100 | 10 | 0.0026 |
| Lotemax Sm | 10 | 0.0026 |
| Lenvima | 10 | 0.0026 |
| Lamictal Xr | 10 | 0.0026 |
| Horizant | 10 | 0.0026 |
| Glucagon Emergency Kit | 10 | 0.0026 |
| Glatopa | 10 | 0.0026 |
| Galantamine Er | 10 | 0.0026 |
| Fiasp | 10 | 0.0026 |
| Fenofibric Acid | 10 | 0.0026 |
| Donepezil Hcl Odt | 10 | 0.0026 |
| Desloratadine | 10 | 0.0026 |
| Cosentyx Unoready Pen | 10 | 0.0026 |
| Cosentyx (2 Syringes) | 10 | 0.0026 |
| Clarithromycin | 10 | 0.0026 |
| Chlorzoxazone | 10 | 0.0026 |
| Betimol | 10 | 0.0026 |
| Auryxia | 10 | 0.0026 |
| Atovaquone | 10 | 0.0026 |
| Ampicillin Sodium | 10 | 0.0026 |
| Xywav | 9 | 0.0023 |
| Xyosted | 9 | 0.0023 |
| Twinrix | 9 | 0.0023 |
| Tenivac | 9 | 0.0023 |
| Reyvow | 9 | 0.0023 |
| Rebif Rebidose | 9 | 0.0023 |
| Ninlaro | 9 | 0.0023 |
| Lyumjev | 9 | 0.0023 |
| Latuda | 9 | 0.0023 |
| Lactated Ringers | 9 | 0.0023 |
| Insulin Aspart | 9 | 0.0023 |
| Fluvoxamine Maleate Er | 9 | 0.0023 |
| Etravirine | 9 | 0.0023 |
| Easy Touch Pen Needle | 9 | 0.0023 |
| Diclofenac Sodium Er | 9 | 0.0023 |
| Desipramine Hcl | 9 | 0.0023 |
| Chlordiazepoxide Hcl | 9 | 0.0023 |
| Carbidopa-Levodopa-Entacapone | 9 | 0.0023 |
| Atenolol-Chlorthalidone | 9 | 0.0023 |
| Alcohol Swabs | 9 | 0.0023 |
| Zyprexa | 8 | 0.002 |
| Xultophy 100-3.6 | 8 | 0.002 |
| Vevye | 8 | 0.002 |
| Trikafta | 8 | 0.002 |
| Tresiba | 8 | 0.002 |
| Tecfidera | 8 | 0.002 |
| Saphris | 8 | 0.002 |
| Osphena | 8 | 0.002 |
| Orphenadrine Citrate Er | 8 | 0.002 |
| Novolin 70-30 Flexpen | 8 | 0.002 |
| Nitroglycerin Patch | 8 | 0.002 |
| Nexium | 8 | 0.002 |
| Mitigare | 8 | 0.002 |
| Metaxalone | 8 | 0.002 |
| Lonsurf | 8 | 0.002 |
| Humalog Mix 75-25 | 8 | 0.002 |
| Humalog Junior Kwikpen | 8 | 0.002 |
| Granix | 8 | 0.002 |
| Glipizide-Metformin | 8 | 0.002 |
| Gammaplex | 8 | 0.002 |
| Flunisolide | 8 | 0.002 |
| Endocet | 8 | 0.002 |
| Dutasteride-Tamsulosin | 8 | 0.002 |
| Depakote Er | 8 | 0.002 |
| Depakote | 8 | 0.002 |
| Cyclosporine Modified | 8 | 0.002 |
| Corlanor | 8 | 0.002 |
| Clozaril | 8 | 0.002 |
| Cefepime Hcl | 8 | 0.002 |
| Bromfenac Sodium | 8 | 0.002 |
| Bosentan | 8 | 0.002 |
| Betaseron | 8 | 0.002 |
| Avonex Pen (4 Pack) | 8 | 0.002 |
| Asa-Butalb-Caffeine-Codeine | 8 | 0.002 |
| Adbry | 8 | 0.002 |
| Zeposia | 7 | 0.0018 |
| Zejula | 7 | 0.0018 |
| Wellbutrin Xl | 7 | 0.0018 |
| Victoza 2-Pak | 7 | 0.0018 |
| Tukysa | 7 | 0.0018 |
| Trifluoperazine Hcl | 7 | 0.0018 |
| Tobradex | 7 | 0.0018 |
| Symproic | 7 | 0.0018 |
| Rezurock | 7 | 0.0018 |
| Prozac | 7 | 0.0018 |
| Pramipexole Er | 7 | 0.0018 |
| Pegasys | 7 | 0.0018 |
| Oxervate | 7 | 0.0018 |
| Opzelura | 7 | 0.0018 |
| Olmesartan-Amlodipine-Hctz | 7 | 0.0018 |
| Nourianz | 7 | 0.0018 |
| Nateglinide | 7 | 0.0018 |
| Methylphenidate Hcl Er (Cd) | 7 | 0.0018 |
| Meropenem | 7 | 0.0018 |
| Mekinist | 7 | 0.0018 |
| Magnesium Sulfate | 7 | 0.0018 |
| Levobunolol Hcl | 7 | 0.0018 |
| Itraconazole | 7 | 0.0018 |
| Isosorbide Mononitrate | 7 | 0.0018 |
| Hydrocodone Bitartrate Er | 7 | 0.0018 |
| Haloperidol Lactate | 7 | 0.0018 |
| Gvoke Hypopen 2-Pack | 7 | 0.0018 |
| Gocovri | 7 | 0.0018 |
| Gleevec | 7 | 0.0018 |
| Frovatriptan Succinate | 7 | 0.0018 |
| Evenity (2 Syringes) | 7 | 0.0018 |
| Epinastine Hcl | 7 | 0.0018 |
| Efavirenz-Emtric-Tenofov Disop | 7 | 0.0018 |
| Easy Touch Alcohol Prep Pads | 7 | 0.0018 |
| Dexilant | 7 | 0.0018 |
| Bystolic | 7 | 0.0018 |
| Bacitracin-Polymyxin | 7 | 0.0018 |
| Aubagio | 7 | 0.0018 |
| Aripiprazole Odt | 7 | 0.0018 |
| Amjevita(Cf) | 7 | 0.0018 |
| Amiloride-Hydrochlorothiazide | 7 | 0.0018 |
| Alunbrig | 7 | 0.0018 |
| Alcohol Prep Pads | 7 | 0.0018 |
| Airsupra | 7 | 0.0018 |
| Admelog Solostar | 7 | 0.0018 |
| Yf-Vax | 6 | 0.0015 |
| Xospata | 6 | 0.0015 |
| Vyndaqel | 6 | 0.0015 |
| Typhim Vi | 6 | 0.0015 |
| Toprol Xl | 6 | 0.0015 |
| Tiadylt Er | 6 | 0.0015 |
| Tegretol | 6 | 0.0015 |
| Tafinlar | 6 | 0.0015 |
| Sulfacetamide Sodium | 6 | 0.0015 |
| Skyrizi On-Body | 6 | 0.0015 |
| Semglee (Yfgn) | 6 | 0.0015 |
| Rasuvo | 6 | 0.0015 |
| Prevymis | 6 | 0.0015 |
| Panzyga | 6 | 0.0015 |
| Oxazepam | 6 | 0.0015 |
| Octagam | 6 | 0.0015 |
| Novolin R Flexpen | 6 | 0.0015 |
| Micafungin | 6 | 0.0015 |
| Metformin Er Gastric | 6 | 0.0015 |
| Mercaptopurine | 6 | 0.0015 |
| Insulin Lispro Protamine Mix | 6 | 0.0015 |
| Insulin Degludec Pen (U-200) | 6 | 0.0015 |
| Inqovi | 6 | 0.0015 |
| Inlyta | 6 | 0.0015 |
| Gralise | 6 | 0.0015 |
| Fluvastatin Sodium | 6 | 0.0015 |
| Ethacrynic Acid | 6 | 0.0015 |
| Deferasirox | 6 | 0.0015 |
| Darifenacin Er | 6 | 0.0015 |
| Codeine Sulfate | 6 | 0.0015 |
| Azelaic Acid | 6 | 0.0015 |
| Amlodipine-Atorvastatin | 6 | 0.0015 |
| Ambien | 6 | 0.0015 |
| Abacavir-Lamivudine | 6 | 0.0015 |
| Zioptan | 5 | 0.0013 |
| Zileuton Er | 5 | 0.0013 |
| Xhance | 5 | 0.0013 |
| Xanax | 5 | 0.0013 |
| Verquvo | 5 | 0.0013 |
| Vancomycin Hcl-0.9% Nacl | 5 | 0.0013 |
| Unifine Safecontrol Pen Needle | 5 | 0.0013 |
| Unifine Pentips | 5 | 0.0013 |
| Trileptal | 5 | 0.0013 |
| Tranylcypromine Sulfate | 5 | 0.0013 |
| Thiothixene | 5 | 0.0013 |
| Suprep | 5 | 0.0013 |
| Sodium Oxybate | 5 | 0.0013 |
| Selenium Sulfide | 5 | 0.0013 |
| Saxagliptin Hcl | 5 | 0.0013 |
| Savaysa | 5 | 0.0013 |
| Rezdiffra | 5 | 0.0013 |
| Rebif | 5 | 0.0013 |
| Propylthiouracil | 5 | 0.0013 |
| Prezista | 5 | 0.0013 |
| Prenatal Vitamin Plus Low Iron | 5 | 0.0013 |
| Piroxicam | 5 | 0.0013 |
| Paroxetine Er | 5 | 0.0013 |
| Orserdu | 5 | 0.0013 |
| Onfi | 5 | 0.0013 |
| Omnipod Dash Pods (Gen 4) | 5 | 0.0013 |
| Olumiant | 5 | 0.0013 |
| Novolin N Flexpen | 5 | 0.0013 |
| Maraviroc | 5 | 0.0013 |
| Lyllana | 5 | 0.0013 |
| Linezolid | 5 | 0.0013 |
| Levalbuterol Hcl | 5 | 0.0013 |
| Letairis | 5 | 0.0013 |
| Klor-Con | 5 | 0.0013 |
| Ivermectin | 5 | 0.0013 |
| Ipol | 5 | 0.0013 |
| Ilevro | 5 | 0.0013 |
| Ibsrela | 5 | 0.0013 |
| Havrix | 5 | 0.0013 |
| Genotropin | 5 | 0.0013 |
| Fondaparinux Sodium | 5 | 0.0013 |
| Flarex | 5 | 0.0013 |
| Firdapse | 5 | 0.0013 |
| Euthyrox | 5 | 0.0013 |
| Estradiol-Norethindrone Acetat | 5 | 0.0013 |
| Epclusa | 5 | 0.0013 |
| Enbrel Mini | 5 | 0.0013 |
| Efavirenz | 5 | 0.0013 |
| Delstrigo | 5 | 0.0013 |
| Cyltezo(Cf) Pen | 5 | 0.0013 |
| Cuvitru | 5 | 0.0013 |
| Clinolipid | 5 | 0.0013 |
| Clindamycin-Benzoyl Peroxide | 5 | 0.0013 |
| Carbatrol | 5 | 0.0013 |
| Candesartan-Hydrochlorothiazid | 5 | 0.0013 |
| Bromocriptine Mesylate | 5 | 0.0013 |
| Atazanavir Sulfate | 5 | 0.0013 |
| Aspirin-Dipyridamole Er | 5 | 0.0013 |
| Ampicillin-Sulbactam | 5 | 0.0013 |
| Amikacin Sulfate | 5 | 0.0013 |
| Advocate Pen Needles | 5 | 0.0013 |
| Abacavir | 5 | 0.0013 |
| Zonegran | 4 | 0.001 |
| Zirgan | 4 | 0.001 |
| Xphozah | 4 | 0.001 |
| Winrevair | 4 | 0.001 |
| Trueplus Pen Needle | 4 | 0.001 |
| Tirosint-Sol | 4 | 0.001 |
| Tibsovo | 4 | 0.001 |
| Tabrecta | 4 | 0.001 |
| Sunosi | 4 | 0.001 |
| Sunitinib Malate | 4 | 0.001 |
| Striverdi Respimat | 4 | 0.001 |
| Somatuline Depot | 4 | 0.001 |
| Solu-Cortef | 4 | 0.001 |
| Sivextro | 4 | 0.001 |
| Seroquel | 4 | 0.001 |
| Scemblix | 4 | 0.001 |
| Rukobia | 4 | 0.001 |
| Renacidin | 4 | 0.001 |
| Remicade | 4 | 0.001 |
| Permethrin | 4 | 0.001 |
| Octreotide Acetate | 4 | 0.001 |
| Nuzyra | 4 | 0.001 |
| Novolin R | 4 | 0.001 |
| Nortrel | 4 | 0.001 |
| Norethindrone | 4 | 0.001 |
| Norethindron-Ethinyl Estradiol | 4 | 0.001 |
| Nevirapine Er | 4 | 0.001 |
| Neurontin | 4 | 0.001 |
| Neomycin-Polymyxin-Hydrocort | 4 | 0.001 |
| Mresvia | 4 | 0.001 |
| Matzim La | 4 | 0.001 |
| Liraglutide | 4 | 0.001 |
| Lamivudine | 4 | 0.001 |
| Klor-Con M10 | 4 | 0.001 |
| Junel Fe | 4 | 0.001 |
| Inbrija | 4 | 0.001 |
| Hetlioz | 4 | 0.001 |
| Felbatol | 4 | 0.001 |
| Edurant | 4 | 0.001 |
| Doxycycline Ir-Dr | 4 | 0.001 |
| Dihydroergotamine Mesylate | 4 | 0.001 |
| Diflunisal | 4 | 0.001 |
| Cymbalta | 4 | 0.001 |
| Crestor | 4 | 0.001 |
| Concerta | 4 | 0.001 |
| Combipatch | 4 | 0.001 |
| Colistimethate | 4 | 0.001 |
| Braftovi | 4 | 0.001 |
| Bosulif | 4 | 0.001 |
| Ayvakit | 4 | 0.001 |
| Arikayce | 4 | 0.001 |
| Ampyra | 4 | 0.001 |
| Alrex | 4 | 0.001 |
| Alprazolam Xr | 4 | 0.001 |
| Alogliptin | 4 | 0.001 |
| Zemaira | 3 | 0.0008 |
| Zavzpret | 3 | 0.0008 |
| Zarxio | 3 | 0.0008 |
| Wellbutrin Sr | 3 | 0.0008 |
| Water | 3 | 0.0008 |
| Wakix | 3 | 0.0008 |
| Vienva | 3 | 0.0008 |
| Verapamil Er Pm | 3 | 0.0008 |
| Vectical | 3 | 0.0008 |
| Valtoco | 3 | 0.0008 |
| Vagifem | 3 | 0.0008 |
| Trokendi Xr | 3 | 0.0008 |
| Tri-Lo-Estarylla | 3 | 0.0008 |
| Tremfya | 3 | 0.0008 |
| Tobramycin Sulfate | 3 | 0.0008 |
| Theo-24 | 3 | 0.0008 |
| Terconazole | 3 | 0.0008 |
| Tasimelteon | 3 | 0.0008 |
| Takhzyro | 3 | 0.0008 |
| Strensiq | 3 | 0.0008 |
| Sofosbuvir-Velpatasvir | 3 | 0.0008 |
| Sodium Fluoride 5000 Plus | 3 | 0.0008 |
| Sodium Bicarbonate | 3 | 0.0008 |
| Sf 5000 Plus | 3 | 0.0008 |
| Ruconest | 3 | 0.0008 |
| Ritalin | 3 | 0.0008 |
| Rifabutin | 3 | 0.0008 |
| Retacrit | 3 | 0.0008 |
| Qelbree | 3 | 0.0008 |
| Prevalite | 3 | 0.0008 |
| Phenelzine Sulfate | 3 | 0.0008 |
| Paxlovid (Eua) | 3 | 0.0008 |
| Paroxetine Cr | 3 | 0.0008 |
| Paricalcitol | 3 | 0.0008 |
| Omnitrope | 3 | 0.0008 |
| Olopatadine Hcl | 3 | 0.0008 |
| Ojjaara | 3 | 0.0008 |
| Novofine 32 | 3 | 0.0008 |
| Nizatidine | 3 | 0.0008 |
| Nitro-Bid | 3 | 0.0008 |
| Methadone Intensol | 3 | 0.0008 |
| Mesalamine Dr | 3 | 0.0008 |
| Menveo A-C-Y-W-135-Dip | 3 | 0.0008 |
| Mektovi | 3 | 0.0008 |
| M-M-R Ii Vaccine | 3 | 0.0008 |
| Lumakras | 3 | 0.0008 |
| Lotemax | 3 | 0.0008 |
| Lorbrena | 3 | 0.0008 |
| Lexapro | 3 | 0.0008 |
| Lamivudine Hbv | 3 | 0.0008 |
| Kineret | 3 | 0.0008 |
| Keppra Xr | 3 | 0.0008 |
| Kalydeco | 3 | 0.0008 |
| Jentadueto | 3 | 0.0008 |
| Isentress Hd | 3 | 0.0008 |
| Invega | 3 | 0.0008 |
| Hydrocortisone Valerate | 3 | 0.0008 |
| Humatrope | 3 | 0.0008 |
| Halobetasol Propionate | 3 | 0.0008 |
| Glyxambi | 3 | 0.0008 |
| Gengraf | 3 | 0.0008 |
| Gavilyte-N | 3 | 0.0008 |
| Gattex | 3 | 0.0008 |
| Gabapentin Er | 3 | 0.0008 |
| Evrysdi | 3 | 0.0008 |
| Ethosuximide | 3 | 0.0008 |
| Estarylla | 3 | 0.0008 |
| Entyvio Pen | 3 | 0.0008 |
| Entyvio | 3 | 0.0008 |
| Effexor Xr | 3 | 0.0008 |
| Doptelet | 3 | 0.0008 |
| Diclofenac Epolamine | 3 | 0.0008 |
| Dextrose In Water | 3 | 0.0008 |
| Dentagel | 3 | 0.0008 |
| Crysvita | 3 | 0.0008 |
| Comfort Ez Pen Needle | 3 | 0.0008 |
| Clinisol | 3 | 0.0008 |
| Clindamycin Phos-Benzoyl Perox | 3 | 0.0008 |
| Chlordiazepoxide-Clidinium | 3 | 0.0008 |
| Cefixime | 3 | 0.0008 |
| Cayston | 3 | 0.0008 |
| Budesonide Er | 3 | 0.0008 |
| Brixadi | 3 | 0.0008 |
| Betaxolol Hcl | 3 | 0.0008 |
| Aviane | 3 | 0.0008 |
| Ativan | 3 | 0.0008 |
| Asmanex Hfa | 3 | 0.0008 |
| Apriso | 3 | 0.0008 |
| Alosetron Hcl | 3 | 0.0008 |
| Almotriptan Malate | 3 | 0.0008 |
| Afrezza | 3 | 0.0008 |
| Admelog | 3 | 0.0008 |
| Adderall | 3 | 0.0008 |
| Adcirca | 3 | 0.0008 |
| Acebutolol Hcl | 3 | 0.0008 |
| Abilify | 3 | 0.0008 |
| Zyprexa Relprevv | 2 | 0.0005 |
| Zoloft | 2 | 0.0005 |
| Xgeva | 2 | 0.0005 |
| Xeomin | 2 | 0.0005 |
| Xembify | 2 | 0.0005 |
| Xalatan | 2 | 0.0005 |
| Welireg | 2 | 0.0005 |
| Vtama | 2 | 0.0005 |
| Voriconazole | 2 | 0.0005 |
| Vonjo | 2 | 0.0005 |
| Vivelle-Dot | 2 | 0.0005 |
| Uzedy | 2 | 0.0005 |
| Ultra-Fine Original Pen Needle | 2 | 0.0005 |
| Ultomiris | 2 | 0.0005 |
| Tybost | 2 | 0.0005 |
| Tudorza Pressair | 2 | 0.0005 |
| Trueplus Insulin Syringe | 2 | 0.0005 |
| Tropicamide | 2 | 0.0005 |
| Tri-Sprintec | 2 | 0.0005 |
| Trexall | 2 | 0.0005 |
| Travatan Z | 2 | 0.0005 |
| Trandolapril | 2 | 0.0005 |
| Toviaz | 2 | 0.0005 |
| Tlando | 2 | 0.0005 |
| Tiagabine Hcl | 2 | 0.0005 |
| Thioridazine Hcl | 2 | 0.0005 |
| Techlite Pen Needle | 2 | 0.0005 |
| Tavalisse | 2 | 0.0005 |
| Tavaborole | 2 | 0.0005 |
| Symdeko | 2 | 0.0005 |
| Sucraid | 2 | 0.0005 |
| Steglatro | 2 | 0.0005 |
| Somavert | 2 | 0.0005 |
| Skyclarys | 2 | 0.0005 |
| Sandostatin Lar Depot | 2 | 0.0005 |
| Rozerem | 2 | 0.0005 |
| Risperdal | 2 | 0.0005 |
| Retevmo | 2 | 0.0005 |
| Renvela | 2 | 0.0005 |
| Relyvrio | 2 | 0.0005 |
| Qnasl | 2 | 0.0005 |
| Pyridostigmine Bromide Er | 2 | 0.0005 |
| Promethegan | 2 | 0.0005 |
| Probenecid-Colchicine | 2 | 0.0005 |
| Prilosec | 2 | 0.0005 |
| Prevident 5000 Dry Mouth | 2 | 0.0005 |
| Pregabalin Er | 2 | 0.0005 |
| Prednisolone | 2 | 0.0005 |
| Potassium Chloride-0.9% Nacl | 2 | 0.0005 |
| Plavix | 2 | 0.0005 |
| Piperacillin-Tazobactam | 2 | 0.0005 |
| Phenytek | 2 | 0.0005 |
| Pertzye | 2 | 0.0005 |
| Perseris | 2 | 0.0005 |
| Pen Needles | 2 | 0.0005 |
| Pazopanib Hcl | 2 | 0.0005 |
| Oxymorphone Hcl | 2 | 0.0005 |
| Oxaprozin | 2 | 0.0005 |
| Orladeyo | 2 | 0.0005 |
| Opium Tincture | 2 | 0.0005 |
| Ongentys | 2 | 0.0005 |
| Odomzo | 2 | 0.0005 |
| Nicotrol Ns | 2 | 0.0005 |
| Nemluvio | 2 | 0.0005 |
| Mycapssa | 2 | 0.0005 |
| Moxifloxacin Hcl | 2 | 0.0005 |
| Methylprednisolone Sodium Succ | 2 | 0.0005 |
| Methazolamide | 2 | 0.0005 |
| Menquadfi | 2 | 0.0005 |
| Lupron Depot | 2 | 0.0005 |
| Loreev Xr | 2 | 0.0005 |
| Lo-Zumandimine | 2 | 0.0005 |
| Lialda | 2 | 0.0005 |
| Lasix | 2 | 0.0005 |
| Koselugo | 2 | 0.0005 |
| Korlym | 2 | 0.0005 |
| Klor-Con 8 | 2 | 0.0005 |
| Klonopin | 2 | 0.0005 |
| Kcl-D5w-0.45% Nacl | 2 | 0.0005 |
| Jynarque | 2 | 0.0005 |
| Junel | 2 | 0.0005 |
| Jaypirca | 2 | 0.0005 |
| Iyuzeh | 2 | 0.0005 |
| Ixiaro | 2 | 0.0005 |
| Isturisa | 2 | 0.0005 |
| Isradipine | 2 | 0.0005 |
| Isoniazid | 2 | 0.0005 |
| Invokamet | 2 | 0.0005 |
| Insulin Glargine | 2 | 0.0005 |
| Inderal La | 2 | 0.0005 |
| Ilaris | 2 | 0.0005 |
| Idhifa | 2 | 0.0005 |
| Iclusig | 2 | 0.0005 |
| Hyqvia | 2 | 0.0005 |
| Humulin R U-500 | 2 | 0.0005 |
| Heplisav-B | 2 | 0.0005 |
| Heparin Sodium | 2 | 0.0005 |
| Haegarda | 2 | 0.0005 |
| Gvoke Hypopen 1-Pack | 2 | 0.0005 |
| Granisetron Hcl | 2 | 0.0005 |
| Gleostine | 2 | 0.0005 |
| Gardasil 9 | 2 | 0.0005 |
| Fosrenol | 2 | 0.0005 |
| Focalin Xr | 2 | 0.0005 |
| Fintepla | 2 | 0.0005 |
| Eylea | 2 | 0.0005 |
| Estradiol Valerate | 2 | 0.0005 |
| Estazolam | 2 | 0.0005 |
| Erythromycin-Benzoyl Peroxide | 2 | 0.0005 |
| Erythromycin Ethylsuccinate | 2 | 0.0005 |
| Erlotinib Hcl | 2 | 0.0005 |
| Ergotamine-Caffeine | 2 | 0.0005 |
| Enspryng | 2 | 0.0005 |
| Emtricitabine | 2 | 0.0005 |
| Edluar | 2 | 0.0005 |
| Edarbi | 2 | 0.0005 |
| Easy Touch Safety Pen Needle | 2 | 0.0005 |
| Diclofenac Sodium-Misoprostol | 2 | 0.0005 |
| Demeclocycline Hcl | 2 | 0.0005 |
| Cosopt Pf | 2 | 0.0005 |
| Cosentyx Syringe | 2 | 0.0005 |
| Cordran | 2 | 0.0005 |
| Clobetasol Emollient | 2 | 0.0005 |
| Climara Pro | 2 | 0.0005 |
| Clemastine Fumarate | 2 | 0.0005 |
| Chloroquine Phosphate | 2 | 0.0005 |
| Cequr Simplicity | 2 | 0.0005 |
| Captopril | 2 | 0.0005 |
| Cambia | 2 | 0.0005 |
| Cabenuva | 2 | 0.0005 |
| Byetta | 2 | 0.0005 |
| Bexarotene | 2 | 0.0005 |
| Besremi | 2 | 0.0005 |
| Benzonatate | 2 | 0.0005 |
| Asmanex | 2 | 0.0005 |
| Aranesp | 2 | 0.0005 |
| Aplenzin | 2 | 0.0005 |
| Alogliptin-Metformin | 2 | 0.0005 |
| Zumandimine | 1 | 0.0003 |
| Zortress | 1 | 0.0003 |
| Zolmitriptan Odt | 1 | 0.0003 |
| Zolinza | 1 | 0.0003 |
| Zilbrysq | 1 | 0.0003 |
| Zerbaxa | 1 | 0.0003 |
| Zelboraf | 1 | 0.0003 |
| Yonsa | 1 | 0.0003 |
| Xyrem | 1 | 0.0003 |
| Xermelo | 1 | 0.0003 |
| Xalkori | 1 | 0.0003 |
| Xadago | 1 | 0.0003 |
| Winlevi | 1 | 0.0003 |
| Westab Plus | 1 | 0.0003 |
| Welchol | 1 | 0.0003 |
| Vyvgart Hytrulo | 1 | 0.0003 |
| Vuity | 1 | 0.0003 |
| Voquezna | 1 | 0.0003 |
| Viracept | 1 | 0.0003 |
| Viokace | 1 | 0.0003 |
| Viibryd | 1 | 0.0003 |
| Venlafaxine Besylate Er | 1 | 0.0003 |
| Varubi | 1 | 0.0003 |
| Varivax Vaccine | 1 | 0.0003 |
| Vaqta | 1 | 0.0003 |
| Valchlor | 1 | 0.0003 |
| Vabysmo | 1 | 0.0003 |
| V-Go 30 | 1 | 0.0003 |
| Unifine Pentips Plus | 1 | 0.0003 |
| Ultiguard Safepack-Pen Needle | 1 | 0.0003 |
| Uloric | 1 | 0.0003 |
| Tyenne | 1 | 0.0003 |
| Truqap | 1 | 0.0003 |
| True Comfort Pro Alcohol Pads | 1 | 0.0003 |
| Trijardy Xr | 1 | 0.0003 |
| Tri-Estarylla | 1 | 0.0003 |
| Transderm-Scop | 1 | 0.0003 |
| Tracleer | 1 | 0.0003 |
| Tobi Podhaler | 1 | 0.0003 |
| Thyroid | 1 | 0.0003 |
| Thiola Ec | 1 | 0.0003 |
| Thiola | 1 | 0.0003 |
| Tepmetko | 1 | 0.0003 |
| Tepezza | 1 | 0.0003 |
| Tazarotene | 1 | 0.0003 |
| Taltz Syringe | 1 | 0.0003 |
| Taltz Autoinjector (2 Pack) | 1 | 0.0003 |
| Sympazan | 1 | 0.0003 |
| Syeda | 1 | 0.0003 |
| Sprintec | 1 | 0.0003 |
| Sorafenib | 1 | 0.0003 |
| Sogroya | 1 | 0.0003 |
| Sodium Fluoride Enamel Protect | 1 | 0.0003 |
| Sodium Fluoride 5000 Dry Mouth | 1 | 0.0003 |
| Slynd | 1 | 0.0003 |
| Skyrizi | 1 | 0.0003 |
| Siliq | 1 | 0.0003 |
| Signifor | 1 | 0.0003 |
| Sevelamer Hcl | 1 | 0.0003 |
| Secuado | 1 | 0.0003 |
| Sandimmune | 1 | 0.0003 |
| Samsca | 1 | 0.0003 |
| Salsalate | 1 | 0.0003 |
| Sajazir | 1 | 0.0003 |
| Safetyglide Insulin Syringe | 1 | 0.0003 |
| Rozlytrek | 1 | 0.0003 |
| Roxicodone | 1 | 0.0003 |
| Ritalin La | 1 | 0.0003 |
| Risedronate Sodium Dr | 1 | 0.0003 |
| Rimantadine Hcl | 1 | 0.0003 |
| Remodulin | 1 | 0.0003 |
| Remeron | 1 | 0.0003 |
| Rayos | 1 | 0.0003 |
| Rayaldee | 1 | 0.0003 |
| Radicava | 1 | 0.0003 |
| Rabavert | 1 | 0.0003 |
| Quinidine Gluconate | 1 | 0.0003 |
| Qudexy Xr | 1 | 0.0003 |
| Pyrimethamine | 1 | 0.0003 |
| Provigil | 1 | 0.0003 |
| Prochlorperazine Edisylate | 1 | 0.0003 |
| Proair Respiclick | 1 | 0.0003 |
| Pristiq | 1 | 0.0003 |
| Priftin | 1 | 0.0003 |
| Prevident 5000 Sensitive | 1 | 0.0003 |
| Plenamine | 1 | 0.0003 |
| Piqray | 1 | 0.0003 |
| Pioglitazone-Metformin | 1 | 0.0003 |
| Pindolol | 1 | 0.0003 |
| Pimozide | 1 | 0.0003 |
| Perphenazine-Amitriptyline | 1 | 0.0003 |
| Percocet | 1 | 0.0003 |
| Pentips Pen Needle | 1 | 0.0003 |
| Pentazocine-Naloxone Hcl | 1 | 0.0003 |
| Pentasa | 1 | 0.0003 |
| Peg3350-Sod Sul-Nacl-Kcl-Asb-C | 1 | 0.0003 |
| Paxil Cr | 1 | 0.0003 |
| Palynziq | 1 | 0.0003 |
| Oxbryta | 1 | 0.0003 |
| Otrexup | 1 | 0.0003 |
| Oracea | 1 | 0.0003 |
| Onureg | 1 | 0.0003 |
| Omeprazole-Sodium Bicarbonate | 1 | 0.0003 |
| Olanzapine-Fluoxetine Hcl | 1 | 0.0003 |
| Ogsiveo | 1 | 0.0003 |
| Nyvepria | 1 | 0.0003 |
| Nuvigil | 1 | 0.0003 |
| Novolog Penfill | 1 | 0.0003 |
| Novolog Mix 70-30 | 1 | 0.0003 |
| Novofine Autocover | 1 | 0.0003 |
| Norvir | 1 | 0.0003 |
| Norvasc | 1 | 0.0003 |
| Norgestimate-Ethinyl Estradiol | 1 | 0.0003 |
| Norethindrone-E.Estradiol-Iron | 1 | 0.0003 |
| Nitazoxanide | 1 | 0.0003 |
| Nimodipine | 1 | 0.0003 |
| Nilandron | 1 | 0.0003 |
| Nexviazyme | 1 | 0.0003 |
| Neupogen | 1 | 0.0003 |
| Neulasta Onpro | 1 | 0.0003 |
| Neomycin-Bacitracin-Polymyxin | 1 | 0.0003 |
| Nefazodone Hcl | 1 | 0.0003 |
| Nafcillin Sodium | 1 | 0.0003 |
| Mysoline | 1 | 0.0003 |
| Mono-Linyah | 1 | 0.0003 |
| Moexipril Hcl | 1 | 0.0003 |
| Minivelle | 1 | 0.0003 |
| Migergot | 1 | 0.0003 |
| Mifepristone | 1 | 0.0003 |
| Microgestin | 1 | 0.0003 |
| Methscopolamine Bromide | 1 | 0.0003 |
| Methenamine Mandelate | 1 | 0.0003 |
| Meropenem-0.9% Nacl | 1 | 0.0003 |
| Menest | 1 | 0.0003 |
| Lysodren | 1 | 0.0003 |
| Lupkynis | 1 | 0.0003 |
| Lunesta | 1 | 0.0003 |
| Loryna | 1 | 0.0003 |
| Litfulo | 1 | 0.0003 |
| Linezolid-D5w | 1 | 0.0003 |
| Licart | 1 | 0.0003 |
| Levorphanol Tartrate | 1 | 0.0003 |
| Larin | 1 | 0.0003 |
| Lamivudine-Zidovudine | 1 | 0.0003 |
| Kuvan | 1 | 0.0003 |
| Krazati | 1 | 0.0003 |
| Konvomep | 1 | 0.0003 |
| Keytruda | 1 | 0.0003 |
| Jornay Pm | 1 | 0.0003 |
| Jatenzo | 1 | 0.0003 |
| Ixchiq | 1 | 0.0003 |
| Istalol | 1 | 0.0003 |
| Invokamet Xr | 1 | 0.0003 |
| Intrarosa | 1 | 0.0003 |
| Intelence | 1 | 0.0003 |
| Insulin Lispro Junior Kwikpen | 1 | 0.0003 |
| Insulin Glargine Max Solostar | 1 | 0.0003 |
| Insulin Aspart Prot Mix 70-30 | 1 | 0.0003 |
| Indomethacin Er | 1 | 0.0003 |
| Imitrex | 1 | 0.0003 |
| Imipramine Pamoate | 1 | 0.0003 |
| Imipenem-Cilastatin Sodium | 1 | 0.0003 |
| Icatibant | 1 | 0.0003 |
| Hadlima(Cf) Pushtouch | 1 | 0.0003 |
| Gvoke | 1 | 0.0003 |
| Griseofulvin Ultramicrosize | 1 | 0.0003 |
| Glipizide Xl | 1 | 0.0003 |
| Gilotrif | 1 | 0.0003 |
| Gilenya | 1 | 0.0003 |
| Geodon | 1 | 0.0003 |
| Gavreto | 1 | 0.0003 |
| Gatifloxacin | 1 | 0.0003 |
| Galafold | 1 | 0.0003 |
| Fyavolv | 1 | 0.0003 |
| Fruzaqla | 1 | 0.0003 |
| Fragmin | 1 | 0.0003 |
| Fotivda | 1 | 0.0003 |
| Fosinopril-Hydrochlorothiazide | 1 | 0.0003 |
| Fosamax | 1 | 0.0003 |
| Formoterol Fumarate | 1 | 0.0003 |
| Fml Forte | 1 | 0.0003 |
| Fluvastatin Er | 1 | 0.0003 |
| Flurbiprofen | 1 | 0.0003 |
| Fluoxetine Dr | 1 | 0.0003 |
| Fluoridex | 1 | 0.0003 |
| Fluocinonide-E | 1 | 0.0003 |
| Flector | 1 | 0.0003 |
| Flavoxate Hcl | 1 | 0.0003 |
| Firazyr | 1 | 0.0003 |
| Filspari | 1 | 0.0003 |
| Fentanyl Citrate | 1 | 0.0003 |
| Eysuvis | 1 | 0.0003 |
| Exondys-51 | 1 | 0.0003 |
| Evotaz | 1 | 0.0003 |
| Etodolac Er | 1 | 0.0003 |
| Estrogel | 1 | 0.0003 |
| Esbriet | 1 | 0.0003 |
| Erivedge | 1 | 0.0003 |
| Eprontia | 1 | 0.0003 |
| Engerix-B Adult | 1 | 0.0003 |
| Emsam | 1 | 0.0003 |
| Empaveli | 1 | 0.0003 |
| Emflaza | 1 | 0.0003 |
| Embrace Pen Needle | 1 | 0.0003 |
| Elyxyb | 1 | 0.0003 |
| Elinest | 1 | 0.0003 |
| Effer-K | 1 | 0.0003 |
| Dysport | 1 | 0.0003 |
| Durezol | 1 | 0.0003 |
| Droxia | 1 | 0.0003 |
| Drospirenone-Ethinyl Estradiol | 1 | 0.0003 |
| Dropsafe Pen Needle | 1 | 0.0003 |
| Droplet Insulin Syringe | 1 | 0.0003 |
| Doxy 100 | 1 | 0.0003 |
| Disopyramide Phosphate | 1 | 0.0003 |
| Dextrose 5%-0.45% Nacl | 1 | 0.0003 |
| Desvenlafaxine Er | 1 | 0.0003 |
| Depakote Sprinkle | 1 | 0.0003 |
| Deferiprone (3 Times A Day) | 1 | 0.0003 |
| Deblitane | 1 | 0.0003 |
| Cyltezo(Cf) | 1 | 0.0003 |
| Cutaquig | 1 | 0.0003 |
| Cryselle | 1 | 0.0003 |
| Cotellic | 1 | 0.0003 |
| Cortef | 1 | 0.0003 |
| Contrave | 1 | 0.0003 |
| Compro | 1 | 0.0003 |
| Complete Natal Dha | 1 | 0.0003 |
| Complera | 1 | 0.0003 |
| Clonidine Hcl Er | 1 | 0.0003 |
| Clinpro 5000 | 1 | 0.0003 |
| Clarithromycin Er | 1 | 0.0003 |
| Claravis | 1 | 0.0003 |
| Ciloxan | 1 | 0.0003 |
| Cibinqo | 1 | 0.0003 |
| Cholbam | 1 | 0.0003 |
| Cetirizine Hcl | 1 | 0.0003 |
| Cerdelga | 1 | 0.0003 |
| Celexa | 1 | 0.0003 |
| Celebrex | 1 | 0.0003 |
| Cefprozil | 1 | 0.0003 |
| Cefaclor | 1 | 0.0003 |
| Caspofungin Acetate | 1 | 0.0003 |
| Carteolol Hcl | 1 | 0.0003 |
| Carospir | 1 | 0.0003 |
| Cardura Xl | 1 | 0.0003 |
| Cardizem La | 1 | 0.0003 |
| Capecitabine | 1 | 0.0003 |
| Butalbital-Acetaminophen | 1 | 0.0003 |
| Bupivacaine Hcl | 1 | 0.0003 |
| Bromsite | 1 | 0.0003 |
| Bortezomib | 1 | 0.0003 |
| Bexsero | 1 | 0.0003 |
| Besivance | 1 | 0.0003 |
| Benicar Hct | 1 | 0.0003 |
| Benicar | 1 | 0.0003 |
| Banzel | 1 | 0.0003 |
| Bacitracin | 1 | 0.0003 |
| Avapro | 1 | 0.0003 |
| Atorvaliq | 1 | 0.0003 |
| Ascomp With Codeine | 1 | 0.0003 |
| Arformoterol Tartrate | 1 | 0.0003 |
| Arcalyst | 1 | 0.0003 |
| Aranelle | 1 | 0.0003 |
| Aralast Np | 1 | 0.0003 |
| Aprepitant | 1 | 0.0003 |
| Apraclonidine Hcl | 1 | 0.0003 |
| Androgel | 1 | 0.0003 |
| Ampicillin Trihydrate | 1 | 0.0003 |
| Amlodipine-Valsartan-Hctz | 1 | 0.0003 |
| Ambien Cr | 1 | 0.0003 |
| Alvaiz | 1 | 0.0003 |
| Altavera | 1 | 0.0003 |
| Alprazolam Odt | 1 | 0.0003 |
| Aliskiren | 1 | 0.0003 |
| Aldurazyme | 1 | 0.0003 |
| Alcohol Swab | 1 | 0.0003 |
| Alcohol Pads | 1 | 0.0003 |
| Albendazole | 1 | 0.0003 |
| Afinitor Disperz | 1 | 0.0003 |
| Adefovir Dipivoxil | 1 | 0.0003 |
| Adalimumab-Adaz(Cf) Pen | 1 | 0.0003 |
| Acthib | 1 | 0.0003 |
| Acthar | 1 | 0.0003 |
| Acetaminophen | 1 | 0.0003 |

_1662 row(s) returned._

### [2.6] Categorical distribution: Gnrc_Name

Distinct values of Gnrc_Name (drug generic name) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| Levothyroxine Sodium | 7007 | 1.7945 |
| Metformin Hcl | 6959 | 1.7822 |
| Gabapentin | 6460 | 1.6544 |
| Atorvastatin Calcium | 6132 | 1.5704 |
| Lisinopril | 5504 | 1.4096 |
| Amlodipine Besylate | 5480 | 1.4034 |
| Albuterol Sulfate | 5347 | 1.3694 |
| Losartan Potassium | 5146 | 1.3179 |
| Omeprazole | 4968 | 1.2723 |
| Prednisone | 4729 | 1.2111 |
| Oxycodone Hcl | 4669 | 1.1957 |
| Trazodone Hcl | 4641 | 1.1886 |
| Rosuvastatin Calcium | 4548 | 1.1647 |
| Pantoprazole Sodium | 4426 | 1.1335 |
| Furosemide | 4310 | 1.1038 |
| Metoprolol Succinate | 4309 | 1.1035 |
| Tramadol Hcl | 4288 | 1.0982 |
| Tamsulosin Hcl | 4094 | 1.0485 |
| Hydrocodone/Acetaminophen | 4094 | 1.0485 |
| Duloxetine Hcl | 3978 | 1.0188 |
| Hydrochlorothiazide | 3972 | 1.0172 |
| Apixaban | 3970 | 1.0167 |
| Sertraline Hcl | 3902 | 0.9993 |
| Bupropion Hcl | 3823 | 0.9791 |
| Potassium Chloride | 3784 | 0.9691 |
| Escitalopram Oxalate | 3445 | 0.8823 |
| Meloxicam | 3339 | 0.8551 |
| Metoprolol Tartrate | 3270 | 0.8374 |
| Simvastatin | 3263 | 0.8357 |
| Amoxicillin/Potassium Clav | 3184 | 0.8154 |
| Carvedilol | 3040 | 0.7785 |
| Fluoxetine Hcl | 3024 | 0.7744 |
| Allopurinol | 2978 | 0.7627 |
| Fluticasone Propionate | 2963 | 0.7588 |
| Cephalexin | 2941 | 0.7532 |
| Empagliflozin | 2922 | 0.7483 |
| Amoxicillin | 2907 | 0.7445 |
| Alendronate Sodium | 2898 | 0.7422 |
| Spironolactone | 2884 | 0.7386 |
| Famotidine | 2805 | 0.7184 |
| Pregabalin | 2779 | 0.7117 |
| Semaglutide | 2731 | 0.6994 |
| Zolpidem Tartrate | 2723 | 0.6974 |
| Venlafaxine Hcl | 2677 | 0.6856 |
| Montelukast Sodium | 2655 | 0.6799 |
| Estradiol | 2643 | 0.6769 |
| Clopidogrel Bisulfate | 2574 | 0.6592 |
| Cyclobenzaprine Hcl | 2553 | 0.6538 |
| Lorazepam | 2535 | 0.6492 |
| Citalopram Hydrobromide | 2528 | 0.6474 |
| Insulin Glargine,hum.Rec.Anlog | 2476 | 0.6341 |
| Lisinopril/Hydrochlorothiazide | 2336 | 0.5982 |
| Fluticasone Propion/Salmeterol | 2316 | 0.5931 |
| Ondansetron | 2285 | 0.5852 |
| Celecoxib | 2285 | 0.5852 |
| Rivaroxaban | 2278 | 0.5834 |
| Quetiapine Fumarate | 2270 | 0.5813 |
| Triamcinolone Acetonide | 2254 | 0.5772 |
| Mirtazapine | 2221 | 0.5688 |
| Doxycycline Hyclate | 2216 | 0.5675 |
| Alprazolam | 2202 | 0.5639 |
| Pravastatin Sodium | 2184 | 0.5593 |
| Finasteride | 2178 | 0.5578 |
| Clonazepam | 2166 | 0.5547 |
| Propranolol Hcl | 2162 | 0.5537 |
| Azithromycin | 2149 | 0.5504 |
| Glipizide | 2118 | 0.5424 |
| Oxycodone Hcl/Acetaminophen | 2094 | 0.5363 |
| Ezetimibe | 2046 | 0.524 |
| Buspirone Hcl | 1979 | 0.5068 |
| Losartan/Hydrochlorothiazide | 1915 | 0.4904 |
| Tizanidine Hcl | 1816 | 0.4651 |
| Warfarin Sodium | 1782 | 0.4564 |
| Hydroxyzine Hcl | 1773 | 0.4541 |
| Atenolol | 1771 | 0.4536 |
| Oxybutynin Chloride | 1727 | 0.4423 |
| Dulaglutide | 1637 | 0.4192 |
| Nitrofurantoin Monohyd/M-Cryst | 1607 | 0.4116 |
| Lamotrigine | 1604 | 0.4108 |
| Methocarbamol | 1563 | 0.4003 |
| Baclofen | 1523 | 0.39 |
| Diclofenac Sodium | 1508 | 0.3862 |
| Donepezil Hcl | 1504 | 0.3852 |
| Ibuprofen | 1473 | 0.3772 |
| Sulfamethoxazole/Trimethoprim | 1425 | 0.3649 |
| Acyclovir | 1405 | 0.3598 |
| Diltiazem Hcl | 1386 | 0.355 |
| Amitriptyline Hcl | 1378 | 0.3529 |
| Tiotropium Bromide | 1360 | 0.3483 |
| Morphine Sulfate | 1323 | 0.3388 |
| Valacyclovir Hcl | 1318 | 0.3375 |
| Tirzepatide | 1296 | 0.3319 |
| Diazepam | 1260 | 0.3227 |
| Budesonide/Formoterol Fumarate | 1249 | 0.3199 |
| Aripiprazole | 1208 | 0.3094 |
| Mirabegron | 1207 | 0.3091 |
| Methylprednisolone | 1200 | 0.3073 |
| Triamterene/Hydrochlorothiazid | 1183 | 0.303 |
| Ondansetron Hcl | 1166 | 0.2986 |
| Dapagliflozin Propanediol | 1152 | 0.295 |
| Ropinirole Hcl | 1150 | 0.2945 |
| Fluticasone/Umeclidin/Vilanter | 1143 | 0.2927 |
| Olanzapine | 1116 | 0.2858 |
| Paroxetine Hcl | 1112 | 0.2848 |
| Divalproex Sodium | 1107 | 0.2835 |
| Topiramate | 1090 | 0.2791 |
| Latanoprost | 1085 | 0.2779 |
| Dextroamphetamine/Amphetamine | 1070 | 0.274 |
| Nystatin | 1037 | 0.2656 |
| Levetiracetam | 1029 | 0.2635 |
| Ipratropium Bromide | 999 | 0.2558 |
| Sumatriptan Succinate | 995 | 0.2548 |
| Memantine Hcl | 994 | 0.2546 |
| Lovastatin | 981 | 0.2512 |
| Chlorthalidone | 939 | 0.2405 |
| Pen Needle, Diabetic | 923 | 0.2364 |
| Hydralazine Hcl | 895 | 0.2292 |
| Valsartan | 889 | 0.2277 |
| Pioglitazone Hcl | 879 | 0.2251 |
| Risperidone | 873 | 0.2236 |
| Carbidopa/Levodopa | 870 | 0.2228 |
| Olmesartan Medoxomil | 858 | 0.2197 |
| Fluconazole | 821 | 0.2103 |
| Ciprofloxacin Hcl | 810 | 0.2074 |
| Mupirocin | 782 | 0.2003 |
| Clobetasol Propionate | 755 | 0.1934 |
| Pramipexole Di-Hcl | 748 | 0.1916 |
| Cefuroxime Axetil | 745 | 0.1908 |
| Esomeprazole Magnesium | 742 | 0.19 |
| Sitagliptin Phosphate | 737 | 0.1887 |
| Insulin Lispro | 737 | 0.1887 |
| Lidocaine | 736 | 0.1885 |
| Clonidine Hcl | 728 | 0.1864 |
| Doxazosin Mesylate | 725 | 0.1857 |
| Ketoconazole | 712 | 0.1823 |
| Nirmatrelvir/Ritonavir | 683 | 0.1749 |
| Azelastine Hcl | 680 | 0.1741 |
| Hydrocortisone | 669 | 0.1713 |
| Evolocumab | 659 | 0.1688 |
| Chlorhexidine Gluconate | 643 | 0.1647 |
| Fluticasone/Vilanterol | 635 | 0.1626 |
| Dicyclomine Hcl | 626 | 0.1603 |
| Naproxen | 623 | 0.1596 |
| Bumetanide | 619 | 0.1585 |
| Irbesartan | 580 | 0.1485 |
| Dabigatran Etexilate Mesylate | 574 | 0.147 |
| Isosorbide Mononitrate | 570 | 0.146 |
| Doxycycline Monohydrate | 568 | 0.1455 |
| Varicella-Zoster Ge/As01b/Pf | 554 | 0.1419 |
| Temazepam | 553 | 0.1416 |
| Hydromorphone Hcl | 549 | 0.1406 |
| Solifenacin Succinate | 541 | 0.1385 |
| Cyclosporine | 541 | 0.1385 |
| Glimepiride | 535 | 0.137 |
| Dexamethasone | 535 | 0.137 |
| Nitroglycerin | 516 | 0.1321 |
| Linaclotide | 514 | 0.1316 |
| Sacubitril/Valsartan | 513 | 0.1314 |
| Methylphenidate Hcl | 512 | 0.1311 |
| Eszopiclone | 506 | 0.1296 |
| Timolol Maleate | 505 | 0.1293 |
| Amiodarone Hcl | 505 | 0.1293 |
| Rsvpref3 Antigen/As01e/Pf | 497 | 0.1273 |
| Prazosin Hcl | 492 | 0.126 |
| Lithium Carbonate | 490 | 0.1255 |
| Fenofibrate | 483 | 0.1237 |
| Nortriptyline Hcl | 481 | 0.1232 |
| Progesterone, Micronized | 479 | 0.1227 |
| Prednisolone Acetate | 477 | 0.1222 |
| Carbamazepine | 477 | 0.1222 |
| Torsemide | 475 | 0.1216 |
| Testosterone Cypionate | 473 | 0.1211 |
| Sucralfate | 471 | 0.1206 |
| Insulin Glargine-Yfgn | 468 | 0.1199 |
| Insulin Degludec | 467 | 0.1196 |
| Brimonidine Tartrate | 464 | 0.1188 |
| Umeclidinium Brm/Vilanterol Tr | 443 | 0.1135 |
| Verapamil Hcl | 437 | 0.1119 |
| Buprenorphine Hcl/Naloxone Hcl | 430 | 0.1101 |
| Clindamycin Hcl | 423 | 0.1083 |
| Liothyronine Sodium | 422 | 0.1081 |
| Nebivolol Hcl | 419 | 0.1073 |
| Benazepril Hcl | 416 | 0.1065 |
| Levofloxacin | 412 | 0.1055 |
| Dorzolamide Hcl/Timolol Maleat | 409 | 0.1047 |
| Primidone | 389 | 0.0996 |
| Colchicine | 388 | 0.0994 |
| Buprenorphine | 378 | 0.0968 |
| Fentanyl | 368 | 0.0942 |
| Cefdinir | 366 | 0.0937 |
| Metronidazole | 362 | 0.0927 |
| Oxcarbazepine | 360 | 0.0922 |
| Lactulose | 360 | 0.0922 |
| Dupilumab | 358 | 0.0917 |
| Digoxin | 352 | 0.0901 |
| Diph,pertuss(Acell),tet Vac/Pf | 351 | 0.0899 |
| Acetaminophen With Codeine | 350 | 0.0896 |
| Clozapine | 348 | 0.0891 |
| Insulin Aspart | 347 | 0.0889 |
| Doxepin Hcl | 346 | 0.0886 |
| Lipase/Protease/Amylase | 344 | 0.0881 |
| Buprenorphine Hcl | 342 | 0.0876 |
| Tiotropium Br/Olodaterol Hcl | 339 | 0.0868 |
| Linagliptin | 336 | 0.086 |
| Benztropine Mesylate | 336 | 0.086 |
| Terazosin Hcl | 334 | 0.0855 |
| Midodrine Hcl | 330 | 0.0845 |
| Lurasidone Hcl | 325 | 0.0832 |
| Desvenlafaxine Succinate | 323 | 0.0827 |
| Methenamine Hippurate | 315 | 0.0807 |
| Ipratropium/Albuterol Sulfate | 314 | 0.0804 |
| Hydroxychloroquine Sulfate | 312 | 0.0799 |
| Budesonide/Glycopyr/Formoterol | 312 | 0.0799 |
| Testosterone | 311 | 0.0796 |
| Insulin Nph Human Isophane | 310 | 0.0794 |
| Vibegron | 305 | 0.0781 |
| Umeclidinium Bromide | 305 | 0.0781 |
| Fenofibrate Nanocrystallized | 304 | 0.0779 |
| Anastrozole | 303 | 0.0776 |
| Meclizine Hcl | 302 | 0.0773 |
| Erythromycin Base | 301 | 0.0771 |
| Nifedipine | 300 | 0.0768 |
| Lacosamide | 297 | 0.0761 |
| Fluorouracil | 294 | 0.0753 |
| Valsartan/Hydrochlorothiazide | 292 | 0.0748 |
| Promethazine Hcl | 290 | 0.0743 |
| Methotrexate Sodium | 286 | 0.0732 |
| Hydroxyzine Pamoate | 286 | 0.0732 |
| Rizatriptan Benzoate | 283 | 0.0725 |
| Flecainide Acetate | 280 | 0.0717 |
| Ciclesonide | 279 | 0.0715 |
| Neomycin/Polymyxin B/Dexametha | 277 | 0.0709 |
| Adalimumab | 275 | 0.0704 |
| Trospium Chloride | 274 | 0.0702 |
| Prochlorperazine Maleate | 267 | 0.0684 |
| Methadone Hcl | 266 | 0.0681 |
| Peg3350/Sod Sulf,bicarb,cl/Kcl | 264 | 0.0676 |
| Brimonidine Tartrate/Timolol | 258 | 0.0661 |
| Cariprazine Hcl | 255 | 0.0653 |
| Budesonide | 254 | 0.065 |
| Ergocalciferol (Vitamin D2) | 241 | 0.0617 |
| Oxycodone Myristate | 239 | 0.0612 |
| Alfuzosin Hcl | 238 | 0.061 |
| Bimatoprost | 237 | 0.0607 |
| Butalb/Acetaminophen/Caffeine | 235 | 0.0602 |
| Ibandronate Sodium | 234 | 0.0599 |
| Naloxone Hcl | 233 | 0.0597 |
| Ofloxacin | 232 | 0.0594 |
| Bisoprolol Fumarate | 232 | 0.0594 |
| Ketorolac Tromethamine | 231 | 0.0592 |
| Calcitriol | 229 | 0.0586 |
| Ramipril | 228 | 0.0584 |
| Telmisartan | 226 | 0.0579 |
| Clindamycin Phosphate | 220 | 0.0563 |
| Amlodipine Besylate/Benazepril | 220 | 0.0563 |
| Dorzolamide Hcl | 213 | 0.0545 |
| Ziprasidone Hcl | 212 | 0.0543 |
| Mycophenolate Mofetil | 212 | 0.0543 |
| Terbinafine Hcl | 211 | 0.054 |
| Dutasteride | 210 | 0.0538 |
| Azathioprine | 210 | 0.0538 |
| Letrozole | 209 | 0.0535 |
| Lansoprazole | 208 | 0.0533 |
| Fluticasone Furoate | 208 | 0.0533 |
| Enalapril Maleate | 208 | 0.0533 |
| Rimegepant Sulfate | 206 | 0.0528 |
| Methimazole | 205 | 0.0525 |
| Mesalamine | 205 | 0.0525 |
| Paliperidone Palmitate | 202 | 0.0517 |
| Minoxidil | 202 | 0.0517 |
| Haloperidol | 202 | 0.0517 |
| Varenicline Tartrate | 200 | 0.0512 |
| Fluocinonide | 192 | 0.0492 |
| Suvorexant | 191 | 0.0489 |
| Thyroid,pork | 190 | 0.0487 |
| Sotalol Hcl | 190 | 0.0487 |
| Sildenafil Citrate | 190 | 0.0487 |
| Naltrexone Hcl | 190 | 0.0487 |
| Diphth,pertuss(Acell),tet Vac | 190 | 0.0487 |
| Hydroxyurea | 189 | 0.0484 |
| Mometasone/Formoterol | 188 | 0.0481 |
| Diphenoxylate Hcl/Atropine | 187 | 0.0479 |
| Rifaximin | 181 | 0.0464 |
| Levocetirizine Dihydrochloride | 180 | 0.0461 |
| Amantadine Hcl | 180 | 0.0461 |
| Labetalol Hcl | 178 | 0.0456 |
| Galcanezumab-Gnlm | 177 | 0.0453 |
| Tacrolimus | 176 | 0.0451 |
| Fluorometholone | 174 | 0.0446 |
| Tadalafil | 171 | 0.0438 |
| Icosapent Ethyl | 171 | 0.0438 |
| Lenalidomide | 170 | 0.0435 |
| Metoclopramide Hcl | 169 | 0.0433 |
| Enoxaparin Sodium | 168 | 0.043 |
| Gemfibrozil | 167 | 0.0428 |
| Insulin Regular, Human | 166 | 0.0425 |
| Alirocumab | 165 | 0.0423 |
| Lisdexamfetamine Dimesylate | 164 | 0.042 |
| Potassium Citrate | 163 | 0.0417 |
| Clotrimazole/Betamethasone Dip | 163 | 0.0417 |
| Lidocaine/Prilocaine | 161 | 0.0412 |
| Zonisamide | 160 | 0.041 |
| Syringe-Needle,insulin,0.5 Ml | 160 | 0.041 |
| Modafinil | 159 | 0.0407 |
| Erenumab-Aooe | 159 | 0.0407 |
| Sevelamer Carbonate | 158 | 0.0405 |
| Phenytoin Sodium Extended | 158 | 0.0405 |
| Cholestyramine (With Sugar) | 158 | 0.0405 |
| Ursodiol | 157 | 0.0402 |
| Folic Acid | 156 | 0.04 |
| Dexlansoprazole | 156 | 0.04 |
| Sulfasalazine | 155 | 0.0397 |
| Carisoprodol | 155 | 0.0397 |
| Vortioxetine Hydrobromide | 153 | 0.0392 |
| Brexpiprazole | 152 | 0.0389 |
| Rsv Vacc, Pref A And Pref B/Pf | 151 | 0.0387 |
| Paliperidone | 151 | 0.0387 |
| Insulin Detemir | 150 | 0.0384 |
| Etanercept | 148 | 0.0379 |
| Valbenazine Tosylate | 146 | 0.0374 |
| Ranolazine | 146 | 0.0374 |
| Ciclopirox | 145 | 0.0371 |
| Estrogens, Conjugated | 141 | 0.0361 |
| Tamoxifen Citrate | 140 | 0.0359 |
| Lubiprostone | 139 | 0.0356 |
| Moxifloxacin Hcl | 138 | 0.0353 |
| Mometasone Furoate | 133 | 0.0341 |
| Abiraterone Acetate | 132 | 0.0338 |
| Colestipol Hcl | 131 | 0.0335 |
| Nitrofurantoin Macrocrystal | 130 | 0.0333 |
| Olmesartan/Hydrochlorothiazide | 129 | 0.033 |
| Loperamide Hcl | 127 | 0.0325 |
| Penicillin V Potassium | 126 | 0.0323 |
| Metolazone | 126 | 0.0323 |
| Cefadroxil | 126 | 0.0323 |
| Naloxegol Oxalate | 124 | 0.0318 |
| Guanfacine Hcl | 121 | 0.031 |
| Teriparatide | 120 | 0.0307 |
| Lifitegrast | 118 | 0.0302 |
| Sodium, Potassium,mag Sulfates | 117 | 0.03 |
| Bictegrav/Emtricit/Tenofov Ala | 116 | 0.0297 |
| Atomoxetine Hcl | 116 | 0.0297 |
| Tretinoin | 115 | 0.0295 |
| Raloxifene Hcl | 115 | 0.0295 |
| Omega-3 Acid Ethyl Esters | 115 | 0.0295 |
| Leflunomide | 113 | 0.0289 |
| Ubrogepant | 112 | 0.0287 |
| Travoprost | 112 | 0.0287 |
| Fluvoxamine Maleate | 111 | 0.0284 |
| Vilazodone Hcl | 110 | 0.0282 |
| Fludrocortisone Acetate | 110 | 0.0282 |
| Deutetrabenazine | 110 | 0.0282 |
| Eplerenone | 107 | 0.0274 |
| Tobramycin/Dexamethasone | 104 | 0.0266 |
| Sodium Chloride/Nahco3/Kcl/Peg | 104 | 0.0266 |
| Lidocaine Hcl | 101 | 0.0259 |
| Cefpodoxime Proxetil | 101 | 0.0259 |
| Tapentadol Hcl | 100 | 0.0256 |
| Alcohol Antiseptic Pads | 100 | 0.0256 |
| Pilocarpine Hcl | 98 | 0.0251 |
| Tolterodine Tartrate | 96 | 0.0246 |
| Atogepant | 96 | 0.0246 |
| Secukinumab | 94 | 0.0241 |
| Ticagrelor | 91 | 0.0233 |
| Sitagliptin Phos/Metformin Hcl | 89 | 0.0228 |
| Dofetilide | 89 | 0.0228 |
| Sodium Zirconium Cyclosilicate | 88 | 0.0225 |
| Fremanezumab-Vfrm | 85 | 0.0218 |
| Cinacalcet Hcl | 85 | 0.0218 |
| Calcium Acetate | 85 | 0.0218 |
| Imiquimod | 84 | 0.0215 |
| Sod Sulf/Pot Chloride/Mag Sulf | 83 | 0.0213 |
| Denosumab | 83 | 0.0213 |
| Betamethasone Dipropionate | 83 | 0.0213 |
| Syringe And Needle,insulin,1ml | 82 | 0.021 |
| Atropine Sulfate | 82 | 0.021 |
| Tofacitinib Citrate | 81 | 0.0207 |
| Fluoride (Sodium) | 80 | 0.0205 |
| Ibrutinib | 79 | 0.0202 |
| Enzalutamide | 79 | 0.0202 |
| 0.9 % Sodium Chloride | 79 | 0.0202 |
| Canagliflozin | 78 | 0.02 |
| Phenobarbital | 77 | 0.0197 |
| Ruxolitinib Phosphate | 76 | 0.0195 |
| Medroxyprogesterone Acetate | 76 | 0.0195 |
| Acetazolamide | 76 | 0.0195 |
| Upadacitinib | 75 | 0.0192 |
| Pyridostigmine Bromide | 75 | 0.0192 |
| Insulin Pump Cart,auto,bt,g6/7 | 75 | 0.0192 |
| Exemestane | 75 | 0.0192 |
| Emtricitabine/Tenofov Alafenam | 75 | 0.0192 |
| Clotrimazole | 75 | 0.0192 |
| Indomethacin | 74 | 0.019 |
| Dextroamphetamine Sulfate | 74 | 0.019 |
| Clobazam | 74 | 0.019 |
| Betamethasone/Propylene Glyc | 74 | 0.019 |
| Nabumetone | 73 | 0.0187 |
| Clonidine | 73 | 0.0187 |
| Brinzolamide/Brimonidine Tart | 73 | 0.0187 |
| Abatacept | 73 | 0.0187 |
| Dolutegravir Sodium | 72 | 0.0184 |
| Desmopressin Acetate | 72 | 0.0184 |
| Apremilast | 72 | 0.0184 |
| Abaloparatide | 72 | 0.0184 |
| Ramelteon | 71 | 0.0182 |
| Haloperidol Decanoate | 71 | 0.0182 |
| Dronedarone Hcl | 71 | 0.0182 |
| Rivastigmine | 70 | 0.0179 |
| Trihexyphenidyl Hcl | 69 | 0.0177 |
| Insulin Aspart (Niacinamide) | 69 | 0.0177 |
| Cilostazol | 69 | 0.0177 |
| Prasugrel Hcl | 68 | 0.0174 |
| Nintedanib Esylate | 68 | 0.0174 |
| Acalabrutinib Maleate | 68 | 0.0174 |
| Fenofibrate,micronized | 67 | 0.0172 |
| Relugolix | 66 | 0.0169 |
| Zanubrutinib | 65 | 0.0166 |
| Risedronate Sodium | 65 | 0.0166 |
| Lumateperone Tosylate | 65 | 0.0166 |
| Insulin Nph Hum/Reg Insulin Hm | 65 | 0.0166 |
| Dalfampridine | 65 | 0.0166 |
| Syring-Needl,disp,insul,0.3 Ml | 64 | 0.0164 |
| Minocycline Hcl | 64 | 0.0164 |
| Epinephrine | 64 | 0.0164 |
| Ceftriaxone Sodium | 64 | 0.0164 |
| Zaleplon | 63 | 0.0161 |
| Trimethoprim | 63 | 0.0161 |
| Triazolam | 63 | 0.0161 |
| Beclomethasone Dipropionate | 63 | 0.0161 |
| Ammonium Lactate | 63 | 0.0161 |
| Palbociclib | 62 | 0.0159 |
| Netarsudil Mesylate | 62 | 0.0159 |
| Rivastigmine Tartrate | 61 | 0.0156 |
| Loteprednol Etabonate | 61 | 0.0156 |
| Imatinib Mesylate | 61 | 0.0156 |
| Glycopyrrolate | 61 | 0.0156 |
| Pen Needle,dual Safety,diabetc | 59 | 0.0151 |
| Ciclopirox Olamine | 59 | 0.0151 |
| Silodosin | 58 | 0.0149 |
| Rabeprazole Sodium | 58 | 0.0149 |
| Febuxostat | 58 | 0.0149 |
| Vancomycin Hcl | 57 | 0.0146 |
| Roflumilast | 57 | 0.0146 |
| Perphenazine | 56 | 0.0143 |
| Brivaracetam | 56 | 0.0143 |
| Venetoclax | 55 | 0.0141 |
| Colesevelam Hcl | 55 | 0.0141 |
| Fluphenazine Hcl | 54 | 0.0138 |
| Dorzolamide/Timolol/Pf | 54 | 0.0138 |
| Ustekinumab | 52 | 0.0133 |
| Peg 3350/Sod Sulf,chlr/Pot/Mag | 52 | 0.0133 |
| Netarsudil Mesylat/Latanoprost | 52 | 0.0133 |
| Candesartan Cilexetil | 52 | 0.0133 |
| Rasagiline Mesylate | 51 | 0.0131 |
| Plecanatide | 51 | 0.0131 |
| Scopolamine | 50 | 0.0128 |
| Bisoprolol/Hydrochlorothiazide | 50 | 0.0128 |
| Armodafinil | 50 | 0.0128 |
| Lemborexant | 49 | 0.0125 |
| Polymyxin B Sulf/Trimethoprim | 48 | 0.0123 |
| Osimertinib Mesylate | 48 | 0.0123 |
| Naratriptan Hcl | 48 | 0.0123 |
| Isosorbide Dinitrate | 48 | 0.0123 |
| Valproic Acid (As Sodium Salt) | 47 | 0.012 |
| Megestrol Acetate | 47 | 0.012 |
| Cyanocobalamin (Vitamin B-12) | 47 | 0.012 |
| Ciprofloxacin Hcl/Dexameth | 47 | 0.012 |
| Prucalopride Succinate | 46 | 0.0118 |
| Dextromethorphan Hbr/Quinidine | 46 | 0.0118 |
| Tramadol Hcl/Acetaminophen | 45 | 0.0115 |
| Tafamidis | 45 | 0.0115 |
| Levalbuterol Tartrate | 45 | 0.0115 |
| Ixekizumab | 45 | 0.0115 |
| Chlorpromazine Hcl | 45 | 0.0115 |
| Ambrisentan | 45 | 0.0115 |
| Pentoxifylline | 44 | 0.0113 |
| Oseltamivir Phosphate | 44 | 0.0113 |
| Dolutegravir Sodium/Lamivudine | 44 | 0.0113 |
| Daptomycin | 44 | 0.0113 |
| Calcipotriene | 44 | 0.0113 |
| Teriflunomide | 43 | 0.011 |
| Irbesartan/Hydrochlorothiazide | 43 | 0.011 |
| Glatiramer Acetate | 43 | 0.011 |
| Exenatide Microspheres | 43 | 0.011 |
| Dimethyl Fumarate | 43 | 0.011 |
| Abacavir/Dolutegravir/Lamivudi | 43 | 0.011 |
| Pimavanserin Tartrate | 42 | 0.0108 |
| Etodolac | 42 | 0.0108 |
| Cyproheptadine Hcl | 42 | 0.0108 |
| Pomalidomide | 41 | 0.0105 |
| Latanoprostene Bunod | 41 | 0.0105 |
| Glycopyrrolate/Formoterol Fum | 41 | 0.0105 |
| Felodipine | 41 | 0.0105 |
| Cevimeline Hcl | 41 | 0.0105 |
| Apalutamide | 41 | 0.0105 |
| Amlodipine Bes/Olmesartan Med | 41 | 0.0105 |
| Tocilizumab | 40 | 0.0102 |
| Fesoterodine Fumarate | 40 | 0.0102 |
| Calcitonin,salmon,synthetic | 40 | 0.0102 |
| Risperidone Microspheres | 39 | 0.01 |
| Glucagon | 39 | 0.01 |
| Finerenone | 39 | 0.01 |
| Elviteg/Cob/Emtri/Tenof Alafen | 39 | 0.01 |
| Asenapine Maleate | 39 | 0.01 |
| Sucroferric Oxyhydroxide | 38 | 0.0097 |
| Pirfenidone | 38 | 0.0097 |
| Pitavastatin Calcium | 37 | 0.0095 |
| Mycophenolate Sodium | 37 | 0.0095 |
| Gentamicin Sulfate | 37 | 0.0095 |
| Desonide | 37 | 0.0095 |
| Cenobamate | 37 | 0.0095 |
| Silver Sulfadiazine | 36 | 0.0092 |
| Leucovorin Calcium | 36 | 0.0092 |
| Abemaciclib | 36 | 0.0092 |
| Empagliflozin/Metformin Hcl | 35 | 0.009 |
| Valganciclovir Hcl | 34 | 0.0087 |
| Onabotulinumtoxina | 34 | 0.0087 |
| Insulin Glargine/Lixisenatide | 34 | 0.0087 |
| Imipramine Hcl | 34 | 0.0087 |
| Darolutamide | 34 | 0.0087 |
| Amiloride Hcl | 34 | 0.0087 |
| Macitentan | 33 | 0.0085 |
| Immune Globul G/Gly/Iga Avg 46 | 33 | 0.0085 |
| Cholestyramine | 33 | 0.0085 |
| Cefazolin Sodium | 33 | 0.0085 |
| Tenofovir Alafenamide | 32 | 0.0082 |
| Spironolact/Hydrochlorothiazid | 32 | 0.0082 |
| Salmeterol Xinafoate | 32 | 0.0082 |
| Patiromer Calcium Sorbitex | 32 | 0.0082 |
| Dolutegravir/Rilpivirine | 32 | 0.0082 |
| Dexmethylphenidate Hcl | 32 | 0.0082 |
| Clomipramine Hcl | 32 | 0.0082 |
| Ofatumumab | 31 | 0.0079 |
| Liraglutide | 31 | 0.0079 |
| Immun Glob G(Igg)/Gly/Iga Ov50 | 31 | 0.0079 |
| Difluprednate | 31 | 0.0079 |
| Brinzolamide | 31 | 0.0079 |
| Bicalutamide | 31 | 0.0079 |
| Olanzapine/Samidorphan Malate | 30 | 0.0077 |
| Mepolizumab | 30 | 0.0077 |
| Glyburide | 30 | 0.0077 |
| Entacapone | 30 | 0.0077 |
| Diclofenac Potassium | 30 | 0.0077 |
| Amlodipine Besylate/Valsartan | 30 | 0.0077 |
| Adalimumab-Atto | 30 | 0.0077 |
| Riociguat | 29 | 0.0074 |
| Perfluorohexyloctane/Pf | 29 | 0.0074 |
| Omalizumab | 29 | 0.0074 |
| Neomycin Sulfate | 29 | 0.0074 |
| Ertapenem Sodium | 29 | 0.0074 |
| Emtricitab/Rilpiviri/Tenof Ala | 29 | 0.0074 |
| Dapsone | 29 | 0.0074 |
| Aripiprazole Lauroxil | 29 | 0.0074 |
| Tafluprost/Pf | 28 | 0.0072 |
| Loxapine Succinate | 28 | 0.0072 |
| Balsalazide Disodium | 28 | 0.0072 |
| Tobramycin | 27 | 0.0069 |
| Darunavir/Cobicistat | 27 | 0.0069 |
| Daridorexant Hcl | 27 | 0.0069 |
| Perampanel | 26 | 0.0067 |
| Insulin Lispro Protamin/Lispro | 26 | 0.0067 |
| Immun Glob G(Igg)/Pro/Iga 0-50 | 26 | 0.0067 |
| Fluocinolone Acetonide Oil | 26 | 0.0067 |
| Cannabidiol (Cbd) | 26 | 0.0067 |
| Butalbit/Acetamin/Caff/Codeine | 26 | 0.0067 |
| Propafenone Hcl | 25 | 0.0064 |
| Milnacipran Hcl | 25 | 0.0064 |
| Hydrocodone Bitartrate | 25 | 0.0064 |
| Filgrastim-Aafi | 25 | 0.0064 |
| Entecavir | 25 | 0.0064 |
| Clorazepate Dipotassium | 25 | 0.0064 |
| Cabergoline | 25 | 0.0064 |
| Famciclovir | 24 | 0.0061 |
| Eletriptan Hydrobromide | 24 | 0.0061 |
| Diphenhydramine Hcl | 24 | 0.0061 |
| Ribociclib Succinate | 23 | 0.0059 |
| Raltegravir Potassium | 23 | 0.0059 |
| Methotrexate Sodium/Pf | 23 | 0.0059 |
| Galantamine Hbr | 23 | 0.0059 |
| Everolimus | 23 | 0.0059 |
| Darunavir | 23 | 0.0059 |
| Ritonavir | 22 | 0.0056 |
| Rifampin | 22 | 0.0056 |
| Posaconazole | 22 | 0.0056 |
| Olaparib | 22 | 0.0056 |
| Insulin Aspart Prot/Insuln Asp | 22 | 0.0056 |
| Fluocinolone Acetonide | 22 | 0.0056 |
| Felbamate | 22 | 0.0056 |
| Benralizumab | 22 | 0.0056 |
| Belimumab | 22 | 0.0056 |
| Acamprosate Calcium | 22 | 0.0056 |
| Selegiline Hcl | 21 | 0.0054 |
| Sarilumab | 21 | 0.0054 |
| Rotigotine | 21 | 0.0054 |
| Risankizumab-Rzaa | 21 | 0.0054 |
| Methylnaltrexone Bromide | 21 | 0.0054 |
| Iloperidone | 21 | 0.0054 |
| Fluphenazine Decanoate | 21 | 0.0054 |
| Darunavir/Cob/Emtri/Tenof Alaf | 21 | 0.0054 |
| Theophylline Anhydrous | 20 | 0.0051 |
| Rufinamide | 20 | 0.0051 |
| Repaglinide | 20 | 0.0051 |
| Dicloxacillin Sodium | 20 | 0.0051 |
| Cromolyn Sodium | 20 | 0.0051 |
| Bromfenac Sodium | 20 | 0.0051 |
| Atovaquone/Proguanil Hcl | 20 | 0.0051 |
| Alpha-1-Proteinase Inhibitor | 20 | 0.0051 |
| Valproic Acid | 19 | 0.0049 |
| Selexipag | 19 | 0.0049 |
| Nilotinib Hcl | 19 | 0.0049 |
| Nadolol | 19 | 0.0049 |
| Interferon Beta-1a | 19 | 0.0049 |
| Insulin Lispro-Aabc | 19 | 0.0049 |
| Indapamide | 19 | 0.0049 |
| Fosinopril Sodium | 19 | 0.0049 |
| Eslicarbazepine Acetate | 19 | 0.0049 |
| Dasatinib | 19 | 0.0049 |
| Bempedoic Acid/Ezetimibe | 19 | 0.0049 |
| Acitretin | 19 | 0.0049 |
| Tetrabenazine | 18 | 0.0046 |
| Niacin | 18 | 0.0046 |
| Midazolam | 18 | 0.0046 |
| Mexiletine Hcl | 18 | 0.0046 |
| Isavuconazonium Sulfate | 18 | 0.0046 |
| Golimumab | 18 | 0.0046 |
| Fingolimod Hcl | 18 | 0.0046 |
| Ethambutol Hcl | 18 | 0.0046 |
| Dapaglifloz Propaned/Metformin | 18 | 0.0046 |
| Butalbital/Aspirin/Caffeine | 18 | 0.0046 |
| Betamethasone Valerate | 18 | 0.0046 |
| Neomycin/Polymyxin B/Hydrocort | 17 | 0.0044 |
| Naltrexone Microspheres | 17 | 0.0044 |
| Levomilnacipran Hcl | 17 | 0.0044 |
| Fosfomycin Tromethamine | 17 | 0.0044 |
| Fezolinetant | 17 | 0.0044 |
| Epoetin Alfa | 17 | 0.0044 |
| Efinaconazole | 17 | 0.0044 |
| Certolizumab Pegol | 17 | 0.0044 |
| Bethanechol Chloride | 17 | 0.0044 |
| Benazepril/Hydrochlorothiazide | 17 | 0.0044 |
| Bempedoic Acid | 17 | 0.0044 |
| Azelastine/Fluticasone | 17 | 0.0044 |
| Acetic Acid | 17 | 0.0044 |
| Sulindac | 16 | 0.0041 |
| Probenecid | 16 | 0.0041 |
| Phenytoin | 16 | 0.0041 |
| Parenteral Amino Acid 20% No.1 | 16 | 0.0041 |
| Emtricitabine/Tenofovir (Tdf) | 16 | 0.0041 |
| Droxidopa | 16 | 0.0041 |
| Doravirine | 16 | 0.0041 |
| Cimetidine | 16 | 0.0041 |
| Acarbose | 16 | 0.0041 |
| Riluzole | 15 | 0.0038 |
| Nystatin/Triamcinolone Acet | 15 | 0.0038 |
| Lotilaner | 15 | 0.0038 |
| Ezetimibe/Simvastatin | 15 | 0.0038 |
| Tezepelumab-Ekko | 14 | 0.0036 |
| Sirolimus | 14 | 0.0036 |
| Norethindrone Acetate | 14 | 0.0036 |
| Interferon Beta-1a/Albumin | 14 | 0.0036 |
| Estrogen,con/M-Progest Acet | 14 | 0.0036 |
| Esketamine Hcl | 14 | 0.0036 |
| Eltrombopag Olamine | 14 | 0.0036 |
| Dextromethorphan Hbr/Bupropion | 14 | 0.0036 |
| Cabozantinib S-Malate | 14 | 0.0036 |
| Alectinib Hcl | 14 | 0.0036 |
| Tranexamic Acid | 13 | 0.0033 |
| Tenofovir Disoproxil Fumarate | 13 | 0.0033 |
| Pimecrolimus | 13 | 0.0033 |
| Pentosan Polysulfate Sodium | 13 | 0.0033 |
| Oxymorphone Hcl | 13 | 0.0033 |
| Ondansetron Hcl/Pf | 13 | 0.0033 |
| Obeticholic Acid | 13 | 0.0033 |
| Lanthanum Carbonate | 13 | 0.0033 |
| Eluxadoline | 13 | 0.0033 |
| Dantrolene Sodium | 13 | 0.0033 |
| Collagenase Clostridium Hist. | 13 | 0.0033 |
| Carvedilol Phosphate | 13 | 0.0033 |
| Zolmitriptan | 12 | 0.0031 |
| Sumatriptan | 12 | 0.0031 |
| Norgestimate-Ethinyl Estradiol | 12 | 0.0031 |
| Molnupiravir | 12 | 0.0031 |
| Mavacamten | 12 | 0.0031 |
| Hydrocodone/Ibuprofen | 12 | 0.0031 |
| Edaravone | 12 | 0.0031 |
| Diroximel Fumarate | 12 | 0.0031 |
| Carbidopa | 12 | 0.0031 |
| Butorphanol Tartrate | 12 | 0.0031 |
| Treprostinil Diolamine | 11 | 0.0028 |
| Somatropin | 11 | 0.0028 |
| Sod Picosulf/Mag Ox/Citric Ac | 11 | 0.0028 |
| Misoprostol | 11 | 0.0028 |
| Econazole Nitrate | 11 | 0.0028 |
| Disulfiram | 11 | 0.0028 |
| Dexamethasone Sodium Phosphate | 11 | 0.0028 |
| Cyclosporine, Modified | 11 | 0.0028 |
| Clarithromycin | 11 | 0.0028 |
| Anagrelide Hcl | 11 | 0.0028 |
| Zafirlukast | 10 | 0.0026 |
| Treprostinil | 10 | 0.0026 |
| Timolol | 10 | 0.0026 |
| Telmisartan/Hydrochlorothiazid | 10 | 0.0026 |
| Memantine Hcl/Donepezil Hcl | 10 | 0.0026 |
| Lenvatinib Mesylate | 10 | 0.0026 |
| Gabapentin Enacarbil | 10 | 0.0026 |
| Ferric Citrate | 10 | 0.0026 |
| Fenofibric Acid (Choline) | 10 | 0.0026 |
| Etravirine | 10 | 0.0026 |
| Desloratadine | 10 | 0.0026 |
| Chlorzoxazone | 10 | 0.0026 |
| Atovaquone | 10 | 0.0026 |
| Ampicillin Sodium | 10 | 0.0026 |
| Tetanus-Diphtheria Toxoids/Pf | 9 | 0.0023 |
| Testosterone Enanthate | 9 | 0.0023 |
| Tenapanor Hcl | 9 | 0.0023 |
| Sodium,calcium,mag,pot Oxybate | 9 | 0.0023 |
| Ringer's Solution,lactated | 9 | 0.0023 |
| Norethindrone Ac/Eth Estradiol | 9 | 0.0023 |
| Levocarnitine (With Sugar) | 9 | 0.0023 |
| Lasmiditan Succinate | 9 | 0.0023 |
| Ixazomib Citrate | 9 | 0.0023 |
| Hepatitis A And B Vaccine/Pf | 9 | 0.0023 |
| Fluocinolone/Shower Cap | 9 | 0.0023 |
| Estradiol/Norethindrone Acet | 9 | 0.0023 |
| Desipramine Hcl | 9 | 0.0023 |
| Codeine/Butalbital/Asa/Caffein | 9 | 0.0023 |
| Chlordiazepoxide Hcl | 9 | 0.0023 |
| Carbidopa/Levodopa/Entacapone | 9 | 0.0023 |
| Bosentan | 9 | 0.0023 |
| Atenolol/Chlorthalidone | 9 | 0.0023 |
| Trifluridine/Tipiracil Hcl | 8 | 0.002 |
| Tralokinumab-Ldrm | 8 | 0.002 |
| Tbo-Filgrastim | 8 | 0.002 |
| Sofosbuvir/Velpatasvir | 8 | 0.002 |
| Ospemifene | 8 | 0.002 |
| Orphenadrine Citrate | 8 | 0.002 |
| Metaxalone | 8 | 0.002 |
| Ivabradine Hcl | 8 | 0.002 |
| Interferon Beta-1b | 8 | 0.002 |
| Insulin Degludec/Liraglutide | 8 | 0.002 |
| Immun Glob G(Igg)/Gly/Iga 0-50 | 8 | 0.002 |
| Glipizide/Metformin Hcl | 8 | 0.002 |
| Flunisolide | 8 | 0.002 |
| Elexacaftor/Tezacaftor/Ivacaft | 8 | 0.002 |
| Dutasteride/Tamsulosin Hcl | 8 | 0.002 |
| Desmopressin (Nonrefrigerated) | 8 | 0.002 |
| Clindamycin Phos/Benzoyl Perox | 8 | 0.002 |
| Cefepime Hcl | 8 | 0.002 |
| Tucatinib | 7 | 0.0018 |
| Trifluoperazine Hcl | 7 | 0.0018 |
| Trametinib Dimethyl Sulfoxide | 7 | 0.0018 |
| Tasimelteon | 7 | 0.0018 |
| Romosozumab-Aqqg | 7 | 0.0018 |
| Peginterferon Alfa-2a | 7 | 0.0018 |
| Ozanimod Hydrochloride | 7 | 0.0018 |
| Olmesartan/Amlodipin/Hcthiazid | 7 | 0.0018 |
| Niraparib Tosylate | 7 | 0.0018 |
| Nateglinide | 7 | 0.0018 |
| Naldemedine Tosylate | 7 | 0.0018 |
| Methotrexate/Pf | 7 | 0.0018 |
| Meropenem | 7 | 0.0018 |
| Magnesium Sulfate | 7 | 0.0018 |
| Levonorgestrel/Ethin.Estradiol | 7 | 0.0018 |
| Levocarnitine | 7 | 0.0018 |
| Levobunolol Hcl | 7 | 0.0018 |
| Lamivudine | 7 | 0.0018 |
| Itraconazole | 7 | 0.0018 |
| Istradefylline | 7 | 0.0018 |
| Haloperidol Lactate | 7 | 0.0018 |
| Frovatriptan Succinate | 7 | 0.0018 |
| Fluvastatin Sodium | 7 | 0.0018 |
| Epinastine Hcl | 7 | 0.0018 |
| Efavirenz/Emtricit/Tenofovr Df | 7 | 0.0018 |
| Cenegermin-Bkbj | 7 | 0.0018 |
| Brigatinib | 7 | 0.0018 |
| Belumosudil Mesylate | 7 | 0.0018 |
| Bacitracin/Polymyxin B Sulfate | 7 | 0.0018 |
| Amiloride/Hydrochlorothiazide | 7 | 0.0018 |
| Albuterol Sulfate/Budesonide | 7 | 0.0018 |
| Yellow Fever Vaccine Live/Pf | 6 | 0.0015 |
| Vedolizumab | 6 | 0.0015 |
| Typhoid Vi Polysacch Vaccine | 6 | 0.0015 |
| Tafamidis Meglumine | 6 | 0.0015 |
| Sulfacetamide Sodium | 6 | 0.0015 |
| Sodium Oxybate | 6 | 0.0015 |
| Pnv,calcium 72/Iron/Folic Acid | 6 | 0.0015 |
| Oxazepam | 6 | 0.0015 |
| Octreotide Acetate | 6 | 0.0015 |
| Micafungin Sodium | 6 | 0.0015 |
| Mercaptopurine | 6 | 0.0015 |
| Letermovir | 6 | 0.0015 |
| Immun Globg(Igg)/Malt/Iga Ov50 | 6 | 0.0015 |
| Immun Glob G(Igg)-Ifas/Glycine | 6 | 0.0015 |
| Hepatitis A Virus Vaccine/Pf | 6 | 0.0015 |
| Gilteritinib Fumarate | 6 | 0.0015 |
| Ethinyl Estradiol/Drospirenone | 6 | 0.0015 |
| Ethacrynic Acid | 6 | 0.0015 |
| Deferasirox | 6 | 0.0015 |
| Decitabine/Cedazuridine | 6 | 0.0015 |
| Darifenacin Hydrobromide | 6 | 0.0015 |
| Dabrafenib Mesylate | 6 | 0.0015 |
| Codeine Sulfate | 6 | 0.0015 |
| Azelaic Acid | 6 | 0.0015 |
| Axitinib | 6 | 0.0015 |
| Amlodipine/Atorvastatin | 6 | 0.0015 |
| Adalimumab-Adbm | 6 | 0.0015 |
| Abacavir Sulfate/Lamivudine | 6 | 0.0015 |
| Zileuton | 5 | 0.0013 |
| Vericiguat | 5 | 0.0013 |
| Vancomycin/0.9 % Sod Chloride | 5 | 0.0013 |
| Tranylcypromine Sulfate | 5 | 0.0013 |
| Timolol Maleate/Pf | 5 | 0.0013 |
| Thiothixene | 5 | 0.0013 |
| Selenium Sulfide | 5 | 0.0013 |
| Saxagliptin Hcl | 5 | 0.0013 |
| Resmetirom | 5 | 0.0013 |
| Propylthiouracil | 5 | 0.0013 |
| Poliomyelitis Vaccine, Killed | 5 | 0.0013 |
| Piroxicam | 5 | 0.0013 |
| Norethindrone-Ethin. Estradiol | 5 | 0.0013 |
| Norethindrone-E.Estradiol-Iron | 5 | 0.0013 |
| Norethindrone | 5 | 0.0013 |
| Nepafenac | 5 | 0.0013 |
| Maraviroc | 5 | 0.0013 |
| Linezolid | 5 | 0.0013 |
| Levalbuterol Hcl | 5 | 0.0013 |
| Ivermectin | 5 | 0.0013 |
| Insulin Pump Cart,cont Inf,bt | 5 | 0.0013 |
| Fondaparinux Sodium | 5 | 0.0013 |
| Fluorometholone Acetate | 5 | 0.0013 |
| Fat Emulsion/Olive/Soy/Phospho | 5 | 0.0013 |
| Elacestrant Hcl | 5 | 0.0013 |
| Efavirenz | 5 | 0.0013 |
| Edoxaban Tosylate | 5 | 0.0013 |
| Doravirine/Lamivu/Tenofov Diso | 5 | 0.0013 |
| Diclofenac Epolamine | 5 | 0.0013 |
| Candesartan/Hydrochlorothiazid | 5 | 0.0013 |
| Bromocriptine Mesylate | 5 | 0.0013 |
| Baricitinib | 5 | 0.0013 |
| Atazanavir Sulfate | 5 | 0.0013 |
| Aspirin/Dipyridamole | 5 | 0.0013 |
| Ampicillin Sod/Sulbactam Sod | 5 | 0.0013 |
| Amikacin Sulfate | 5 | 0.0013 |
| Amifampridine Phosphate | 5 | 0.0013 |
| Abacavir Sulfate | 5 | 0.0013 |
| Tedizolid Phosphate | 4 | 0.001 |
| Sunitinib Malate | 4 | 0.001 |
| Sotatercept-Csrk | 4 | 0.001 |
| Solriamfetol Hcl | 4 | 0.001 |
| Sodium Chloride Irrig Solution | 4 | 0.001 |
| Rsv Vaccine, Pref, Mrna/Pf | 4 | 0.001 |
| Rilpivirine Hcl | 4 | 0.001 |
| Permethrin | 4 | 0.001 |
| Pen Needle, Diabetic, Safety | 4 | 0.001 |
| Omadacycline Tosylate | 4 | 0.001 |
| Olodaterol Hcl | 4 | 0.001 |
| Nevirapine | 4 | 0.001 |
| Levodopa | 4 | 0.001 |
| Lanreotide Acetate | 4 | 0.001 |
| Ivosidenib | 4 | 0.001 |
| Infliximab | 4 | 0.001 |
| Hydrocortisone Sodium Succ/Pf | 4 | 0.001 |
| Ganciclovir | 4 | 0.001 |
| Fostemsavir Tromethamine | 4 | 0.001 |
| Encorafenib | 4 | 0.001 |
| Dihydroergotamine Mesylate | 4 | 0.001 |
| Diflunisal | 4 | 0.001 |
| Colistin (Colistimethate Na) | 4 | 0.001 |
| Citric Ac/Gluconolact/Mag Carb | 4 | 0.001 |
| Capmatinib Hydrochloride | 4 | 0.001 |
| Bosutinib | 4 | 0.001 |
| Avapritinib | 4 | 0.001 |
| Asciminib Hydrochloride | 4 | 0.001 |
| Amikacin Liposomal/Neb.Accessr | 4 | 0.001 |
| Alogliptin Benzoate | 4 | 0.001 |
| Zavegepant Hcl | 3 | 0.0008 |
| Water For Irrigation,sterile | 3 | 0.0008 |
| Viloxazine Hcl | 3 | 0.0008 |
| Tolvaptan | 3 | 0.0008 |
| Tobramycin Sulfate | 3 | 0.0008 |
| Testosterone Undecanoate | 3 | 0.0008 |
| Terconazole | 3 | 0.0008 |
| Teduglutide | 3 | 0.0008 |
| Sotorasib | 3 | 0.0008 |
| Sodium Bicarbonate | 3 | 0.0008 |
| Risdiplam | 3 | 0.0008 |
| Rifabutin | 3 | 0.0008 |
| Pitolisant Hcl | 3 | 0.0008 |
| Phenelzine Sulfate | 3 | 0.0008 |
| Paricalcitol | 3 | 0.0008 |
| Parenteral Amino Acid 15% No.5 | 3 | 0.0008 |
| Olopatadine Hcl | 3 | 0.0008 |
| Nizatidine | 3 | 0.0008 |
| Momelotinib Dihydrochloride | 3 | 0.0008 |
| Mifepristone | 3 | 0.0008 |
| Mening Vac A,c,y,w-135 Dip/Pf | 3 | 0.0008 |
| Measles,mumps,rubella Vacc/Pf | 3 | 0.0008 |
| Lorlatinib | 3 | 0.0008 |
| Linagliptin/Metformin Hcl | 3 | 0.0008 |
| Lanadelumab-Flyo | 3 | 0.0008 |
| Ivacaftor | 3 | 0.0008 |
| Icatibant Acetate | 3 | 0.0008 |
| Hydrocortisone Valerate | 3 | 0.0008 |
| Halobetasol Propionate | 3 | 0.0008 |
| Guselkumab | 3 | 0.0008 |
| Filgrastim-Sndz | 3 | 0.0008 |
| Famotidine/Pf | 3 | 0.0008 |
| Ethosuximide | 3 | 0.0008 |
| Ergotamine Tartrate/Caffeine | 3 | 0.0008 |
| Epoetin Alfa-Epbx | 3 | 0.0008 |
| Empagliflozin/Linagliptin | 3 | 0.0008 |
| Dextrose 5 % In Water | 3 | 0.0008 |
| Chlordiazepoxide/Clidinium Br | 3 | 0.0008 |
| Cefixime | 3 | 0.0008 |
| Canagliflozin/Metformin Hcl | 3 | 0.0008 |
| C1 Esterase Inhibitor, Recomb | 3 | 0.0008 |
| Burosumab-Twza | 3 | 0.0008 |
| Binimetinib | 3 | 0.0008 |
| Betaxolol Hcl | 3 | 0.0008 |
| Aztreonam Lysine | 3 | 0.0008 |
| Avatrombopag Maleate | 3 | 0.0008 |
| Asfotase Alfa | 3 | 0.0008 |
| Anakinra | 3 | 0.0008 |
| Alosetron Hcl | 3 | 0.0008 |
| Almotriptan Malate | 3 | 0.0008 |
| Acebutolol Hcl | 3 | 0.0008 |
| Voriconazole | 2 | 0.0005 |
| Vancomycin/Water For Inj (Peg) | 2 | 0.0005 |
| Tropicamide | 2 | 0.0005 |
| Trandolapril | 2 | 0.0005 |
| Tiopronin | 2 | 0.0005 |
| Tiagabine Hcl | 2 | 0.0005 |
| Thioridazine Hcl | 2 | 0.0005 |
| Tezacaftor/Ivacaftor | 2 | 0.0005 |
| Tavaborole | 2 | 0.0005 |
| Tapinarof | 2 | 0.0005 |
| Syrge-Ndl,ins 0.3 Ml Half Mark | 2 | 0.0005 |
| Sonidegib Phosphate | 2 | 0.0005 |
| Sodium Fluoride/Potassium Nit | 2 | 0.0005 |
| Sod Phenylbutyrat/Taurursodiol | 2 | 0.0005 |
| Selumetinib Sulfate | 2 | 0.0005 |
| Selpercatinib | 2 | 0.0005 |
| Satralizumab-Mwge | 2 | 0.0005 |
| Sacrosidase | 2 | 0.0005 |
| Ropeginterferon Alfa-2b-Njft | 2 | 0.0005 |
| Ravulizumab-Cwvz | 2 | 0.0005 |
| Probenecid/Colchicine | 2 | 0.0005 |
| Prednisolone | 2 | 0.0005 |
| Potassium Chloride/D5-0.45nacl | 2 | 0.0005 |
| Potassium Chloride In 0.9%nacl | 2 | 0.0005 |
| Ponatinib Hcl | 2 | 0.0005 |
| Pirtobrutinib | 2 | 0.0005 |
| Piperacillin Sodium/Tazobactam | 2 | 0.0005 |
| Pegvisomant | 2 | 0.0005 |
| Pazopanib Hcl | 2 | 0.0005 |
| Pacritinib Citrate | 2 | 0.0005 |
| Oxaprozin | 2 | 0.0005 |
| Osilodrostat Phosphate | 2 | 0.0005 |
| Opium Tincture | 2 | 0.0005 |
| Opicapone | 2 | 0.0005 |
| Omeprazole/Sodium Bicarbonate | 2 | 0.0005 |
| Omeprazole Magnesium | 2 | 0.0005 |
| Omaveloxolone | 2 | 0.0005 |
| Olanzapine Pamoate | 2 | 0.0005 |
| Octreotide Acetate,mi-Spheres | 2 | 0.0005 |
| Norgestrel-Ethinyl Estradiol | 2 | 0.0005 |
| Nicotine | 2 | 0.0005 |
| Nemolizumab-Ilto | 2 | 0.0005 |
| Methylprednisolone Sod Succ | 2 | 0.0005 |
| Methazolamide | 2 | 0.0005 |
| Mening Vac A,c,y,w135,c-Tet/Pf | 2 | 0.0005 |
| Meloxicam, Submicronized | 2 | 0.0005 |
| Lomustine | 2 | 0.0005 |
| Lidocaine Hcl/Pf | 2 | 0.0005 |
| Leuprolide Acetate | 2 | 0.0005 |
| Latanoprost/Pf | 2 | 0.0005 |
| Japanese Encephalitis Vacc/Pf | 2 | 0.0005 |
| Isradipine | 2 | 0.0005 |
| Isoniazid | 2 | 0.0005 |
| Incobotulinumtoxina | 2 | 0.0005 |
| Immune Globulin,gamma(Igg)klhw | 2 | 0.0005 |
| Igg/Hyaluronidase,recombinant | 2 | 0.0005 |
| Hpv Vaccine 9-Valent/Pf | 2 | 0.0005 |
| Hepatitis B Vaccine/Cpg1018/Pf | 2 | 0.0005 |
| Granisetron Hcl | 2 | 0.0005 |
| Fostamatinib Disodium | 2 | 0.0005 |
| Flurandrenolide | 2 | 0.0005 |
| Fenfluramine Hcl | 2 | 0.0005 |
| Exenatide | 2 | 0.0005 |
| Estradiol/Levonorgestrel | 2 | 0.0005 |
| Estradiol Valerate | 2 | 0.0005 |
| Estazolam | 2 | 0.0005 |
| Erythromycin/Benzoyl Peroxide | 2 | 0.0005 |
| Erythromycin Ethylsuccinate | 2 | 0.0005 |
| Erythromycin Base In Ethanol | 2 | 0.0005 |
| Ertugliflozin Pidolate | 2 | 0.0005 |
| Erlotinib Hcl | 2 | 0.0005 |
| Enasidenib Mesylate | 2 | 0.0005 |
| Emtricitabine | 2 | 0.0005 |
| Diclofenac Sodium/Misoprostol | 2 | 0.0005 |
| Demeclocycline Hcl | 2 | 0.0005 |
| Darbepoetin Alfa In Polysorbat | 2 | 0.0005 |
| Cobicistat | 2 | 0.0005 |
| Clobetasol Propionate/Emoll | 2 | 0.0005 |
| Clemastine Fumarate | 2 | 0.0005 |
| Chloroquine Phosphate | 2 | 0.0005 |
| Ceftriaxone In Is-Osm Dextrose | 2 | 0.0005 |
| Captopril | 2 | 0.0005 |
| Canakinumab/Pf | 2 | 0.0005 |
| Cabotegravir/Rilpivirine | 2 | 0.0005 |
| C1 Esterase Inhibitor | 2 | 0.0005 |
| Bupropion Hbr | 2 | 0.0005 |
| Bolus Insulin Pump, 200 Unit | 2 | 0.0005 |
| Bexarotene | 2 | 0.0005 |
| Berotralstat Hydrochloride | 2 | 0.0005 |
| Benzonatate | 2 | 0.0005 |
| Belzutifan | 2 | 0.0005 |
| Azilsartan Medoxomil | 2 | 0.0005 |
| Alogliptin Benz/Metformin Hcl | 2 | 0.0005 |
| Aflibercept | 2 | 0.0005 |
| Aclidinium Bromide | 2 | 0.0005 |
| Abatacept/Maltose | 2 | 0.0005 |
| Zilucoplan Sodium | 1 | 0.0003 |
| Voxelotor | 1 | 0.0003 |
| Vorinostat | 1 | 0.0003 |
| Vonoprazan Fumarate | 1 | 0.0003 |
| Voclosporin | 1 | 0.0003 |
| Vismodegib | 1 | 0.0003 |
| Venlafaxine Besylate | 1 | 0.0003 |
| Vemurafenib | 1 | 0.0003 |
| Varicella Vaccine Live/Pf | 1 | 0.0003 |
| Treprostinil Sodium | 1 | 0.0003 |
| Tocilizumab-Aazg | 1 | 0.0003 |
| Tivozanib Hcl | 1 | 0.0003 |
| Teprotumumab-Trbw | 1 | 0.0003 |
| Tepotinib Hcl | 1 | 0.0003 |
| Telotristat Etiprate | 1 | 0.0003 |
| Tazarotene | 1 | 0.0003 |
| Sub-Q Insulin Device, 30 Unit | 1 | 0.0003 |
| Sparsentan | 1 | 0.0003 |
| Sorafenib Tosylate | 1 | 0.0003 |
| Somapacitan-Beco | 1 | 0.0003 |
| Sodium Chloride 0.45 % | 1 | 0.0003 |
| Sevelamer Hcl | 1 | 0.0003 |
| Selegiline | 1 | 0.0003 |
| Sapropterin Dihydrochloride | 1 | 0.0003 |
| Salsalate | 1 | 0.0003 |
| Safinamide Mesylate | 1 | 0.0003 |
| Rolapitant Hcl | 1 | 0.0003 |
| Ritlecitinib Tosylate | 1 | 0.0003 |
| Rimantadine Hcl | 1 | 0.0003 |
| Rilonacept | 1 | 0.0003 |
| Rifapentine | 1 | 0.0003 |
| Rabies Vaccine (Pcec)/Pf | 1 | 0.0003 |
| Quinidine Gluconate | 1 | 0.0003 |
| Pyrimethamine | 1 | 0.0003 |
| Prochlorperazine Edisylate | 1 | 0.0003 |
| Prochlorperazine | 1 | 0.0003 |
| Prasterone (Dhea) | 1 | 0.0003 |
| Pralsetinib | 1 | 0.0003 |
| Potassium Bicarbonate/Cit Ac | 1 | 0.0003 |
| Pnv Cmb 52/Iron/Fa/Omega-3/Dha | 1 | 0.0003 |
| Pioglitazone Hcl/Metformin Hcl | 1 | 0.0003 |
| Pindolol | 1 | 0.0003 |
| Pimozide | 1 | 0.0003 |
| Perphenazine/Amitriptyline Hcl | 1 | 0.0003 |
| Pentazocine Hcl/Naloxone Hcl | 1 | 0.0003 |
| Pen Needle, Diabetic,disp Unit | 1 | 0.0003 |
| Pembrolizumab | 1 | 0.0003 |
| Pegvaliase-Pqpz | 1 | 0.0003 |
| Pegfilgrastim-Apgf | 1 | 0.0003 |
| Pegfilgrastim | 1 | 0.0003 |
| Pegcetacoplan | 1 | 0.0003 |
| Peg3350/Sod Sul/Nacl/Kcl/Asb/C | 1 | 0.0003 |
| Pasireotide Diaspartate | 1 | 0.0003 |
| Parenteral Amino Acid 15% No.6 | 1 | 0.0003 |
| Olanzapine/Fluoxetine Hcl | 1 | 0.0003 |
| Nitrofurantoin | 1 | 0.0003 |
| Nitazoxanide | 1 | 0.0003 |
| Nirogacestat Hydrobromide | 1 | 0.0003 |
| Nimodipine | 1 | 0.0003 |
| Nilutamide | 1 | 0.0003 |
| Neomycin/Bacitracin/Polymyxinb | 1 | 0.0003 |
| Nelfinavir Mesylate | 1 | 0.0003 |
| Nefazodone Hcl | 1 | 0.0003 |
| Naltrexone Hcl/Bupropion Hcl | 1 | 0.0003 |
| Nafcillin Sodium | 1 | 0.0003 |
| Mupirocin Calcium | 1 | 0.0003 |
| Moexipril Hcl | 1 | 0.0003 |
| Mitotane | 1 | 0.0003 |
| Migalastat Hcl | 1 | 0.0003 |
| Methscopolamine Bromide | 1 | 0.0003 |
| Methenamine Mandelate | 1 | 0.0003 |
| Meropenem-0.9% Sodium Chloride | 1 | 0.0003 |
| Meningococcal B Vaccine,4-Comp | 1 | 0.0003 |
| Mechlorethamine Hcl | 1 | 0.0003 |
| Linezolid In Dextrose 5% | 1 | 0.0003 |
| Levorphanol Tartrate | 1 | 0.0003 |
| Laronidase | 1 | 0.0003 |
| Lamivudine/Zidovudine | 1 | 0.0003 |
| Isotretinoin | 1 | 0.0003 |
| Immun Glob G(Igg)-Hipp/Maltose | 1 | 0.0003 |
| Imipramine Pamoate | 1 | 0.0003 |
| Imipenem/Cilastatin Sodium | 1 | 0.0003 |
| Hepatitis B Virus Vaccine/Pf | 1 | 0.0003 |
| Heparin Sodium,porcine/Pf | 1 | 0.0003 |
| Heparin Sodium,porcine | 1 | 0.0003 |
| Haemoph B Poly Conj-Tet Tox/Pf | 1 | 0.0003 |
| Griseofulvin Ultramicrosize | 1 | 0.0003 |
| Glucagon Hcl | 1 | 0.0003 |
| Gatifloxacin | 1 | 0.0003 |
| Fruquintinib | 1 | 0.0003 |
| Fosinopril/Hydrochlorothiazide | 1 | 0.0003 |
| Formoterol Fumarate | 1 | 0.0003 |
| Flurbiprofen | 1 | 0.0003 |
| Fluocinonide/Emollient Base | 1 | 0.0003 |
| Flavoxate Hcl | 1 | 0.0003 |
| Filgrastim | 1 | 0.0003 |
| Fentanyl Citrate | 1 | 0.0003 |
| Faricimab-Svoa | 1 | 0.0003 |
| Eteplirsen | 1 | 0.0003 |
| Estrogens,esterified | 1 | 0.0003 |
| Entrectinib | 1 | 0.0003 |
| Emtricita/Rilpivirine/Tenof Df | 1 | 0.0003 |
| Empaglifloz/Linaglip/Metformin | 1 | 0.0003 |
| Eltrombopag Choline | 1 | 0.0003 |
| Eliglustat Tartrate | 1 | 0.0003 |
| Efgartigimod-Hyaluronidas-Qvfc | 1 | 0.0003 |
| Drospirenone | 1 | 0.0003 |
| Disopyramide Phosphate | 1 | 0.0003 |
| Dextrose 5 %-0.45 % Sod Chlord | 1 | 0.0003 |
| Desvenlafaxine | 1 | 0.0003 |
| Deflazacort | 1 | 0.0003 |
| Deferiprone | 1 | 0.0003 |
| Dalteparin Sodium,porcine | 1 | 0.0003 |
| Crizotinib | 1 | 0.0003 |
| Corticotropin | 1 | 0.0003 |
| Cobimetinib Fumarate | 1 | 0.0003 |
| Clascoterone | 1 | 0.0003 |
| Cholic Acid | 1 | 0.0003 |
| Chikungunya Vaccine, Live/Pf | 1 | 0.0003 |
| Cetirizine Hcl | 1 | 0.0003 |
| Ceftolozane/Tazobactam | 1 | 0.0003 |
| Cefprozil | 1 | 0.0003 |
| Cefaclor | 1 | 0.0003 |
| Caspofungin Acetate | 1 | 0.0003 |
| Carteolol Hcl | 1 | 0.0003 |
| Capivasertib | 1 | 0.0003 |
| Capecitabine | 1 | 0.0003 |
| Calcifediol | 1 | 0.0003 |
| Butalbital/Acetaminophen | 1 | 0.0003 |
| Bupivacaine Hcl/Pf | 1 | 0.0003 |
| Brodalumab | 1 | 0.0003 |
| Bortezomib | 1 | 0.0003 |
| Besifloxacin Hcl | 1 | 0.0003 |
| Bacitracin | 1 | 0.0003 |
| Azacitidine | 1 | 0.0003 |
| Avalglucosidase Alfa-Ngpt | 1 | 0.0003 |
| Atazanavir Sulfate/Cobicistat | 1 | 0.0003 |
| Asenapine | 1 | 0.0003 |
| Arformoterol Tartrate | 1 | 0.0003 |
| Aprepitant | 1 | 0.0003 |
| Apraclonidine Hcl | 1 | 0.0003 |
| Ampicillin Trihydrate | 1 | 0.0003 |
| Amlodipine/Valsartan/Hcthiazid | 1 | 0.0003 |
| Alpelisib | 1 | 0.0003 |
| Aliskiren Hemifumarate | 1 | 0.0003 |
| Albendazole | 1 | 0.0003 |
| Afatinib Dimaleate | 1 | 0.0003 |
| Adefovir Dipivoxil | 1 | 0.0003 |
| Adalimumab-Bwwd | 1 | 0.0003 |
| Adalimumab-Adaz | 1 | 0.0003 |
| Adagrasib | 1 | 0.0003 |
| Acetaminophen | 1 | 0.0003 |
| Abrocitinib | 1 | 0.0003 |
| Abobotulinumtoxina | 1 | 0.0003 |
| Abiraterone Acet,submicronized | 1 | 0.0003 |

_1177 row(s) returned._

### [2.7] Categorical distribution: GE65_Sprsn_Flag

Distinct values of GE65_Sprsn_Flag (GE65 claims/cost suppression flag) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
|  | 226277 | 57.9495 |
| # | 122906 | 31.4762 |
| * | 41290 | 10.5744 |

_3 row(s) returned._

### [2.8] Categorical distribution: GE65_Bene_Sprsn_Flag

Distinct values of GE65_Bene_Sprsn_Flag (GE65 beneficiary suppression flag) with row count and % of total, ordered by frequency descending.

| value | n_rows | pct_of_total |
|---|---|---|
| * | 238726 | 61.1376 |
| # | 98430 | 25.2079 |
|  | 53317 | 13.6545 |

_3 row(s) returned._

### [2.9] Numeric summary: Tot_Clms

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Clms (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 390473 | 11 | 21631 | 42.4452 | 23 | 11 | 80.3944 | 15 | 23 | 43 | 88 | 307 |

_1 row(s) returned._

### [2.10] Numeric summary: Tot_30day_Fills

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_30day_Fills (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 390473 | 11 | 21631 | 84.8192 | 39.9 | 12 | 157.3359 | 21.8 | 39.9 | 82.7 | 183.2 | 750 |

_1 row(s) returned._

### [2.11] Numeric summary: Tot_Day_Suply

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Day_Suply (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 390473 | 11 | 112491 | 2408.0078 | 1103 | 360 | 4447.6687 | 502 | 1103 | 2368 | 5370 | 22256 |

_1 row(s) returned._

### [2.12] Numeric summary: Tot_Drug_Cst

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Drug_Cst (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 390473 | 0 | 10210321.85 | 7010.6138 | 442.71 | 0 | 59190.4134 | 185.76 | 442.71 | 1347.48 | 7885.14 | 124277.12 |

_1 row(s) returned._

### [2.13] Numeric summary: Tot_Benes

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for Tot_Benes (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 160561 | 11 | 16313 | 27.9489 | 19 | 11 | 76.671 | 13 | 19 | 30 | 52 | 140 |

_1 row(s) returned._

### [2.14] Numeric summary: GE65_Tot_Clms

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Clms (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 226277 | 0 | 20053 | 38.412 | 20 | 11 | 89.0139 | 13 | 20 | 38 | 79 | 305 |

_1 row(s) returned._

### [2.15] Numeric summary: GE65_Tot_30day_Fills

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_30day_Fills (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 226277 | 0 | 20053 | 78.6697 | 37 | 0 | 160.2212 | 19 | 37 | 75 | 167.3 | 733.9 |

_1 row(s) returned._

### [2.16] Numeric summary: GE65_Tot_Drug_Cst

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Drug_Cst (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 226277 | 0 | 9915014.4 | 7091.5598 | 395.73 | 0 | 59500.6704 | 158.92 | 395.73 | 1234.16 | 7827.38 | 131890.69 |

_1 row(s) returned._

### [2.17] Numeric summary: GE65_Tot_Day_Suply

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Day_Suply (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 226277 | 0 | 107221 | 2253.4143 | 1065 | 0 | 4371.0606 | 450 | 1065 | 2160 | 4897 | 21692 |

_1 row(s) returned._

### [2.18] Numeric summary: GE65_Tot_Benes

Min, max, mean, median, mode, sample stddev, and 25/50/75/90/99th percentiles for GE65_Tot_Benes (non-blank values only).

| n | min | max | mean | median | mode | stddev | p25 | p50 | p75 | p90 | p99 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 53317 | 0 | 15104 | 25.3859 | 17 | 11 | 121.4703 | 13 | 17 | 25 | 41 | 127 |

_1 row(s) returned._

## SECTION 3: BIVARIATE PROFILING (distribution shape only)

### [3.1] Crosstab sample: specialty x city

Top 20 specialty x city combinations by total drug cost, with row count and total claims (sample, not full enumeration).

| dim1 | dim2 | n_rows | total_claims | total_drug_cost |
|---|---|---|---|---|
| Internal Medicine | Denver | 13530 | 623739 | 72124029.05 |
| Nurse Practitioner | Colorado Springs | 11191 | 416359 | 59585798.64 |
| Nurse Practitioner | Aurora | 5932 | 205177 | 52789737.84 |
| Nurse Practitioner | Denver | 7795 | 263274 | 51376805.46 |
| Pulmonary Disease | Denver | 786 | 31001 | 46120672.78 |
| Hematology-Oncology | Denver | 552 | 16780 | 40230325.5 |
| Hematology-Oncology | Aurora | 208 | 7219 | 33371249.04 |
| Medical Oncology | Aurora | 438 | 12217 | 33239488.84 |
| Nurse Practitioner | Pueblo | 5814 | 234438 | 32899442.21 |
| Family Practice | Colorado Springs | 10334 | 441477 | 32471627.5 |
| Physician Assistant | Colorado Springs | 5889 | 215801 | 31037673.33 |
| Rheumatology | Denver | 764 | 40024 | 30634437.7 |
| Critical Care (Intensivists) | Denver | 268 | 10580 | 29674113.31 |
| Physician Assistant | Aurora | 4343 | 136299 | 29369453.29 |
| Neurology | Aurora | 943 | 33265 | 28230717.23 |
| Internal Medicine | Aurora | 6346 | 297040 | 27458107.19 |
| Family Practice | Denver | 9090 | 327707 | 27404776.73 |
| Hematology-Oncology | Colorado Springs | 355 | 10790 | 24317365.87 |
| Infectious Disease | Aurora | 804 | 23768 | 22488974.52 |
| Hematology-Oncology | Fort Collins | 233 | 8772 | 20711917.75 |

_20 row(s) returned._

### [3.2] Distribution shape: total claims by specialty x city

Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total claims across all populated specialty x city combinations.

| n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total |
|---|---|---|---|---|---|---|---|---|---|
| 2118 | 11 | 623739 | 7825.17 | 774 | 30523.53 | 150 | 3907 | 13292 | 136299 |

_1 row(s) returned._

### [3.3] Distribution shape: total drug cost by specialty x city

Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total drug cost across all populated specialty x city combinations.

| n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total |
|---|---|---|---|---|---|---|---|---|---|
| 2118 | 7.83 | 72124029.05 | 1292471.85 | 44230.21 | 4427124.23 | 2505.02 | 553587.77 | 3210593.96 | 19574232.47 |

_1 row(s) returned._

### [3.4] Crosstab sample: specialty x generic drug

Top 20 specialty x generic drug combinations by total drug cost, with row count and total claims (sample, not full enumeration).

| dim1 | dim2 | n_rows | total_claims | total_drug_cost |
|---|---|---|---|---|
| Hematology-Oncology | Lenalidomide | 92 | 3394 | 54475740.75 |
| Family Practice | Apixaban | 1141 | 56402 | 49235652.23 |
| Internal Medicine | Apixaban | 709 | 51024 | 45171200.11 |
| Cardiology | Apixaban | 181 | 35872 | 45039627.76 |
| Family Practice | Semaglutide | 1083 | 33224 | 40391260.63 |
| Rheumatology | Adalimumab | 120 | 4350 | 36431817.29 |
| Nurse Practitioner | Apixaban | 884 | 41991 | 35895873.32 |
| Rheumatology | Etanercept | 108 | 4676 | 33712339.89 |
| Family Practice | Empagliflozin | 1013 | 33032 | 32727057.34 |
| Internal Medicine | Semaglutide | 572 | 23646 | 28721657.47 |
| Internal Medicine | Empagliflozin | 538 | 24218 | 22009008.74 |
| Family Practice | Dulaglutide | 615 | 16472 | 20688636.84 |
| Nurse Practitioner | Semaglutide | 525 | 15987 | 19862308.84 |
| Gastroenterology | Ustekinumab | 30 | 729 | 19810825.66 |
| Physician Assistant | Apixaban | 494 | 20015 | 19764041.08 |
| Pulmonary Disease | Nintedanib Esylate | 39 | 1476 | 19558368.89 |
| Nurse Practitioner | Empagliflozin | 583 | 19667 | 19387386.17 |
| Family Practice | Rivaroxaban | 673 | 19119 | 18238899.87 |
| Infectious Disease | Bictegrav/Emtricit/Tenofov Ala | 58 | 4038 | 18221976.33 |
| Family Practice | Tirzepatide | 474 | 14302 | 17950092.7 |

_20 row(s) returned._

### [3.5] Distribution shape: total claims by specialty x generic drug

Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total claims across all populated specialty x generic drug combinations.

| n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total |
|---|---|---|---|---|---|---|---|---|---|
| 10800 | 11 | 349454 | 1534.6 | 65 | 9200.21 | 22 | 315 | 1817 | 31848 |

_1 row(s) returned._

### [3.6] Distribution shape: total drug cost by specialty x generic drug

Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total drug cost across all populated specialty x generic drug combinations.

| n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total |
|---|---|---|---|---|---|---|---|---|---|
| 10800 | 0 | 54475740.75 | 253468.09 | 4593.12 | 1676537.37 | 772.52 | 41034.38 | 290137.75 | 5163591.75 |

_1 row(s) returned._

### [3.7] Crosstab sample: city x generic drug

Top 20 city x generic drug combinations by total drug cost, with row count and total claims (sample, not full enumeration).

| dim1 | dim2 | n_rows | total_claims | total_drug_cost |
|---|---|---|---|---|
| Denver | Elexacaftor/Tezacaftor/Ivacaft | 8 | 1047 | 28899560.58 |
| Colorado Springs | Apixaban | 379 | 23630 | 26599983.58 |
| Aurora | Apixaban | 406 | 25604 | 24994394.78 |
| Denver | Apixaban | 448 | 20256 | 19596006.15 |
| Littleton | Apixaban | 129 | 15738 | 18655117.56 |
| Denver | Nintedanib Esylate | 20 | 1382 | 18139944.16 |
| Aurora | Lenalidomide | 10 | 973 | 17930142.16 |
| Denver | Lenalidomide | 34 | 1152 | 17020105.49 |
| Fort Collins | Apixaban | 164 | 14525 | 16908018.77 |
| Aurora | Tafamidis | 5 | 672 | 15770802.81 |
| Denver | Empagliflozin | 384 | 15327 | 14326654.74 |
| Denver | Semaglutide | 339 | 11748 | 13943238.64 |
| Denver | Adalimumab | 57 | 1504 | 12587556.05 |
| Colorado Springs | Empagliflozin | 301 | 10824 | 12464103.82 |
| Aurora | Bictegrav/Emtricit/Tenofov Ala | 33 | 3170 | 12259964.32 |
| Denver | Bictegrav/Emtricit/Tenofov Ala | 38 | 2627 | 11725574.11 |
| Colorado Springs | Semaglutide | 255 | 8560 | 11514950.55 |
| Lakewood | Apixaban | 132 | 11106 | 11415073.92 |
| Aurora | Semaglutide | 242 | 8577 | 11276221.9 |
| Denver | Etanercept | 43 | 1517 | 10955793.34 |

_20 row(s) returned._

### [3.8] Distribution shape: total claims by city x generic drug

Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total claims across all populated city x generic drug combinations.

| n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total |
|---|---|---|---|---|---|---|---|---|---|
| 34992 | 11 | 105242 | 473.64 | 55 | 2200.1 | 20 | 207 | 801 | 8078 |

_1 row(s) returned._

### [3.9] Distribution shape: total drug cost by city x generic drug

Distribution shape (n groups, min/max/mean/median/stddev/percentiles) of per-group total drug cost across all populated city x generic drug combinations.

| n_groups | min_group_total | max_group_total | mean_group_total | median_group_total | stddev_group_total | p25_group_total | p75_group_total | p90_group_total | p99_group_total |
|---|---|---|---|---|---|---|---|---|---|
| 34992 | 0 | 28899560.58 | 78230.89 | 2663.33 | 554559.43 | 618.31 | 16198.47 | 93608.24 | 1467847.38 |

_1 row(s) returned._


---

# STAGE 2 — Cost-Percentile Segmentation and Outlier Detection

Generated 2026-08-12 from `outputs/capstone_segmentation.sql`, run against
`outputs/part_d.sqlite` (table `part_d`). Sections above this line are the earlier
profiling run from `part_d_profiling.sql` and are unchanged — this Stage 2 block was
appended, nothing was overwritten.

**System of record.** The cleaned dataset is `outputs/part_d_co_clean.csv`. The database
holds the same 390,473 rows; the two were compared field by field before the queries were
written and agree exactly on row count, drug cost, claims, 30-day fills, and all four
distinct-entity counts. The clean file's two derived columns are recomputed in SQL as
`cost * 1.0 / denominator`, which reproduces the CSV values with 0 mismatches across all
390,473 rows.

**Reconciliation to Stage 1 (`CAPSTONE_EXCEL_AGGREGATES.xlsx`).**

| Measure | Stage 1 workbook | Stage 2 SQL (Query 1) | Delta |
|---|---|---|---|
| Rows | 390,473 | 390,473 | 0 |
| Total drug cost | $2,737,455,388.61 | $2,737,455,388.61 | $0.00 |
| Total claims | 16,573,710 | 16,573,710 | 0 |
| Total 30-day fills | 33,119,594.5 | 33,119,594.5 | 0.0 |
| Distinct prescribers | 19,390 | 19,390 | 0 |
| Distinct specialties | 97 | 97 | 0 |
| Distinct generic drugs | 1,177 | 1,177 | 0 |
| Distinct cities | — (tab not carried into Stage 1) | 226 | n/a |

**8 of 8 tie. No discrepancy.**

**Bucket sizing.** `NTILE(n)` only fills n buckets when the group has at least n members.
Buckets are sized to the group: `NTILE(100)` for the 19,390 prescribers and 226 cities,
`NTILE(20)` for prescribers inside a single specialty (band 20 = top 5%), `NTILE(4)` for
the 46 qualifying specialties and 60 qualifying cities (bucket 4 = top quartile).

**Within-specialty rule.** Every within- or across-specialty comparison is restricted to
specialties with at least 30 distinct prescribers — 46 of 97 qualify. The same guard is
applied to cities in Query 8 — 60 of 226 qualify.

**Age-group scope.** Queries 9 and 10 run only on the 226,277 rows where CMS reported the
65+ breakout (`GE65_Sprsn_Flag = ''`), covering $1,949,327,500.29 of the $2,737,455,388.61
statewide total. The remaining 164,196 rows are CMS-suppressed. Nothing is imputed; these
are not statewide age figures. See QUESTIONS.md Q9 and Q11.

**Substitutions from CALIBRATION.md.** No `CASE WHEN`, `CAST`, `COALESCE`/`NULLIF`,
`UNION`, `PERCENTILE_CONT`, or explicit window frames appear in any executed statement
(verified by search — the only occurrences of those words in the file are in the comment
block that explains why they are absent). Age groups are presented as parallel columns
rather than stacked labelled rows, because stacking would require `UNION`.

---

### Query 1 — Reconciliation to the Stage 1 Excel workbook

Rows returned: 1

| rows_in_file | total_drug_cost | total_claims | total_30day_fills | prescribers | specialties | generic_drugs | cities |
|---|---|---|---|---|---|---|---|
| 390,473 | 2,737,455,388.61 | 16,573,710 | 33,119,594.5 | 19,390 | 97 | 1,177 | 226 |

### Query 2 — Prescriber level — cost-per-claim percentile, top-bucket outliers

Rows returned: 25

| Prscrbr_NPI | Prscrbr_Last_Org_Name | Prscrbr_Type | Prscrbr_City | total_cost | total_claims | cost_per_claim | cost_per_30day_fill | cost_per_claim_pctile | total_cost_pctile |
|---|---|---|---|---|---|---|---|---|---|
| 1750466496 | Elias | Medical Genetics and Genomics | Aurora | 1,557,788.55 | 14 | 111,270.61 | 111,270.61 | 100 | 99 |
| 1083707434 | Apkon | Physical Medicine and Rehabilitation | Aurora | 1,131,520 | 16 | 70,720 | 70,720 | 100 | 98 |
| 1457439713 | Taylor | Medical Genetics and Genomics | Aurora | 4,851,830.65 | 102 | 47,566.97 | 45,858.51 | 100 | 100 |
| 1013007780 | Kirkpatrick | Allergy/ Immunology | Aurora | 563,929.23 | 13 | 43,379.17 | 43,379.17 | 100 | 95 |
| 1225113954 | Thomas | Medical Genetics and Genomics | Aurora | 1,368,068.58 | 42 | 32,573.06 | 32,573.06 | 100 | 99 |
| 1245728203 | King | Physician Assistant | Centennial | 6,045,733.94 | 196 | 30,845.58 | 22,891.84 | 100 | 100 |
| 1407374408 | Swint | Physician Assistant | Centennial | 5,965,211.84 | 316 | 18,877.25 | 17,019.15 | 100 | 100 |
| 1366746893 | Hoffman | Pediatric Medicine | Aurora | 430,127.49 | 26 | 16,543.37 | 16,543.37 | 100 | 92 |
| 1871286435 | Johnson | Nurse Practitioner | Aurora | 495,079.45 | 30 | 16,502.65 | 14,561.16 | 100 | 94 |
| 1255532990 | Yeh | General Surgery | Denver | 588,211.97 | 39 | 15,082.36 | 15,082.36 | 100 | 95 |
| 1235259169 | Gross | Pediatric Medicine | Denver | 938,693.6 | 65 | 14,441.44 | 14,309.35 | 100 | 98 |
| 1962907758 | Kent | Hematopoietic Cell Transplantation and Cellular Therapy | Aurora | 243,735.57 | 17 | 14,337.39 | 13,540.87 | 100 | 86 |
| 1922797612 | Reinhart | Nurse Practitioner | Aurora | 1,124,047.59 | 81 | 13,877.13 | 13,542.74 | 100 | 98 |
| 1164842241 | Plost | Dermatology | Aurora | 148,365.86 | 11 | 13,487.81 | 13,487.81 | 100 | 80 |
| 1548296775 | Wyles | Infectious Disease | Denver | 182,241.41 | 14 | 13,017.24 | 13,017.24 | 100 | 83 |
| 1568552230 | Robinson | Medical Oncology | Aurora | 4,880,404.46 | 383 | 12,742.57 | 11,041.64 | 100 | 100 |
| 1063873560 | Heinz | Nurse Practitioner | Denver | 1,275,219.78 | 102 | 12,502.15 | 11,962.66 | 100 | 99 |
| 1902859242 | Knupp | Epileptologists | Aurora | 197,918.03 | 16 | 12,369.88 | 12,369.88 | 100 | 83 |
| 1295851400 | Dodge | Nurse Practitioner | Aspen | 629,179.5 | 54 | 11,651.47 | 11,651.47 | 100 | 96 |
| 1306898028 | Jordan | Medical Oncology | Pagosa Springs | 126,709.21 | 11 | 11,519.02 | 11,519.02 | 100 | 78 |
| 1417047192 | Nick | Pulmonary Disease | Denver | 10,658,319.46 | 951 | 11,207.49 | 9,956.39 | 100 | 100 |
| 1356600464 | Mcmahon | Hematology-Oncology | Aurora | 2,464,578.1 | 222 | 11,101.7 | 9,479.15 | 100 | 100 |
| 1245598747 | Dixon | Neurology | Aurora | 4,185,696.3 | 387 | 10,815.75 | 6,581.28 | 100 | 100 |
| 1104912575 | Taylor-Cousar | Pulmonary Disease | Denver | 4,480,096.09 | 433 | 10,346.64 | 9,244.94 | 100 | 100 |
| 1720068760 | Stanciu | Internal Medicine | Arvada | 5,884,390.09 | 595 | 9,889.73 | 5,353.34 | 100 | 100 |

### Query 3 — Prescriber level — highest total spend, and how concentrated it is

Rows returned: 25

| spend_rank | Prscrbr_NPI | Prscrbr_Last_Org_Name | Prscrbr_Type | Prscrbr_City | total_cost | total_claims | cost_per_claim | pct_of_state_spend | total_cost_pctile |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 1801871215 | Burke | Hematology-Oncology | Aurora | 16,360,898.37 | 1,901 | 8,606.47 | 0.6 | 100 |
| 2 | 1457414203 | George | Critical Care (Intensivists) | Denver | 13,244,806.13 | 2,066 | 6,410.85 | 0.48 | 100 |
| 3 | 1245678648 | Howe | Rheumatology | Greeley | 12,469,453.4 | 5,273 | 2,364.77 | 0.46 | 100 |
| 4 | 1700975042 | Ambardekar | Advanced Heart Failure and Transplant Cardiology | Aurora | 11,374,975.8 | 1,861 | 6,112.29 | 0.42 | 100 |
| 5 | 1255667655 | Benton | Medical Oncology | Englewood | 11,133,184.48 | 1,655 | 6,727 | 0.41 | 100 |
| 6 | 1417047192 | Nick | Pulmonary Disease | Denver | 10,658,319.46 | 951 | 11,207.49 | 0.39 | 100 |
| 7 | 1962523555 | Melendez | Family Practice | Thornton | 10,559,185.94 | 66,015 | 159.95 | 0.39 | 100 |
| 8 | 1861455099 | Timms | Rheumatology | Pueblo | 10,464,865.06 | 8,475 | 1,234.79 | 0.38 | 100 |
| 9 | 1760402655 | Dauber | Interventional Cardiology | Littleton | 9,676,267.85 | 9,128 | 1,060.06 | 0.35 | 100 |
| 10 | 1932299518 | Saavedra | Critical Care (Intensivists) | Denver | 9,660,656.85 | 1,090 | 8,862.99 | 0.35 | 100 |
| 11 | 1114064490 | Dong | Cardiology | Greeley | 8,607,685.19 | 5,418 | 1,588.72 | 0.31 | 100 |
| 12 | 1417903154 | Moore | Hematology-Oncology | Fort Collins | 8,374,555.26 | 1,918 | 4,366.3 | 0.31 | 100 |
| 13 | 1760799894 | Chavda | Rheumatology | Pueblo | 7,829,842.21 | 6,042 | 1,295.9 | 0.29 | 100 |
| 14 | 1104053438 | Sherbenou | Hematopoietic Cell Transplantation and Cellular Therapy | Aurora | 7,123,344.17 | 922 | 7,725.97 | 0.26 | 100 |
| 15 | 1629104450 | O'reilly | Physician Assistant | Aurora | 7,012,978.53 | 769 | 9,119.61 | 0.26 | 100 |
| 16 | 1265675433 | Bupathi | Internal Medicine | Littleton | 6,988,289.66 | 4,171 | 1,675.45 | 0.26 | 100 |
| 17 | 1689973075 | Hountras | Critical Care (Intensivists) | Aurora | 6,521,963.5 | 823 | 7,924.62 | 0.24 | 100 |
| 18 | 1699759241 | Decarolis | Hematology-Oncology | Colorado Springs | 6,121,813.86 | 1,203 | 5,088.79 | 0.22 | 100 |
| 19 | 1245728203 | King | Physician Assistant | Centennial | 6,045,733.94 | 196 | 30,845.58 | 0.22 | 100 |
| 20 | 1407374408 | Swint | Physician Assistant | Centennial | 5,965,211.84 | 316 | 18,877.25 | 0.22 | 100 |
| 21 | 1720068760 | Stanciu | Internal Medicine | Arvada | 5,884,390.09 | 595 | 9,889.73 | 0.21 | 100 |
| 22 | 1275623951 | Badesch | Pulmonary Disease | Aurora | 5,819,259.35 | 1,025 | 5,677.33 | 0.21 | 100 |
| 23 | 1609950922 | Tonozzi | Family Practice | Glenwood Springs | 5,536,752.45 | 25,674 | 215.66 | 0.2 | 100 |
| 24 | 1891931986 | Mcdermott | Certified Clinical Nurse Specialist | Littleton | 5,531,929.45 | 2,753 | 2,009.42 | 0.2 | 100 |
| 25 | 1952457632 | Sorce | Urology | Parker | 5,506,093.34 | 2,112 | 2,607.05 | 0.2 | 100 |

### Query 4 — Specialty level — cost-per-claim quartile, >= 30 prescribers

Rows returned: 46

| Prscrbr_Type | prescribers | total_cost | total_claims | cost_per_claim | cost_per_30day_fill | cost_per_claim_quartile | total_cost_quartile | spend_rank |
|---|---|---|---|---|---|---|---|---|
| Hematology-Oncology | 115 | 227,788,348.31 | 85,900 | 2,651.79 | 1,713.6 | 4 | 4 | 5 |
| Medical Oncology | 76 | 85,517,729.57 | 34,964 | 2,445.88 | 1,501.34 | 4 | 4 | 10 |
| Critical Care (Intensivists) | 75 | 59,328,932.37 | 39,790 | 1,491.05 | 913 | 4 | 3 | 12 |
| Infectious Disease | 98 | 44,687,920.8 | 44,155 | 1,012.07 | 730.71 | 4 | 3 | 15 |
| Pulmonary Disease | 154 | 103,282,900.81 | 113,868 | 907.04 | 580.92 | 4 | 4 | 8 |
| Rheumatology | 89 | 132,993,654.5 | 146,726 | 906.41 | 467.05 | 4 | 4 | 7 |
| Allergy/ Immunology | 69 | 21,102,605.08 | 37,441 | 563.62 | 356.27 | 4 | 3 | 21 |
| Endocrinology | 94 | 68,725,921.47 | 139,604 | 492.29 | 211.09 | 4 | 4 | 11 |
| Neurology | 212 | 98,212,591.13 | 219,462 | 447.52 | 235.69 | 4 | 4 | 9 |
| Gastroenterology | 235 | 47,519,063.84 | 110,241 | 431.05 | 261.14 | 4 | 3 | 14 |
| Clinical Cardiac Electrophysiology | 51 | 24,476,024.71 | 64,789 | 377.78 | 150.91 | 4 | 3 | 20 |
| Radiation Oncology | 63 | 2,118,267.24 | 5,674 | 373.33 | 233.88 | 3 | 1 | 35 |
| Urology | 178 | 50,352,533.96 | 157,355 | 319.99 | 155.25 | 3 | 3 | 13 |
| Certified Clinical Nurse Specialist | 45 | 9,135,805.32 | 28,976 | 315.29 | 206.54 | 3 | 2 | 25 |
| Cardiology | 205 | 134,894,374.98 | 495,701 | 272.13 | 104.53 | 3 | 4 | 6 |
| Dermatology | 278 | 32,615,376.27 | 129,743 | 251.38 | 208.76 | 3 | 3 | 18 |
| Pharmacist | 112 | 2,436,387.51 | 10,028 | 242.96 | 197.5 | 3 | 2 | 34 |
| Pediatric Medicine | 37 | 4,266,573.72 | 18,611 | 229.25 | 117.38 | 3 | 2 | 31 |
| Interventional Cardiology | 76 | 43,636,648.77 | 199,981 | 218.2 | 84.31 | 3 | 3 | 16 |
| Optometry | 523 | 17,283,034.86 | 94,300 | 183.28 | 99.04 | 3 | 3 | 22 |
| Vascular Surgery | 46 | 662,601.67 | 4,145 | 159.86 | 75.57 | 3 | 1 | 40 |
| Physician Assistant | 3,010 | 256,354,520.73 | 1,744,525 | 146.95 | 79.9 | 3 | 4 | 4 |
| Nurse Practitioner | 3,509 | 392,830,055.77 | 2,869,709 | 136.89 | 80.08 | 2 | 4 | 1 |
| Nephrology | 117 | 11,509,993.63 | 85,231 | 135.04 | 58 | 2 | 2 | 24 |
| Obstetrics & Gynecology | 410 | 5,368,228.12 | 44,453 | 120.76 | 56.44 | 2 | 2 | 27 |
| Psychiatry | 278 | 32,964,273.37 | 274,786 | 119.96 | 84.16 | 2 | 3 | 17 |
| Student in an Organized Health Care Education/Training Program | 235 | 3,097,744.08 | 29,158 | 106.24 | 63 | 2 | 2 | 32 |
| Psychiatry & Neurology | 175 | 4,771,012.38 | 45,460 | 104.95 | 71.67 | 2 | 2 | 29 |
| Ophthalmology | 315 | 30,748,735.15 | 295,180 | 104.17 | 61.21 | 2 | 3 | 19 |
| Internal Medicine | 1,292 | 315,763,830.08 | 3,222,260 | 97.99 | 43.66 | 2 | 4 | 3 |
| Hospitalist | 258 | 6,299,024.96 | 67,673 | 93.08 | 57.24 | 2 | 2 | 26 |
| Geriatric Medicine | 41 | 13,174,085.67 | 142,656 | 92.35 | 50.2 | 2 | 2 | 23 |
| Neuropsychiatry | 42 | 535,467.42 | 5,999 | 89.26 | 60.36 | 2 | 1 | 43 |
| General Practice | 40 | 2,996,599.52 | 37,368 | 80.19 | 43.66 | 2 | 2 | 33 |
| Family Practice | 2,288 | 352,180,328.68 | 4,834,922 | 72.84 | 33.04 | 1 | 4 | 2 |
| Physical Medicine and Rehabilitation | 176 | 4,678,770.6 | 64,258 | 72.81 | 60.54 | 1 | 2 | 30 |
| General Surgery | 284 | 1,375,209.61 | 20,246 | 67.93 | 53.89 | 1 | 1 | 37 |
| Anesthesiology | 35 | 811,128.71 | 11,952 | 67.87 | 60.28 | 1 | 1 | 38 |
| Sports Medicine | 33 | 254,329.07 | 4,419 | 57.55 | 54.28 | 1 | 1 | 44 |
| Emergency Medicine | 708 | 4,826,603.83 | 100,100 | 48.22 | 37.92 | 1 | 2 | 28 |
| Otolaryngology | 176 | 1,585,996.61 | 47,005 | 33.74 | 23.87 | 1 | 1 | 36 |
| Podiatry | 171 | 602,135.03 | 22,518 | 26.74 | 22.9 | 1 | 1 | 42 |
| Orthopedic Surgery | 367 | 791,635.09 | 73,144 | 10.82 | 10.06 | 1 | 1 | 39 |
| Plastic and Reconstructive Surgery | 38 | 32,562.38 | 3,522 | 9.25 | 9.08 | 1 | 1 | 46 |
| Oral Surgery (Dentist only) | 125 | 212,016.96 | 40,902 | 5.18 | 5.17 | 1 | 1 | 45 |
| Dentist | 1,986 | 645,698.86 | 126,208 | 5.12 | 5.06 | 1 | 1 | 41 |

### Query 5 — Within-specialty outliers — prescriber's cost band inside their own specialty

Rows returned: 25

| Prscrbr_Type | prescribers_in_specialty | rank_in_specialty | Prscrbr_NPI | Prscrbr_Last_Org_Name | Prscrbr_City | total_cost | total_claims | cost_per_claim | cost_band_in_specialty |
|---|---|---|---|---|---|---|---|---|---|
| Physical Medicine and Rehabilitation | 176 | 1 | 1083707434 | Apkon | Aurora | 1,131,520 | 16 | 70,720 | 20 |
| Allergy/ Immunology | 69 | 1 | 1013007780 | Kirkpatrick | Aurora | 563,929.23 | 13 | 43,379.17 | 20 |
| Physician Assistant | 3,010 | 1 | 1245728203 | King | Centennial | 6,045,733.94 | 196 | 30,845.58 | 20 |
| Physician Assistant | 3,010 | 2 | 1407374408 | Swint | Centennial | 5,965,211.84 | 316 | 18,877.25 | 20 |
| Pediatric Medicine | 37 | 1 | 1366746893 | Hoffman | Aurora | 430,127.49 | 26 | 16,543.37 | 20 |
| Nurse Practitioner | 3,509 | 1 | 1871286435 | Johnson | Aurora | 495,079.45 | 30 | 16,502.65 | 20 |
| General Surgery | 284 | 1 | 1255532990 | Yeh | Denver | 588,211.97 | 39 | 15,082.36 | 20 |
| Nurse Practitioner | 3,509 | 2 | 1922797612 | Reinhart | Aurora | 1,124,047.59 | 81 | 13,877.13 | 20 |
| Dermatology | 278 | 1 | 1164842241 | Plost | Aurora | 148,365.86 | 11 | 13,487.81 | 20 |
| Infectious Disease | 98 | 1 | 1548296775 | Wyles | Denver | 182,241.41 | 14 | 13,017.24 | 20 |
| Medical Oncology | 76 | 1 | 1568552230 | Robinson | Aurora | 4,880,404.46 | 383 | 12,742.57 | 20 |
| Nurse Practitioner | 3,509 | 3 | 1063873560 | Heinz | Denver | 1,275,219.78 | 102 | 12,502.15 | 20 |
| Nurse Practitioner | 3,509 | 4 | 1295851400 | Dodge | Aspen | 629,179.5 | 54 | 11,651.47 | 20 |
| Medical Oncology | 76 | 2 | 1306898028 | Jordan | Pagosa Springs | 126,709.21 | 11 | 11,519.02 | 20 |
| Pulmonary Disease | 154 | 1 | 1417047192 | Nick | Denver | 10,658,319.46 | 951 | 11,207.49 | 20 |
| Hematology-Oncology | 115 | 1 | 1356600464 | Mcmahon | Aurora | 2,464,578.1 | 222 | 11,101.7 | 20 |
| Neurology | 212 | 1 | 1245598747 | Dixon | Aurora | 4,185,696.3 | 387 | 10,815.75 | 20 |
| Pulmonary Disease | 154 | 2 | 1104912575 | Taylor-Cousar | Denver | 4,480,096.09 | 433 | 10,346.64 | 20 |
| Internal Medicine | 1,292 | 1 | 1720068760 | Stanciu | Arvada | 5,884,390.09 | 595 | 9,889.73 | 20 |
| Physician Assistant | 3,010 | 3 | 1629104450 | O'reilly | Aurora | 7,012,978.53 | 769 | 9,119.61 | 20 |
| Nurse Practitioner | 3,509 | 5 | 1659680247 | Oonk | Aurora | 3,160,324.22 | 351 | 9,003.77 | 20 |
| Physician Assistant | 3,010 | 4 | 1659948057 | Farren | Englewood | 178,087.66 | 20 | 8,904.38 | 20 |
| Critical Care (Intensivists) | 75 | 1 | 1932299518 | Saavedra | Denver | 9,660,656.85 | 1,090 | 8,862.99 | 20 |
| Gastroenterology | 235 | 1 | 1184990079 | Proksell | Aurora | 2,294,056.51 | 260 | 8,823.29 | 20 |
| Neurology | 212 | 2 | 1073907457 | Kammeyer | Aurora | 114,313.84 | 13 | 8,793.37 | 20 |

### Query 6 — Within-specialty outlier concentration — how much does the top 5% carry?

Rows returned: 46

| Prscrbr_Type | prescribers_in_specialty | prescribers_in_top_band | top_band_cost | top_band_claims | top_band_cost_per_claim | pct_of_specialty_spend |
|---|---|---|---|---|---|---|
| Sports Medicine | 33 | 1 | 230,872.35 | 1,145 | 201.64 | 90.78 |
| Emergency Medicine | 708 | 35 | 4,306,984.3 | 47,189 | 91.27 | 89.23 |
| General Surgery | 284 | 14 | 1,136,517.05 | 2,117 | 536.85 | 82.64 |
| Radiation Oncology | 63 | 3 | 1,616,416.24 | 691 | 2,339.24 | 76.31 |
| Certified Clinical Nurse Specialist | 45 | 2 | 5,546,821.7 | 2,764 | 2,006.81 | 60.72 |
| Urology | 178 | 8 | 24,688,571.06 | 11,659 | 2,117.55 | 49.03 |
| Optometry | 523 | 26 | 7,919,299.79 | 2,649 | 2,989.54 | 45.82 |
| Podiatry | 171 | 8 | 270,374.97 | 1,461 | 185.06 | 44.9 |
| Otolaryngology | 176 | 8 | 677,819.89 | 4,080 | 166.13 | 42.74 |
| Physician Assistant | 3,010 | 150 | 106,579,848.69 | 86,171 | 1,236.84 | 41.58 |
| Pharmacist | 112 | 5 | 816,081.73 | 2,105 | 387.69 | 33.5 |
| Physical Medicine and Rehabilitation | 176 | 8 | 1,560,326.18 | 1,791 | 871.2 | 33.35 |
| Obstetrics & Gynecology | 410 | 20 | 1,682,451.74 | 3,293 | 510.92 | 31.34 |
| Anesthesiology | 35 | 1 | 240,978.18 | 1,943 | 124.02 | 29.71 |
| Gastroenterology | 235 | 11 | 13,403,947.37 | 3,194 | 4,196.6 | 28.21 |
| Nurse Practitioner | 3,509 | 175 | 109,117,192.82 | 85,429 | 1,277.29 | 27.78 |
| Orthopedic Surgery | 367 | 18 | 218,221.62 | 3,715 | 58.74 | 27.57 |
| Ophthalmology | 315 | 15 | 8,367,001.6 | 10,189 | 821.18 | 27.21 |
| Dermatology | 278 | 13 | 8,631,332.36 | 7,185 | 1,201.3 | 26.46 |
| Interventional Cardiology | 76 | 3 | 10,394,336.54 | 10,752 | 966.74 | 23.82 |
| Neuropsychiatry | 42 | 2 | 121,056.04 | 266 | 455.1 | 22.61 |
| Critical Care (Intensivists) | 75 | 3 | 11,744,381.69 | 1,347 | 8,718.92 | 19.8 |
| Pulmonary Disease | 154 | 7 | 19,822,816.51 | 1,971 | 10,057.24 | 19.19 |
| Internal Medicine | 1,292 | 64 | 60,267,802.03 | 42,150 | 1,429.84 | 19.09 |
| Dentist | 1,986 | 99 | 121,906.3 | 8,519 | 14.31 | 18.88 |
| Medical Oncology | 76 | 3 | 16,140,298.15 | 2,049 | 7,877.16 | 18.87 |
| Cardiology | 205 | 10 | 23,789,586.01 | 21,040 | 1,130.68 | 17.64 |
| Student in an Organized Health Care Education/Training Program | 235 | 11 | 542,626.09 | 852 | 636.89 | 17.52 |
| Nephrology | 117 | 5 | 2,009,690.38 | 751 | 2,676.02 | 17.46 |
| Hospitalist | 258 | 12 | 1,032,274.75 | 963 | 1,071.94 | 16.39 |
| Allergy/ Immunology | 69 | 3 | 3,360,390.76 | 648 | 5,185.79 | 15.92 |
| Neurology | 212 | 10 | 15,071,255.58 | 3,039 | 4,959.28 | 15.35 |
| Psychiatry & Neurology | 175 | 8 | 687,435.49 | 613 | 1,121.43 | 14.41 |
| Plastic and Reconstructive Surgery | 38 | 1 | 4,623.88 | 83 | 55.71 | 14.2 |
| Hematology-Oncology | 115 | 5 | 28,865,851.07 | 3,522 | 8,195.87 | 12.67 |
| Family Practice | 2,288 | 114 | 41,265,710.55 | 186,839 | 220.86 | 11.72 |
| Psychiatry | 278 | 13 | 3,663,707.08 | 7,840 | 467.31 | 11.11 |
| Pediatric Medicine | 37 | 1 | 430,127.49 | 26 | 16,543.37 | 10.08 |
| Geriatric Medicine | 41 | 2 | 1,269,444.9 | 2,697 | 470.69 | 9.64 |
| Infectious Disease | 98 | 4 | 3,847,117.63 | 831 | 4,629.5 | 8.61 |
| Oral Surgery (Dentist only) | 125 | 6 | 14,931.31 | 1,479 | 10.1 | 7.04 |
| Vascular Surgery | 46 | 2 | 30,003.2 | 47 | 638.37 | 4.53 |
| General Practice | 40 | 2 | 105,448.89 | 383 | 275.32 | 3.52 |
| Rheumatology | 89 | 4 | 3,209,607.55 | 1,058 | 3,033.66 | 2.41 |
| Clinical Cardiac Electrophysiology | 51 | 2 | 508,334.54 | 708 | 717.99 | 2.08 |
| Endocrinology | 94 | 4 | 1,324,456.87 | 320 | 4,138.93 | 1.93 |

### Query 7 — Region level — city cost-per-claim and spend percentiles

Rows returned: 20

| spend_rank | Prscrbr_City | prescribers | total_cost | total_claims | cost_per_claim | cost_per_30day_fill | cost_per_claim_pctile | total_cost_pctile |
|---|---|---|---|---|---|---|---|---|
| 1 | Denver | 2,879 | 446,786,074.26 | 1,932,203 | 231.23 | 117.15 | 94 | 100 |
| 2 | Aurora | 2,337 | 417,572,332.19 | 1,316,691 | 317.14 | 162.39 | 97 | 100 |
| 3 | Colorado Springs | 2,044 | 269,937,885.33 | 1,692,039 | 159.53 | 79.43 | 85 | 99 |
| 4 | Fort Collins | 888 | 135,682,421.54 | 805,115 | 168.53 | 82.06 | 89 | 99 |
| 5 | Pueblo | 607 | 129,762,097.13 | 767,469 | 169.08 | 85.92 | 89 | 98 |
| 6 | Littleton | 508 | 95,329,138.35 | 579,355 | 164.54 | 73.74 | 87 | 98 |
| 7 | Greeley | 421 | 86,753,600.02 | 442,688 | 195.97 | 92.66 | 92 | 97 |
| 8 | Grand Junction | 545 | 86,324,702.76 | 519,992 | 166.01 | 88.04 | 88 | 97 |
| 9 | Boulder | 541 | 82,564,591.8 | 407,819 | 202.45 | 95.17 | 93 | 96 |
| 10 | Lakewood | 586 | 78,561,572.66 | 557,885 | 140.82 | 66.72 | 82 | 96 |
| 11 | Englewood | 460 | 64,893,784.24 | 287,104 | 226.03 | 118.66 | 93 | 95 |
| 12 | Lone Tree | 453 | 60,606,099.56 | 302,782 | 200.16 | 94.07 | 92 | 95 |
| 13 | Longmont | 387 | 54,267,210.4 | 363,853 | 149.15 | 67.52 | 84 | 94 |
| 14 | Lafayette | 317 | 48,493,308.99 | 281,928 | 172.01 | 81.12 | 90 | 94 |
| 15 | Loveland | 332 | 48,148,781.19 | 307,920 | 156.37 | 76.3 | 84 | 93 |
| 16 | Wheat Ridge | 276 | 43,912,465.35 | 404,719 | 108.5 | 54.36 | 74 | 93 |
| 17 | Thornton | 261 | 42,418,327.13 | 240,365 | 176.47 | 102.17 | 91 | 92 |
| 18 | Parker | 340 | 41,905,880.77 | 438,465 | 95.57 | 59.69 | 63 | 92 |
| 19 | Durango | 267 | 41,254,966.82 | 253,003 | 163.06 | 92.02 | 86 | 91 |
| 20 | Westminster | 415 | 36,294,044.17 | 530,763 | 68.38 | 29.69 | 35 | 91 |

### Query 8 — Region level — unit-cost outlier cities, >= 30 prescribers

Rows returned: 15

| Prscrbr_City | prescribers | total_cost | total_claims | cost_per_claim | cost_per_30day_fill | cost_per_claim_quartile | total_cost_quartile |
|---|---|---|---|---|---|---|---|
| Edwards | 37 | 4,827,927.85 | 13,217 | 365.28 | 227.91 | 4 | 2 |
| Aurora | 2,337 | 417,572,332.19 | 1,316,691 | 317.14 | 162.39 | 4 | 4 |
| Denver | 2,879 | 446,786,074.26 | 1,932,203 | 231.23 | 117.15 | 4 | 4 |
| Englewood | 460 | 64,893,784.24 | 287,104 | 226.03 | 118.66 | 4 | 4 |
| Boulder | 541 | 82,564,591.8 | 407,819 | 202.45 | 95.17 | 4 | 4 |
| Lone Tree | 453 | 60,606,099.56 | 302,782 | 200.16 | 94.07 | 4 | 4 |
| Greeley | 421 | 86,753,600.02 | 442,688 | 195.97 | 92.66 | 4 | 4 |
| Thornton | 261 | 42,418,327.13 | 240,365 | 176.47 | 102.17 | 4 | 3 |
| Lafayette | 317 | 48,493,308.99 | 281,928 | 172.01 | 81.12 | 4 | 4 |
| Steamboat Springs | 81 | 8,707,450.02 | 51,365 | 169.52 | 84.57 | 4 | 2 |
| Pueblo | 607 | 129,762,097.13 | 767,469 | 169.08 | 85.92 | 4 | 4 |
| Fort Collins | 888 | 135,682,421.54 | 805,115 | 168.53 | 82.06 | 4 | 4 |
| Grand Junction | 545 | 86,324,702.76 | 519,992 | 166.01 | 88.04 | 4 | 4 |
| Craig | 36 | 4,777,177.67 | 28,971 | 164.9 | 88.72 | 4 | 2 |
| Vail | 56 | 2,480,412.86 | 15,057 | 164.73 | 81.34 | 4 | 1 |

### Query 9 — Age group — statewide 65+ vs under-65 split, reported rows only

Rows returned: 1

| reported_rows | cost_all_ages | cost_ge65 | cost_under65 | claims_all_ages | claims_ge65 | claims_under65 | cpc_all_ages | cpc_ge65 | cpc_under65 | pct_of_cost_ge65 |
|---|---|---|---|---|---|---|---|---|---|---|
| 226,277 | 1,949,327,500.29 | 1,604,656,867.63 | 344,670,632.66 | 9,969,678 | 8,691,742 | 1,277,936 | 195.53 | 184.62 | 269.71 | 82.3 |

### Query 10 — Age group by specialty — quartile outliers in each age band

Rows returned: 44

| Prscrbr_Type | prescribers | cost_ge65 | claims_ge65 | cpc_ge65 | cpc_ge65_quartile | cost_under65 | claims_under65 | cpc_under65 | cpc_under65_quartile | cpc_gap_ge65_minus_under65 |
|---|---|---|---|---|---|---|---|---|---|---|
| Hematology-Oncology | 115 | 189,061,865.99 | 48,701 | 3,882.09 | 4 | 7,187,306.9 | 2,447 | 2,937.19 | 4 | 944.9 |
| Medical Oncology | 74 | 57,492,217.12 | 19,697 | 2,918.83 | 4 | 4,709,890.84 | 1,107 | 4,254.64 | 4 | -1,335.81 |
| Critical Care (Intensivists) | 74 | 33,801,867.89 | 20,652 | 1,636.74 | 4 | 14,358,585.43 | 3,886 | 3,694.95 | 4 | -2,058.22 |
| Infectious Disease | 94 | 23,936,140.3 | 19,039 | 1,257.22 | 4 | 13,504,159.28 | 9,632 | 1,402.01 | 4 | -144.79 |
| Pulmonary Disease | 151 | 61,056,346.68 | 62,276 | 980.42 | 4 | 18,717,200.04 | 8,424 | 2,221.89 | 4 | -1,241.47 |
| Rheumatology | 87 | 71,726,255.79 | 89,241 | 803.74 | 4 | 27,552,945.54 | 15,430 | 1,785.67 | 4 | -981.94 |
| Allergy/ Immunology | 67 | 11,148,749.64 | 18,466 | 603.74 | 4 | 3,716,047.49 | 3,229 | 1,150.84 | 4 | -547.09 |
| Radiation Oncology | 55 | 2,084,193.6 | 3,560 | 585.45 | 4 | 748.26 | 52 | 14.39 | 1 | 571.06 |
| Certified Clinical Nurse Specialist | 42 | 5,863,999.21 | 11,359 | 516.24 | 4 | 1,301,521.48 | 9,682 | 134.43 | 2 | 381.82 |
| Urology | 173 | 42,019,087.17 | 82,532 | 509.12 | 4 | 1,140,883.62 | 4,689 | 243.31 | 3 | 265.81 |
| Endocrinology | 91 | 38,418,720.54 | 75,866 | 506.4 | 4 | 9,166,997.14 | 14,006 | 654.51 | 3 | -148.1 |
| Gastroenterology | 213 | 25,272,425.82 | 55,359 | 456.52 | 3 | 4,665,630.74 | 7,142 | 653.27 | 3 | -196.75 |
| Neurology | 204 | 41,120,037.49 | 103,560 | 397.06 | 3 | 31,936,091.81 | 40,129 | 795.84 | 4 | -398.77 |
| Clinical Cardiac Electrophysiology | 51 | 11,056,458.76 | 35,007 | 315.84 | 3 | 146,753.55 | 442 | 332.02 | 3 | -16.19 |
| Dermatology | 270 | 18,971,870.06 | 60,119 | 315.57 | 3 | 4,679,971.4 | 4,000 | 1,169.99 | 4 | -854.42 |
| Cardiology | 202 | 86,507,272.18 | 277,824 | 311.37 | 3 | 3,518,512.06 | 11,999 | 293.23 | 3 | 18.14 |
| Interventional Cardiology | 75 | 25,495,533.34 | 107,830 | 236.44 | 3 | 1,087,875.49 | 5,011 | 217.1 | 3 | 19.34 |
| Pharmacist | 83 | 1,189,707.49 | 5,131 | 231.87 | 3 | 20,621.65 | 107 | 192.73 | 3 | 39.14 |
| General Surgery | 139 | 962,961.57 | 5,616 | 171.47 | 3 | 27,689.86 | 573 | 48.32 | 1 | 123.14 |
| Optometry | 481 | 9,541,603.53 | 56,989 | 167.43 | 3 | 1,122,874.6 | 1,407 | 798.06 | 4 | -630.63 |
| Physician Assistant | 2,417 | 127,323,729.04 | 827,604 | 153.85 | 3 | 41,295,605.45 | 161,207 | 256.17 | 3 | -102.32 |
| Nephrology | 114 | 5,726,784.67 | 37,470 | 152.84 | 3 | 1,280,571.52 | 9,067 | 141.23 | 2 | 11.6 |
| Vascular Surgery | 35 | 292,659.36 | 1,932 | 151.48 | 2 | 1,427.38 | 148 | 9.64 | 1 | 141.84 |
| Nurse Practitioner | 3,058 | 196,300,346.05 | 1,396,893 | 140.53 | 2 | 73,328,190.82 | 395,282 | 185.51 | 3 | -44.98 |
| Obstetrics & Gynecology | 312 | 2,919,380.81 | 22,457 | 130 | 2 | 290,036.52 | 1,624 | 178.59 | 2 | -48.6 |
| Student in an Organized Health Care Education/Training Program | 148 | 1,426,880.93 | 11,015 | 129.54 | 2 | 346,039.09 | 1,822 | 189.92 | 3 | -60.38 |
| Pediatric Medicine | 34 | 1,150,923.2 | 9,226 | 124.75 | 2 | 2,144,289.73 | 2,278 | 941.3 | 4 | -816.56 |
| Hospitalist | 195 | 3,839,003.96 | 34,619 | 110.89 | 2 | 542,762.82 | 5,032 | 107.86 | 2 | 3.03 |
| Ophthalmology | 289 | 17,720,673.02 | 163,115 | 108.64 | 2 | 858,991.66 | 6,475 | 132.66 | 2 | -24.02 |
| Psychiatry & Neurology | 162 | 2,187,803.88 | 20,474 | 106.86 | 2 | 1,982,566.89 | 10,887 | 182.1 | 2 | -75.25 |
| Internal Medicine | 1,181 | 198,644,267.67 | 1,859,239 | 106.84 | 2 | 19,166,122.02 | 125,652 | 152.53 | 2 | -45.69 |
| Geriatric Medicine | 41 | 10,730,884.31 | 111,428 | 96.3 | 2 | 784,567.47 | 7,778 | 100.87 | 1 | -4.57 |
| General Practice | 36 | 1,931,419.46 | 23,317 | 82.83 | 2 | 503,435.02 | 2,722 | 184.95 | 2 | -102.12 |
| Family Practice | 2,185 | 209,112,143.13 | 2,633,622 | 79.4 | 1 | 22,770,982.14 | 239,832 | 94.95 | 1 | -15.54 |
| Emergency Medicine | 313 | 2,803,585.74 | 35,714 | 78.5 | 1 | 295,139.21 | 4,310 | 68.48 | 1 | 10.02 |
| Psychiatry | 256 | 7,377,473.03 | 94,220 | 78.3 | 1 | 16,580,442.69 | 113,310 | 146.33 | 2 | -68.03 |
| Neuropsychiatry | 40 | 155,064.13 | 2,584 | 60.01 | 1 | 305,947.24 | 1,704 | 179.55 | 2 | -119.54 |
| Physical Medicine and Rehabilitation | 149 | 1,522,621.13 | 28,960 | 52.58 | 1 | 1,805,329.14 | 8,869 | 203.55 | 3 | -150.98 |
| Anesthesiology | 31 | 277,868.18 | 5,709 | 48.67 | 1 | 216,559.52 | 2,398 | 90.31 | 1 | -41.64 |
| Otolaryngology | 151 | 898,400.52 | 19,778 | 45.42 | 1 | 137,220.15 | 1,315 | 104.35 | 2 | -58.93 |
| Podiatry | 129 | 232,191.14 | 7,440 | 31.21 | 1 | 70,575.41 | 1,287 | 54.84 | 1 | -23.63 |
| Orthopedic Surgery | 279 | 270,153.46 | 27,197 | 9.93 | 1 | 45,649.19 | 1,605 | 28.44 | 1 | -18.51 |
| Dentist | 1,184 | 252,162.35 | 48,549 | 5.19 | 1 | 17,545.29 | 3,270 | 5.37 | 1 | -0.17 |
| Oral Surgery (Dentist only) | 94 | 83,175.5 | 16,294 | 5.1 | 1 | 6,618.08 | 1,595 | 4.15 | 1 | 0.96 |
