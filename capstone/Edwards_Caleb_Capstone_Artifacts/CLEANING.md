CATEGORY: SOLELY CAPSTONE — graded deliverable. Structural record for an instructor. Not a working file.

# Data Cleaning Log

Source: `Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv` (2024 CMS Medicare
Part D Prescribers by Provider and Drug, Colorado extract). All row counts below are
independently reproducible from this file with `pandas.read_csv(path,
encoding='utf-8-sig', dtype=str, keep_default_na=False)`.

Every step below was executed against the full file, in order. No row was removed at
any step. Final row count equals source row count: **390,473 in, 390,473 out.**

## Step 1 — Encoding

The file opens with a UTF-8 byte-order mark. Read with `encoding='utf-8-sig'`; a plain
`utf-8` read leaves a BOM character prepended to the first column name
(`Prscrbr_NPI`), which breaks column lookups by name.

Rows before: 390,473. Rows after: 390,473.

## Step 2 — Schema verification

Confirmed the file has 22 columns in the documented order (`Prscrbr_NPI` through
`GE65_Tot_Benes`). No columns added, renamed, or dropped.

Rows before: 390,473. Rows after: 390,473.

## Step 3 — Row count verification

Confirmed the loaded row count matches the file: 390,473 data rows (header excluded).

Rows before: 390,473. Rows after: 390,473.

## Step 4 — Geographic scope check

Checked `Prscrbr_State_Abrvtn` for values other than `CO`. Result: 390,473 of 390,473
rows (100%) are `CO`. The file is a pre-filtered Colorado extract; no state filter was
applied here because none is needed.

Rows before: 390,473. Rows after: 390,473.

## Step 5 — Type coercion

Ten columns are numeric by definition and loaded as text: `Tot_Clms`,
`Tot_30day_Fills`, `Tot_Day_Suply`, `Tot_Drug_Cst`, `Tot_Benes`, `GE65_Tot_Clms`,
`GE65_Tot_30day_Fills`, `GE65_Tot_Drug_Cst`, `GE65_Tot_Day_Suply`, `GE65_Tot_Benes`.
Each was coerced from string to numeric. Non-blank values that failed to parse: 0 for
all ten columns. Every non-blank value in these columns is a valid number.

Blank strings in these columns were coerced to missing (`NaN`), not to zero and not to
an imputed value. CMS's published documentation for this file states that blanks in
these fields mark cells suppressed under the beneficiary-privacy threshold, not
data-entry omissions — see Data Limitations below.

Rows before: 390,473. Rows after: 390,473.

## Step 6 — Null-handling verification

Checked all 22 columns for true nulls: 0 across every column. The file contains no
nulls; all missingness takes the form of the empty string. Per-column empty-string
counts, checked directly against the raw file:

| Column | Empty-string count | % of rows |
|---|---|---|
| `Tot_Benes` | 229,912 | 58.9% |
| `GE65_Sprsn_Flag` | 226,277 | 58.0% |
| `GE65_Tot_Clms` | 164,196 | 42.1% |
| `GE65_Tot_30day_Fills` | 164,196 | 42.1% |
| `GE65_Tot_Drug_Cst` | 164,196 | 42.1% |
| `GE65_Tot_Day_Suply` | 164,196 | 42.1% |
| `GE65_Bene_Sprsn_Flag` | 53,317 | 13.7% |
| `GE65_Tot_Benes` | 337,156 | 86.3% |
| All other 14 columns | 0 | 0% |

No blank was filled, dropped, or imputed. `Tot_Clms` and `Tot_Drug_Cst` — the inputs to
both primary metrics — are complete: 0% blank.

Rows before: 390,473. Rows after: 390,473.

## Step 7 — Duplicate check

Checked for exact duplicate rows across all 22 columns: 0 found. Checked for duplicate
rows on the file's grain key (`Prscrbr_NPI` + `Brnd_Name` + `Gnrc_Name`): 0 found. Each
prescriber-brand-generic combination appears exactly once.

Rows before: 390,473. Rows after: 390,473.

## Step 8 — Entity-mapping consistency check

Checked whether any `Prscrbr_NPI` maps to more than one `Prscrbr_Type` or more than one
`Prscrbr_City` across its rows. Result: 0 NPIs with more than one specialty, 0 NPIs
with more than one city. Every NPI has exactly one specialty and one city value in this
file; carrying either forward from row level to prescriber level loses no information
and creates no conflict.

Rows before: 390,473. Rows after: 390,473.

## Step 9 — Value tie-out

Summed `Tot_Drug_Cst` before and after Step 5's coercion: $2,737,455,388.61 both times.
Coercion changed no value.

Rows before: 390,473. Rows after: 390,473.

## No exclusions applied

No row was filtered, dropped, or reweighted at any step. The 390,473-row file used for
profiling in `STATS_OUTPUT.md` is the full source file, unmodified except for the
type coercion in Step 5.

Filtering decisions that were identified but require a call only Caleb can make —
whether to drop the 596 zero-cost rows, whether to treat `Prscrbr_City` spelling
variants as one place, how to handle the 110 generic-name and 32 brand-name values
truncated at 30 characters, whether the ≥30-prescriber specialty rule changes anything
upstream of aggregation — were **not** applied. They are logged in `QUESTIONS.md`, not
decided here.

## Data Limitations

**CMS cell suppression sets a hard floor on what this file contains.** Every row has
`Tot_Clms` ≥ 11 and `Tot_30day_Fills` ≥ 11; CMS does not release
prescriber-drug combinations below that count. This rules out computing a
prescriber's true total claim volume or true total cost from this file — both are
sums over only the rows CMS chose to report, understating the true total for any
prescriber whose volume is spread thinly across many drugs. It also rules out
detecting or counting the suppressed combinations themselves; their number is unknown
from this file.

