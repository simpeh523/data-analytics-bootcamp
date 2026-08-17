# PREGAME_RESEARCH.md

Reference document for the 2024 CMS Medicare Part D Prescribers by Provider and
Drug file, Colorado subset (390,473 rows × 22 columns).

Every count in this document was computed from
`Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv` read with
`encoding='utf-8-sig'`. Every definition is cited to a CMS primary source.

**Source-availability note.** The CMS resource pages for this dataset
(`data.cms.gov/provider-summary-by-type-of-service/medicare-part-d-prescribers/...`
and `/resources/medicare-part-d-prescribers-by-provider-and-drug-data-dictionary`)
are JavaScript-rendered and could not be retrieved as text. Definitions below are
taken from the CMS PDFs that *are* retrievable and that describe the same
variables: the RY25 Geography-and-Drug Data Dictionary, the RY23 Methodological
Overview, the RY21 Technical Specifications, and the November 2020 Part D
Prescriber PUF Methodological Overview (which uses the older snake_case variable
names for the identical fields). Where wording is carried over from a sibling
file, it is marked **[sibling-file DD]**.

---

## 1. DATA DICTIONARY

### 1.1 Columns (all 22, in file order)

| Column Name | Data Type | Brief Description | Potential Business Value |
|---|---|---|---|
| `Prscrbr_NPI` | Integer, 10-digit (treat as string) | National Provider Identifier of the prescriber, taken from the Part D prescription drug event (PDE) record. 19,390 distinct values in the CO file. | Join key to NPPES, Open Payments (via name/address only), and the CMS Part D Prescribers by-Provider summary table. The unit of analysis for any prescriber-level comparison. |
| `Prscrbr_Last_Org_Name` | String | Provider last name when NPPES entity type = "I" (individual); legal business name when entity type = "O" (organization). Sourced from NPPES. | Human-readable label; also the only signal (with first name) that a row belongs to an organizational rather than individual NPI. |
| `Prscrbr_First_Name` | String | Provider first name from NPPES. Blank for organizational NPIs. **0 blanks in the CO file** — see §5.3. | Human-readable label; disambiguation of same-surname prescribers. |
| `Prscrbr_City` | String | City of the provider's NPPES business practice location. 226 distinct strings; see §5.2 for spelling-variant issues. | The only geographic field below state level. Every regional rollup in §4 depends on it. |
| `Prscrbr_State_Abrvtn` | String, 2 char | State postal abbreviation of the NPPES practice location. `CO` for 100% of rows. | Confirms the filter was applied correctly; no analytic use once filtered. |
| `Prscrbr_State_FIPS` | Integer (leading-zero risk) | FIPS state code. `8` for 100% of rows; the raw file stores it as `08`. | Join key to Census/FIPS-based geography files. Must be read as string or zero-padded, or the leading zero is lost. |
| `Prscrbr_Type` | String | Prescriber specialty. Single value per NPI. 97 distinct values; 46 have ≥30 distinct prescribers. | The primary peer-grouping dimension. Any "compared to peers" statement depends on this field. |
| `Prscrbr_Type_Src` | String, categorical | Source of `Prscrbr_Type`. Observed values: `Claim-Specialty` (344,460 rows), `NPPES-Specialty` (40,016), `NPPES-Taxonomy` (5,997). | Data-quality stratifier. Claim-derived specialty reflects what the provider actually bills; NPPES-derived specialty reflects self-report at enrollment and is less reliable. |
| `Brnd_Name` | String, max 30 char | Trademarked name of the drug filled, derived by linking the NDC on the PDE to a commercial drug information database. 1,662 distinct values; 0 nulls. For non-trademarked products this repeats the generic name (70.2% of rows have `Brnd_Name == Gnrc_Name`). | Brand-vs-generic substitution questions; identifying high-cost branded products. **Truncated at 30 characters** — see §5.1. |
| `Gnrc_Name` | String, max 30 char | Chemical-ingredient name of the drug, derived the same way. 1,177 distinct values; 0 nulls. 199 contain `/` (combination products). | The stated analytic grain for this project. Also the join key for any therapeutic-class crosswalk (§3). **Truncated at 30 characters** — see §5.1. |
| `Tot_Clms` | Integer | Number of Part D claims, including original prescriptions and refills, for this NPI + brand + generic combination. **Rows with fewer than 11 claims are excluded from the file entirely.** Observed min 11, max 21,631. 0% null. | Denominator for cost-per-claim. Volume measure. The file's inclusion threshold — see §2. |
| `Tot_30day_Fills` | Float | Standardized 30-day fill count. Derived per claim as day supply ÷ 30, bottom-coded at 1.0 and top-coded at 12.0, then summed. 0% null. | Denominator for cost-per-30-day-fill. Normalizes across 30/60/90-day dispensing so a 90-day script is not counted as one "claim" equal to a 30-day script. |
| `Tot_Day_Suply` | Integer | Aggregate days supply dispensed across all claims in the row. Observed min 11, max 112,491. 0% null. | Therapy-duration and adherence-adjacent measures. Note it is *not* simply 30 × `Tot_30day_Fills` because of bottom/top-coding — the two disagree by >1% in 45.7% of rows. |
| `Tot_Drug_Cst` | Float (USD) | Aggregate drug cost for all claims in the row: ingredient cost + dispensing fee + sales tax + applicable vaccine administration fees, summed across amounts paid by the Part D plan, the beneficiary, government subsidies, and third-party payers. **Excludes manufacturer rebates.** CO total = $2,737,455,389. 0% null; 596 rows equal $0.00; no negatives. | The primary spend measure. Numerator for both cost-per-claim and cost-per-30-day-fill. |
| `Tot_Benes` | Integer, nullable | Unique Part D beneficiaries with ≥1 claim for this drug from this prescriber. **Counts of 1–10 are suppressed and appear blank.** 58.88% null; observed min 11. | Would be the denominator for cost-per-beneficiary — which is why cost-per-beneficiary is off the table here. Usable only on the 41% unsuppressed subset, which is a biased (high-volume) subset. |
| `GE65_Sprsn_Flag` | String, categorical, nullable | Reason `GE65_Tot_Clms`, `GE65_Tot_30day_Fills`, `GE65_Tot_Drug_Cst`, and `GE65_Tot_Day_Suply` are suppressed. `*` = primary suppression, `#` = counter-suppression, blank = not suppressed. Distribution: blank 226,277 / `#` 122,906 / `*` 41,290. | Determines whether the age-65+ subgroup can be analyzed at all for a given row. See §2 — this is the single most consequential field in the file for scope decisions. |
| `GE65_Tot_Clms` | Float, nullable | Part D claims for beneficiaries age 65+, including refills. Blank when suppressed (42.05% of rows). **Observed min is 0** — 11,263 rows carry an explicit 0. | Age-stratified volume. The explicit zeros are what prove blank ≠ zero (§2.3). |
| `GE65_Tot_30day_Fills` | Float, nullable | Standardized 30-day fills for beneficiaries 65+, same derivation and coding as `Tot_30day_Fills`. Suppressed whenever `GE65_Tot_Clms` is suppressed. | Age-stratified cost-per-fill, on the unsuppressed subset only. |
| `GE65_Tot_Drug_Cst` | Float (USD), nullable | Aggregate drug cost for claims of beneficiaries 65+, same components as `Tot_Drug_Cst`. Suppressed whenever `GE65_Tot_Clms` is suppressed. 11,658 rows equal $0.00 (395 more than have 0 claims — see §5.5). | Age-stratified spend, on the unsuppressed subset only. |
| `GE65_Tot_Day_Suply` | Float, nullable | Aggregate days supply for beneficiaries 65+. Suppressed whenever `GE65_Tot_Clms` is suppressed. Note the column order differs from the sibling Geography file. | Age-stratified therapy duration. |
| `GE65_Bene_Sprsn_Flag` | String, categorical, nullable | Reason `GE65_Tot_Benes` is suppressed. `*` = primary, `#` = counter-suppression, blank = not suppressed. Distribution: `*` 238,726 / `#` 98,430 / blank 53,317. | Governs the 65+ beneficiary count separately from the 65+ utilization block. Only 13.65% of rows have a usable 65+ beneficiary count. |
| `GE65_Tot_Benes` | Float, nullable | Unique Part D beneficiaries age 65+ with ≥1 claim for this drug from this prescriber. Blank when suppressed (86.35% of rows). Observed min is 0 (66 rows). | Age-stratified panel size. Too sparse to anchor a headline metric. |

