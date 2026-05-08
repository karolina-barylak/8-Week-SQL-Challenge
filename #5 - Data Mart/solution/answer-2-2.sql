-- What range of week numbers are missing from the dataset?
-- Jaki zakres numerów tygodniowych brakuje w zestawie danych?

WITH number_generate_cte AS(
    SELECT
        GENERATE_SERIES(1,52) as all_week_numbers
)

SELECT
    DISTINCT all_week_numbers as missing_week_numbers
FROM number_generate_cte
LEFT JOIN clean_weekly_sales
   ON clean_weekly_sales.week_number = number_generate_cte.all_week_numbers
WHERE week_number IS NULL;