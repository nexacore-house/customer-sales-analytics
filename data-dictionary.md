# Customer & Sales Analytics — Data Dictionary

## 1. Purpose

This document describes the datasets, tables, keys, important attributes and analytical roles used in the Customer & Sales Analytics project.

The solution contains two primary data layers:

1. **Raw source layer** — transactional CSV data loaded into the SQL `raw` schema.
2. **Analytical layer** — dimensional tables created in the SQL `analytics` schema and imported into Power BI.

The final Power BI model follows a star-schema design centred on `FactSales`.


---

# 2. Raw Source Data

The source dataset contains five primary CSV files:

| Source File | Purpose | Approximate Scale |
|---|---|---:|
| customers.csv | Customer master data | 20,000 unique customers |
| categories.csv | Product category reference data | 8 categories |
| products.csv | Product master data | 500 products |
| orders.csv | Order header transactions | 180,000 orders |
| order_lines.csv | Product-level order transactions | 450,000 order lines |

The transactional period covers:

**1 January 2022 – 31 December 2025**


---

# 3. Customers Source

## Grain

One row represents one customer record in the source customer master.

The raw file contains a small number of intentionally duplicated source rows for data-quality validation.

## Key

`CustomerID`

## Important Fields

| Column | Description | Analytical Role |
|---|---|---|
| CustomerID | Business identifier for the customer | Primary business key |
| CustomerType | Customer classification, such as Consumer or Business | Customer segmentation/filtering |
| RegistrationDate | Date the customer registered | Customer profile attribute |
| City | Customer city | Geographic analysis |
| County | Customer county where available | Geographic analysis |
| Region | Customer region | Geographic analysis |

### Notes

`RegistrationDate` is not used to determine when a customer first purchased.

Customer acquisition analysis uses the customer's **first observed completed purchase date**, derived from transactional data.

Duplicate source customer records are resolved before the analytical `DimCustomer` table is created.


---

# 4. Categories Source

## Grain

One row represents one product category.

## Key

`CategoryID`

## Important Fields

| Column | Description | Analytical Role |
|---|---|---|
| CategoryID | Unique category identifier | Primary key |
| CategoryName | Descriptive category name | Category analysis |

The dataset contains eight product categories:

- Electronics
- Home & Kitchen
- Health & Personal Care
- Sports & Fitness
- Office & Stationery
- Accessories
- Smart Home
- Travel & Lifestyle

Category information is ultimately flattened into `DimProduct` in the analytical model rather than maintained as a separate Power BI dimension.


---

# 5. Products Source

## Grain

One row represents one product.

## Key

`ProductID`

## Important Fields

| Column | Description | Analytical Role |
|---|---|---|
| ProductID | Unique product identifier | Primary business key |
| ProductName | Product description | Product analysis |
| CategoryID | Category associated with the product | Foreign key to category source |
| UnitPrice | Standard/reference product selling price | Product reference attribute |
| UnitCost | Standard/reference product cost | Product reference attribute |

### Notes

Actual transaction-level commercial calculations use values associated with the transaction rather than relying solely on current product-master pricing.

This preserves the commercial values applicable to the individual transaction.


---

# 6. Orders Source

## Grain

One row represents one customer order.

## Key

`OrderID`

## Important Fields

| Column | Description | Analytical Role |
|---|---|---|
| OrderID | Unique order identifier | Primary business key |
| CustomerID | Customer placing the order | Foreign key to customer |
| OrderDate | Date of the order | Time analysis |
| Channel | Sales channel used for the order | Channel analysis |
| OrderStatus | Commercial status of the order | Transaction treatment |

## Order Statuses

The dataset contains:

- Completed
- Returned
- Cancelled

Only **Completed** orders are included in the primary analytical `FactSales` table.

Returned and cancelled orders remain available in the raw layer for traceability and validation.


---

# 7. Order Lines Source

## Grain

One row represents one product line within an order.

An order may therefore contain multiple order-line records.

## Key Structure

The order-line source links:

- `OrderID`
- `ProductID`

to the relevant transaction detail.

## Important Fields

