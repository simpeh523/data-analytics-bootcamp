-- Title: SQL Public Library Management
-- Code Editor: VSCode w/SQLite Viewer Extension
-- Database: sqlite3 SQL_Public_Library_Management.db

-- DATABASE SCHEMA
PRAGMA foreign_keys = ON;

-- Level 0: no dependencies
CREATE TABLE Branches (
    branch_id   INTEGER PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address     VARCHAR(200),
    city        VARCHAR(100),
    phone       VARCHAR(20)
);

CREATE TABLE Genres (
    genre_id    INTEGER PRIMARY KEY,
    genre_name  VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE Authors (
    author_id  INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birth_year INTEGER,
    country    VARCHAR(50)
);

-- Level 1: depend on Level 0
CREATE TABLE Patrons (
    patron_id         INTEGER PRIMARY KEY,
    first_name        VARCHAR(50) NOT NULL,
    last_name         VARCHAR(50) NOT NULL,
    email             VARCHAR(100),
    address           VARCHAR(200),
    city              VARCHAR(100),
    registration_date DATE,
    branch_id         INTEGER,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Books (
    book_id          INTEGER PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    author_id        INTEGER,
    genre_id         INTEGER,
    isbn             VARCHAR(20),
    publication_year INTEGER,
    copies_owned     INTEGER,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (genre_id)  REFERENCES Genres(genre_id)
);

-- Level 2: depends on Level 1
CREATE TABLE Loans (
    loan_id       INTEGER PRIMARY KEY,
    book_id       INTEGER,
    patron_id     INTEGER,
    branch_id     INTEGER,
    checkout_date DATE,
    due_date      DATE,
    return_date   DATE,  -- nullable: 12 of 30 loans are unreturned; .import writes blanks as '' (empty string), not NULL
    FOREIGN KEY (book_id)   REFERENCES Books(book_id),
    FOREIGN KEY (patron_id) REFERENCES Patrons(patron_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

.mode csv
.import --skip 1 wk6-wkshop-branches.csv Branches
.import --skip 1 wk6-wkshop-genres.csv Genres
.import --skip 1 wk6-wkshop-authors.csv Authors
.import --skip 1 wk6-wkshop-patrons.csv Patrons
.import --skip 1 wk6-wkshop-books.csv Books
.import --skip 1 wk6-wkshop-loans.csv Loans

SELECT 'Branches', COUNT(*) FROM Branches UNION ALL
SELECT 'Genres', COUNT(*) FROM Genres UNION ALL
SELECT 'Authors', COUNT(*) FROM Authors UNION ALL
SELECT 'Patrons', COUNT(*) FROM Patrons UNION ALL
SELECT 'Books', COUNT(*) FROM Books UNION ALL
SELECT 'Loans', COUNT(*) FROM Loans;
-- Expected output seen: 8 / 8 / 14 / 16 / 20 / 30 rows respectively


-- Workshop Tasks
-- Part 1: Basic SQL Operations and JOIN Queries
-- 1. Basic Selection: Retrieve the titles and publication years of all books published after 2000, ordered by publication year (newest first)
SELECT 
    title, 
    publication_year
FROM Books
WHERE publication_year > 2000
ORDER BY publication_year DESC;

-- 2. Filtering: Find all books with more than 5 copies owned in the fiction genre (genre_id = 1).
SELECT title
FROM Books
WHERE genre_id = 1
  AND copies_owned > 5;

-- 3. Pattern Matching: List all books whose titles contain the word "History".
SELECT title
FROM Books
WHERE title LIKE '%History%';

-- 4. JOIN Operations: Display loan information (loan_id, checkout_date, due_date) along with patron details (first_name, last_name, email) for all loans made in January 2023.
SELECT
    l.loan_id,
    l.checkout_date,
    l.due_date,
    p.first_name,
    p.last_name,
    p.email
FROM Loans l
LEFT JOIN Patrons p
    ON l.patron_id = p.patron_id
WHERE l.checkout_date BETWEEN '2023-01-01' AND '2023-01-31';

-- 5. Multi-table JOIN: Show book details (title, author's full name, genre_name) for each loan, along with the checkout_date and due_date.
SELECT
    bk.title,
    a.first_name || ' ' || a.last_name AS author_full_name,
    g.genre_name,
    l.checkout_date,
    l.due_date
FROM Loans l
LEFT JOIN Books bk
    ON l.book_id = bk.book_id
LEFT JOIN Authors a 
    ON bk.author_id = a.author_id
LEFT JOIN Genres g  
    ON bk.genre_id = g.genre_id
ORDER BY l.loan_id;

-- 6. Self JOIN: Find pairs of patrons who live in the same city. Show both patrons' names and their city.
SELECT 
    p1.first_name || ' ' || p1.last_name AS patron_1,
    p2.first_name || ' ' || p2.last_name AS patron_2,
    p1.city
FROM Patrons p1
INNER JOIN Patrons p2
    ON p1.city = p2.city
    AND p1.patron_id < p2.patron_id
ORDER BY p1.city;

-- 7. Multi-table JOIN with filtering: Find all fiction books (genre_id = 1) that have been borrowed, along with the patron name and the branch where they were borrowed from.
SELECT 
    bk.title,
    p.first_name || ' ' || p.last_name AS patron_full_name,
    br.branch_name
FROM Loans l
LEFT JOIN Books bk
    ON l.book_id = bk.book_id
LEFT JOIN Patrons p
    ON l.patron_id = p.patron_id
LEFT JOIN Branches br
    ON l.branch_id = br.branch_id
WHERE bk.genre_id = 1
ORDER BY bk.title;

-- Part 2: Aggregation and GROUP BY Operations
-- 8. COUNT aggregation: Count the number of books in each genre category.
SELECT 
    g.genre_name, 
    COUNT(bk.book_id) AS book_count
FROM Genres g
LEFT JOIN Books bk 
    ON g.genre_id = bk.genre_id
GROUP BY g.genre_id
ORDER BY book_count DESC;

-- 9. Multiple aggregations: Calculate the average, minimum, and maximum loan duration (days between checkout and return) for each library branch. Include only returned books.
SELECT
    br.branch_name,
    MIN(julianday(l.return_date) - julianday(l.checkout_date)) AS min_checkout_days,
    AVG(julianday(l.return_date) - julianday(l.checkout_date)) AS avg_checkout_days,
    MAX(julianday(l.return_date) - julianday(l.checkout_date)) AS max_checkout_days
FROM Loans l
LEFT JOIN Branches br 
    ON l.branch_id = br.branch_id
WHERE l.return_date IS NOT NULL 
    AND l.return_date <> ''
GROUP BY br.branch_name;

-- 10. Conditional aggregation: Find patrons with overdue books (due_date < CURRENT_DATE and return_date = ' '), along with the count of overdue books they have.
SELECT 
    p.first_name, 
    p.last_name, 
    COUNT(l.loan_id) AS overdue_book_count
FROM Loans l
LEFT JOIN Patrons p 
    ON l.patron_id = p.patron_id
WHERE l.due_date < CURRENT_DATE
    AND l.return_date = ''
GROUP BY p.patron_id
ORDER BY overdue_book_count DESC;

-- 11. Time-based analysis: Analyze monthly borrowing trends. Show the year, month, number of loans, and number of unique patrons for each month.
SELECT 
    strftime('%Y', checkout_date) AS loan_year,
    strftime('%m', checkout_date) AS loan_month,
    COUNT(loan_id) AS loan_count,
    COUNT(DISTINCT patron_id) AS unique_patrons
FROM Loans
GROUP BY loan_year, loan_month
ORDER BY loan_year;

-- BONUS: Write a query to create a simple data dictionary for the library database schema, listing table names, column names, data types, and whether they are primary keys.
SELECT 
    m.name AS table_name,                                           
    ti.name AS column_name,                                         
    ti.type AS data_type,                                           -- declared data type in pragma_table_info
    CASE WHEN ti.pk > 0 THEN 'YES' ELSE 'NO' END AS is_primary_key  -- ti.pk is for whether or not primary key in pragma_table_info
FROM sqlite_master m                                                -- holds table/object names + schema metadata (not the db filename)
JOIN pragma_table_info(m.name) ti                                   -- pulls each table's columns by passing table name into pragma
WHERE m.type = 'table'
ORDER BY m.name, ti.cid;


-- Discussion Questions
/* 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Q1. In our library database, we track which branch a book was borrowed from, but books can exist at multiple branches. How would you modify the schema to track the actual inventory at each branch?
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
I would modify the schema by adding a Junction Table with a composite primary key that combines two or more foreign keys in other tables.
This allows for many-to-many relationships such that multiple instances of table1 can be linked to a single instance of table2 and multiple instances of table2 to single instance of table1
Example: a Junction table Branch_Inventory with columns branch_inventory_id, branch_copies_owned, branch_copies_available
    PK (branch_inventory_id) is a composite of PKs in branches and books tables that allows them to be foreign keys that are paired together in Branch_Inventory table
    From there, count of copies_owned grouped by branch should allow for branch_copies_owned to be created
    branch_copies_available can be also derived from known branch_copies_owned by subtracting a count of copies loaned at each branch with a JOIN to Loans
*/


/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------
   Q2. Based on the provided data model, what business questions could library administrators answer using SQL queries that we haven't covered in our exercise?
----------------------------------------------------------------------------------------------------------------------------------------------------------------
What authors and genres are most often borrowed in comparison to our current stock?
Why: guides inventory decisions such as whether to acquire more by a given author/genre or reduce copies of titles that sit unused or to consider ways of increasing demand for underperforming titles
*/
WITH author_stock AS (
    SELECT 
        bk.author_id, 
        SUM(bk.copies_owned) AS total_copies
    FROM Books bk
    GROUP BY bk.author_id
),
author_demand AS (
    SELECT 
        bk.author_id, 
        COUNT(l.loan_id) AS total_loans
    FROM Books bk
    LEFT JOIN Loans l 
        ON bk.book_id = l.book_id
    GROUP BY bk.author_id
)
SELECT
    a.first_name,
    a.last_name,
    aus.total_copies,
    aud.total_loans,
    ROUND(CAST(aud.total_loans AS REAL) / aus.total_copies, 2) AS loan_to_copy_ratio
FROM author_stock aus
INNER JOIN author_demand aud
    ON aus.author_id = aud.author_id
INNER JOIN Authors a
    ON a.author_id = aus.author_id
ORDER BY loan_to_copy_ratio DESC;
-- Example Result: Virginia Woolf leads at 0.67 loans per copy; García Márquez and Tolstoy are tied for second at 0.50.  Harari and Christie sit at the bottom (0.21, 0.24), despite two of the two deepest catalogs
-- Associated Action: Acquire additional Woolf, García Márquez, and Tolstoy titles.  Flag  Harari and Christie titles as first books for removal in event of downsizing

WITH genre_stock AS (
    SELECT 
        bk.genre_id, 
        SUM(bk.copies_owned) AS total_copies
    FROM Books bk
    GROUP BY bk.genre_id
),
genre_demand AS (
    SELECT 
        bk.genre_id, 
        COUNT(l.loan_id) AS total_loans
    FROM Books bk
    LEFT JOIN Loans l 
        ON bk.book_id = l.book_id
    GROUP BY bk.genre_id
)
SELECT
    g.genre_name,
    gs.total_copies,
    gd.total_loans,
    ROUND(CAST(gd.total_loans AS REAL) / gs.total_copies, 2) AS loan_to_copy_ratio
FROM genre_stock gs
INNER JOIN genre_demand gd
    ON gs.genre_id = gd.genre_id
INNER JOIN Genres g
    ON g.genre_id = gs.genre_id
ORDER BY loan_to_copy_ratio DESC;
-- Example Result: Fiction leads at 0.39 loans per copy on 36 copies — highest turnover on the largest holding. Fantasy is lowest at 0.19 on 16 copies
-- Associated Action: Expand Fiction selection seeing as it has the most demand per copy, despite already being deepest category.  Consider efforts to increase demand for Fantasy titles
-- Note: History and Poetry genres each have zero copies, making the ratio undefined and this not returned in query results
/*
Which branches have the longest average loan duration?
Why: flags enforcement behavior differences across locations and showcases when one branch drifts from the norm for further investigation
*/
SELECT
    br.branch_name,
    ROUND(AVG(julianday(l.return_date) - julianday(l.checkout_date)), 1) AS avg_loan_days
FROM Loans l
INNER JOIN Branches br 
    ON l.branch_id = br.branch_id
WHERE l.return_date IS NOT NULL 
    AND l.return_date <> ''
GROUP BY br.branch_id
ORDER BY avg_loan_days DESC;
-- Example Result: Riverside Library/South Branch/North County lead at 13.0 loan days on average; East Branch has lowest at 10.0 days
-- Associated Action: Investigate local conditions at the three flagged libraries currently as well as avg_loan_days at earlier time periods to assess finding durability over time

/*
What's the gap between patron registration and their last loan?
Why: provides signal for overall churn with respect to patron usage churn-risk signal, particularly as patron base grows and drop-off becomes uneven
*/
SELECT
    p.first_name,
    p.last_name,
    p.registration_date,
    MAX(l.checkout_date) AS last_loan_date,
    CAST(julianday(MAX(l.checkout_date)) - julianday(p.registration_date) AS INT) AS days_reg_to_last_loan
FROM Patrons p
LEFT JOIN Loans l 
    ON p.patron_id = l.patron_id
GROUP BY p.patron_id
ORDER BY days_reg_to_last_loan DESC;
-- Example Result: John Smith tops out at 391 days between registration and last checkout (February 10th, 2023)
-- Associated Action: Check if John Smith still library member.  Reach out re: renewal if not/provide gentle reminder if yes

/*
Do we have all genres covered in overall book catalog?
-- Why: flags genres that are catalog-thin regardless of demand, useful for diversification/acquisition planning on its own
*/
SELECT
    g.genre_id, 
    g.genre_name,
    COUNT(DISTINCT bk.book_id) AS num_titles,
    COUNT(l.loan_id) AS total_loans
FROM Genres g
LEFT JOIN Books bk 
    ON g.genre_id = bk.genre_id
LEFT JOIN Loans l 
    ON bk.book_id = l.book_id
GROUP BY g.genre_id, g.genre_name
ORDER BY total_loans DESC;
-- Example Result: History and Poetry have 0 titles; Science Fiction and Biography have exactly 1 each; these genres are thus most exposed to a single point of failure in the catalog
-- Associated Action: Add additional stock in the aforementioned 4 genres

/*
Which loans are currently unreturned?  And by which patrons?
Why: Need data with re: outstanding loans to operationalize methods of getting those loans returned; drives patron follow-up priority
*/
SELECT 
    COUNT(DISTINCT l.loan_id) AS total_unreturned_loans,
    COUNT(DISTINCT p.patron_id) AS total_late_patrons
FROM Loans l
INNER JOIN Patrons p 
    ON l.patron_id = p.patron_id
WHERE l.return_date IS NULL 
    OR l.return_date = '';
SELECT
    p.first_name,
    p.last_name,
    p.email,
    MIN(l.due_date) AS oldest_unreturned_loan,
    COUNT(DISTINCT l.loan_id) AS total_unreturned_loans
FROM Loans l
INNER JOIN Patrons p 
    ON l.patron_id = p.patron_id
WHERE l.return_date IS NULL 
    OR l.return_date = ''
GROUP BY p.patron_id
ORDER BY total_unreturned_loans DESC, oldest_unreturned_loan;
-- Example Result: 12 unreturned loans from 11 patrons
-- Associated Action: contact patrons starting with James Davis who needs to return two books, then William White down to Emma Wilson last


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
  Q3. How would you extend this schema to track additional patron interactions, such as reserved books, late fees, or participation in library programs?
---------------------------------------------------------------------------------------------------------------------------------------------------------
Assuming libraries have organized programs as well as system of notifying patrons and tracking information such as renewal status

Action: Create table for Holds (hold_id, book_id, patron_id, branch_id, hold_date, status)
Why: Allows for an organized queue tracking reservations when demand exceeds copies_owned
Gap closed: Loans only tracks active/completed checkouts with no waitlist for us to know how many/which patrons have reserved books

Action: Create table for Fees (fee_id, loan_id, patron_id, amount, assessed_date, paid_date, status)
Why: No current system for assessing and tracking fees for unreturned books and fee's lifecycle (ex. disputed/waived/paid) stays independent of whether the book has been returned
Gap closed: Loans has due/return dates, nothing about penalties and whether patrons have paid or need to pay any fees

Action: Create table for Programs (program_id, name, program_type, branch_id, date, capacity) + Program_Attendance (program_id, patron_id, registered_at, attended)
Why: Need system for tracking what programs are happening where and when; this system should be separate from attended table as we should distinguish the "what" from "who showed-up",
which is a different signal focusing more on the level of specific engagement and not just what is being offered
Gap closed: NO table at all for events or patron engagement with them to know if/which patrons engaging with library programs

Action: Create table for Notifications (notification_id, patron_id, type, sent_date, responded) with type = 'due_reminder'/'hold_ready'/'fee_notice'
Why: Tracks which patrons have been reached, whether patrons have actually been reached, and what last form of communication was to either batch communications/ensure no unintended repeats
Gap closed: Nothing currently records if patrons have been contacted and whether or not any actions/responses have happened as a result

Action: Create table for Renewals (renewal_id, patron_id, renewal_date,previous_expiration_date, new_expiration_date)
Why: Provides data on which patrons have or have not renewed library cards such that we can know who does, at what cadence, and who needs to do so in future
Gap closed: Currently, all patrons assumed equal with regards to library book access, which is not guaranteed since usually you need to have a library card (in all places, as far as I am aware) to do so 
*/

-- Q4. For tasks 1-3, how could you combine them into a single, more complex query that finds recent history books with multiple copies?
SELECT 
    title, 
    publication_year, 
    copies_owned
FROM Books
WHERE title LIKE '%History%'
    AND genre_id =1
    AND copies_owned > 5
    AND publication_year > 2000
ORDER BY publication_year DESC;
-- Result: 0 rows as no current book satisfies all conditions simultaneously

/*
------------------------------------------------------------------------------------------------------------------------------------
-- Q5. What performance considerations should be kept in mind when running complex joins and aggregations on large library datasets?
------------------------------------------------------------------------------------------------------------------------------------
With large datasets, consideration should be given to ensuring data is normalized before anything.  If this data ever arrived as one flat table (every loan row repeating author name, genre name, branch, etc.),
that redundancy would bloat storage and slow down performance by uploading and transforming identical information repeatedly.  Splitting into
Authors/Genres/Branches/Books/Patrons removes that redundancy and keeps each fact stored, only to be loaded when queried in SQL.
    Tradeoff: Normalization trades storage/consistency for JOIN overhead at query time, for read-heavy reporting on very large tables, some deliberate denormalization (summary tables, materialized views)
    is sensible, especially if it's a one-time additional performance cost.

Following normalization, pre-aggregation of larger fact table (ex. Loans) can be considered best practice from a performance perspective to one row per key prior complex JOINs (ex. Genres), as that shrinks the
amount of data the JOIN has to process.  JOIN at the start forces a full read-through of each piece of data scaling with fact-table size instead of key count.  
    Tradeoff: GROUP BY still scans and sorts entire table.  Therefore, with queries that only filter on dimensions in smaller table, it's best not to default to pre-aggregation of larger table since summation
    of rows at that point fails to provide performance benefits because the GROUP BY command will still have to review entire larger table and apply labels from smaller table for groupings.
*/