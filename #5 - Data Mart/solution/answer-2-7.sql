-- What is the percentage of sales by demographic for each year in the dataset?
-- Jaki jest procent sprzedaży według grup demograficznych w każdym roku?

WITH year_sales_cte AS(
    SELECT
        calendar_year,
        SUM(sales) as total_year_sales
    FROM clean_weekly_sales
    GROUP BY calendar_year
),
total_demographic_sales_cte AS(
    SELECT
        calendar_year,
        demographic,
        SUM(sales) as demographic_sales
    FROM clean_weekly_sales
    GROUP BY calendar_year, demographic
)

SELECT
    tds_cte.calendar_year,
    demographic,
    ROUND(demographic_sales * 100.00 / total_year_sales, 2) as demographic_sales_percentage
FROM total_demographic_sales_cte as tds_cte
LEFT JOIN year_sales_cte
    ON tds_cte.calendar_year = year_sales_cte.calendar_year
ORDER BY tds_cte.calendar_year, demographic;
