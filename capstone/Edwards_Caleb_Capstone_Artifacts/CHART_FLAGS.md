# Chart Generation Flags

Notes on ambiguous specifications and the choices made to resolve them while generating charts in `outputs/charts/`.

1. **Chart 1 (Pareto/cost concentration):** Rendered as a single cumulative-% line on a log-scaled rank axis rather than a classic dual-axis Pareto (bars + cumulative line), since dual y-axes are excluded by the charting style guide. X-axis is log-scaled because cost is extremely concentrated in a small number of generics relative to the full 1,177-drug list; a linear rank axis would compress the informative region into the first few pixels.

2. **Chart 4 (percentile spread):** The request did not specify which 3-4 'high-cost' specialties to use, so the 4 specialties with the highest median cost-per-claim were selected: Hematology-Oncology, Medical Oncology, Infectious Disease, Rheumatology.

3. **Chart 5 (variance explained):** regression_output.csv provides several variance-share metrics per dimension (own_r_squared, incremental_r_squared, pct_of_full_model_r2_own). The chart uses 'own_r_squared' -- the R-squared of a model using only that single dimension -- as 'variance explained by dimension', since it is the most directly interpretable measure and does not depend on inclusion order of the other dimensions.