### 1.2 Terms

| Term | Definition |
|---|---|
| **NPI (National Provider Identifier)** | A 10-digit, intelligence-free numeric identifier assigned to health care providers by CMS through the National Plan & Provider Enumeration System (NPPES). Entity type "I" = individual provider, "O" = organization. In this file the NPI is the CCW Prescriber ID (`CCW_PRSCRBR_ID`) carried on the PDE record. |
| **NPPES** | National Plan & Provider Enumeration System — the CMS system that issues NPIs and holds provider name, credentials, gender, address, entity type, and taxonomy. All demographic fields in this file come from NPPES, captured **as of the end of the calendar year following the data year** (so 2024 data carries NPPES demographics as of end of 2025). A provider who moved cities in 2025 is labeled with the 2025 city, not the 2024 one. |
| **Medicare Part D** | The optional outpatient prescription drug benefit, delivered by private plan sponsors. Two enrollment routes: stand-alone Prescription Drug Plans (PDP) and Medicare Advantage Prescription Drug plans (MAPD). Part D enrollees are approximately 77.1% of all Medicare beneficiaries; of those, roughly 49.3% PDP and 50.7% MAPD (RY23 methodology figures). |
| **PDE (Prescription Drug Event)** | The claim-equivalent record a Part D plan sponsor submits to CMS for each dispensed prescription. This file is built from 100% of final-action PDE records for Part D enrollees, received through the June 30 cutoff following the benefit year. |
| **Claim (`Tot_Clms`)** | One PDE record = one claim. Original prescriptions and refills each count as one. A 90-day fill and a 30-day fill are both one claim — which is exactly why the 30-day standardized fill exists. |
| **Day supply** | The number of days a dispensed quantity is expected to last, as reported on the PDE (`DAYSSPLY`). Summed across claims into `Tot_Day_Suply`. |
| **30-day standardized fill** | Day supply ÷ 30, computed **per claim**, then bottom-coded to 1.0 if below 1.0 and top-coded to 12.0 if above 12.0, then summed. Because coding is applied per claim before summation, `Tot_30day_Fills` cannot be recovered from `Tot_Day_Suply ÷ 30` — the two differ by more than 1% in 45.7% of CO rows. Use the published column; never re-derive it. |
| **Brand name vs. generic name** | Both are assigned by linking the NDC on each PDE to a commercial drug information database, not by CMS clinical review. `Brnd_Name` is the trademarked name where one exists; where none exists the field repeats the chemical name. `Gnrc_Name` is the chemical-ingredient name. Neither is a therapeutic classification (see §3). |
| **NDC (National Drug Code)** | The 10- or 11-digit FDA product identifier on the PDE. **It is not in this file.** It is the link CMS used internally to assign brand and generic names, and its absence is why NDC-keyed crosswalks (e.g. the CMS Formulary Reference File) cannot be joined directly. |
| **Prescriber type source (`Prscrbr_Type_Src`)** | Specialty is assigned by a documented hierarchy: (1) the Medicare specialty code appearing on the NPI's Part B carrier claims with the largest service count; failing that (2) the DMEPOS claims specialty code; failing that (3) the NPPES primary taxonomy code crosswalked to a Medicare provider/supplier type; failing that (4) the NUCC taxonomy classification description. The older PUF encoded this as `description_flag` ("S" = Medicare specialty code description, "T" = taxonomy classification description); this file uses the more granular `Claim-Specialty` / `NPPES-Specialty` / `NPPES-Taxonomy`. |
| **Total drug cost** | Gross drug cost (`TOTALCST` on the PDE): ingredient cost + dispensing fee + sales tax + applicable vaccine administration fee, across all payers. It is **gross of manufacturer rebates** and cannot be attributed to the Medicare Trust Fund. It is a spend figure, not a Medicare-payment figure. |
| **LIS (Low-Income Subsidy)** | Part D premium and cost-sharing assistance for low-income beneficiaries. LIS/non-LIS cost-share splits exist in the sibling Geography-and-Drug file but **not** in this one. |
| **Over-the-counter exclusion** | PDEs with drug coverage status code `O` (over-the-counter) are excluded from all summarizations, even though they appear in raw PDE data because of step-therapy protocols. |
| **Redaction vs. suppression** | Two distinct mechanisms. **Redaction** removes whole rows (any NPI+drug combination with fewer than 11 total claims never appears). **Suppression** blanks individual cells within rows that did make the file. See §2. |
| **Primary suppression** | A cell is blanked because its own value is between 1 and 10. |
| **Counter-suppression (complementary suppression)** | A cell is blanked not because its own value is small, but because leaving it visible would let a reader arithmetically recover a *different* small value from the published totals. |

