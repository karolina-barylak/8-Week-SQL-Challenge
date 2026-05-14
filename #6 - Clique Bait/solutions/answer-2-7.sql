-- What are the top 3 pages by number of views?
-- Jakie są top 3 strony pod względem wyświetleń?

SELECT
    page_name,
    COUNT(*) as number_of_visits
FROM events
LEFT JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
WHERE event_type = 1
GROUP BY page_name
ORDER BY number_of_visits DESC
LIMIT 3;