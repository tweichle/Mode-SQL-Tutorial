/*** The SQL Tutorial for Data Analysis ***/

/*** The Advanced SQL Tutorial ***/

/*** LESSON 1: SQL Data Types
     Learn about SQL data types and how to change a column's data type using CONVERT and CAST ***/

-- For the complete list: https://www.w3schools.com/sql/sql_datatypes.asp.

/* Changing a column’s data type */

-- Note: CAST(column_name AS integer) and column_name::integer produce the same result
SELECT CAST(funding_total_usd AS varchar) AS funding_total_usd_string,
       founded_at_clean::varchar AS founded_at_string
  FROM tutorial.crunchbase_companies_clean_date;
  
/*** LESSON 2: SQL Date Format
     Learn how dates and times are formatted in SQL, and best practices for interacting with them ***/

/* Why dates are formatted year-first */

-- Here’s a date field stored as a string. Because the month is listed first, the ORDER BY statement doesn’t produce a chronological list
SELECT permalink,
       founded_at
  FROM tutorial.crunchbase_companies_clean_date
  ORDER BY founded_at;

--  The cleaned date field is actually stored as a string, but still sorts in chronological order anyway
SELECT permalink,
       founded_at,
       founded_at_clean
  FROM tutorial.crunchbase_companies_clean_date
  ORDER BY founded_at_clean;
  
/* Crazy rules for dates and times */
  
SELECT companies.permalink,
       companies.founded_at_clean,
       acquisitions.acquired_at_cleaned,
       acquisitions.acquired_at_cleaned - companies.founded_at_clean::timestamp AS time_to_acquisition
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
  WHERE founded_at_clean IS NOT NULL;
  
SELECT companies.permalink,
       companies.founded_at_clean,
       companies.founded_at_clean::timestamp + INTERVAL '1 week' AS plus_one_week
  FROM tutorial.crunchbase_companies_clean_date companies
  WHERE founded_at_clean IS NOT NULL;
  
SELECT companies.permalink,
       companies.founded_at_clean,
       NOW() - companies.founded_at_clean::timestamp AS founded_time_ago
  FROM tutorial.crunchbase_companies_clean_date companies
  WHERE founded_at_clean IS NOT NULL;
  
SELECT companies.category_code,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
        THEN 1 ELSE NULL END) AS acquired_3_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
        THEN 1 ELSE NULL END) AS acquired_5_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
        THEN 1 ELSE NULL END) AS acquired_10_yrs,
       COUNT(*) AS total
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
  WHERE founded_at_clean IS NOT NULL
  GROUP BY companies.category_code
  ORDER BY total DESC;
  
/*** LESSON 3: Data Wrangling with SQL
     Programmatically transform data into a format that makes it easier to work with ***/

-- What does it mean to “wrangle” data?
-- From Wikipedia:
--  Data munging or data wrangling is loosely the process of manually converting or mapping data from one “raw” form 
--  into another format that allows for more convenient consumption of the data with the help of semi-automated tools.

/*** LESSON 4: Using SQL String Functions to Clean Data
     Use SQL string functions to clean data strings and fix date formats ***/
  
SELECT * FROM tutorial.sf_crime_incidents_2014_01;

/* Cleaning strings */

/* LEFT, RIGHT, and LENGTH */

SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, 17) AS cleaned_time
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, LENGTH(date) - 11) AS cleaned_time
  FROM tutorial.sf_crime_incidents_2014_01;

/* TRIM */

SELECT location,
       TRIM(both '()' FROM location)
  FROM tutorial.sf_crime_incidents_2014_01;

/* POSITION and STRPOS */
-- Both functions achieve the same results and are case sensitive

SELECT incidnt_num,
       descript,
       POSITION('A' IN descript) AS a_position
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       descript,
       STRPOS(descript, 'A') AS a_position
  FROM tutorial.sf_crime_incidents_2014_01;

/* SUBSTR */

SELECT incidnt_num,
       date,
       SUBSTR(date, 4, 2) AS day
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT location,
       TRIM(leading '(' FROM LEFT(location, POSITION(',' IN location) - 1)) AS lattitude,
       TRIM(trailing ')' FROM RIGHT(location, LENGTH(location) - POSITION(',' IN location))) AS longitude
  FROM tutorial.sf_crime_incidents_2014_01;

/* CONCAT */

