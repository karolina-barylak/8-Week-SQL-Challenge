-- What is the average total historical deposit counts and amounts for all customers?
-- Jaka jest łącznie średnia liczba i kwota depozytów dla wszystkich klientów?

WITH number_of_counts_cte AS(
    SELECT
        COUNT(customer_id) AS sum_customer_counts,
        SUM(txn_amount) AS sum_customer_amount
    FROM customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id
)

SELECT
    ROUND(AVG(sum_customer_counts), 0) as avg_deposit_counts,
    ROUND(AVG(sum_customer_amount), 2) as avg_amount
FROM number_of_counts_cte;