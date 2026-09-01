# Customer & Sales Analytics — Project Overview

## 1. Project Summary

Customer & Sales Analytics is an end-to-end business intelligence project designed to analyse customer behaviour, commercial performance, purchasing patterns, customer value, and changes in customer activity over time.

The project models a fictional UK omnichannel retailer, **Northstar Retail Group**, operating across multiple product categories and sales channels.

The solution moves beyond traditional sales reporting by combining transactional sales analysis with customer-level analytics, including:

- Customer value analysis
- Purchase frequency and recency
- Repeat purchasing behaviour
- New and existing customer analysis
- Customer segmentation
- Customer growth and decline analysis
- Product and category behaviour
- Sales channel performance
- Year-over-year customer movement

The final solution uses SQL for data preparation and dimensional modelling, and Power BI with DAX for the semantic model, customer analytics, interactive reporting, and business insight generation.


## 2. Business Scenario

Northstar Retail Group is a fictional UK consumer retail business operating through four sales channels:

- Online Store
- Mobile App
- Retail Stores
- Marketplace

The company sells products across eight categories:

- Electronics
- Home & Kitchen
- Health & Personal Care
- Sports & Fitness
- Office & Stationery
- Accessories
- Smart Home
- Travel & Lifestyle

Management has access to transactional sales data but requires a stronger understanding of the customers behind those transactions.

Traditional revenue reporting can show what has been sold, but it does not fully answer questions such as:

- Which customers generate the greatest commercial value?
- How frequently do customers purchase?
- How concentrated is revenue among high-value customers?
- Which customers are purchasing more or less over time?
- How much revenue comes from newly acquired versus existing customers?
- Which customer groups are associated with particular product categories?
- Which previously active customers are no longer purchasing?
- Which channels and categories generate the strongest commercial performance?


## 3. Project Objective

The objective of the project is to transform detailed transactional data into a structured customer analytics solution that supports both commercial and behavioural analysis.

The solution was designed to:

1. Build a reliable analytical data model from raw transactional files.
2. Apply explicit data-quality and commercial-status rules.
3. Create a dimensional star schema suitable for Power BI.
4. Develop reusable DAX measures for customer and sales analytics.
5. Segment customers using behavioural and value-based characteristics.
6. Compare customer purchasing behaviour across reporting periods.
7. Identify defensible business insights directly supported by the data.
8. Present the results through a four-page interactive Power BI report.


## 4. Data Scope

The dataset covers the period:

**1 January 2022 – 31 December 2025**

The raw dataset contains approximately:

| Dataset | Scale |
|---|---:|
| Customers | 20,000 unique customers |
| Products | 500 |
| Product Categories | 8 |
| Orders | 180,000 |
| Order Lines | 450,000 |
| Sales Channels | 4 |
| Transaction Period | 4 years |

The source customer file intentionally contains a small number of duplicate records and other controlled data-quality conditions to support realistic validation and preparation work.


## 5. Commercial Transaction Treatment

Orders contain three business statuses:

- Completed
- Returned
- Cancelled

For the primary realised-sales analytical model:

**Completed orders are included in the FactSales table.**

Returned and cancelled orders are retained in the raw data layer for traceability and data-quality analysis but are excluded from the primary realised Revenue, Cost, Profit, Quantity and Order measures.

This prevents cancelled or returned transactions from being interpreted as realised commercial sales.


## 6. Analytical Data Model

The Power BI solution uses a star schema consisting of:

- DimCustomer
- DimProduct
- DimDate
- DimChannel
- FactSales

The fact-table grain is:

> One row per completed order line — one product purchased by one customer as part of one order.

The model uses one-to-many, single-direction relationships from each dimension to FactSales.

OrderID is retained in the fact table as a degenerate dimension to support order-level calculations without introducing an unnecessary order dimension.


## 7. Customer Analytics Approach

### Customer Behaviour

The model evaluates:

- Purchasing customers
- Repeat customers
- One-time customers
- Orders per customer
- Average customer value
- Customer revenue contribution
- Lifetime orders
- Lifetime revenue
- First purchase
- Last purchase
- Active purchasing months


### New and Existing Customers

A New Customer is defined as a customer whose **first observed completed purchase** occurs within the evaluated reporting period.

