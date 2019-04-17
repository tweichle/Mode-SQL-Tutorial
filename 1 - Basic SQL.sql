/*** LESSON 1: The SQL Tutorial for Data Analysis
     Learn to answer questions with data to solve challenging problems ***/

/*** The Basic SQL Tutorial ***/

/*** LESSON 2: Using SQL in Mode
     Learn to use Mode's Query Editor to run SQL queries against data in a relational database ***/

SELECT * FROM tutorial.us_housing_units;

/*** LESSON 3: SQL SELECT
     The SQL SELECT statement is used to retrieve data from a database based on criteria specified in the query ***/

/* Basic syntax: SELECT and FROM */

SELECT year,
       month,
       west
  FROM tutorial.us_housing_units;

SELECT * FROM tutorial.us_housing_units;

SELECT year,
       month,
       month_name,
       west,
       midwest,
       south,
       northeast
  FROM tutorial.us_housing_units;

/* Formatting convention */

SELECT *        FROM tutorial.us_housing_units;

-- It also treats this the same way:

SELECT *
  FROM tutorial.us_housing_units;

/* Column names */

SELECT west AS "West Region"
  FROM tutorial.us_housing_units;

SELECT west AS West_Region,
       south AS South_Region
  FROM tutorial.us_housing_units;

SELECT year AS "Year",
       month AS "Month",
       month_name AS "Month Name",
       west AS "West",
       midwest AS "Midwest",
       south AS "South",
       northeast AS "Northeast"
  FROM tutorial.us_housing_units;

/*** LESSON 4: SQL LIMIT
     Use the SQL LIMIT command to restrict how many rows a SQL query returns ***/

/* Automatic LIMIT in Mode */

SELECT * FROM tutorial.us_housing_units;

/* Using the SQL LIMIT command */

SELECT *
  FROM tutorial.us_housing_units
  LIMIT 100;

SELECT *
  FROM tutorial.us_housing_units
  LIMIT 15;

/*** LESSON 5: SQL WHERE
     Use the SQL WHERE clause to filter data ***/

/* The SQL WHERE clause */

SELECT *
  FROM tutorial.us_housing_units
  WHERE month = 1;

/*** LESSON 6: SQL Comparison Operators
     Use SQL comparison operators like =, <, and, > to filter numerical and non-numerical data ***/

/* Comparison operators on numerical data */

SELECT *
  FROM tutorial.us_housing_units
  WHERE west > 30;

SELECT *
  FROM tutorial.us_housing_units
  WHERE west > 50;

SELECT *
  FROM tutorial.us_housing_units
  WHERE south <= 20;

/* Comparison operators on non-numerical data */

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name != 'January';

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name > 'January';

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name > 'J';

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name = 'February';

SELECT *
  FROM tutorial.us_housing_units
  WHERE month_name < 'o';

/* Arithmetic in SQL */

SELECT year,
       month,
       west,
       south,
       west + south AS south_plus_west
  FROM tutorial.us_housing_units;

SELECT year,
       month,
       west,
       south,
       west + south - 4 * year AS nonsense_column
  FROM tutorial.us_housing_units;

SELECT year,
       month,
       west,
       south,
       midwest,
       northeast,
       west + south + midwest + northeast AS usa_total
  FROM tutorial.us_housing_units;

SELECT year,
       month,
       west,
       south,
       (west + south)/2 AS south_west_avg
  FROM tutorial.us_housing_units;

SELECT year,
       month,
       west,
       south,
       midwest,
       northeast
  FROM tutorial.us_housing_units
  WHERE west > (midwest + northeast);

SELECT year,
       month,
       west/(west + south + midwest + northeast)*100 AS west_pct,
       south/(west + south + midwest + northeast)*100 AS south_pct,
       midwest/(west + south + midwest + northeast)*100 AS midwest_pct,
       northeast/(west + south + midwest + northeast)*100 AS northeast_pct
  FROM tutorial.us_housing_units
  WHERE year >= 2000;

