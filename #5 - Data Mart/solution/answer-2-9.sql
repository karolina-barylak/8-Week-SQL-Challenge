-- Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
-- Czy możemy użyć kolumny avg_transaction, aby znaleźć średnią wielkość transakcji w danym roku dla Retail i Shopify? Jeśli nie, jak ją obliczyć?

SELECT
    calendar_year,
    platform,
    SUM(sales) / SUM(transactions) as avg_transactions_calc,
    ROUND(AVG(avg_transaction),0) as avg_transactions_row
FROM clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform;