-- What is the number of events for each event type?
-- Jaka jest liczba zdarzeń dla każdego typu zdarzenia?

SELECT
    event_type,
    COUNT(event_type) as number_of_events
FROM events
GROUP BY event_type
ORDER BY event_type;