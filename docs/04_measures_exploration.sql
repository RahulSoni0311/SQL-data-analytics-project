/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Find how many Items are sold
SELECT SUM(quantity) AS total_sales FROM gold.fact_sales;

-- Find the Average Selling Price 
SELECT AVG(price) AS Avg_selling_price FROM gold.fact_sales;

-- Find the Total Number of Order
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Find the Total Number of Products
SELECT COUNT(product_key) AS total_products FROM gold.fact_sales;
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.fact_sales;

-- Find the Total Number of Customers 
SELECT COUNT(customer_key) AS total_customers FROM gold.fact_sales;

-- Find the Total Number of Customers that has placed an Order 
SELECT COUNT(DISTINCT customer_key) AS total_customer FROM gold.fact_sales;


-- Generate a Report that shows all Key Metrics of the Business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', ROUND(AVG(price), 2) AS Avg_selling_price FROM gold.fact_sales
UNION ALL
SELECT 'Total no. Orders', COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales
UNION ALL
SELECT 'Total no. Products', COUNT(DISTINCT product_key) AS total_products FROM gold.fact_sales
UNION ALL
SELECT 'Total no. Customers', COUNT(DISTINCT customer_key) AS total_customer FROM gold.fact_sales;
SELECT * FROM gold.fact_sales;
