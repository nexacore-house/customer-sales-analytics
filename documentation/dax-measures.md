# Customer & Sales Analytics --- DAX Measures

## 1. Purpose

This document describes the principal DAX objects used in the Customer &
Sales Analytics Power BI semantic model.

The model deliberately distinguishes between:

-   **Measures** --- dynamic calculations evaluated in report filter
    context;
-   **Calculated Columns** --- customer-level attributes stored in
    `DimCustomer`;
-   **Calculated Tables** --- small disconnected helper structures used
    for presentation.

Most business calculations are organised in the dedicated `_Measures`
table.

------------------------------------------------------------------------

## 2. DAX Organisation

The `_Measures` table contains logical display folders for:

-   Sales
-   Volume
-   Averages
-   Customer Behaviour
-   Customer Growth
-   Time Intelligence
-   Customer Segmentation
-   Customer Trends

Customer-level lifetime attributes and RFV classifications are stored as
calculated columns in `DimCustomer`.

Three disconnected calculated tables support categorical visuals:

-   `Customer Behaviour Type`
-   `Customer Composition Type`
-   `Customer Movement Type`

------------------------------------------------------------------------

# 3. Sales Measures

## Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Revenue =
SUM ( FactSales[NetRevenue] )
```

Represents realised net revenue from completed transactions.

Validated all-time result:

**£46,028,499.80**

------------------------------------------------------------------------

## Gross Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Gross Revenue =
SUM ( FactSales[GrossRevenue] )
```

Represents completed transaction value before discounts.

------------------------------------------------------------------------

## Discounts

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Discounts =
[Gross Revenue] - [Revenue]
```

------------------------------------------------------------------------

## Total Cost

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Total Cost =
SUM ( FactSales[TotalCost] )
```

------------------------------------------------------------------------

## Profit

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Profit =
SUM ( FactSales[Profit] )
```

Validated all-time result:

**Approximately £19.63M**

------------------------------------------------------------------------

## Profit Margin %

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Profit Margin % =
DIVIDE ( [Profit], [Revenue] )
```

Validated all-time result:

**42.66%**

------------------------------------------------------------------------

## Discount Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Sales`

``` dax
Discount Rate % =
DIVIDE ( [Discounts], [Gross Revenue] )
```

------------------------------------------------------------------------

# 4. Volume Measures

## Orders

**Object Type:** MEASURE\
**Target:** `_Measures → Volume`

``` dax
Orders =
DISTINCTCOUNT ( FactSales[OrderID] )
```

`FactSales` operates at order-line grain, so `OrderID` must be counted
distinctly.

Validated all-time result:

**169,360**

------------------------------------------------------------------------

## Units Sold

**Object Type:** MEASURE\
**Target:** `_Measures → Volume`

``` dax
Units Sold =
SUM ( FactSales[Quantity] )
```

------------------------------------------------------------------------

## Purchasing Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Volume`

``` dax
Purchasing Customers =
DISTINCTCOUNT ( FactSales[CustomerKey] )
```

Validated all-time result:

**17,773**

------------------------------------------------------------------------

## Registered Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Volume`

``` dax
Registered Customers =
DISTINCTCOUNT ( DimCustomer[CustomerKey] )
```

Validated result:

**20,000**

------------------------------------------------------------------------

# 5. Average Measures

## Average Order Value

**Object Type:** MEASURE\
**Target:** `_Measures → Averages`

``` dax
Average Order Value =
DIVIDE ( [Revenue], [Orders] )
```

Validated all-time result:

**£271.78**

------------------------------------------------------------------------

## Average Customer Value

**Object Type:** MEASURE\
**Target:** `_Measures → Averages`

``` dax
Average Customer Value =
DIVIDE ( [Revenue], [Purchasing Customers] )
```

Validated all-time result:

**Approximately £2.59K**

------------------------------------------------------------------------

## Units per Order

**Object Type:** MEASURE\
**Target:** `_Measures → Averages`

``` dax
Units per Order =
DIVIDE ( [Units Sold], [Orders] )
```

------------------------------------------------------------------------

## Revenue per Unit

**Object Type:** MEASURE\
**Target:** `_Measures → Averages`

``` dax
Revenue per Unit =
DIVIDE ( [Revenue], [Units Sold] )
```

------------------------------------------------------------------------

## Profit per Customer

**Object Type:** MEASURE\
**Target:** `_Measures → Averages`

``` dax
Profit per Customer =
DIVIDE ( [Profit], [Purchasing Customers] )
```

