-- How many unique nodes are there on the Data Bank system?
-- Ile unikalnych węzłów znajduje się w systemie Banku Danych?

SELECT
    COUNT(DISTINCT node_id) as unique_nodes
FROM customer_nodes;