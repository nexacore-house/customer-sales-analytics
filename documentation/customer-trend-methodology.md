# Customer & Sales Analytics --- Customer Trend Methodology

## 1. Purpose

This document defines the methodology used to analyse customer
acquisition, continuity and year-over-year purchasing movement in the
Customer & Sales Analytics project.

The trend framework is designed to answer questions such as:

-   Which customers are new?
-   Which previously acquired customers have returned after a gap?
-   Which customers continue to purchase year over year?
-   Which continuing customers are growing, stable or declining?
-   Which previous-year customers recorded no completed purchase in the
    current year?

The methodology is descriptive and avoids treating temporary inactivity
as confirmed churn.

------------------------------------------------------------------------

## 2. Why Customer Movement Is Dynamic

Customer movement depends on the reporting period being evaluated.

A customer may be Growing in one year and Declining in another.

For this reason, customer trend classifications are implemented using
**Power BI measures**, rather than permanent calculated columns.

This allows classifications to respond dynamically to:

-   Year
-   Customer Type
-   Customer Value Segment
-   Customer Segment
-   other applicable report filters

------------------------------------------------------------------------

## 3. Reporting Period

The customer trend page focuses on comparative years:

-   2023
-   2024
-   2025

The dataset begins in 2022.

Because there is no 2021 transaction history, 2022 cannot support a
complete previous-year customer movement comparison.

For this reason, 2022 is not used as a selectable comparative year on
the Customer Trends page.

------------------------------------------------------------------------

## 4. First Observed Purchase

Customer acquisition is based on:

**First Purchase Date**

This represents the customer's first **observed completed purchase**
within the available dataset.

The dataset covers:

**1 January 2022 to 31 December 2025**

Therefore, the model cannot establish whether a customer had purchasing
activity before 2022.

Throughout the project:

> New Customer means first observed completed purchase within the
> available analytical history.

This caveat is important when interpreting 2022.

------------------------------------------------------------------------

## 5. New Customers

A **New Customer** is a purchasing customer whose First Purchase Date
falls within the selected reporting period.

Conceptually:

``` text
Current-period completed purchase > 0
AND
First Purchase Date falls within current reporting period
```

This separates current-period acquisition from previously acquired
customer activity.

------------------------------------------------------------------------

## 6. Existing Customers

An **Existing Customer** is a current purchasing customer whose first
observed completed purchase occurred before the selected reporting
period.

The relationship is:

``` text
Existing Customers
=
Purchasing Customers - New Customers
```

Existing is a broad acquisition-status category.

It includes customers who may be:

-   Continuing from the previous year;
-   Returning after a gap.

------------------------------------------------------------------------

## 7. Continuing Customers

A **Continuing Customer** has completed purchasing activity in both:

-   the current reporting period; and
-   the equivalent previous-year period.

Conceptually:

``` text
Current Revenue > 0
AND
Previous-Year Revenue > 0
```

Continuing Customers form the population used for Growing, Stable and
Declining movement classifications.

------------------------------------------------------------------------

## 8. Returning Existing Customers

A **Returning Existing Customer**:

-   purchases in the current period;
-   has no completed purchase in the equivalent previous-year period;
    and
-   has a First Purchase Date before the start of the current reporting
    period.

Conceptually:

``` text
Current Revenue > 0
AND
Previous-Year Revenue = 0 or blank
AND
First Purchase Date < Current Period Start
```

This prevents returning customers from being incorrectly classified as
New Customers.

------------------------------------------------------------------------

## 9. Current Customer Composition

The three current-period customer populations reconcile as:

``` text
New Customers
+ Returning Existing Customers
+ Continuing Customers
= Purchasing Customers
```

These populations are mutually exclusive within the trend framework.

This provides the basis for the **Current Customer Composition** visual
on the Customer Trends page.

------------------------------------------------------------------------

## 10. Why Revenue Is Used for Customer Movement

Customer movement is evaluated using change in customer revenue
contribution.

Revenue was selected because it captures the commercial value of a
customer's purchasing activity rather than only whether the number of
orders increased or decreased.

A customer could:

-   place fewer but higher-value orders;
-   place more but lower-value orders;
-   purchase a different product mix.

Using revenue provides a consistent commercial basis for the movement
framework.

