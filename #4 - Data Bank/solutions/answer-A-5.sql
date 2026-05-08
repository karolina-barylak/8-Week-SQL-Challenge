-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
-- Jaka jest mediana, 80. i 95. percentyl dla tej samej liczby dni realokacji dla każdego regionu?

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