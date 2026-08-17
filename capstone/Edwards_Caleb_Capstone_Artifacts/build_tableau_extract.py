# WHAT: rebuild the prescriber-level table from the Stage 1 cleaned file and write
#       the flat CSV that the Tableau workbook is packaged around.
# WHY:  the dashboard must show the same numbers as FINDINGS.md, so it is built
#       from the same source and the same rules, not from a re-derivation.
import pandas as pd

SRC = "/sessions/upbeat-keen-feynman/mnt/DAB Capstone--outputs/part_d_co_clean.csv"
OUT = "/tmp/tw/Data/co_part_d/co_prescriber_segments.csv"

df = pd.read_csv(SRC, encoding="utf-8-sig", low_memory=False)

# WHAT: collapse the drug-level rows to one row per prescriber.
presc = (df.groupby(["Prscrbr_NPI", "Prscrbr_Last_Org_Name", "Prscrbr_Type", "Prscrbr_City"])
           .agg(total_cost=("Tot_Drug_Cst", "sum"),
                total_claims=("Tot_Clms", "sum"))
           .reset_index())
presc["cost_per_claim"] = presc["total_cost"] / presc["total_claims"]

# WHAT: keep only specialties with at least 30 prescribers (the proposal's rule).
spec_counts = presc["Prscrbr_Type"].value_counts().reset_index()
spec_counts.columns = ["Prscrbr_Type", "prescribers_in_specialty"]
presc = presc.merge(spec_counts, on="Prscrbr_Type", how="left")
qual = presc[presc["prescribers_in_specialty"] >= 30].copy()

# WHAT: per-specialty 95th percentile of cost per claim, merged back per prescriber.
thr = (qual.groupby("Prscrbr_Type")["cost_per_claim"].quantile([0.95]).unstack().reset_index())
thr.columns = ["Prscrbr_Type", "spec_p95"]
qual = qual.merge(thr, on="Prscrbr_Type", how="left")
qual["is_outlier"] = qual["cost_per_claim"] > qual["spec_p95"]

# WHAT: outlier spend per specialty -> priority ranking (top 8 = FINDINGS priority table).
oc = (qual[qual["is_outlier"]].groupby("Prscrbr_Type")["total_cost"].sum()
        .reset_index().rename(columns={"total_cost": "outlier_cost"}))
oc = oc.sort_values("outlier_cost", ascending=False).reset_index(drop=True)
oc["priority_rank"] = oc.index + 1
qual = qual.merge(oc[["Prscrbr_Type", "priority_rank"]], on="Prscrbr_Type", how="left")
qual["priority_rank"] = qual["priority_rank"].fillna(99).astype(int)
qual["Priority Group"] = qual["priority_rank"].apply(
    lambda r: "Top 8 priority segment" if r <= 8 else "Other qualifying specialty")
qual["Outlier Status"] = qual["is_outlier"].apply(
    lambda b: "Above own specialty 95th pct" if b else "Within specialty norm")
# WHAT: pre-split the cost column so a plain SUM() gives outlier dollars in Tableau.
qual["outlier_cost"] = qual.apply(lambda r: r["total_cost"] if r["is_outlier"] else 0.0, axis=1)

out = qual.rename(columns={
    "Prscrbr_NPI": "NPI", "Prscrbr_Last_Org_Name": "Prescriber",
    "Prscrbr_Type": "Specialty", "Prscrbr_City": "City",
    "total_cost": "Total Cost", "total_claims": "Total Claims",
    "cost_per_claim": "Cost Per Claim", "spec_p95": "Specialty p95",
    "outlier_cost": "Outlier Cost", "priority_rank": "Priority Rank",
    "prescribers_in_specialty": "Prescribers In Specialty"})
cols = ["NPI","Prescriber","Specialty","City","Total Claims","Total Cost","Cost Per Claim",
        "Specialty p95","Outlier Status","Outlier Cost","Priority Group","Priority Rank",
        "Prescribers In Specialty"]
out = out[cols].round({"Total Cost":2,"Cost Per Claim":2,"Specialty p95":2,"Outlier Cost":2})
out.to_csv(OUT, index=False, encoding="utf-8")

# --- reconciliation against FINDINGS.md ---
print("rows (expect 18,940):", len(out))
print("specialties (expect 46):", out["Specialty"].nunique())
print("outliers (expect 965):", int(qual["is_outlier"].sum()))
print("outlier spend (expect 587,147,319.57): {:,.2f}".format(qual.loc[qual["is_outlier"],"total_cost"].sum()))
print("qualifying spend: {:,.2f}".format(qual["total_cost"].sum()))
print("\nTop 8 priority table:")
t = (qual.groupby("Specialty" if "Specialty" in qual.columns else "Prscrbr_Type")
        .agg(prescribers=("Prscrbr_NPI","count"), outliers=("is_outlier","sum"),
             spec_cost=("total_cost","sum"), spec_claims=("total_claims","sum"),
             outlier_cost=("outlier_cost","sum")).reset_index())
t["pct"] = 100*t["outlier_cost"]/t["spec_cost"]
t["cpc"] = t["spec_cost"]/t["spec_claims"]
print(t.sort_values("outlier_cost", ascending=False).head(8).to_string(index=False,
      formatters={"spec_cost":"{:,.0f}".format,"outlier_cost":"{:,.0f}".format,
                  "pct":"{:.1f}".format,"cpc":"{:.0f}".format}))