---

## 2. SUPPRESSION SEMANTICS

This section is written to be defensible verbatim in live Q&A.

### 2.1 What each value means

**`GE65_Sprsn_Flag`** governs a block of four columns: `GE65_Tot_Clms`,
`GE65_Tot_30day_Fills`, `GE65_Tot_Drug_Cst`, `GE65_Tot_Day_Suply`. CMS's own
wording (Nov 2020 methodology, field `ge65_suppress_flag` — same field, older
name):

> "A flag that indicates the reason the total_claim_count_ge65,
> total_30_day_fill_count_ge65, total_day_supply_ge65, and total_drug_cost_ge65
> variables are suppressed.
> "\*" = Primary suppressed due to total_claim_count_ge65 between 1 and 10.
> "#" = Counter suppressed because the "less than 65 year old" group (not
> explicitly displayed) contains a small claim count between 1 and 10, which can
> be mathematically determined from the total_claim_count_ge65 and
> total_claim_count."

**`GE65_Bene_Sprsn_Flag`** governs exactly one column: `GE65_Tot_Benes`. CMS
wording (same document, field `bene_count_ge65_suppress_flag`):

> "A flag indicating the reason the bene_count_ge65 variable is suppressed.
> "\*" = Primary suppressed due to bene_count_ge65 between 1 and 10.
> "#" = Counter suppressed because the "less than 65 year old" group (not
> explicitly displayed) contains a beneficiary count between 1 and 10, which can
> be mathematically determined from bene_count_ge65 and bene_count."

| Value | Meaning | Applies to |
|---|---|---|
| `*` | **Primary suppression.** The 65+ value itself is between 1 and 10. | Both flags, independently |
| `#` | **Counter-suppression.** The 65+ value may be any size, but the *under-65* value — never printed, but recoverable as (total − 65+) — is between 1 and 10. The 65+ cell is blanked to protect the under-65 cell. | Both flags, independently |
| blank | **Not suppressed.** The governed columns carry real published values. | Both flags |

### 2.2 How the two columns differ

They are separate decisions on separate quantities and must not be conflated.

- `GE65_Sprsn_Flag` is driven by **claim counts**; it blanks four utilization and
  cost columns as a block.
- `GE65_Bene_Sprsn_Flag` is driven by **beneficiary counts**; it blanks only
  `GE65_Tot_Benes`.

A row can have usable 65+ claims and costs while its 65+ beneficiary count is
suppressed — that is in fact the modal case. Observed cross-tabulation of all
390,473 CO rows:

| `GE65_Sprsn_Flag` \ `GE65_Bene_Sprsn_Flag` | `#` | blank | `*` |
|---|---|---|---|
| `#` | 66,471 | 0 | 56,435 |
| blank | 31,959 | **53,317** | 141,001 |
| `*` | 0 | 0 | 41,290 |

Reading it: 226,277 rows (57.95%) have usable 65+ claims/cost/fills/day-supply,
but only 53,317 rows (13.65%) have a usable 65+ beneficiary count. The two zero
cells are structural — if 65+ claims are primary-suppressed (1–10 claims), the
65+ beneficiary count is necessarily 1–10 as well, so it is always `*`.

Verified: in all 390,473 rows, a blank flag always accompanies a present value
and a non-blank flag always accompanies a null value. Zero exceptions in either
direction, for both flags.

### 2.3 Threshold, and why

**The threshold is 11.** Two separate rules use it:

1. **Row-level redaction.** Any NPI + brand + generic combination with fewer than
   11 total claims is dropped from the file entirely. Confirmed in the data:
   `min(Tot_Clms) = 11`.
2. **Cell-level suppression.** Within surviving rows, beneficiary counts, claim
   counts, 30-day fill counts, drug costs, and day supply are blanked when the
   value is 1–10. Confirmed: `min(Tot_Benes) = 11`, and among rows where
   `GE65_Tot_Clms` is published and below 11, **all 11,263 are exactly 0** — no
   published value between 1 and 10 exists anywhere in the 65+ block.

**Why 11.** CMS states the purpose as protecting the privacy of Medicare
beneficiaries — a cell built from a handful of people is close to identifying
those people, particularly when combined with a named prescriber, a named city,
and a named drug. The counter-suppression rule exists because the file publishes
totals alongside subgroups: since 65+ and under-65 sum to the total, publishing
one subgroup discloses the other by subtraction. CMS: "Since only one sub-group
category is suppressed, you can mathematically determine it using the values from
the other claim count categories and the total claim count information."

### 2.4 Hidden, not zero

**A suppressed cell means the value is hidden and lies between 1 and 10. It does
not mean zero.** The distinction is the difference between a defensible number
and a wrong one.

The decisive evidence is internal to the file: **zero is explicitly published.**
11,263 rows carry `GE65_Tot_Clms = 0`, and 66 rows carry `GE65_Tot_Benes = 0`.
CMS did not need to blank those cells because a zero discloses nothing about any
individual. So blank and 0 are two different states that CMS chose to represent
differently. Treating blank as 0 collapses a distinction the publisher
deliberately made.

CMS says the same thing explicitly:

> "Suppressed values represent values 1 to 10 and are indicated by a 'blank' in
> the data files. ... If users choose to retain the suppressed values in their
> analysis, please note that most statistical software packages will treat the
> 'blanks' as 'zeroes', resulting in underestimates of the true values.
> Alternatively, users may assign an imputed value of their choosing, e.g. five
> (5), for the suppressed value."

Two practical hazards follow:

- **The software trap.** `pandas.sum()`, `SUM()` in SQL, and Excel's `SUM()` all
  skip nulls, which for a *sum* is arithmetically the same as treating them as
  zero. A "total 65+ spend" computed by summing `GE65_Tot_Drug_Cst` understates
  the truth by whatever the 164,196 suppressed rows contain.
- **The mean trap.** `mean()` skips nulls in the numerator *and* the denominator,
  so a "mean 65+ cost per claim" is not biased toward zero — it is a mean over a
  non-random, systematically higher-volume subset of rows. That is a selection
  problem, not a rounding problem, and it does not shrink as N grows.

### 2.5 What this rules in and out

**Ruled IN — no suppression exposure:**