SELECT incidnt_num,
       day_of_week,
       LEFT(date, 10) AS cleaned_date,
       CONCAT(day_of_week, ', ', LEFT(date, 10)) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       day_of_week,
       LEFT(date, 10) AS cleaned_date,
       day_of_week || ', ' || LEFT(date, 10) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT CONCAT('(', lat, ', ', lon, ')') AS concat_location,
       location
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT '(' || lat || ', ' || lon || ')' AS concat_location,
       location
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       date,
       SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01;

/* Changing case with UPPER and LOWER */

SELECT incidnt_num,
       address,
       UPPER(address) AS address_upper,
       LOWER(address) AS address_lower
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       category,
       UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, LENGTH(category) - 1)) AS category_cleaned
  FROM tutorial.sf_crime_incidents_2014_01;

/* Turning strings into dates */

SELECT incidnt_num,
       date,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::date AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01;
  
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp + INTERVAL '1 week' AS timestamp_plus_interval
  FROM tutorial.sf_crime_incidents_2014_01;

/* Turning dates into more useful dates */

SELECT * FROM tutorial.sf_crime_incidents_cleandate;

SELECT cleaned_date,
       EXTRACT('year'   FROM cleaned_date) AS year,
       EXTRACT('month'  FROM cleaned_date) AS month,
       EXTRACT('day'    FROM cleaned_date) AS day,
       EXTRACT('hour'   FROM cleaned_date) AS hour,
       EXTRACT('minute' FROM cleaned_date) AS minute,
       EXTRACT('second' FROM cleaned_date) AS second,
       EXTRACT('decade' FROM cleaned_date) AS decade,
       EXTRACT('dow'    FROM cleaned_date) AS day_of_week
  FROM tutorial.sf_crime_incidents_cleandate;
  
SELECT cleaned_date,
       DATE_TRUNC('year'   , cleaned_date) AS year,
       DATE_TRUNC('month'  , cleaned_date) AS month,
       DATE_TRUNC('week'   , cleaned_date) AS week,
       DATE_TRUNC('day'    , cleaned_date) AS day,
       DATE_TRUNC('hour'   , cleaned_date) AS hour,
       DATE_TRUNC('minute' , cleaned_date) AS minute,
       DATE_TRUNC('second' , cleaned_date) AS second,
       DATE_TRUNC('decade' , cleaned_date) AS decade
  FROM tutorial.sf_crime_incidents_cleandate;
  
SELECT DATE_TRUNC('week', cleaned_date)::date AS week_beginning,
       COUNT(*) AS incidents
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY week_beginning
  ORDER BY week_beginning;
  
SELECT CURRENT_DATE AS date,
       CURRENT_TIME AS time,
       CURRENT_TIMESTAMP AS timestamp,
       LOCALTIME AS localtime,
       LOCALTIMESTAMP AS localtimestamp,
       NOW() AS now;
       
SELECT CURRENT_TIME AS time,
       CURRENT_TIME AT TIME ZONE 'PST' AS time_pst;
       
SELECT incidnt_num,
       cleaned_date,
       NOW() AT TIME ZONE 'PST' AS now,
       NOW() AT TIME ZONE 'PST' - cleaned_date AS time_ago 
  FROM tutorial.sf_crime_incidents_cleandate;

/* COALESCE */

SELECT incidnt_num,
       descript,
       COALESCE(descript, 'No Description') AS descript_coalesce
  FROM tutorial.sf_crime_incidents_cleandate
  ORDER BY descript DESC;
  
/*** LESSON 5: Writing Subqueries in SQL
     Use subqueries in SQL with aggregate functions, conditional logic, and joins ***/

/* Subquery basics */

SELECT sub.*
  FROM (
        SELECT *
          FROM tutorial.sf_crime_incidents_2014_01
          WHERE day_of_week = 'Friday'
       ) sub
  WHERE sub.resolution = 'NONE';
 
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
  WHERE day_of_week = 'Friday'   -- Inner query result

SELECT sub.*
  FROM (
       <<results from inner query go here>>
       ) sub
  WHERE sub.resolution = 'NONE';

SELECT sub.*
  FROM (
        SELECT *
          FROM tutorial.sf_crime_incidents_2014_01
          WHERE descript = 'WARRANT ARREST'
        ) sub
  WHERE sub.resolution = 'NONE';

/* Using subqueries to aggregate in multiple stages */

SELECT LEFT(sub.date, 2) AS cleaned_month,
       sub.day_of_week,
       AVG(sub.incidents) AS average_incidents
  FROM (
        SELECT day_of_week,
               date,
               COUNT(incidnt_num) AS incidents
          FROM tutorial.sf_crime_incidents_2014_01
          GROUP BY day_of_week, date
       ) sub
  GROUP BY cleaned_month, sub.day_of_week
  ORDER BY cleaned_month, sub.day_of_week;