It does not explain why the change occurred.

------------------------------------------------------------------------

## 11. Customer Revenue Change

For each Continuing Customer, current-period revenue is compared with
equivalent previous-year revenue.

Conceptually:

``` text
Customer Revenue Change %
=
(Current Revenue - Previous-Year Revenue)
/
Previous-Year Revenue
```

Only customers with activity in both periods enter the Growing, Stable
and Declining classification.

------------------------------------------------------------------------

## 12. Materiality Threshold

A **±5% threshold** is applied to customer revenue movement.

The framework is:

``` text
Revenue Change > +5%  → Growing
Revenue Change between -5% and +5% → Stable
Revenue Change < -5% → Declining
```

The threshold is an analytical rule used by this project.

It is not presented as a universal industry standard.

------------------------------------------------------------------------

## 13. Why ±5% Was Used

Without a tolerance range, very small differences could classify a
customer as Growing or Declining.

For example, a customer whose revenue changed by only 0.5% would
technically have moved, even though the commercial difference may be
immaterial for this analysis.

The ±5% band creates a practical Stable category and separates
relatively small movement from more material changes.

In a production environment, the threshold should be reviewed with
business stakeholders and could differ by:

-   industry;
-   customer type;
-   revenue scale;
-   product mix;
-   strategic objectives.

------------------------------------------------------------------------

## 14. Growing Customers

A **Growing Customer** is a Continuing Customer whose revenue increased
by more than 5% relative to the equivalent previous-year period.

Conceptually:

``` text
Current Revenue > 0
AND
Previous-Year Revenue > 0
AND
Revenue Change % > 5%
```

------------------------------------------------------------------------

## 15. Stable Customers

A **Stable Customer** is a Continuing Customer whose revenue movement
remains within the ±5% tolerance band.

Conceptually:

``` text
-5% ≤ Revenue Change % ≤ +5%
```

------------------------------------------------------------------------

## 16. Declining Customers

A **Declining Customer** is a Continuing Customer whose revenue
decreased by more than 5% relative to the equivalent previous-year
period.

Conceptually:

``` text
Current Revenue > 0
AND
Previous-Year Revenue > 0
AND
Revenue Change % < -5%
```

Declining describes commercial movement only.

It does not identify the cause of the decline.

------------------------------------------------------------------------

## 17. Continuing Customer Reconciliation

The Continuing Customer population must reconcile as:

``` text
Growing Customers
+ Stable Customers
+ Declining Customers
= Continuing Customers
```

This identity was included in the final QA process.

------------------------------------------------------------------------

## 18. No Longer Purchasing Customers

A **No Longer Purchasing Customer**:

-   recorded completed purchasing activity in the equivalent
    previous-year period; and
-   recorded no completed purchase in the current reporting period.

Conceptually:

``` text
Previous-Year Revenue > 0
AND
Current Revenue = 0 or blank
```

This population is analysed separately from Continuing Customers.

------------------------------------------------------------------------

## 19. Why the Project Does Not Use "Churn"

The project deliberately avoids calling No Longer Purchasing customers
**Churned Customers**.

The dataset shows absence of completed purchasing activity during the
evaluated current period.

It does not prove that:

-   the customer permanently left the business;
-   the customer will never purchase again;
-   the customer formally cancelled a relationship;
-   inactivity resulted from dissatisfaction.

Therefore:

> No Longer Purchasing is an observed behavioural status, not confirmed
> churn.

A production churn definition would require a business-approved
inactivity rule and potentially additional customer relationship data.

------------------------------------------------------------------------

## 20. Previous-Year Customer Reconciliation

The previous-year purchasing population reconciles as:

``` text
Continuing Customers
+ No Longer Purchasing Customers
= Purchasing Customers PY
```

This provides an important validation check for the movement framework.

------------------------------------------------------------------------

## 21. New vs Returning Customers

New and Returning customers can both appear as current-period purchasers
without equivalent previous-year activity.

The distinction is based on First Purchase Date.

### New

``` text
First Purchase Date is within current period
```

### Returning Existing

``` text
First Purchase Date is before current period
AND
no equivalent previous-year purchase
AND
current purchase exists
```

This distinction prevents returning customers from inflating acquisition
counts.