| Column | Description | Analytical Role |
|---|---|---|
| OrderID | Order containing the line | Links to order header |
| ProductID | Product purchased | Links to product |
| Quantity | Number of units on the line | Sales-volume analysis |
| UnitPrice | Transaction selling price per unit | Revenue calculation |
| UnitCost | Transaction cost per unit | Cost/profit calculation |
| Discount | Discount applied to the transaction line | Net revenue calculation |

### Commercial Calculations

The analytical model derives commercial values at order-line level, including:

**Gross Revenue**

`Quantity × Unit Price`

**Discount Amount**

The monetary reduction applied to gross transaction value.

**Net Revenue**

`Gross Revenue - Discount Amount`

**Total Cost**

`Quantity × Unit Cost`

**Profit**

`Net Revenue - Total Cost`


---

# 8. Analytical Star Schema

The SQL analytical layer contains five primary tables:

| Table | Type | Purpose |
|---|---|---|
| DimCustomer | Dimension | Customer attributes and segmentation base |
| DimProduct | Dimension | Product and category attributes |
| DimDate | Dimension | Calendar and time-intelligence attributes |
| DimChannel | Dimension | Sales-channel attributes |
| FactSales | Fact | Completed order-line transactions |

The model follows a standard one-to-many star schema.


---

# 9. DimCustomer

## Grain

One row represents one unique customer.

## Key

`CustomerKey`

`CustomerID` is retained as the source/business identifier.

## Core SQL Attributes

| Column | Description |
|---|---|
| CustomerKey | Analytical customer key |
| CustomerID | Source customer identifier |
| CustomerType | Consumer/business classification |
| RegistrationDate | Customer registration date |
| City | Customer city |
| County | Customer county |
| Region | Customer region |

## Power BI Customer Analytics

Additional customer-level attributes are calculated within the Power BI semantic model.

These include:

| Calculated Column | Purpose |
|---|---|
| First Purchase Date | First observed completed purchase |
| Last Purchase Date | Most recent observed completed purchase |
| First Purchase Year | Year of first observed completed purchase |
| First Purchase Month | Month of first observed completed purchase |
| Lifetime Orders | Number of completed orders across observed history |
| Lifetime Revenue | Revenue generated across observed history |
| Lifetime Profit | Profit generated across observed history |
| Lifetime Purchase Behaviour | Purchasing-behaviour classification |
| Active Purchasing Months | Number of distinct months with purchasing activity |
| Purchase Span Days | Days between first and last observed purchase |
| Days Since Last Purchase | Recency relative to the fixed analysis endpoint |
| Value Score | Customer-value quartile score |
| Customer Value Segment | Value-based customer tier |
| Frequency Score | Purchase-frequency quartile score |
| Frequency Segment | Frequency tier |
| Recency Score | Customer-recency quartile score |
| Recency Segment | Recency tier |
| Customer Behaviour Score | Combined behavioural score |
| Customer Segment | Final customer behavioural segment |

### Recency Reference Date

`Days Since Last Purchase` is evaluated relative to:

**31 December 2025**

This fixed reference date ensures that portfolio results remain reproducible rather than changing with the current system date.


---

# 10. DimProduct

## Grain

One row represents one unique product.

## Key

`ProductKey`

## Important Fields

| Column | Description |
|---|---|
| ProductKey | Analytical product key |
| ProductID | Source product identifier |
| ProductName | Product description |
| CategoryID | Source category identifier |
| CategoryName | Product category |

### Design Decision

Category is flattened into `DimProduct`.

A separate category dimension was not required because category forms a straightforward descriptive hierarchy of product and does not require independent dimensional behaviour within this analytical scope.


---

# 11. DimDate

## Grain

One row represents one calendar date.

## Key

`DateKey`

## Important Fields

| Column | Description |
|---|---|
| DateKey | Integer/date surrogate used for fact relationship |
| Date | Calendar date |
| Year | Calendar year |
| Quarter | Calendar quarter |
| MonthNumber | Numeric month |
| MonthName | Month description |
| YearMonth | Year/month reporting attribute |

The date dimension covers the complete analytical period required by the sales data.

