Customer & Sales Analytics — Dimensional Model
1. Purpose

This document describes the dimensional model developed for the Customer & Sales Analytics project.

The model was designed to support:

sales and profitability analysis;
customer behaviour analysis;
customer segmentation;
customer acquisition analysis;
product and category analysis;
sales-channel analysis;
year-over-year customer movement;
efficient Power BI filtering and aggregation.

The analytical model follows a star schema design with a central sales fact table connected directly to four dimensions.

2. Modelling Approach

The analytical layer was intentionally separated from the raw transactional source.

The final Power BI model contains:

FactSales
DimCustomer
DimProduct
DimDate
DimChannel
_Measures
disconnected presentation/helper tables

The core model can be represented as:

                    DimCustomer
                         |
                         |
DimProduct --------- FactSales --------- DimDate
                         |
                         |
                    DimChannel

Each dimension has a one-to-many relationship with FactSales.

The model avoids unnecessary dimension-to-dimension relationships and bidirectional filtering.

3. FactSales
Purpose

FactSales is the central transactional fact table.

It contains the completed commercial transactions used by the primary sales and customer analytics.

Grain

The grain of FactSales is:

One row per completed order line — one product purchased by one customer as part of one order.

This definition is important because a single order can contain multiple products and therefore multiple rows in the fact table.

OrderID must therefore be counted distinctly when calculating the number of orders.

Transaction Scope

Only orders with:

OrderStatus = Completed

are loaded into FactSales.

Returned and Cancelled transactions remain in the raw data layer but are excluded from primary realised-sales calculations.

Important Fields

FactSales contains analytical fields including:

Field	Purpose
DateKey	Relationship to DimDate
CustomerKey	Relationship to DimCustomer
ProductKey	Relationship to DimProduct
ChannelKey	Relationship to DimChannel
OrderID	Degenerate order identifier
Quantity	Units sold
UnitPrice	Transaction selling price
UnitCost	Transaction unit cost
DiscountPercent	Applied discount
GrossRevenue	Revenue before discount
NetRevenue	Revenue after discount
TotalCost	Transaction cost
Profit	Net revenue less total cost
4. Financial Logic

Financial calculations were prepared consistently at the analytical fact-table level.

Conceptually:

Gross Revenue
= Quantity × Unit Price
Net Revenue
= Gross Revenue after applicable discount
Total Cost
= Quantity × Unit Cost
Profit
= Net Revenue - Total Cost

Power BI measures aggregate these analytical fields rather than reconstructing transaction arithmetic repeatedly within report visuals.

This keeps the semantic layer easier to understand and validate.

5. DimCustomer
Purpose

DimCustomer contains one row per unique customer.

Validated customer population:

20,000 registered customers

Of these:

17,773 customers

recorded at least one completed purchase during the observed period.

Customers without completed purchasing activity remain in the dimension because they are valid registered customers.

Key

CustomerKey is the analytical customer key used to connect the dimension to FactSales.

Customer Attributes

The dimension contains descriptive attributes such as:

Customer ID
Customer Type
Registration Date
City
Region
Country

These attributes support customer filtering and analysis.

6. Customer Analytical Attributes

Several customer-level analytical attributes are implemented as Power BI calculated columns in DimCustomer.

These include:

First Purchase Date
Last Purchase Date
First Purchase Year
First Purchase Month
Lifetime Orders
Lifetime Revenue
Lifetime Profit
Lifetime Purchase Behaviour
Active Purchasing Months
Purchase Span Days
Days Since Last Purchase
Value Score
Customer Value Segment
Frequency Score
Frequency Segment
Recency Score
Recency Segment
Customer Behaviour Score
Customer Segment
Value Segment Sort
Frequency Segment Sort
Recency Segment Sort
Customer Segment Sort

These attributes provide the customer-level foundation for RFV segmentation and lifetime behavioural analysis.

7. Static vs Dynamic Customer Logic

An important modelling distinction is made between static customer attributes and dynamic report measures.

Static Customer Attributes

Customer segmentation is based on the complete observed history from:

1 January 2022 to 31 December 2025

Examples include:

Lifetime Revenue
Lifetime Orders
Days Since Last Purchase
Value Segment
Frequency Segment
Recency Segment
Customer Segment

These are stored as calculated columns in DimCustomer.

They describe the customer's position across the complete observed dataset.

Dynamic Customer Measures

Measures such as:

New Customers
Existing Customers
Repeat Customers
Continuing Customers
Returning Existing Customers
Growing Customers
Stable Customers
Declining Customers
No Longer Purchasing Customers

are evaluated dynamically according to report filter context.

This distinction prevents static lifetime segmentation from being confused with period-specific customer movement.

8. DimProduct
Purpose

DimProduct contains one row per product.

Validated product population:

500 products

Product Attributes

The dimension contains descriptive attributes including:

Product ID
Product Name
Category
Unit Cost
List Price

Product attributes allow the report to analyse sales and customer behaviour by product and category.

9. Category Flattening

The raw source contains separate Product and Category structures.

