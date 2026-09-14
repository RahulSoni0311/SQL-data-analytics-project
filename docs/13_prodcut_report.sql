/*
================================================================================
Product Report
================================================================================
Purpose:
- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
- total orders
- total sales
- total quantity sold
- total customers (unique)
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last sale)
- average order revenue (AOR)
- average monthly revenue
================================================================================
*/


CREATE VIEW gold.report_products AS 
WITH base_query AS (
/*------------------------------------------------------------------------------
1) Base Query: Retrieves core Columns from tables
------------------------------------------------------------------------------*/
	SELECT 
		fs.order_number,
        fs.order_date,
        fs.customer_key,
		fs.sales_amount,
		fs.quantity,
		p.product_key,
		p.product_name,
        p.category,
        p.subcategory,
        p.cost
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS p
	ON fs.product_key = p.product_key
	WHERE order_date IS NOT NULL
	),
product_aggregation AS(
/*------------------------------------------------------------------------------
2) Product Aggregations: Summarize Key Metrics at the Customer Level
------------------------------------------------------------------------------*/
SELECT
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
    product_name,
	category,
    subcategory,
    cost
    )
/*------------------------------------------------------------------------------
3) Final Query: Combines all Products results into One Output 
------------------------------------------------------------------------------*/
SELECT 
	product_key,
    product_name,
	category,
    subcategory,
    cost,
    last_sale_date,
    TIMESTAMPDIFF(MONTH, last_sale_date, NOW()) AS recency_in_month,
    CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
	END AS product_segment,
    lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
    
	-- Average Order Revenue (AOR)
    CASE 
		WHEN total_orders = 0 THEN 0
		ELSE ROUND(total_sales / total_orders, 2)
	END AS avg_order_value,
    
    -- Compute Average Monthly Spend
    CASE
		WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
	END AS avg_monthly_spend
FROM product_aggregation;
