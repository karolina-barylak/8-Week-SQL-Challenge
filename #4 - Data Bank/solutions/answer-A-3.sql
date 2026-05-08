-- How many customers are allocated to each region?
-- Ilu klientów jest przydzielonych do każdego regionu?

SELECT
    region_name,
    COUNT(DISTINCT customer_id) as customers_per_region
FROM customer_nodes
INNER JOIN regions
    ON customer_nodes.region_id = regions.region_id
GROUP BY region_name;