/*** LESSON 7: SQL Logical Operators
     SQL logical operators allow you to filter results using several conditions at once ***/

SELECT * FROM tutorial.billboard_top_100_year_end;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  ORDER BY year DESC, year_rank;

/*** LESSON 8: SQL LIKE
     An introduction to the LIKE operator, which matches similar values ***/

/* The SQL LIKE operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" LIKE 'Snoop%';

/* Wildcards and ILIKE */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE 'snoop%';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE artist ILIKE 'dr_ke';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE '%ludacris%';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" LIKE 'DJ%';

/*** LESSON 9: SQL IN
     Use the SQL IN operator in the WHERE clause to filter data by a list of values ***/

/* The SQL IN operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank IN (1, 2, 3);

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris');

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" IN ('M.C. Hammer', 'Hammer', 'Elvis Presley');

/*** LESSON 10: SQL BETWEEN
     Use the SQL BETWEEN operator to select values from a specific range ***/

/* The SQL BETWEEN operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank BETWEEN 5 AND 10;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank >= 5 AND year_rank <= 10;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year BETWEEN 1985 AND 1990;

/*** LESSON 11: SQL IS NULL
     Use IS NULL operator to select rows that have no data in a given column ***/

/* The IS NULL operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE artist IS NULL;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name IS NULL;

/*** LESSON 12: SQL AND
     Use the SQL AND operator to select rows that satisfy two or more conditions ***/

/* The SQL AND operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2012
    AND year_rank <= 10;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2012
    AND year_rank <= 10
    AND "group" ILIKE '%feat%';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 10
    AND "group" ILIKE '%ludacris%';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank = 1
    AND year IN (1990, 2000, 2010);

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year BETWEEN 1960 AND 1969
    AND song_name ILIKE '%love%';

/*** LESSON 13: SQL OR
     Use the SQL OR operator to select rows that satisfy either of two conditions ***/

/* The SQL OR operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank = 5 OR artist = 'Gotye';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
    AND ("group" ILIKE '%macklemore%' OR "group" ILIKE '%timberlake%');

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 10
    AND ("group" ILIKE '%katy perry%' OR "group" ILIKE '%bon jovi%');

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name LIKE '%California%'
    AND (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 AND 1999);

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE '%dr. dre%'
    AND (year <= 2000 OR year >= 2010);

/*** LESSON 14: SQL NOT
     Use the SQL NOT operator to select rows for which a certain conditional statement is false ***/

/* The SQL NOT operator */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
    AND year_rank NOT BETWEEN 2 AND 3;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
    AND "group" NOT ILIKE '%macklemore%';

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
    AND artist IS NOT NULL;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name NOT ILIKE '%a%'
    AND year = 2013;

/*** LESSON 15: SQL ORDER BY
     See code and examples of using SQL ORDER BY to sort data ***/

SELECT * FROM tutorial.billboard_top_100_year_end;

/* Sorting data with SQL ORDER BY */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  ORDER BY artist;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
  ORDER BY year_rank;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
  ORDER BY year_rank DESC;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2012
  ORDER BY song_name DESC;

/* Ordering data by multiple columns */

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 3
  ORDER BY year DESC, year_rank;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 3
  ORDER BY year_rank, year DESC;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2010
  ORDER BY year_rank, artist;

/* Using comments */

SELECT *  -- This comment won't affect the way the code runs
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013;

-- You can also leave comments across multiple lines using /* to begin the comment and */ to close it:

/* Here's a comment so long and descriptive that
it could only fit on multiple lines. Fortunately,
it, too, will not affect how this code runs. */
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE '%t-pain%'
  ORDER BY year_rank DESC;

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year IN (2013, 2003, 1993)  -- Select the relevant years
    AND year_rank BETWEEN 10 AND 20  -- Limit the rank to 10-20
  ORDER BY year, year_rank;
