-- ============================================
-- DATA QUALITY CHECKS
-- Run these BEFORE building your KPIs. Note what you find —
-- this becomes your "data cleaning" story for interviews.
-- ============================================

-- 1. Duplicate order IDs (should be none — order_id is a PK)
SELECT order_id, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING cnt > 1;

-- 2. Orders with no matching customer (orphaned foreign keys)
SELECT o.order_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 3. Orders missing delivery dates but marked "delivered"
-- (data entry inconsistency — worth flagging in your README)
SELECT order_id, order_status, order_delivered_customer_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- 4. Null / missing product category names
SELECT COUNT(*) AS missing_category
FROM products
WHERE product_category_name IS NULL;

-- 5. Order items with price = 0 or negative freight (bad data)
SELECT *
FROM order_items
WHERE price <= 0 OR freight_value < 0;

-- 6. Review scores outside valid 1-5 range
SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

-- 7. Order status breakdown (know what you're including/excluding later)
-- Typically: exclude 'canceled' and 'unavailable' from revenue KPIs
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- ============================================
-- CLEAN VIEW: use this as your "single source of truth" for analysis
-- Excludes canceled/unavailable orders, joins category translation
-- ============================================
DROP VIEW IF EXISTS clean_orders;
CREATE VIEW clean_orders AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp) AS delivery_days,
    julianday(o.order_estimated_delivery_date) - julianday(o.order_delivered_customer_date) AS delivery_days_vs_estimate
FROM orders o
WHERE o.order_status NOT IN ('canceled', 'unavailable');
