/*
================================================================================
Customer Report
================================================================================
Purpose:
- This report consolidates key customer metrics and behaviors
================================================================================
Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
- total orders
- total sales
- total quantity purchased
- total products
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last order)
- average order value
- average monthly spend
================================================================================
*/

CREATE VIEW gold.report_customers AS 
WITH base_query AS (
/*------------------------------------------------------------------------------
1) Base Query: Retrieves core Columns from tables
------------------------------------------------------------------------------*/
	SELECT 
		fs.order_number,
		fs.product_key, 
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
		TIMESTAMPDIFF(YEAR, c.birthdate, NOW()) AS age
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_customers AS c
	ON fs.customer_key = c.customer_key
	WHERE order_date IS NOT NULL
	),
customer_aggregation AS(
/*------------------------------------------------------------------------------
2) Customer Aggregations: Summarize Key Metrics at the Customer Level
------------------------------------------------------------------------------*/
SELECT
	customer_key,
    customer_number,
    customer_name, 
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
    customer_number,
    customer_name,
    age
    )
SELECT 
	customer_key,
    customer_number,
    customer_name,
    age,
    CASE
		WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and Above'
	END AS age_group,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	last_order_date,
    TIMESTAMPDIFF(MONTH, last_order_date, NOW()) AS recency,
	total_orders,
    total_sales,
    total_quantity,
    total_products,
	lifespan,
    -- Compute Average Order Value (AVO)
    CASE 
		WHEN total_sales = 0 THEN 0
		ELSE ROUND(total_sales / total_orders, 2)
	END AS avg_order_value,
    -- Compute Average Monthly Spend
    CASE
		WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
	END AS avg_monthly_spend
FROM customer_aggregation
;
