-------------------------------
-- High Level Sales Analysis --
-------------------------------

-- Q1 What was the total quantity sold for all products?
-- Q2 What is the total generated revenue for all products before discounts?
-- Q3 What was the total discount amount for all products?

SELECT
    SUM(qty) as total_quantity,
    SUM(qty * price) as total_revenue_before_discounts,
    ROUND(SUM(qty * price * (discount / 100.0)), 2) as total_discount_amount
FROM sales;

-- Q2 