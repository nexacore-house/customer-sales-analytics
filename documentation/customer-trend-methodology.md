# Customer & Sales Analytics — Customer Trend Methodology

## 1. Purpose

This document describes the customer movement methodology used in the Customer & Sales Analytics project.

The objective is to evaluate how customer purchasing activity changes between a selected reporting period and the equivalent previous-year period.

The framework distinguishes between:

- New Customers
- Returning Existing Customers
- Continuing Customers
- Growing Customers
- Stable Customers
- Declining Customers
- No Longer Purchasing Customers

These classifications are dynamic and respond to the selected reporting period.

---

# 2. Why Customer Movement Is Dynamic

Customer behaviour changes over time.

A customer may increase spending in one year, reduce spending in another, or stop purchasing for a period and later return.

For this reason, customer movement is implemented using DAX measures rather than static calculated columns.

The classification depends on:

- current-period purchasing activity;
- equivalent previous-year activity;
- first observed purchase date;
- revenue movement between periods.

---

# 3. Reporting Period

The final report supports annual customer movement analysis for:

- 2023
- 2024
- 2025

The 2022 year is the first observed transactional year and therefore does not have a complete equivalent previous-year period within the dataset.

The Customer Trends report page defaults to:

**2025**

---

# 4. First Observed Purchase

Customer acquisition logic is based on:

`First Purchase Date`

This represents the customer's first observed completed purchase within the available transactional history.

The available data begins on:

**1 January 2022**

Therefore, First Purchase Date should not be interpreted as proof that the customer had never purchased before the dataset began.

---

# 5. New Customers

A New Customer is defined as a customer who:

- has completed purchasing activity in the current reporting period; and
- has a First Purchase Date within that reporting period.

Conceptually:

```text
Current Revenue > 0
AND
First Purchase Date is within current period
