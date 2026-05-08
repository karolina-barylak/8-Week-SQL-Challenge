-- What is the percentage of sales for Retail vs Shopify for each month?
-- Jaki jest procent sprzedaży Retail vs Shopify w poszczególnych miesiącach?

WITH monthly_total_sales_cte AS(
    SELECT
        month_number,
        calendar_year,
        SUM(sales) as sales_in_month
    FROM clean_weekly_sales
    GROUP BY month_number, calendar_year
),
total_platform_sales_cte AS(
    SELECT
        platform,
        month_number,
        calendar_year,
        SUM(sales) as total_sales
    FROM clean_weekly_sales
    GROUP BY platform, month_number, calendar_year
)

SELECT
    platform,
    tps_cte.calendar_year,
    tps_cte.month_number,
    ROUND(total_sales * 100.00 /sales_in_month, 2) as platform_sales_percentage
FROM total_platform_sales_cte as tps_cte
LEFT JOIN monthly_total_sales_cte
    ON tps_cte.month_number = monthly_total_sales_cte.month_number 
    AND tps_cte.calendar_year = monthly_total_sales_cte.calendar_year
ORDER BY tps_cte.calendar_year, tps_cte.month_number;