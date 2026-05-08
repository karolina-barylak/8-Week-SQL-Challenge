WITH monthly_transactions AS (
  -- Obliczamy sumę transakcji dla każdego klienta w każdym miesiącu
  SELECT 
    customer_id, 
    DATE_TRUNC('month', txn_date) AS txn_month,
    SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END) AS net_amount
  FROM customer_transactions
  GROUP BY customer_id, txn_month
),
monthly_balances AS (
  -- Obliczamy saldo końcowe dla każdego miesiąca (running total)
  SELECT 
    customer_id, 
    txn_month,
    SUM(net_amount) OVER (
      PARTITION BY customer_id 
      ORDER BY txn_month 
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS closing_balance
  FROM monthly_transactions
)
--,opening_vs_closing AS (
  -- Wybieramy saldo z pierwszego i ostatniego dostępnego miesiąca
  SELECT 
    customer_id,
    FIRST_VALUE(closing_balance) OVER (PARTITION BY customer_id ORDER BY txn_month) AS opening_balance,
    LAST_VALUE(closing_balance) OVER (
      PARTITION BY customer_id 
      ORDER BY txn_month 
      RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS final_balance
  FROM monthly_balances
--),
growth_check AS (
  -- Filtrujemy unikalnych klientów i sprawdzamy warunek > 5%
  SELECT DISTINCT
    customer_id,
    opening_balance,
    final_balance
  FROM opening_vs_closing
)
SELECT 
  ROUND(
    100.0 * COUNT(CASE WHEN final_balance > opening_balance * 1.05 THEN 1 END) / COUNT(*), 
    2
  ) AS percentage_of_customers
FROM growth_check;