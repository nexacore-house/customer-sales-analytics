USE CustomerSalesAnalytics;
GO

CREATE TABLE analytics.DimCustomer
(
    CustomerKey        INT IDENTITY(1,1) NOT NULL,
    CustomerID         VARCHAR(10) NOT NULL,
    CustomerName       VARCHAR(150) NOT NULL,
    CustomerType       VARCHAR(20) NOT NULL,
    Gender             VARCHAR(10) NOT NULL,
    DateOfBirth        DATE NULL,
    RegistrationDate   DATE NOT NULL,
    City               VARCHAR(100) NOT NULL,
    County             VARCHAR(100) NOT NULL,
    Region             VARCHAR(50) NOT NULL,
    PostcodeArea       VARCHAR(10) NOT NULL,

    CONSTRAINT PK_DimCustomer
        PRIMARY KEY (CustomerKey),

    CONSTRAINT UQ_DimCustomer_CustomerID
        UNIQUE (CustomerID)
);
GO

USE CustomerSalesAnalytics;
GO

INSERT INTO analytics.DimCustomer
(
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
)
SELECT DISTINCT
    CustomerID,
    CustomerName,
    CustomerType,

    COALESCE(Gender, 'Unknown') AS Gender,

    DateOfBirth,
    RegistrationDate,

    CONCAT(
        UPPER(LEFT(City, 1)),
        LOWER(SUBSTRING(City, 2, LEN(City)))
    ) AS City,

    COALESCE(County, 'Unknown') AS County,

    Region,
    PostcodeArea
FROM raw.Customers;
GO

CREATE TABLE analytics.DimProduct
(
    ProductKey        INT IDENTITY(1,1) NOT NULL,
    ProductID         VARCHAR(10) NOT NULL,
    ProductName       VARCHAR(200) NOT NULL,
    CategoryID        VARCHAR(10) NOT NULL,
    CategoryName      VARCHAR(100) NOT NULL,
    Brand             VARCHAR(100) NOT NULL,
    CurrentUnitCost   DECIMAL(12,2) NOT NULL,
    ListPrice         DECIMAL(12,2) NOT NULL,
    LaunchDate        DATE NOT NULL,
    ProductStatus     VARCHAR(20) NOT NULL,

    CONSTRAINT PK_DimProduct
        PRIMARY KEY (ProductKey),

    CONSTRAINT UQ_DimProduct_ProductID
        UNIQUE (ProductID)
);
GO

INSERT INTO analytics.DimProduct
(
    ProductID,
    ProductName,
    CategoryID,
    CategoryName,
    Brand,
    CurrentUnitCost,
    ListPrice,
    LaunchDate,
    ProductStatus
)
SELECT
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    c.CategoryName,
    p.Brand,
    p.UnitCost,
    p.ListPrice,
    p.LaunchDate,
    p.ProductStatus
FROM raw.Products p
INNER JOIN raw.Categories c
    ON p.CategoryID = c.CategoryID;
GO

CREATE TABLE analytics.DimChannel
(
    ChannelKey      INT IDENTITY(1,1) NOT NULL,
    SalesChannel    VARCHAR(30) NOT NULL,

    CONSTRAINT PK_DimChannel
        PRIMARY KEY (ChannelKey),

    CONSTRAINT UQ_DimChannel_SalesChannel
        UNIQUE (SalesChannel)
);
GO

INSERT INTO analytics.DimChannel
(
    SalesChannel
)
SELECT DISTINCT
    SalesChannel
FROM raw.Orders
WHERE SalesChannel IS NOT NULL;
GO

CREATE TABLE analytics.DimDate
(
    DateKey             INT NOT NULL,
    [Date]              DATE NOT NULL,
    [Year]              INT NOT NULL,
    QuarterNumber       INT NOT NULL,
    QuarterName         VARCHAR(2) NOT NULL,
    MonthNumber         INT NOT NULL,
    MonthName           VARCHAR(20) NOT NULL,
    YearMonth           CHAR(7) NOT NULL,
    YearMonthNumber     INT NOT NULL,
    WeekNumber          INT NOT NULL,
    DayOfMonth          INT NOT NULL,
    DayName             VARCHAR(20) NOT NULL,
    DayOfWeekNumber     INT NOT NULL,
    IsWeekend           BIT NOT NULL,

    CONSTRAINT PK_DimDate
        PRIMARY KEY (DateKey),

    CONSTRAINT UQ_DimDate_Date
        UNIQUE ([Date])
);
GO

WITH DateSeries AS
(
    SELECT CAST('2022-01-01' AS DATE) AS [Date]

    UNION ALL

    SELECT DATEADD(DAY, 1, [Date])
    FROM DateSeries
    WHERE [Date] < '2025-12-31'
)
INSERT INTO analytics.DimDate
(
    DateKey,
    [Date],
    [Year],
    QuarterNumber,
    QuarterName,
    MonthNumber,
    MonthName,
    YearMonth,
    YearMonthNumber,
    WeekNumber,
    DayOfMonth,
    DayName,
    DayOfWeekNumber,
    IsWeekend
)
SELECT
    YEAR([Date]) * 10000
        + MONTH([Date]) * 100
        + DAY([Date]),

    [Date],

    YEAR([Date]),

    DATEPART(QUARTER, [Date]),

    CONCAT(
        'Q',
        DATEPART(QUARTER, [Date])
    ),

    MONTH([Date]),

    DATENAME(MONTH, [Date]),

    CONVERT(CHAR(7), [Date], 126),

    YEAR([Date]) * 100
        + MONTH([Date]),

    DATEPART(ISO_WEEK, [Date]),

    DAY([Date]),

    DATENAME(WEEKDAY, [Date]),

    ((DATEDIFF(DAY, '19000101', [Date]) % 7) + 1),

    CASE
        WHEN ((DATEDIFF(DAY, '19000101', [Date]) % 7) + 1)
             IN (6,7)
        THEN 1
        ELSE 0
    END

