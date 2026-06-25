-- Area 1 — Store Performance
-- Query 1 Business question: Which stores generate the most total revenue, and how many orders did each store take?

SELECT 
o.store_id, s.store_address, s.city, s.province, COUNT(o.order_id) AS total_orders,  
ROUND(SUM(o.order_total),2) AS total_revenue, ROUND(AVG(o.order_total),2) AS avg_order_value
FROM stores s
JOIN orders o ON s.store_id = o.store_id         
WHERE o.order_status = 'Completed'
GROUP BY 
s.store_id, s.store_address, s.city, s.province
ORDER BY total_revenue DESC;

-- Query 2
-- Business question: What percentage of total company revenue does each store contribute?

WITH store_revenue AS (
SELECT
s.store_id, s.city, s.store_type, ROUND(SUM(o.order_total), 2) AS store_total
FROM stores s
JOIN orders o ON s.store_id = o.store_id
WHERE o.order_status = 'Completed'
GROUP BY s.store_id, s.city, s.store_type
)
SELECT
store_id, city, store_type, store_total, ROUND( store_total / SUM(store_total) OVER () * 100, 2) AS revenue_share_pct
FROM store_revenue
ORDER BY revenue_share_pct DESC;

-- Query 3
-- Business question: How does each store rank by revenue within its province?

WITH store_revenue AS (
SELECT
s.store_id, s.city, s.province, ROUND(SUM(o.order_total),2) AS total_revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
WHERE o.order_status = 'Completed'
GROUP BY s.store_id, s.city, s.province
)
SELECT
store_id, city, province, total_revenue, RANK() OVER (
PARTITION BY province
ORDER BY total_revenue DESC) AS rank_by_province
FROM store_revenue
ORDER BY province, rank_by_province;

-- Query 4
-- Business question: What is the monthly revenue trend for each store?

SELECT 
o.store_id, s.city, DATE_FORMAT(o.order_timestamp, '%Y-%m') AS month,
COUNT(o.order_id) AS total_orders, ROUND(SUM(o.order_total), 2) AS total_revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
WHERE o.order_status = 'Completed'
GROUP BY o.store_id, s.city, DATE_FORMAT(o.order_timestamp, '%Y-%m')
ORDER BY o.store_id, DATE_FORMAT(o.order_timestamp, '%Y-%m');

-- Query 5 — Month over Month Change
-- Business question: How much did each store's revenue grow or decline compared to the previous month?

WITH monthly AS (
SELECT
s.store_id, s.city, DATE_FORMAT(o.order_timestamp, '%Y-%m') AS order_month,
ROUND(SUM(o.order_total), 2) AS monthly_revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
WHERE o.order_status = 'Completed'
GROUP BY s.store_id, s.city, order_month
)
SELECT
store_id, city, order_month, monthly_revenue,
LAG(monthly_revenue) OVER (PARTITION BY store_id ORDER BY order_month) AS prev_month_revenue,
ROUND((monthly_revenue - LAG(monthly_revenue) OVER (PARTITION BY store_id ORDER BY order_month)) /
NULLIF(LAG(monthly_revenue) OVER (PARTITION BY store_id ORDER BY order_month), 0) * 100, 2) AS mom_change_pct
FROM monthly
ORDER BY store_id, order_month;

-- Area 2 — Customer Behaviour
-- Query 1
-- Business question: Who are the top 10 highest spending customers, and how many orders have they placed

SELECT 
o.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(o.order_id) AS total_orders,
ROUND(SUM(o.order_total),2) AS total_spend
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.first_name, c.last_name
ORDER BY total_spend DESC
LIMIT 10;

-- Query 2
-- Business question: What is the average number of orders placed per customer across the whole customer base?

SELECT ROUND(AVG(order_count), 2) AS avg_orders_per_customer
FROM (
SELECT COUNT(order_id) AS order_count   
FROM orders  
GROUP BY customer_id ) AS avg_orders;

