/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Which Categories contribute the most to Overall Sales 
WITH category_sales AS (
	SELECT 
		p.category,
		SUM(fs.sales_amount) AS total_sales 
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS p
	ON fs.product_key = p.product_key
	GROUP BY p.category
	) 
SELECT
	category,
	total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
GROUP BY category, total_sales 
ORDER BY total_sales DESC;

