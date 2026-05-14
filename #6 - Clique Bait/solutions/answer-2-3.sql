-- What is the unique number of visits by all users per month?
-- Jaka jest unikalna liczba wizyt wszystkich użytkowników w miesiącu?

SELECT
    DATE_PART('month', event_time) as month,
    COUNT(distinct visit_id) as unique_visits
FROM events
GROUP BY month;