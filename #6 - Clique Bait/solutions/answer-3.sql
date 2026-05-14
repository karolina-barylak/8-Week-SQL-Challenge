-- CREATE VIEW product_summary_view AS
-- WITH product_status_cte AS(
--     SELECT
--         page_name,
--         SUM(1) FILTER (WHERE event_type = 1) as views,
--         SUM(1) FILTER (WHERE event_type = 2) as add_card,
--         CASE
--             WHEN visit_id IN(
--                 SELECT
--                     visit_id
--                 FROM events
--                 WHERE event_type = 3
--             ) THEN 1 ELSE 0
--         END as is_purchased
--     FROM events as e
--     INNER JOIN page_hierarchy AS ph
--         ON e.page_id = ph.page_id
--     WHERE product_id IS NOT NULL
--     GROUP BY page_name, visit_id
-- )

-- SELECT
--     page_name,
--     SUM(views) as views,
--     SUM(add_card) as add_card,
--     SUM(1) FILTER (WHERE add_card = 1 AND is_purchased = 0) as abandoned,
--     SUM(1) FILTER (WHERE add_card = 1 AND is_purchased = 1) as purchased
-- FROM product_status_cte
-- GROUP BY page_name;

-- Q1 Which product had the most views, cart adds and purchases?

SELECT
    (SELECT page_name FROM product_summary_view ORDER BY views DESC LIMIT 1) as most_views,
    (SELECT page_name FROM product_summary_view ORDER BY add_card DESC LIMIT 1) as most_adds,
    (SELECT page_name FROM product_summary_view ORDER BY purchased DESC LIMIT 1) as most_purchases

-- Q2 Which product was most likely to be abandoned?

SELECT
    page_name,
    abandoned as most_abandoned
FROM product_summary_view
ORDER BY abandoned DESC
LIMIT 1;

-- Q3 Which product had the highest view to purchase percentage?

SELECT
    page_name,
    ROUND(purchased * 100.0 / views, 1) as view_to_purchase_rate
FROM product_summary_view
ORDER BY view_to_purchase_rate DESC
LIMIT 1;


-- Q4 What is the average conversion rate from view to cart add?

SELECT 
  ROUND(AVG(100.00 * add_card / views), 2) AS avg_view_to_cart_rate
FROM product_summary_view;


-- Q5 What is the average conversion rate from cart add to purchase?
SELECT 
  ROUND(AVG(100.0 * purchased / add_card), 2) AS avg_cart_to_purchase_rate
FROM product_summary_view;



-- WITH product_status_cte AS(
--     SELECT
--         product_category,
--         SUM(1) FILTER (WHERE event_type = 1) as views,
--         SUM(1) FILTER (WHERE event_type = 2) as add_card,
--         CASE
--             WHEN visit_id IN(
--                 SELECT
--                     visit_id
--                 FROM events
--                 WHERE event_type = 3
--             ) THEN 1 ELSE 0
--         END as is_purchased
--     FROM events as e
--     INNER JOIN page_hierarchy AS ph
--         ON e.page_id = ph.page_id
--     WHERE product_id IS NOT NULL
--     GROUP BY product_category, visit_id
-- )

-- SELECT
--     product_category,
--     SUM(views) as views,
--     SUM(add_card) as add_card,
--     SUM(1) FILTER (WHERE add_card = 1 AND is_purchased = 0) as abandoned,
--     SUM(1) FILTER (WHERE add_card = 1 AND is_purchased = 1) as purchased
-- FROM product_status_cte
-- GROUP BY product_category;