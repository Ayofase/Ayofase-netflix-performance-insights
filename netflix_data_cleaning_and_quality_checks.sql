--Data cleaning and data quality test

CREATE DATABASE netflix_project;
USE netflix_project;

-- adding a new column named content_type in the engagement dataset
ALTER TABLE updated_netflix_movie
ADD content_type VARCHAR(50);

UPDATE updated_netflix_movie
SET content_type = 'Movie';

ALTER TABLE updated_netflix_tv
 ADD content_type VARCHAR(50);

UPDATE updated_netflix_tv
 SET content_type = 'TV Show';

-- combining both updated_netflix_movie and updated_netflix_tv
SELECT 
	title, release_date, runtime, hours_viewed, views, content_type
INTO 
	netflix_combine_data
FROM 
	updated_netflix_movie
UNION  
SELECT 
	title, release_date, runtime, hours_viewed, views, content_type
FROM 
	updated_netflix_tv;

--checking combined data
SELECT *
FROM netflix_combine_data

SELECT *
FROM cleaned_netflix_revenue_by_region;

EXEC sp_rename 'cleaned_netflix_revenue_by_region.latm_streaming_evenue', 'latm_streaming_revenue', 'COLUMN'
EXEC sp_rename 'cleaned_netflix_revenue_by_region.date', 'dates', 'COLUMN';


--standardizing the arpu column into 2 decimal
UPDATE cleaned_netflix_revenue_by_region
 SET ucan_arpu = ROUND(ucan_arpu, 2),
 emea_arpu = ROUND(emea_arpu, 2),
 latm_arpu = ROUND(latm_arpu, 2),
 apac_arpu = ROUND(apac_arpu, 2);

--Data quality test for the two dataset
--cheking the row count
SELECT 
  COUNT (*)                                                                     --number of rows = 21
FROM 
  cleaned_netflix_revenue_by_region;

SELECT  COUNT (*)                                                               --number of rows = 15419
FROM netflix_combine_data;

-- checking column count
SELECT 
 COUNT(*) AS column_count
FROM
 INFORMATION_SCHEMA.COLUMNS                                                      -- number of column = 15
WHERE 
 table_name = 'cleaned_netflix_revenue_by_region';

SELECT 
 COUNT(*) AS column_count
FROM
 INFORMATION_SCHEMA.COLUMNS                                                       -- number of column = 5  
WHERE 
 table_name = 'netflix_combine_data';

--checking data type of each column
SELECT 
 COLUMN_NAME,
 DATA_TYPE
FROM
 INFORMATION_SCHEMA.COLUMNS                     
WHERE 
 table_name = 'cleaned_netflix_revenue_by_region';

SELECT 
 COLUMN_NAME,
 DATA_TYPE
FROM
 INFORMATION_SCHEMA.COLUMNS                     
WHERE 
 table_name = 'netflix_combine_data';

 --checking for null
SELECT *                               
FROM 
  cleaned_netflix_revenue_by_region
WHERE 
 dates IS NULL 
  AND global_plus_dvd_revenue IS NULL 
  AND ucan_streaming_revenue IS NULL 
  AND emea_streaming_revenue IS NULL 
  AND latm_streaming_revenue IS NULL 
  AND apac_streaming_revenue IS NULL 
  AND ucan_members IS NULL                                                                   --no null
  AND emea_members IS NULL 
  AND latm_members IS NULL 
  AND apac_members IS NULL
  AND ucan_arpu IS NULL
  AND emea_arpu IS NULL
  AND latm_arpu IS NULL
  AND apac_arpu IS NULL
  AND netflix_streaming_membership IS NULL;

SELECT *
FROM netflix_combine_data
WHERE release_date IS NULL OR runtime IS NULL OR hours_viewed IS NULL;


SELECT COUNT(*)
FROM netflix_combine_data                                                       -- 1400 release_date null values           
WHERE release_date IS NULL;

 SELECT COUNT(*)
FROM netflix_combine_data                                                        --363 total runtime null values        
WHERE runtime IS NULL;

SELECT *
FROM netflix_combine_data                                                        --1 total hours_viewed  null values        
WHERE hours_viewed  IS NULL;
 

