# Customer & Sales Analytics — Data Quality & Validation

## 1. Purpose

This document describes the data-quality framework used in the Customer & Sales Analytics project.

The objective was to validate the raw transactional data before it entered the analytical star schema and to distinguish between:

- genuine data-quality problems;
- valid business conditions;
- commercial transaction statuses requiring analytical treatment.

Data-quality validation was primarily performed in SQL after the source CSV files were loaded into the `raw` schema.


---

# 2. Validation Approach

The data-quality process covered six areas:

1. Record completeness
2. Duplicate detection
3. Key integrity
4. Referential integrity
5. Business-rule validation
6. Financial and transactional validation

The principle followed throughout the project was:

> Data should not be removed or corrected simply because a value appears unusual. A condition must first be assessed to determine whether it represents invalid data or legitimate business activity.


---

# 3. Source Data Validation

The raw dataset contains five primary source files:

| Dataset | Validation Focus |
|---|---|
| Customers | Duplicates, missing attributes, geographic consistency |
| Categories | Unique category keys and descriptions |
| Products | Product keys, category relationships, commercial attributes |
| Orders | Order keys, customer references, dates, channels and statuses |
| Order Lines | Order/product references, quantity, price, cost and discounts |

Validation was completed before the analytical dimensional model was created.


---

# 4. Customer Duplicate Validation

The raw customer source contained:

**20,012 rows**

representing:

**20,000 unique customers**

This identified:

**12 duplicate source rows**

The duplicates were intentionally present in the source dataset to provide a realistic data-quality scenario.

The analytical customer dimension was built at one row per unique customer.

Final `DimCustomer` row count:

**20,000**


## Treatment

Duplicate customer source rows were removed during analytical preparation so that the customer dimension maintained a unique business key.

This prevents:

- duplicate dimension members;
- ambiguous customer relationships;
- duplicated customer counts;
- incorrect fact-table relationships.


---

# 5. Missing Customer Attributes

Some optional customer attributes contain missing values.

Examples include geographic information such as county.

These values were not automatically treated as invalid records because the customer itself may still have:

- a valid CustomerID;
- valid transactional history;
- valid customer type;
- sufficient information for other levels of geographic analysis.


## Treatment

Where an optional descriptive attribute was missing, the customer record was retained.

Missing optional attributes were therefore treated differently from missing business keys.


---

# 6. Geographic Consistency

Source customer data included controlled inconsistencies in descriptive geographic fields, including differences in city text casing.

Examples of this type of issue may include variations such as:

`Manchester`

and

`MANCHESTER`

when both represent the same location.


## Treatment

Descriptive geographic fields were standardised during preparation where appropriate.

The objective was to prevent logically identical locations from appearing as separate reporting categories due only to text formatting differences.


---

# 7. Customer Registration vs Purchasing

A registered customer does not necessarily have a completed purchase.

This is a valid business condition rather than a data-quality failure.

The project therefore distinguishes between:

**Registered Customers**

and

**Purchasing Customers**

Registered customers are counted from `DimCustomer`.

Purchasing customers are customers with completed transactional activity in `FactSales`.


## Analytical Importance

Removing customers without completed purchases would incorrectly eliminate legitimate registered customers from the customer population.

These customers are retained in `DimCustomer` and may be classified as:

`No Completed Purchase`

where relevant.


---

# 8. Order Status Validation

The order source contains three statuses:

- Completed
- Returned
- Cancelled

The raw order counts were:

| Status | Orders |
|---|---:|
| Completed | 169,360 |
| Returned | 7,079 |
| Cancelled | 3,561 |
| **Total** | **180,000** |

The statuses were validated before construction of the analytical fact table.


---

# 9. Commercial Status Treatment

The primary reporting model represents **realised completed sales**.

Therefore:

### Completed

Included in primary:

- Revenue
- Cost
- Profit
- Quantity
- Orders
- Customer purchasing analysis

### Returned

Retained in the raw layer but excluded from the primary realised-sales fact table.

### Cancelled

Retained in the raw layer but excluded from the primary realised-sales fact table.


## Reason

Treating returned or cancelled transactions as realised completed sales would distort commercial KPIs and customer purchasing behaviour.

The raw records remain available for traceability and potential future analysis.


---

# 10. Order Key Validation

`OrderID` was validated for uniqueness at the order-header grain.

The expected structure is:

> One OrderID represents one order header.

Order lines may legitimately contain the same OrderID multiple times because one order can contain multiple products.

Therefore:

- duplicate OrderID values in `Orders` would represent a data-quality issue;
- duplicate OrderID values in `OrderLines` are expected transactional behaviour.


