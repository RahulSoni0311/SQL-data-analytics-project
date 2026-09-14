/*
=============================================================
Create Database
=============================================================
Script Purpose:
    This script creates a new database named 'gold' after checking
    if it already exists.
    If the database exists, it is dropped and recreated.

WARNING:
    Running this script will drop the entire 'gold' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

-- Drop and recreate the 'gold' database
DROP DATABASE IF EXISTS gold;

CREATE DATABASE gold;


-- Use gold
USE gold;


-- =========================================================
-- Create Tables
-- =========================================================

CREATE TABLE gold.dim_customers(
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);


CREATE TABLE gold.dim_products(
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);


CREATE TABLE gold.fact_sales(
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);


-- =========================================================
-- Load dim_customers
-- =========================================================

TRUNCATE TABLE gold.dim_customers;

LOAD DATA LOCAL INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-analytics-project-main/datasets/csv-files/gold.dim_customers.csv'
INTO TABLE gold.dim_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- Load dim_products
-- =========================================================

TRUNCATE TABLE gold.dim_products;

LOAD DATA LOCAL INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-analytics-project-main/datasets/csv-files/gold.dim_products.csv'
INTO TABLE gold.dim_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- Load fact_sales
-- =========================================================

TRUNCATE TABLE gold.fact_sales;

LOAD DATA LOCAL INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-analytics-project-main/datasets/csv-files/gold.fact_sales.csv'
INTO TABLE gold.fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

