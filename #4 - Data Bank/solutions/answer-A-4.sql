-- How many days on average are customers reallocated to a different node?
-- Przez ile dni średnio klienci są przenoszeni do innego węzła?

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