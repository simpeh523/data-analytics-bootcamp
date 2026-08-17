CATEGORY: COWORK-ONLY — working file. Sets the technique ceiling for Stages 1–6. Never submitted.

# CALIBRATION — What the Curriculum Actually Taught

Built by extracting the text of all 21 lecture PDFs in `Lecture PDFs\` and parsing the
code cells of three submitted workshops (`wk-12wkshop-learner-CE.ipynb`,
`wk8-wkshop-learner-CE.ipynb`, `SQL_Public_Library_Management-CE.sql`,
`SQL_Online_Music_Store-CE.sql`, `car_sales_final-CE.xlsx`,
`Tableau Hospital ER Insights.twbx`). A technique is listed as TAUGHT only where it
appears by name in a lecture deck or in Caleb's own submitted work.

This file is the ceiling. Stages 1–6 use what is on the TAUGHT lists. Anything on the
BEYOND list either gets swapped for the taught alternative named next to it, or gets a
one-line substitution note if it is kept.

---

## 1. SQL — taught constructs

| Construct | Where taught |
|---|---|
| `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `LIMIT`, `DISTINCT` | SQL Queries |
| `LIKE`, `BETWEEN`, `IN (...)` | SQL Queries; Database Fundamentals |
| `CREATE TABLE`, `INSERT INTO`, `UPDATE`, transactions | SQL Queries; Applied SQL I |
| `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`, `CROSS JOIN`, self-join | Applied SQL I |
| `PRIMARY KEY`, `FOREIGN KEY`, normalization, ERD | Database Fundamentals; Applied SQL I |
| `GROUP BY`, `HAVING` | Applied SQL II |
| `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `ROUND` | Applied SQL II |
| `COUNT(DISTINCT ...)` | Applied SQL II |
| Subqueries — scalar, `IN`, correlated; `EXISTS` | Advanced SQL I |
| CTEs (`WITH ... AS`) | Advanced SQL II |
| Window functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`, `LAG()`, `LEAD()` | Advanced SQL II |
| `OVER (PARTITION BY ... ORDER BY ...)` | Advanced SQL I (intro), Advanced SQL II (full) |
| `CREATE INDEX` | Advanced SQL II |
| `UPPER()` | Advanced SQL II |

### SQL — NOT taught anywhere in the curriculum

`CASE WHEN ... THEN ... ELSE ... END` · `CAST()` · `CEIL()` / `FLOOR()` ·
`COALESCE()` / `IFNULL()` / `NULLIF()` · `PERCENTILE_CONT()` · a `MEDIAN()` or
`STDDEV()` aggregate · `GROUP_CONCAT()` · `UNION` / `INTERSECT` / `EXCEPT` ·
explicit window frames (`ROWS BETWEEN ...`) · views · recursive CTEs · triggers ·
stored procedures · `SUBSTR()` / `LENGTH()` / `TRIM()` / `REPLACE()` ·
`strftime()` / date functions.

**Note:** `NTILE()` *is* taught, and it is the taught route to percentile bucketing.
Where prior work reached for `CASE WHEN` to build buckets, `NTILE()` is the
in-curriculum replacement. Where prior work used `CAST` purely to force float
division, the taught alternative is multiplying by `1.0`.

---

## 2. Python / pandas — taught methods

| Method | Where taught |
|---|---|
| `pd.read_csv`, `pd.read_excel`, `pd.read_sql` / `read_sql_query` | Intro to Pandas I |
| `.head()`, `.tail()`, `.info()`, `.describe()`, `.sample()`, `.copy()` | Intro to Pandas I–II |
| `.isnull()` / `.isna()`, `.dropna()`, `.fillna()` | Intro to Pandas II; wk8 workshop |
| `.duplicated()`, `.drop_duplicates()` | Intro to Pandas II |
| `pd.to_numeric`, `.astype()`, `.replace()`, `.apply()` | Intro to Pandas II |
| `.value_counts()`, `.nunique()` | Intro to Pandas II; wk8 workshop |
| `.groupby()` + `.agg()` | Advanced Pandas I |
| `.sum()`, `.mean()`, `.median()`, `.mode()`, `.min()`, `.max()`, `.count()`, `.std()`, `.var()` | Advanced Pandas I |
| `.quantile()` (explicitly `.quantile(0.25)` for quartiles) | Advanced Pandas I |
| `.sort_values()`, `pd.to_datetime`, `.to_period()`, `.day_name()` | Advanced Pandas I |
| `.corr()` + `sns.heatmap()` correlation matrix | Advanced Pandas II |
| `.merge()` | Intro to Pandas I; wk12 workshop |
| `pd.cut()`, `.nlargest()`, `.idxmax()`, `.map()`, `.ffill()`, `.strip()` | Caleb's own wk8/wk12 workshops |
| `lambda` in an `apply` | Advanced Pandas II |

