# VALIDATION REPORT — Capstone deliverables, pre-submission QA

Run 2026-08-13 against `Edwards_Caleb_Capstone_Report.docx`, `FINDINGS.md`,
`QUESTIONS.md`, plus CMS source documentation. Method: `/data:validate-data`
checklist — methodology review, calculation spot-checks, pitfall catalog,
narrative/conclusion review.

## Overall assessment: **Share with noted caveats**

No calculation errors. Every arithmetic claim I could recompute ties. Five text-level
issues, all fixable in under fifteen minutes, one of which is a factual error about
a CMS variable that a clinically fluent grader could catch.

**Scope limit on this pass, stated up front:** your desktop went offline mid-session, so
I validated against the report, `FINDINGS.md` and `QUESTIONS.md` (staged earlier) and
against CMS's published documentation. I could **not** re-derive anything from the raw
CSV, and did not re-open the deck, the workbook, the SQL, the notebook, the charts or
the `.twbx` this pass. Those were verified in Stages 0/3/5/6 — 7 PASS / 1 INCONCLUSIVE,
recorded in `VERIFICATION.md` and `PROGRESS.md`. This pass adds a check on *claims and
framing*, which is the layer no prior stage checked.

---

## Calculation spot-checks — 20 of 20 tie

| Claim in the report | Recomputed | Result |
|---|---|---|
| Top-4 cohort = 507 clinicians | 176+151+65+115 = 507 | ✅ |
| Top-4 hold $317.6M | $317,640,958 | ✅ |
| = 54% of all outlier dollars | 54.1% of $587,147,319.57 | ✅ |
| 965 outliers = 5.1% of qualifying prescribers | 5.10% of 18,940 | ✅ |
| Outliers carry 22.1% of qualifying spend | 22.11% | ✅ |
| 29-fold median gap | 29.33× | ✅ |
| 467 + 498 = 965; 431 + 498 = 929 | exact | ✅ |
| 467 is 48% of 965 | 48.4% | ✅ |
| Mean × n = group total, both groups | $587.147M and $2,068.300M | ✅ exact |
| 965 + 17,975 = 18,940 qualifying | exact | ✅ |
| Excluded specialties = 2.3% of prescribers | 2.32% | ✅ |
| Excluded specialties = 3.0% of spend | 3.00%, derived independently from the F3 group totals against the $2.74B state total | ✅ **strong** — two figures computed in different places agree to 0.004pp |
| Top-20 generics = 45.5% | 45.7% from the rounded $1.25B | ✅ |
| Top-10 generics = 33.5% | 33.5% | ✅ |
| Top decile = 1,939 prescribers, 71.9% of spend | 1,939; 71.96% | ✅ |
| 20 of 1,177 generics = 1.7% | 1.70% | ✅ |

The report is internally consistent to a degree most student work is not — the
cross-check on excluded-specialty spend share, where 3.0% falls out of the F3 group
totals without being told to, is the strongest single piece of evidence that the
pipeline is sound.

---

## Issues found

### 1. HIGH — "Cost is plan-paid" is factually wrong

**Where:** Report §6 Limitations, second bullet. Check the memo and deck slide 13 for the
same phrasing.

**Currently:** *"Cost is plan-paid, not net. Tot_Drug_Cst is what CMS reports as paid."*

CMS's own methodology says the opposite of "plan-paid": total drug cost *"reflect[s] the
prescription drug costs incurred by Medicare Part D beneficiaries, including costs that
are paid by Medicare, by beneficiaries, and by third-party payers."* ResDAC breaks the
components out as ingredient cost + dispensing fee + sales tax + vaccine administration
fee, and confirms it excludes manufacturer rebates.

So it is a **gross, all-payer, point-of-sale** figure that includes beneficiary
cost-sharing — not a plan-paid figure. The rebate half of your sentence is correct; the
"plan-paid" half is not.

**Why it matters beyond pedantry:** you are a physician presenting to instructors who may
know this file. It is also the one factual claim in the report sourced from outside your
own data, which makes it the one most likely to be checked.

**Paste-ready replacement:**

```
Cost is gross, not net.  Tot_Drug_Cst is the point-of-sale cost of the prescription —
ingredient cost, dispensing fee, sales tax and any vaccine administration fee — summed
across everyone who paid it: the Part D plan, the beneficiary, government subsidies and
any third-party payer. It is not net of manufacturer rebates, so cross-drug comparisons
overstate the spread on heavily rebated brands.
```

---

### 2. MEDIUM-HIGH — two different "specialty cost per claim" numbers, undistinguished

**Where:** §4 Finding 1 versus §5 and the priority table.

Finding 1 says the most expensive qualifying specialty sits at **$2,272.07** per claim.
Section 5 then says Hematology-Oncology is at **$2,652**. Both are true and they are
different constructs: Finding 1 quotes the *median of prescriber-level* cost per claim;
the priority table quotes the *specialty-weighted* ratio (total specialty cost ÷ total
specialty claims). Nothing in the report says so.

