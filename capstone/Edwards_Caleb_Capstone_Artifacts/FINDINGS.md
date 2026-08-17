# FINDINGS — Stage 3

Source: `outputs/capstone_analysis.ipynb`, executed clean-kernel end to end
(23 code cells, 0 errors) against `outputs/part_d_co_clean.csv`.
Population: 390,473 rows, 19,390 Colorado Part D prescribers, $2,737,455,388.61
in 2024 drug cost.

Every figure below is printed in the notebook's "Figures used in FINDINGS.md"
cell so it can be traced to the cell that produced it.

---

## Method substitution

| Proposal said | Delivered instead | Why |
|---|---|---|
| Regression identifying which dimensions drive cost | One-way ANOVA (`scipy.stats.f_oneway`) + Kruskal–Wallis (`scipy.stats.kruskal`) across specialty and region, plus within-specialty percentile ranking on `groupby().quantile()` and `.merge()` | The curriculum never taught regression beyond `sns.regplot()` — no coefficient table, no R², no `statsmodels` or `scikit-learn` (CALIBRATION.md §2). ANOVA, Kruskal–Wallis, `groupby().agg()` and `.quantile()` are all taught in Advanced Pandas I–II and answer the same question. |

Two smaller substitutions, both noted on the chart that uses them: the Stage 0
Pareto curve is replaced by a `sns.barplot` with the concentration figure stated
in the title, and the log-scale axes are replaced by 99th-percentile trims that
are declared on the chart rather than hidden.

Definitional note: the notebook flags a prescriber as a within-specialty outlier
on a strict `cost_per_claim > specialty p95` test. SQL Query 6 used
`NTILE(20)` band 20. The two rules agree closely but not exactly — Urology, for
example, returns 9 prescribers here and 8 under `NTILE`. Where the two are
quoted together, the notebook rule governs.

---

## F1 — Specialty is a real driver of cost per claim. Region is statistically real but practically trivial.

| Dimension | Groups (≥30 prescribers) | Prescribers | ANOVA F | Kruskal–Wallis H | p | Group medians span | p75/p25 fold |
|---|---|---|---|---|---|---|---|
| **Specialty** | 46 of 97 | 18,940 | 51.83 | **8,608.94** | <1e-300 | $3.89 → $2,272.07 (**584×**) | **11.23×** |
| **City** | 60 of 226 | 18,394 | 3.17 | 254.96 | 3.4e-26 | $4.38 → $79.71 (18×) | 1.81× |

Both dimensions reject the null. That is the wrong place to stop — with ~19,000
prescribers, almost anything rejects. The size of the effect is the finding:
the middle half of specialties differ 11-fold on median cost per claim, while
the middle half of cities differ 1.8-fold. Kruskal–Wallis is the test relied on
because cost per claim is severely right-skewed (mean $193.65 against a median
of $31.09); ANOVA is reported alongside it and points the same way.

**Practical consequence:** cost-per-claim comparisons must be made inside a
specialty. Comparing an oncologist to a dentist measures case mix, not
prescribing behaviour. Comparing a Denver prescriber to a Pueblo one measures
almost nothing.

*Charts: `stage3_02`, `stage3_03`, `stage3_05`.*

## F2 — A statewide outlier list and a within-specialty list find largely different people.

| Flagged | Prescribers | Reading |
|---|---|---|
| Statewide top 5% **only** | 431 | High unit cost, but normal for their specialty — explained by case mix |
| Within own specialty's top 5% **only** | 467 | Unusual against their own peers, **invisible on a statewide list** |
| Both | 498 | High unit cost and unusual for their specialty |

Of the 965 prescribers who sit above their own specialty's 95th percentile,
**467 (48%) never appear on a statewide top-5% list at all.** Conversely 431 of
the 929 statewide flags are fully accounted for by specialty. A statewide
ranking is roughly half noise and half signal for this purpose, and it misses
half the real signal.

*Chart: `stage3_06`.*

## F3 — 965 prescribers — 5.1% — carry 22.1% of qualifying spend, and the spend gap is not an artifact of the ranking.

| Group | n | Median total cost | Mean total cost | Total cost |
|---|---|---|---|---|
| Above own specialty's p95 | 965 | $144,422.20 | $608,442.82 | **$587,147,319.57** |
| All other qualifying prescribers | 17,975 | $4,924.29 | $115,065.37 | $2,068,299,963.63 |

Kruskal–Wallis H = 658.63, p = 3.0e-145; Welch t = 11.11, p = 4.3e-27.

The test is on **total cost**, not on cost per claim. Cost per claim was the
variable used to build the flag, so re-testing it would have been circular.
Total cost is an independent measure, and the flagged group's median total spend
is **29× the median of everyone else**.

## F4 — Unit cost and volume are nearly independent, so a high-spend review list and a high-unit-cost review list find different people.

| Pair | Pearson r |
|---|---|
| Total cost vs total claims | 0.380 |
| Cost per claim vs total claims | **−0.011** |
| Cost per claim vs total cost | 0.337 |

Cost per claim carries essentially no linear relationship to claim volume. The
scatter in `stage3_06` shows the same thing structurally: flagged prescribers
sit high on total cost at low claim counts. This is the analytic justification
for the whole approach — a program that reviews the highest-spending prescribers
is reviewing a volume list, and will systematically miss the prescribers whose
problem is price per prescription.

*Charts: `stage3_06`, `stage3_07`.*

## F5 — Spend is extremely concentrated on both the drug and the prescriber axis.