### Statistics — taught

| Test | Function | Where taught |
|---|---|---|
| Independent-samples t-test | `scipy.stats.ttest_ind` | Advanced Pandas II |
| Paired t-test | `scipy.stats.ttest_rel` | Advanced Pandas II |
| One-way ANOVA | `scipy.stats.f_oneway` | Advanced Pandas II |
| Kruskal–Wallis (non-parametric ANOVA) | `scipy.stats.kruskal` | Advanced Pandas II |
| Chi-square test of independence | `scipy.stats.chi2_contingency` | Advanced Pandas II |
| Hypothesis framing, null hypothesis, p-value, confidence interval | — | Advanced Pandas II |
| Correlation coefficient | `.corr()` | Advanced Pandas II |

### Python — NOT taught anywhere in the curriculum

`statsmodels` (any use) · `scikit-learn` (named once in a slide listing the SciPy
ecosystem in Intro to Pandas I; never imported, never demonstrated) · OLS regression
with categorical dummy variables · adjusted R² · incremental / partitioned R² ·
`pd.get_dummies` · `pivot_table` · `melt` · `crosstab` · `.query()` · `.rolling()` /
`.resample()` · `.transform()` on a groupby · `np.bincount` / `np.full` /
`np.asarray` · `.iterrows()`.

**The only regression taught in the entire curriculum is `sns.regplot()`** — a
scatter with a fitted trend line and a shaded confidence band (Creating Custom
Visualizations, "Layer 2 — the trend"). No coefficient table, no R², no model
summary is ever produced in a lecture.

**Taught alternative for "which dimension drives cost":** one-way ANOVA
(`f_oneway`) across each candidate dimension, backed by Kruskal–Wallis for the
non-normal case, plus `groupby().agg()` group means and `.quantile()` spreads. This
answers the same proposal question — *which dimensions are statistically meaningful
rather than noise* — entirely inside the syllabus.

---

## 3. Visualization — taught

**Seaborn / matplotlib (Intro to Seaborn, Creating Custom Visualizations, Advanced Pandas II):**
`sns.scatterplot` · `sns.regplot` · `sns.lmplot` · `sns.barplot` · `sns.countplot` ·
`sns.boxplot` · `sns.violinplot` · `sns.histplot` · `sns.kdeplot` · `sns.jointplot` ·
`sns.pairplot` · `sns.relplot` · `sns.heatmap` · `sns.set_theme` · `sns.despine` ·
`sns.color_palette` · `plt.subplots` · `plt.tight_layout` · `plt.show`.

**Also demonstrated in Caleb's wk12 workshop:** `ax.set_title/xlabel/ylabel`,
`ax.legend`, `ax.annotate`, `ax.axvline`, `ax.text`, `plt.FuncFormatter` for axis
currency formatting, `ax.set_xticks` / `set_xticklabels`, `fig.suptitle`.

**Pandas-native plots (Intro to Pandas II):** `.hist()`, `.boxplot()`, `.scatter()`.

**Tableau (Intro I–II, Advanced I–II):** calculated fields · parameters · filters and
context filters · filter-order-of-operations · dashboard actions · sets · groups ·
bins · hierarchies · LOD expressions (`FIXED`, `INCLUDE`, `EXCLUDE`) · table
calculations · tooltips · maps · dashboards · stories · bar chart · line chart ·
scatter plot.

