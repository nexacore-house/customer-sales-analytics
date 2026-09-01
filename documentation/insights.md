# Customer & Sales Analytics — Key Insights

## 1. Purpose

This document summarises the principal business insights identified through the Customer & Sales Analytics project.

The findings are based on validated SQL outputs and Power BI analysis covering completed transactions between:

**1 January 2022 and 31 December 2025**

The purpose is to demonstrate how the analytical model can translate transactional data into commercially relevant customer insights.

The findings are descriptive.

Where the available data shows an association or behavioural pattern, the analysis does not claim causation unless the data supports such a conclusion.

---

# 2. Executive Summary

The analysis identified six principal findings:

1. Revenue is highly concentrated among Premium Value customers.
2. Existing customers increasingly account for the majority of annual revenue.
3. Electronics is the dominant product category by revenue.
4. Online Store is the largest sales channel by revenue and profit.
5. Continuing customers showed highly polarised revenue movement in 2025.
6. A material proportion of 2024 purchasing customers recorded no completed purchase in 2025.

Together, these findings demonstrate that overall sales growth alone does not provide a complete view of customer performance.

Customer value concentration, acquisition mix, purchasing continuity and customer-level movement provide additional context for commercial decision-making.

---

# 3. Insight 1 — Revenue Is Highly Concentrated Among Premium Value Customers

The customer-value segmentation divides the 17,773 purchasing customers into approximately equal quartiles based on Lifetime Revenue.

Validated customer populations:

| Value Segment | Customers |
|---|---:|
| Premium Value | 4,443 |
| High Value | 4,443 |
| Medium Value | 4,443 |
| Low Value | 4,444 |
| **Total** | **17,773** |

Despite representing approximately one-quarter of purchasing customers, Premium Value customers generated approximately:

**£29.30M**

of the total:

**£46.03M**

in revenue.

This represents approximately:

**63.7% of total revenue.**

By comparison:

| Value Segment | Approx. Revenue | Approx. Revenue Share |
|---|---:|---:|
| Premium Value | £29.30M | 63.7% |
| High Value | £10.13M | 22.0% |
| Medium Value | £4.91M | 10.7% |
| Low Value | £1.68M | 3.6% |

## Business Interpretation

The customer base shows substantial revenue concentration.

A relatively small proportion of purchasing customers contributes the majority of realised revenue.

This makes the behaviour of the highest-value customer population commercially significant.

In a production environment, further analysis could investigate:

- product preferences of Premium Value customers;
- channel preferences;
- purchasing frequency;
- declining activity among high-value customers;
- profitability within the Premium Value population.

The analysis demonstrates concentration but does not establish why these customers generate higher revenue.

---

# 4. Insight 2 — Existing Customers Increasingly Drive Annual Revenue

New versus Existing Customer Revenue shows a clear change in annual revenue composition.

Validated results:

| Year | New Customer Revenue | Existing Customer Revenue |
|---|---:|---:|
| 2022 | £9,432,133.84 | £0.00 |
| 2023 | £2,742,346.77 | £7,946,364.51 |
| 2024 | £2,488,661.40 | £9,620,206.46 |
| 2025 | £2,364,561.06 | £11,434,225.76 |

Existing Customer Revenue increased from approximately:

**£7.95M in 2023**

to:

**£11.43M in 2025**

while New Customer Revenue remained within a narrower range of approximately:

**£2.4M–£2.7M per year**

between 2023 and 2025.

## Business Interpretation

The growth in annual revenue increasingly reflects purchasing activity from customers acquired in earlier periods.

This suggests that understanding the existing customer base is important when evaluating overall commercial performance.

The result also demonstrates why customer analytics should not focus exclusively on acquisition.

However, this analysis does not establish formal customer retention because Existing Customer Revenue can include different forms of previously acquired customer activity.

---

# 5. Insight 3 — Electronics Is the Dominant Revenue Category

Validated category revenue includes:

| Category | Revenue |
|---|---:|
| Electronics | £17,926,368.28 |
| Smart Home | £7,202,862.19 |
| Home & Kitchen | £5,773,739.76 |
| Sports & Fitness | £5,767,872.46 |
| Travel & Lifestyle | £3,031,331.43 |
| Health & Personal Care | £2,563,255.86 |
| Office & Stationery | £2,004,080.61 |
| Accessories | £1,758,989.21 |

Electronics generated approximately:

**£17.93M**

from total revenue of:

**£46.03M**

representing roughly:

**39% of total revenue.**

## Business Interpretation

Electronics is the largest commercial category in the observed dataset by a substantial margin.

This creates both opportunity and concentration considerations.

In a production environment, further investigation could examine:

- Electronics profitability;
- customer segments purchasing Electronics;
- channel dependence;
- product-level concentration within the category;
- year-over-year category performance.

The current analysis establishes revenue concentration by category but does not determine whether that concentration represents commercial risk.

---

# 6. Insight 4 — Online Store Is the Largest Sales Channel

Channel analysis shows that the:

**Online Store**

is the largest sales channel by both:

- Revenue
- Profit

across the observed dataset.

The remaining channels are:

- Mobile App
- Retail Stores
- Marketplace

## Business Interpretation

The Online Store is the principal revenue-generating channel in the dataset.

This makes digital purchasing behaviour an important part of overall commercial performance.

Further analysis in a production environment could examine:

- customer-value mix by channel;
- channel-specific average order value;
- repeat purchasing by channel;
- category preferences by channel;
- channel profitability and acquisition cost.

The available dataset supports identifying the largest channel by revenue and profit but does not include sufficient information to assess marketing efficiency or customer acquisition cost.

