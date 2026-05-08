-- What is the unique count and total amount for each transaction type?
-- Jaka jest unikatowa liczba i całkowita kwota dla każdego typu transakcji?

SELECT
    txn_type,
    COUNT(*) as unique_transaction,
    SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type;