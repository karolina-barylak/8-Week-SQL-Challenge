-- What is the percentage of customers who increase their closing balance by more than 5%?
-- Jaki jest procent klientów, których saldo końcowe zwiększyło się o więcej niż 5%?

-- suma transakcji dla każdego klienta w każdym miesiącu
WITH monthly_transactions_cte AS (
    SELECT 
        customer_id,
        (DATE_TRUNC('month', txn_date) + interval '1 month - 1 day') as txn_months,
        SUM(
            CASE
                WHEN txn_type = 'deposit' THEN txn_amount
                ELSE -txn_amount
            END
        ) as sum_transactions
    FROM customer_transactions
    GROUP BY customer_id, txn_months
    ORDER BY customer_id
),

-- obliczanie bilansu końcowego dla każdego miesiąca
monthly_balances_cte AS (
    SELECT
        customer_id,
        txn_months,
        SUM(sum_transactions) OVER (
            PARTITION BY customer_id 
            ORDER BY txn_months
            ) as monthly_balance
    FROM monthly_transactions_cte
),

-- pobranie pierwszego i ostatniego salda
first_last_deposit_cte AS(
    SELECT
        customer_id,
        FIRST_VALUE(monthly_balance) OVER(
            PARTITION BY customer_id
            ORDER BY txn_months
        ) as first_month,
        LAST_VALUE(monthly_balance) OVER(
            PARTITION BY customer_id
            ORDER BY txn_months
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) as last_month
    FROM monthly_balances_cte
),

-- wytypowanie unikatowych klientów
unique_customers_balance_cte AS(
    SELECT
        DISTINCT customer_id,
        first_month,
        last_month
    FROM first_last_deposit_cte
)

SELECT
    ROUND(
        COUNT(
            CASE
                WHEN last_month > first_month * 1.05 THEN 1
            END
        ) * 100.00 / COUNT(*), 2
    ) AS percentage_of_customers
FROM unique_customers_balance_cte