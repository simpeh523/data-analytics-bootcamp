"""
run_segmentation_sql.py — Stage 2 plumbing script.

WHAT IT DOES
    Opens outputs/part_d.sqlite read-only, runs each of the ten queries in
    outputs/capstone_segmentation.sql, and prints every result as a markdown table.
    Redirect the output to append it to SQL_RESULTS.md.

WHY IT EXISTS
    So the Stage 2 result tables can be regenerated on demand instead of being
    hand-pasted. This is plumbing, not analysis — no number in it is computed here;
    every figure comes out of the SQL file.

    The .sql file also runs on its own with no edits:
        sqlite3 part_d.sqlite < capstone_segmentation.sql

HOW TO RUN
    python run_segmentation_sql.py > stage2_tables.md

IMPORTS
    sqlite3 and pathlib only — both on the CALIBRATION.md taught list.
"""

import sqlite3
from pathlib import Path

HERE = Path(__file__).parent
DB = HERE / "part_d.sqlite"
SQL = HERE / "capstone_segmentation.sql"
MARKER = "-- ==== QUERY "


def strip_comments(block):
    """Remove -- comments so a semicolon inside a comment cannot split a statement."""
    lines = []
    for line in block.splitlines():
        if "--" in line:
            line = line[: line.index("--")]
        lines.append(line)
    return "\n".join(lines)


def format_value(value):
    """Thousands separators for numbers; blank for NULL; text passed through."""
    if value is None:
        return ""
    if isinstance(value, float):
        return f"{value:,.2f}".rstrip("0").rstrip(".")
    if isinstance(value, int):
        return f"{value:,}"
    return str(value)


def main():
    sql_text = SQL.read_text(encoding="utf-8")
    connection = sqlite3.connect(f"file:{DB}?mode=ro", uri=True)

    # Split the file into its ten commented query blocks.
    for block in sql_text.split(MARKER)[1:]:
        title = block.split("====")[0].strip()
        body = block[block.index("====") + 4:]
        statements = [s.strip() for s in strip_comments(body).split(";") if s.strip()]

        for statement in statements:
            cursor = connection.execute(statement + ";")
            columns = [d[0] for d in cursor.description]
            rows = cursor.fetchall()

            number, heading = title.split("|", 1)
            print(f"### Query {number.strip()} — {heading.strip()}\n")
            print(f"Rows returned: {len(rows)}\n")
            print("| " + " | ".join(columns) + " |")
            print("|" + "|".join(["---"] * len(columns)) + "|")
            for row in rows:
                print("| " + " | ".join(format_value(v) for v in row) + " |")
            print()

    connection.close()


if __name__ == "__main__":
    main()
