<div align="center">

# Case Study #7 - Balanced Tree Clothing Co. </br>

<img src="img/case_logo.png" alt="Logo case study 7" width="500" height="500">
</div>

## 💡 Informacje

W folderze _solutions_ znajdują się pliki z rozwiązaniami w SQL.</br>
Do wykonania wykorzystany został SQL oraz PostgreSQL.</br>
Szczegółowe informacje dotyczące tego studium przypadku znajdują się [tutaj](https://8weeksqlchallenge.com/case-study-7/).

## 📋 Spis treści

- [Opis](#-opis)
- [Diagram relacji](#-diagram-relacji)
- [Rozwiązanie: 2. Digital Analysis](#️-2-digital-analysis)

## 🔍 Opis

### Wprowadzenie

Balanced Tree Clothing Company szczyci się tym, że zapewnia zoptymalizowaną gamę odzieży dla współczesnego poszukiwacza przygód!

Danny, dyrektor generalny tej modnej firmy odzieżowej, poprosił o pomoc w analizie ich wyników sprzedaży i wygenerowaniu podstawowego raportu finansowego, którym możesz podzielić się z szerszym biznesem.

## 📈 Diagram relacji

<div align=center>
<img src="img/diagram.png" alt="Diagram relacji" width="80%">
</div>

## ⚙️ 1. High Level Sales Analysis

### 1. What was the total quantity sold for all products?

### 2. What is the total generated revenue for all products before discounts?

### 3. What was the total discount amount for all products?

_Jaka była całkowita sprzedana ilość wszystkich produktów?_ </br>
_Jaki jest całkowity przychód wygenerowany dla wszystkich produktów przed rabatami?_ </br>
_Jaka była łączna kwota rabatu na wszystkie produkty?_ </br>

```sql
SELECT
    SUM(qty) as total_quantity,
    SUM(qty * price) as total_revenue_before_discounts,
    ROUND(SUM(qty * price * (discount / 100.0)), 2) as total_discount_amount
FROM sales;
```

#### Wynik zapytania/Odpowiedź:

| total_quantity | total_revenue_before_discounts | total_discount_amount |
| :------------: | :----------------------------: | :-------------------: |
|     45216      |            1289453             |       156229.14       |

---

## ⚙️ 2. Transaction Analysis

### 1. How many unique transactions were there?

### 2. What is the average unique products purchased in each transaction?

### 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

### 4. What is the average discount value per transaction?

### 5. What is the percentage split of all transactions for members vs non-members?

### 6. What is the average revenue for member transactions and non-member transactions?

_Ile było unikalnych transakcji?_ </br>
_Jaka jest średnia liczba unikalnych produktów zakupionych w każdej transakcji?_ </br>
_Jakie są wartości 25., 50. i 75. percentyla przychodu z transakcji?_ </br>
_Jaka jest średnia wartość rabatu na transakcję?_ </br>
_Jaki jest procentowy podział wszystkich transakcji dla członków i osób niebędących członkami?_ </br>
_Jaki jest średni przychód z transakcji członków i transakcji osób niebędących członkami?_ </br>

```sql

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

```

#### Wynik zapytania 1:

| unique_transaction |
| :----------------: |
|        2500        |

#### Wynik zapytania 2:

| average_unique_products |
| :---------------------: |
|            6            |

#### Wynik zapytania 3:

| percentile_25 | percentile_50 | percentile_75 |
| :-----------: | :-----------: | :-----------: |
|    375.75     |     509.5     |      647      |

#### Wynik zapytania 4:

| avg_discount_value |
| :----------------: |
|       62.49        |

#### Wynik zapytania 5:

| number_of_non_member | number_of_member |
| :------------------: | :--------------: |
|          40          |        60        |

#### Wynik zapytania 6:

| member | avg_revenue |
| :----: | :---------: |
| FALSE  |   515.04    |
|  TRUE  |   516.27    |

## ⚙️ 3. Product Analysis

<!--

### 1.

__

```sql

```

#### Wynik zapytania/Odpowiedź:


---

--->
