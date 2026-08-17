# PY_FLAGS — Medicare Part D, Colorado 2024

Companion to `PY_RESULTS.md`. Nothing here is needed to read the results tables.
Sections: data quality, foreseeable transformations (flagged, not built),
model-specification concerns, ambiguities and the choices made, and
interpretation that entered the work.

## 1. Data quality

- **CMS suppression sets a floor on what is visible.** Every row in the file has
  `Tot_Clms` >= 11, the CMS cell-suppression threshold, and the minimum
  `Tot_30day_Fills` in the file is likewise 11. Prescriber-drug combinations below
  that threshold are absent entirely. Prescriber totals computed here are
  therefore totals over reported rows, not the prescriber's true totals, and the
  gap is larger for prescribers whose volume is spread thinly across many drugs.
  Both primary metrics inherit this.
- **Beneficiary columns are unusable as denominators.** `Tot_Benes` is blank in
  58.9% of rows, `GE65_Tot_Benes` in 86.3%, and the GE65 claim/cost/fill columns
  in 42.1%. The blanks are suppression, not missingness at random. No metric here
  uses them; cost-per-beneficiary is not computed anywhere in this notebook.
- **596 rows report `Tot_Drug_Cst` = 0** with non-zero claims,
  giving cost-per-claim of exactly 0. No negative costs appear. These rows were
  retained unaltered, per the no-cleaning constraint. They sit at the outcome's
  lower bound in the regression and pull the low tail of the outlier screen.
  Prescribers whose total drug cost is 0 after aggregation: 1.
- **Specialty labels come from three different sources** (`Prscrbr_Type_Src`):
  - `Claim-Specialty`: 344,460 rows (88.2%)
  - `NPPES-Specialty`: 40,016 rows (10.2%)
  - `NPPES-Taxonomy`: 5,997 rows (1.5%)
  The label is not uniformly derived, so peer groups mix claim-derived and
  registry-derived specialty assignments. `Prscrbr_Type_Src` is carried into
  `outliers.csv` so the mix is visible per prescriber.
- **City is the free-text value as filed** (226 distinct values). No
  normalization, deduplication, or geocoding was applied, and the level set
  contains pairs that look like spellings of the same place, each carried as its
  own regression level:
  - `Colorado Springs` (40,743 rows) and `Colo Springs` (9 rows)
  - `Lone Tree` (7,285 rows) and `Lone Treet` (65 rows)
  - `Greeley` (9,508 rows) and `Greely` (6 rows)
  - `Haxtun` (36 rows) and `Haxton` (64 rows)
  - `Wheat Ridge` (8,294 rows) and `Wheatridge` (63 rows)
  - `Greenwood Village` (4,176 rows) and `Greenwood Vlg` (8 rows)
  Reading each pair as one place is an inference, not something the file states;
  it is repeated under Section 5. The low-count spelling in each pair also
  produces a coefficient fit to very few rows.
- **Many levels are supported by very few rows.** Counting levels with 2 or fewer
  rows: 251 of 1,177 generic drugs
  (347 rows), 24 of 226
  cities (30 rows), 8 of
  97 specialties (13 rows).
  Coefficients on those levels are fit to a handful of observations and are not
  stable quantities. `n_obs_at_level` is in `regression_output.csv` for every
  level so they can be screened out.
- **Generic name does not encode strength, dosage form, or route.** 1,177
  distinct `Gnrc_Name` values cover multiple strengths and formulations of the
  same molecule, which vary widely in cost per claim. The file has no NDC-level
  detail to separate them.
- **Each NPI maps to exactly one specialty and one city in this file**
  (asserted in the notebook), so the prescriber-level carry-forward of those
  labels is lossless.
- Aggregation to prescriber level preserves the cost total exactly:
  $2,737,455,388.61 before, $2,737,455,388.61 after.

## 2. Transformations foreseeable at capstone time (flagged, not built)

Per the no-transformation constraint, none of these were applied.

- **Log or Box-Cox transform of cost-per-claim.** The row-level outcome runs from
  0 to $136,922.29 with a median of $14.00. A level-scale OLS is fit here
  as specified; a log-scale fit is the conventional treatment and would change
  both the coefficients and the R-squared. The 596 zero-cost rows
  would need an offset or an explicit exclusion rule first.
- **Claim-weighted estimation.** The regression is unweighted, so an 11-claim row
  and a 50,000-claim row count equally. Weighting by `Tot_Clms` is the natural
  alternative and would change every coefficient.
- **Winsorizing or trimming the extreme tail** of both metrics before fitting.
- **City-name normalization.** The apparent spelling variants listed in Section 1
  would be merged before any city-level modelling. Not done here.
- **Collapsing rare levels.** Many cities and generics appear in very few rows;
  pooling them into an `Other` category would cut the parameter count and the
  overfitting risk. Level counts are in `regression_output.csv`.
- **Brand-versus-generic indicator.** `Brnd_Name` and `Gnrc_Name` are both
  present and their relationship is not encoded as a variable anywhere here.