---

# 7. Insight 5 — Continuing Customer Movement Was Highly Polarised in 2025

Customers purchasing in both 2024 and 2025 were classified using changes in annual revenue contribution.

A ±5% materiality threshold was applied.

The classifications are:

- Growing — revenue increased by more than 5%
- Stable — revenue remained within ±5%
- Declining — revenue decreased by more than 5%

Validated 2025 results:

| Movement | Customers | Approx. Share |
|---|---:|---:|
| Growing | 4,829 | 48.54% |
| Stable | 358 | 3.60% |
| Declining | 4,761 | 47.86% |
| **Continuing** | **9,948** | **100%** |

## Business Interpretation

Customer movement was highly polarised.

Approximately:

**48.5%**

of continuing customers materially increased their annual revenue contribution, while approximately:

**47.9%**

materially decreased it.

Only approximately:

**3.6%**

remained within the ±5% stability band.

This shows that relatively stable aggregate business performance can contain substantial customer-level movement underneath it.

The analysis identifies the direction and scale of customer revenue change but does not explain its cause.

---

# 8. Insight 6 — 2,944 Previous-Year Customers Did Not Purchase in 2025

The customer movement framework identified:

**2,944 customers**

who recorded a completed purchase in 2024 but no completed purchase in 2025.

The relevant 2024 purchasing population was:

**12,892 customers**

consisting of:

- 9,948 customers who continued purchasing in 2025;
- 2,944 customers who did not.

Therefore:

`2,944 / 12,892 ≈ 22.8%`

Approximately:

**23% of the prior-year purchasing population**

recorded no completed purchase in 2025.

## Business Interpretation

This group represents a meaningful population for further investigation.

In a production environment, analysis could examine:

- previous customer value;
- historical purchase frequency;
- product preferences;
- previous sales channel;
- recency before inactivity;
- customer type;
- geographic patterns.

The project deliberately labels this group:

**No Longer Purchasing**

rather than:

**Churned**

because the dataset does not establish permanent customer loss.

---

# 9. Supporting Pattern — Value, Frequency and Recency Are Related

The RFV analysis shows clear associations between customer value, purchasing frequency and recency.

Premium Value customers are strongly represented among:

- higher-frequency purchasers;
- more recently active customers.

Low Value customers are more concentrated among:

- lower-frequency purchasers;
- less recent customers.

## Business Interpretation

Customer value in the dataset is associated with both frequency and recency characteristics.

This supports analysing multiple dimensions of customer behaviour rather than using Lifetime Revenue alone.

However, these relationships are observational.

The analysis does not establish that increasing purchase frequency or recency would necessarily cause a customer to become Premium Value.

---

# 10. Overall Commercial Picture

Across the complete 2022–2025 period, validated results include:

| KPI | Result |
|---|---:|
| Revenue | £46.03M |
| Profit | £19.63M |
| Profit Margin | 42.66% |
| Completed Orders | 169,360 |
| Purchasing Customers | 17,773 |
| Registered Customers | 20,000 |
| Average Order Value | £271.78 |
| Average Customer Value | £2.59K |
| Orders per Customer | 9.53 |
| Repeat Customer Rate | 91.67% |

Annual revenue increased from:

**£9.43M in 2022**

to:

**£13.80M in 2025**

while customer-level analysis shows that this growth sits alongside significant variation in customer value and purchasing movement.

---

# 11. Management Questions Raised by the Analysis

The findings create several useful follow-up questions.

### Customer Concentration

How dependent is the business on its Premium Value customer population?

### Existing Customer Growth

Which existing customer groups are responsible for the increase in Existing Customer Revenue?

### High-Value Customer Movement

Which High-Value or Premium customers are showing declining purchasing activity?

### Customer Inactivity

What characteristics distinguish customers who stopped purchasing from those who continued?

### Category Concentration

How dependent is overall revenue and profit on Electronics?

### Channel Behaviour

Do high-value and repeat customers show stronger preferences for particular sales channels?

These questions represent potential next stages of analysis rather than conclusions from the current dataset.

---

# 12. Recommended Analytical Extensions

A production implementation could extend the project with:

- customer cohort retention analysis;
- historical point-in-time RFV segmentation;
- customer lifetime value modelling;
- churn propensity modelling;
- basket and product affinity analysis;
- customer profitability analysis;
- acquisition-cost analysis;
- promotional effectiveness;
- channel migration analysis;
- predictive customer scoring.

These extensions would require additional business data and, in some cases, different modelling techniques.

---

# 13. Analytical Boundaries

The findings in this project intentionally avoid several unsupported claims.

The report does not claim:

- that No Longer Purchasing customers have permanently churned;
- that repeat purchasing represents formal retention;
- that RFV segment relationships are causal;
- that 2022 First Purchase Date represents true historical acquisition;
- that customer movement explains why behaviour changed;
- that revenue concentration automatically represents business risk.

These distinctions are important for responsible interpretation of descriptive analytics.

---

# 14. Conclusion

The analysis demonstrates that customer performance cannot be understood from total revenue alone.

The strongest findings show that:

- revenue is concentrated among a relatively small high-value customer population;
- existing customers increasingly contribute to annual revenue;
- Electronics represents the largest product category;
- Online Store is the leading sales channel;
- continuing customers show substantial positive and negative movement;
- a meaningful population of previous-year customers recorded no completed purchase in 2025.

Together, the SQL analytical model, Power BI semantic layer, RFV segmentation and dynamic customer movement framework provide a more complete view of customer and commercial performance than traditional sales reporting alone.
