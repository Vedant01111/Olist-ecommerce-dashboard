-- ============================================
-- BUSINESS ANALYSIS QUERIES
-- Each answers a real question a stakeholder would ask.
-- ============================================

-- Q1. Monthly revenue trend
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM clean_orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Q2. Top 10 product categories by revenue
SELECT
    ct.product_category_name_english AS category,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation ct ON p.product_category_name = ct.product_category_name
JOIN clean_orders o ON oi.order_id = o.order_id
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- Q3. Average delivery time by customer state
SELECT
    c.customer_state,
    ROUND(AVG(o.delivery_days), 1) AS avg_delivery_days,
    COUNT(*) AS orders
FROM clean_orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.delivery_days IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- Q4. Repeat customer rate
-- (customer_unique_id tracks the same person across multiple customer_id records)
WITH order_counts AS (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS num_orders
    FROM clean_orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(CASE WHEN num_orders > 1 THEN 1 END) * 100.0 / COUNT(*) AS repeat_customer_rate_pct,
    COUNT(*) AS total_unique_customers
FROM order_counts;

-- Q5. Payment method breakdown
SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS total_value,
    ROUND(AVG(payment_installments), 1) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY total_value DESC;

-- Q6. Review score vs delivery delay (does late delivery hurt ratings?)
SELECT
    CASE
        WHEN o.delivery_days_vs_estimate >= 0 THEN 'On time or early'
        WHEN o.delivery_days_vs_estimate >= -3 THEN 'Slightly late (1-3 days)'
        ELSE 'Very late (4+ days)'
    END AS delivery_bucket,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS order_count
FROM clean_orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.delivery_days_vs_estimate IS NOT NULL
GROUP BY delivery_bucket
ORDER BY avg_review_score DESC;

-- Q7. Average order value (AOV) trend by month
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM clean_orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Q8. Top 10 sellers by revenue
SELECT
    s.seller_id,
    s.seller_state,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
JOIN clean_orders o ON oi.order_id = o.order_id
GROUP BY s.seller_id
ORDER BY revenue DESC
LIMIT 10;
