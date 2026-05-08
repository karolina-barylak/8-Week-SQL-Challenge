-- How many total transactions were there for each year in the dataset?
-- Ile transakcji łącznie odnotowano w każdym roku w zbiorze danych?

SELECT
    calendar_year,
    SUM(transactions) as total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year;