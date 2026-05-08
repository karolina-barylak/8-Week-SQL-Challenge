-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
-- Jak wskaźniki sprzedaży dla tych dwóch okresów przed i po mają się do poprzednich lat 2018 i 2019?

WITH total_sales_year_cte AS(
    SELECT
        calendar_year,
        week_number,
        SUM(sales) as total_sales
    FROM clean_weekly_sales
    GROUP BY calendar_year, week_number
),
before_after_date_cte AS(
    SELECT
        calendar_year,
        SUM(CASE
            WHEN week_number BETWEEN 13 AND 24 THEN total_sales
        END) as before_date,
        SUM(CASE
            WHEN week_number BETWEEN 25 AND 36 THEN total_sales
        END) as after_date
    FROM total_sales_year_cte
    GROUP BY calendar_year
)

SELECT
    calendar_year,
    after_date - before_date AS sales_diff,
    ROUND((after_date - before_date) * 100 / before_date, 2) as diff_percentage
FROM before_after_date_cte;