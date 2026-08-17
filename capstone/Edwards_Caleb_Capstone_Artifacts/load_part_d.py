r"""
Loader: builds outputs\part_d.sqlite from the source CSV.

No cleaning, no coercion beyond SQLite's native column-affinity typing.
Values are inserted exactly as read from the CSV (empty string stays
empty string, never converted to NULL) so that NULL-vs-empty-string
counts in the profiling SQL reflect the source data as-is.
"""
import csv
import os
import sqlite3

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CSV_PATH = os.path.join(BASE_DIR, "Medicare_Part_D_Prescribers_by_Provider_and_Drug_2024.csv")
DB_PATH = os.path.join(BASE_DIR, "outputs", "part_d.sqlite")

SCHEMA = """
CREATE TABLE part_d (
    Prscrbr_NPI            TEXT,
    Prscrbr_Last_Org_Name  TEXT,
    Prscrbr_First_Name     TEXT,
    Prscrbr_City           TEXT,
    Prscrbr_State_Abrvtn   TEXT,
    Prscrbr_State_FIPS     TEXT,
    Prscrbr_Type           TEXT,
    Prscrbr_Type_Src       TEXT,
    Brnd_Name              TEXT,
    Gnrc_Name              TEXT,
    Tot_Clms               REAL,
    Tot_30day_Fills        REAL,
    Tot_Day_Suply          REAL,
    Tot_Drug_Cst           REAL,
    Tot_Benes              REAL,
    GE65_Sprsn_Flag        TEXT,
    GE65_Tot_Clms          REAL,
    GE65_Tot_30day_Fills   REAL,
    GE65_Tot_Drug_Cst      REAL,
    GE65_Tot_Day_Suply     REAL,
    GE65_Bene_Sprsn_Flag   TEXT,
    GE65_Tot_Benes         REAL
);
"""

BATCH_SIZE = 20000


def main():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.executescript(SCHEMA)

    insert_sql = f"INSERT INTO part_d VALUES ({','.join(['?'] * 22)})"

    with open(CSV_PATH, encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f)
        header = next(reader)
        assert len(header) == 22, f"expected 22 columns, got {len(header)}"

        batch = []
        total = 0
        for row in reader:
            batch.append(row)
            if len(batch) >= BATCH_SIZE:
                cur.executemany(insert_sql, batch)
                total += len(batch)
                batch = []
        if batch:
            cur.executemany(insert_sql, batch)
            total += len(batch)

    conn.commit()

    row_count = cur.execute("SELECT COUNT(*) FROM part_d").fetchone()[0]
    print(f"Loaded {row_count} rows into {DB_PATH}")
    assert row_count == total

    conn.close()


if __name__ == "__main__":
    main()
