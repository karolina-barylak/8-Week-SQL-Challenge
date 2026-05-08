-- How many cookies does each user have on average?
-- Ile plików cookie ma średnio każdy użytkownik?

WITH cookie_cte AS(
    SELECT
        user_id,
        COUNT(cookie_id) as cookie_count
    FROM users
    GROUP BY user_id
)

SELECT
    ROUND(AVG(cookie_count),0) as avg_cookie_id
FROM cookie_cte;