An instructor reading straight through sees a number exceed a stated maximum eleven
paragraphs later. That is the single most likely "wait, explain this" moment in the
document, and the answer is entirely defensible — it just is not written down.

**Paste-ready — replace the priority-table caption:**

```
Priority segments ranked by outlier spend. Cost per claim in this table is
specialty-weighted (total specialty cost divided by total specialty claims), which is
why it runs higher than the prescriber-level medians quoted in Finding 1. Rows 1-4 are
the recommended first cohort. Source: FINDINGS.md, "Recommended priority segments."
```

---

### 3. MEDIUM — the column label "Dollars above own p95" does not mean what it says

**Where:** `FINDINGS.md` priority table, the report's §5 table, and the dashboard's
`Outlier Cost` field.

Read literally, "dollars above own p95" means *excess over a threshold*. The figures are
almost certainly *total drug cost of the prescribers who are above p95* — three lines of
evidence:

- F3 defines $587,147,319.57 as the **"Total cost"** of the 965 flagged prescribers. The
  report's "$317.6M = 54% of all outlier dollars" only ties if numerator and denominator
  share a definition, so the table must also be total cost.
- Mean total cost × n reproduces $587.147M exactly.
- As pure excess-over-threshold, Physician Assistant at 41.6% and Urology at 53.0% of
  specialty spend would be implausible. As total spend held by a specialty's top 5% on
  unit cost, both are ordinary.

**Two-minute check when you're back at the machine** — if these match, the label is the
only thing that needs changing:

```python
import pandas as pd
d = pd.read_csv(r"outputs\part_d_co_clean.csv", encoding="utf-8-sig", low_memory=False)
p = d.groupby(["Prscrbr_NPI","Prscrbr_Type"], as_index=False).agg(
        cost=("Tot_Drug_Cst","sum"), clms=("Tot_Clms","sum"))
p["cpc"] = p["cost"] / p["clms"]
big = p.groupby("Prscrbr_Type")["Prscrbr_NPI"].transform("size") >= 30
p = p[big]
p95 = p.groupby("Prscrbr_Type")["cpc"].transform(lambda s: s.quantile(0.95))
flag = p[p["cpc"] > p95]
print(flag.groupby("Prscrbr_Type")["cost"].sum().sort_values(ascending=False).head(8))
# Nurse Practitioner should print ~$109,343,136 if the column is TOTAL spend.
```

**Then rename the column** in `FINDINGS.md`, the report table and the Tableau field to
`Outlier spend (total drug cost of flagged prescribers)`. Nothing else changes — the
recommendation and every percentage stay exactly as they are.

---

### 4. MEDIUM — "Geography is off the table" claims more than the test supports

**Where:** §4 Finding 1, closing sentence.

Two gaps between the claim and the evidence:

- The test compares **60 city strings as published by CMS**, unnormalized. `QUESTIONS.md`
  Q1 logs 28 spelling variants across 1,856 rows — Grand Junction, Colorado Springs, Lone
  Tree and Fort Carson each split across multiple strings. Fragmenting a city
  *attenuates* a city effect, so an un-normalized test is biased toward the null you are
  reporting. Your conclusion is probably right; it is just being defended with the one
  test design that cannot fully establish it.
- City is not region. Your proposal promised *prescriber region*; Q3 (which Colorado
  regional scheme) was never resolved, so the delivered geography analysis is city-level.
  Rural/frontier/urban grouping is exactly the cut where a geography effect would show up
  if one exists, and it was not run.

Both are honest scope decisions. The fix is to narrow the sentence, not to run anything.

**Paste-ready replacement for the closing sentence of Finding 1:**

```
City-level geography is off the table as a targeting dimension. Two qualifications: this
tests the 60 city strings as CMS published them, without normalizing the 28 spelling
variants logged as Q1 in QUESTIONS.md, and it tests cities rather than a rural/urban or
multi-county regional grouping, which QUESTIONS.md Q3 leaves open. Both would have to be
settled before ruling geography out entirely.
```

---

### 5. MEDIUM — a proposal goal is delivered in SQL but absent from the findings

Your proposal lists five goals. Goal 5 — *"Determine whether patterns differ between the
under-65 and 65+ beneficiary populations"* — is built (`capstone_segmentation.sql`
Queries 9–10, per the Stage 2 note in `QUESTIONS.md`) but appears nowhere in Findings
F1–F5 or in §5. A grader marking R3 with the proposal beside the report will notice a
committed goal with no result.

The reason you didn't report it is good and is already in your notes: GE65 cost is
suppressed on 42.1% of rows, so the split covers $1.95B of $2.74B — 71% — and reporting
an age difference on that subset needs an imputation decision (Q9) you deliberately
declined to make silently. Say that, and the gap becomes evidence of discipline.

