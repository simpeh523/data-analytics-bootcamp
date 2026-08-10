-- Workshop Title: SQL Online Music Store
-- Database Engine: SQLite 3.53.3
-- Datasets: artists.csv, songs.csv, customers.csv, purchases.csv, streams.csv
-- Code Editor: VSCode


/* DATABASE AND SCHEMA SETUP
Database created directly in VSCode terminal via the following command:

    sqlite3 SQL_Online_Music_Store.db

Tables created using specifications in workshop instructions
*/
CREATE TABLE artists (
    artist_id     INTEGER PRIMARY KEY,
    artist_name   TEXT NOT NULL,
    genre         TEXT,
    country       TEXT,
    active_since  DATE
);

CREATE TABLE songs (
    song_id           INTEGER PRIMARY KEY,
    title             TEXT NOT NULL,
    artist_id         INTEGER NOT NULL REFERENCES artists(artist_id),
    album             TEXT,
    release_date      DATE,
    duration_seconds  INTEGER,
    popularity_score  INTEGER
);

CREATE TABLE customers (
    customer_id     INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT,
    join_date       DATE,
    premium_member  BOOLEAN
);

CREATE TABLE purchases (
    purchase_id    INTEGER PRIMARY KEY,
    customer_id    INTEGER NOT NULL REFERENCES customers(customer_id),
    song_id        INTEGER NOT NULL REFERENCES songs(song_id),
    purchase_date  DATE,
    price          DECIMAL(10,2)
);

CREATE TABLE streams (
    stream_id     INTEGER PRIMARY KEY,
    customer_id   INTEGER NOT NULL REFERENCES customers(customer_id),
    song_id       INTEGER NOT NULL REFERENCES songs(song_id),
    stream_date   DATE,
    stream_time   TIME
);

-- Data imported and verified as follows (-- skip 1 to ignore header row in CSVs):
.mode csv
.import --skip 1 artists.csv artists
.import --skip 1 songs.csv songs
.import --skip 1 customers.csv customers
.import --skip 1 purchases.csv purchases
.import --skip 1 streams.csv streams

SELECT 'artists', COUNT(*) FROM artists
UNION ALL SELECT 'songs', COUNT(*) FROM songs
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'purchases', COUNT(*) FROM purchases
UNION ALL SELECT 'streams', COUNT(*) FROM streams;
-- Expected output seen with counts of 15 / 40 / 20 / 40 / 70 rows for each respective table


-- WORKSHOP TASKS AND QUERIES
-- Task 1 — Basic Selection
-- Retrieve titles and release dates of all songs released in 2022, ordered by release date (newest first)
SELECT
    title,
    release_date
FROM songs
WHERE release_date BETWEEN '2022-01-01' AND '2022-12-31'
ORDER BY release_date DESC;

-- Task 2 — Filtering
-- Find all songs with a popularity score greater than 80 and a duration less than 4 minutes (240 seconds)
SELECT
    title
FROM songs
WHERE popularity_score > 80
  AND duration_seconds < 240;

-- Task 3 - Pattern Matching
-- List all artists whose names start with "The"
SELECT
    artist_name
FROM artists
WHERE artist_name LIKE 'The%';

-- Task 4: Multiple Conditions
-- Find all premium customers who joined in 2022
SELECT
    first_name,
    last_name,
    join_date
FROM customers 
WHERE premium_member = 'true'
  AND join_date BETWEEN '2022-01-01' AND '2022-12-31';

-- Task 5: Calculations and Aliasing
-- Calculate the total duration (in minutes) of all songs in the database and display the result with an appropriate column name
SELECT
    SUM(duration_seconds) / 60.0 AS total_minutes
FROM songs;

-- Task 6: Advanced Filtering
-- Find the top 5 most expensive song purchases in the database
SELECT
    purchase_id,
    price
FROM purchases
ORDER BY price DESC, purchase_date ASC
LIMIT 5;
-- Of note, several purchases share price of $1.29; purchase_date acts as a secondary sort as a tie-breaker that, while somewhat arbitrary, does provide a consistent and repeatable result set for this query.

-- Task 7: Using Multiple Tables Separately
-- First, find all song_ids from songs with a popularity score greater than 90
-- Then, use those song_ids to find all purchases of those songs
SELECT
    purchase_id
FROM purchases
WHERE song_id IN (
    SELECT song_id
    FROM songs
    WHERE popularity_score > 90
); 

-- Task 8: Range Checking
-- Find all purchases made between January 1, 2023 and March 31, 2023
SELECT
    purchase_id
FROM purchases
WHERE purchase_date BETWEEN '2023-01-01' AND '2023-03-31';

-- Task 9: Advanced Filtering with ORDER BY
-- Identify the songs with the highest popularity scores (above 90)
SELECT
    title
FROM songs
WHERE popularity_score > 90
ORDER BY popularity_score DESC;


