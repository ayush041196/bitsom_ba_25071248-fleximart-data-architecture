Query 1: Query 1: Monthly Sales Drill-Down (Year → Quarter → Month)
SELECT 
    d.year,
    d.quarter,
    d.month_name,
    SUM(f.total_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
WHERE d.year = 2024
GROUP BY 
    d.year,
    d.quarter,
    d.month_name,
    d.month
ORDER BY 
    d.year,
    d.quarter,
    d.month;
----------------------------------------------------------------------------------------------------------------

Query 2:
SELECT
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.total_amount) AS revenue,
    ROUND(
        (SUM(f.total_amount) / 
        (SELECT SUM(total_amount) FROM fact_sales)
        ) * 100, 
    2) AS revenue_percentage
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_name,
    p.category
ORDER BY
    revenue DESC
LIMIT 10;
-----------------------------------------------------------------------------------------------------------------

Query 3:

WITH customer_sales AS (
    SELECT
        c.customer_key,
        c.customer_name,
        SUM(f.total_amount) AS total_spent
    FROM fact_sales f
    JOIN dim_customer c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.customer_name
),

segmented AS (
    SELECT
        CASE
            WHEN total_spent > 50000 THEN 'High Value'
            WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment,
        total_spent
    FROM customer_sales
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM segmented
GROUP BY customer_segment
ORDER BY 
    CASE customer_segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'Low Value' THEN 3
    END;
