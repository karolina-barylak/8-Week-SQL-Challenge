
CREATE TABLE clean_weekly_sales as(
    SELECT
        week_date::date,
        DATE_PART('week', week_date::date) as week_number,
        DATE_PART('month', week_date::date) as month_number,
        DATE_PART('year', week_date::date) as calendar_year,
        region,
        platform,
        CASE
            WHEN segment LIKE 'null' THEN 'unkown'
            ELSE segment
        END as segment,
        CASE
            WHEN segment LIKE '%1' THEN 'Young Adults'
            WHEN segment LIKE '%2' THEN 'Middle Aged'
            WHEN segment LIKE '%3' OR segment LIKE '%4' THEN 'Retirees'
            ELSE 'unknown'
        END as age_band,
        CASE
            WHEN segment LIKE 'C%' THEN 'Couples'
            WHEN segment LIKE 'F%' THEN 'Families'
            ELSE 'unknown'
        END as demographic,
        customer_type,
        transactions,
        ROUND(sales::NUMERIC / transactions, 2) as avg_transaction,
        sales
    FROM weekly_sales
);

-- SELECT 
--     DISTINCT month_number 
-- FROM clean_weekly_sales;