------------------------------------------------------------------------

## 22. New vs Existing Customer Revenue

Validated annual revenue composition:

  Year     New Customer Revenue   Existing Customer Revenue
  ------ ---------------------- ---------------------------
  2022            £9,432,133.84                       £0.00
  2023            £2,742,346.77               £7,946,364.51
  2024            £2,488,661.40               £9,620,206.46
  2025            £2,364,561.06              £11,434,225.76

For each year:

``` text
New Customer Revenue
+ Existing Customer Revenue
= Revenue
```

------------------------------------------------------------------------

## 23. Interpretation of 2022

All observed 2022 purchasing customers appear as New Customers because
the analytical history begins in 2022.

Therefore:

``` text
2022 Existing Customer Revenue = £0
```

This does not mean that every customer was necessarily new to the
real-world business in 2022.

It means that 2022 is the first observable transaction year in the
dataset.

------------------------------------------------------------------------

## 24. 2025 Current Customer Composition

For the default 2025 Customer Trends view, the report identifies
approximately:

-   **2.64K New Customers**
-   **1.17K Returning Existing Customers**
-   **9.95K Continuing Customers**

The exact New Customer cohort count validated from the analytical model
is:

**2,641**

Continuing Customers:

**9,948**

Returning Existing Customers are calculated dynamically in the Power BI
model and are displayed at approximately **1.17K** in the report.

Together these populations reconcile to the 2025 purchasing-customer
population.

------------------------------------------------------------------------

## 25. 2025 Continuing Customer Movement

Validated 2025 movement:

  Movement           Customers
  ---------------- -----------
  Growing                4,829
  Stable                   358
  Declining              4,761
  **Continuing**     **9,948**

Reconciliation:

``` text
4,829 + 358 + 4,761 = 9,948
```

------------------------------------------------------------------------

## 26. 2025 Movement Rates

Among Continuing Customers:

  Movement      Approx. Rate
  ----------- --------------
  Growing             48.54%
  Stable               3.60%
  Declining           47.86%

The movement distribution is highly polarised.

Almost half of Continuing Customers materially increased revenue
contribution, while a similar proportion materially decreased it.

Only a small proportion remained inside the ±5% Stable band.

------------------------------------------------------------------------

## 27. Interpretation of Continuing Customer Movement

The 2025 movement results demonstrate why aggregate revenue alone can
hide important customer-level behaviour.

The business can experience overall revenue growth while individual
customers move in substantially different directions.

The framework therefore complements high-level sales KPIs with
customer-level commercial movement.

The model identifies **what changed**, not **why it changed**.

------------------------------------------------------------------------

## 28. 2025 No Longer Purchasing Population

Validated results:

-   Previous-year Purchasing Customers: **12,892**
-   Continuing Customers: **9,948**
-   No Longer Purchasing Customers: **2,944**

Reconciliation:

``` text
9,948 + 2,944 = 12,892
```

------------------------------------------------------------------------

## 29. No Longer Purchasing Rate

The 2,944 customers represent approximately:

``` text
2,944 / 12,892 ≈ 22.8%
```

of the relevant prior-year purchasing population.

Therefore, approximately **23% of customers who purchased in 2024
recorded no completed purchase in 2025**.

This remains an inactivity observation rather than a churn claim.

------------------------------------------------------------------------

## 30. Customer Movement by Segment

The Customer Trends report also analyses movement against static
Customer Segment classifications.

Validated 2025 results include:

  ------------------------------------------------------------------------
  Customer            Growing         Stable      Declining      No Longer
  Segment                                                       Purchasing
  ------------ -------------- -------------- -------------- --------------
  Core                    239             15            253            122
  Customer                                                  

  High-Value              494             48          1,028            712
  At Risk                                                   

  High-Value            2,428            198          2,021              0
  Loyal                                                     

  Low                     757             46            849          2,110
  Engagement                                                

  Recent                  911             51            610              0
  Developing                                                

  **Total**         **4,829**        **358**      **4,761**      **2,944**
  ------------------------------------------------------------------------

Blank report values for No Longer Purchasing in some segments are
represented as zero in this documentation table for reconciliation
clarity.

------------------------------------------------------------------------

## 31. Static Segment vs Dynamic Movement