- Anything built from `Tot_Clms`, `Tot_30day_Fills`, `Tot_Day_Suply`,
  `Tot_Drug_Cst`. All four are 0% null across all 390,473 rows.
- Cost-per-claim (`Tot_Drug_Cst / Tot_Clms`) and cost-per-30-day-fill
  (`Tot_Drug_Cst / Tot_30day_Fills`) — complete for every row, every prescriber,
  every drug, every city.
- Any aggregation over prescriber, specialty, city, or generic drug built from
  those four columns, at any grouping level.

**Ruled OUT — or only usable with an explicit, stated caveat:**

- **Cost-per-beneficiary at any level.** `Tot_Benes` is 58.88% null and
  `GE65_Tot_Benes` is 86.35% null, and the nulls are not missing at random —
  they are exactly the low-volume rows. Already excluded from this project's
  metric set; §2.4 is the defense of that decision.
- **Summed 65+ totals.** Any "total 65+ spend/claims in Colorado" figure is an
  undercount of unknown size, because 42.05% of rows contribute nothing.
- **65+ vs. under-65 comparison.** The under-65 group is never published; it is
  recoverable only as (total − 65+), and only for the 57.95% of rows where the
  65+ block is unsuppressed. That subset is exactly the rows CMS judged
  non-disclosive, i.e. the high-volume ones — so the comparison is drawn on a
  biased sample by construction.
- **Beneficiaries-per-prescriber panel size.** Same problem as cost-per-
  beneficiary.
- **Any claim about drugs a prescriber prescribes rarely.** Fewer than 11 claims
  and the row is gone. The file cannot support "Dr. X never prescribes Y" — only
  "Dr. X did not prescribe Y at least 11 times."

**A note on totals.** Because of row-level redaction, no figure in this file —
including the $2,737,455,389 CO total drug cost — is the true Colorado Part D
total. It is the total across rows that met the ≥11-claim threshold. CMS is
explicit: "summing data in detail file will underestimate the true Part D
totals." The published sum is a correct statement about the file; it is not a
correct statement about Colorado.

**The 30-second version for Q&A:** *A blank in the 65-and-over columns means CMS
hid a number between 1 and 10, not that the number is zero. We know it means
hidden rather than zero because CMS publishes actual zeros — 11,263 of them —
so blank and zero are different states in this file. Two flags tell you why a
cell was hidden: a star means the 65-and-over value itself was small; a hash
means the under-65 value was small and CMS had to hide the 65-and-over value so
you couldn't subtract your way to it. Because the hidden cells are systematically
the low-volume ones, we built the analysis on the four columns that are never
suppressed — claims, 30-day fills, day supply, and cost — and we do not report
per-beneficiary metrics.*

---

## 3. DRUG CLASSIFICATION

**The question:** is there a low-effort, sourced way to map the 1,177 `Gnrc_Name`
values to therapeutic categories?

**Two file-specific obstacles apply to every option below.**

1. **`Gnrc_Name` is truncated at 30 characters.** 110 of the 1,177 values (9.3%)
   are exactly 30 characters and visibly cut off: `Abacavir/Dolutegravir/Lamivudi`,
   `Amlodipine/Valsartan/Hcthiazid`, `Bictegrav/Emtricit/Tenofov Ala`,
   `Budesonide/Glycopyr/Formoterol`. Another 42 sit at 29 characters. Exact
   string matching against any external vocabulary will fail on these.
2. **Salt forms and CMS-internal abbreviations.** 378 values carry a salt or ester
   suffix (`Hcl`, `Besylate`, `Sodium`, `Succinate`, …), and some carry
   non-standard abbreviations (`Umeclidinium Brm/Vilanterol Tr`,
   `Alogliptin Benz/Metformin Hcl`, `Amikacin Liposomal/Neb.Accessr`,
   `Abiraterone Acet,submicronized`). 199 values are combination products
   containing `/`, which most classification systems assign to multiple classes
   or to a dedicated combination class.

Any option requiring name-based matching therefore needs a normalization pass —
strip salt suffixes, split on `/`, hand-repair the truncated 110 — before it can
reach a claimed coverage figure. That pass is the real cost, and it is the same
cost for every option.

**Scoping figures** (computed from the file, for effort estimation only): 25
generics account for 50% of CO drug cost, 107 for 80%, 211 for 90%, 326 for 95%.
On claims: 26 / 93 / 160 / 241 for the same thresholds.

### 3.1 ATC (Anatomical Therapeutic Chemical)

**What it is.** The WHO Collaborating Centre for Drug Statistics Methodology's
classification. Five levels: 14 anatomical main groups at level 1 (A alimentary
tract/metabolism, C cardiovascular, N nervous system, …), narrowing to a single
chemical substance at level 5. Levels 2–4 are the therapeutic/pharmacological
groupings most analyses want. It is the international standard for drug
utilization research.

**Free downloadable mapping?** Partly, with a licensing wrinkle worth stating
plainly. The WHO ATC/DDD Index is browsable free online but **bulk download of
the ATC index requires a paid WHOCC licence.** However, NLM's **RxClass** exposes
ATC1–4 classes through a free, no-key REST API at
`rxnav.nlm.nih.gov`, with two membership sources: `ATC` (ingredient-level,
curated by the WHO Collaborating Centre) and `ATCPROD` (product-level, curated by
NLM). RxClass supports lookup by drug *name* (`getClassByRxNormDrugName`), which
is the access path that matters here, since this file has names and no NDCs or
RxCUIs. Check RxNav's Terms of Service before scripting, and respect its rate
limits.

**Coverage against `Gnrc_Name`.** Not empirically tested — this environment
cannot make scripted HTTP calls, so no coverage figure is asserted. What can be
said: RxNorm ingredient names are salt-aware and RxNav's name search handles
brand names and many salt forms, so the 378 salt-suffixed values are the
tractable part. The 110 truncated values and the CMS-abbreviated values
(`Brm`, `Benz`, `Neb.Accessr`) will not match and need hand repair. Combination
products will return multiple ATC codes per name and require a documented
tie-breaking rule.

**Realistic effort.** 3–5 hours: ~1 hour to write and test the API loop, ~1 hour
of run and retry for 1,177 names, ~1–2 hours hand-repairing truncated and
unmatched names, ~30 min documenting the combination-product tie-breaker. Output
is an ATC1 (14 categories) or ATC2/3 rollup.

### 3.2 USP Medicare Model Guidelines (MMG)

