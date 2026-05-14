-- What are the top 3 products by purchases?
-- Jakie są top 3 produkty pod względem zakupów?

SELECT
    page_name,
    COUNT(*) AS purchases_count
FROM events
INNER JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
WHERE event_type = 2
    AND visit_id IN (
        SELECT
            visit_id
        FROM events
        WHERE event_type = 3
    )
GROUP BY page_name
ORDER BY purchases_count DESC
LIMIT 3;