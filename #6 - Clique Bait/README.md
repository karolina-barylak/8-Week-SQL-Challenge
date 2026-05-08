<div align="center">

# Case Study #6 - Clique Bait </br>

<img src="img/case_logo.png" alt="Logo case study 6" width="500" height="500">
</div>

## 💡 Informacje

W folderze _solutions_ znajdują się pliki z rozwiązaniami w SQL.</br>
Do wykonania wykorzystany został SQL oraz PostgreSQL.</br>
Szczegółowe informacje dotyczące tego studium przypadku znajdują się [tutaj](https://8weeksqlchallenge.com/case-study-6/).

## 📋 Spis treści

- [Opis](#-opis)
- [Diagram relacji](#-diagram-relacji)
- [Rozwiązanie: A. Customer Journey](#️-a-customer-journey)

## 🔍 Opis

### Wprowadzenie

Danny jest założycielem i dyrektorem generalnym sklepu online z owocami morza - Clique Bait. W tym studium przypadku Twoim zadaniem jest wesprzeć wizję Danny’ego, przeanalizować jego zbiór danych oraz zaproponować kreatywne rozwiązania

## 📈 Diagram relacji

<div align=center>
<img src="img/diagram.png" alt="Diagram relacji" width="80%" height="80%">
</div>

Tabela 1: Users

| user_id | cookie_id |     start_date      |
| :-----: | :-------: | :-----------------: |
|   397   |  3759ff   | 2020-03-30 00:00:00 |
|   215   |  863329   | 2020-01-26 00:00:00 |
|   191   |  eefca9   | 2020-03-15 00:00:00 |
|   89    |  764796   | 2020-01-07 00:00:00 |
|   127   |  17ccc5   | 2020-01-22 00:00:00 |
|   81    |  b0b666   | 2020-03-01 00:00:00 |
|   260   |  a4f236   | 2020-01-08 00:00:00 |
|   203   |  d1182f   | 2020-04-18 00:00:00 |
|   23    |  12dbc8   | 2020-01-18 00:00:00 |
|   375   |  f61d69   | 2020-01-03 00:00:00 |

Tabela 2: Events

| visit_id | cookie_id | page_id | event_type | sequence_number |         event_time         |
| :------: | :-------: | :-----: | :--------: | :-------------: | :------------------------: |
|  719fd3  |  3d83d3   |    5    |     1      |        4        | 2020-03-02 00:29:09.975502 |
|  fb1eb1  |  c5ff25   |    5    |     2      |        8        | 2020-01-22 07:59:16.761931 |
|  23fe81  |  1e8c2d   |   10    |     1      |        9        | 2020-03-21 13:14:11.745667 |
|  ad91aa  |  648115   |    6    |     1      |        3        | 2020-04-27 16:28:09.824606 |
|  5576d7  |  ac418c   |    6    |     1      |        4        | 2020-01-18 04:55:10.149236 |
|  48308b  |  c686c1   |    8    |     1      |        5        | 2020-01-29 06:10:38.702163 |
|  46b17d  |  78f9b3   |    7    |     1      |       12        | 2020-02-16 09:45:31.926407 |
|  9fd196  |  ccf057   |    4    |     1      |        5        | 2020-02-14 08:29:12.922164 |
|  edf853  |  f85454   |    1    |     1      |        1        | 2020-02-22 12:59:07.652207 |
|  3c6716  |  02e74f   |    3    |     2      |        5        | 2020-01-31 17:56:20.777383 |

Tabela 3: Event Identifier

| event_type |  event_name   |
| :--------: | :-----------: |
|     1      |   Page View   |
|     2      |  Add to Cart  |
|     3      |   Purchase    |
|     4      | Ad Impression |
|     5      |   Ad Click    |

Tabela 4: Campaign Identifier

| campaign_id | products |           campaign_name           |     start_date      | end_date            |
| :---------: | :------: | :-------------------------------: | :-----------------: | ------------------- |
|      1      |   1-3    |  BOGOF - Fishing For Compliments  | 2020-01-01 00:00:00 | 2020-01-14 00:00:00 |
|      2      |   4-5    |   25% Off - Living The Lux Life   | 2020-01-15 00:00:00 | 2020-01-28 00:00:00 |
|      3      |   6-8    | Half Off - Treat Your Shellf(ish) | 2020-02-01 00:00:00 | 2020-03-31 00:00:00 |

Tabela 5: Page Hierarchy

|    region     | month_number | total_sales |
| :-----------: | :----------: | :---------: |
|    AFRICA     |      3       |  567767480  |
|     ASIA      |      3       |  529770793  |
|    CANADA     |      3       |  144634329  |
|    EUROPE     |      3       |  35337093   |
|    OCEANIA    |      3       |  783282888  |
| SOUTH AMERICA |      3       |  71023109   |
|      USA      |      3       |  225353043  |

</br>

## ⚙️ 2. Digital Analysis

### 1. How many users are there?

_Ilu jest użytkowników?_

```sql
SELECT
    COUNT(DISTINCT user_id) as all_users
FROM users;
```

#### Wynik zapytania/Odpowiedź:

| all_users |
| :-------: |
|    500    |

---

### 2. How many cookies does each user have on average?

_Ile plików cookie ma średnio każdy użytkownik?_

```sql
WITH cookie_cte AS(
    SELECT
        user_id,
        COUNT(cookie_id) as cookie_count
    FROM users
    GROUP BY user_id
)

SELECT
    ROUND(AVG(cookie_count),0) as avg_cookie_id
FROM cookie_cte;
```

#### Wynik zapytania/Odpowiedź:

| avg_cookie_id |
| :-----------: |
|       4       |

---

### 3. What is the unique number of visits by all users per month?

_Jaka jest unikalna liczba wizyt wszystkich użytkowników w miesiącu?_

```sql
SELECT
    DATE_PART('month', event_time) as month,
    COUNT(distinct visit_id) as unique_visits
FROM events
GROUP BY month;
```

#### Wynik zapytania/Odpowiedź:

| month | unique_visits |
| :---: | :-----------: |
|   1   |      876      |
|   2   |     1488      |
|   3   |      916      |
|   4   |      248      |
|   5   |      36       |

---

<!--

### 1.

__

```sql

```

#### Wynik zapytania/Odpowiedź:


---

--->
