

-- Q1 What are the top 3 products by total revenue before discount?

SELECT
    product_name,
    SUM(sales.price * qty) as total_revenue
FROM sales
LEFT JOIN product_details
    ON sales.prod_id = product_details.product_id
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 3;

-- Q2 What is the total quantity, revenue and discount for each segment?

SELECT
    pd.segment_name,
    SUM(sales.qty) as total_quantity,
    SUM(sales.price * sales.qty) as total_revenue,
    ROUND(SUM(sales.price * sales.qty * sales.discount / 100.0), 2) as total_discount
FROM sales
INNER JOIN product_details pd
    ON sales.prod_id = pd.product_id
GROUP BY segment_name;

-- Q3 What is the top selling product for each segment?

WITH ranked_product_cte AS(
    SELECT
        pd.segment_name,
        pd.product_name,
        SUM(sales.qty) as total_quantity,
        DENSE_RANK() OVER 
            (PARTITION BY  segment_name 
            ORDER BY SUM(sales.qty) DESC) as rank
    FROM sales
    INNER JOIN product_details pd
        ON sales.prod_id = pd.product_id
    GROUP BY segment_name, product_name
)

SELECT
    segment_name,
    product_name,
    total_quantity
FROM ranked_product_cte
WHERE rank = 1;

-- Q4 What is the total quantity, revenue and discount for each category?

SELECT
    pd.category_name,
    SUM(sales.qty) as total_quantity,
    SUM(sales.price * sales.qty) as total_revenue,
    ROUND(SUM(sales.price * sales.qty * sales.discount / 100.0), 2) as total_discount
FROM sales
INNER JOIN product_details pd
    ON sales.prod_id = pd.product_id
GROUP BY pd.category_name;

-- Q5 What is the top selling product for each category?

WITH ranked_product_cte AS(
    SELECT
        pd.category_name,
        pd.product_name,
        SUM(sales.qty) as total_quantity,
        DENSE_RANK() OVER 
            (PARTITION BY  category_name 
            ORDER BY SUM(sales.qty) DESC) as rank
    FROM sales
    INNER JOIN product_details pd
        ON sales.prod_id = pd.product_id
    GROUP BY category_name, product_name
)

SELECT
    category_name,
    product_name,
    total_quantity
FROM ranked_product_cte
WHERE rank = 1;

-- Q6 What is the percentage split of revenue by product for each segment?

WITH product_revenue_cte AS (
    SELECT 
        pd.segment_name,
        pd.product_name,
        SUM(s.qty * s.price) as prod_revenue
    FROM sales s
    INNER JOIN product_details pd ON s.prod_id = pd.product_id
    GROUP BY pd.segment_name, pd.product_name
)
SELECT 
    segment_name,
    product_name,
    prod_revenue,
    ROUND(100.0 * prod_revenue / SUM(prod_revenue) OVER (PARTITION BY segment_name), 2) as percentage_revenue
FROM product_revenue_cte
ORDER BY segment_name, percentage_revenue DESC;

-- Q7 What is the percentage split of revenue by segment for each category?

WITH segment_revenue_cte AS (
    SELECT 
        pd.category_name,
        pd.segment_name,
        SUM(s.qty * s.price) as seg_revenue
    FROM sales s
    INNER JOIN product_details pd ON s.prod_id = pd.product_id
    GROUP BY pd.category_name, pd.segment_name
)
SELECT 
    category_name,
    segment_name,
    seg_revenue,
    ROUND(100.0 * seg_revenue / SUM(seg_revenue) OVER (PARTITION BY category_name), 2) as percentage_revenue
FROM segment_revenue_cte
ORDER BY category_name, percentage_revenue DESC;

-- Q8 What is the percentage split of total revenue by category?

WITH category_revenue_cte AS (
    SELECT 
        pd.category_name,
        SUM(s.qty * s.price) as categ_revenue
    FROM sales s
    INNER JOIN product_details pd ON s.prod_id = pd.product_id
    GROUP BY pd.category_name
)
SELECT 
    category_name,
    categ_revenue,
    ROUND(100.0 * categ_revenue / (SELECT SUM(qty * price) FROM sales), 2) as percentage_revenue
FROM category_revenue_cte
ORDER BY category_name, percentage_revenue DESC;

-- Q9 What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

SELECT 
    pd.product_name,
    COUNT(DISTINCT s.txn_id) as product_transactions,
    ROUND(100.0 * COUNT(DISTINCT s.txn_id) / (SELECT COUNT(DISTINCT txn_id) FROM sales), 2) as penetration_percentage
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
GROUP BY pd.product_name
ORDER BY penetration_percentage DESC;

-- Q10 What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

SELECT 
    pd1.product_name AS product_1,
    pd2.product_name AS product_2,
    pd3.product_name AS product_3,
    COUNT(*) AS times_bought_together
FROM sales s1
JOIN sales s2 ON s1.txn_id = s2.txn_id AND s1.prod_id < s2.prod_id
JOIN sales s3 ON s2.txn_id = s3.txn_id AND s2.prod_id < s3.prod_id
JOIN product_details pd1 ON s1.prod_id = pd1.product_id
JOIN product_details pd2 ON s2.prod_id = pd2.product_id
JOIN product_details pd3 ON s3.prod_id = pd3.product_id
GROUP BY pd1.product_name, pd2.product_name, pd3.product_name
ORDER BY times_bought_together DESC
LIMIT 1;