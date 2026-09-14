/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the Total Sales per Month 
-- And the Running Total Sales over time 
SELECT 
	order_date,
    total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM (
	SELECT 
		DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
    )t; 


SELECT 
	order_date,
    total_sales,
	SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
	SELECT 
		DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
    )t; 



-- Moving Average 
SELECT 
	order_date,
    total_sales,
	SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
	ROUND(AVG(avg_price) OVER(ORDER BY order_date)) AS moving_average
FROM (
	SELECT 
		DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
		SUM(sales_amount) AS total_sales,
        AVG(sales_amount) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
    )t; 