------------------------------------------------------------------------

## Profit per Order

**Object Type:** MEASURE\
**Target:** `_Measures → Averages`

``` dax
Profit per Order =
DIVIDE ( [Profit], [Orders] )
```

------------------------------------------------------------------------

# 6. Customer Behaviour Measures

## Orders per Customer

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
Orders per Customer =
DIVIDE ( [Orders], [Purchasing Customers] )
```

Validated all-time result:

**9.53**

------------------------------------------------------------------------

## Repeat Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

Conceptually counts customers with at least two completed orders in the
current filter context.

The classification is contextual rather than a permanent customer
attribute.

------------------------------------------------------------------------

## One-Time Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

Counts customers with exactly one completed order in the current filter
context.

------------------------------------------------------------------------

## Repeat Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
Repeat Customer Rate % =
DIVIDE ( [Repeat Customers], [Purchasing Customers] )
```

Validated all-time result:

**91.67%**

This is a contextual repeat-purchasing measure and is **not a formal
retention rate**.

------------------------------------------------------------------------

## One-Time Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
One-Time Customer Rate % =
DIVIDE ( [One-Time Customers], [Purchasing Customers] )
```

------------------------------------------------------------------------

## Repeat Customer Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

Represents current-context revenue generated by customers meeting the
Repeat Customer definition.

------------------------------------------------------------------------

## Repeat Customer Revenue Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
Repeat Customer Revenue Share % =
DIVIDE ( [Repeat Customer Revenue], [Revenue] )
```

------------------------------------------------------------------------

## One-Time Customer Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

Represents current-context revenue generated by customers with exactly
one completed order.

------------------------------------------------------------------------

## One-Time Customer Revenue Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
One-Time Customer Revenue Share % =
DIVIDE ( [One-Time Customer Revenue], [Revenue] )
```

------------------------------------------------------------------------

## Average Repeat Customer Value

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
Average Repeat Customer Value =
DIVIDE ( [Repeat Customer Revenue], [Repeat Customers] )
```

------------------------------------------------------------------------

## Average One-Time Customer Value

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
Average One-Time Customer Value =
DIVIDE ( [One-Time Customer Revenue], [One-Time Customers] )
```

------------------------------------------------------------------------

# 7. Customer-Level Purchase Attributes

The following are **CALCULATED COLUMNS**, not measures.

They are stored in:

**Target:** `DimCustomer → Customer Behaviour`

This distinction is important because these values must persist at
individual customer-row level.

------------------------------------------------------------------------

## First Purchase Date

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

``` dax
First Purchase Date =
VAR CustomerFirstDateKey =
    MINX (
        RELATEDTABLE ( FactSales ),
        FactSales[DateKey]
    )
RETURN
    LOOKUPVALUE (
        DimDate[Date],
        DimDate[DateKey], CustomerFirstDateKey
    )
```

Represents the customer's first observed completed purchase in the
available 2022--2025 history.

------------------------------------------------------------------------

## Last Purchase Date

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Uses the latest `FactSales[DateKey]` from the customer's related
completed transactions and returns the corresponding date from
`DimDate`.

------------------------------------------------------------------------

## First Purchase Year

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Derived from First Purchase Date.

------------------------------------------------------------------------

## First Purchase Month

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Derived from First Purchase Date.

------------------------------------------------------------------------

## Lifetime Orders

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Represents distinct completed orders across the complete observed
history for each customer.

------------------------------------------------------------------------

## Lifetime Revenue

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Represents completed-sale revenue across the complete observed history
for each customer.

------------------------------------------------------------------------

## Lifetime Profit

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Represents customer-level profit across the complete observed history.

------------------------------------------------------------------------

## Lifetime Purchase Behaviour

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Provides a lifetime purchasing-behaviour classification based on
observed completed-order activity.

------------------------------------------------------------------------

## Active Purchasing Months

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Counts distinct months in which the customer completed a purchase.

------------------------------------------------------------------------

## Purchase Span Days

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Represents elapsed days between the customer's first and last observed
completed purchase.

------------------------------------------------------------------------

## Days Since Last Purchase

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Customer Behaviour`

Recency is calculated against the fixed analytical endpoint:

**31 December 2025**

rather than `TODAY()`.

This makes the portfolio model reproducible.

------------------------------------------------------------------------

# 8. Customer Growth Measures

