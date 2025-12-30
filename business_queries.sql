Query 1: SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.subtotal) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email
HAVING 
    COUNT(DISTINCT o.order_id) >= 2
    AND SUM(oi.subtotal) > 5000
ORDER BY 
    total_spent DESC;

---------------------------------------------------------------------------------------------------------------
 Query 2: 
SELECT
    p.category AS category,
    COUNT(DISTINCT p.product_id) AS num_products,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.subtotal) AS total_revenue
FROM products p
JOIN order_items oi 
    ON p.product_id = oi.product_id
GROUP BY 
    p.category
HAVING 
    SUM(oi.subtotal) > 10000
ORDER BY 
    total_revenue DESC;

---------------------------------------------------------------------------------------------------------------


Query 3:
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%M') AS month_name,
        MONTH(o.order_date) AS month_number,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.subtotal) AS monthly_revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = 2024
    GROUP BY 
        MONTH(o.order_date),
        DATE_FORMAT(o.order_date, '%M')
)
SELECT
    month_name,
    total_orders,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY month_number) AS cumulative_revenue
FROM monthly_sales
ORDER BY month_number;
