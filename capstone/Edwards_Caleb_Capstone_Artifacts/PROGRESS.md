CATEGORY: COWORK-ONLY — working file. Running record of stages. Never submitted.

# PROGRESS

---

# Stage 0 — Calibrate, Inventory, Verify, Clean, Map Requirements
**Run:** 2026-08-13, ~00:35–00:50 MDT · **Gate:** none (first stage)
**Deadline:** 2026-08-13, 4:00 PM MDT

## 1. Inventory

### Project root — `...\DAB Capstone`

| File | Size | Modified |
|---|---|---|
| `Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv` | 58,355,800 | 2026-08-10 10:35 |
| `Edwards_Caleb_CapstoneProposal.docx` | 9,524 | 2026-08-10 10:19 |
| `capstone assignment rubric.pdf` | 1,078,276 | 2026-08-10 10:58 |
| `Data Analytics Capstone instructions.pdf` | 343,984 | 2026-08-10 22:52 |
| `DAB Workshops\` (dir, 11 files) | — | — |
| `Lecture PDFs\` (dir, 21 files) | — | — |
| `outputs\` (dir) | — | — |
| `.claude\` (dir, settings only) | — | — |

Note: the instructions PDF is named `Data Analytics Capstone instructions.pdf`
(spaces), not `Data_Analytics_Capstone_instructions.pdf` as written in the project
context block. Same file.

### `outputs\` — 22 files + `charts\`

| File | Size | Modified |
|---|---|---|
| `part_d_co_clean.csv` | 71,904,750 | **2026-08-13 00:44 (new, this stage)** |
| `part_d.sqlite` | 60,518,400 | 2026-08-10 12:48 |
| `outliers.csv` | 8,249,552 | 2026-08-10 13:05 |
| `CAPSTONE_AGGREGATES.xlsx` | 1,638,972 | 2026-08-10 13:01 |
| `CAPSTONE_PROFILE.xlsx` | 729,887 | 2026-08-10 13:00 |
| `SQL_RESULTS.md` | 126,852 | 2026-08-10 12:53 |
| `part_d_analysis.ipynb` | 144,061 | 2026-08-10 13:05 |
| `regression_output.csv` | 101,250 | 2026-08-10 13:05 |
| `PREGAME_RESEARCH.md` | 51,977 | 2026-08-10 12:53 |
| `part_d_profiling.sql` | 48,231 | 2026-08-10 12:53 |
| `PY_RESULTS.md` | 31,738 | 2026-08-10 13:05 |
| `CITY_REFERENCE.xlsx` | 21,489 | 2026-08-10 23:13 |
| `STATS_OUTPUT.md` | 13,830 | 2026-08-10 13:14 |
| `PY_FLAGS.md` | 11,079 | 2026-08-10 13:05 |
| `make_charts.py` | 10,704 | 2026-08-10 23:11 |
| `CLEANING.md` | 7,767 | 2026-08-10 13:14 |
| `QUESTIONS.md` | 7,416 | 2026-08-10 23:13 |
| `SQL_FLAGS.md` | 6,037 | 2026-08-10 12:54 |
| `RUN_LOG.md` | 5,996 | 2026-08-10 13:14 |
| `load_part_d.py` | 2,407 | 2026-08-10 12:48 |
| `CHART_FLAGS.md` | 1,285 | 2026-08-10 23:11 |

Plus this stage's four new documents: `CALIBRATION.md`, `VERIFICATION.md`,
`REQUIREMENTS.md`, `PROGRESS.md`.

### `outputs\charts\` — 5 files

| File | Size | Modified |
|---|---|---|
| `01_cost_concentration_pareto.png` | 71,883 | 2026-08-10 23:11 |
| `02_cost_per_claim_by_specialty_box.png` | 226,847 | 2026-08-10 23:11 |
| `03_top15_cities_total_cost.png` | 84,641 | 2026-08-10 23:11 |
| `04_within_specialty_percentile_spread.png` | 101,365 | 2026-08-10 23:11 |
| `05_variance_explained_by_dimension.png` | 47,748 | 2026-08-10 23:11 |

## 2. Calibration → `CALIBRATION.md`

Extracted text from all 21 lecture PDFs and parsed the code of Caleb's submitted
workshops. Result: a technique whitelist for SQL, pandas, statistics, seaborn,
Tableau, and Excel, plus six items (B1–B6) in the existing work that exceed it.

The load-bearing finding: **the only regression taught in the entire curriculum is
`sns.regplot()`.** No lecture ever produces a coefficient table or an R². ANOVA,
Kruskal–Wallis, chi-square, and t-tests *are* taught (Advanced Pandas II) and answer
the proposal's "which dimensions are meaningful rather than noise" question inside
the syllabus. Second finding: `CASE WHEN` is never taught in any SQL lecture; the
existing profiling SQL uses it 54 times.

## 3. Verification → `VERIFICATION.md`

8 checks. **7 PASS, 1 INCONCLUSIVE, 0 FAIL, 0 ABSENT.**

Headline: the prior work reconciles. `part_d.sqlite` holds exactly 390,473 rows
summing to $2,737,455,388.61. All four `CAPSTONE_AGGREGATES.xlsx` sheets tie to that
same total. All 35 SQL statements run and all 35 documented results match. The
notebook executes clean and regenerates `regression_output.csv`, `PY_RESULTS.md`, and
`PY_FLAGS.md` byte-identically; `make_charts.py` regenerates all 5 charts and
`CHART_FLAGS.md` byte-identically.

The one INCONCLUSIVE is `STATS_OUTPUT.md` — its numbers spot-check correct against the
database, but the script that produced it was never saved, so it cannot be re-run.

## 4. Clean + cache → `outputs\part_d_co_clean.csv`

Raw CSV read **once**, on 2026-08-13 00:44, with `encoding='utf-8-sig'`,
`dtype=str`, `keep_default_na=False`.

| | |
|---|---|
| Rows in | 390,473 |
| Rows out | **390,473** — delta **0**, no row excluded at any step |
| Columns | 22 source + 2 derived = 24 |
| `SUM(Tot_Drug_Cst)` | $2,737,455,388.61 — ties to raw |
| `SUM(Tot_Clms)` | 16,573,710 — ties to raw |
| Distinct entities | 19,390 NPI · 97 specialties · 1,177 generics · 1,662 brands · 226 cities — all tie |
| Type-coercion parse failures | **0** across all ten numeric columns |
| Derived nulls | 0 in `cost_per_claim`, 0 in `cost_per_30day_fill` |

Written to the user's disk directly (71.9 MB — above the 20 MB file-transfer cap, so
generated in place rather than round-tripped). Every later stage reads this file
instead of the raw CSV. See `CLEANING.md` §Step 10 for the derived-column definitions.

## 5. Requirements → `REQUIREMENTS.md`

Rubric is **130 points across 8 graded lines**. Mapped each to its satisfying artifact.
50 of 130 points (R1 + R2) are pure submission completeness. R5 (insights and
recommendations, 15 pts) currently has **zero** coverage — by design, since Stages 0–2
forbid interpretation.

## 6. Open questions

`QUESTIONS.md` still holds **Q1–Q14, all unresolved.** Stage 0 resolved none and
raised none. No new data ambiguity surfaced.

---

## BUILD vs. REUSE for Stages 1–6

### REUSE AS-IS — verified, in-curriculum, do not touch

| Artifact | Why |
|---|---|
| `CLEANING.md` | PASS. Meets the rubric's "cleaning documentation" artifact requirement (R1, R4) at an Excellent standard. Stage 0 appended Step 10 only. |
| `CAPSTONE_AGGREGATES.xlsx` | PASS. Ties to $2,737,455,388.61 on all four sheets. Satisfies the proposal's Excel deliverable outright. |
| `part_d.sqlite` + `load_part_d.py` | PASS. 390,473 rows. The system of record for all SQL work. |
| `part_d_co_clean.csv` | New this stage. The single cached input for all Python and Tableau work. |
| `QUESTIONS.md` | Carry forward unchanged. Q1–Q14 remain Caleb's calls. |
| `CAPSTONE_PROFILE.xlsx`, `CITY_REFERENCE.xlsx`, `SQL_FLAGS.md`, `PY_FLAGS.md`, `CHART_FLAGS.md`, `PREGAME_RESEARCH.md`, `RUN_LOG.md` | Supporting material. Reference, cite where useful, do not regenerate. |

### REUSE WITH EDITS — correct, but off-syllabus constructs to swap

| Artifact | Edit | Ref |
|---|---|---|
| `part_d_profiling.sql` | Replace `CASE WHEN` (54×) with `NTILE()`; `CAST` (100×) with `* 1.0`; `CEIL` (91×) with `ROUND()` where rounding is the intent. Results must still tie to `SQL_RESULTS.md`. | CALIBRATION B2 |
| `SQL_RESULTS.md` | Re-run and refresh the sample-result blocks after the SQL edits. Numbers should not change. | — |

### REBUILD — correct but not defensible under the calibration rule

| Artifact | Why | Replacement |
|---|---|---|
| `part_d_analysis.ipynb` (analysis half) | OLS with categorical dummies, R² / adj-R² / incremental R² — never taught. Also uses `np.bincount`, `np.full`, `.transform()`, `.iterrows()`. | ANOVA (`f_oneway`) + Kruskal–Wallis per dimension, plus `groupby().agg()` means and `.quantile()` spreads. CALIBRATION B1, B3. Keep the load/clean/outlier half — `.quantile()` is taught. |
| `regression_output.csv` | Output of the above. | An ANOVA results table. |
| `charts\01`–`05` | Pareto with cumulative line, `ax.barh`, `ax.fill_between`, log axis, raw `ax.boxplot` — none taught. | `sns.barplot` / `sns.boxplot` / `sns.histplot` equivalents, linear axes. CALIBRATION B4–B5. |
| `STATS_OUTPUT.md` | INCONCLUSIVE — numbers correct, no runnable script behind them. | Regenerate from `part_d_co_clean.csv` with a saved, commented script so it is reproducible. |

### BUILD FROM NOTHING

| Deliverable | Rubric | Notes |
|---|---|---|
| Findings + interpretation | R5 (15) | Highest unearned value. Stage 3 is where interpretation begins. |
| Comprehensive Analytics Report (`.docx`) | R1 (25), R3, R4, R5 | 5 required sections + artifact appendix. |
| Slide deck (`.pptx`) | R2 (25), R8 | Storytelling, professional design, embedded visualizations. |
| Tableau executive dashboard | R8 (5) | Proposal-committed. One dashboard, no elaboration. |
| 1-page recommendation memo | R5 | Proposal-committed. |
| Speaker notes / rehearsal plan | R6 (15), R7 (10) | 10–15 min, no-prior-knowledge audience. |

### Stage 1 starts here

Edit `part_d_profiling.sql` per CALIBRATION B2 and confirm the results still tie to
`SQL_RESULTS.md`. Do not touch anything in the REUSE AS-IS list.

---

# Stage 1 — Excel Aggregate Workbook
**Run:** 2026-08-12, ~19:05–19:12 MDT · **Gate:** PASSED
**Deliverable:** `outputs\CAPSTONE_EXCEL_AGGREGATES.xlsx` · **Builder:** `outputs\build_excel_aggregates.py`

## 1. Gate

`VERIFICATION.md` check 2 marks `CAPSTONE_AGGREGATES.xlsx` **PASS**, and
`part_d_co_clean.csv` is present (71.9 MB, written 2026-08-13 00:44). Per the gate,
the existing group-level totals were **reused, not re-derived**. The cleaned CSV was
read once — for the reconciliation reference totals only, not to rebuild the rollups.

## 2. What was built

| Sheet | Grouped by | Rows | Source of the numbers |
|---|---|---|---|
| `0_Index` | — | 4 | Written this stage |
| `Reconciliation` | — | 12 checks | Live Excel formulas |
| `By_Prescriber` | `Prscrbr_NPI` | 19,390 | Carried over from `CAPSTONE_AGGREGATES.xlsx` |
| `By_Specialty` | `Prscrbr_Type` | 97 | Carried over |
| `By_Generic_Drug` | `Gnrc_Name` | 1,177 | Carried over |

`By_City` was not carried over — the task named three tabs and scope is fixed.

**Metrics per tab:** total drug cost · total claims · total 30-day fills ·
cost per claim · **cost per 30-day fill (new this stage)** · cumulative % of total cost.

**Formulas added** (all on the CALIBRATION §3 Excel taught list — `SUM`, `IFERROR`,
`COUNTA`, `ROUND`, `IF`, absolute references):

| Cell | Formula | What it does |
|---|---|---|
| Row 2, each additive column | `=SUM(col4:colN)` | Visible grand-total row; the anchor for every cumulative-% formula |
| Cost per Claim | `=IFERROR(cost/claims,"")` | Unit cost per prescription claim |
| Cost per 30-Day Fill | `=IFERROR(cost/fills,"")` | Dose-standardised unit cost |
| Cumulative % | `=prior + cost/$col$2*100` | Running share of statewide spend, absolute-anchored to row 2 |
| Reconciliation | `='Tab'!F2`, `=ROUND(E-D,n)`, `=IF(F=0,"TIE","CHECK")` | Live tie-out; re-evaluates on open |

Cost-per-claim values that were static numbers in the prior workbook are now live
formulas, so every derived figure recomputes in Excel itself.

## 3. Reconciliation result

Reference totals computed once from `part_d_co_clean.csv`:
390,473 rows · $2,737,455,388.61 · 16,573,710 claims · 33,119,594.5 30-day fills ·
19,390 NPIs · 97 specialties · 1,177 generics.

| Check | By_Prescriber | By_Specialty | By_Generic_Drug |
|---|---|---|---|
| Total drug cost | TIE | TIE | TIE |
| Total claims | TIE | TIE | TIE |
| Total 30-day fills | TIE | TIE | TIE |
| Group count | TIE | TIE | TIE |

**12 of 12 TIE. Delta 0.00 on every line. No discrepancy, no number adjusted.**

Verified by recalculating the workbook headless (LibreOffice) and reading the cached
results back — the delivered file carries both the formulas and their evaluated values.
Source row count (390,473) is not summable from an aggregate tab; it is verified
indirectly by the three group counts matching the cleaned file's distinct-entity counts.

## 4. Observations (no action taken)

- At least one prescriber row carries `Total Drug Cost = 0.00` against 11 claims, which
  makes its cost-per-claim and cost-per-30-day-fill both 0.00. Totals still tie. Not
  adjusted, not excluded — logged here only.
- Cumulative % reaches exactly 100.00 on the last row of all three tabs.

## 5. Substitutions from CALIBRATION

None required. Every construct used is on the taught Excel list. No PivotTable was
built — the rollups are pre-aggregated one-row-per-group tables, which is the same
output a PivotTable produces and is what the downstream stages read.

## 6. Open questions

`QUESTIONS.md` unchanged — Q1–Q14 still unresolved. Stage 1 raised none.

---

# Stage 2 — SQL Cost-Percentile Segmentation
**Run:** 2026-08-12, ~19:15–19:35 MDT · **Gate:** PASSED
**Deliverables:** `outputs\capstone_segmentation.sql` · Stage 2 section appended to
`outputs\SQL_RESULTS.md` · `outputs\run_segmentation_sql.py` (runner)

## 1. Gate

| Check | Result |
|---|---|
| `VERIFICATION.md` read | 7 PASS, 1 INCONCLUSIVE, 0 FAIL |
| `CALIBRATION.md` read | SQL taught-construct list applied as the ceiling |
| `PROGRESS.md` read | Stage 1 complete, 12/12 TIE |
| `CAPSTONE_EXCEL_AGGREGATES.xlsx` present | Yes — 2,398,730 bytes, 2026-08-12 19:10 |

Gate passed. Not blocked.

## 2. What was built

`capstone_segmentation.sql` — ten queries, each with a plain-language WHAT/WHY comment
block and inline comments on every CTE. Read-only; no temp tables, no writes.

| # | Level | Query | Rows out |
|---|---|---|---|
| 1 | — | Reconciliation to the Stage 1 workbook | 1 |
| 2 | Prescriber | Cost-per-claim percentile, top-bucket outliers | 25 |
| 3 | Prescriber | Highest total spend + share of statewide dollars | 25 |
| 4 | Specialty | Cost-per-claim quartile, >= 30 prescribers | 46 |
| 5 | Within-specialty | Prescriber cost band inside own specialty | 25 |
| 6 | Within-specialty | Share of specialty spend held by its top band | 46 |
| 7 | Region (city) | City percentiles, 20 largest by spend | 20 |
| 8 | Region (city) | Unit-cost outlier cities, >= 30 prescribers | 15 |
| 9 | Age group | Statewide 65+ vs under-65 split, reported rows | 1 |
| 10 | Age group | Age split by specialty, quartiles per age band | 44 |

Constructs used: `WITH` CTEs · `NTILE()` · `RANK()` · `OVER (PARTITION BY ... ORDER BY ...)` ·
`GROUP BY` / `HAVING` · `INNER JOIN` · scalar and correlated subqueries · `COUNT(DISTINCT)` ·
`SUM` · `ROUND` · `* 1.0` float division. All on the CALIBRATION.md §1 taught list.

## 3. Reconciliation — SQL vs. Stage 1 Excel aggregates

| Measure | Stage 1 workbook | Stage 2 SQL (Query 1) | Delta |
|---|---|---|---|
| Rows | 390,473 | 390,473 | 0 |
| Total drug cost | $2,737,455,388.61 | $2,737,455,388.61 | $0.00 |
| Total claims | 16,573,710 | 16,573,710 | 0 |
| Total 30-day fills | 33,119,594.5 | 33,119,594.5 | 0.0 |
| Distinct prescribers | 19,390 | 19,390 | 0 |
| Distinct specialties | 97 | 97 | 0 |
| Distinct generic drugs | 1,177 | 1,177 | 0 |

**7 of 7 tie. Delta 0 on every line. No discrepancy to report.** Distinct cities (226)
has no Stage 1 counterpart — the `By_City` tab was deliberately not carried into the
Stage 1 workbook — so it is reported without a comparison.

## 4. System of record

The task names the cleaned dataset as system of record. SQL needs a database, so the
queries run against `part_d.sqlite`. Before writing them, `part_d_co_clean.csv` and
`part_d.sqlite` were compared directly:

| Field | Clean CSV | sqlite | Match |
|---|---|---|---|
| Rows | 390,473 | 390,473 | yes |
| Total drug cost | $2,737,455,388.61 | $2,737,455,388.61 | yes |
| Total claims | 16,573,710 | 16,573,710 | yes |
| Total 30-day fills | 33,119,594.5 | 33,119,594.5 | yes |
| Distinct NPI / specialty / generic / city | 19,390 / 97 / 1,177 / 226 | same | yes |
| `cost_per_claim` vs `Tot_Drug_Cst * 1.0 / Tot_Clms` | — | — | 0 mismatches in 390,473 rows |

The two derived columns in the clean CSV are recomputed inline in SQL rather than
reloaded, so no second copy of the data was written. Storage added this stage: 24 KB of
`.sql`, 3 KB of `.py`, 29 KB appended to an existing `.md`. No new database.

## 5. Substitutions from CALIBRATION.md

| # | Wanted | Used instead | Why |
|---|---|---|---|
| S1 | `PERCENTILE_CONT()` | `NTILE()` | Not taught; NTILE is the taught route to percentile buckets |
| S2 | `CAST(x AS REAL)` | `* 1.0` | `CAST` never taught |
| S3 | `CASE WHEN` age labels + `UNION` to stack 65+ / under-65 rows | Age groups as parallel columns on one row | Neither construct taught; same numbers, different shape |
| S4 | `COALESCE` / `NULLIF` zero-denominator guards | `HAVING ... > 0`, or SQL's own NULL | Not taught |
| S5 | `NTILE(100)` everywhere | Bucket count matched to group size — 100 for 19,390 prescribers and 226 cities, 20 within a specialty, 4 for the 46 qualifying specialties and 60 qualifying cities | `NTILE(n)` cannot fill n buckets from fewer than n rows; on 46 specialties "bucket 100" would never exist |

Verified by search: `CASE`, `CAST(`, `COALESCE`, `NULLIF`, `UNION`, `PERCENTILE_CONT`,
and `ROWS BETWEEN` appear nowhere in the file except inside the comment block that
explains their absence.

## 6. Filters applied

| Filter | Where | Effect |
|---|---|---|
| >= 30 distinct prescribers | Queries 4, 5, 6, 10 (specialty) | 46 of 97 specialties qualify |
| >= 30 distinct prescribers | Query 8 (city) | 60 of 226 cities qualify |
| `GE65_Sprsn_Flag = ''` | Queries 9, 10 | 226,277 of 390,473 rows; $1,949,327,500.29 of $2,737,455,388.61 |
| `total_claims > 0` | Queries 2, 5, 6, 7 | 0 rows dropped — no prescriber or city has zero claims |

The >= 30 city guard in Query 8 is an extension of the stated specialty rule to region,
on the same small-cell logic. Noted here rather than treated as new scope; Query 7
reports all 226 cities unfiltered so nothing is hidden.

## 7. Data-quality notes carried, not fixed

- City strings are used exactly as CMS supplied them. QUESTIONS.md Q1 (28 spelling
  variants, 1,856 rows) and Q2 (military installations and neighbourhoods in the city
  field) both remain open and both affect Queries 7 and 8. Nothing was merged.
- The 596 zero-cost rows (Q10 in QUESTIONS.md) are retained, unaltered, as in Stage 1.
- Queries 9 and 10 exclude no rows on a judgment call — they run on the subset where CMS
  reported the 65+ figures at all. Nothing is imputed.

## 8. Open questions

`QUESTIONS.md` — Q1–Q15 all still unresolved. Stage 2 raised no new question, but it
moved **Q9 from hypothetical to live**: the 65+ / under-65 split is now in the analysis,
so the suppressed-cell decision has to be stated before Stage 3 interprets any age
figure. A status line to that effect was appended to `QUESTIONS.md`. **Q11** (395 rows
with 65+ claims but $0.00 of 65+ cost) is live for the same reason.

## 9. Quality check

| Check | Result |
|---|---|
| SQL totals reconcile to Stage 1 Excel | **PASS** — 7/7, delta 0 |
| Script runs start to finish, no manual edits | **PASS** — 10/10 statements executed against `part_d.sqlite`, 0 errors, 0 edits. Executed via `run_segmentation_sql.py`; the `sqlite3` command-line shell was not available in the run environment, so the `sqlite3 db < file` invocation named in the script header is stated but untested. |
| Result tables exported | **PASS** — appended to `SQL_RESULTS.md`; the Stage 0 profiling content above the Stage 2 header was not overwritten or deleted |
| Tables regenerable | **PASS** — `run_segmentation_sql.py` reproduces the appended tables exactly |
| Only taught constructs | **PASS** — 5 substitutions logged in §5 |

No discrepancies. Nothing blocked.

---

# Stage 3 — Statistical Analysis, Charts, Findings

Run 2026-08-12. Status: **COMPLETE**. Nothing blocked.

## 1. Gate

| Requirement | Result |
|---|---|
| `VERIFICATION.md` read | PASS — 7 PASS / 1 INCONCLUSIVE / 0 FAIL |
| `CALIBRATION.md` read | PASS — technique ceiling applied below |
| `PROGRESS.md` read | PASS — Stages 0–2 complete |
| `capstone_segmentation.sql` present | PASS |
| `SQL_RESULTS.md` present | PASS — Stage 2 block appended at line 3586 |

Gate opened. Stage 3 proceeded.

## 2. Deliverables written

| File | Content |
|---|---|
| `capstone_analysis.ipynb` | 31 cells (23 code, 8 markdown). Executed clean-kernel via `nbconvert --execute --inplace`, **exit 0, 0 error outputs**. Every cell carries a plain-language WHAT/WHY comment. |
| `FINDINGS.md` | 5 findings (F1–F5), a ranked priority-segment table, an explicit limits section, and the method-substitution note. |
| `charts/stage3_01` … `stage3_07` | 7 PNGs. |
| `build_nb.py` | The script that generates the notebook. Left in place so the notebook is regenerable; not a submitted deliverable. |

## 3. The statistical step

One step, as specified. **Regression was not used.** `CALIBRATION.md` §2 records
that the curriculum taught no regression beyond `sns.regplot()` — no coefficient
table, no R², no `statsmodels`, no `scikit-learn`. The taught substitute was used:

1. One-way ANOVA (`scipy.stats.f_oneway`) + Kruskal–Wallis (`scipy.stats.kruskal`)
   across specialty (46 groups, n=18,940) and across city (60 groups, n=18,394).
2. Within-specialty percentile ranking — per-specialty `.quantile([.25,.5,.75,.95])`,
   merged back with `.merge()`, prescribers flagged against their own p95.
3. Group comparison on **total cost** (Kruskal–Wallis + Welch `ttest_ind`) — an
   independent measure, deliberately not the variable used to build the flag.

The substitution is stated in `FINDINGS.md` under "Method substitution".

## 4. Substitutions from CALIBRATION.md

| # | Wanted | Used instead | Why |
|---|---|---|---|
| S6 | OLS regression, R² by dimension | ANOVA + Kruskal–Wallis + `groupby().median()` / `.quantile()` group-median dispersion | Regression never taught (B1) |
| S7 | `groupby().transform()` to attach group thresholds | `groupby().quantile()` → `.reset_index()` → `.merge()` | `.transform()` never taught |
| S8 | Pareto chart with cumulative-% line | `sns.barplot` with the concentration figure in the chart title | Pareto never taught (B4) |
| S9 | Log-scale x-axis on skewed distributions | 99th-percentile trim, declared in the chart title with the excluded count named | `set_xscale('log')` never taught (B5) |
| S10 | Raw `ax.boxplot` / `ax.barh` | `sns.boxplot` / `sns.barplot` | Direct taught swaps (B5) |

Imports used: `pandas`, `numpy`, `matplotlib.pyplot`, `seaborn`, `scipy.stats`,
`pathlib`. Nothing outside CALIBRATION.md rule 1.

## 5. Chart count

**7 charts total for the project**, inside the 5–8 budget. The five Stage 0
figures were **moved, not deleted**, to `charts/superseded/` — they are correct
but off-syllabus (Pareto line, `ax.barh`, `ax.fill_between`, log axis, raw
`ax.boxplot`). They are excluded from the deliverable set and must not be used in
the deck or report.

## 6. Quality check

| Check | Result |
|---|---|
| Every figure in FINDINGS.md traces to a notebook cell | **PASS** — cell 29 prints every quoted figure; cell 30 prints the priority table |
| Every method appears in CALIBRATION.md as taught | **PASS** — 5 substitutions logged in §4 |
| Notebook runs top to bottom | **PASS** — 23/23 code cells, 0 errors |
| Reconciles to the verified totals | **PASS** — 390,473 rows / $2,737,455,388.61 / 16,573,710 claims / 19,390 NPIs, all reproduced in cell 3 |
| Derived figures re-checked independently | **PASS** — a separate script recomputed the 965 outliers, $587,147,319.57, 22.1%, 507 clinicians, $317.6M, 54.1%, Urology 53.0%, 51 excluded specialties (2.3% of prescribers / 3.0% of spend), top-20 generics 45.5%. All matched. |
| Interpretation confined to Stage 3 | **PASS** — Stages 0–2 files were appended to, never rewritten |

## 7. Definitional difference carried forward

The notebook flags within-specialty outliers on a strict `cost_per_claim > p95`
test; SQL Query 6 used `NTILE(20)` band 20. The two agree closely but not
exactly — Urology returns 9 prescribers under the notebook rule and 8 under
`NTILE`. Both are correct under their own definition. `FINDINGS.md` states that
the notebook rule governs wherever the two are quoted together. This is a
definitional note, not a discrepancy, and needs one sentence in the report
methodology section.

## 8. Open questions

`QUESTIONS.md` Q1–Q15 all still unresolved. Stage 3 raised no new question and
resolved none. None of them are large enough to move any figure in `FINDINGS.md`;
the relevant ones are named in the limits table there.

## 9. Remaining rubric exposure

R5 (insights and recommendations, 15 pts) is now covered by `FINDINGS.md`.
Still to build: the report (R1/R3/R4), the deck (R2/R8), the Tableau dashboard
(R8), the 1-page recommendation memo, and rehearsal (R6/R7).

---

# STAGE 4 — Slide deck — COMPLETE (2026-08-12)

## 1. Deliverable

`outputs/Edwards_Caleb_Capstone_Deck.pptx` — 14 slides, speaker notes on every
slide. Built with `pptxgenjs`. Validator: **All validations PASSED**.

## 2. Gate

`outputs/FINDINGS.md` present. Gate PASS.

## 3. Slide map and number provenance

Every figure on a slide is copied from `FINDINGS.md`. Nothing was hand-computed
at deck-build time.

| # | Slide | Numbers on it | Source |
|---|---|---|---|
| 1 | Title | — | — |
| 2 | The business problem | $2.74B, 19,390, 1,177 | FINDINGS.md header, F5 |
| 3 | Two ways to build a review list | 19,390 | FINDINGS.md header |
| 4 | Data and preparation | 390,473 / $2.7375B / 16,573,710 / 19,390 / 97 | CLEANING.md Step 10 reconciliation |
| 5 | Metric choice | 58.9%, 0%, median $31.09, mean $193.65 | CLEANING.md Step 6; FINDINGS.md F1 |
| 6 | Methodology (Excel → SQL → Python → Tableau) | 390,473 | Proposal + CALIBRATION.md |
| 7 | F1 — specialty vs city | 11.2×, 1.8×, 46 groups, 60 groups, H = 8,608.94 / 254.96 | FINDINGS.md F1 |
| 8 | F1 continued — specialty spread | $3.89, $2,272, 584× | FINDINGS.md F1 |
| 9 | F4 — unit cost vs volume | −0.011 | FINDINGS.md F4 |
| 10 | F2 / F3 — list overlap | 431 / 498 / 467 / 48%, 965, 5.1%, 22.1% | FINDINGS.md F2, F3 |
| 11 | F5 — concentration | 33.5% / 45.5% / 79.0% / 18.5% / 71.9%, 1.7% | FINDINGS.md F5 |
| 12 | Recommendation | full 8-row priority table, $317.6M, 54%, 507, Urology 53.0% | FINDINGS.md "Recommended priority segments" |
| 13 | Limits | 2.3% / 3.0%, 51 of 97 | FINDINGS.md limits table; CLEANING.md |
| 14 | Next steps | 45.5% | FINDINGS.md F5 |

## 4. Charts used

5 of the 7 Stage 3 figures: `stage3_01` (slide 5), `stage3_05` (7), `stage3_03`
(8), `stage3_07` (9), `stage3_06` (10), `stage3_04` (11). `stage3_02` is not in
the deck — it duplicates `stage3_03`'s message and is reserved for the report.
Nothing from `charts/superseded/` was used. Chart count for the project is
unchanged at 7.

## 5. Talk-track timing

1,889 words of speaker notes across 14 slides.

| Delivery pace | Runtime |
|---|---|
| 145 wpm | 13.0 min |
| 140 wpm | 13.5 min |
| 130 wpm | 14.5 min |

Inside the 10–15 minute window at any realistic pace. Notes are written as
spoken sentences with numbers read out in words where a reader would stumble
("negative zero point zero one one"), so they can be delivered without rehearsal.

## 6. Decisions made without asking (run was unattended)

| # | Decision | Rationale |
|---|---|---|
| D1 | 14 slides, not 12 | Within the 12–14 range specified. The two extra slots go to the framing slide (slide 3) and the limits slide (slide 13), both of which the rubric rewards. |
| D2 | No dedicated Tableau screenshot slide | The dashboard is Stage 5 and does not exist yet. Tableau appears on the methodology slide as the delivery layer. **If Stage 5 produces the dashboard, add a screenshot slide after slide 12** — the deck has room and the notes for slide 12 hand off to it cleanly. |
| D3 | Findings renumbered on the slides (F1→1, F4→2, F2/F3→3, F5→4) | Presentation order is argumentative, not the order of `FINDINGS.md`. The independence result (F4) has to come before the list-overlap result (F2/F3) for the story to land. Underlying labels unchanged in `FINDINGS.md`. |
| D4 | The regression substitution is stated on the methodology slide and in the talk track | An instructor will ask. Better volunteered than defended. |
| D5 | No cost-per-beneficiary anywhere, stated explicitly on slide 5 | Matches the project constraint and pre-empts the obvious question. |

## 7. Quality check

| Check | Result |
|---|---|
| Every slide number traces to FINDINGS.md / CLEANING.md | **PASS** — table in §3 |
| Speaker notes read at 10–15 min | **PASS** — 13.0–14.5 min across the plausible pace range |
| pptx validator | **PASS** — schema, relationships, content types, slides |
| Placeholder-text scan (`lorem`, `TODO`, `[insert`, `xxx`) | **PASS** — no hits |
| Visual QA — all 14 slides rendered and inspected | **PASS** after one fix round: 3 titles shortened to stop two-line wrap crowding the content below, 4 cards shortened to remove dead space, one ambiguous bullet reworded ("Zero values failed to parse" → "No value failed to parse") |
| Charts limited to the Stage 3 set | **PASS** — 6 uses of 5 approved figures, none superseded |

## 8. Open items

- Tableau dashboard (Stage 5) — see D2, deck has a slot for it.
- 1-page recommendation memo — still to build.
- Comprehensive report (Stage 6) — still to build.
- `QUESTIONS.md` Q1–Q15 remain open. Stage 4 raised none and resolved none.

---

# STAGE 5 — Tableau dashboard + recommendation memo

**Status: COMPLETE, with one residual risk (R1 below). 2026-08-12.**

Gate checked before starting: `FINDINGS.md` and `CALIBRATION.md` both present.

## 1. Deliverables written

| File | What it is |
|---|---|
| `Capstone_Dashboard.twbx` | Packaged Tableau workbook — 3 worksheets + 1 dashboard, CSV extract inside |
| `RECOMMENDATION_MEMO.docx` | 1 page, addressed to a health-system population health team |
| `tableau_prescriber_segments.csv` | The extract, also written standalone — see R1 |
| `build_tableau_extract.py` | Rebuilds the extract from `part_d_co_clean.csv` |
| `build_recommendation_memo.py` | Rebuilds the memo |

## 2. Dashboard contents

Data: one row per prescriber, 18,940 rows across the 46 specialties with >= 30
prescribers. Built by re-running the Stage 3 rules against `part_d_co_clean.csv`,
not by re-deriving them. Reconciliation printed by `build_tableau_extract.py`:

| Check | Expected (FINDINGS.md) | Produced |
|---|---|---|
| Qualifying prescribers | 18,940 | 18,940 |
| Qualifying specialties | 46 | 46 |
| Within-specialty outliers | 965 | 965 |
| Outlier spend | $587,147,319.57 | $587,147,319.57 |
| Top-8 priority table | 8 rows, all figures | exact match, all 8 rows |

| Sheet | Type | Shows |
|---|---|---|
| Priority Segments | horizontal bar, sorted desc | Flagged spend by specialty, top 8 |
| Unit Cost by Segment | horizontal bar, sorted desc | Weighted cost per claim, same 8 |
| Prescriber Scatter | scatter, coloured by flag | Claims vs cost per claim, one mark per prescriber |

Dashboard `CO Part D Review Priorities` — fixed 1250x850, title, two bars on the
top row, scatter across the bottom, plus one filter action (select a bar in
Priority Segments, the other two sheets filter).

## 3. Techniques used, against CALIBRATION.md §3

| Used | Taught? |
|---|---|
| Calculated fields (2, both ratio-of-sums aggregates) | Yes — Tableau Intro I–II |
| Categorical filter (Priority Group) | Yes |
| Quantitative range filter (cost per claim <= $2,000) | Yes |
| Computed sort by a measure | Yes |
| Colour encoding on a dimension | Yes |
| Bar chart, scatter plot, dashboard, dashboard action | Yes — all four named in CALIBRATION §3 |

Nothing on the Tableau NOT-taught list was used: no reference lines, no trend
lines, no forecasting, no treemaps, no packed bubbles, no dual axis, no LOD.

**Substitution (preference-level, taken without asking):** the scatter's y-axis is
trimmed at $2,000 per claim with a range filter rather than log-scaled, because
log axes are on the NOT-taught list. The trim is stated in the sheet title.

**Chart count unaffected.** The project's 7-figure budget covers the Stage 3 PNGs.
The dashboard is Stage 5's own deliverable and renders from the same data; it adds
no new PNG to `charts/`.

## 4. Memo

One page, US Letter, verified by rendering to PDF and inspecting the page image
(2 pages on the first build; tightened to 1). Every figure in it appears in
`FINDINGS.md` — checked programmatically across 16 headline numbers and all 18
figures in the priority table, 0 mismatches. Closes with the "statistical outlier,
not a finding of waste" limitation, carried over verbatim in substance from the
FINDINGS.md limits table.

## 5. Deck chart swap — NOT DONE, and why

The task allowed exporting a dashboard chart if it beat a deck chart. No swap was
made: Tableau cannot be rendered headlessly in this environment, so there is no
image to compare against `stage3_03` or `stage3_06` and no basis for calling one
better. The deck is untouched. Slide D2 in the Stage 4 log still stands — if Caleb
opens the workbook and likes a view, a screenshot slide goes after slide 12.

## 6. Decisions made without asking (run was unattended)

| # | Decision | Rationale |
|---|---|---|
| D6 | Dashboard built on a prescriber-level CSV, not on `part_d.sqlite` or the raw file | Storage constraint. 2.4 MB extract instead of a 60 MB database inside the twbx, and Tableau binds a packaged CSV without a driver. |
| D7 | Extract covers all 46 qualifying specialties, not just the top 8 | Same file size either way, and it lets the filter be changed live if an instructor asks "what about X?". Sheets are filtered to the top 8. |
| D8 | `Outlier Cost` pre-split into its own column in the CSV | Lets the dashboard use a plain `SUM()` instead of an `IF` inside an aggregate. Simpler to explain live. |
| D9 | Memo dated 2026-08-12, addressed to a generic "Population Health Leadership Team" | No real recipient was specified. |
| D10 | `.twb` hand-authored as XML rather than clicked together in Tableau | Tableau Desktop is not available in this environment. See R1. |

## 7. Quality check

| Check | Result |
|---|---|
| Gate — FINDINGS.md and CALIBRATION.md present | **PASS** |
| Extract reconciles to FINDINGS.md | **PASS** — 5 of 5 checks exact, including the full 8-row priority table |
| `.twb` XML well-formed | **PASS** — parses clean |
| `.twbx` zip integrity | **PASS** — `unzip -t`, no errors |
| `.twb` connection path resolves inside the archive | **PASS** — `Data/co_part_d/co_prescriber_segments.csv` present |
| CSV header matches the declared relation columns | **PASS** — 13 of 13, in order |
| Techniques within CALIBRATION §3 | **PASS** — table in §3 above |
| Memo fits one page | **PASS** — rendered and inspected |
| Memo figures trace to FINDINGS.md | **PASS** — 16 headline figures + 18 table figures, 0 mismatches |
| **Dashboard renders correctly in Tableau Desktop** | **UNVERIFIED — see R1** |

## 8. Residual risk

**R1 — the `.twbx` has not been opened in Tableau.** Tableau Desktop does not run
in this environment, so the workbook is verified as a well-formed archive and as
valid XML against the structure of Caleb's own submitted
`Tableau Hospital ER Insights.twbx`, but not as a rendered dashboard. A hand-written
`.twb` can parse cleanly and still fail to lay out.

**Mitigation, and what to do first thing:** open `Capstone_Dashboard.twbx`. Budget
ten minutes.

- If it opens — check the three sheets look right and save from Tableau once. That
  rewrites the file in Tableau's own hand and removes the risk permanently.
- If it does not open — `tableau_prescriber_segments.csv` is in `outputs\` as a
  standalone file. Connect Tableau to it directly and rebuild: three sheets, each
  filtered to `Priority Group = "Top 8 priority segment"`. Two bars (`Specialty` vs
  `SUM(Outlier Cost)`; `Specialty` vs `SUM(Total Cost)/SUM(Total Claims)`) and one
  scatter (`SUM(Total Claims)` vs `SUM(Cost Per Claim)`, `NPI` on Detail,
  `Outlier Status` on Colour). That is the whole workbook, and it is faster to
  rebuild than to debug.

## 9. Open items

- Comprehensive report (Stage 6) — still to build.
- Deck screenshot slide for the dashboard — blocked on R1, see §5.
- `QUESTIONS.md` Q1–Q15 remain open. Stage 5 raised none and resolved none.

---

# STAGE 6 — Comprehensive analytics report — COMPLETE (2026-08-12)

**Gate:** `FINDINGS.md` present, `Edwards_Caleb_Capstone_Deck.pptx` present. **PASS.**

## 1. Deliverable

`outputs\Edwards_Caleb_Capstone_Report.docx` — 9 pages: **7 pages of report body**
(sections 1–6) plus a 2-page artifacts appendix. US Letter, Calibri, navy/grey to
match `RECOMMENDATION_MEMO.docx`. Built by `build_report.py`, which is in `outputs\`
and reruns from `charts\` and the figures in `FINDINGS.md`.

| Section | Pages | Rubric line it serves |
|---|---|---|
| Summary + 1. The business question | 1–2 | R3 |
| 2. Data collection and preparation | 2–3 | R1, R4 |
| 3. Methodology | 3–4 | R4 |
| 4. Key findings (F1–F4, 2 figures, 4 tables) | 4–6 | R1, R5 |
| 5. Recommendations and next steps | 6–7 | R5 |
| 6. Limitations | 7 | R4, R5 |
| Appendix — Artifacts | 8–9 | R1 (artifact inclusion) |

## 2. Consistency with the deck

No new claim appears in the report. Every finding, figure, and recommendation is the
deck's, in prose: the two-option framing (deck slide 3), the cost-per-claim decision
(slide 5), the four-tool pipeline and regression substitution (slide 6), F1 (slides
7–8), F4 correlation (slide 9), F2/F3 (slide 10), F5 concentration (slide 11), the
507-clinician cohort and Urology second tier (slide 12), the limits (slide 13), and
the four next steps (slide 14).

Findings are renumbered for reading order in the report (report Finding 2 =
FINDINGS.md F4, report Finding 3 = F2 + F3, report Finding 4 = F5). The underlying
numbers are unchanged; FINDINGS.md remains the record.

## 3. Verification

| Check | Result |
|---|---|
| Rendered to PDF and inspected page by page | **PASS** — 9 pages, no orphaned headings, no clipped tables, both figures sized inside margins |
| Numeric trace — every number in the report exists in FINDINGS.md / CLEANING.md | **PASS** — 129 distinct numeric tokens extracted from the rendered PDF; 121 match verbatim, the 8 non-matches are `p < 0.001` (a threshold statement, true given p < 1e-300), fragments of `3.0e-145` and `1e-300` split by the tokenizer, chart-filename suffixes (`stage3_01.`, `stage3_04.`, `stage3_06.`, `stage3_07.`), and `2023` in a forward-looking next step. **Zero unsupported figures.** |
| Appendix lists every file in `outputs\` | **PASS** — all 40 files plus `charts\` and `charts\superseded\`, checked against a directory listing after the report was written |
| Techniques described match what was actually run | **PASS** — ANOVA, Kruskal–Wallis, `groupby`/`quantile`/`merge`, `NTILE()`, seaborn; nothing claimed that CALIBRATION.md lists as BEYOND |
| Nothing modified in the project folder root | **PASS** |

## 4. Rubric coverage check against REQUIREMENTS.md

| # | Rubric line | Pts | Artifact | Status |
|---|---|---|---|---|
| R1 | Submission — report + artifacts | 25 | `Edwards_Caleb_Capstone_Report.docx` with all five required sections, plus `CLEANING.md`, `STATS_OUTPUT.md`, `SQL_RESULTS.md`, `PY_RESULTS.md`, `CAPSTONE_EXCEL_AGGREGATES.xlsx`, `part_d_profiling.sql`, `capstone_segmentation.sql`, `capstone_analysis.ipynb`, `charts\` — all named and described in the appendix | **COVERED** |
| R2 | Submission — slide deck | 25 | `Edwards_Caleb_Capstone_Deck.pptx` — 14 slides, full speaker notes, 6 embedded charts | **COVERED** |
| R3 | Problem definition and data approach | 15 | Report §1 (business question, the A/B framing, real-world application) and §2 (source, scope, why this file) | **COVERED** |
| R4 | Methodology and rigor | 20 | Report §3 + `CLEANING.md` (10 steps, row counts) + `capstone_segmentation.sql` + `capstone_analysis.ipynb` (23 cells, clean-kernel, 0 errors). Substitution from regression to ANOVA / Kruskal–Wallis stated openly in §3 and in FINDINGS.md | **COVERED** |
| R5 | Insights and recommendations | 15 | Report §4 (four findings) and §5 (507-clinician cohort, Urology second tier, three deprioritized specialties, four next steps) + `RECOMMENDATION_MEMO.docx` | **COVERED** — was the largest gap at Stage 0; now closed |
| R6 | Live delivery content | 15 | Speaker notes on all 14 slides, written for a no-prior-knowledge audience | **FILE-COMPLETE — needs rehearsal** |
| R7 | Delivery, pace, professionalism | 10 | Not a file | **CALEB — rehearse** |
| R8 | Visual design and data visualization | 5 | 7-chart set, 6 in the deck, 2 in the report, plus `Capstone_Dashboard.twbx` | **COVERED, with R1 risk below** |

All four proposal-committed deliverables exist: Excel aggregates, commented SQL with
percentile window functions, Python notebook answering "which dimension drives cost",
Tableau dashboard plus one-page memo.

## 5. Open items carried out of Stage 6

1. **`Capstone_Dashboard.twbx` has never been opened in Tableau Desktop** (Stage 5 R1,
   unchanged). Open it first thing; budget ten minutes. Rebuild instructions and the
   standalone CSV are in the Stage 5 entry above.
2. **Rehearse the deck** — R6 and R7 are 25 of 130 points and no file can earn them.
3. **`QUESTIONS.md` Q1–Q15 remain open.** Stage 6 raised none and resolved none. The
   report states them as limitations rather than resolving them.

**Stage 6 complete. All file-based deliverables built.**

---

# STAGE 7 — Validation pass, corrections, and submission packaging — COMPLETE (2026-08-13)

**Gate:** all Stage 6 deliverables present. **PASS.**

## 1. What was done

Three things, in order: assembled `outputs\Final Deliverables\` as the graded subset;
ran a pre-submission QA pass against the report, FINDINGS.md, QUESTIONS.md and CMS's
published documentation; applied the five corrections that pass surfaced and rebuilt
every affected file.

## 2. Validation result — `outputs\VALIDATION_REPORT.md`

**20 of 20 calculation spot-checks tie.** No numeric error anywhere. Strongest single
check: "51 excluded specialties = 3.0% of spend" falls out of the F3 group totals
against the $2.74B state total independently, and agrees to 0.004 percentage points.

Five text-level issues found, all now fixed:

| # | Severity | Issue | Fix |
|---|---|---|---|
| 1 | HIGH | "Cost is plan-paid, not net" is factually wrong — CMS states total drug cost includes amounts paid by Medicare, **beneficiaries** and third-party payers | Rewritten as "Cost is gross, not net" with the full component list, in report §6, deck slide 13 + notes 13, and the memo |
| 2 | MED-HIGH | F1 quotes a $2,272.07 max specialty cost per claim (prescriber-level median); §5 quotes Hem-Onc at $2,652 (specialty-weighted). Two constructs, undistinguished | Both labeled: report §5 caption + table header, deck slide 12 header/footnote/notes |
| 3 | MEDIUM | Column "Dollars above own p95" reads as excess-over-threshold; it is total drug cost of flagged prescribers. Confirmed by RECOMMENDATION_MEMO.docx, which already defined it correctly as "Spend flagged" | Renamed to "Spend flagged" in FINDINGS.md, report table + §5 intro, deck slide 12 |
| 4 | MEDIUM | "Geography is off the table" overreaches — tested on 60 un-normalized CMS city strings (Q1), and city is not the region promised in the proposal (Q3) | Narrowed to city-level with both qualifications named, in report §4 and deck slide 7 footnote + notes |
| 5 | MEDIUM | Proposal goal 5 (under-65 vs 65+) built in `capstone_segmentation.sql` Q9/Q10 but absent from findings | Stated in report §6 and slide 13 source line: 42.1% suppression, Q9 left undecided rather than defaulted |

Bias review cleared circular segmentation (F3 tests total cost, not the flag variable),
average-of-averages, and significance-mistaken-for-importance. One live item logged for
the viva: the top-4 cohort is also the four largest specialties, because a 5%-per-
specialty rule scales with size.

## 3. Verification of the corrections

| Check | Result |
|---|---|
| Deck — `validate.py --original` | **PASS**, all validations |
| Deck — media parts vs original | **PASS** — 6 of 6 images byte-identical; only the empty `ppt/media/` directory entry differs (zip recompression) |
| Deck — slides / notes | **PASS** — 14 / 14, unchanged |
| Deck — slides 7, 12, 13 rendered and inspected | **PASS** — no overflow, no clipping, footnotes on one line |
| Report — numeric diff vs pre-correction PDF | **PASS** — zero numbers removed; three added (`28`, `42.1%`, `71%`), all intentional |
| Report — rendered page by page | **PASS** — 10 pages (was 9; the 65+ bullet added one), bold lead-in preserved on every limitation bullet |
| Memo — page count | **PASS** — 1 page. First correction wording pushed it to 2; shortened to "gross, not net of rebates" and re-verified |
| All 20 edits landed | **PASS** — 0 misses |

## 4. Deliverable folders

`outputs\Presentation\` — corrected deck + `PRESENTATION_NOTES.md` (timed 12-minute talk
track, slide-by-slide, 8 anticipated questions with answers).

`outputs\Final Deliverables\` — 31 files, the graded subset, with `00_START_HERE.md` as
the index. `outputs\Edwards_Caleb_Capstone_Submission.zip` mirrors it for single-file
upload. Corrected report, deck, memo and FINDINGS.md were written to `outputs\` and to
`Final Deliverables\` so both copies match.

## 5. Open items carried out of Stage 7

1. **`Capstone_Dashboard.twbx` has still never been opened in Tableau Desktop** (Stage 5
   R1, unchanged). Open it, save once from Tableau. Ten minutes.
2. **Rehearse the deck** — R6 + R7 are 25 of 130 points and no file earns them.
3. **`QUESTIONS.md` Q1–Q15 remain open.** Stage 7 resolved none and raised none; Q1, Q3
   and Q9 are now explicitly named in the report and deck as stated limitations.

**Stage 7 complete.**

---

# STAGE 8 — Tableau rebuild, deck slide 13, consistency + voice pass — COMPLETE (2026-08-13)

## 1. Tableau — Stage 5 R1 resolved

The hand-authored `Capstone_Dashboard.twbx` failed to load in Tableau Desktop. Two
schema faults were found and fixed (`<computed-sort>` is not a schema element — the
correct form is `<sort class='computed'>`; `<actions>` must precede `<worksheets>`), the
XML then parsed clean, and Tableau still refused it with a non-diagnostic internal error
(501CF476). At that point the file was abandoned rather than debugged further.

Caleb rebuilt the workbook in Tableau Desktop from `tableau_prescriber_segments.csv` and
saved it as **`CO Medicare Part D Dashboard.twbx`**, plus a static export
`CO Part D Review Priorities.pdf`. Verified against FINDINGS.md from the PDF: Priority
Segments sorts NP → Cardiology on flagged spend, Unit Cost by Segment sorts
Hematology-Oncology (~$2,652) → Family Practice ($73) on the weighted ratio. Both tie.

**Lesson for the record:** a hand-written `.twb` can be well-formed XML, pass an
archive-integrity check, and still not open. Only Tableau Desktop can verify a Tableau
workbook.

## 2. Deck — new slide 13

Cloned from slide 8's layout, so the design is unchanged. Contains a cropped screenshot
of the rebuilt dashboard, a `1st vs 6th` stat panel (Nurse Practitioner ranks first on
flagged spend and sixth on unit cost; Hematology-Oncology is fifth and first), and full
speaker notes. Deck is now **15 slides, 7 images, notes on all 15**; Limits moved to 14
and Next Steps to 15.

This closes the gap where the proposal promised a Tableau layer and the deck showed only
seaborn output. Six of the seven deck images are still Python; the dashboard is the
seventh.

## 3. Cross-document consistency check

Scripted comparison of every numeric token across report, deck, notes and memo against
FINDINGS.md.

| Check | Result |
|---|---|
| `plan-paid` remaining anywhere | **0** |
| `Dollars above own p95` remaining anywhere | **0** |
| Stale `Capstone_Dashboard` references | **0** — report appendix, START_HERE and notes all renamed |
| `gross, not net` present | all four documents |
| Headline figures (507, $317.6M, 965, 467, 22.1%, 45.5%, $2,652, −0.011, $2,272, 58.9%) | present and identical wherever quoted |
| Unexplained numeric tokens | none — residue is tokenizer noise (chart filename suffixes, timing-table minutes, spoken roundings in the notes) |

## 4. Report voice pass

Thirteen prose edits, no figures touched. Mostly contractions in first-person sentences
plus five stiff constructions loosened. Verified by numeric diff against the pre-edit
render: **zero numbers lost**, three added earlier in Stage 7 (`28`, `42.1%`, `71%`).
Report holds at 10 pages.

## 5. Open items

1. `Final Deliverables\Edwards_Caleb_Capstone_Deck.pptx` was locked by PowerPoint at
   commit time and still holds the 14-slide version. Close PowerPoint, recopy from
   `outputs\`, rebuild the zip.
2. Rehearse. R6 + R7 are 25 of 130 points.
3. QUESTIONS.md Q1–Q15 remain open; Q1, Q3, Q9 are named in the report and deck.

**Stage 8 complete.**