## New Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
New Customers =
VAR StartDate = MIN ( DimDate[Date] )
VAR EndDate = MAX ( DimDate[Date] )
RETURN
    COUNTROWS (
        FILTER (
            VALUES ( DimCustomer[CustomerKey] ),
            DimCustomer[First Purchase Date] >= StartDate
                && DimCustomer[First Purchase Date] <= EndDate
                && CALCULATE ( [Orders] ) > 0
        )
    )
```

A New Customer is a purchasing customer whose **first observed completed
purchase** falls within the selected reporting period.

Because the dataset starts in 2022, this is first observed purchase
rather than guaranteed historical acquisition.

------------------------------------------------------------------------

## Existing Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
Existing Customers =
[Purchasing Customers] - [New Customers]
```

------------------------------------------------------------------------

## New Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
New Customer Rate % =
DIVIDE ( [New Customers], [Purchasing Customers] )
```

------------------------------------------------------------------------

## Existing Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
Existing Customer Rate % =
DIVIDE ( [Existing Customers], [Purchasing Customers] )
```

------------------------------------------------------------------------

## New Customer Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
New Customer Revenue =
VAR StartDate = MIN ( DimDate[Date] )
VAR EndDate = MAX ( DimDate[Date] )
RETURN
    SUMX (
        FILTER (
            VALUES ( DimCustomer[CustomerKey] ),
            DimCustomer[First Purchase Date] >= StartDate
                && DimCustomer[First Purchase Date] <= EndDate
        ),
        CALCULATE ( [Revenue] )
    )
```

------------------------------------------------------------------------

## Existing Customer Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
Existing Customer Revenue =
[Revenue] - [New Customer Revenue]
```

------------------------------------------------------------------------

## New Customer Revenue Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
New Customer Revenue Share % =
DIVIDE ( [New Customer Revenue], [Revenue] )
```

------------------------------------------------------------------------

## Existing Customer Revenue Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
Existing Customer Revenue Share % =
DIVIDE ( [Existing Customer Revenue], [Revenue] )
```

------------------------------------------------------------------------

## Average New Customer Value

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
Average New Customer Value =
DIVIDE ( [New Customer Revenue], [New Customers] )
```

------------------------------------------------------------------------

## Average Existing Customer Value

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Growth`

``` dax
Average Existing Customer Value =
DIVIDE ( [Existing Customer Revenue], [Existing Customers] )
```

------------------------------------------------------------------------

# 9. Time Intelligence Measures

Time-intelligence calculations use the marked `DimDate` table.

The semantic model includes previous-year and year-over-year
calculations for:

-   Revenue
-   Profit
-   Orders
-   Purchasing Customers
-   New Customers
-   Average Order Value
-   Average Customer Value

------------------------------------------------------------------------

## Revenue PY

**Object Type:** MEASURE\
**Target:** `_Measures → Time Intelligence`

Returns revenue for the equivalent previous-year period using the
controlled date dimension.

------------------------------------------------------------------------

## Revenue YoY Change

**Object Type:** MEASURE\
**Target:** `_Measures → Time Intelligence`

``` dax
Revenue YoY Change =
[Revenue] - [Revenue PY]
```

------------------------------------------------------------------------

## Revenue YoY %

**Object Type:** MEASURE\
**Target:** `_Measures → Time Intelligence`

``` dax
Revenue YoY % =
DIVIDE ( [Revenue YoY Change], [Revenue PY] )
```

The same previous-year/change/rate pattern is applied to the other
supported time-intelligence KPIs.

------------------------------------------------------------------------

# 10. Customer Segmentation Calculated Columns

The segmentation framework uses **CALCULATED COLUMNS** in:

**Target:** `DimCustomer → Segmentation`

The segmentation is static across the complete observed 2022--2025
history.

Purchasing customers are scored using:

-   Recency
-   Frequency
-   Value

Each component uses quartile scores from 1 to 4.

------------------------------------------------------------------------

## Customer Value Segment

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Classifies purchasing customers into:

-   Premium Value
-   High Value
-   Medium Value
-   Low Value

based on Lifetime Revenue quartiles.

------------------------------------------------------------------------

## Value Score

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Assigns a score from 1 to 4 based on Lifetime Revenue.

Higher value receives a higher score.

------------------------------------------------------------------------

## Frequency Score

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Assigns a score from 1 to 4 based on Lifetime Orders.

------------------------------------------------------------------------

## Frequency Segment

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Maps Frequency Score to descriptive frequency categories.

------------------------------------------------------------------------

## Recency Score

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Assigns a score from 1 to 4 based on Days Since Last Purchase.

