-- For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
-- Dla każdego miesiaca - ile klientów Data Bank dokonuje więcej niż jednej wpłaty oraz jednego zakupu lub jednej wypłaty w ciągu jednego miesiąca?

WITH number_of_type_transaction_cte AS(
    SELECT
        customer_id,
        DATE_PART('month', txn_date) as txn_date_month,
        SUM(
            CASE
                WHEN txn_type = 'deposit' THEN 1
            END
        ) AS sum_deposit_transaction,
        SUM(
            CASE
                WHEN txn_type = 'purchase' THEN 1
            END
        ) AS sum_purchase_transaction,
        SUM(
            CASE
                WHEN txn_type = 'withdrawal' THEN 1
            END
        ) AS sum_withdrawal_transaction
    FROM customer_transactions
    GROUP BY customer_id, txn_date_month
    ORDER BY customer_id
)

SELECT
    txn_date_month,
    COUNT(customer_id)
FROM number_of_type_transaction_cte
WHERE sum_deposit_transaction > 1
    AND (sum_purchase_transaction IS NOT NULL OR sum_withdrawal_transaction IS NOT NULL)
GROUP BY txn_date_month
ORDER BY txn_date_month;