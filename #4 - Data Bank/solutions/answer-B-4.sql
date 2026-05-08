-- What is the closing balance for each customer at the end of the month?
-- Jakie jest saldo końcowe dla każdego klienta na koniec miesiąca?

--SELECT * FROM customer_transactions where customer_id = 1;

WITH transition_monthly_sum_cte AS (
    SELECT 
        customer_id,
        (DATE_TRUNC('month', txn_date) + interval '1 month - 1 day') as txn_months,
        SUM(
            CASE
                WHEN txn_type = 'deposit' THEN txn_amount
                WHEN txn_type <> 'deposit' THEN -txn_amount
                ELSE 0
            END
        ) as transaction_sum
    FROM customer_transactions
    GROUP BY customer_id, txn_months
    ORDER BY customer_id
),
generate_months_cte AS(
    SELECT
        DISTINCT customer_id,
        '2020-01-31'::date + generate_series(0,3) * interval '1 month' as ending_month
    FROM customer_transactions
    ORDER BY customer_id, ending_month
)

SELECT
    gm_cte.customer_id,
    ending_month,
    SUM(COALESCE(tms_cte.transaction_sum, 0)) OVER(
        PARTITION BY gm_cte.customer_id 
        ORDER BY ending_month
    ) as monthly_balance
FROM generate_months_cte as gm_cte
LEFT JOIN transition_monthly_sum_cte as tms_cte
    ON gm_cte.customer_id = tms_cte.customer_id
    AND gm_cte.ending_month = tms_cte.txn_months
ORDER BY gm_cte.customer_id, ending_month;