---

# 11. Product Key Validation

`ProductID` was validated for uniqueness within the product master.

Each product should resolve to one product record and one valid category.

The analytical model contains:

**500 unique products**

Product duplicates at the product-master grain would create ambiguous dimension members and were therefore included in key-integrity validation.


---

# 12. Category Integrity

Each product is expected to reference a valid category.

The category source contains:

**8 categories**

Referential-integrity checks were used to ensure that product category identifiers resolve to valid category records.

Unmatched category keys would indicate an orphaned product relationship and require investigation before dimensional modelling.


---

# 13. Customer Referential Integrity

Each order containing a CustomerID should resolve to a valid customer record.

SQL validation checked for orders referencing customers that did not exist in the customer source.

This prevents orphaned fact transactions when constructing the customer dimension relationship.


---

# 14. Product Referential Integrity

Each order-line ProductID should resolve to a valid product.

SQL validation checked for order lines containing product identifiers absent from the product master.

This protects the relationship:

`DimProduct → FactSales`

from unmatched transactional records.


---

# 15. Order-Line Referential Integrity

Each order line should reference a valid order header.

SQL validation checked for order-line records whose OrderID did not exist in the Orders source.

This is particularly important because order-level attributes such as:

- Customer
- Order Date
- Sales Channel
- Order Status

are obtained from the order header when constructing the analytical fact table.


---

# 16. Date Validation

Order dates were checked against the expected analytical period:

**1 January 2022 – 31 December 2025**

Annual order volumes were also reviewed to ensure that the dataset covered the expected four-year period.

Raw order counts by year were:

| Year | Orders |
|---|---:|
| 2022 | 39,266 |
| 2023 | 42,765 |
| 2024 | 46,926 |
| 2025 | 51,043 |
| **Total** | **180,000** |

Dates outside the expected scope would require investigation before inclusion in the analytical model.


---

# 17. Quantity Validation

Transaction quantities were reviewed for invalid or unexpected values.

Examples requiring investigation would include:

- zero quantity;
- negative quantity where not explicitly representing a return;
- missing quantity.

Because returned transactions are represented through order status rather than negative completed-sale quantities, completed sales are expected to contain valid positive quantities.


---

# 18. Price and Cost Validation

Transaction-level prices and costs were validated for:

- missing values;
- impossible values;
- unexpected negative amounts.

Commercial values were calculated from the transaction-level fields rather than assumed from the current product master.

This preserves the financial state of the transaction at the time it occurred.


---

# 19. Discount Validation

Discount values were validated to ensure that they produced commercially valid transaction amounts.

The core relationship is:

`Net Revenue = Gross Revenue - Discount Amount`

Validation focused on conditions that could result in mathematically or commercially impossible net transaction values.


---

# 20. Financial Reconciliation

The analytical model derives:

### Gross Revenue

`Quantity × Unit Price`

### Net Revenue

`Gross Revenue - Discount Amount`

### Total Cost

`Quantity × Unit Cost`

### Profit

`Net Revenue - Total Cost`

These values were validated at SQL level before being aggregated through Power BI measures.


---

# 21. Negative Profit Is Not Automatically a Data-Quality Error

A transaction producing negative profit is not automatically invalid.

A negative-profit sale can legitimately occur because of:

- discounting;
- promotional pricing;
- transaction-level selling price;
- product cost structure.

Therefore, negative profit should be investigated analytically rather than automatically removed as bad data.

This distinction is important because aggressive data-cleaning rules could otherwise remove genuine commercial outcomes.


---

# 22. Fact Table Validation

The analytical `FactSales` table contains completed order lines only.

Validation included confirming that:

- only Completed orders entered FactSales;
- each fact CustomerKey resolved to DimCustomer;
- each ProductKey resolved to DimProduct;
- each DateKey resolved to DimDate;
- each ChannelKey resolved to DimChannel;
- OrderID remained available for distinct-order calculations.

A final reconciliation confirmed:

**169,360 distinct completed OrderIDs**

within the analytical fact table.


---

# 23. Dimension Validation

Final analytical dimension counts included:

| Dimension | Rows |
|---|---:|
| DimCustomer | 20,000 |
| DimProduct | 500 |
| DimChannel | 4 |
| DimDate | 1,461 |

These counts were reconciled against the intended dimensional grain.


---

# 24. Power BI Model Validation

After loading the analytical tables into Power BI, additional model-level QA was completed.

The following relationships were validated:

`DimCustomer[CustomerKey] 1 → * FactSales[CustomerKey]`

