-- What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
-- Jaka jest całkowita sprzedaż za 4 tygodnie przed i po 15.06.2020 r.? Jaki jest wskaźnik wzrostu lub spadku rzeczywistych wartości i procent sprzedaży?


-- SELECT
--     DISTINCT week_number
-- FROM clean_weekly_sales
-- WHERE week_date = '2020-06-15'

WITH total_sales_week_cte AS(
    SELECT
        week_date,
        week_number,
        SUM(sales) as total_sales
    FROM clean_weekly_sales
    WHERE (week_number BETWEEN 21 AND 28)
        AND calendar_year = 2020
    GROUP BY week_date, week_number
),
before_after_date_cte AS(
    SELECT
        SUM(CASE
            WHEN week_number BETWEEN 21 AND 24 THEN total_sales
        END) as before_date,
        SUM(CASE
            WHEN week_number BETWEEN 25 AND 28 THEN total_sales
        END) as after_date
    FROM total_sales_week_cte
)

SELECT
    after_date - before_date AS sales_diff,
    ROUND((after_date - before_date) * 100 / before_date, 2) as diff_percentage
FROM before_after_date_cte;