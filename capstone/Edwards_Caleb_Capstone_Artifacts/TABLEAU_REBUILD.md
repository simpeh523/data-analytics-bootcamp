# Tableau rebuild — Capstone Dashboard

20 minutes. Data source `tableau_prescriber_segments.csv` is already connected.
Shelf placement is explicit at every step: **Rows** = the shelf above the canvas labelled
Rows, **Columns** = the one above it labelled Columns.

Why the dimension goes on Rows for the bar charts: the measure on **Columns** makes bars
grow left-to-right (horizontal bars), and specialty names like "Hematology-Oncology" only
read cleanly stacked down the left side.

---

## 0 — Pre-flight (1 min)

1. Right-click `NPI` in the left data pane → **Convert to Dimension**. It loads as a
   measure because it is numeric; you need it as a dimension for the scatter. Do this
   now, before building anything.
2. Analysis menu → **Create Calculated Field**. Name: `Cost Per Claim (weighted)`.
   Formula, exactly:

```
SUM([Total Cost]) / SUM([Total Claims])
```

   Click OK. You should see it appear in the data pane with an `=` in front of the icon.

Do NOT delete or rename `Cost Per Claim` — the existing column is per-prescriber and the
scatter needs it. The two coexist on purpose.

---

## 1 — Sheet 1: Priority Segments (5 min)

| Step | Action |
|---|---|
| 1 | Drag `Specialty` → **Rows** |
| 2 | Drag `Outlier Cost` → **Columns**. It becomes `SUM(Outlier Cost)` — correct |
| 3 | Drag `Priority Group` → **Filters** shelf. Dialog opens → General tab → check only **Top 8 priority segment** → OK |
| 4 | Sort: click the `Specialty` pill on Rows to select it, then click the **descending sort** button in the top toolbar (the bar-chart icon with the down arrow). If it sorts alphabetically instead, right-click the pill → Sort → Sort By: **Field** → Sort Order: **Descending** → Field Name: **Outlier Cost** → Aggregation: **Sum** → OK |
| 5 | Double-click the sheet tab at the bottom, rename to `Priority Segments` |

**Check before moving on:** eight bars, top to bottom —
Nurse Practitioner $109.3M · Physician Assistant $106.7M · Internal Medicine $60.3M ·
Family Practice $41.3M · Hematology-Oncology $33.0M · Urology $26.7M ·
Pulmonary Disease $25.6M · Cardiology $24.1M.

---

## 2 — Sheet 2: Unit Cost by Segment (4 min)

New worksheet (the tab with a `+` at the bottom).

| Step | Action |
|---|---|
| 1 | Drag `Specialty` → **Rows** |
| 2 | Drag `Cost Per Claim (weighted)` → **Columns** — your calculated field, not the plain `Cost Per Claim` column |
| 3 | Drag `Priority Group` → **Filters** → **Top 8 priority segment** → OK |
| 4 | Sort descending, same as sheet 1 (Field → Descending → Cost Per Claim (weighted)) |
| 5 | Rename the tab to `Unit Cost by Segment` |

**Check:** Hematology-Oncology at the top around **$2,652**, then Pulmonary Disease $907,
Urology $320, Cardiology $272, Physician Assistant $147, Nurse Practitioner $137,
Internal Medicine $98, Family Practice $73 at the bottom.

If Hem-Onc reads something in the hundreds instead, you used the plain `Cost Per Claim`
column and Tableau averaged it. Swap in the weighted field.

---

## 3 — Sheet 3: Prescriber Scatter (5 min)

New worksheet.

| Step | Action |
|---|---|
| 1 | Drag `Total Claims` → **Columns** (x-axis, becomes SUM) |
| 2 | Drag `Cost Per Claim` → **Rows** (y-axis) — the plain column this time, not the weighted one |
| 3 | On the **Marks** card, set the mark type dropdown to **Circle** |
| 4 | Drag `NPI` → **Detail** on the Marks card. This is what makes one dot per prescriber |
| 5 | Drag `Outlier Status` → **Color** on the Marks card. Two values, no cleanup needed |
| 6 | Drag `Priority Group` → **Filters** → **Top 8 priority segment** → OK |
| 7 | Drag `Cost Per Claim` → **Filters** again. Dialog asks how to filter → choose **All values** → Next → **At most** → type `2000` → OK. This trims the tail so the cloud is readable |
| 8 | Rename the tab to `Prescriber Scatter` |

**Check:** a dense cloud low on the y-axis with scattered high points, two colours in the
legend. Marks count bottom-left should be in the low ten-thousands (10,751 rows pass the
Top 8 filter, minus whatever the $2,000 trim removes).

Step 7's "All values" matters — if you pick Sum or Average instead, Tableau filters the
aggregate and the trim won't behave.

---

## 4 — Dashboard (4 min)

New Dashboard (the middle icon at the bottom, next to the new-sheet `+`).

| Step | Action |
|---|---|
| 1 | Left panel → Size → **Fixed size** → Custom → **1250 × 850** |
| 2 | Drag `Priority Segments` onto the canvas — it fills the space |
| 3 | Drag `Unit Cost by Segment` onto the **right half** of the first sheet. Watch for the grey drop-zone preview before releasing |
| 4 | Drag `Prescriber Scatter` onto the **bottom** of the canvas, across the full width |
| 5 | Dashboard menu → **Actions** → Add Action → **Filter**. Source Sheets: `Priority Segments` only. Target Sheets: check the other two. Run action on: **Select**. Clearing the selection: **Show all values**. OK |
| 6 | Rename the dashboard tab to `CO Part D Review Priorities` |

Test the action: click one bar in Priority Segments — the other two panes should filter to
that specialty. Click empty space to clear.

---

## 5 — Save (1 min)

File → **Save As** → set file type to **Tableau Packaged Workbook (\*.twbx)** →
save over:

```
C:\Users\Caleb Edwards\OneDrive\Documents\DAB Capstone\outputs\Final Deliverables\Capstone_Dashboard.twbx
```

Packaged, not plain `.twb` — packaged bundles the CSV inside so it opens on any machine.

---

## If something snags

| Symptom | Cause | Fix |
|---|---|---|
| Sort goes alphabetical | Toolbar button sorted the dimension, not by the measure | Right-click the Specialty pill → Sort → Sort By: Field → Descending → pick the measure |
| Bars show all 46 specialties | Priority Group filter missing on that sheet | Filters apply per sheet unless you right-click the filter → Apply to Worksheets → Selected Worksheets |
| Scatter shows one giant dot | `NPI` not on Detail, or still a measure | Right-click NPI in the data pane → Convert to Dimension, then drag to Detail |
| Hem-Onc unit cost looks too low | Used `Cost Per Claim` instead of the weighted field | Swap the pill on Columns |
| Numbers look right but the axis is ugly | Not worth fixing | R8 is 5 points. Ship it |

---

## Ties back to the report

| Figure | Where it also appears |
|---|---|
| $109.3M / $106.7M / $60.3M / $41.3M for the top four | Report §5 table, deck slide 12, memo table |
| $587.1M total flagged (all 46 specialties) | FINDINGS.md F3 — the `Outlier Cost` column sums to $587,147,319.57 |
| 965 flagged / 17,975 not | `Outlier Status` field, exact counts |
| Hem-Onc $2,652 weighted | Report §5, deck slide 12 — deliberately different from the $2,272 median on slide 8 |
