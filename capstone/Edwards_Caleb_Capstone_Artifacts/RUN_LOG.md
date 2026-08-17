CATEGORY: COWORK-ONLY — working file. Exists so this run can be verified. Never submitted.

# Run Log — 2026-08-10 (scheduled "documentation" task)

Chronological record of this automated run. Row count is 390,473 throughout — no
filtering was performed at any point in this run.

## 1. Checked existing outputs folder

`ls` on `\outputs` before doing anything. Found prior-session artifacts already
present, all dated 2026-08-10: `PREGAME_RESEARCH.md`, `SQL_RESULTS.md`,
`SQL_FLAGS.md`, `part_d_profiling.sql`, `load_part_d.py`, `part_d.sqlite`,
`PY_RESULTS.md`, `PY_FLAGS.md`, `part_d_analysis.ipynb`, `CAPSTONE_PROFILE.xlsx`,
`CAPSTONE_AGGREGATES.xlsx`, `outliers.csv`, `regression_output.csv`, and an existing
`QUESTIONS.md`. These were treated as prior work to verify against, not regenerated.

## 2. Read prior work to establish baseline facts

Read in full: `load_part_d.py` (the loader — confirms no cleaning/coercion is
performed at load time, blanks kept as literal empty string), `PY_FLAGS.md`,
`SQL_FLAGS.md`, existing `QUESTIONS.md` (14 open questions, Q1–Q14).

Read Section 1 ("Import & Verification") and Section 2 ("Univariate Profiling") of
`SQL_RESULTS.md` — row/column counts, state check, distinct-entity counts, per-column
null and empty-string counts, numeric-column summary statistics for all 10 numeric
columns, and full/partial categorical distributions for `Prscrbr_Type`,
`Prscrbr_Type_Src`, `Prscrbr_City`, `Brnd_Name`, `Gnrc_Name`, `GE65_Sprsn_Flag`,
`GE65_Bene_Sprsn_Flag`.

Read table-of-contents headers only (via grep) for `PY_RESULTS.md` and
`PREGAME_RESEARCH.md` to confirm scope — did not pull regression/outlier content from
`PY_RESULTS.md` into this run's output, since that is model output, not profiling, and
out of scope for this role.

## 3. Independently re-verified header facts against the raw CSV

Did not trust `SQL_RESULTS.md` numbers without a direct check. Ran the following
against `Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv` directly:

```python
import pandas as pd
df = pd.read_csv(path, encoding='utf-8-sig', dtype=str, keep_default_na=False)
df.shape                                          # (390473, 22)
df['Prscrbr_State_Abrvtn'].unique()               # ['CO']
df['Prscrbr_NPI'].nunique()                       # 19390
df['Prscrbr_Type'].nunique()                      # 97
df['Gnrc_Name'].nunique()                         # 1177
df['Brnd_Name'].nunique()                         # 1662
df['Prscrbr_City'].nunique()                      # 226
# per-column empty-string counts for the 6 suppression-bearing columns — matched
# SQL_RESULTS.md exactly (58.9%, 86.3%, 42.1% x4)
tot_clms = pd.to_numeric(df['Tot_Clms'], errors='coerce')   # 0 NaN produced
tot_cost = pd.to_numeric(df['Tot_Drug_Cst'], errors='coerce')  # 0 NaN produced
tot_cost.sum()                                    # 2737455388.61 — matches
(tot_cost == 0).sum()                             # 596
((tot_cost == 0) & (tot_clms > 0)).sum()          # 596
df.duplicated().sum()                             # 0
df.duplicated(subset=['Prscrbr_NPI','Brnd_Name','Gnrc_Name']).sum()  # 0
```

All figures matched `SQL_RESULTS.md` exactly. No discrepancy found.

## 4. Additional direct checks not already in prior work

```python
(df['Gnrc_Name'].str.len() == 30).sum()          # 17624 rows
df.loc[df['Gnrc_Name'].str.len()==30, 'Gnrc_Name'].nunique()   # 110 distinct values
(df['Brnd_Name'].str.len() == 30).sum()          # 7985 rows
df.loc[df['Brnd_Name'].str.len()==30, 'Brnd_Name'].nunique()   # 32 distinct values
df.groupby('Prscrbr_NPI')['Prscrbr_Type'].nunique().gt(1).sum()  # 0
df.groupby('Prscrbr_NPI')['Prscrbr_City'].nunique().gt(1).sum()  # 0
df.groupby('Prscrbr_NPI').size().median()        # 7.0 rows per NPI
df.groupby('Prscrbr_NPI')['Tot_Drug_Cst_numeric'].sum().eq(0).sum()  # 1 prescriber
# city spelling-variant pair row counts (Colorado Springs/Colo Springs, etc.)
# — confirms 6 pairs, 155 rows on the low-count side, matches PY_FLAGS.md Section 1
```

## 5. Built generic-drug-level rollup

Grouped by `Gnrc_Name`, summed `Tot_Clms`, `Tot_30day_Fills`, `Tot_Drug_Cst`, counted
distinct NPIs and rows; derived `cost_per_claim` and `cost_per_fill` per generic.
Verified the sum of `tot_cost` across all 1,177 generics equals $2,737,455,388.61 —
ties to the file total exactly, confirming the groupby dropped no rows.

## 6. Wrote CLEANING.md

Documented Steps 1–9 (encoding, schema check, row count, state check, type coercion,
null-handling verification, duplicate check, entity-mapping check, value tie-out).
No exclusion step was written because none was performed — every filtering decision
identified during research requires a call from Caleb and is logged in `QUESTIONS.md`
instead of being applied.

## 7. Wrote STATS_OUTPUT.md

Compiled load verification, distinct-entity counts, null/suppression profile, full
10-column numeric summary, full 97-row `Prscrbr_Type` distribution, `Prscrbr_Type_Src`
distribution, top-20 `Prscrbr_City` / `Brnd_Name` / `Gnrc_Name` distributions with
residual row counts, both suppression-flag distributions, and the top-20
generic-drug-level cost rollup. No commentary, findings, or interpretation included.

## 8. Reviewed and re-issued QUESTIONS.md

Read the existing `QUESTIONS.md` (14 questions, sourced from `PREGAME_RESEARCH.md`,
dated 2026-08-10). Confirmed all 14 remain unresolved — nothing in this run's checks
(Sections 3–5 above) resolved any of them, and no new ambiguity surfaced. Re-issued
with a category header per this run's four-document spec; content unchanged from the
version already in `\outputs`.

## 9. Copied final files from scratch working directory to `\outputs`

`CLEANING.md`, `STATS_OUTPUT.md`, `RUN_LOG.md`, `QUESTIONS.md` written in the scratch
working directory first, then copied to `\outputs` as the final step, per the
low-storage / no-intermediate-copies constraint (single copy operation, no
duplicate large files retained).