`DimProduct[ProductKey] 1 → * FactSales[ProductKey]`

`DimChannel[ChannelKey] 1 → * FactSales[ChannelKey]`

`DimDate[DateKey] 1 → * FactSales[DateKey]`

All relationships are:

- active;
- one-to-many;
- single-direction;
- dimension-to-fact.


---

# 25. KPI Reconciliation

Core Power BI results were reconciled against SQL outputs.

Final all-time values include:

| KPI | Validated Result |
|---|---:|
| Revenue | £46,028,499.80 |
| Profit | Approximately £19.63M |
| Profit Margin | Approximately 42.66% |
| Completed Orders | 169,360 |
| Purchasing Customers | 17,773 |
| Registered Customers | 20,000 |
| Average Customer Value | Approximately £2.59K |
| Repeat Customer Rate | Approximately 91.67% |

This reconciliation was performed before final report screenshots and documentation were produced.


---

# 26. Annual Revenue Reconciliation

Revenue was also reconciled by reporting year:

| Year | Revenue |
|---|---:|
| 2022 | £9,432,133.84 |
| 2023 | £10,688,711.28 |
| 2024 | £12,108,867.86 |
| 2025 | £13,798,786.82 |
| **Total** | **£46,028,499.80** |

The annual totals reconcile to the all-time Power BI Revenue measure.


---

# 27. Customer Analytics Validation

Customer-level analytical logic received additional QA because several metrics depend on filter context and customer history.

Validation included:

- First Purchase Date
- Last Purchase Date
- Lifetime Orders
- Lifetime Revenue
- Repeat customer classification
- New versus existing customers
- Customer value segmentation
- Recency and frequency scoring
- Customer movement
- Previous-year customer comparisons


---

# 28. New vs Existing Revenue Validation

For each year:

`New Customer Revenue + Existing Customer Revenue = Total Revenue`

Validated results include:

| Year | New Customer Revenue | Existing Customer Revenue |
|---|---:|---:|
| 2022 | £9,432,133.84 | £0.00 |
| 2023 | £2,742,346.77 | £7,946,364.51 |
| 2024 | £2,488,661.40 | £9,620,206.46 |
| 2025 | £2,364,561.06 | £11,434,225.76 |

2022 is entirely classified as new-customer revenue because it is the first year of observable transaction history.


---

# 29. Segmentation Validation

Customer-value segmentation was validated against the purchasing-customer population.

| Value Segment | Customers |
|---|---:|
| Premium Value | 4,443 |
| High Value | 4,443 |
| Medium Value | 4,443 |
| Low Value | 4,444 |
| **Total** | **17,773** |

Approximate revenue contribution:

| Value Segment | Revenue Share |
|---|---:|
| Premium Value | 63.7% |
| High Value | 22.0% |
| Medium Value | 10.7% |
| Low Value | 3.6% |
| **Total** | **100%** |

This provided an additional validation of the quartile-based segmentation logic.


---

# 30. Customer Trend Validation

For customer movement analysis, classification totals were reconciled to the underlying purchasing population.

For 2025:

| Classification | Customers |
|---|---:|
| Growing | 4,829 |
| Stable | 358 |
| Declining | 4,761 |
| Continuing | 9,948 |

The following reconciliation holds:

`Growing + Stable + Declining = Continuing`

Therefore:

`4,829 + 358 + 4,761 = 9,948`

A separate validation confirmed:

`Continuing + No Longer Purchasing = Previous-Year Purchasing Customers`

For 2025:

`9,948 + 2,944 = 12,892`


---

# 31. Data Quality vs Business Conditions

A key principle of this project is that not every unusual condition represents bad data.

| Condition | Classification |
|---|---|
| Duplicate customer master row | Data-quality issue |
| Missing optional county | Potential completeness issue |
| Inconsistent city casing | Standardisation issue |
| Invalid foreign key | Data-quality issue |
| Registered customer with no purchase | Valid business condition |
| Multiple order lines per OrderID | Valid transactional structure |
| Negative profit transaction | Potentially valid commercial outcome |
| Cancelled order | Valid business status |
| Returned order | Valid business status |
| Customer purchasing less than previous year | Analytical behaviour, not DQ |
| Customer with no current-year purchase | Analytical behaviour, not automatically churn |


---

# 32. Validation Outcome

The data-quality process produced a validated analytical model suitable for customer and sales analysis.

The final solution maintains a clear separation between:

**Raw data**

and

**Analytical data**

while preserving source records required for traceability.

The resulting model supports reproducible SQL validation, dimensional modelling and Power BI analysis without silently removing legitimate business conditions from the dataset.
