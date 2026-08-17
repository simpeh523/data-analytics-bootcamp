CATEGORY: COWORK-ONLY — working file. The scope contract for Stages 1–6. Never submitted.

# REQUIREMENTS — Rubric Coverage Map

Sources: `capstone assignment rubric.pdf` (Canvas rubric, **130 points**, 8 graded
lines) and `Data Analytics Capstone instructions.pdf` (3 deliverable components).
Due **Thu 2026-08-13, 4:00 PM MDT**.

The instructions define three deliverables — Comprehensive Analytics Report, Slide
Deck, Live Demo Day presentation. The rubric grades those three across 8 lines.

## Graded rubric lines

| # | Rubric line | Pts | What "Excellent" requires | Satisfying artifact | Status |
|---|---|---|---|---|---|
| R1 | **Submission** — completion and submission of all required deliverables (report) | 25 | Complete report with intro, data collection/preparation, analytical process, findings, recommendations. **Plus artifacts**: data collection plan, cleaning documentation, statistical outputs, methodology explanations, supporting materials. | Capstone report (`.docx`) + appendix pack: `CLEANING.md`, `STATS_OUTPUT.md`, `SQL_RESULTS.md`, Python results, `CAPSTONE_AGGREGATES.xlsx`, `part_d_profiling.sql` | **TO BUILD** (report) / **REUSABLE** (artifacts) |
| R2 | **Submission** — completion and submission of all required deliverables (slide deck) | 25 | Slide deck with clear storytelling, professional visual design, effective data visualizations, actionable recommendations, supporting visual elements. | Capstone deck (`.pptx`) | **TO BUILD** |
| R3 | **Analysis** — problem definition and data approach | 15 | Clear, well-defined business challenge/research question. Appropriate data selection strategy aligned to objectives. Real-world application understood. | Report §1–§2, sourced from `Edwards_Caleb_CapstoneProposal.docx` | **TO BUILD** (proposal text is the input, not the deliverable) |
| R4 | **Analysis** — methodology and rigor | 20 | Sophisticated methodology appropriate to the problem. Clear documentation of preparation, cleaning, analysis steps. Evidence of **proper statistical/analytical techniques**. Methodology reproducible and well-justified. | `CLEANING.md` ✅ · `part_d_profiling.sql` ✅ · Python analysis notebook ⚠️ · report methodology section | **REUSABLE** (cleaning, SQL) / **TO BUILD** (Python analysis on taught methods) |
| R5 | **Analysis** — insights and recommendations | 15 | Clear, actionable insights that directly address the business problem. Well-supported recommendations with clear reasoning. Real-world implications and next steps. | Findings section of report + recommendation memo | **TO BUILD** — nothing in `outputs\` contains interpretation yet, by design |
| R6 | **Presentation** — live delivery content | 15 | 10–15 min covering business problem, analytical process, key findings, recommendations. Appropriate for an audience with no prior knowledge. Logical flow, strong storytelling. | Speaker notes on the deck + rehearsal | **TO BUILD** |
| R7 | **Presentation** — delivery, pace, professionalism | 10 | Confident, clear delivery. Professional demeanor. Effective use of visual aids. | Caleb, live on Zoom | **TO BUILD** (not a file — rehearsal) |
| R8 | **Presentation** — visual design and data visualization | 5 | Professional, polished visual design. Highly effective visualizations using appropriate tools (Tableau, Python, etc.). | Tableau dashboard + chart set embedded in the deck | **TO BUILD** |

**Total: 130 pts.**

## Instruction-level components mapped to rubric lines

| Instructions component | Rubric lines | Status |
|---|---|---|
| 1. Comprehensive Analytics Report (5 required sections + artifact inclusion) | R1, R3, R4, R5 | TO BUILD; artifacts REUSABLE |
| 2. Presentation Slide Deck (storytelling, design, **data visualization component**, recommendations, supporting charts) | R2, R8 | TO BUILD |
| 3. Demo Day live presentation (Zoom, 10–15 min, no-prior-knowledge audience) | R6, R7 | TO BUILD |

## Proposal-committed deliverables (scope is fixed by the proposal — do not expand)

| Proposal deliverable | Current state | Status |
|---|---|---|
| Excel aggregate tables tying back to the raw extract | `CAPSTONE_AGGREGATES.xlsx` — verified, ties to $2,737,455,388.61 across all four sheets | **DONE** |
| SQL script: segmentation, cost-percentile window functions, outlier identification, commented logic | `part_d_profiling.sql` — 35/35 queries run and match; commented. Uses `CASE`/`CAST`/`CEIL`, which are off-syllabus | **REUSABLE with edits** — swap off-syllabus constructs for `NTILE()` / `*1.0` per CALIBRATION.md B2 |
| Python notebook: trend analysis and regression identifying which dimensions drive cost | `part_d_analysis.ipynb` — runs clean and reproduces byte-identically, but the regression method is off-syllabus | **TO BUILD** — re-do the "which dimension matters" answer with ANOVA / Kruskal–Wallis + group spreads (CALIBRATION.md B1) |
| Tableau executive dashboard | Not started | **TO BUILD** |
| 1-page written recommendation memo | Not started | **TO BUILD** |

## Coverage gaps to close, in priority order

1. **R5 (15 pts) has zero coverage.** No interpretation exists anywhere in `outputs\` —
   Stages 0–2 forbade it. This is the single largest unearned block relative to effort.
2. **R1 + R2 (50 pts, 38% of the grade) are pure submission-completeness.** The report
   and deck must simply *exist and be complete*. Cheapest points on the rubric.
3. **R4 (20 pts) is half-earned already.** `CLEANING.md` and the SQL cover
   "documentation of preparation, cleaning, analysis steps" at an Excellent standard.
   The exposure is "proper statistical/analytical techniques" — currently satisfied by
   an off-syllabus regression.
4. **R8 is only 5 pts.** Tableau is proposal-committed, so it gets built, but it does
   not warrant elaboration beyond one dashboard.
