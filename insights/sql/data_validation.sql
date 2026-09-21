-- =============================================
-- SUPERSTORE — DATA VALIDATION
-- =============================================

-- 1. Total record count
SELECT COUNT(*) AS total_records
FROM superstore.orders;

-- 2. Check for missing values in key columns
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS null_region
FROM superstore.orders;

-- 3. Check for duplicate row_id
SELECT row_id, COUNT(*) AS count
FROM superstore.orders
GROUP BY row_id
HAVING COUNT(*) > 1;

-- 4. Check for negative sales
SELECT COUNT(*) AS negative_sales_count
FROM superstore.orders
WHERE sales < 0;

-- 5. Check distinct categories
SELECT DISTINCT category
FROM superstore.orders
ORDER BY category;

-- 6. Check distinct regions
SELECT DISTINCT region
FROM superstore.orders
ORDER BY region;

-- 7. Check distinct ship modes
SELECT DISTINCT ship_mode
FROM superstore.orders
ORDER BY ship_mode;

-- 8. Check date range
WITH orders_fixed AS (
    SELECT TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_d
    FROM superstore.orders
)
SELECT MIN(order_date_d) AS earliest_order,
       MAX(order_date_d) AS latest_order
FROM orders_fixed;

-- 9. Sales and profit range check
SELECT 
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales,
    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit
FROM superstore.orders;

-- 10. Count of loss-making orders
SELECT COUNT(*) AS loss_making_orders
FROM superstore.orders
WHERE profit < 0;