**Excel (Fundamentals I–II, Advanced Excel I, Excel Data Cleaning):** PivotTables ·
`VLOOKUP` · conditional formatting · Excel Tables · absolute references · named
ranges · `IFERROR` · `CONCATENATE` · `TRIM` · `PROPER` · `LEFT` / `MID` / `LEN` ·
Remove Duplicates · Data Validation · Text to Columns · charts.

### Visualization — NOT taught

Pareto / cumulative-percentage charts · dual-axis (`twinx`) charts · log-scale axes
(`set_xscale('log')`) · `ax.fill_between` · `ax.barh` · `ax.boxplot` called directly
on matplotlib rather than through `sns.boxplot` · stacked area / step charts ·
treemaps · packed bubbles · reference and trend lines in Tableau · forecasting.

**Excel — NOT taught:** `XLOOKUP` · `INDEX`/`MATCH` · Power Query · Solver ·
Goal Seek · dynamic array functions (`FILTER`, `SORT`, `UNIQUE`) · macros/VBA ·
slicers · sparklines.

---

## 4. What in *this* project currently goes beyond the curriculum

Assessed against the artifacts already in `outputs\`.

| # | Where | What exceeds the syllabus | Taught substitute |
|---|---|---|---|
| B1 | `part_d_analysis.ipynb` → `regression_output.csv` | Multivariate OLS with categorical dummies, R², adjusted R², incremental R² by dimension. Implemented by hand in pandas/numpy (no `statsmodels`, no `sklearn`) — but the *method* is never taught, and Caleb would have to defend the math live. | One-way ANOVA (`f_oneway`) + Kruskal–Wallis per dimension, plus `groupby().agg()` means and `.quantile()` spreads. Both taught in Advanced Pandas II. |
| B2 | `part_d_profiling.sql` | `CASE WHEN` (54 uses), `CAST` (100), `CEIL` (91) | `NTILE()` for bucketing; `* 1.0` for float division; `ROUND()` where rounding is the actual intent. All taught. |
| B3 | `part_d_analysis.ipynb` | `np.bincount`, `np.full`, `np.asarray`, `.transform()`, `.iterrows()` | `.groupby().agg()` and `.value_counts()` cover every use here. |
| B4 | `charts\01_cost_concentration_pareto.png` | Pareto chart with cumulative-% line | `sns.barplot` of top-N cost by generic, with the concentration figure ("top 20 drugs = X% of spend") stated in text rather than drawn as a curve. |
| B5 | `charts\02`, `03`, `04` | Raw matplotlib `ax.boxplot`, `ax.barh`, `ax.fill_between`, log-scale axis | `sns.boxplot`, `sns.barplot`, and a linear axis. All taught; `sns.boxplot` is a direct swap. |
| B6 | `part_d.sqlite` / `load_part_d.py` | Loading a CSV into SQLite from Python | Low risk — Database Fundamentals covers `CREATE TABLE` and Intro to Pandas I covers `read_sql`. Keep, and comment the loader. |

**Not flagged (in-curriculum, keep as-is):** window functions with
`OVER (PARTITION BY ...)` and `ROW_NUMBER()` in the profiling SQL; CTEs; the
`.quantile()`-based outlier rule; `COUNT(DISTINCT ...)`; the Excel aggregate
workbook's structure.

---

## 5. Standing rules this file sets for Stages 1–6

1. No library import beyond `pandas`, `numpy`, `matplotlib.pyplot`, `seaborn`,
   `scipy.stats`, `sqlite3`, `pathlib`, `json`. Nothing else was ever used in a
   lecture or a workshop.
2. No `CASE WHEN` in submitted SQL. Use `NTILE()` for buckets.
3. Statistical claims about *which dimension matters* rest on ANOVA / Kruskal–Wallis
   and group spreads, not on a regression coefficient table.
4. Every chart is a chart type from §3, drawn with `sns.` where a seaborn function
   exists for it.
5. Every SQL query and notebook cell carries a plain-language comment saying what it
   does and why — the standard Caleb's own `SQL_Public_Library_Management-CE.sql`
   already meets.
