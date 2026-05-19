
-- Q1. How many unique transactions were there?
SELECT
    COUNT(DISTINCT txn_id) as unique_transaction
FROM sales;

-- Q2. What is the average unique products purchased in each transaction?

WITH products_count_cte AS(
    SELECT
        txn_id,
        COUNT(DISTINCT prod_id) as products_per_transaction
    FROM sales
    GROUP BY txn_id
)

SELECT
    ROUND(AVG(products_per_transaction)) as average_unique_products
FROM products_count_cte;

-- Q3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

WITH txn_revenue_cte AS(
    SELECT
        txn_id,
        SUM(price * qty) as total_revenue
    FROM sales
    GROUP BY txn_id
)

SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue) as percentile_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_revenue) as percentile_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue) as percentile_75
FROM txn_revenue_cte;

-- Q4. What is the average discount value per transaction?

WITH discount_per_transaction_cte AS(
    SELECT
        txn_id,
        SUM(price * qty * (discount / 100.0)) as discount_value
    FROM sales
    GROUP BY txn_id
)
SELECT 
    ROUND(AVG(discount_value), 2) as avg_discount_value
FROM discount_per_transaction_cte;

-- Q5. What is the percentage split of all transactions for members vs non-members?

SELECT
    ROUND(COUNT(DISTINCT txn_id) FILTER (WHERE member = 'f') * 100.0 /COUNT(DISTINCT txn_id)) as number_of_non_member,
    ROUND(COUNT(DISTINCT txn_id) FILTER (WHERE member = 't') * 100.0 /COUNT(DISTINCT txn_id)) as number_of_member
FROM sales;

-- Q6. What is the average revenue for member transactions and non-member transactions?

WITH total_revenue_cte AS(
    SELECT
        member,
        txn_id,
        SUM(price * qty) as revenue
    FROM sales
    GROUP BY member, txn_id
)
SELECT
    member,
    ROUND(AVG(revenue), 2) as avg_revenue
FROM total_revenue_cte
GROUP BY member