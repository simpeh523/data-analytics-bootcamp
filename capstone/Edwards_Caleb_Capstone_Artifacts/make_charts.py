"""
Generate presentation-quality charts from outputs/outliers.csv,
outputs/regression_output.csv, and outputs/CAPSTONE_AGGREGATES.xlsx.

Charts written to outputs/charts/ as PNG @ 150 dpi.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
from pathlib import Path

BASE = Path(__file__).resolve().parent
CHARTS = BASE / "charts"
CHARTS.mkdir(exist_ok=True)

# ---- palette (dataviz skill reference palette, light mode) ----
BLUE = "#2a78d6"
ORANGE = "#eb6834"
AQUA = "#1baf7a"
YELLOW = "#eda100"
MAGENTA = "#e87ba4"
GREEN = "#008300"
VIOLET = "#4a3aa7"
RED = "#e34948"

SURFACE = "#fcfcfb"
INK_PRIMARY = "#0b0b0b"
INK_SECONDARY = "#52514e"
INK_MUTED = "#898781"
GRIDLINE = "#e1e0d9"
BASELINE = "#c3c2b7"

plt.rcParams.update({
    "figure.facecolor": SURFACE,
    "axes.facecolor": SURFACE,
    "savefig.facecolor": SURFACE,
    "font.family": "sans-serif",
    "font.sans-serif": ["Segoe UI", "DejaVu Sans", "Arial"],
    "text.color": INK_PRIMARY,
    "axes.edgecolor": BASELINE,
    "axes.labelcolor": INK_PRIMARY,
    "xtick.color": INK_SECONDARY,
    "ytick.color": INK_SECONDARY,
    "axes.grid": True,
    "grid.color": GRIDLINE,
    "grid.linewidth": 0.8,
    "axes.axisbelow": True,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "font.size": 11,
})

flags = []  # collected ambiguity / methodology notes for CHART_FLAGS.md


def savefig(fig, name):
    path = CHARTS / name
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print("wrote", path)


# ------------------------------------------------------------------
# Load data
# ------------------------------------------------------------------
outliers = pd.read_csv(BASE / "outliers.csv")
regression = pd.read_csv(BASE / "regression_output.csv")

generic = pd.read_excel(BASE / "CAPSTONE_AGGREGATES.xlsx", sheet_name="By_Generic_Drug", header=2)
city = pd.read_excel(BASE / "CAPSTONE_AGGREGATES.xlsx", sheet_name="By_City", header=2)

generic = generic.rename(columns={
    "Generic Drug (Gnrc_Name)": "generic_name",
    "Total Drug Cost": "total_cost",
    "Cumulative % of Total Cost": "cum_pct",
})
city = city.rename(columns={
    "City (Prscrbr_City)": "city",
    "Total Drug Cost": "total_cost",
})

# ------------------------------------------------------------------
# Chart 1: Cost concentration -- cumulative % of total cost by generic drug
# ------------------------------------------------------------------
generic_sorted = generic.sort_values("total_cost", ascending=False).reset_index(drop=True)
generic_sorted["rank"] = np.arange(1, len(generic_sorted) + 1)

fig, ax = plt.subplots(figsize=(9, 5.5))
ax.plot(generic_sorted["rank"], generic_sorted["cum_pct"], color=BLUE, linewidth=2.2)
ax.fill_between(generic_sorted["rank"], generic_sorted["cum_pct"], color=BLUE, alpha=0.12)

for pct_level in [50, 80]:
    idx = (generic_sorted["cum_pct"] >= pct_level).idxmax()
    rank_at = generic_sorted.loc[idx, "rank"]
    ax.axhline(pct_level, color=INK_MUTED, linewidth=0.8, linestyle="--")
    ax.axvline(rank_at, color=INK_MUTED, linewidth=0.8, linestyle="--")
    ax.plot([rank_at], [pct_level], marker="o", color=ORANGE, markersize=6, zorder=5)
    ax.annotate(
        f"{rank_at} drugs → {pct_level}% of cost",
        xy=(rank_at, pct_level),
        xytext=(rank_at + len(generic_sorted) * 0.03, pct_level - 8),
        fontsize=9.5, color=INK_SECONDARY,
    )

ax.set_xscale("log")
ax.set_xlabel("Generic drug rank (ranked by total drug cost, most costly = 1; log scale)")
ax.set_ylabel("Cumulative % of total drug cost")
ax.set_title(f"Cumulative Share of Total Drug Cost Across {len(generic_sorted):,} Generic Drugs, Ranked by Cost")
ax.set_ylim(0, 105)
ax.yaxis.set_major_formatter(mticker.PercentFormatter(xmax=100))
savefig(fig, "01_cost_concentration_pareto.png")

flags.append(
    "**Chart 1 (Pareto/cost concentration):** Rendered as a single cumulative-% line on a "
    "log-scaled rank axis rather than a classic dual-axis Pareto (bars + cumulative line), "
    "since dual y-axes are excluded by the charting style guide. X-axis is log-scaled because "
    "cost is extremely concentrated in a small number of generics relative to the full "
    f"{len(generic_sorted):,}-drug list; a linear rank axis would compress the informative "
    "region into the first few pixels."
)

# ------------------------------------------------------------------
# Chart 2: Cost per claim distribution by specialty (box plot, 46 specialties)
# ------------------------------------------------------------------
specialties_all = sorted(outliers["Prscrbr_Type"].unique())
n_spec = len(specialties_all)
if n_spec != 46:
    flags.append(
        f"**Chart 2 (box plot):** outputs/outliers.csv contains {n_spec} distinct "
        "Prscrbr_Type values, not the 46 specified in the request. All specialties present "
        "in outliers.csv were plotted -- this file already appears pre-filtered to specialties "
        "meeting a minimum-prescriber-count threshold (all have specialty_n_prescribers >= 30)."
    )

order = (
    outliers.groupby("Prscrbr_Type")["cost_per_claim"]
    .median()
    .sort_values(ascending=False)
    .index.tolist()
)
data_by_spec = [outliers.loc[outliers["Prscrbr_Type"] == s, "cost_per_claim"].values for s in order]

fig, ax = plt.subplots(figsize=(10, 13))
bp = ax.boxplot(
    data_by_spec,
    vert=False,
    patch_artist=True,
    widths=0.6,
    flierprops=dict(marker="o", markersize=2.5, markerfacecolor=BLUE, markeredgecolor="none", alpha=0.35),
    medianprops=dict(color=INK_PRIMARY, linewidth=1.4),
    boxprops=dict(facecolor=BLUE, edgecolor=INK_SECONDARY, alpha=0.55, linewidth=0.8),
    whiskerprops=dict(color=INK_SECONDARY, linewidth=0.9),
    capprops=dict(color=INK_SECONDARY, linewidth=0.9),
)
ax.set_yticks(range(1, n_spec + 1))
ax.set_yticklabels(order, fontsize=9)
ax.set_xscale("log")
ax.set_xlabel("Cost per claim, $ (log scale)")
ax.set_ylabel("Prescriber specialty")
ax.set_title(f"Distribution of Cost per Claim by Prescriber Specialty ({n_spec} Specialties, Sorted by Median)")
ax.invert_yaxis()
savefig(fig, "02_cost_per_claim_by_specialty_box.png")

# ------------------------------------------------------------------
# Chart 3: Top 15 cities by total cost (bar)
# ------------------------------------------------------------------
top_cities = city.sort_values("total_cost", ascending=False).head(15).iloc[::-1]

fig, ax = plt.subplots(figsize=(9, 6.5))
ax.barh(top_cities["city"], top_cities["total_cost"] / 1e6, color=BLUE)
ax.set_xlabel("Total drug cost, $ millions")
ax.set_ylabel("Prescriber city")
ax.set_title("Total Drug Cost by City, Top 15 Colorado Cities")
for y, v in enumerate(top_cities["total_cost"] / 1e6):
    ax.text(v + top_cities["total_cost"].max() / 1e6 * 0.01, y, f"${v:,.1f}M", va="center", fontsize=9, color=INK_SECONDARY)
ax.xaxis.set_major_formatter(mticker.StrMethodFormatter("${x:,.0f}"))
savefig(fig, "03_top15_cities_total_cost.png")

# ------------------------------------------------------------------
# Chart 4: Within-specialty percentile spread for high-cost specialties
# ------------------------------------------------------------------
median_by_spec = outliers.groupby("Prscrbr_Type")["cost_per_claim"].median().sort_values(ascending=False)
top_specialties = median_by_spec.head(4).index.tolist()
flags.append(
    "**Chart 4 (percentile spread):** The request did not specify which 3-4 'high-cost' "
    "specialties to use, so the 4 specialties with the highest median cost-per-claim were "
    f"selected: {', '.join(top_specialties)}."
)

colors4 = [BLUE, ORANGE, AQUA, YELLOW]
fig, ax = plt.subplots(figsize=(9, 6))
for spec, color in zip(top_specialties, colors4):
    sub = outliers.loc[outliers["Prscrbr_Type"] == spec, ["cost_per_claim_pctile_in_specialty", "cost_per_claim"]]
    sub = sub.sort_values("cost_per_claim_pctile_in_specialty")
    ax.plot(sub["cost_per_claim_pctile_in_specialty"], sub["cost_per_claim"], color=color, linewidth=2, label=spec)

ax.set_yscale("log")
ax.set_xlabel("Percentile rank of cost per claim within specialty")
ax.set_ylabel("Cost per claim, $ (log scale)")
ax.set_title("Cost per Claim vs. Within-Specialty Percentile Rank, 4 Highest-Median Specialties")
ax.legend(frameon=False, loc="upper left", fontsize=9.5)
ax.xaxis.set_major_formatter(mticker.PercentFormatter(xmax=100))
savefig(fig, "04_within_specialty_percentile_spread.png")

# ------------------------------------------------------------------
# Chart 5: Variance explained by dimension (from regression output)
# ------------------------------------------------------------------
ve = regression[regression["block"] == "variance_explained"].copy()
own_r2 = (
    ve[ve["level"] == "own_r_squared"]
    .set_index("source_column")["coefficient"]
    .sort_values(ascending=False)
)
flags.append(
    "**Chart 5 (variance explained):** regression_output.csv provides several variance-share "
    "metrics per dimension (own_r_squared, incremental_r_squared, pct_of_full_model_r2_own). "
    "The chart uses 'own_r_squared' -- the R-squared of a model using only that single dimension "
    "-- as 'variance explained by dimension', since it is the most directly interpretable measure "
    "and does not depend on inclusion order of the other dimensions."
)

dim_labels = {"generic": "Generic drug", "specialty": "Prescriber specialty", "city": "Prescriber city"}
labels = [dim_labels.get(k, k) for k in own_r2.index]
colors5 = [BLUE, ORANGE, AQUA][: len(own_r2)]

fig, ax = plt.subplots(figsize=(7.5, 5))
bars = ax.bar(labels, own_r2.values * 100, color=colors5)
ax.set_ylabel("Variance in cost per claim explained, % (R²)")
ax.set_xlabel("Regression dimension")
ax.set_title("Share of Cost-per-Claim Variance Explained by Each Dimension, Single-Dimension Models")
for bar, val in zip(bars, own_r2.values * 100):
    ax.text(bar.get_x() + bar.get_width() / 2, val + 1, f"{val:.1f}%", ha="center", fontsize=10, color=INK_SECONDARY)
ax.set_ylim(0, max(own_r2.values * 100) * 1.15)
savefig(fig, "05_variance_explained_by_dimension.png")

# ------------------------------------------------------------------
# Write CHART_FLAGS.md
# ------------------------------------------------------------------
flags_path = BASE / "CHART_FLAGS.md"
with open(flags_path, "w", encoding="utf-8") as f:
    f.write("# Chart Generation Flags\n\n")
    f.write("Notes on ambiguous specifications and the choices made to resolve them "
            "while generating charts in `outputs/charts/`.\n\n")
    for i, note in enumerate(flags, 1):
        f.write(f"{i}. {note}\n\n")

print("wrote", flags_path)
print("Done.")