FROM DateSeries
OPTION (MAXRECURSION 0);
GO

CREATE TABLE analytics.FactSales
(
    SalesKey          BIGINT IDENTITY(1,1) NOT NULL,
    OrderLineID       BIGINT NOT NULL,
    OrderID           VARCHAR(15) NOT NULL,

    DateKey           INT NOT NULL,
    CustomerKey       INT NOT NULL,
    ProductKey        INT NOT NULL,
    ChannelKey        INT NOT NULL,

    PaymentMethod     VARCHAR(30) NOT NULL,
    ShippingRegion    VARCHAR(50) NOT NULL,

    Quantity          INT NOT NULL,
    UnitPrice         DECIMAL(12,2) NOT NULL,
    UnitCost          DECIMAL(12,2) NOT NULL,

    GrossRevenue      DECIMAL(18,2) NOT NULL,
    DiscountAmount    DECIMAL(18,2) NOT NULL,
    NetRevenue        DECIMAL(18,2) NOT NULL,
    TotalCost         DECIMAL(18,2) NOT NULL,
    Profit            DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_FactSales
        PRIMARY KEY (SalesKey),

    CONSTRAINT UQ_FactSales_OrderLineID
        UNIQUE (OrderLineID),

    CONSTRAINT FK_FactSales_Date
        FOREIGN KEY (DateKey)
        REFERENCES analytics.DimDate(DateKey),

    CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY (CustomerKey)
        REFERENCES analytics.DimCustomer(CustomerKey),

    CONSTRAINT FK_FactSales_Product
        FOREIGN KEY (ProductKey)
        REFERENCES analytics.DimProduct(ProductKey),

    CONSTRAINT FK_FactSales_Channel
        FOREIGN KEY (ChannelKey)
        REFERENCES analytics.DimChannel(ChannelKey)
);
GO

INSERT INTO analytics.FactSales
(
    OrderLineID,
    OrderID,
    DateKey,
    CustomerKey,
    ProductKey,
    ChannelKey,
    PaymentMethod,
    ShippingRegion,
    Quantity,
    UnitPrice,
    UnitCost,
    GrossRevenue,
    DiscountAmount,
    NetRevenue,
    TotalCost,
    Profit
)
SELECT
    ol.OrderLineID,
    o.OrderID,

    YEAR(o.OrderDate) * 10000
        + MONTH(o.OrderDate) * 100
        + DAY(o.OrderDate) AS DateKey,

    dc.CustomerKey,
    dp.ProductKey,
    dch.ChannelKey,

    o.PaymentMethod,
    o.ShippingRegion,

    ol.Quantity,
    ol.UnitPrice,
    ol.UnitCost,

    CAST(
        ol.Quantity * ol.UnitPrice
        AS DECIMAL(18,2)
    ) AS GrossRevenue,

    ol.DiscountAmount,

    CAST(
        (ol.Quantity * ol.UnitPrice)
        - ol.DiscountAmount
        AS DECIMAL(18,2)
    ) AS NetRevenue,

    CAST(
        ol.Quantity * ol.UnitCost
        AS DECIMAL(18,2)
    ) AS TotalCost,

    CAST(
        ((ol.Quantity * ol.UnitPrice)
        - ol.DiscountAmount)
        - (ol.Quantity * ol.UnitCost)
        AS DECIMAL(18,2)
    ) AS Profit

FROM raw.OrderLines ol

INNER JOIN raw.Orders o
    ON ol.OrderID = o.OrderID

INNER JOIN analytics.DimCustomer dc
    ON o.CustomerID = dc.CustomerID

INNER JOIN analytics.DimProduct dp
    ON ol.ProductID = dp.ProductID

INNER JOIN analytics.DimChannel dch
    ON o.SalesChannel = dch.SalesChannel

WHERE o.OrderStatus = 'Completed';
GO

CREATE INDEX IX_FactSales_DateKey
ON analytics.FactSales(DateKey);

CREATE INDEX IX_FactSales_CustomerKey
ON analytics.FactSales(CustomerKey);

CREATE INDEX IX_FactSales_ProductKey
ON analytics.FactSales(ProductKey);

CREATE INDEX IX_FactSales_ChannelKey
ON analytics.FactSales(ChannelKey);

CREATE INDEX IX_FactSales_OrderID
ON analytics.FactSales(OrderID);
GO

SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS [RowCount]
FROM sys.tables t

INNER JOIN sys.schemas s
    ON t.schema_id = s.schema_id

INNER JOIN sys.partitions p
    ON t.object_id = p.object_id
    AND p.index_id IN (0,1)

WHERE s.name = 'analytics'

GROUP BY
    s.name,
    t.name

ORDER BY
    t.name;
