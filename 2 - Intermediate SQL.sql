/*** The SQL Tutorial for Data Analysis ***/

/*** The Intermediate SQL Tutorial ***/

/* Query clause order */

SELECT
  FROM
  WHERE
  GROUP BY
  HAVING
  ORDER BY;

/*** LESSON 1: SQL Aggregate Functions
     Aggregate data across entire columns using the COUNT, SUM, MIN, MAX, and AVG functions ***/

SELECT * FROM tutorial.aapl_historical_stock_price;

/*** LESSON 2: SQL COUNT
     Using SQL COUNT to count the number of rows in a particular column ***/

/* Counting all rows */

SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price;

/* Counting individual columns */

SELECT COUNT(high)
  FROM tutorial.aapl_historical_stock_price;

SELECT COUNT(low) AS low
  FROM tutorial.aapl_historical_stock_price;

/* Counting non-numerical columns */

SELECT COUNT(date)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT COUNT(date) AS count_of_date
  FROM tutorial.aapl_historical_stock_price;

SELECT COUNT(date) AS "Count Of Date"
  FROM tutorial.aapl_historical_stock_price;
  
SELECT COUNT(year) AS year,
       COUNT(month) AS month,
       COUNT(open) AS open,
       COUNT(high) AS high,
       COUNT(low) AS low,
       COUNT(close) AS close,
       COUNT(volume) AS volume
  FROM tutorial.aapl_historical_stock_price;
  
/*** LESSON 3: SQL SUM
     Use the SQL SUM function to total the numerical values in a particular column ***/

/* The SQL SUM function */

SELECT SUM(volume)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT SUM(open)/COUNT(open) AS avg_open_price
  FROM tutorial.aapl_historical_stock_price;
  
/*** LESSON 4: SQL MIN/MAX
     See examples using the SQL MIN and MAX functions to select the highest and lowest values in a particular column ***/

/* The SQL MIN and MAX functions */

SELECT MIN(volume) AS min_volume,
       MAX(volume) AS max_volume
  FROM tutorial.aapl_historical_stock_price;

SELECT MIN(low)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT MAX(close - open)
  FROM tutorial.aapl_historical_stock_price;
  
/*** LESSON 5: SQL AVG
     Using the SQL AVG function to select the average of a selected group of values ***/

/* The SQL AVG function */

SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price
  WHERE high IS NOT NULL;

SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price;
  
SELECT AVG(volume) AS avg_volume
  FROM tutorial.aapl_historical_stock_price;
  
/*** LESSON 6: SQL GROUP BY
     Use the GROUP BY clause to separate data into groups ***/

/* The SQL GROUP BY clause */

SELECT year,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year;
  
SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month;
  
SELECT year,
       month,
       SUM(volume) AS volume_sum
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY year, month;
 
/* GROUP BY column numbers */

SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY 1, 2

-- Note: this functionality (numbering columns instead of using names) is supported by Mode, but not by every flavor of SQL,
--  so if you’re using another system or connected to certain types of databases, it may not work.

/* Using GROUP BY with ORDER BY */

SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY month, year;
  
SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY year, month;
  
/* Using GROUP BY with LIMIT */

SELECT year,
       AVG(close - open) AS avg_daily_change
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year
  ORDER BY year;
  
SELECT year,
       month,
       MIN(low) AS lowest_price,
       MAX(high) AS highest_price
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  ORDER BY year, month;
  
/*** LESSON 7: SQL HAVING
     Use the SQL HAVING clause to filter an aggregated query ***/

/* The SQL HAVING clause */

SELECT year,
       month,
       MAX(high) AS month_high
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year, month
  HAVING MAX(high) > 400
  ORDER BY year, month;
  
/* Query clause order */

SELECT
  FROM
  WHERE
  GROUP BY
  HAVING
  ORDER BY;
  
/*** LESSON 8: SQL DISTINCT
     Using SQL DISTINCT to view and aggregate unique values in a given column ***/

