-- What is the number of views and cart adds for each product category?
-- Jaka jest liczba wyświetleń i dodanych do koszyka produktów dla każdej kategorii?

SELECT
    product_category,
    SUM(1) FILTER(WHERE event_type = 1) as number_of_views,
    SUM(1) FILTER(WHERE event_type = 2) as number_of_add
FROM events
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
WHERE product_category IS NOT NULL
GROUP BY product_category;