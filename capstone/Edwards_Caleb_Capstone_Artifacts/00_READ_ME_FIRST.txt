This archive is the artifact pack described in the report's Appendix - Artifacts.

Two files named in the appendix are omitted for size:
  part_d_co_clean.csv  (72 MB)  - the cached clean file
  part_d.sqlite        (60 MB)  - the SQL system of record
Both regenerate from Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv by
running build_scripts/load_part_d.py and build_scripts/build_excel_aggregates.py,
reading the raw CSV with encoding='utf-8-sig'. Everything else in the appendix is here.

Start with 00_START_HERE.md.
