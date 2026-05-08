-- What is the total sales for each region for each month?
-- Jaka jest całkowita sprzedaż w każdym regionie w każdym miesiącu?

SELECT
    region,
    month_number,
    SUM(sales) as total_sales
FROM clean_weekly_sales
GROUP BY region, month_number
ORDER BY month_number, region;