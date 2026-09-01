/* ============================================================
   Project: Customer & Sales Analytics
   Script: 01_create_database.sql
   Purpose: Create database, schemas and raw landing tables
   ============================================================ */

CREATE DATABASE CustomerSalesAnalytics;
GO

USE CustomerSalesAnalytics;
GO

CREATE SCHEMA raw;
GO

CREATE SCHEMA analytics;
GO

-- ============================================================
-- RAW CUSTOMERS
-- ============================================================

CREATE TABLE raw.Customers
(
    CustomerID          VARCHAR(10)     NULL,
    CustomerName        VARCHAR(150)    NULL,
    CustomerType        VARCHAR(20)     NULL,
    Gender              VARCHAR(10)     NULL,
    DateOfBirth         DATE            NULL,
    RegistrationDate    DATE            NULL,
    City                VARCHAR(100)    NULL,
    County              VARCHAR(100)    NULL,
    Region              VARCHAR(50)     NULL,
    PostcodeArea        VARCHAR(10)     NULL
);
GO

-- ============================================================
-- RAW CATEGORIES
-- ============================================================

CREATE TABLE raw.Categories
(
    CategoryID      VARCHAR(10)     NULL,
    CategoryName    VARCHAR(100)    NULL
);
GO

-- ============================================================
-- RAW PRODUCTS
-- ============================================================

CREATE TABLE raw.Products
(
    ProductID       VARCHAR(10)      NULL,
    ProductName     VARCHAR(200)     NULL,
    CategoryID      VARCHAR(10)      NULL,
    Brand           VARCHAR(100)     NULL,
    UnitCost        DECIMAL(12,2)    NULL,
    ListPrice       DECIMAL(12,2)    NULL,
    LaunchDate      DATE             NULL,
    ProductStatus   VARCHAR(20)      NULL
);
GO

-- ============================================================
-- RAW ORDERS
-- ============================================================

CREATE TABLE raw.Orders
(
    OrderID             VARCHAR(15)     NULL,
    CustomerID          VARCHAR(10)     NULL,
    OrderDate           DATETIME2       NULL,
    SalesChannel        VARCHAR(30)     NULL,
    PaymentMethod       VARCHAR(30)     NULL,
    OrderStatus         VARCHAR(20)     NULL,
    ShippingRegion      VARCHAR(50)     NULL
);
GO

-- ============================================================
-- RAW ORDER LINES
-- ============================================================

CREATE TABLE raw.OrderLines
(
    OrderLineID       BIGINT           NULL,
    OrderID           VARCHAR(15)      NULL,
    ProductID         VARCHAR(10)      NULL,
    Quantity          INT              NULL,
    UnitPrice         DECIMAL(12,2)    NULL,
    UnitCost          DECIMAL(12,2)    NULL,
    DiscountAmount    DECIMAL(12,2)    NULL
);
GO