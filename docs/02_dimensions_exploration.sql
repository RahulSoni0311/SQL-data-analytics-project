/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore all Countries our Customers come from.
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore All Categories "The major Divisions"
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products		-- There are 4 Categories, 36 Subcategories, 295 Products
ORDER BY 1, 2, 3;

