# START HERE — Capstone Submission Pack

**Colorado Medicare Part D Prescribing Pattern Analysis — Caleb Edwards**
Due Thu 2026-08-13, 4:00 PM MDT. Last updated after the validation pass, the Tableau rebuild, and a voice pass on the report.

Everything in this folder is submission-ready and has been through a QA pass. The parent
`outputs\` folder is the working folder — process logs, superseded charts, the 60–72 MB
data files. Nothing in here needs editing before you submit, with one exception (item 1).

---

## 1. Do these two things before you submit

| # | Task | Time | Why |
|---|---|---|---|
| 1 | ~~Open the Tableau workbook~~ **DONE.** | — | The hand-authored workbook would not load in Tableau Desktop. Rebuilt from `tableau_prescriber_segments.csv` and saved as `CO Medicare Part D Dashboard.twbx`; a screenshot of it is now slide 13 of the deck. |
| 2 | **Rehearse the deck out loud, twice, on a timer, using `PRESENTATION_NOTES.md`.** | 30–40 min | Rubric lines R6 + R7 are **25 of 130 points** and no file can earn them. Target 10–15 min; the notes are timed to 12. |

---

## 2. What to submit

Three components per the assignment instructions:

1. **Comprehensive Analytics Report** → `Edwards_Caleb_Capstone_Report.docx` (10 pages)
2. **Presentation Slide Deck** → `Edwards_Caleb_Capstone_Deck.pptx` (15 slides, full speaker notes)
3. **Demo Day live presentation** → you, on Zoom, with `PRESENTATION_NOTES.md` in front of you

Everything else here is the **supporting artifact pack** the rubric asks for under R1
("data collection plan, cleaning documentation, statistical outputs, methodology
explanations, supporting materials"). If the portal takes one file, upload
`outputs\Edwards_Caleb_Capstone_Submission.zip`.

---

## 3. File index

### Graded deliverables

| File | What it is | Rubric |
|---|---|---|
| `Edwards_Caleb_Capstone_Report.docx` | The report. Business question, data collection and prep, methodology, four findings, recommendations, limitations, plus a 2-page artifact appendix. | R1, R3, R4, R5 |
| `Edwards_Caleb_Capstone_Deck.pptx` | 15 slides, 6 seaborn charts plus the Tableau dashboard on slide 13, speaker notes on every slide. | R2, R6, R8 |
| `PRESENTATION_NOTES.md` | Timed 12-minute talk track, slide-by-slide, with eight anticipated questions and answers. Also in `outputs\Presentation\`. | R6, R7 |
| `RECOMMENDATION_MEMO.docx` | One page, addressed to a health-system population health leadership team. | R5 |
| `CO Medicare Part D Dashboard.twbx` | Tableau executive dashboard — 3 worksheets + 1 dashboard with a filter action, extract packaged inside. `CO Part D Review Priorities.pdf` is a static export of it. | R8 |

### Analysis and code (the four-tool pipeline from the proposal)

| File | What it is | Tool |
|---|---|---|
| `CAPSTONE_EXCEL_AGGREGATES.xlsx` | Aggregate tables from the raw extract. Ties to $2,737,455,388.61 and 16,573,710 claims on every sheet. | Excel |
| `part_d_profiling.sql` | 35 commented profiling queries establishing shape, completeness, suppression. | SQL |
| `capstone_segmentation.sql` | Segmentation, cost-percentile window functions (`NTILE()`), outlier identification. | SQL |
| `capstone_analysis.ipynb` | 23 code cells, clean-kernel run, zero errors. ANOVA / Kruskal–Wallis + within-specialty percentile ranking. | Python |
| `tableau_prescriber_segments.csv` | 18,940-row prescriber-level extract feeding the dashboard. Fallback if the `.twbx` won't open. | Tableau |
| `charts\` | The complete 7-figure set, all seaborn. Six are embedded in the deck. | Python |
| `build_scripts\` | Every deliverable here is regenerable from the raw CSV by running these in order. | — |

### Documentation

| File | What it is |
|---|---|
| `CLEANING.md` | Ten cleaning steps, each with rows-before / rows-after. Reconciles 390,473 in → 390,473 out. |
| `FINDINGS.md` | The findings of record — F1–F5, the priority-segment table, the limits table. Every number in the report and deck traces here. |
| `STATS_OUTPUT.md` | Descriptive statistical output, paste-ready tables. |
| `SQL_RESULTS.md` | Raw query output for every SQL statement. |
| `QUESTIONS.md` | Fifteen open data questions raised during analysis and deliberately left undecided rather than silently defaulted. A rigor artifact, not a to-do list. |

`outputs\VALIDATION_REPORT.md` holds the full QA pass — 20 calculation spot-checks, the
bias review, and the five issues that were found and fixed.

---

## 4. What the validation pass changed

A pre-submission QA pass recomputed every arithmetic claim (20 of 20 tie) and checked the
report's factual claims against CMS's published documentation. No numbers changed. Five
wording issues were found and fixed across the report, deck, memo and `FINDINGS.md`:

| # | Was | Now |
|---|---|---|
| 1 | "Cost is plan-paid, not net" | "Cost is gross, not net" — CMS's methodology says total drug cost includes what Medicare, **beneficiaries**, and third parties paid. It was never a plan-paid figure. |
| 2 | Finding 1 said max specialty cost per claim is $2,272; §5 said Hem-Onc is $2,652 | Both are correct — one is a prescriber-level median, the other specialty-weighted. Now labeled, in both the report and on slide 12. |
| 3 | Column header "Dollars above own p95" | "Spend flagged" — it is the total drug cost held by flagged prescribers, not an excess over a threshold. The memo already defined it this way. |
| 4 | "Geography is off the table as a targeting dimension" | Narrowed to city-level, with the un-normalized city strings (Q1) and the untested regional grouping (Q3) named. |
| 5 | Proposal goal 5 (under-65 vs 65+) delivered in SQL, absent from findings | Added to §6 Limitations and the Limits slide's source line: built, but 42.1% suppressed, so Q9 was left undecided rather than defaulted. |

---

## 5. Two things to be ready to say out loud

Both are in the report and on the deck. An instructor may ask.

1. **"The proposal said regression. Where is it?"**
   One-way ANOVA plus Kruskal–Wallis replaced it, because the course never taught
   regression beyond `sns.regplot()` — no coefficient tables, no R², no statsmodels or
   scikit-learn. Both are taught in Advanced Pandas II and answer the same question. The
   substitution is stated openly in report §3, on slide 6, and in `FINDINGS.md`.

2. **"Are these prescribers doing something wrong?"**
   No — and the analysis cannot say that. No diagnoses, no severity, no panel
   composition. A within-specialty outlier is a *statistical* outlier: a reason to look,
   not a finding of waste. That sentence closes the memo for a reason.

`PRESENTATION_NOTES.md` has six more anticipated questions with answers.

---

## 6. What was deliberately left out of this folder

Kept in `outputs\` and not part of the submission pack: process files (`PROGRESS.md`,
`CALIBRATION.md`, `REQUIREMENTS.md`, `VERIFICATION.md`, `RUN_LOG.md`,
`PREGAME_RESEARCH.md`, the `*_FLAGS.md` set), superseded exploratory work
(`part_d_analysis.ipynb`, `PY_RESULTS.md`, `regression_output.csv`,
`CAPSTONE_AGGREGATES.xlsx`, `CAPSTONE_PROFILE.xlsx`, `CITY_REFERENCE.xlsx`,
`charts\superseded\`), and the two large data files (`part_d_co_clean.csv` 72 MB,
`part_d.sqlite` 60 MB) which are reproducible from the raw CSV via `build_scripts\`.

The report's appendix describes the full `outputs\` folder, so it references files not in
here. That is intentional — the appendix documents the whole project; this folder is the
graded subset.

`QUESTIONS.md` is the only file whose copy differs from its original: its first line was
changed from an internal working-file label to a submission label. Content is identical.
