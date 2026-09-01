# Customer & Sales Analytics — DAX Reference

## 1. Purpose

This document describes the main DAX calculations used in the Customer & Sales Analytics Power BI semantic model.

The DAX layer supports:

- Sales and profitability analysis
- Order and customer volumes
- Customer-value metrics
- Repeat purchasing behaviour
- New and existing customer analysis
- Time intelligence
- Customer segmentation
- Customer movement and trend analysis
- Presentation helper calculations

The model separates calculations into three object types:

- **Measures** — dynamic calculations evaluated within report filter context
- **Calculated Columns** — customer-level attributes evaluated and stored at `DimCustomer` grain
- **Calculated Tables** — disconnected helper structures used for report presentation


---

# 2. DAX Organisation

Most measures are stored in the dedicated:

`_Measures`

table.

They are logically organised into:

1. Sales
2. Volume
3. Averages
4. Customer Behaviour
5. Customer Growth
6. Time Intelligence
7. Segmentation
8. Customer Trends

Customer-level calculated columns are stored in:

`DimCustomer`

Three disconnected calculated tables support selected report visuals.


---

# 3. Sales Measures

## Revenue

**Type:** Measure  
**Table:** `_Measures`  
**Folder:** Sales

```DAX
Revenue =
SUM ( FactSales[NetRevenue] )