/* Using SQL DISTINCT for viewing unique values */

SELECT DISTINCT month
  FROM tutorial.aapl_historical_stock_price;
  
SELECT DISTINCT year, month
  FROM tutorial.aapl_historical_stock_price;
  
-- Note: You only need to include DISTINCT once in your SELECT clause — you do not need to add it for each column name.
  
SELECT DISTINCT year
  FROM tutorial.aapl_historical_stock_price
  ORDER BY year;

/* Using DISTINCT in aggregations */

SELECT COUNT(DISTINCT month) AS unique_months
  FROM tutorial.aapl_historical_stock_price;
  
SELECT month,
       AVG(volume) AS avg_trade_volume
  FROM tutorial.aapl_historical_stock_price
  GROUP BY month
  ORDER BY AVG(volume) DESC;
  
/* DISTINCT performance */

SELECT year,
       COUNT(DISTINCT month) AS months_count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year
  ORDER BY year;
  
SELECT COUNT(DISTINCT year) AS years_count,
       COUNT(DISTINCT month) AS months_count
  FROM tutorial.aapl_historical_stock_price;

/*** LESSON 9: SQL CASE
     Using if/then logic with the SQL CASE statement ***/

SELECT * FROM benn.college_football_players;

/* The SQL CASE statement */

SELECT player_name,
       year,
       CASE WHEN year = 'SR' THEN 'yes'
            ELSE NULL END AS is_a_senior
  FROM benn.college_football_players;
  
SELECT player_name,
       year,
       CASE WHEN year = 'SR' THEN 'yes'
            ELSE 'no' END AS is_a_senior
  FROM benn.college_football_players;
  
SELECT player_name,
       state,
       CASE WHEN state = 'CA' THEN 'yes'
            ELSE NULL END AS from_california
  FROM benn.college_football_players
  ORDER BY from_california;
  
/* Adding multiple conditions to a CASE statement */
  
SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 THEN '201-250'
            WHEN weight > 175 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players;
  
SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 AND weight <= 250 THEN '201-250'
            WHEN weight > 175 AND weight <= 200 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players;
  
SELECT player_name,
       height,
       CASE WHEN height > 74 THEN 'over 74'
            WHEN height > 72 AND height <= 74 THEN '73-74'
            WHEN height > 70 AND height <= 72 THEN '71-72'
            ELSE 'under 70' END AS height_group
  FROM benn.college_football_players;
  
SELECT player_name,
       CASE WHEN year = 'FR' AND position = 'WR' THEN 'frosh_wr'
            ELSE NULL END AS sample_case_statement
  FROM benn.college_football_players;

SELECT *,
       CASE WHEN year IN ('JR', 'SR') THEN player_name ELSE NULL END AS upperclass_player_name
  FROM benn.college_football_players;

/* Using CASE with aggregate functions */

SELECT CASE WHEN year = 'FR' THEN 'FR'
            ELSE 'Not FR' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
  GROUP BY CASE WHEN year = 'FR' THEN 'FR'
                ELSE 'Not FR' END;
               
SELECT COUNT(*) AS fr_count
  FROM benn.college_football_players
  WHERE year = 'FR';
  
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
  GROUP BY year_group;
  
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
  GROUP BY CASE WHEN year = 'FR' THEN 'FR'
               WHEN year = 'SO' THEN 'SO'
               WHEN year = 'JR' THEN 'JR'
               WHEN year = 'SR' THEN 'SR'
               ELSE 'No Year Data' END;
               
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            *
  FROM benn.college_football_players;
  
SELECT CASE WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS arbitrary_regional_designation,
            COUNT(*) AS players
  FROM benn.college_football_players
  WHERE weight >= 300
  GROUP BY arbitrary_regional_designation;
  
