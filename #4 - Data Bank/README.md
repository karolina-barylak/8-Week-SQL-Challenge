<div align="center">

# Case Study #4 - Date Bank </br>

<img src="img/case-logo.png" alt="Logo case study 4" width="500" height="500">
</div>

## 💡 Informacje

W folderze _solutions_ znajdują się pliki z rozwiązaniami w SQL.</br>
Do wykonania wykorzystany został SQL oraz PostgreSQL.</br>
Szczegółowe informacje dotyczące tego studium przypadku znajdują się [tutaj](https://8weeksqlchallenge.com/case-study-4/).

## 📋 Spis treści

- [Opis](#-opis)
- [Diagram relacji](#-diagram-relacji)
- [Rozwiązanie: A. Customer Nodes Exploration](#️-a-customer-nodes-exploration)
  - [1. How many unique nodes are there on the Data Bank system?](#1-how-many-unique-nodes-are-there-on-the-data-bank-system)
  - [2. What is the number of nodes per region?](#2-what-is-the-number-of-nodes-per-region)
  - [3. How many customers are allocated to each region?](#3-how-many-customers-are-allocated-to-each-region)
  - [4. How many days on average are customers reallocated to a different node?](#4-how-many-days-on-average-are-customers-reallocated-to-a-different-node)
  - [5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?](#5-what-is-the-median-80th-and-95th-percentile-for-this-same-reallocation-days-metric-for-each-region)
- [Rozwiązanie: B. Customer Transactions](#️-b-customer-transactions)
  - [1. What is the unique count and total amount for each transaction type?](#1-what-is-the-unique-count-and-total-amount-for-each-transaction-type)
  - [2. What is the average total historical deposit counts and amounts for all customers?](#2-what-is-the-average-total-historical-deposit-counts-and-amounts-for-all-customers)
  - [3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?](#3-for-each-month---how-many-data-bank-customers-make-more-than-1-deposit-and-either-1-purchase-or-1-withdrawal-in-a-single-month)
  - [4. What is the closing balance for each customer at the end of the month?](#4-what-is-the-closing-balance-for-each-customer-at-the-end-of-the-month)
  - [5. What is the percentage of customers who increase their closing balance by more than 5%?](#5-what-is-the-percentage-of-customers-who-increase-their-closing-balance-by-more-than-5)

## 🔍 Opis

### Wprowadzenie

Danny stworzył Data Bank, bank, który łączy w sobie klasyczne, stare banki oraz banki nowych czasów zajmujące się kryptowalutami i danymi. Nie jest to jedynie bank cyfrowy, jest także najbezpieczniejszą na świecie platformą do przechowywania danych rozproszonych.</br>
Klienci otrzymują limity przechowywania danych w chmurze, które są powiązane z tym, ile klient ma pieniedzy na koncie.

### Problem

Zespół zarządzający chce zwiększyć całkowitą bazę klientów oraz potrzebuje pomocy w śledzeniu ile danych do przechowywania będą potrzebować ich klienci.</br>
To studium skupia się na wskaźnikach wzrostu i pomaganie firmom w analizowaniu swoich danych.

## 📈 Diagram relacji

<div align=center>
<img src="img/diagram.png" alt="Diagram relacji" width="80%" height="80%">
</div>

Tabela 1: `Regions`

| region_id | region_name |
| :-------: | :---------: |
|     1     |   Afryka    |
|     2     |   Ameryka   |
|     3     |    Azji     |
|     4     |   Europa    |
|     5     |   Oceanii   |

Tabela 2: `Customer Nodes`

| customer_id |  txn_date  | txn_type | txn_amount |
| :---------: | :--------: | :------: | :--------: |
|     429     | 2020-01-21 | deposit  |     82     |
|     155     | 2020-01-10 | deposit  |    712     |
|     398     | 2020-01-01 | deposit  |    196     |
|     255     | 2020-01-14 | deposit  |    563     |
|     185     | 2020-01-29 | deposit  |    626     |
|     309     | 2020-01-13 | deposit  |    995     |
|     312     | 2020-01-20 | deposit  |    485     |
|     376     | 2020-01-03 | deposit  |    706     |
|     188     | 2020-01-13 | deposit  |    601     |
|     138     | 2020-01-11 | deposit  |    520     |

Tabela 3: `Customer Transactions`

## ⚙️ A. Customer Nodes Exploration

### 1. How many unique nodes are there on the Data Bank system?

_Ile unikalnych węzłów znajduje się w systemie Banku Danych?_

```sql
SELECT
    COUNT(DISTINCT node_id) as unique_nodes
FROM customer_nodes;
```

#### Wynik zapytania/Odpowiedź:

| unique_nodes |
| :----------: |
|      5       |

---

### 2. What is the number of nodes per region?

_Jaka jest liczba węzłów na region?_

```sql
SELECT
    region_name,
    COUNT(node_id) as number_of_nodes,
    COUNT(DISTINCT node_id) as numer_of_unique_nodes
FROM customer_nodes as cn
INNER JOIN regions
    ON cn.region_id = regions.region_id
GROUP BY region_name;
```

#### Wynik zapytania/Odpowiedź:

| region_name | number_of_nodes | numer_of_unique_nodes |
| :---------: | :-------------: | :-------------------: |
|   Africa    |       714       |           5           |
|   America   |       735       |           5           |
|    Asia     |       665       |           5           |
|  Australia  |       770       |           5           |
|   Europe    |       616       |           5           |

---

### 3. How many customers are allocated to each region?

_Ilu klientów jest przydzielonych do każdego regionu?_

```sql
SELECT
    region_name,
    COUNT(DISTINCT customer_id) as customers_per_region
FROM customer_nodes
INNER JOIN regions
    ON customer_nodes.region_id = regions.region_id
GROUP BY region_name;
```

#### Wynik zapytania/Odpowiedź:

| region_name | customers_per_region |
| :---------: | :------------------: |
|   Africa    |         102          |
|   America   |         105          |
|    Asia     |          95          |
|  Australia  |         110          |
|   Europe    |          88          |

---

### 4. How many days on average are customers reallocated to a different node?

_Przez ile dni średnio klienci są przenoszeni do innego węzła?_

```sql
WITH node_days AS(
    SELECT
        customer_id,
        node_id,
        SUM(end_date - start_date) as days_in_node
    FROM customer_nodes
    WHERE end_date != '9999-12-31'
    GROUP BY customer_id, node_id
)

SELECT
    ROUND(AVG(days_in_node), 0) as avg_days_in_node
FROM node_days;
```

#### Wynik zapytania/Odpowiedź:

| avg_days_in_node |
| :--------------: |
|        24        |

---

### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

_Jaka jest mediana, 80. i 95. percentyl dla tej samej liczby dni realokacji dla każdego regionu?_

```sql
WITH node_days AS(
    SELECT
        customer_id,
        node_id,
        region_id,
        SUM(end_date - start_date) as days_in_node
    FROM customer_nodes
    WHERE end_date != '9999-12-31'
    GROUP BY customer_id, node_id, region_id
)

SELECT
    region_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_in_node)::integer AS median,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY days_in_node)::integer AS percentile_80th,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days_in_node)::integer AS percentile_95th
FROM node_days
INNER JOIN regions
    ON node_days.region_id = regions.region_id
GROUP BY region_name;
```

#### Wynik zapytania/Odpowiedź:

| region_name | median | percentile_80th | percentile_95th |
| :---------: | :----: | :-------------: | :-------------: |
|   Africa    |   22   |       35        |       54        |
|   America   |   22   |       34        |       54        |
|    Asia     |   22   |       35        |       52        |
|  Australia  |   21   |       34        |       51        |
|   Europe    |   23   |       34        |       51        |

---

## ⚙️ B. Customer Transactions

### 1. What is the unique count and total amount for each transaction type?

_Jaka jest unikatowa liczba i całkowita kwota dla każdego typu transakcji?_

```sql
SELECT
    txn_type,
    COUNT(*) as unique_transaction,
    SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type;
```

#### Wynik zapytania/Odpowiedź:

|  txn_type  | unique_transaction | total_amount |
| :--------: | :----------------: | :----------: |
|  purchase  |        1617        |    806537    |
| withdrawal |        1580        |    793003    |
|  deposit   |        2671        |   1359168    |

---

### 2. What is the average total historical deposit counts and amounts for all customers?

_Jaka jest łącznie średnia liczba i kwota depozytów dla wszystkich klientów?_

```sql
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
```

#### Wynik zapytania/Odpowiedź:

| avg_deposit_counts | avg_amount |
| :----------------: | :--------: |
|         5          |  2718.34   |

---

### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

_Dla każdego miesiaca - ile klientów Data Bank dokonuje więcej niż jednej wpłaty oraz jednego zakupu lub jednej wypłaty w ciągu jednego miesiąca?_

```sql
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
```

#### Wynik zapytania/Odpowiedź:

| txn_date_month | count |
| :------------: | :---: |
|       1        |  168  |
|       2        |  181  |
|       3        |  192  |
|       4        |  70   |

---

### 4. What is the closing balance for each customer at the end of the month?

_Jakie jest saldo końcowe dla każdego klienta na koniec miesiąca?_

```sql
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
```

#### Wynik zapytania/Odpowiedź:

| customer_id |      ending_month      | monthly_balance |
| :---------: | :--------------------: | :-------------: |
|      1      | 2020-01-31 00:00:00.00 |       312       |
|      1      | 2020-02-29 00:00:00.00 |       312       |
|      1      | 2020-03-31 00:00:00.00 |      -640       |
|      1      | 2020-04-30 00:00:00.00 |      -640       |
|      2      | 2020-01-31 00:00:00.00 |       549       |
|      2      | 2020-02-29 00:00:00.00 |       549       |
|      2      | 2020-03-31 00:00:00.00 |       610       |
|      2      | 2020-04-30 00:00:00.00 |       610       |
|      3      | 2020-01-31 00:00:00.00 |       144       |
|      3      | 2020-02-29 00:00:00.00 |      -821       |
|      3      | 2020-03-31 00:00:00.00 |      -1222      |
|      3      | 2020-04-30 00:00:00.00 |      -729       |

Wynik pierwszych trzech id

---

### 5. What is the percentage of customers who increase their closing balance by more than 5%?

_Jaki jest procent klientów, których saldo końcowe zwiększyło się o więcej niż 5%?_

```sql
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
```

#### Wynik zapytania/Odpowiedź:

| percentage_of_customers |
| :---------------------: |
|          34.00          |

