-- MySQL SQL analysis project for Online Sales Data
SET sql_mode = STRICT_ALL_TABLES;
DROP DATABASE IF EXISTS online_sales_db;
CREATE DATABASE online_sales_db;
USE online_sales_db;
DROP TABLE IF EXISTS online_sales;
CREATE TABLE online_sales (
  TransactionID BIGINT PRIMARY KEY,
  OrderDate DATE,
  ProductCategory VARCHAR(100),
  ProductName VARCHAR(255),
  UnitsSold INT,
  UnitPrice DECIMAL(10,2),
  TotalRevenue DECIMAL(12,2),
  Region VARCHAR(100),
  PaymentMethod VARCHAR(50)
);

DROP TABLE IF EXISTS online_sales_stg;
CREATE TABLE online_sales_stg (
  TransactionID BIGINT,
  DateRaw VARCHAR(32),
  ProductCategory VARCHAR(100),
  ProductName VARCHAR(255),
  UnitsSold INT,
  UnitPrice DECIMAL(10,2),
  TotalRevenue DECIMAL(12,2),
  Region VARCHAR(100),
  PaymentMethod VARCHAR(50)
);
-- Load the CSV into staging (adjust file path and permissions as needed)
LOAD DATA LOCAL INFILE 'Online Sales Data.csv'
INTO TABLE online_sales_stg
FIELDS TERMINATED BY ' , ' ENCLOSED BY '"'
LINES TERMINATED BY '
' IGNORE 1 LINES
(TransactionID, DateRaw, ProductCategory, ProductName, UnitsSold, UnitPrice, TotalRevenue, Region, PaymentMethod);
INSERT INTO online_sales (TransactionID, OrderDate, ProductCategory, ProductName, UnitsSold, UnitPrice, TotalRevenue, Region, PaymentMethod
)
SELECT
  TransactionID,
  STR_TO_DATE(DateRaw, '%d-%m-%Y'),
  ProductCategory,
  ProductName,
  UnitsSold,
  UnitPrice,
  TotalRevenue,
  Region,
  PaymentMethod
FROM online_sales_stg;
CREATE INDEX idx_orders_date ON online_sales (OrderDate);
CREATE INDEX idx_orders_region ON online_sales (Region);
CREATE INDEX idx_orders_category ON online_sales (ProductCategory);
DROP VIEW IF EXISTS v_daily_revenue;
CREATE VIEW v_daily_revenue AS
SELECT OrderDate, SUM(TotalRevenue) AS DailyRevenue
FROM online_sales
GROUP BY OrderDate
ORDER BY OrderDate;
DROP VIEW IF EXISTS v_region_category_rev;
CREATE VIEW v_region_category_rev AS
SELECT Region, ProductCategory, SUM(TotalRevenue) AS Revenue
FROM online_sales
GROUP BY Region, ProductCategory
ORDER BY Revenue DESC;
DROP VIEW IF EXISTS v_top_products;
CREATE VIEW v_top_products AS
SELECT ProductName, SUM(UnitsSold) AS Units, SUM(TotalRevenue) AS Revenue
FROM online_sales
GROUP BY ProductName
ORDER BY Revenue DESC
LIMIT 50;
DROP VIEW IF EXISTS v_payment_mix;
CREATE VIEW v_payment_mix AS
SELECT PaymentMethod, COUNT(*) AS Orders, SUM(TotalRevenue) AS Revenue
FROM online_sales
GROUP BY PaymentMethod
ORDER BY Revenue DESC;
DROP VIEW IF EXISTS v_monthly_summary;
CREATE VIEW v_monthly_summary AS
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS YearMonth,
       SUM(UnitsSold) AS Units,
       SUM(TotalRevenue) AS Revenue,
       COUNT(DISTINCT TransactionID) AS Orders
FROM online_sales
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
ORDER BY YearMonth


-- Example queries to run:
/*
SELECT * FROM v_daily_revenue;
SELECT Region, SUM(TotalRevenue) AS Revenue FROM online_sales GROUP BY Region ORDER BY Revenue DESC;
SELECT ProductCategory, SUM(TotalRevenue) AS Revenue FROM online_sales GROUP BY ProductCategory ORDER BY Revenue DESC;
SELECT * FROM v_top_products;
SELECT * FROM v_payment_mix;
SELECT * FROM v_monthly_summary;
*/