-- Inner query result
SELECT day_of_week,
       date,
       COUNT(incidnt_num) AS incidents
  FROM tutorial.sf_crime_incidents_2014_01
  GROUP BY day_of_week, date;
  
SELECT sub.category,
       AVG(sub.incidents) AS avg_incidents_per_month
  FROM (
        SELECT EXTRACT('month' FROM cleaned_date) AS month,
               category,
               COUNT(*) AS incidents
          FROM tutorial.sf_crime_incidents_cleandate
          GROUP BY month, category
       ) sub
  GROUP BY sub.category;
  
-- Inner query result
SELECT EXTRACT('month' FROM cleaned_date) AS month,
       category,
       COUNT(*) AS incidents
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY month, category;

/* Subqueries in conditional logic */

SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
  WHERE Date = (
                SELECT MIN(date)
                  FROM tutorial.sf_crime_incidents_2014_01
               );
               
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
  WHERE Date IN (
                 SELECT date
                   FROM tutorial.sf_crime_incidents_2014_01
                   ORDER BY date
                   LIMIT 5
                );
                
/* Joining subqueries */

SELECT *
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  INNER JOIN (
              SELECT date
                FROM tutorial.sf_crime_incidents_2014_01
                ORDER BY date
                LIMIT 5
              ) sub
    ON incidents.date = sub.date;
    
SELECT incidents.*,
       sub.incidents AS incidents_that_day
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  INNER JOIN (
              SELECT date,
                     COUNT(incidnt_num) AS incidents
                FROM tutorial.sf_crime_incidents_2014_01
                GROUP BY date
              ) sub
    ON incidents.date = sub.date
  ORDER BY sub.incidents DESC, time;

SELECT incidents.*,
       sub.count AS total_incidents_in_category
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  INNER JOIN (
              SELECT category,
                     COUNT(*) AS count
                FROM tutorial.sf_crime_incidents_2014_01
                GROUP BY category
                ORDER BY count
                LIMIT 3
              ) sub
    ON sub.category = incidents.category;

-- Inner query result
SELECT category,
       COUNT(*) AS count
  FROM tutorial.sf_crime_incidents_2014_01
  GROUP BY category
  ORDER BY count
  LIMIT 3;
  
SELECT COALESCE(acquisitions.acquired_month, investments.funded_month) AS month,
       COUNT(DISTINCT acquisitions.company_permalink) AS companies_acquired,
       COUNT(DISTINCT investments.company_permalink) AS investments
  FROM tutorial.crunchbase_acquisitions acquisitions
  FULL JOIN tutorial.crunchbase_investments investments
    ON acquisitions.acquired_month = investments.funded_month
  GROUP BY month;

SELECT COUNT(*) FROM tutorial.crunchbase_acquisitions;

SELECT COUNT(*) FROM tutorial.crunchbase_investments;

SELECT COUNT(*)
  FROM tutorial.crunchbase_acquisitions acquisitions
  FULL JOIN tutorial.crunchbase_investments investments
    ON acquisitions.acquired_month = investments.funded_month;
    
SELECT COALESCE(acquisitions.month, investments.month) AS month,
       acquisitions.companies_acquired,
       investments.companies_rec_investment
  FROM (
        SELECT acquired_month AS month,
               COUNT(DISTINCT company_permalink) AS companies_acquired
          FROM tutorial.crunchbase_acquisitions
          GROUP BY month
       ) acquisitions
  FULL JOIN (
             SELECT funded_month AS month,
                    COUNT(DISTINCT company_permalink) AS companies_rec_investment
               FROM tutorial.crunchbase_investments
               GROUP BY month
            ) investments
    ON acquisitions.month = investments.month
  ORDER BY month DESC;
  
SELECT COALESCE(companies.quarter, acquisitions.quarter) AS quarter,
       companies.companies_founded,
       acquisitions.companies_acquired
  FROM (
        SELECT founded_quarter AS quarter,
               COUNT(permalink) AS companies_founded
          FROM tutorial.crunchbase_companies
          WHERE founded_year >= 2012
          GROUP BY quarter
        ) companies
  LEFT JOIN (
             SELECT acquired_quarter AS quarter,
                    COUNT(DISTINCT company_permalink) AS companies_acquired
               FROM tutorial.crunchbase_acquisitions
               WHERE acquired_year >= 2012
               GROUP BY quarter
            ) acquisitions
    ON companies.quarter = acquisitions.quarter
  ORDER BY quarter;
  
