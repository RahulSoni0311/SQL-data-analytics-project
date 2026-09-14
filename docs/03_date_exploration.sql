/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the Date of the First and Last Order
-- How many Years of the Sales are Available 
SELECT 
	MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(year, MIN(order_date), MAX(order_date))
FROM gold.fact_sales;

-- Find the Youngest and the Oldest Customer based on Birth
SELECT 
	MIN(birthdate) AS oldest_birthdate,
    TIMESTAMPDIFF(year, MIN(birthdate), NOW()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF(year, MAX(birthdate), NOW()) AS youngest_age
FROM gold.dim_customers;