Customer Segment and Customer Movement answer different questions.

### Static Segment

Based on complete observed 2022--2025 RFV history.

Examples:

-   High-Value Loyal
-   High-Value At Risk
-   Recent Developing
-   Low Engagement

### Dynamic Movement

Based on current versus previous-year revenue.

Examples:

-   Growing
-   Stable
-   Declining
-   No Longer Purchasing

A High-Value Loyal customer can therefore be Declining in 2025.

Likewise, a Low Engagement customer can be Growing.

This combination makes the model more analytically useful than treating
customer status as a single permanent classification.

------------------------------------------------------------------------

## 32. Customer Trends Report Page

The Customer Trends page contains four principal analytical views.

### Current Customer Composition

Shows:

-   New Customers
-   Returning Customers
-   Continuing Customers

### Continuing Customer Movement

Shows:

-   Growing
-   Stable
-   Declining

as shares of Continuing Customers.

### Monthly Revenue vs Previous Year

Compares:

-   Revenue
-   Revenue PY

across months.

### Customer Movement by Segment

Cross-analyses static Customer Segment with dynamic customer movement.

------------------------------------------------------------------------

## 33. Year Selection

The Customer Trends page uses a single-select Year slicer.

The default reporting year is:

**2025**

Comparative trend analysis is intended for:

-   2023
-   2024
-   2025

2022 is excluded from comparative selection because no 2021 transaction
history is available.

------------------------------------------------------------------------

## 34. Filter Context

Trend measures are designed to respond to relevant report filters.

Examples include:

-   Customer Type
-   Customer Value Segment
-   Customer Segment
-   selected Year

The movement classification is therefore recalculated for the population
represented by the current analytical context.

This is one reason movement classifications remain measures rather than
permanent customer columns.

------------------------------------------------------------------------

## 35. Validation Rules

The trend framework was included in the final Power BI QA.

Key reconciliation rules included:

### Current Population

``` text
New
+ Returning Existing
+ Continuing
= Purchasing Customers
```

### Continuing Population

``` text
Growing
+ Stable
+ Declining
= Continuing
```

### Previous-Year Population

``` text
Continuing
+ No Longer Purchasing
= Purchasing Customers PY
```

### Revenue

``` text
New Customer Revenue
+ Existing Customer Revenue
= Revenue
```

These checks were validated before the final screenshots were produced.

------------------------------------------------------------------------

## 36. Analytical Limitations

The customer trend methodology has several intentional boundaries.

### Limited Historical Window

Transaction history begins in 2022.

First Purchase therefore means first observed purchase within the
dataset.

### No Formal Churn Definition

No Longer Purchasing does not establish permanent customer loss.

### Revenue-Based Movement

Growing and Declining classifications are based on revenue contribution.

They do not directly measure:

-   order-frequency change;
-   unit-volume change;
-   profitability change;
-   satisfaction;
-   engagement outside purchases.

### Fixed Materiality Threshold

The ±5% threshold is an analytical project rule rather than a universal
standard.

### Descriptive Rather Than Causal

The model identifies patterns and movement but does not establish the
causes of customer behaviour.

------------------------------------------------------------------------

## 37. Business Use

The framework can support business questions such as:

-   Which customer segments contain the largest declining populations?
-   Which valuable customers are reducing annual purchasing activity?
-   How much of current purchasing activity comes from new versus
    previously acquired customers?
-   Which customers have returned after a period without purchasing?
-   Which previous-year customers recorded no purchase this year?
-   Are high-value customer populations growing or weakening?
-   How does customer movement differ by customer type or value segment?

In a production environment, these insights could support deeper
investigation and targeted customer strategies.

------------------------------------------------------------------------

## 38. Outcome

The customer trend framework extends the project beyond traditional
sales reporting by distinguishing:

-   acquisition;
-   existing-customer contribution;
-   returning customers;
-   customer continuity;
-   material growth;
-   stability;
-   decline;
-   purchasing inactivity.

The methodology deliberately separates **static customer segmentation**
from **dynamic year-over-year movement** and uses reconciliation rules
to ensure that customer populations remain analytically consistent.

This provides a stronger view of how customer behaviour changes over
time while avoiding unsupported claims about retention, churn or
causation.