For the analytical star schema, Category was flattened into DimProduct.

This avoids introducing an unnecessary snowflake relationship such as:

FactSales
    |
DimProduct
    |
DimCategory

Instead, the analytical model uses:

FactSales
    |
DimProduct

with Category available directly as a product attribute.

This simplifies:

filtering;
DAX behaviour;
report development;
model navigation;
relationship management.
10. DimDate
Purpose

DimDate provides the project's standard calendar dimension.

The dataset covers:

1 January 2022 to 31 December 2025

Validated date rows:

1,461

Date Attributes

The dimension supports fields such as:

Date
DateKey
Year
Quarter
Month Number
Month Name
Year-Month

These attributes support report filtering, chronological sorting and time-intelligence calculations.

Power BI Configuration

DimDate is marked as the model's official Date Table.

Power BI Auto Date/Time is disabled.

This prevents hidden automatic date tables from introducing unnecessary model structures and ensures that time intelligence uses the controlled calendar dimension.

11. DimChannel
Purpose

DimChannel contains the available customer sales channels.

The four channels are:

Online Store
Marketplace
Retail Stores
Mobile App
Key

ChannelKey connects the dimension directly to FactSales.

The dimension supports analysis of revenue, profit and customer behaviour by sales channel.

12. OrderID as a Degenerate Dimension

OrderID remains directly within FactSales.

A separate DimOrder table was not created because the project does not require a substantial set of descriptive order-level attributes.

This makes OrderID a degenerate dimension.

It is used primarily for calculations such as:

Distinct Completed Orders

while avoiding an unnecessary dimension table.

13. Relationships

The final semantic model contains four primary relationships.

From	To	Cardinality	Direction	Active
DimCustomer[CustomerKey]	FactSales[CustomerKey]	1:*	Single	Yes
DimProduct[ProductKey]	FactSales[ProductKey]	1:*	Single	Yes
DimChannel[ChannelKey]	FactSales[ChannelKey]	1:*	Single	Yes
DimDate[DateKey]	FactSales[DateKey]	1:*	Single	Yes

All filters flow:

Dimension → Fact

No bidirectional relationships are required in the core model.

14. Why Single-Direction Relationships Were Used

Single-direction relationships maintain predictable filter propagation.

For example:

DimCustomer
      ↓
   FactSales

allows a Region, Customer Type or Customer Segment selection to filter sales transactions without requiring FactSales to filter the customer dimension automatically.

This reduces:

ambiguous filter paths;
unexpected DAX behaviour;
unnecessary model complexity.
15. No Direct Dimension Relationships

The analytical model intentionally avoids direct relationships such as:

DimCustomer → DimProduct

or:

DimChannel → DimCustomer

Business interactions between dimensions are analysed through FactSales.

For example, to determine which categories are purchased by Premium Value customers:

DimCustomer
      ↓
   FactSales
      ↑
DimProduct

This preserves the star-schema structure.

16. Analytical Keys

The analytical tables use controlled keys to support relationships.

These include:

CustomerKey
ProductKey
DateKey
ChannelKey

These keys separate analytical relationships from descriptive business fields.

The design avoids relying on names or other descriptive attributes as relationship keys.

17. _Measures Table

A dedicated _Measures table is used to organise Power BI measures.

It does not participate in model relationships.

Measures are grouped into logical display folders including areas such as:

Sales
Volume
Averages
Customer Behaviour
Customer Growth
Time Intelligence
Customer Segmentation
Customer Trends

This improves semantic-model navigation and keeps analytical logic separate from physical data columns.

18. Disconnected Helper Tables

Three small disconnected calculated tables support report presentation:

Customer Behaviour Type
Customer Composition Type
Customer Movement Type

These tables have no relationships to the star schema.

They provide controlled categories for visuals whose values are generated by measures.

For example:

Customer Movement Type
-----------------------
Growing
Stable
Declining

A measure then returns the corresponding dynamic customer count.

This pattern allows several independently calculated measures to be displayed as categories within a single visual without changing the underlying star schema.

19. Why Helper Tables Remain Disconnected

Connecting the helper tables to DimCustomer or FactSales would incorrectly imply that their labels are physical attributes of individual transactions or customers.

They are instead presentation structures.

Keeping them disconnected ensures that:

they do not alter core filter propagation;
they do not create ambiguous relationships;
dynamic measures remain responsible for analytical classification.
20. Customer Segmentation Modelling

Customer segmentation uses an RFV-style framework:

Recency
Frequency
Value
Value

Based on Lifetime Revenue.

Frequency

Based on Lifetime Orders.

Recency

Based on Days Since Last Purchase.

Purchasing customers are assigned quartile scores from 1 to 4.

Higher scores represent stronger performance.

For Recency, fewer days since the last purchase produces the stronger score.

The segmentation is calculated across the complete observed 2022–2025 history.

21. Fixed Recency Endpoint

Recency is calculated against:

31 December 2025

rather than TODAY().

This is intentional.

