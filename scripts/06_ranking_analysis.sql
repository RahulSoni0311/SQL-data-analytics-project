/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which Top 5 Products generate the Highest Revenue?
SELECT
	p.product_key,
	p.product_name,
	SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key 
GROUP BY 
	p.product_key,
	p.product_name;


SELECT *
FROM (
		SELECT
		p.product_key,
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key 
	GROUP BY 
		p.product_key,
		p.product_name
	) t
WHERE rank_products <= 5;




-- What are the worst-performing Products in the Terms of Sales 
SELECT
	p.product_key,
	p.product_name,
	SUM(f.sales_amount) AS total_sales,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) ASC) AS rank_products 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key 
GROUP BY 
	p.product_key,
	p.product_name;


SELECT *
FROM (
	SELECT
		p.product_key,
		p.product_name,
		SUM(f.sales_amount) AS total_sales,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) ASC) AS rank_products 
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key 
	GROUP BY 
		p.product_key,
		p.product_name
	) t
WHERE rank_products <= 5;


-- Find the Top 10 Customers who have generated the Highest Revenue
SELECT *
FROM (
	SELECT
		c.customer_key,
		c.first_name,
        c.last_name,
		SUM(fs.sales_amount) AS revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS `rank`
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_customers AS c
	ON fs.customer_key = c.customer_key
	GROUP BY
		c.customer_key,
		c.first_name,
        c.last_name
	) t
WHERE `rank` <= 10;


-- The 3 Customers with the Fewest Orders Placed
SELECT * 
FROM (
	SELECT
		c.customer_key,
		c.first_name,
        c.last_name,
		COUNT(DISTINCT fs.order_number) AS total_orders,
		ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT fs.order_number) ASC, customer_key) AS customer_rank
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_customers AS c
	ON fs.customer_key = c.customer_key
    GROUP BY 
		c.customer_key,
		c.first_name,
        c.last_name
	)t 
WHERE customer_rank <= 3
ORDER BY customer_rank;

SELECT * FROM gold.fact_sales;
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
