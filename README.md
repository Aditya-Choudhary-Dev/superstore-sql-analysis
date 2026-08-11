# Superstore SQL Analysis

SQL analysis of the Superstore dataset, stored in `Portfolio_DB` (`superstore.orders`, 9,994 rows / 21 columns).

## Date handling

`order_date` and `ship_date` are stored as `TEXT` in `MM/DD/YYYY` format. The available DB connection is **read-only**, so no schema change (`ALTER TABLE`, `CREATE VIEW`) could be applied. Instead, every query in `superstore_analysis.sql` parses dates inline with:

```sql
TO_DATE(order_date, 'MM/DD/YYYY')
```

Verified against all 9,994 rows: 0 parse failures, date range 2014-01-02 to 2017-12-29.

If write access becomes available, the fix can be made permanent with the `CREATE OR REPLACE VIEW superstore.orders_clean` statement commented at the top of the SQL file.

## Contents (`superstore_analysis.sql`)

1. Monthly sales & profit trend
2. Year-over-year sales & profit growth
3. Category / sub-category performance
4. Regional performance
5. Top 10 customers by sales
6. Discount impact on profit
7. Shipping mode performance & average delay
8. Loss-making products
9. Segment performance

## Tableau

Connect Tableau Desktop to `Portfolio_DB` via **PostgreSQL connector** (Data > Connect to Data > PostgreSQL), pointing at the `superstore.orders` table or a custom SQL query built from the queries above.