/* Subqueries and UNIONs */

SELECT *
  FROM tutorial.crunchbase_investments_part1
 UNION ALL
 SELECT *
   FROM tutorial.crunchbase_investments_part2;
   
SELECT COUNT(*) AS total_rows
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1
         UNION ALL
        SELECT *
          FROM tutorial.crunchbase_investments_part2
       ) sub;
       
SELECT investor_name,
       COUNT(*) AS investments
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1
         UNION ALL
         SELECT *
           FROM tutorial.crunchbase_investments_part2
       ) sub
 GROUP BY investor_name
 ORDER BY investments DESC;
 
SELECT investments.investor_name,
       COUNT(investments.*) AS investments
  FROM tutorial.crunchbase_companies companies
  INNER JOIN (
              SELECT *
                FROM tutorial.crunchbase_investments_part1
              UNION ALL
              SELECT *
                FROM tutorial.crunchbase_investments_part2
              ) investments
    ON investments.company_permalink = companies.permalink
  WHERE companies.status = 'operating'
  GROUP BY 1
  ORDER BY 2 DESC;
  
/*** LESSON 6: SQL Window Functions
     Learn about SQL windowing functions such as ROW_NUMBER(), NTILE, LAG, and LEAD ***/

/* Intro to window functions */

SELECT duration_seconds,
       SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012;
  
/* Basic windowing syntax */

SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS start_terminal_total
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS start_terminal_sum,
       (duration_seconds/SUM(duration_seconds) OVER (PARTITION BY start_terminal))*100 AS pct_of_total_time
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  ORDER BY start_terminal, pct_of_total_time DESC;
  
/* The usual suspects: SUM, COUNT, and AVG */

SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS running_total,
       COUNT(duration_seconds) OVER (PARTITION BY start_terminal) AS running_count,
       AVG(duration_seconds) OVER (PARTITION BY start_terminal) AS running_avg
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';

SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_total,
       COUNT(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_count,
       AVG(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_avg
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
SELECT end_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY end_terminal ORDER BY duration_seconds DESC) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
/* ROW_NUMBER() */

SELECT start_terminal,
       start_time,
       duration_seconds,
       ROW_NUMBER() OVER (ORDER BY start_time) AS row_number
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
SELECT start_terminal,
       start_time,
       duration_seconds,
       ROW_NUMBER() OVER (PARTITION BY start_terminal ORDER BY start_time) AS row_number
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
/* RANK() and DENSE_RANK() */

SELECT start_terminal, start_time,
       duration_seconds,
       RANK() OVER (PARTITION BY start_terminal ORDER BY start_time) AS rank
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08';
  
SELECT *
  FROM (
        SELECT start_terminal,
               start_time,
               duration_seconds AS trip_time,
               RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
          FROM tutorial.dc_bikeshare_q1_2012
          WHERE start_time < '2012-01-08'
        ) sub
  WHERE sub.rank <= 5;
  
/* NTILE */

SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS quartile,
       NTILE(5) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS quintile,
       NTILE(100) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  ORDER BY start_terminal, duration_seconds;

SELECT duration_seconds,
       NTILE(100) OVER (ORDER BY duration_seconds) AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  ORDER BY duration_seconds DESC;
  
/* LAG and LEAD */

SELECT start_terminal,
       duration_seconds,
       LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
       LEAD(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  ORDER BY start_terminal, duration_seconds;
  
SELECT start_terminal,
       duration_seconds,
       duration_seconds - LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS difference
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  ORDER BY start_terminal, duration_seconds;

SELECT *
  FROM (
        SELECT start_terminal,
               duration_seconds,
               duration_seconds - LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS difference
          FROM tutorial.dc_bikeshare_q1_2012
          WHERE start_time < '2012-01-08'
          ORDER BY start_terminal, duration_seconds
        ) sub
  WHERE sub.difference IS NOT NULL;
  
/* Defining a window alias */

SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER ntile_window AS quartile,
       NTILE(5) OVER ntile_window AS quintile,
       NTILE(100) OVER ntile_window AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  WINDOW ntile_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
  ORDER BY start_terminal, duration_seconds;
  
/*** LESSON 7: Performance Tuning SQL Queries
     Learn how to conduct SQL performance tuning by reducing table size, simplifying joins, and the EXPLAIN command ***/

/* Reducing table size */

SELECT *
  FROM benn.sample_event_table
  WHERE event_date >= '2014-03-01'
    AND event_date <  '2014-04-01';

-- If you’re aggregating into one row as below, LIMIT 100 will do nothing to speed up your query:
SELECT COUNT(*)
  FROM benn.sample_event_table
  LIMIT 100;

-- If you want to limit the dataset before performing the count (to speed things up), try doing it in a subquery:
SELECT COUNT(*)
  FROM (
        SELECT *
          FROM benn.sample_event_table
          LIMIT 100
        ) sub;
        
/* Making joins less complicated */

SELECT teams.conference AS conference,
       players.school_name,
       COUNT(1) AS players
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
  GROUP BY conference, players.school_name;
  
SELECT players.school_name,
       COUNT(*) AS players
  FROM benn.college_football_players players
  GROUP BY players.school_name;
  
SELECT teams.conference,
       sub.*
  FROM (
        SELECT players.school_name,
               COUNT(*) AS players
          FROM benn.college_football_players players
          GROUP BY players.school_name
       ) sub
  JOIN benn.college_football_teams teams
    ON teams.school_name = sub.school_name;
    
/* EXPLAIN */

EXPLAIN
SELECT *
  FROM benn.sample_event_table
  WHERE event_date >= '2014-03-01'
   AND event_date < '2014-04-01'
  LIMIT 100;
  
/*** LESSON 8: Pivoting Data in SQL
     Learn to pivot rows to columns and columns to rows in SQL ***/

/* Pivoting rows to columns */

SELECT teams.conference AS conference,
       players.year,
       COUNT(1) AS players
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
  GROUP BY conference, players.year
  ORDER BY conference, players.year;
  
SELECT *
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM benn.college_football_players players
          JOIN benn.college_football_teams teams
            ON teams.school_name = players.school_name
          GROUP BY conference, players.year
       ) sub;

SELECT conference,
       SUM(CASE WHEN year = 'FR' THEN players ELSE NULL END) AS fr,
       SUM(CASE WHEN year = 'SO' THEN players ELSE NULL END) AS so,
       SUM(CASE WHEN year = 'JR' THEN players ELSE NULL END) AS jr,
       SUM(CASE WHEN year = 'SR' THEN players ELSE NULL END) AS sr
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM benn.college_football_players players
          JOIN benn.college_football_teams teams
            ON teams.school_name = players.school_name
          GROUP BY conference, players.year
        ) sub
  GROUP BY conference
  ORDER BY conference;
  