-- DISCUSSION QUESTIONS
/* 
1. In our database design, we separated purchases and streams into different tables.  What are the benefits of this approach versus having a single "user_interactions" table?
These two tables record different kinds of events, so a single table would involve capturing data in a manner that would fit neither well

A purchase is a discrete, one-time transaction at a particular price point.
In comparison, streams are easily repeated, unpriced event that can recur several times over several sessions that may encompass several lengths of time

For example, 70 stream rows collapse to only 45 distinct (customer_id, song_id) pairs, with 20 of those pairs appearing more than once and others repeating thrice

Merging would produce 110-row table where `price` is NULL on 70 rows (64%), while needed to introduce an `interaction_type` column for queries to filter on
Necessary constraints will also lead to downstream issues.  Today, you can enforce one-purchase-per-song-per-customer on `purchases`, but that same constraint would also affect
legitimate repeat streams on a merged table.  Two tables let each one mean exactly one thing


2. Based on the provided data model, what business questions could music executives answer using SQL queries that we haven't covered in our exercise?
**Which artists and genres actually generate revenue?**
- JOIN purchases → songs → artists, then SUM(price) grouped by artist_name or genre
- Ex. Dua Lipa leads at $4.86 across 4 purchases; Pop accounts for $16.86 of $45.80 total (37%)
- Tells you where catalog licensing spend is earning its keep

**What is a customer worth over their lifetime?**
- SUM(price) grouped by customer_id, optionally divided by months since join_date if rate desired
- Ex. Range here is $0.99 to $3.87, and all 20 customers have at least one purchase — no dormant segment to win back (at least at this low level of $$$)
- Sets the ceiling on what acquisition spend can justify

**Does premium membership pay for itself?**
- GROUP BY premium_member across a customers → purchases JOIN
- Ex. 12 premium customers made 30 of 40 purchases for $34.40; the 8 non-premium made 10 for $11.40 — 2.5 purchases per premium customer vs. 1.25, exactly double
- Open question the data can't settle currently: whether premium causes spending or heavy spenders self-select into premium

**When are customers actually listening?**
- Bucket streams by hour using substr(stream_time, 1, 2), then COUNT
- 2pm and 7pm tie at 6 streams each, with five more hours (9am, 11am, 4pm, 8pm, 10pm) tied at 5
- Directly actionable for release timing, advertisements, and notification windows

**Does signup cohort predict premium status?**
- GROUP BY substr(join_date, 1, 4) and premium_member
- All 5 customers who joined in 2022 are premium, vs. 1 of 4 in 2019, 4 of 6 in 2020, and 2 of 5 in 2021
- Limit worth stating: this shows recent joiners are premium *now*, not that they converted quickly — the schema can't distinguish those two


3. How would you extend this schema to track more detailed user behavior, such as when users skip songs or how much of a song they listen to before skipping?
**Add `listen_duration_seconds INTEGER` to `streams`.**
- Currently, a stream row records that a song played, not how much of it played, so skip behavior is currently invisible
- Store raw seconds rather than a precomputed `is_skip` boolean. Roughly 30 seconds is the industry convention for a real play, but hardcoding it into the data means backfilling every row if the definition changes
- Joining to `songs.duration_seconds` then yields completion percentage, which is more honest than one flat cutoff applied to both a 125-second track ("Yesterday") and a 243-second one ("Let It Be")

**Add a `sessions` table (`session_id`, `customer_id`, `start_time`, `end_time`, `device`), with `streams.session_id` as an FK.**
- Skipping is a session-level pattern — five skips in a row is a different signal from five skips across a month
- Without a session grouping, skips can only be analyzed as isolated events, which loses the sequence that makes them meaningful
- Also unlocks device-level questions the current schema can't touch at all

**Add `customers.premium_since_date DATE`.**
- `join_date` is store signup only, so "when did this customer convert to premium?" is unanswerable today — not hard, unanswerable.
- Day-one conversion vs. months-later conversion point at opposite strategies: acquisition spend in the first case; in-product upsell and retention in the second.

**Add an `albums` table (`album_id` PK, `title`, `artist_id`, `release_date`, `total_tracks`), with `songs.album_id` replacing the free-text `album` column.**
- Normalization: `album` is a repeated string today, so a single typo silently creates a phantom album.
- `total_tracks` is the only way to know real album length without stocking every track. Ex. song_id 4 ("Die For You") maps to Starboy and the catalog holds exactly one song from it, so a full-length album reads as a one-track album;
 26 of the 33 albums here have a single song in the catalog.
- Enables catalog coverage as a metric — how often are high-performing songs purchased and listened to alongside the rest of an album?  And how does this change with artist and genre? — there might need to be adjustments in marketing,
 for example,  a hit-single can act as a useful gateway to getting customers to stream other songs on one artist's albums, whereas other genres, it might be better to sell albums as a whole experiences with a hit-single being the climax  

4. For tasks 1-3, how could you combine them into a single, more complex query that finds popular short songs by artists whose names start with "The"?
-- Combining Tasks 1-3 in manner above allows one to filter for popular, short songs by artists starting with "The" sorted by release date in descending order for the year 2022.
*/
SELECT
    s.title,                                                -- Requested from Task 1 and 2
    a.artist_name,                                          -- Requested in Task 3
    s.release_date                                          -- Requested by Task 1
FROM songs s                                                
LEFT JOIN artists a ON s.artist_id = a.artist_id            -- Required JOIN: artist_name now connects to song title and popularity, duration, and release date filters
WHERE s.popularity_score > 80                               -- Task 2: "popular"
  AND s.duration_seconds < 240                              -- Task 2: "short" (under 4 minutes)
  AND a.artist_name LIKE 'The%'                             -- Task 3: name begins with "The"
  AND s.release_date BETWEEN '2022-01-01' AND '2022-12-31'  -- Task 1: 2022 releases only
ORDER BY s.release_date DESC;                               -- Task 1: newest first