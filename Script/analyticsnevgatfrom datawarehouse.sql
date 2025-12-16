/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics2')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics2;
END;
GO

-- Create the 'DataWarehouseAnalytics2' database
CREATE DATABASE DataWarehouseAnalytics2;
GO

USE DataWarehouseAnalytics2;
GO
CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

TRUNCATE TABLE gold.dim_customers;
GO
INSERT into DataWarehouseAnalytics2.gold.dim_customers(
    customer_key ,
	customer_id,
	customer_number,
	first_name,
	last_name,
	country ,
	marital_status,
	gender ,
	birthdate,
	create_date
)
select 
 customer_key ,
	customer_id,
	customer_number,
	first_name,
	last_name,
	country ,
	marital_status,
	gender ,
	birthdate,
	create_date
FROM DatabaseWarehouse.gold.dim_customers

GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);

TRUNCATE TABLE gold.dim_products;
GO
INSERT into DataWarehouseAnalytics2.gold.dim_products (
	product_key ,
	product_id ,
	product_number ,
	product_name ,
	category_id ,
	category  ,
	subcategory ,
	maintenance  ,
	cost ,
	product_line,
	start_date 
	)
	select 
	product_key ,
	product_id ,
	product_number ,
	product_name ,
	category_id ,
	category  ,
	subcategory ,
	maintenance  ,
	cost ,
	product_line,
	start_date 
FROM DatabaseWarehouse.gold.dim_product
	
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.fact_sales;

INSERT into DataWarehouseAnalytics2.gold.fact_sales (
order_number ,
	product_key,
	customer_key,
	order_date,
	shipping_date,
	due_date,
	sales_amount,
	quantity ,
	price )
select 
order_number ,
	product_key,
	customer_key,
	order_date,
	shipping_date,
	due_date,
	sales_amount,
	quantity ,
	price
	from  DatabaseWarehouse.gold.fact_sales
	go