**Beneficiary columns are not usable as denominators.** `Tot_Benes` is blank in 58.9%
of rows, `GE65_Tot_Benes` in 86.3%, and the four `GE65_Tot_Clms` / `GE65_Tot_30day_Fills`
/ `GE65_Tot_Drug_Cst` / `GE65_Tot_Day_Suply` columns in 42.1%. This is the same
suppression mechanism, tied to `GE65_Sprsn_Flag` and `GE65_Bene_Sprsn_Flag`, applied to
patient-count fields specifically. It rules out any cost-per-beneficiary metric and
rules out any GE65 (65-and-older) subpopulation metric computed on the full 390,473-row
base — a GE65 metric can only be computed on the 226,277 rows (57.9%) where the GE65
claims fields are populated, and that subset is not a random sample of rows.

**Generic and brand names are truncated at 30 characters.** 110 distinct `Gnrc_Name`
values and 32 distinct `Brnd_Name` values hit exactly 30 characters (17,624 and 7,985
rows respectively), the field's apparent maximum length. This rules out confident
identification of the full drug name for those values without an external reference,
and rules out any exact-string join to an external drug database for the affected
rows unless the names are first repaired.

**`Prscrbr_City` is unvalidated free text.** 226 distinct values, no normalization
against a place-name authority. At least 6 pairs of values in the file look like
spelling variants of one place (e.g., `Colorado Springs` / `Colo Springs`, `Lone Tree`
/ `Lone Treet`) totaling 155 rows across the low-count member of each pair. This
rules out treating city-level counts as exact without a normalization step, which was
not performed here.

**Specialty labels are not uniformly sourced.** `Prscrbr_Type_Src` shows three
different derivations: `Claim-Specialty` (344,460 rows, 88.2%), `NPPES-Specialty`
(40,016 rows, 10.2%), `NPPES-Taxonomy` (5,997 rows, 1.5%). This rules out treating
`Prscrbr_Type` as a single consistently-derived classification; a peer group built on
this column mixes claim-derived and registry-derived specialty assignments.

**No entity-type column exists in this file.** CMS's documentation states
organizational NPIs appear in the Part D prescriber data generally, but this file has
no field that flags entity type, and `Prscrbr_First_Name` is 0% blank (the usual
organizational-NPI marker). This rules out distinguishing individual from
organizational prescribers from this file alone.

## Step 10 — Cached clean file (added 2026-08-13, Stage 0)

The raw CSV is read exactly once for the whole project. That read produced
`outputs/part_d_co_clean.csv`, which every later stage uses in place of the raw file.

Read parameters, unchanged from Steps 1 and 5:
`pandas.read_csv(path, encoding='utf-8-sig', dtype=str, keep_default_na=False)`,
then the ten numeric columns coerced with `pd.to_numeric(..., errors='coerce')`.

Additional operations applied at this step, and nothing else:

1. **Whitespace trim on four grouping keys** — `Prscrbr_City`, `Prscrbr_Type`,
   `Gnrc_Name`, `Brnd_Name` had leading/trailing whitespace stripped so that
   group-by keys cannot split on invisible characters. This changed no distinct-value
   count: 226 cities, 97 specialties, 1,177 generics, 1,662 brands before and after.
   It removed no row.

2. **Two derived columns appended** — the project's two primary metrics, computed at
   row level:

   | Column | Definition | Guard |
   |---|---|---|
   | `cost_per_claim` | `Tot_Drug_Cst / Tot_Clms` | Denominator masked where `Tot_Clms <= 0`, so a zero-claim row yields `NaN` rather than infinity |
   | `cost_per_30day_fill` | `Tot_Drug_Cst / Tot_30day_Fills` | Denominator masked where `Tot_30day_Fills <= 0`, same reason |

   Both denominators are complete (0% blank) and, because of CMS's suppression floor,
   never fall below 11. Neither guard fired: **0 nulls in `cost_per_claim`, 0 nulls in
   `cost_per_30day_fill`.**

   Cost-per-beneficiary is deliberately not derived. `Tot_Benes` is blank in 58.9% of
   rows (Step 6) and is not a usable denominator.

3. **No exclusion, no imputation, no deduplication.** Nothing was filtered. The four
   filtering decisions logged in `QUESTIONS.md` remain unapplied and undecided.

### Reconciliation

| Measure | Raw CSV | `part_d_co_clean.csv` | Delta |
|---|---|---|---|
| Rows | 390,473 | **390,473** | **0** |
| Columns | 22 | 24 (22 source + 2 derived) | +2 |
| `SUM(Tot_Drug_Cst)` | $2,737,455,388.61 | $2,737,455,388.61 | $0.00 |
| `SUM(Tot_Clms)` | 16,573,710 | 16,573,710 | 0 |
| Distinct `Prscrbr_NPI` | 19,390 | 19,390 | 0 |
| Distinct `Prscrbr_Type` | 97 | 97 | 0 |
| Distinct `Gnrc_Name` | 1,177 | 1,177 | 0 |
| Distinct `Brnd_Name` | 1,662 | 1,662 | 0 |
| Distinct `Prscrbr_City` | 226 | 226 | 0 |

Type-coercion failures across all ten numeric columns: **0**. Every value that failed
to parse was a blank string, and every blank string is a CMS-suppressed cell, not a
data error. Per-column blank counts are identical to Step 6's table.

**390,473 in, 390,473 out.** No delta to explain.