Lower recency days receive the stronger score.

------------------------------------------------------------------------

## Recency Segment

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Maps Recency Score to descriptive recency categories.

------------------------------------------------------------------------

## Customer Behaviour Score

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

Combines the RFV scoring components for customer behavioural analysis.

------------------------------------------------------------------------

## Customer Segment

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

The segment evaluation rules are:

1.  High-Value Loyal --- Recency ≥3, Frequency ≥3 and Value ≥3
2.  Recent Developing --- Recency ≥3 and Frequency ≤2
3.  High-Value At Risk --- Recency ≤2, Frequency ≥3 and Value ≥3
4.  Low Engagement --- Recency ≤2 and Frequency ≤2
5.  Valuable Regular --- remaining customers with Value ≥3
6.  Core Customer --- remaining purchasers
7.  No Completed Purchase --- registered customers without completed
    purchase activity

------------------------------------------------------------------------

# 11. Segmentation Sort Columns

Sort fields are **CALCULATED COLUMNS** in:

**Target:** `DimCustomer → Segmentation`

They deliberately derive from underlying scores/rules rather than
referencing the label being sorted, avoiding circular dependencies.

------------------------------------------------------------------------

## Value Segment Sort

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

``` dax
Value Segment Sort =
IF (
    DimCustomer[Lifetime Orders] = 0,
    5,
    5 - DimCustomer[Value Score]
)
```

------------------------------------------------------------------------

## Frequency Segment Sort

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

``` dax
Frequency Segment Sort =
IF (
    DimCustomer[Lifetime Orders] = 0,
    5,
    5 - DimCustomer[Frequency Score]
)
```

------------------------------------------------------------------------

## Recency Segment Sort

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

``` dax
Recency Segment Sort =
IF (
    DimCustomer[Lifetime Orders] = 0,
    5,
    5 - DimCustomer[Recency Score]
)
```

------------------------------------------------------------------------

## Customer Segment Sort

**Object Type:** CALCULATED COLUMN\
**Target:** `DimCustomer → Segmentation`

``` dax
Customer Segment Sort =
SWITCH (
    TRUE (),
    DimCustomer[Lifetime Orders] = 0, 7,
    DimCustomer[Recency Score] >= 3
        && DimCustomer[Frequency Score] >= 3
        && DimCustomer[Value Score] >= 3, 1,
    DimCustomer[Recency Score] >= 3
        && DimCustomer[Frequency Score] <= 2, 3,
    DimCustomer[Recency Score] <= 2
        && DimCustomer[Frequency Score] >= 3
        && DimCustomer[Value Score] >= 3, 5,
    DimCustomer[Recency Score] <= 2
        && DimCustomer[Frequency Score] <= 2, 6,
    DimCustomer[Value Score] >= 3, 2,
    4
)
```

------------------------------------------------------------------------

# 12. Segmentation Share Measures

## Segment Revenue Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Segmentation`

Calculates a segment's revenue as a share of revenue across the intended
segment population.

------------------------------------------------------------------------

## Segment Customer Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Segmentation`

Calculates a segment's purchasing customers as a share of the intended
purchasing population.

------------------------------------------------------------------------

## Segment Profit Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Segmentation`

Calculates a segment's profit as a share of total profit across the
intended segment population.

------------------------------------------------------------------------

## Value Segment Customer Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Segmentation`

``` dax
Value Segment Customer Share % =
DIVIDE (
    [Purchasing Customers],
    CALCULATE (
        [Purchasing Customers],
        REMOVEFILTERS (
            DimCustomer[Customer Value Segment],
            DimCustomer[Value Segment Sort]
        )
    )
)
```

Both the visible segment and its hidden sort column are removed from
denominator context.

------------------------------------------------------------------------

## Value Segment Revenue Share %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Segmentation`

``` dax
Value Segment Revenue Share % =
DIVIDE (
    [Revenue],
    CALCULATE (
        [Revenue],
        REMOVEFILTERS (
            DimCustomer[Customer Value Segment],
            DimCustomer[Value Segment Sort]
        )
    )
)
```

The same principle is used by the general Customer Segment share
measures: both `Customer Segment` and `Customer Segment Sort` are
removed when calculating the denominator.

------------------------------------------------------------------------

# 13. Customer Trend Measures

Customer trends are **MEASURES**, not calculated columns.

**Target:** `_Measures → Customer Trends`

They compare current-period customer revenue with equivalent
previous-year activity.

