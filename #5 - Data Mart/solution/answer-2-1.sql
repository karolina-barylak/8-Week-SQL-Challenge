-- What day of the week is used for each week_date value?
-- Który dzień tygodnia jest używany dla każdej wartości week_date?


SELECT
    to_char(week_date, 'Day') as week_day,
    COUNT(*)
FROM clean_weekly_sales
GROUP BY week_day;