-- Query 3
-- Business question: How long has each customer been with us, and when did they sign up?

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS customer_name, city, province, signup_date,
-- DATEDIFF(CURDATE(), signup_date) AS days_as_customer (this returns number of days from current date)
ROUND(TIMESTAMPDIFF(MONTH, signup_date, CURDATE()) / 12, 1) AS years_as_customer -- this function returns exact days with no approximation hence no division needed
FROM customers
ORDER BY years_as_customer DESC;

-- Query 4
-- Business question: Segment customers into spend tiers based on their total spending — who are your High, Mid, and Low value customers?

SELECT o.customer_id,  CONCAT(c.first_name, ' ', c.last_name) AS customer_name, ROUND(SUM(o.order_total), 2) AS total_spend,
CASE
WHEN SUM(o.order_total) > 200 THEN 'High Value'
WHEN SUM(o.order_total) BETWEEN 100 AND 200 THEN 'Mid Value'
ELSE 'Low Value'
END AS customer_segment
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.first_name, c.last_name
ORDER BY total_spend DESC;

-- Query 5
-- Business question: How many new vs returning customers placed orders each month?

WITH first_orders AS (
SELECT customer_id, MIN(order_timestamp) AS first_order_date
FROM orders 
GROUP BY customer_id
)
SELECT 
COUNT(o.order_id) AS total_orders, DATE_FORMAT(o.order_timestamp, '%Y-%m') AS order_month,
CASE
WHEN DATE_FORMAT(o.order_timestamp, '%Y-%m') = DATE_FORMAT(f.first_order_date, '%Y-%m') THEN 'New'
ELSE 'Returning'
END AS customer_type
FROM orders o
JOIN first_orders f ON o.customer_id = f.customer_id
GROUP BY DATE_FORMAT(o.order_timestamp, '%Y-%m'),
CASE WHEN DATE_FORMAT(o.order_timestamp, '%Y-%m') = DATE_FORMAT(f.first_order_date, '%Y-%m') THEN 'New'
ELSE 'Returning'
END
ORDER BY order_month;

-- Area 3 — Product & Category Sales
-- Query 1
-- Business question: Which products generate the most revenue and how many units were sold?

SELECT oi.product_id, p.product_name, c.category_name, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue, SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON c.category_id = p.category_id
GROUP BY oi.product_id, p.product_name, c.category_name
ORDER BY total_revenue DESC;

-- Bonus Query - Are there any products with no sales history?

SELECT p.product_id, p.product_name, p.product_price,
p.is_available, p.product_season
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Query 2
-- Business question: Which product categories drive the most revenue and how many products does each category have?

SELECT c.category_id, c.category_name, COUNT(DISTINCT p.product_id) AS total_products,
SUM(oi.quantity) AS total_quantity, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;

-- Query 3 — 
-- Business question: What is the average number of items per order across all orders?

SELECT ROUND(AVG(basket), 2) as avg_basket
FROM (
SELECT order_id, SUM(quantity) as basket
FROM order_items
GROUP BY order_id) AS avg_order;

-- Query 4
-- Business question: Which products are underperforming — generating less than a certain revenue threshold?

SELECT oi.product_id, p.product_name, c.category_name, 
ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue, SUM(oi.quantity) AS total_units_sold 
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id 
JOIN categories c ON p.category_id = c.category_id 
GROUP BY oi.product_id, p.product_name, c.category_name 
HAVING ROUND(SUM(oi.quantity * oi.unit_price), 2) < 200
ORDER BY total_revenue ASC;

-- Query 5
-- Business question: How does revenue and units sold compare across different product seasons?

SELECT 
COALESCE(p.product_season, 'Year Round') AS season, COUNT(DISTINCT( p.product_id)) AS total_products,
SUM(oi.quantity) AS total_units_sold, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY COALESCE(p.product_season, 'Year Round')
ORDER BY total_revenue DESC;

-- Area 4 — Loyalty Program
-- Query 1
-- Business question: What percentage of total orders come from loyalty program members?

SELECT 
CASE WHEN lr.loyalty_id IS NOT NULL THEN 'Member' ELSE 'Non-Member' END AS membership_status,
COUNT(o.order_id) AS total_orders,
ROUND(COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER (), 2) AS order_share_pct
FROM orders o
LEFT JOIN loyalty_rewards lr ON o.customer_id = lr.customer_id
GROUP BY 
CASE 
WHEN lr.loyalty_id IS NOT NULL 
THEN 'Member' ELSE 'Non-Member' END
ORDER BY total_orders DESC;