**What it is.** A Part D–specific therapeutic classification. Under §1860D-4(b)(3)(C)(ii)
of the Social Security Act, CMS asks the U.S. Pharmacopeial Convention to
maintain a list of categories and classes usable by Part D plans for formulary
submissions. USP Category is the broad tier; USP Class is the granular tier. This
is the classification native to the Part D program — which is a genuine
rhetorical advantage over ATC for a Medicare-focused capstone.

**Free downloadable mapping?** Yes, but stale. The public USP MMG landing page
offers downloadable files for **v7.0 (updated 06-Feb-2017)**, v6.0, and v5.0,
including an "MMG-FRF Alignment File" that maps USP MMG v7.0 to the **CMS CY2016
Formulary Reference File**. Search results reference a v9.0 aligned to a current
CMS FRF and a v10.0 draft posted for public comment in June 2026, but those
files were not retrievable from the public USP page during this research — treat
v9.0/v10.0 availability as **unverified**.

**Coverage against `Gnrc_Name`.** Two problems compound. First, the alignment
file is keyed to **NDCs** from the CY2016 FRF, and this dataset has no NDC — so
the join must fall back to name matching anyway, inheriting every problem in the
preamble. Second, a CY2016 drug list against 2024 utilization will miss eight
years of new molecules; the GLP-1 receptor agonists, newer oncology agents, and
newer biologics that drive a large share of 2024 Part D spend are the exact drugs
most likely to be absent. USP also notes that a drug may legitimately appear in
more than one USP Category or Class, so the mapping is not one-to-one.

**Realistic effort.** 6–10 hours, with a coverage ceiling set by the 2016
vintage. Not recommended unless v9.0 turns out to be publicly downloadable, in
which case re-scope.

### 3.3 CMS crosswalks

**What exists.**

- **CMS Formulary Reference File (FRF).** CMS's list of NDCs that may appear on
  Part D formularies. NDC-keyed, so unjoinable to this file without an NDC
  bridge. It also is not itself a therapeutic classification — the USP alignment
  file is what adds category/class.
- **CMS Part D Prescribers — by Geography and Drug** (sibling file, same release,
  free download). This one is directly useful. Its data dictionary confirms it
  carries four drug flags at the **`Brnd_Name` + `Gnrc_Name`** grain — exactly
  this file's drug key, with no NDC required:
  - `Opioid_Drug_Flag` — based on drugs in the Medicare Part D Overutilization
    Monitoring System (OMS), originating from CDC
  - `Opioid_LA_Drug_Flag` — long-acting opioids, from OMS
  - `Antbtc_Drug_Flag` — antibiotics, excluding TB agents, antimalarials, and
    topicals
  - `Antpsyct_Drug_Flag` — antipsychotics, including first- and second-generation
    and combination products
- **NUCC taxonomy / Medicare provider-supplier crosswalk.** Classifies
  *prescribers*, not drugs. Already baked into `Prscrbr_Type`. Not relevant here.

**Coverage against `Gnrc_Name`.** The Geography-and-Drug flags cover only four
categories, but within those four the coverage is exact and CMS-authored, and the
join key is a name pair CMS itself generated from the same source database in the
same release — so truncation and abbreviation are identical on both sides and
match cleanly. It is not a therapeutic classification of all 1,177 generics; it
is a high-confidence label for four clinically salient groups.

**Realistic effort.** 1–2 hours: download the Geography-and-Drug file, filter to
Colorado or National, deduplicate to distinct `Brnd_Name` + `Gnrc_Name`, left
join. No normalization needed.

### 3.4 Recommendation

**Do the CMS Geography-and-Drug flag join first (§3.3, 1–2 hours). Add RxClass
ATC1 second (§3.1, 3–5 hours) only if the analysis needs categories beyond those
four. Skip USP MMG.**

Reasoning:

1. The CMS join is the only option with **zero name-matching risk**, because both
   sides of the join were generated by CMS from the same drug information
   database in the same release cycle. It is also the only option where the
   classification is authored by the same agency that published the data — which
   is the strongest possible sourcing position in a defense.
2. RxClass ATC is the right *general* classification: free, no license, no key,
   name-searchable, and the recognized standard for drug utilization research.
   Its cost is real but bounded, and the bounded part is hand-repair of ~110
   truncated names.
3. USP MMG is conceptually the best fit for Part D and practically the worst
   option available: NDC-keyed against a file this dataset lacks, and pinned to a
   2016 drug list against 2024 utilization.

**Cost of the recommendation: 1–2 hours if the four CMS flags suffice; 4–7 hours
total if ATC1 is added.**

**Fallback if the budget is one hour.** Hand-code therapeutic categories for the
top 107 generics by cost (80% of CO drug cost) or the top 93 by claims (80% of
claims), sourcing each assignment to the drug's FDA label or ATC1 letter, and
report the residual as "Other/Unclassified" with its exact share stated. This is
defensible if — and only if — the unclassified share is disclosed. It is not
recommended over the CMS flag join, which costs the same and carries a citation.

---

## 4. COLORADO REGIONS

**Structural constraint that governs this entire section: the file has
`Prscrbr_City`, not county.** Every scheme below is defined on **counties**.
Using any of them requires a city → county crosswalk, and city → county is not a
clean one-to-one relationship in Colorado. Aurora spans Adams, Arapahoe, and
Douglas; Littleton spans Arapahoe, Douglas, and Jefferson; Longmont spans Boulder
and Weld; Westminster spans Adams and Jefferson; Broomfield is its own
city-and-county. Each of those requires a documented assignment rule.

**Second constraint: 226 is a count of strings, not places.** See §5.2 — at least
28 of the 226 are misspellings or abbreviations of another string in the same
list. Any crosswalk must be built after city-name normalization, not before, or
28 rows of it are wasted and 1,856 data rows fall out unmatched.

### 4.1 The schemes