- **Days-supply normalization.** `Tot_Day_Suply` was not loaded or used; a
  cost-per-day-supply metric is available in the source and was not built.
- **Specialty label reconciliation** across the three `Prscrbr_Type_Src` values.

## 3. Model-specification concerns

- **Errors are not independent.** A prescriber contributes many rows (median
  7) and each drug appears across many
  prescribers. No clustered, robust, or panel-corrected standard errors were
  computed. This is the single largest specification problem with the model.
- **No standard errors, t-statistics, or p-values are reported at all.** The
  1,498-parameter design was fit by alternating projections, which yields point
  estimates without `(X'X)^-1`; a sparse linear-algebra library is not available
  in this environment. Every coefficient in `regression_output.csv` is a point
  estimate with no reported uncertainty, and none should be read as significant
  or not significant.
- **Heteroskedasticity is near-certain** given the outcome's skew, and is not
  addressed.
- **Main effects only.** The model assumes a specialty shifts cost-per-claim by
  the same dollar amount regardless of drug or city. Interactions are not fit.
- **R-squared rises mechanically with level count.** The generic-drug factor has
  1,177 levels against 226 cities and 97 specialties, so part of its advantage in
  Table 8 is a degrees-of-freedom artifact. Adjusted R-squared is reported next
  to it for that reason; with n = 390,473 the adjustment is small.
- **The three dimensions overlap**, so the single-dimension R-squareds do not
  partition the variance and their sum exceeds the full-model R-squared by
  0.088846. Incremental R-squared is reported alongside for this reason;
  neither measure alone is a clean attribution.
- **The outcome is bounded below at 0** and 596 observations are
  at the bound, which a linear model does not respect.
- **No causal identification is attempted or possible here.** The coefficients
  are conditional mean differences within this file. Nothing is controlled for
  beyond the three categorical dimensions, and patient case-mix, which plainly
  drives drug choice, is not observed in this dataset at all.
- **Two different units of analysis appear in this notebook.** The outlier screen
  is prescriber-level (18,940 rows); the regression is
  prescriber-drug-row-level (390,473 rows). Results from the two sections are
  not directly comparable.

## 4. Ambiguities and the choices made

- **"Cost-per-claim as outcome" is unit-ambiguous.** It could mean the
  prescriber-level ratio or the row-level ratio. Row level was chosen because
  generic drug is a row-level attribute and cannot enter a prescriber-level
  model. Consequence: the regression is fit on a different unit than the outlier
  screen.
- **"Variance-explained comparison" is not a single defined quantity** when
  predictors are correlated. Two measures are reported (single-dimension
  R-squared and incremental R-squared) rather than picking one. They agree on the
  ranking in this run.
- **The >= 30 prescribers restriction was applied at prescriber level** after
  aggregation, which yields 46 specialties as the brief states. Applying it to
  row counts would give a different set.
- **Prescriber metrics were built as summed-cost over summed-denominator**, not
  as the mean of that prescriber's row-level ratios. The two differ; the former
  is claim-weighted and preserves the cost total.
- **Both tails are flagged** by the outlier rule. The brief did not specify a
  direction, so high and low are flagged separately and reported separately.
- **Percentile ranks use average ranking for ties** (pandas default) and are
  expressed 0-100 within specialty.
- **Reference levels for the regression are the first level alphabetically** in
  each dimension, which is arbitrary. Coefficients are differences versus those
  levels and change meaning entirely if the reference changes; the reference
  levels are marked in `regression_output.csv`.
- **`part_d.sqlite` and `load_part_d.py` already in `outputs/` were not read or
  used.** This notebook reads the raw CSV only.

## 5. Interpretation that entered the work, labeled as such

The brief restricts output to calculations. These are the points where judgment,
not arithmetic, determined a result. They are listed here and kept out of
`PY_RESULTS.md`.

- **Choosing IQR fences over a z-score rule is a judgment**, made because both
  metric distributions are strongly right-skewed and heavy-tailed, so the mean
  and standard deviation a z-rule depends on are themselves inflated by the
  values being screened for. That reasoning is an interpretation of the observed
  distribution shape, not a result derived from it. The 1.5 multiplier is
  convention, not an estimate, and a different multiplier gives a different
  flagged set.
- **"Outlier" is a statistical label only.** A flag in `outliers.csv` means a
  prescriber's metric fell outside the fences for their specialty. It carries no
  claim about appropriateness, quality, or anything else, and the notebook makes
  no such claim.
- **Choosing the prescriber-drug row as the regression unit** is a modeling
  judgment (see Section 4), not something the data determined.
- **The three dimensions overlap for substantive reasons**, e.g. specialty and
  drug choice are related by clinical practice. That statement is interpretation;
  what the notebook actually computes is the numerical overlap of
  0.088846 in Table 8.
- **Describing the outcome's distribution as "strongly skewed"** is a
  characterization; the underlying numbers (skew and kurtosis) are in
  `PY_RESULTS.md` Table 2.
- **Calling the city pairs in Section 1 spelling variants of one place is an
  inference.** What the file contains is distinct string values; nothing in it
  says they refer to the same municipality. No merge was performed on that basis.