| Cut | Share of $2.74B |
|---|---|
| Top 10 of 1,177 generic drugs | 33.5% ($917.8M) |
| Top 20 generics | **45.5%** ($1.25B) |
| Top 100 generics | 79.0% |
| Top 100 of 19,390 prescribers | 18.5% |
| Top 1,000 prescribers | 56.1% |
| Top 10% of prescribers (1,939) | **71.9%** ($1.97B) |

1.7% of the drug list carries 45.5% of the money. This is what makes a targeted
review economically viable at all: a formulary or utilisation review scoped to
20 generic molecules touches nearly half of Colorado Part D spend.

*Chart: `stage3_04`.*

---

## Recommended priority segments

Ranked by **spend flagged** — the total 2024 drug cost held by the prescribers who
sit above their own specialty's 95th percentile on cost per claim. That is the money
a within-specialty review would actually be looking at. It is not an excess-over-
threshold figure. `Specialty cost per claim` is specialty-weighted (total specialty
cost / total specialty claims), which is why it runs higher than the prescriber-level
medians quoted in F1. This is the
notebook's `priority` table, sorted, not a judgment call layered on top of it.

| Rank | Specialty | Outliers / prescribers | Spend flagged | % of specialty spend | Specialty cost per claim (wtd) |
|---|---|---|---|---|---|
| 1 | Nurse Practitioner | 176 / 3,509 | $109,343,136 | 27.8% | $137 |
| 2 | Physician Assistant | 151 / 3,010 | $106,670,500 | 41.6% | $147 |
| 3 | Internal Medicine | 65 / 1,292 | $60,293,209 | 19.1% | $98 |
| 4 | Family Practice | 115 / 2,288 | $41,334,113 | 11.7% | $73 |
| 5 | Hematology-Oncology | 6 / 115 | $33,045,826 | 14.5% | $2,652 |
| 6 | Urology | 9 / 178 | $26,685,838 | **53.0%** | $320 |
| 7 | Pulmonary Disease | 8 / 154 | $25,642,076 | 24.8% | $907 |
| 8 | Cardiology | 11 / 205 | $24,133,908 | 17.9% | $272 |

**Recommendation — review the top four first, and review them as a single
cohort of 507 clinicians.**

The reasoning: Nurse Practitioner, Physician Assistant, Internal Medicine and
Family Practice are the four *cheapest* segments per claim on this list — $73 to
$147, all at or below the state median-weighted level — and yet together their
within-specialty outliers account for **$317.6M**, 54% of all outlier dollars in
the state. That combination is the entire argument for using a within-specialty
rule. These 507 prescribers are invisible to any statewide unit-cost screen,
because a $600 claim looks unremarkable next to oncology and looks extraordinary
next to a Family Practice peer group whose median is $73. They are 507 people —
a tractable review list, not a program.

**Second tier: Urology, on concentration rather than size.** Nine prescribers
hold 53.0% of the specialty's entire spend. No other segment on the list is
close. Nine charts is a day of work.

**Deprioritise Hematology-Oncology, Pulmonary Disease and Cardiology relative to
their dollar rank.** They appear high on the table because the drugs are
genuinely expensive — specialty cost per claim of $2,652, $907 and $272. F1
establishes that specialty explains most of that. The residual within-specialty
signal is real but small (14.5%, 24.8%, 17.9% of specialty spend), and the
clinical justification for high-cost oncology and pulmonary agents is
correspondingly stronger.

---

## What these findings do not establish

Stated so that no one reads more into the tables than the data supports.

| Limit | Detail |
|---|---|
| No clinical context | The file has no diagnoses, no severity, no patient panel composition. A within-specialty outlier is a *statistical* outlier — it is a reason to look, not a finding of waste or impropriety. |
| Cost is plan-paid drug cost | `Tot_Drug_Cst` is what CMS reports as paid; it is not a rebate-net or a net-of-discount price, so cross-drug comparisons overstate spread on brands with large rebates. |
| No cost per beneficiary | `Tot_Benes` is blank on 58.9% of rows under CMS small-cell suppression, so no per-patient rate is computed anywhere in this analysis. Cost per claim and cost per 30-day fill are the only unit metrics used. |
| 51 specialties excluded | The ≥30 prescriber rule drops 51 of 97 specialties, covering 2.3% of prescribers and 3.0% of spend. Nothing is claimed about them. |
| Single year, single state | 2024 Colorado only. No trend, no national benchmark. |
| Open data questions unresolved | QUESTIONS.md Q1–Q15 remain open, including 28 city spelling variants (1,856 rows) and 596 zero-cost rows. None are large enough to move the figures above, and none were silently fixed. |

---

## Chart inventory — 7 figures, the complete set for this project

| File | Type | Supports |
|---|---|---|
| `charts/stage3_01_cost_per_claim_distribution.png` | `sns.histplot` | Skew justifying Kruskal–Wallis over ANOVA |
| `charts/stage3_02_cost_per_claim_by_specialty_box.png` | `sns.boxplot` | F1 |
| `charts/stage3_03_median_cost_per_claim_by_specialty.png` | `sns.barplot` | F1 |
| `charts/stage3_04_top15_generic_drugs_by_spend.png` | `sns.barplot` | F5 |
| `charts/stage3_05_group_median_dispersion_by_dimension.png` | `sns.boxplot` + `sns.stripplot` | F1 |
| `charts/stage3_06_within_specialty_outliers_scatter.png` | `sns.scatterplot` | F2, F3, F4 |
| `charts/stage3_07_prescriber_measure_correlation_heatmap.png` | `sns.heatmap` | F4 |

The five Stage 0 figures were built with a Pareto cumulative-percent line,
`ax.barh`, `ax.fill_between` and log axes, none of which appear in any lecture.
They were **moved, not deleted**, to `charts/superseded/` and are excluded from
the deliverable set. The project's chart count is 7.