| Scheme | Definition | Source | Maps to city names? |
|---|---|---|---|
| **CDPHE Health Statistics Regions (HSR)** | 21 regions, each an aggregation of whole counties, developed by the CDPHE Health Statistics Program with state and local public health professionals using statistical and demographic criteria. Boundaries follow county lines exactly. | CDPHE Open Data (ArcGIS Hub / data.colorado.gov), item `75e32548d3b24169adb942ecb7424937`; also served from `cohealthmaps.dphe.state.co.us` | Indirectly. County-keyed; needs city → county. Because HSRs are whole-county aggregations, a county assignment resolves the region unambiguously. |
| **CDPHE local public health agency (LPHA) / all-hazards preparedness regions** | LPHAs and Health Care Coalitions are organized into **nine** regions aligned to Colorado's nine all-hazards homeland security regions. | CDPHE LPHA portal (`cdphe-lpha.colorado.gov`, "A6. Emergency Preparedness and Response") | Indirectly, county-keyed. Coarser than HSR and oriented to emergency response rather than to health statistics. |
| **Medicaid RAE regions (ACC Phase II)** | **Seven** Regional Accountable Entities, launched July 1, 2018, responsible for primary care and behavioral health access and care coordination for Health First Colorado members. County-defined. | Colorado HCPF; Colorado Health Institute, "The Ways of the RAEs" | Indirectly, county-keyed. |
| **Medicaid RAE regions (ACC Phase III)** | **Four** regions, launched July 1, 2025, replacing the seven-region map. HCPF selected it using 28 metrics covering population, demographics, income, eligibility, and behavioral health need, explicitly accounting for mountain-barrier drive times and Eastern Plains / Western Slope regional identity. | HCPF, "Accountable Care Collaborative Phase III Regional Accountable Entity Map," December 2023 | Indirectly, county-keyed. **The county list is in a figure image in the fact sheet, not in extractable text** — the counties must be transcribed from the HCPF map or sourced from a separate HCPF county listing. |
| **Front Range / Western Slope / Eastern Plains** | Informal but near-universal in Colorado usage. Front Range = the I-25 urban corridor east of the mountains, roughly Pueblo through Fort Collins. Western Slope = west of the Continental Divide. Eastern Plains = the agricultural counties east of the Front Range. No single authoritative boundary set. | No single authority. HCPF's Phase III fact sheet uses "Eastern Plains" and "Western Slopes" as stakeholder-recognized identities, which is a citable acknowledgment that the terms are meaningful — not a boundary definition. | **Yes, directly** — these are geographic-intuition categories that can be assigned from a city name without a county step, at the cost of judgment calls on mountain-resort and transitional cities. |
| **Rural / frontier / urban designation** | Not a region scheme but a density classification, and the one most used in Colorado health policy. Rural = non-metropolitan county with no municipality over 50,000. Frontier = county with ≤6 residents per square mile. Colorado Rural Health Center reports 24 rural and 23 frontier of 64 counties, ~77% of the state's land area. CRHC notes these are **programmatic designations, not fixed definitions** — they vary by the program invoking them. | Colorado Rural Health Center, "Colorado: County Designations"; CRHC maps page | Indirectly, county-keyed. |
| **Colorado planning & management regions** | 14 regions used by the Colorado State Demography Office / DOLA for demographic and economic planning; correspond to the Councils of Governments. Not health-specific. | Colorado State Demography Office (`gis.dola.colorado.gov/RegionsMap/`) | Indirectly, county-keyed. Listed for completeness; a health-policy audience will not expect it. |

### 4.2 Three workable schemes for assigning all 226 cities

Each assumes city-name normalization (§5.2) has already happened.

**Scheme A — Front Range / Western Slope / Eastern Plains / Mountain (3–4 buckets, direct city assignment)**

- *How.* Assign each normalized city directly to a bucket by geographic knowledge,
  no county step. Publish the full assignment table as an appendix.
- *Tradeoffs.* Fastest (2–3 hours) and the only scheme with no crosswalk
  dependency. Bucket sizes are large enough that the suppression and small-cell
  problems in §2 mostly disappear. Cost: no citable authority for the boundaries,
  so the assignment table itself must carry the defense — and a reviewer can
  legitimately challenge any individual call. The hard cases are the mountain
  corridor (Vail, Breckenridge, Steamboat Springs, Aspen, Frisco, Winter Park)
  and the transitional foothills (Evergreen, Conifer, Bailey, Nederland). A
  fourth "Mountain/Resort" bucket resolves most of them and is worth the extra
  category.

**Scheme B — City → county → CDPHE Health Statistics Region (21 regions)**

- *How.* Build city → county from a free authoritative source (Census Gazetteer
  Places file, or the Colorado municipality list), then county → HSR from the
  CDPHE Open Data layer.
- *Tradeoffs.* Fully cited end-to-end and the scheme a Colorado public-health
  audience will recognize on sight — HSR is how CDPHE itself reports health data,
  so results are directly comparable to published CDPHE statistics. Cost: 21
  regions across 19,390 prescribers means several regions will have very few
  prescribers, which reintroduces small-cell fragility in any within-region
  comparison. Also requires a documented rule for multi-county cities. Estimated
  5–8 hours.

**Scheme C — City → county → rural / frontier / urban**

- *How.* Same city → county step as Scheme B, then apply the Colorado Rural
  Health Center's county designations.
- *Tradeoffs.* Only three buckets, so every bucket is well-populated and robust.
  The rural/frontier framing is the dominant lens in Colorado health policy and
  needs no explanation to that audience. Cited to CRHC. Cost: CRHC's own caveat
  that these are programmatic designations rather than definitions must be stated
  — a reviewer who uses a different program's rural definition will get different
  counties. The published designation table also has a vintage that should be
  checked and named. Estimated 4–6 hours.

**Combination worth noting:** B and C share the city → county step entirely. If
that crosswalk is built once, the second scheme costs only the county → region
join — roughly an extra hour. That makes "Scheme C, with Scheme B available as a
robustness check" a materially better deal than either alone.

### 4.3 Open items logged

Which scheme to use, and the multi-county assignment rule, are decisions for
Caleb. Both are logged in `QUESTIONS.md`.

---

## 5. ANYTHING ELSE

### 5.1 `Brnd_Name` and `Gnrc_Name` are truncated at 30 characters

The maximum observed length of both fields is exactly 30. 110 `Gnrc_Name` values
sit at 30 characters and are visibly cut mid-word
(`Abacavir/Dolutegravir/Lamivudi`, `Candesartan/Hydrochlorothiazid`,
`Triamterene/Hydrochlorothiazid`). This is a field-width limit, not a data
problem per se — but it means:

- Two genuinely different drugs could in principle collapse to the same truncated
  string. Worth a duplicate check before treating `Gnrc_Name` as a clean key.
- Any external join on drug name will fail on these 110 values (§3).
- Displaying these strings in a deliverable without a footnote invites a reviewer
  to think the analyst mangled them.

### 5.2 `Prscrbr_City` contains substantial spelling variation

