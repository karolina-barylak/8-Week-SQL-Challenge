-- Which age_band and demographic values contribute the most to Retail sales?
-- Które wartości „age_band” i „demographic” mają największy wpływ na sprzedaż Retail?


SELECT 
    age_band,
    demographic,
    SUM(sales) as total_sales,
    ROUND(SUM(sales) * 100.00 / SUM(SUM(sales)) OVER(), 2) as sales_percentage
FROM clean_weekly_sales
GROUP BY age_band, demographic
ORDER BY total_sales DESC;