The movement framework uses a ±5% material-change threshold.

------------------------------------------------------------------------

## Continuing Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Customers with purchasing activity in both the current period and
equivalent previous-year period.

------------------------------------------------------------------------

## Growing Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Continuing customers whose revenue increased by more than 5%.

------------------------------------------------------------------------

## Stable Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Continuing customers whose revenue change remains within ±5%.

------------------------------------------------------------------------

## Declining Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Continuing customers whose revenue decreased by more than 5%.

------------------------------------------------------------------------

## No Longer Purchasing Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Customers with previous-year completed purchasing activity but no
completed purchase in the current period.

This is deliberately **not labelled churn**.

------------------------------------------------------------------------

## Returning Existing Customers

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

``` dax
Returning Existing Customers =
VAR PeriodStart =
    MIN ( DimDate[Date] )
RETURN
    COUNTROWS (
        FILTER (
            VALUES ( DimCustomer[CustomerKey] ),
            VAR CurrentRevenue =
                CALCULATE ( [Revenue] )
            VAR PreviousRevenue =
                CALCULATE ( [Revenue PY] )
            VAR FirstPurchase =
                CALCULATE (
                    MAX ( DimCustomer[First Purchase Date] )
                )
            RETURN
                CurrentRevenue > 0
                    && ( PreviousRevenue = 0 || ISBLANK ( PreviousRevenue ) )
                    && NOT ISBLANK ( FirstPurchase )
                    && FirstPurchase < PeriodStart
        )
    )
```

This identifies previously acquired customers who purchase in the
current period after having no equivalent previous-year purchase.

------------------------------------------------------------------------

## Growing Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

``` dax
Growing Customer Rate % =
DIVIDE ( [Growing Customers], [Continuing Customers] )
```

------------------------------------------------------------------------

## Declining Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

``` dax
Declining Customer Rate % =
DIVIDE ( [Declining Customers], [Continuing Customers] )
```

------------------------------------------------------------------------

## Stable Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

``` dax
Stable Customer Rate % =
DIVIDE ( [Stable Customers], [Continuing Customers] )
```

------------------------------------------------------------------------

## No Longer Purchasing Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Uses the relevant previous-year purchasing population as its
denominator.

------------------------------------------------------------------------

## Continuing Customer Rate %

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Represents the proportion of the relevant previous-year purchasing
population that also purchased in the current period.

------------------------------------------------------------------------

## Growing Customer Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Revenue generated by customers classified as Growing in the evaluated
period.

------------------------------------------------------------------------

## Declining Customer Revenue

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

Revenue generated by customers classified as Declining in the evaluated
period.

------------------------------------------------------------------------

# 14. Customer Trend Reconciliation

The trend framework was validated using the following identities.

For current purchasing customers:

``` text
New Customers
+ Returning Existing Customers
+ Continuing Customers
= Purchasing Customers
```

For Continuing Customers:

``` text
Growing Customers
+ Stable Customers
+ Declining Customers
= Continuing Customers
```

For the previous-year purchasing population:

``` text
Continuing Customers
+ No Longer Purchasing Customers
= Purchasing Customers PY
```

For 2025:

  KPI                         Customers
  ------------------------- -----------
  Growing                         4,829
  Stable                            358
  Declining                       4,761
  Continuing                      9,948
  No Longer Purchasing            2,944
  Purchasing Customers PY        12,892

------------------------------------------------------------------------

# 15. Disconnected Helper Tables

## Customer Behaviour Type

**Object Type:** CALCULATED TABLE\
**Target:** Standalone / Disconnected

``` dax
Customer Behaviour Type =
DATATABLE (
    "Customer Behaviour", STRING,
    {
        { "Repeat Customer" },
        { "One-Time Customer" }
    }
)
```

------------------------------------------------------------------------

