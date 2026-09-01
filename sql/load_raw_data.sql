/* ============================================================
   Project: Customer & Sales Analytics
   Script: load_raw_data.sql
   Purpose: Validate raw CSV ingestion
   ============================================================ */

USE CustomerSalesAnalytics;
GO

SELECT 'Customers' AS TableName, COUNT(*) AS RowCount
FROM raw.Customers

UNION ALL

SELECT 'Categories', COUNT(*)
FROM raw.Categories

UNION ALL

SELECT 'Products', COUNT(*)
FROM raw.Products

UNION ALL

SELECT 'Orders', COUNT(*)
FROM raw.Orders

UNION ALL

SELECT 'OrderLines', COUNT(*)
FROM raw.OrderLines;
GO

/* ============================================================
   Order Status Checks: 
   ============================================================ */

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM raw.Orders
GROUP BY OrderStatus
ORDER BY OrderStatus;

/* ============================================================
   Date Range Check: 
   ============================================================ */

SELECT
    MIN(OrderDate) AS MinOrderDate,
    MAX(OrderDate) AS MaxOrderDate
FROM raw.Orders;

/*
Orders CSV ingestion note:

The SQL Server Import/Export Wizard inferred OrderDate
as DT_STR and could not map it directly to DATETIME2.

Orders were therefore first loaded into raw.Orders_Stage
with OrderDate as VARCHAR(30).

Date conversion was validated using TRY_CONVERT before
loading into raw.Orders.
*/