-- ============================================================
-- Superstore Analysis — Portfolio_DB (superstore.orders)
-- ============================================================
-- NOTE ON DATES: order_date and ship_date are stored as TEXT
-- in 'MM/DD/YYYY' format. The DB connection used to build this
-- is read-only, so instead of altering the table schema, every
-- query below parses dates inline with:
--   TO_DATE(order_date, 'MM/DD/YYYY')
-- Verified against all 9,994 rows: 0 parse failures,
-- date range 2014-01-02 to 2017-12-29.
--
-- If you later get write access, you can persist this fix with:
--   CREATE OR REPLACE VIEW superstore.orders_clean AS
--   SELECT *,
--     TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_d,
--     TO_DATE(ship_date, 'MM/DD/YYYY')  AS ship_date_d
--   FROM superstore.orders;
-- ============================================================

-- Reusable base CTE (paste at the top of any new query)
-- WITH orders_fixed AS (
--   SELECT *,
--     TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_d,
--     TO_DATE(ship_date, 'MM/DD/YYYY')  AS ship_date_d
--   FROM superstore.orders
-- )

-- ------------------------------------------------------------
-- 1. Monthly sales & profit trend
-- ------------------------------------------------------------
WITH orders_fixed AS (
  SELECT *,
    TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_d,
    TO_DATE(ship_date, 'MM/DD/YYYY')  AS ship_date_d
  FROM superstore.orders
)
SELECT date_trunc('month', order_date_d)::date AS month,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit,
       COUNT(DISTINCT order_id) AS orders
FROM orders_fixed
GROUP BY 1
ORDER BY 1;

-- ------------------------------------------------------------
-- 2. Year-over-year sales & profit growth
-- ------------------------------------------------------------
WITH orders_fixed AS (
  SELECT *, TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_d
  FROM superstore.orders
),
yearly AS (
  SELECT EXTRACT(YEAR FROM order_date_d)::int AS year,
         SUM(sales)  AS total_sales,
         SUM(profit) AS total_profit
  FROM orders_fixed
  GROUP BY 1
)
SELECT year, total_sales, total_profit,
       ROUND(100.0 * (total_sales - LAG(total_sales) OVER (ORDER BY year))
             / NULLIF(LAG(total_sales) OVER (ORDER BY year), 0), 1) AS sales_growth_pct
FROM yearly
ORDER BY year;

-- ------------------------------------------------------------
-- 3. Category / sub-category performance
-- ------------------------------------------------------------
SELECT category, sub_category,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit,
       ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 1) AS profit_margin_pct,
       SUM(quantity) AS units_sold
FROM superstore.orders
GROUP BY category, sub_category
ORDER BY total_sales DESC;

-- ------------------------------------------------------------
-- 4. Regional performance
-- ------------------------------------------------------------
SELECT region, state,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit,
       COUNT(DISTINCT order_id) AS orders
FROM superstore.orders
GROUP BY region, state
ORDER BY total_sales DESC
LIMIT 20;

-- ------------------------------------------------------------
-- 5. Top 10 customers by sales
-- ------------------------------------------------------------
SELECT customer_id, customer_name, segment,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit,
       COUNT(DISTINCT order_id) AS orders
FROM superstore.orders
GROUP BY customer_id, customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 6. Discount impact on profit
-- ------------------------------------------------------------
SELECT
  CASE
    WHEN discount = 0 THEN '0%'
    WHEN discount <= 0.2 THEN '1-20%'
    WHEN discount <= 0.4 THEN '21-40%'
    WHEN discount <= 0.6 THEN '41-60%'
    ELSE '60%+'
  END AS discount_band,
  COUNT(*) AS orders,
  ROUND(SUM(sales), 2)  AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(AVG(profit), 2) AS avg_profit_per_line
FROM superstore.orders
GROUP BY 1
ORDER BY 1;

-- ------------------------------------------------------------
-- 7. Shipping mode performance & average delay (days)
-- ------------------------------------------------------------
WITH orders_fixed AS (
  SELECT *,
    TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_d,
    TO_DATE(ship_date, 'MM/DD/YYYY')  AS ship_date_d
  FROM superstore.orders
)
SELECT ship_mode,
       COUNT(*) AS orders,
       ROUND(AVG(ship_date_d - order_date_d), 2) AS avg_ship_days,
       ROUND(SUM(sales), 2) AS total_sales
FROM orders_fixed
GROUP BY ship_mode
ORDER BY avg_ship_days;

-- ------------------------------------------------------------
-- 8. Loss-making products (negative profit)
-- ------------------------------------------------------------
SELECT product_name, category, sub_category,
       SUM(quantity) AS units_sold,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore.orders
GROUP BY product_name, category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 20;

-- ------------------------------------------------------------
-- 9. Segment performance
-- ------------------------------------------------------------
SELECT segment,
       COUNT(DISTINCT customer_id) AS customers,
       COUNT(DISTINCT order_id)    AS orders,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore.orders
GROUP BY segment
ORDER BY total_sales DESC;
