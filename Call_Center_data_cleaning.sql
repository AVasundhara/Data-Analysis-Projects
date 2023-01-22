-- Initial code to  create database 
CREATE SCHEMA CCPROJECT;
-- then added table calls directly
Use ccproject;
SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where
table_schema = 'ccproject' and table_name = 'calls';
SELECT * FROM calls;
SET SQL_SAFE_UPDATES = 0;
UPDATE calls SET  csat_score = 0 WHERE csat_score = '';
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM calls;
SET SQL_SAFE_UPDATES = 0;
Alter table calls modify column csat_score int;
SET SQL_SAFE_UPDATES = 1;
SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where
table_schema = 'ccproject' and table_name = 'calls';
select column_name,data_type from information_schema.columns where table_schema = 'ccproject' and table_name = 'calls';
-- The call_timestamp is a string, so we need to convert it to a date
SET SQL_SAFE_UPDATES = 0;
UPDATE calls SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");
-- note Y alone is capital.
SET SQL_SAFE_UPDATES =1;
SELECT * FROM calls LIMIT 10;
-- Initially we have replaced the blank values to 0 in csat_score (text format version). But 0 is not the score provided by customer. It must be null, because presence of 0 may affect our calculation.
SET SQL_SAFE_UPDATES = 0;
UPDATE calls SET csat_score = NULL where csat_score = 0;
SET SQL_SAFE_UPDATES =1;
SELECT * FROM calls LIMIT 10;

-- ###****EDA****### --

-- lets see the shape of our data, i.e, the number of rows and columns

SELECT COUNT(*) AS row_num FROM calls;
SELECT COUNT(*) AS cols_num FROM information_schema.columns WHERE table_name = 'calls';

-- Checking the distinct values of some columns:
SELECT DISTINCT sentiment FROM calls;
SELECT DISTINCT reason FROM calls;
SELECT DISTINCT channel FROM calls;
SELECT DISTINCT response_time FROM calls;
SELECT DISTINCT call_center FROM calls;

SELECT sentiment, count(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;
SELECT reason, count(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;
SELECT channel, count(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;
SELECT response_time, count(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;
SELECT call_center, count(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

Select state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;
SELECT DAYNAME(call_timestamp) as DAY_of_Call, count(*) as num_of_calls 
FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Aggregations:

SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),1) AS avg_score 
FROM calls WHERE csat_score !=0; 
-- #Mysql added 0 to blank rows. But the min is 1.
SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;
SELECT MIN(`call duration in minutes`) AS min_call_duration, MAX(`call duration in minutes`) AS max_call_duration, 
AVG(`call duration in minutes`) AS avg_call_duration FROM calls;
-- use `` when there is space in column name
SELECT call_center, response_time, count(*) as count FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;
SELECT call_center, AVG(`call duration in minutes`) FROM calls GROUP BY 1 ORDER BY 2 DESC;
SELECT channel, AVG(`call duration in minutes`) FROM calls GROUP BY 1 ORDER BY 2 DESC;
SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;
SELECT state, reason, COUNT(*) from calls GROUP BY 1,2 ORDER BY 1,2,3 DESC;
SELECT state, sentiment, COUNT(*) from calls GROUP BY 1,2 ORDER BY 1,3 DESC;
SELECT state, AVG(csat_score) as avg_csat_score FROM calls WHERE csat_score !=0 GROUP BY 1 ORDER BY 2 DESC;
SELECT sentiment, AVG(`call duration in minutes`) FROM calls GROUP BY 1 ORDER BY 2 DESC;
SELECT call_timestamp, MAX(`call duration in minutes`) OVER(PARTITION BY call_timestamp) AS max_call_duration 
FROM calls GROUP BY 1 ORDER BY 2 DESC;