USE CustomerSalesAnalytics;
GO

WITH CleanCustomers AS
(
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
        ROW_NUMBER() OVER
        (
            PARTITION BY CustomerID
            ORDER BY CustomerID
        ) AS RowNum
    FROM raw.Customers
),
SalesBase AS
(
    SELECT
        o.OrderID,
        o.CustomerID,
        o.OrderDate,
        o.SalesChannel,
        o.PaymentMethod,
        o.ShippingRegion,
        ol.OrderLineID,
        ol.ProductID,
        ol.Quantity,
        ol.UnitPrice,
        ol.UnitCost,
        ol.DiscountAmount,

        ol.Quantity * ol.UnitPrice AS GrossRevenue,

        (ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount AS NetRevenue,

        ol.Quantity * ol.UnitCost AS TotalCost,

        ((ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount)
            - (ol.Quantity * ol.UnitCost) AS Profit

    FROM raw.Orders o
    INNER JOIN raw.OrderLines ol
        ON o.OrderID = ol.OrderID
    WHERE o.OrderStatus = 'Completed'
)
SELECT TOP 100 *
FROM SalesBase;

WITH SalesBase AS
(
    SELECT
        o.OrderID,
        o.CustomerID,
        ol.Quantity,
        ol.Quantity * ol.UnitPrice AS GrossRevenue,
        (ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount AS NetRevenue,
        ol.Quantity * ol.UnitCost AS TotalCost,
        ((ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount)
            - (ol.Quantity * ol.UnitCost) AS Profit
    FROM raw.Orders o
    INNER JOIN raw.OrderLines ol
        ON o.OrderID = ol.OrderID
    WHERE o.OrderStatus = 'Completed'
)
SELECT
    COUNT(DISTINCT OrderID) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    SUM(Quantity) AS Units,
    ROUND(SUM(GrossRevenue), 2) AS GrossRevenue,
    ROUND(SUM(NetRevenue), 2) AS NetRevenue,
    ROUND(SUM(TotalCost), 2) AS TotalCost,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(
        SUM(Profit) /
        NULLIF(SUM(NetRevenue), 0) * 100,
        2
    ) AS ProfitMarginPct
FROM SalesBase;

WITH SalesBase AS
(
    SELECT
        o.OrderID,
        o.CustomerID,
        o.OrderDate,
        ol.Quantity,
        (ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount AS NetRevenue,

        ((ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount)
            - (ol.Quantity * ol.UnitCost) AS Profit
    FROM raw.Orders o
    INNER JOIN raw.OrderLines ol
        ON o.OrderID = ol.OrderID
    WHERE o.OrderStatus = 'Completed'
)
SELECT
    YEAR(OrderDate) AS SalesYear,
    COUNT(DISTINCT OrderID) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    SUM(Quantity) AS Units,
    ROUND(SUM(NetRevenue), 2) AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(
        SUM(Profit) /
        NULLIF(SUM(NetRevenue), 0) * 100,
        2
    ) AS MarginPct
FROM SalesBase
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;

WITH CustomerSales AS
(
    SELECT
        o.CustomerID,
        COUNT(DISTINCT o.OrderID) AS Orders,
        MIN(o.OrderDate) AS FirstPurchaseDate,
        MAX(o.OrderDate) AS LastPurchaseDate,
        SUM(ol.Quantity) AS Units,

        SUM(
            (ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount
        ) AS Revenue,

        SUM(
            ((ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount)
            - (ol.Quantity * ol.UnitCost)
        ) AS Profit

    FROM raw.Orders o
    INNER JOIN raw.OrderLines ol
        ON o.OrderID = ol.OrderID
    WHERE o.OrderStatus = 'Completed'
    GROUP BY o.CustomerID
)
SELECT TOP 100
    CustomerID,
    Orders,
    FirstPurchaseDate,
    LastPurchaseDate,
    Units,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(Profit, 2) AS Profit,
    ROUND(
        Revenue / NULLIF(Orders, 0),
        2
    ) AS AverageOrderValue
FROM CustomerSales
ORDER BY Revenue DESC;

WITH CustomerSales AS
(
    SELECT
        o.CustomerID,
        COUNT(DISTINCT o.OrderID) AS Orders,
        SUM(
            (ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount
        ) AS Revenue
    FROM raw.Orders o
    INNER JOIN raw.OrderLines ol
        ON o.OrderID = ol.OrderID
    WHERE o.OrderStatus = 'Completed'
    GROUP BY o.CustomerID
)
SELECT TOP 20
    CustomerID,
    Orders,
    ROUND(Revenue, 2) AS Revenue
FROM CustomerSales
ORDER BY Revenue DESC;

WITH CustomerSales AS
(
    SELECT
        o.CustomerID,

        SUM(
            (ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount
        ) AS Revenue,

        SUM(
            ((ol.Quantity * ol.UnitPrice)
            - ol.DiscountAmount)
            - (ol.Quantity * ol.UnitCost)
        ) AS Profit

    FROM raw.Orders o
    INNER JOIN raw.OrderLines ol
        ON o.OrderID = ol.OrderID
    WHERE o.OrderStatus = 'Completed'
    GROUP BY o.CustomerID
)
SELECT TOP 20
    CustomerID,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(Profit, 2) AS Profit,
    ROUND(
        Profit / NULLIF(Revenue, 0) * 100,
        2
    ) AS MarginPct
FROM CustomerSales
ORDER BY Profit DESC;




