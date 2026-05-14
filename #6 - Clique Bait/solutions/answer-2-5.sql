-- What is the percentage of visits which have a purchase event?
-- Jaki jest procent wizyt, w trakcie których następuje dokonanie zakupu?


SELECT
    COUNT(visit_id) * 100/
        (SELECT COUNT(DISTINCT visit_id) FROM events) as percentage_of_purchase
FROM events
WHERE event_type = 3;