-- What about the entire 12 weeks before and after?
-- A co z całym okresem 12 tygodni przed i po?

-- SELECT
--     DISTINCT week_number
-- FROM clean_weekly_sales
-- WHERE week_date = '2020-06-15'A

WITH total_sales_week_cte AS(
    SELECT
        week_date,
        week_number,
        SUM(sales) as total_sales
    FROM clean_weekly_sales
    WHERE (week_number BETWEEN 13 AND 36)
        AND calendar_year = 2020
    GROUP BY week_date, week_number
),
before_after_date_cte AS(
    SELECT
        SUM(CASE
            WHEN week_number BETWEEN 13 AND 24 THEN total_sales
        END) as before_date,
        SUM(CASE
            WHEN week_number BETWEEN 25 AND 36 THEN total_sales
        END) as after_date
    FROM total_sales_week_cte
)

SELECT
    after_date - before_date AS sales_diff,
    ROUND((after_date - before_date) * 100 / before_date, 2) as diff_percentage
FROM before_after_date_cte;