# SQL Profiling Flags

Everything in this file needs a human decision before or during downstream (Python
notebook) work. `SQL_RESULTS.md` is fully usable without reading this file --
nothing here is required to interpret the numbers there.

## Data quality issues

- **Suppressed GE65 fields.** `Tot_Benes` is blank (empty string) in 58.9% of rows,
  `GE65_Tot_Benes` in 86.3%, and `GE65_Tot_Clms` / `GE65_Tot_30day_Fills` /
  `GE65_Tot_Drug_Cst` / `GE65_Tot_Day_Suply` in 42.1% -- consistent with CMS's
  documented policy of suppressing beneficiary counts under 11 for privacy. This is
  not missing data in the usual sense; it's a censoring mechanism tied to
  `GE65_Sprsn_Flag` (`*` = claim-count suppressed, `#` = a related field
  suppressed) and `GE65_Bene_Sprsn_Flag`. Any mean/median/percentile/stddev
  computed on these columns (Section 2) is computed only over the *non-suppressed*
  rows -- it is not representative of the full population and will understate
  true totals if summed naively.
- **No true SQL NULLs anywhere in the table** (Section 1.5, all zero). All
  "missingness" in the source CSV is the empty string, not NULL. Any downstream
  tooling that filters on `IS NULL` (e.g. pandas after a naive load, or a BI tool
  defaulting to NULL-aware aggregates) will silently treat these blanks as present
  unless explicitly checked for `''` as well. Flag for the Python notebook: decide
  whether to coerce `''` to `NaN`/`NULL` on load there.
- **Mode on continuous cost fields is close to meaningless.** `Tot_Drug_Cst` and
  similar dollar fields are effectively continuous; the "mode" reported in
  Section 2 is just the single most-repeated exact value (e.g. ties at low-cost,
  low-claim generics) and is not a useful central-tendency statistic for these
  columns. Kept in the output only because the task spec asked for mode on all
  numerics.
- **Data is at the NPI x drug grain, not the NPI grain.** A prescriber (NPI) can
  and typically does appear across many rows (one per drug). Distinct NPI count
  (19,390) is far below the row count (390,473) for this reason -- this is
  expected grain, not a duplication problem, but any per-provider analysis needs
  a GROUP BY NPI first.

## Foreseeable transformations (not performed here, per constraints)

- **City-to-region lookup.** `Prscrbr_City` has 226 distinct free-text values with
  no standardized region/MSA/county grouping. A city-to-region (or city-to-county)
  lookup table would be needed for any regional roll-up. Not built here.
- **Type coercion on load.** The loader (`load_part_d.py`) stores numeric columns
  with SQLite `REAL` affinity but leaves blanks as the literal empty string (by
  design, to preserve the NULL-vs-blank distinction above). A downstream tool
  will need its own explicit coercion step (e.g. `pd.to_numeric(..., errors=
  'coerce')` in pandas) rather than relying on SQLite affinity.
- **NPI deduplication / provider-level rollup.** No deduplication was performed.
  If the notebook needs one row per provider, an explicit `GROUP BY Prscrbr_NPI`
  aggregation step will be needed, with a decision about how to combine
  `Prscrbr_Type` if a single NPI reports more than one specialty across rows
  (not checked here).
- **Brand vs. generic name reconciliation.** `Brnd_Name` and `Gnrc_Name` are both
  present and not the same cardinality; some rows have `Brnd_Name == Gnrc_Name`
  (unbranded/generic-only). No mapping or dedup between brand and generic was
  built here.

## Ambiguities / judgment calls made during this profiling pass

- **Bivariate scope ("distribution shape only").** The task asked for cost/claims
  cross-cut by specialty x city, specialty x generic, and city x generic, with
  "distribution shape only." A full enumeration of every populated combination
  would run into the tens of thousands of rows for some pairs (e.g. up to
  266,502 possible city x generic combinations), which is impractical to embed
  as a markdown table and arguably not "shape." This pass therefore produced,
  per pair: (a) a 20-row sample of the top combinations by total drug cost (for
  concreteness), and (b) group-level distribution-shape statistics (n groups,
  min/max/mean/median/stddev/p25/p75/p90/p99 of the per-group totals) as the
  primary deliverable. **Decision needed:** confirm this interpretation is what's
  wanted, or specify a different cut (e.g. full crosstab exported to CSV instead
  of markdown) if the notebook needs the complete combination-level detail.
- **Percentile method.** Percentiles (25/50/75/90/99th) use the nearest-rank
  method (`rank = CEIL(p * n)`, no interpolation) rather than linear
  interpolation. This is a standard, defensible choice for descriptive
  statistics, but it will produce slightly different values than
  `numpy.percentile`'s default (linear interpolation) or pandas' `.quantile()`.
  Flag so the Python notebook's percentile method is chosen consistently (or the
  discrepancy is expected and documented).
- **Sample stddev, not population stddev.** Section 2 stddev values use the
  sample formula (`n-1` denominator). If population stddev is expected instead,
  this needs to be changed.
- **Numeric univariate scope.** All 10 numeric columns (`Tot_Clms`,
  `Tot_30day_Fills`, `Tot_Day_Suply`, `Tot_Drug_Cst`, `Tot_Benes`, and their
  `GE65_*` counterparts) were profiled. The task did not name specific columns,
  so this list was inferred from the schema; confirm it's the intended scope.
- **Categorical univariate scope.** `Prscrbr_State_Abrvtn`, `Prscrbr_City`,
  `Prscrbr_Type`, `Prscrbr_Type_Src`, `Brnd_Name`, `Gnrc_Name`,
  `GE65_Sprsn_Flag`, and `GE65_Bene_Sprsn_Flag` were profiled as categoricals.
  `Prscrbr_NPI`, `Prscrbr_Last_Org_Name`, `Prscrbr_First_Name`, and
  `Prscrbr_State_FIPS` were excluded from full frequency tables (NPI and name
  fields are identifiers, not analytic categories; `Prscrbr_State_FIPS` is
  redundant with `Prscrbr_State_Abrvtn`, already confirmed CO-only in Section 1).
  Confirm this exclusion is acceptable.
