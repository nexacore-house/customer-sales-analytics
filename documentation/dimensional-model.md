# Customer & Sales Analytics — Dimensional Model

## 1. Purpose

This document describes the dimensional modelling approach used in the Customer & Sales Analytics project.

The raw source data follows a transactional structure containing customers, products, categories, orders and order lines.

Rather than loading this transactional structure directly into Power BI, the data was transformed in SQL into a purpose-built analytical star schema.

The final model is designed to support:

- Sales and profitability analysis
- Customer behaviour analysis
- Product and category analysis
- Sales channel analysis
- Time intelligence
- Customer segmentation
- Customer growth and decline analysis
- Efficient Power BI filtering and aggregation


---

# 2. Modelling Approach

The analytical model follows a star-schema design.

The central fact table is:

`FactSales`

It is surrounded by four primary dimensions:

- `DimCustomer`
- `DimProduct`
- `DimDate`
- `DimChannel`

The simplified structure is:

```text
                  DimProduct
                      |
                      |
DimCustomer ---- FactSales ---- DimChannel
                      |
                      |
                   DimDate