Because the available transactional history begins in January 2022, first purchase represents the first observed completed purchase within the available 2022–2025 dataset.

Customers purchasing during the reporting period whose first observed purchase occurred earlier are treated as existing customers.


### Customer Segmentation

Customer segmentation is based on customer-level:

- Recency
- Frequency
- Value

Customers are scored using data-driven quartile thresholds rather than arbitrary monetary limits.

The final behavioural segments include:

- High-Value Loyal
- Valuable Regular
- Recent Developing
- Core Customer
- High-Value At Risk
- Low Engagement
- No Completed Purchase

The segmentation represents a static lifetime view based on the complete observed 2022–2025 transactional history. It should not be interpreted as historical point-in-time segmentation.


### Customer Movement

For period-over-period customer analysis, continuing customers are classified using changes in customer revenue.

The materiality threshold is:

- Growing: revenue change greater than +5%
- Stable: revenue change between -5% and +5%
- Declining: revenue change below -5%

The model also identifies:

- New Customers
- Returning Existing Customers
- Continuing Customers
- No Longer Purchasing Customers

`No Longer Purchasing` indicates that a customer purchased during the previous comparable period but recorded no completed purchase during the current period.

It does not represent confirmed customer churn.


## 8. Power BI Report Structure

The final report contains four analytical pages.

### Page 1 — Customer Overview

Provides the executive-level customer and commercial picture.

Key areas include:

- Revenue and profit
- Purchasing customers
- Repeat purchasing
- Customer value
- Revenue trend
- New versus existing customer revenue
- Customer-type performance


### Page 2 — Customer Segmentation

Explores customer concentration and behavioural segmentation.

Key areas include:

- Premium-value customers
- High-Value Loyal customers
- High-Value At Risk customers
- Customer versus revenue concentration
- Recency by customer value
- Purchase frequency by customer value


### Page 3 — Sales & Product Behaviour

Connects customer behaviour with commercial purchasing activity.

Key areas include:

- Category revenue and profit
- Customer value by category
- Customer segment purchasing patterns
- Sales channel revenue and profit


### Page 4 — Customer Trends

Examines how customer activity changes between reporting periods.

Key areas include:

- New customers
- Returning customers
- Continuing customers
- Growing customers
- Stable customers
- Declining customers
- No Longer Purchasing customers
- Current versus previous-year revenue


## 9. Technology Stack

The project uses:

- **SQL Server / SSMS** — database creation, raw-data storage, validation, transformation and dimensional modelling
- **SQL** — data-quality checks, analytical exploration, aggregations and star-schema preparation
- **Power BI Desktop** — semantic modelling and interactive reporting
- **Power Query** — data connectivity and model loading
- **DAX** — business measures, customer behaviour, segmentation, time intelligence and trend analysis
- **Git / GitHub** — source control and portfolio documentation


## 10. Key Analytical Results

Several significant patterns were identified from the completed analysis:

- Premium Value customers represent approximately 25% of purchasing customers but contribute approximately 63.7% of total revenue.
- Existing-customer revenue increased from approximately £7.95M in 2023 to £11.43M in 2025.
- Electronics generated approximately £17.9M and was the largest revenue category.
- Online Store was the leading sales channel by revenue and profit.
- Among customers active in both 2024 and 2025, approximately 48.5% materially increased their revenue contribution while approximately 47.9% materially decreased it.
- 2,944 customers who purchased in 2024 recorded no completed purchase during 2025, representing approximately 23% of the previous-year purchasing population.

These findings describe patterns observed within the project dataset and do not imply causation.


## 11. Project Deliverables

The repository contains:

- Raw source datasets
- SQL database and analytical scripts
- Data-quality validation
- Dimensional modelling logic
- Power BI report
- DAX analytical logic
- Customer segmentation methodology
- Customer trend methodology
- KPI definitions
- Data dictionary
- Data model screenshot
- Dashboard screenshots
- Validated analytical findings
- Technical documentation


## 12. Portfolio Focus

This project demonstrates practical capability across the complete analytics lifecycle:

**Raw Data → Data Quality → SQL Transformation → Dimensional Modelling → Power BI Semantic Model → DAX → Customer Analytics → Interactive Reporting → Business Insight**

The emphasis is not only on dashboard design, but on producing a traceable and analytically defensible BI solution from source data through to final interpretation.