-- Query 2
-- Business question: Do loyalty members spend more per order on average than non-members?

SELECT   
CASE WHEN lr.loyalty_id IS NOT NULL THEN 'Member' ELSE 'Non-Member' END AS membership_status, 
COUNT(o.order_id) AS total_orders,  
ROUND(AVG(o.order_total),2) AS avg_spend , 
ROUND(SUM(o.order_total), 2) AS total_revenue
FROM orders o  
LEFT JOIN loyalty_rewards lr ON o.customer_id = lr.customer_id  
GROUP BY 
CASE 
WHEN lr.loyalty_id IS NOT NULL 
THEN 'Member' 
ELSE 'Non-Member' END 
ORDER BY total_orders DESC;

-- Query 3
-- Business question: Which loyalty tier spends the most on average and has the most members?

SELECT loyalty_tier, 
COUNT(DISTINCT lr.customer_id) AS total_members, 
ROUND(AVG(o.order_total), 2) AS avg_spend, 
ROUND(SUM(o.order_total), 2) AS total_revenue 
FROM orders o 
JOIN loyalty_rewards lr ON o.customer_id = lr.customer_id 
GROUP BY loyalty_tier 
ORDER BY avg_spend DESC;

-- Query 4
-- Business question: What is the stars redemption rate by loyalty tier?

SELECT loyalty_tier, 
ROUND(SUM(stars_earned), 2) AS total_stars_earned, 
ROUND(SUM(stars_redeemed),2) AS total_stars_redeemed, 
ROUND(SUM(stars_balance), 2) AS total_stars_balance, 
ROUND(SUM(stars_redeemed) / NULLIF(SUM(stars_earned), 0) * 100, 2) AS redemption_rate_pct 
FROM loyalty_rewards 
GROUP BY loyalty_tier 
ORDER BY redemption_rate_pct DESC;

-- Area 5: Operations & Employees
-- Query 1
-- Business question: How many orders has each employee handled at their store, and what is the total revenue they processed?

SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
e.store_id, s.city, s.province, COUNT(o.order_id) AS order_count,
ROUND(SUM(o.order_total), 2) AS total_revenue
FROM employees e
JOIN stores s ON e.store_id = s.store_id
JOIN orders o ON s.store_id = o.store_id
WHERE e.is_active = 1
GROUP BY e.employee_id, e.first_name, e.last_name, e.store_id, s.city, s.province
ORDER BY total_revenue DESC;

-- Query 2
-- Business question: What are the peak ordering hours throughout the day broken down by stores?

SELECT o.store_id, s.city, HOUR(o.order_timestamp) AS order_hour,
COUNT(o.order_id) AS order_count, ROUND(AVG(o.order_total), 2) AS avg_revenue
FROM orders o
JOIN stores s ON o.store_id = s.store_id
GROUP BY o.store_id, s.city, HOUR(o.order_timestamp)
ORDER BY o.store_id, order_hour;

-- Query 3
-- Business question: What is the breakdown of payment methods used by customers?

SELECT * from payments;

SELECT payment_type, COUNT(payments_id) as total_transcations, ROUND(SUM(amount), 2) AS total_payment,
ROUND(COUNT(payments_id) * 100.0 / SUM(COUNT(payments_id)) OVER (), 2) AS transaction_share_pct
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_type
ORDER BY total_transcations DESC;

-- Query 4
-- Business question: Which stores have the highest weekly labour cost?

SELECT s.store_id, s.city, s.province, 
COUNT(e.employee_id) AS total_employees, 
ROUND(SUM(e.hourly_wage * e.hours_per_week), 2) AS total_weekly_labour_cost
FROM employees e
JOIN stores s ON e.store_id = s.store_id
WHERE e.is_active = 1
GROUP BY s.store_id, s.city, s.province
ORDER BY total_weekly_labour_cost DESC;