Using TODAY() would cause the segmentation to change simply because the report was opened at a later date, despite the underlying transactional dataset ending in 2025.

The fixed endpoint makes the portfolio analysis:

reproducible;
auditable;
consistent with the available data period.
22. Customer Trend Modelling

Customer movement is not stored as a permanent customer classification.

Instead, trend classifications are calculated dynamically using measures.

The framework compares customer revenue between the current reporting period and the equivalent previous-year period.

Continuing customers are classified as:

Growing
Stable
Declining

using a ±5% materiality threshold.

Customers who purchased in the previous year but not in the current year are classified separately as:

No Longer Purchasing

Customers returning after a gap are classified as:

Returning Existing Customers

This dynamic approach allows movement to change correctly when the reporting period changes.

23. Segmentation vs Customer Movement

The model deliberately separates two analytical concepts.

Segmentation

Answers:

What type of customer is this across the complete observed history?

Examples:

Premium Value
High-Value Loyal
High-Value At Risk
Low Engagement
Customer Movement

Answers:

How has this customer's purchasing activity changed between reporting periods?

Examples:

Growing
Stable
Declining
No Longer Purchasing

A customer can therefore have a static segment such as:

High-Value Loyal

while dynamically being classified as:

Declining

for a selected reporting year.

This combination provides a more useful analytical view than treating customer status as a single attribute.

24. Filter Context Design

The star schema allows report filters to propagate predictably through the fact table.

Examples include:

Year
→ DimDate
→ FactSales
Customer Segment
→ DimCustomer
→ FactSales
Category
→ DimProduct
→ FactSales
Sales Channel
→ DimChannel
→ FactSales

This supports cross-analysis such as:

Premium Value revenue by category;
customer movement by segment;
channel performance by year;
customer behaviour by region.
25. Segmentation Share Measures and Sort Context

Customer segment labels use dedicated sort columns to enforce meaningful business ordering.

For example:

Premium Value
High Value
Medium Value
Low Value

rather than alphabetical ordering.

During development, Power BI's sort-column behaviour introduced an important filter-context consideration.

When a label is sorted by another column, both the visible label and hidden sort field can participate in grouping context.

Therefore, share-of-total measures explicitly remove filters from both:

the segment label;
its corresponding sort column.

This ensures that denominator calculations represent the complete intended customer population.

26. Model Validation

The final model was validated before report completion.

Validation included:

relationship cardinality;
relationship direction;
orphan-key checks;
customer counts;
product counts;
date coverage;
completed order counts;
annual revenue reconciliation;
customer segmentation reconciliation;
new versus existing customer reconciliation;
customer movement reconciliation.

Validated core totals include:

KPI	Result
Revenue	£46,028,499.80
Profit	Approx. £19.63M
Profit Margin	42.66%
Completed Orders	169,360
Purchasing Customers	17,773
Registered Customers	20,000

These results reconcile between the analytical SQL layer and Power BI.

27. Model Design Principles

The following principles guided the final model.

Clear Fact Grain

The fact-table grain is explicitly defined before measure development.

Star Schema First

Dimensions connect directly to the central fact table.

Single-Direction Filtering

Core relationships use dimension-to-fact filtering.

Minimal Snowflaking

Category is flattened into DimProduct.

Controlled Date Intelligence

A dedicated DimDate table is used and Auto Date/Time is disabled.

Separate Static and Dynamic Logic

Lifetime segmentation is stored at customer level while period movement remains measure-driven.

Dedicated Measures Layer

Business calculations are organised in _Measures.

Disconnected Presentation Tables

Helper categories are separated from the physical analytical model.

Reproducible Recency

The recency endpoint matches the end of the available dataset.

Validation Before Visualisation

Key totals and customer classifications were reconciled before final report design.

28. Power BI Model

The final Power BI model follows the star-schema structure described above.

The model screenshot provides visual evidence of:

the central FactSales table;
four directly connected dimensions;
one-to-many relationships;
disconnected helper tables;
the dedicated _Measures table.
29. Data Flow

The project follows the analytical flow:

Raw CSV Files
      ↓
SQL Raw Layer
      ↓
Data Quality Validation
      ↓
SQL Analytical Layer
      ↓
Star Schema
      ↓
Power BI Semantic Model
      ↓
DAX Measures & Customer Analytics
      ↓
Interactive Power BI Report
      ↓
Business Insights

This separation ensures that raw data, transformation logic, analytical modelling and reporting responsibilities remain clearly defined.

30. Model Outcome

The final dimensional model provides a scalable analytical foundation for the Customer & Sales Analytics report.

It supports analysis across:

customers;
products;
categories;
channels;
geography;
dates;
customer segments;
customer purchasing behaviour;
year-over-year customer movement.

The model demonstrates practical application of:

dimensional modelling;
star-schema design;
SQL analytical preparation;
Power BI semantic modelling;
DAX;
filter-context management;
customer analytics.

The result is a model designed not only to report sales totals, but to support deeper analysis of who generates value, how customers behave, what they purchase and how their activity changes over time.