In Power BI, `DimDate` is marked as the model's Date Table.

Power BI Auto Date/Time is disabled so that time intelligence is controlled through this explicit calendar dimension.


---

# 12. DimChannel

## Grain

One row represents one sales channel.

## Key

`ChannelKey`

## Important Fields

| Column | Description |
|---|---|
| ChannelKey | Analytical channel key |
| SalesChannel | Sales-channel description |

The four channels are:

- Online Store
- Marketplace
- Retail Stores
- Mobile App


---

# 13. FactSales

## Grain

The fact-table grain is:

> **One row per completed order line — one product purchased by one customer as part of one order.**

This grain is central to the analytical model and must be preserved when interpreting measures.

## Transaction Scope

`FactSales` contains only order lines belonging to **Completed** orders.

Returned and cancelled transactions remain in the raw data layer but are not included in realised-sales KPIs.

## Keys

| Column | Role |
|---|---|
| CustomerKey | Foreign key to DimCustomer |
| ProductKey | Foreign key to DimProduct |
| DateKey | Foreign key to DimDate |
| ChannelKey | Foreign key to DimChannel |
| OrderID | Degenerate order identifier |

## Commercial Fields

| Column | Description |
|---|---|
| OrderID | Source order identifier |
| Quantity | Units purchased |
| UnitPrice | Transaction selling price |
| UnitCost | Transaction unit cost |
| Discount | Transaction discount |
| GrossRevenue | Revenue before discount |
| NetRevenue | Revenue after discount |
| TotalCost | Transaction cost |
| Profit | Net revenue less total cost |

### OrderID Design

`OrderID` remains directly in the fact table as a **degenerate dimension**.

A separate order dimension is unnecessary because the project does not require descriptive order-level attributes beyond those already represented by the dimensions.

`OrderID` supports calculations such as distinct order count and average order value.


---

# 14. Model Relationships

The final Power BI model contains four primary relationships:

| Dimension | Fact | Cardinality | Direction |
|---|---|---|---|
| DimCustomer[CustomerKey] | FactSales[CustomerKey] | 1:* | Single |
| DimProduct[ProductKey] | FactSales[ProductKey] | 1:* | Single |
| DimDate[DateKey] | FactSales[DateKey] | 1:* | Single |
| DimChannel[ChannelKey] | FactSales[ChannelKey] | 1:* | Single |

All four relationships are active.

Filters flow from dimensions to the fact table.


---

# 15. Power BI Helper Tables

The Power BI semantic model also contains three disconnected calculated tables used for visual presentation.

| Table | Purpose |
|---|---|
| Customer Behaviour Type | Repeat vs One-Time visual categories |
| Customer Composition Type | New, Returning and Continuing customer categories |
| Customer Movement Type | Growing, Stable and Declining visual categories |

These tables intentionally have **no relationships** to the star schema.

DAX measures use the selected helper-table category to return the appropriate metric for the visual.


---

# 16. Data Lineage Summary

The high-level data flow is:

Raw CSV Files  
↓  
SQL `raw` Schema  
↓  
Data Quality Validation  
↓  
SQL Analytical Preparation  
↓  
SQL `analytics` Schema  
↓  
DimCustomer / DimProduct / DimDate / DimChannel / FactSales  
↓  
Power BI Semantic Model  
↓  
DAX Measures and Customer-Level Analytics  
↓  
Interactive Customer & Sales Analytics Report


---

# 17. Important Analytical Constraints

### Completed Sales

Primary commercial KPIs represent completed transactions only.

### Customer First Purchase

First Purchase Date represents the first **observed completed purchase** within the available dataset.

It should not be interpreted as a customer's true historical first purchase before January 2022.

### Customer Lifetime Metrics

Lifetime metrics refer to the customer's observed activity within the available 2022–2025 dataset.

### Segmentation

Customer segmentation is a static analytical classification based on complete observed purchasing history.

It is not a historical snapshot of how a customer's segment changed at each point in time.

### No Completed Purchase

Customers with no completed transactions remain valid registered customers but do not contribute to purchasing-customer or realised-sales measures.