SELECT CASE WHEN year IN ('FR', 'SO') THEN 'underclass'
            WHEN year IN ('JR', 'SR') THEN 'upperclass'
            ELSE NULL END AS class_group,
       SUM(weight) AS combined_player_weight
  FROM benn.college_football_players
  WHERE state = 'CA'
  GROUP BY class_group;

/* Using CASE inside of aggregate functions */

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
  GROUP BY year_group;
  
SELECT COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
  FROM benn.college_football_players;

SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(*) AS total_players
  FROM benn.college_football_players
  GROUP BY state
  ORDER BY total_players DESC;
  
SELECT CASE WHEN school_name < 'n' THEN 'A-M'
            WHEN school_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS school_name_group,
       COUNT(*) AS players
  FROM benn.college_football_players
  GROUP BY school_name_group;
  
/*** LESSON 10: SQL Joins
     An introduction to SQL joins and the relational logic behind them ***/

/* Intro to SQL joins: relational concepts */

/* The anatomy of a join */

SELECT teams.conference AS conference,
       AVG(players.weight) AS average_weight
  FROM benn.college_football_players players
  INNER JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
  GROUP BY teams.conference
  ORDER BY AVG(players.weight) DESC;

/* Aliases in SQL */

SELECT players.school_name,
       players.player_name,
       players.position,
       players.weight
  FROM benn.college_football_players players
  WHERE players.state = 'GA'
  ORDER BY players.weight DESC;

/* JOIN and ON */

SELECT *
  FROM benn.college_football_players players
  INNER JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name;
    
/*** LESSON 11: SQL INNER JOIN
     Use a SQL INNER JOIN to select rows that satisfy a join statement and eliminate rows that don't ***/

/* INNER JOIN */

/* Joining tables with identical column names */

SELECT players.*,
       teams.*
  FROM benn.college_football_players players
  INNER JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name;
    
SELECT players.school_name AS players_school_name,
       teams.school_name AS teams_school_name
  FROM benn.college_football_players players
  INNER JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name;
    
SELECT players.player_name,
       players.school_name,
       teams.conference
  FROM benn.college_football_players players
  INNER JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
  WHERE teams.division = 'FBS (Division I-A Teams)';
  
/*** LESSON 12: SQL Outer Joins
     This lesson of the SQL tutorial for data analysis introduces the concept of outer joins ***/

/* Outer joins */

-- LEFT JOIN returns only unmatched rows from the left table.
-- RIGHT JOIN returns only unmatched rows from the right table.
-- FULL OUTER JOIN returns unmatched rows from both tables.

SELECT * FROM tutorial.crunchbase_companies;
  
SELECT * FROM tutorial.crunchbase_acquisitions;
  
/*** LESSON 13: SQL LEFT JOIN
     See code and examples for LEFT JOIN ***/

/* The LEFT JOIN command */

-- INNER JOIN
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  INNER JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;

-- LEFT JOIN
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;
    
SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM tutorial.crunchbase_companies companies
  INNER JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;
    
SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;
    
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_companies_acquired
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
  WHERE companies.state_code IS NOT NULL
  GROUP BY companies.state_code
  ORDER BY unique_companies_acquired DESC;
 
/*** LESSON 14: SQL RIGHT JOIN
     See code and examples for RIGHT JOIN ***/
 
/* The RIGHT JOIN command */

-- LEFT JOIN
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;

-- RIGHT JOIN
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_acquisitions acquisitions
  RIGHT JOIN tutorial.crunchbase_companies companies
    ON companies.permalink = acquisitions.company_permalink;

SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_companies_acquired
  FROM tutorial.crunchbase_acquisitions acquisitions
  RIGHT JOIN tutorial.crunchbase_companies companies
    ON companies.permalink = acquisitions.company_permalink
  WHERE companies.state_code IS NOT NULL
  GROUP BY companies.state_code
  ORDER BY unique_companies_acquired DESC;
  
/*** LESSON 15: SQL Joins Using WHERE or ON
     Learn the differences between filtering joined data using WHERE or ON ***/

/* Filtering in the ON clause */

SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
  ORDER BY companies_permalink;

-- Filter one or both of the tables before joining them (conditional statement AND is evaluated before the join occurs)
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
    AND acquisitions.company_permalink != '/company/1000memories'
  ORDER BY companies_permalink;

/* Filtering in the WHERE clause */
-- Filter happens after the tables are joined
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
  WHERE acquisitions.company_permalink != '/company/1000memories'
    OR acquisitions.company_permalink IS NULL
  ORDER BY companies_permalink;
  
SELECT companies.name AS company_name,
       companies.status,
       COUNT(DISTINCT investments.investor_name) AS unqiue_investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 WHERE companies.state_code = 'NY'
 GROUP BY companies.name, companies.status
 ORDER BY unqiue_investors DESC;
 
SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
  GROUP BY investor
  ORDER BY companies_invested_in DESC;
 
/*** LESSON 16: SQL FULL OUTER JOIN
     Learn about SQL FULL OUTER JOIN, which returns unmatched rows from both tables being joined ***/
 
/* The SQL FULL JOIN command */
 
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
  FROM tutorial.crunchbase_companies companies
  FULL OUTER JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;
    
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NULL
                      THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NOT NULL
                      THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND investments.company_permalink IS NOT NULL
                      THEN investments.company_permalink ELSE NULL END) AS investments_only
  FROM tutorial.crunchbase_companies companies
  FULL JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink;
    
/*** LESSON 17: SQL UNION
     UNION allows you to stack one dataset on top of another dataset ***/

/* The SQL UNION operator */

-- Only appends distinct values (drops duplicate rows)
SELECT * FROM tutorial.crunchbase_investments_part1
 UNION
 SELECT * FROM tutorial.crunchbase_investments_part2;

-- Append all the values from the second table (keeps duplicate rows)
SELECT * FROM tutorial.crunchbase_investments_part1
 UNION ALL
 SELECT * FROM tutorial.crunchbase_investments_part2;
   
SELECT company_permalink,
       company_name,
       investor_name
  FROM tutorial.crunchbase_investments_part1
  WHERE company_name ILIKE 'T%'
 UNION ALL
SELECT company_permalink,
       company_name,
       investor_name
  FROM tutorial.crunchbase_investments_part2
  WHERE company_name ILIKE 'M%';

SELECT 'investments_part1' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
  GROUP BY dataset_name, companies.status
 UNION ALL
 SELECT 'investments_part2' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part2 investments
    ON companies.permalink = investments.company_permalink
  GROUP BY dataset_name, companies.status;
  
/*** LESSON 18: SQL Joins with Comparison Operators
     Use comparison operators with SQL joins, which is especially helpful for defining date ranges ***/

/* Using comparison operators with joins */

SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
    AND investments.funded_year > companies.founded_year + 5
  GROUP BY 1, 2, 3;
  
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
  WHERE investments.funded_year > companies.founded_year + 5
  GROUP BY 1, 2, 3;
  
/*** LESSON 19: SQL Joins on Multiple Keys
     Learn to join tables on multiple keys to boost performance and make SQL queries run faster ***/

/* Joining on multiple keys */

SELECT companies.permalink,
       companies.name,
       investments.company_name,
       investments.company_permalink
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
    AND companies.name = investments.company_name;
   
/*** LESSON 20: SQL Self Joins
     Learn the situations where you might want to join a table to itself, and how to do so ***/

/* Self joining tables */

SELECT DISTINCT japan_investments.company_name,
       japan_investments.company_permalink
  FROM tutorial.crunchbase_investments_part1 japan_investments
  JOIN tutorial.crunchbase_investments_part1 gb_investments
    ON japan_investments.company_name = gb_investments.company_name
    AND gb_investments.investor_country_code = 'GBR'
    AND gb_investments.funded_at > japan_investments.funded_at
  WHERE japan_investments.investor_country_code = 'JPN'
  ORDER BY japan_investments.company_name;