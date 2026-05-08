-- What is the total count of transactions for each platform
-- Jaka jest łączna liczba transakcji dla każdej platformy?

SELECT
    platform,
    SUM(transactions) as total_transactions
FROM clean_weekly_sales
GROUP BY platform;