--handling null/NA
UPDATE netflix_combine_data
SET 
 runtime = CAST(ISNULL(runtime, '00:00:00') AS TIME),
 release_date = CAST(ISNULL(release_date, '1900-01-01') AS DATE) 


--checking for duplicates

SELECT dates,
  COUNT (*)  AS duplicates                                 
FROM                                                                               -- no duplicate
  cleaned_netflix_revenue_by_region
GROUP BY dates 
HAVING 
 COUNT (*)> 1;

SELECT release_date,
  COUNT (*)  AS duplicates                                                   -- this duplicates are okay because of quarterly grouping of the release date 
FROM 
  netflix_combine_data
GROUP BY release_date
HAVING
  COUNT (*) > 1;

-- handling duplicate by categorising date into quarterly
ALTER TABLE netflix_combine_data
ADD  runtime_min INT

UPDATE netflix_combine_data
SET 
	runtime_min = CAST(DATEDIFF(SECOND, '00:00:00', ISNULL(runtime, '00:00:00')) AS INT)/60,
	runtime = CAST(ISNULL(runtime, '00:00:00') AS TIME),
	release_date = CAST(ISNULL(release_date, '1900-01-01') AS DATE)                               -- Handle NULL release_date with default value

ALTER TABLE netflix_combine_data
ALTER COLUMN views BIGINT;                                                                     -- changing data type from INT to BIGNIT since total_views exceed INT limit

ALTER TABLE netflix_combine_data           
ALTER COLUMN hours_viewed BIGINT;                                                             -- changing data type from INT to BIGNIT since total_hours_viewed exceed INT limit

--creating a view of release_date grouped quarterly

CREATE VIEW quarterly_netflix_engagement AS
SELECT 
	content_type, 
	AVG(runtime_min) AS avg_runtime,
	YEAR(release_date) AS years,
	DATEPART(QUARTER, release_date) AS quarters,
	COUNT (content_type) AS no_content_type,
	SUM(views) AS total_views,
	SUM(hours_viewed) AS total_hours_viewed
FROM 
	netflix_combine_data
WHERE 
	release_date >= '2019-01-01' AND release_date <= '2024-12-31'
GROUP BY 
	YEAR(release_date),
	DATEPART(QUARTER, release_date), content_type;



	--checking the newly created view
SELECT *
FROM 
	quarterly_netflix_engagement
ORDER BY 
	years, quarters



-- checking for the derived columns in cleaned_netflix_revenue_by_region  
SELECT 
	netflix_streaming_membership, ucan_members + emea_members + latm_members + apac_members AS total_members
FROM 
	cleaned_netflix_revenue_by_region                                                                              -- no result found
WHERE 
	netflix_streaming_membership != (ucan_members + emea_members + latm_members + apac_members);

SELECT  
	ucan_arpu,
    ROUND(AVG(CAST(ucan_streaming_revenue AS DECIMAL(18, 2)) / CAST(ucan_members AS DECIMAL(18, 2))) / 3, 2) AS new_ucan_arpu,
	emea_arpu,
    ROUND(AVG(CAST(emea_streaming_revenue AS DECIMAL(18, 2)) / CAST(emea_members AS DECIMAL(18, 2))) / 3, 2) AS new_emea_arpu,
	latm_arpu,
    ROUND(AVG(CAST(latm_streaming_revenue AS DECIMAL(18, 2)) / CAST(latm_members AS DECIMAL(18, 2))) / 3, 2) AS new_latm_arpu,
	apac_arpu,
    ROUND(AVG(CAST(apac_streaming_revenue AS DECIMAL(18, 2)) / CAST(apac_members AS DECIMAL(18, 2))) / 3, 2) AS new_apac_arpu
FROM 
    cleaned_netflix_revenue_by_region  
GROUP BY 
    ucan_arpu,                                                                                                                    -- 
	emea_arpu,
	latm_arpu,
	apac_arpu;


SELECT *
INTO netflix_tv_movies
FROM netflix_engagement_with_titles
WHERE release_date >= '2019-01-01'