## Customer Behaviour Count

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Behaviour`

``` dax
Customer Behaviour Count =
SWITCH (
    SELECTEDVALUE (
        'Customer Behaviour Type'[Customer Behaviour]
    ),
    "Repeat Customer", [Repeat Customers],
    "One-Time Customer", [One-Time Customers]
)
```

------------------------------------------------------------------------

## Customer Composition Type

**Object Type:** CALCULATED TABLE\
**Target:** Standalone / Disconnected

``` dax
Customer Composition Type =
DATATABLE (
    "Composition Type", STRING,
    "Composition Sort", INTEGER,
    {
        { "New Customers", 1 },
        { "Returning Customers", 2 },
        { "Continuing Customers", 3 }
    }
)
```

------------------------------------------------------------------------

## Customer Composition Count

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

``` dax
Customer Composition Count =
SWITCH (
    SELECTEDVALUE (
        'Customer Composition Type'[Composition Type]
    ),
    "New Customers", [New Customers],
    "Returning Customers", [Returning Existing Customers],
    "Continuing Customers", [Continuing Customers]
)
```

------------------------------------------------------------------------

## Customer Movement Type

**Object Type:** CALCULATED TABLE\
**Target:** Standalone / Disconnected

``` dax
Customer Movement Type =
DATATABLE (
    "Movement Type", STRING,
    "Movement Sort", INTEGER,
    {
        { "Growing", 1 },
        { "Stable", 2 },
        { "Declining", 3 }
    }
)
```

------------------------------------------------------------------------

## Customer Movement Count

**Object Type:** MEASURE\
**Target:** `_Measures → Customer Trends`

``` dax
Customer Movement Count =
SWITCH (
    SELECTEDVALUE (
        'Customer Movement Type'[Movement Type]
    ),
    "Growing", [Growing Customers],
    "Stable", [Stable Customers],
    "Declining", [Declining Customers]
)
```

All three helper tables remain disconnected from the core star schema.

------------------------------------------------------------------------

# 16. DAX Design Principles

The semantic model follows several DAX design principles.

### Measures for Dynamic Analysis

Period-dependent customer classifications are measures so that they
respond to filter context.

### Calculated Columns for Lifetime Customer Attributes

First Purchase Date, lifetime values and static RFV segmentation are
customer-row attributes stored in `DimCustomer`.

### Calculated Tables for Presentation

Disconnected helper tables provide controlled visual categories without
altering the physical star schema.

### DIVIDE for Ratios

`DIVIDE()` is preferred for ratios to handle zero or blank denominators
safely.

### Explicit Filter Context

Share-of-total calculations remove both visible segment fields and their
sort columns when necessary.

### Reusable Base Measures

Higher-level calculations reuse measures such as Revenue, Orders, Profit
and Purchasing Customers rather than duplicating base aggregation logic.

### Reproducible Recency

Customer recency uses the fixed dataset endpoint of 31 December 2025
rather than the system date.

------------------------------------------------------------------------

# 17. Analytical Validation

DAX outputs were reconciled against SQL analytical results and
cross-checked within Power BI.

Validated all-time results include:

  KPI                                 Result
  ------------------------ -----------------
  Revenue                     £46,028,499.80
  Profit                     Approx. £19.63M
  Profit Margin                       42.66%
  Orders                             169,360
  Purchasing Customers                17,773
  Registered Customers                20,000
  Average Order Value                £271.78
  Average Customer Value      Approx. £2.59K
  Orders per Customer                   9.53
  Repeat Customer Rate                91.67%

Validated annual Revenue:

  Year                     Revenue
  ----------- --------------------
  2022               £9,432,133.84
  2023              £10,688,711.28
  2024              £12,108,867.86
  2025              £13,798,786.82
  **Total**     **£46,028,499.80**

------------------------------------------------------------------------

# 18. Interpretation Notes

Several calculation names require careful interpretation.

### First Purchase Date

Means first **observed completed purchase** in the available dataset,
not necessarily the customer's true historical first purchase.

### Repeat Customer Rate

Measures repeat purchasing within the evaluated context. It is not a
formal retention metric.

### Customer Segmentation

Represents static lifetime segmentation across the observed 2022--2025
history.

### High-Value At Risk

Represents an RFV classification based on weaker recency combined with
strong frequency/value. It is not a churn prediction.

### Declining Customer

Represents a continuing customer whose revenue fell by more than 5%
compared with the equivalent previous-year period.

### No Longer Purchasing

Represents a customer with previous-year purchasing activity and no
completed current-period purchase. It does not establish permanent
churn.

------------------------------------------------------------------------

# 19. Outcome

The DAX layer extends the SQL star schema into a reusable semantic model
capable of analysing:

-   financial performance;
-   order volume;
-   customer value;
-   repeat purchasing;
-   customer acquisition;
-   previous-year performance;
-   RFV segmentation;
-   customer composition;
-   customer movement.

The separation between **measures**, **calculated columns** and
**calculated tables** ensures that each analytical concept is
implemented at the appropriate semantic-model level.

Where this document describes methodology rather than reproducing an
exact expression, the working PBIX model remains the authoritative
implementation.
