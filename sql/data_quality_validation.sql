
/* ============================================================
   Data Validation checks:
   Row Count Validation
   ============================================================ */

USE CustomerSalesAnalytics;
GO

SELECT 'Customers' AS TableName, COUNT(*) AS [RowCount]
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
   Data Validation checks:
   Duplicate Key Checks
   ============================================================ */
   SELECT
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM raw.Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;

SELECT
    CustomerID,
    CustomerName,
    CustomerType,
    Gender,
    DateOfBirth,
    RegistrationDate,
    City,
    County,
    Region,
    PostcodeArea,
    COUNT(*) AS DuplicateCount
FROM raw.Customers
GROUP BY
    CustomerID,
    CustomerName,
    CustomerType,
    Gender,
    DateOfBirth,
    RegistrationDate,
    City,
    County,
    Region,
    PostcodeArea
HAVING COUNT(*) > 1;

SELECT
    ProductID,
    COUNT(*) AS DuplicateCount
FROM raw.Products
GROUP BY ProductID
HAVING COUNT(*) > 1;

SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM raw.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

SELECT
    OrderLineID,
    COUNT(*) AS DuplicateCount
FROM raw.OrderLines
GROUP BY OrderLineID
HAVING COUNT(*) > 1;

/* ============================================================
   Mandatory Null Checks:
   ============================================================ */

SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN CustomerName IS NULL THEN 1 ELSE 0 END) AS MissingCustomerName,
    SUM(CASE WHEN CustomerType IS NULL THEN 1 ELSE 0 END) AS MissingCustomerType,
    SUM(CASE WHEN RegistrationDate IS NULL THEN 1 ELSE 0 END) AS MissingRegistrationDate,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS MissingCity,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS MissingRegion,
    SUM(CASE WHEN PostcodeArea IS NULL THEN 1 ELSE 0 END) AS MissingPostcodeArea
FROM raw.Customers;