**Paste-ready — add as a bullet in §6 Limitations:**

```
The 65-and-over split was built but is not reported.  Queries 9 and 10 in
capstone_segmentation.sql split cost by age group, but the 65-and-over cost columns are
suppressed on 42.1% of rows, so the split covers $1.95 billion of the $2.74 billion
state total. Reporting an age-group difference on a 71%-complete subset would have
required an imputation decision, which is logged as Q9 in QUESTIONS.md and was left
undecided rather than defaulted.
```

---

## Bias and pitfall review

Checked against the standard catalog. Three worth knowing about; none invalidate anything.

**Cleared:**

- **Circular segmentation** — the flag is built on cost per claim, and F3 deliberately
  tests *total cost* instead. You call this out in the report. This is the pitfall most
  student analyses walk straight into, and you sidestepped it on purpose.
- **Average of averages** — specialty cost per claim is a ratio of sums, not a mean of
  means. Correct.
- **Outliers distorting the center** — medians lead throughout, with a rank-based test
  chosen off the observed skew rather than by default.
- **Survivorship / who's missing** — the ≥11-claim floor and the ≥30-prescriber rule are
  both stated with their exact coverage cost (2.3% of prescribers, 3.0% of spend).
- **Significance mistaken for importance** — explicitly refused: *"with roughly 19,000
  prescribers almost anything rejects the null."* That paragraph is the strongest
  analytical writing in the report.

**Live, and worth a prepared answer:**

1. **The top-4 cohort is also the four largest specialties.** A 5%-per-specialty rule
   produces outlier counts proportional to specialty size — 176/3,509, 151/3,010,
   65/1,292, 115/2,288 are all exactly 5.0%. So ranking by outlier *dollars* structurally
   favors big specialties. Your §5 argument defends the choice on unit cost ($73–$147),
   not size, and the "% of specialty spend" column varies 11.7% → 41.6%, which shows the
   ranking is not purely mechanical. Be ready to say that out loud, because "aren't these
   just your biggest specialties?" is the obvious challenge.
2. **Flag counts don't land on 5% exactly** — 929 statewide and 965 within-specialty
   against an expected 947. Strict `>` comparison plus ties plus per-specialty quantile
   interpolation. Normal, but know the reason before someone asks.
3. **Kruskal–Wallis with 584-fold spread between group medians** tests stochastic
   dominance rather than a clean median comparison when group shapes differ this much.
   You avoid the trap in practice by leading with effect size instead of the p-value, so
   this is a nuance to acknowledge, not a flaw to fix.

---

## Narrative and conclusions

Conclusions are supported by what's shown, and the confidence level matches the evidence
— particularly the F1 refusal to treat significance as importance, and the limitations
section's insistence that a statistical outlier is "a reason to look at a chart, not an
accusation." The recommendation follows from the findings rather than sitting beside
them, and the second-tier Urology call and the three deprioritizations show the framework
being applied *against* the headline ranking, which is what distinguishes analysis from
a sorted table.

One presentational note: the report leads with the answer in the Summary and never
oversells it. Keep that in the live delivery.

---

## Priority order for the next fifteen minutes

| # | Fix | Where | Time |
|---|---|---|---|
| 1 | "Cost is gross, not net" replacement | Report §6, memo, deck slide 13 | 4 min |
| 2 | Priority-table caption — weighted vs median | Report §5 | 2 min |
| 3 | Narrow the geography sentence | Report §4, Finding 1 | 2 min |
| 4 | Add the 65-and-over limitation bullet | Report §6 | 2 min |
| 5 | Run the label check, rename the column if it confirms | FINDINGS.md, report table, Tableau field | 5 min |

Then the two items already on `00_START_HERE.md`: open the `.twbx` in Tableau and save
it once, and rehearse.

---

## Required caveats — say these unprompted in the live delivery

- Cost is gross point-of-sale across all payers and not net of rebates, so cross-drug
  comparisons overstate spread on rebated brands.
- No per-patient rate exists anywhere in the analysis — beneficiary counts are suppressed
  on 58.9% of rows.
- A within-specialty outlier is a statistical outlier. It is a reason to look at a chart,
  not a finding of waste.
- Geography was tested at city level only, on CMS's raw city strings, and a regional
  grouping was never built.
- One state, one year. No trend, no national benchmark.

**Sources:** [ResDAC — Total Drug Cost (Part D)](https://resdac.org/cms-data/variables/total-drug-cost-part-d) · [CMS — Medicare Part D Prescribers Datasets: A Methodological Overview](https://data.cms.gov/sites/default/files/2023-05/MUP_DPR_RY23_20230424_Methodology_508.pdf) · [CMS — Medicare Part D Prescribers by Provider and Drug](https://data.cms.gov/provider-summary-by-type-of-service/medicare-part-d-prescribers/medicare-part-d-prescribers-by-provider-and-drug)
