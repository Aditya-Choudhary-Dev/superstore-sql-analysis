# Superstore Sales Analysis

## Project Overview
This project analyzes Sample Superstore retail sales data using PostgreSQL and Tableau
to identify sales trends, profit performance, top products, customers, and regional
insights to help the business make better decisions.

## Tools Used
- CSV (Sample Superstore Dataset — Tableau)
- PostgreSQL
- SQL
- Tableau

## Business Questions
1. What is the total sales and profit for each product category?
2. Which are the top 10 products by total sales?
3. How many orders were placed in each region?
4. What is the average discount given per sub-category?
5. Which orders are loss-making (negative profit)?
6. What is the month-over-month sales trend for each year?
7. Which sub-category has the highest and lowest total profit?
8. What is the profit margin per category ranked?
9. What is the average shipping delay by ship mode?
10. Who are the top 5 customers by lifetime sales?
11. What percentage of total sales does each region represent?

## Data Validation
Data was validated for:
- Total record count
- Missing values in key columns (sales, profit, order_id)
- Duplicate order line items
- Negative sales values
- Invalid date formats

## SQL Analysis
SQL queries cover:
- Basic aggregation and filtering
- Window functions (RANK, SUM OVER)
- CTEs for multi-step calculations
- Date parsing and time-series analysis
- Profit margin calculations

## Tableau Dashboards
Dashboards built covering all 11 business questions:
- Dashboard 1 — Sales & Profit Overview
- Dashboard 2 — Product Performance
- Dashboard 3 — Regional Analysis
- Dashboard 4 — Customer & Shipping Insights

## Key Insights
- Technology is the highest revenue category
- Furniture has the lowest profit margin despite high sales
- Tables sub-category operates at a net loss
- West region generates the highest percentage of total sales
- Standard Class shipping has the longest average delay
- Top 5 customers contribute disproportionately to lifetime revenue
- Heavy discounting in Office Supplies is eroding profit margins
- Sales show consistent growth year-over-year with Q4 peaks

## Skills Demonstrated
SQL | PostgreSQL | Window Functions | CTEs | Data Analysis | Data Validation | Tableau | Data Visualization | Retail Analytics | Business Intelligence
