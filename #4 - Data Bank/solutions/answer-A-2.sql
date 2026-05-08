-- What is the number of nodes per region?
-- Jaka jest liczba węzłów na region?

SELECT
    region_name,
    COUNT(node_id) as number_of_nodes,
    COUNT(DISTINCT node_id) as numer_of_unique_nodes
FROM customer_nodes as cn
INNER JOIN regions
    ON cn.region_id = regions.region_id
GROUP BY region_name;