-- Q1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month

ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE
USING to_date(month_year, 'MM-YYYY');

-- Q2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?

SELECT
    month_year,
    COUNT(*) as count_of_records
FROM interest_metrics
GROUP BY month_year
ORDER BY month_year NULLS FIRST;

-- Q3. What do you think we should do with these null values in the fresh_segments.interest_metrics

SELECT
    interest_id
FROM interest_metrics
WHERE month_year IS NULL
ORDER BY interest_id;

-- Q4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?

SELECT
    COUNT(DISTINCT interest_id) as count_no_in_map
FROM interest_metrics
LEFT JOIN interest_map
    ON interest_metrics.interest_id::INTEGER = interest_map.id
WHERE id IS NULL;

SELECT
    COUNT(DISTINCT id) as count_no_in_metrics
FROM interest_map
LEFT JOIN interest_metrics
    ON interest_metrics.interest_id::INTEGER = interest_map.id
WHERE interest_id IS NULL;

-- Q5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table

-- SELECT 
--   COUNT(*) as total_records,
--   COUNT(id) as total_id,
--   COUNT(DISTINCT id) as unique_id
-- FROM interest_map;

SELECT
    id,
    interest_name,
    COUNT(*) as total_count
FROM interest_map
INNER JOIN interest_metrics
    ON interest_map.id = interest_metrics.interest_id::integer
GROUP BY id, interest_name
ORDER BY total_count DESC;