226 distinct strings do **not** represent 226 places. At least 28 are variants of
another string already in the list, affecting **1,856 rows (0.48%)** and reducing
the true place count to roughly 198 before any further review.

| Canonical | Variants present | Rows on variants | NPIs |
|---|---|---|---|
| Colorado Springs | Colo Springs, Colo Sprgs, Co Springs, Colorado Spgs, Colorado Spings | 172 | 10 |
| Lone Tree | Lone Treet, Lonetree | 310 | 18 |
| Fort Carson | Ft Carson, Ft. Carson | 227 | 13 |
| Grand Junction | Grand Jct | 644 | 14 |
| La Junta | Lajunta | 103 | 1 |
| Loveland | Lovleand, Lovlenad | 96 | 2 |
| Glenwood Springs | Glenwood Spgs | 77 | 6 |
| Haxtun | Haxton | 64 | 1 |
| Wheat Ridge | Wheatridge | 63 | 1 |
| Fort Collins | Ft Collins, Ft. Collins | 46 | 8 |
| Greeley | Greely, Greenley | 13 | 2 |
| USAF Academy | U S A F Academy, Usafa | 9 | 2 |
| Steamboat Springs | Steamboat Spgs | 9 | 2 |
| Greenwood Village | Greenwood Vlg | 8 | 1 |
| Keenesburg | Keenesberg | 8 | 1 |
| Highlands Ranch | Highland Ranch | 5 | 1 |
| Northglenn | North Glenn, Northgelnn | 2 | 2 |

Additional entries needing a judgment call rather than a spelling fix:
`Montebello` (a Denver neighborhood, not a municipality), `Dublin` (no Colorado
municipality of this name — origin not determined), `Apple Valley` (an
unincorporated Boulder County locality), `Security` (part of Security-Widefield),
`Peterson Afb` vs. `Peterson Space Force Base` (the same installation, renamed),
`Buckley Afb`, `Fort Carson` (military installations, not municipalities).

**This is flagged, not fixed.** Whether to normalize, and how to treat
neighborhoods and military installations, is logged in `QUESTIONS.md`.

Two structural facts that make normalization safe: each NPI appears with exactly
**one** city string (0 NPIs have more than one), and each NPI appears with exactly
**one** specialty (0 NPIs have more than one). City and specialty are prescriber
attributes, not row attributes.

### 5.3 No organizational providers are identifiable in this file

CMS documentation states `Prscrbr_First_Name` is blank for organizational NPIs
(NPPES entity type "O"), and that the dataset "contains information predominantly
from individual providers, but also includes a small proportion of organizational
providers." In the Colorado file, **`Prscrbr_First_Name` has zero blanks.** Either
no organizational NPIs survived the ≥11-claim threshold in Colorado, or entity
type cannot be inferred from this field here. The file carries no entity-type
column, so this cannot be resolved internally. Consequence: any statement about
"individual prescribers" rests on an assumption that should be either verified
against NPPES or stated as an assumption. Logged in `QUESTIONS.md`.

### 5.4 The grain, and what it does and does not permit

Each row is a unique `Prscrbr_NPI` + `Brnd_Name` + `Gnrc_Name` combination —
verified: **0 duplicates** on those three columns across 390,473 rows. Note the
grain includes brand, so aggregating to the generic level (this project's stated
analytic grain) requires summing across brand rows within a generic. A prescriber
who wrote both the branded and generic form of a molecule has two rows, and
counting rows instead of summing them will double-count them as prescribers.

### 5.5 Small internal inconsistencies worth knowing before someone else finds them

- **596 rows have `Tot_Drug_Cst = $0.00`** despite ≥11 claims. No negative costs
  anywhere.
- **11,658 rows have `GE65_Tot_Drug_Cst = $0.00`, but only 11,263 have
  `GE65_Tot_Clms = 0`** — leaving 395 rows with 65+ claims recorded but $0 in 65+
  cost.
- **`Tot_30day_Fills` ≠ `Tot_Day_Suply / 30` in 45.7% of rows** (>1% relative
  difference). This is expected behavior from per-claim bottom-coding at 1.0 and
  top-coding at 12.0, not an error — but it will look like one to a reviewer who
  checks the arithmetic. Never re-derive 30-day fills from day supply.

None of these have been altered.

### 5.6 Attribution limits CMS states about the NPI itself

Directly quotable if challenged on prescriber-level conclusions:

> "There are known issues in the attribution of PDEs to a specific NPI. Some
> prescribers' claims may be listed under multiple NPIs, such as an
> organizational and individual NPI. In this case, users cannot determine a
> prescriber's actual total because it is not possible to identify the
> individual's portion when the claim is submitted under their organization. In
> addition, some of an individual's prescriptions might be erroneously attributed
> to a different prescriber due to errors that can occur in the transcription of
> prescriber information at the point-of-sale."

CMS also states plainly: *"the information presented in this file does not
indicate the quality of care provided by individual clinicians."*

### 5.7 Coverage and timing limits

- **Part D only.** These are Part D beneficiaries — approximately 77.1% of
  Medicare beneficiaries, and a fraction of any prescriber's full panel. CMS:
  the data "may not be representative of a prescriber's entire prescribing
  pattern, nor be fully inclusive of all prescriptions written by the provider."
- **Claims cutoff.** PDEs received through **June 30, 2025** for the 2024 data
  year. Late-adjudicated claims are absent.
- **Demographics lag the utilization by a year.** Prescriber name, city, and
  specialty reflect NPPES **as of the end of calendar year 2025**, while the
  prescribing is calendar year 2024. A prescriber who relocated or changed
  specialty in 2025 carries the 2025 attribute against 2024 prescribing.
- **Statutorily excluded drugs** are underrepresented — some Part D plans cover
  them as a supplemental benefit and some do not, so utilization of those
  products is understated.
- **Costs are gross of manufacturer rebates** and cannot be attributed to the
  Medicare Trust Fund.
- **A small proportion of PDEs whose NDCs did not match** the commercial drug
  information database were excluded entirely.

### 5.8 Method changes that break year-over-year comparison

If any part of the project compares 2024 to earlier years:

- Data years 2013–2019 were **restated in August 2021**, primarily because of
  changes in how suppression was applied. Pre-2021 downloads of those years do
  not match current ones.
- Long-acting opioid identification changed with data year 2021 — from CDC oral
  MME data to the Medicare Part D Overutilization Monitoring System. Relevant if
  §3.3's `Opioid_LA_Drug_Flag` is used across years.
