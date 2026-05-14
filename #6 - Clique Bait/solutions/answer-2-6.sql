-- What is the percentage of visits which view the checkout page but do not have a purchase event?
-- Jaki jest procent wizyt, podczas których wyświetlana jest strona płatności, ale nie następuje zakup?

WITH session_sum_cte AS(
    SELECT
        visit_id,
        MAX(CASE WHEN page_id = 12 THEN 1 ELSE 0 END) as checkout_event,
        MAX(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) as purchase_event
    FROM events
    GROUP BY visit_id
)

SELECT
    ROUND(
        COUNT(*) * 100.00 / (SELECT COUNT(DISTINCT visit_id) FROM events), 2) as percentage_from_all_visits
FROM session_sum_cte
WHERE checkout_event = 1 and purchase_event = 0;