SELECT conference,
       SUM(players) AS total_players,
       SUM(CASE WHEN year = 'FR' THEN players ELSE NULL END) AS fr,
       SUM(CASE WHEN year = 'SO' THEN players ELSE NULL END) AS so,
       SUM(CASE WHEN year = 'JR' THEN players ELSE NULL END) AS jr,
       SUM(CASE WHEN year = 'SR' THEN players ELSE NULL END) AS sr
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM benn.college_football_players players
          JOIN benn.college_football_teams teams
            ON teams.school_name = players.school_name
          GROUP BY conference, players.year
       ) sub
  GROUP BY conference
  ORDER BY total_players DESC;
  
/* Pivoting columns to rows */

SELECT * FROM tutorial.worldwide_earthquakes;

SELECT year
  FROM (VALUES (2000),(2001),(2002),(2003),(2004),(2005),(2006),
               (2007),(2008),(2009),(2010),(2011),(2012)) v(year);
               
SELECT years.*,
       earthquakes.*
  FROM tutorial.worldwide_earthquakes earthquakes
  CROSS JOIN (
              SELECT year
                FROM (VALUES (2000),(2001),(2002),(2003),(2004),(2005),(2006),
                             (2007),(2008),(2009),(2010),(2011),(2012)) v(year)
              ) years;
              
SELECT years.*,
       earthquakes.magnitude,
       CASE year
         WHEN 2000 THEN year_2000
         WHEN 2001 THEN year_2001
         WHEN 2002 THEN year_2002
         WHEN 2003 THEN year_2003
         WHEN 2004 THEN year_2004
         WHEN 2005 THEN year_2005
         WHEN 2006 THEN year_2006
         WHEN 2007 THEN year_2007
         WHEN 2008 THEN year_2008
         WHEN 2009 THEN year_2009
         WHEN 2010 THEN year_2010
         WHEN 2011 THEN year_2011
         WHEN 2012 THEN year_2012
         ELSE NULL END
         AS number_of_earthquakes
  FROM tutorial.worldwide_earthquakes earthquakes
  CROSS JOIN (
              SELECT year
                FROM (VALUES (2000),(2001),(2002),(2003),(2004),(2005),(2006),
                             (2007),(2008),(2009),(2010),(2011),(2012)) v(year)
              ) years;