- The `Prscrbr_Type_Src` encoding differs from the older `description_flag`
  ("S"/"T") in pre-2021 releases.

### 5.9 Reading the file correctly

- `encoding='utf-8-sig'` — the file carries a UTF-8 BOM that will otherwise
  corrupt the first column name to `ï»¿Prscrbr_NPI`.
- Read `Prscrbr_NPI` and `Prscrbr_State_FIPS` as **strings**. FIPS is stored as
  `08`; numeric parsing drops the leading zero. NPI is an identifier, not a
  quantity.
- The 22 columns are pipe-clean but `Prscrbr_Type`, `Brnd_Name`, and `Gnrc_Name`
  are quoted in the raw file where they contain commas or spaces. Standard CSV
  parsing handles this; naive splitting on commas does not.
- Column order differs from the sibling Geography-and-Drug file
  (`GE65_Tot_Drug_Cst` precedes `GE65_Tot_Day_Suply` here). Do not assume
  positional alignment between the two files.

### 5.10 Sibling files worth knowing exist

Same release, same CMS landing page, free:

- **Part D Prescribers — by Provider** (one row per NPI). Adds beneficiary
  demographics (age, sex, race, Medicare/Medicaid entitlement, HCC risk scores),
  MAPD/PDP split, LIS/non-LIS split, brand/generic/other split, and the opioid /
  antibiotic / antipsychotic aggregates. **Critically: the summary tables are
  aggregated from all PDE data, not from the redacted detail file** — so their
  totals are the true totals, and they will not match sums from this file. That
  asymmetry is a trap and also an opportunity: it allows a stated quantification
  of how much the ≥11-claim redaction removes.
- **Part D Prescribers — by Geography and Drug** (state/national × drug). Source
  of the four drug flags in §3.3, plus LIS and non-LIS beneficiary cost share.

### 5.11 Open items

Ambiguities that require a decision from Caleb rather than a default have been
logged in `outputs/QUESTIONS.md` per project constraints.

---

## Sources

- [Medicare Part D Prescribers Datasets: A Methodological Overview, April 2023 (CMS OEDA)](https://data.cms.gov/sites/default/files/2023-05/MUP_DPR_RY23_20230424_Methodology_508.pdf) — population, aggregation, redaction and suppression rules, data limitations, update history
- [Medicare Part D Prescriber Public Use File: A Methodological Overview, November 6, 2020 (CMS OEDA)](https://www.cms.gov/files/document/part-d-prescriber-puf-methodology.pdf) — verbatim `*` / `#` suppression-flag definitions for the GE65 claim and beneficiary flags
- [Medicare Part D Prescribers Datasets: Technical Specifications, August 2021 (CMS OEDA)](https://data.cms.gov/sites/default/files/2021-08/mup_dpr_ry21_20210819_technical_specifications.pdf) — source data, step-by-step construction, 30-day fill derivation, specialty-assignment hierarchy
- [Medicare Part D Prescribers — by Geography and Drug Data Dictionary, RY25 (CMS)](https://data.cms.gov/sites/default/files/2025-04/MUP_DPR_RY25_20250401_DD_Geo_508.pdf) — field definitions shared with this file; opioid / long-acting opioid / antibiotic / antipsychotic flag definitions
- [Medicare Part D Prescribers — by Provider and Drug (CMS dataset landing page)](https://data.cms.gov/provider-summary-by-type-of-service/medicare-part-d-prescribers/medicare-part-d-prescribers-by-provider-and-drug) — dataset home (JavaScript-rendered; not retrievable as text)
- [Medicare Part D Prescribers — by Provider and Drug Data Dictionary (CMS)](https://data.cms.gov/resources/medicare-part-d-prescribers-by-provider-and-drug-data-dictionary) — file-specific dictionary (JavaScript-rendered; not retrievable as text)
- [RxClass Overview, NLM Lister Hill Center](https://lhncbc.nlm.nih.gov/RxNav/applications/RxClassIntro.html) — ATC1–4 class type, `ATC` and `ATCPROD` membership sources, full class-type inventory
- [RxClass FAQ, NLM](https://lhncbc.nlm.nih.gov/RxNav/applications/RxClassFAQ.html) — search by drug name, brand-name handling, ATC identifier search
- [RxNav Terms of Service, NLM](https://lhncbc.nlm.nih.gov/RxNav/TermsofService.html) — check before scripting the API
- [USP Medicare Model Guidelines (USP)](https://www.usp.org/health-quality-safety/usp-medicare-model-guidelines) — statutory basis, version history, downloadable v7.0 / v6.0 / v5.0 files and the MMG-FRF alignment file
- [Formulary Reference NDC File (HHS guidance portal)](https://www.hhs.gov/guidance/document/formulary-reference-ndc-file) — FRF contents and NDC keying
- [CDPHE Colorado Health Statistics Regions (CDPHE Open Data)](https://data-cdphe.opendata.arcgis.com/datasets/CDPHE::cdphe-colorado-health-statistics-regions/about) — 21 HSRs as whole-county aggregations, development methodology
- [CDPHE Colorado Health Statistics Regions (Colorado Information Marketplace)](https://data.colorado.gov/dataset/CDPHE-Colorado-Health-Statistics-Regions/5nsk-8tdy) — alternate download
- [A6. Emergency Preparedness and Response (CDPHE LPHA portal)](https://cdphe-lpha.colorado.gov/a6-emergency-preparedness-and-response) — nine LPHA / all-hazards regions
- [Accountable Care Collaborative Phase III Regional Accountable Entity Map, December 2023 (Colorado HCPF)](https://hcpf.colorado.gov/sites/hcpf/files/ACC%20Phase%20III%20RAE%20Region%20Fact%20Sheet%20December%202023.pdf) — four-region Phase III map effective July 1, 2025; selection criteria; Eastern Plains / Western Slope regional identity
- [The Ways of the RAEs (Colorado Health Institute)](https://www.coloradohealthinstitute.org/research/ways-raes) — seven-region Phase II RAE structure, launched July 1, 2018
- [Colorado: County Designations (Colorado Rural Health Center)](https://coruralhealth.org/wp-content/uploads/2013/10/2014.Colorado-County-Designations.pdf) — rural and frontier definitions and county counts
- [Maps (Colorado Rural Health Center)](https://coruralhealth.org/resources/maps-resource) — current designation maps
- [Understanding Colorado Regions (Colorado State Demography Office)](https://gis.dola.colorado.gov/RegionsMap/) — 14 planning and management regions
