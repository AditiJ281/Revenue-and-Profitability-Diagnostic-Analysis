# Revenue & Profitability Diagnostic Analysis

## Project Overview

This project analyzes large-scale e-commerce transaction data (100,000+ records) to diagnose revenue performance, cost structure, and profitability drivers.

The analysis builds a structured revenue diagnostic framework that traces revenue from product sales through logistics costs and payment adjustments, enabling a clearer understanding of how operational factors impact profitability.

The final output is an interactive **Power BI diagnostic dashboard** designed to help stakeholders monitor revenue growth, evaluate category performance, and identify cost drivers affecting margins.

---
![Dashboard Overview](https://github.com/AditiJ281/Revenue-and-Profitability-Diagnostic-Analysis/blob/main/dashboard/Dashboard.gif)

---
## Business Objectives

* Evaluate revenue growth and order trends
* Identify top-performing and underperforming product categories
* Understand how logistics and payment adjustments affect revenue
* Analyze order volume and average order value drivers
* Build a structured KPI framework for revenue monitoring

---

## Tools & Technologies

**Python (Pandas, NumPy):**
Data validation, quality checks, and exploratory analysis.

**SQL:**
Data transformation, dataset integration, and revenue metric preparation.

**Power BI:**
Interactive dashboards and KPI monitoring.


---

## Dataset

* **100,000+ transaction-level records**
* Multiple relational datasets:

| Dataset     | Description                          |
| ----------- | ------------------------------------ |
| Orders      | Order-level transaction data         |
| Order Items | Product-level purchase details       |
| Payments    | Payment value and method information |
| Products    | Product and category attributes      |
| Customers   | Customer demographic information     |
| Sellers     | Seller-level operational data        |

---

# Data Validation & Cleaning (Python)

Initial data validation ensured dataset accuracy before transformation and analysis.

1.Data Import & Structure Inspection: Validated dataset shape, schema consistency, and column data types.

2.Duplicate Record Checks: Verified primary key uniqueness and removed redundant records where necessary.

3.Missing Value Analysis:Identified null fields impacting revenue and operational metrics.

4.Data Type & Consistency Validation
* Standardized numeric fields for pricing and payment data
* Normalized date formats
* Verified relational consistency across datasets

---

# Data Transformation (SQL)

SQL was used to integrate the relational datasets and generate analytical tables used for revenue diagnostics.

Key transformation steps included:

* Joining orders, order items, payments, and product tables
* Creating revenue and cost calculations
* Aggregating metrics by product category and time period
* Preparing structured datasets for Power BI visualization

---

# Dashboard Development (Power BI)

The final Power BI dashboard provides a multi-layer diagnostic view of business performance.

### Dashboard Modules

**1. Revenue Overview**

Key KPIs monitored:

* Total Revenue
* Revenue Growth
* Total Orders
* Average Order Value
* Repeat Purchase Rate

The overview also includes a revenue trend analysis and a revenue reconciliation waterfall showing how product value, logistics costs, and financial adjustments contribute to total revenue.

---

**2. Category Impact Analysis**

Analyzes product category performance by:

* Revenue contribution by category
* Order volume distribution
* Freight cost patterns across product segments

This view helps identify categories driving revenue and those with operational cost pressure.

---

**3. Financial Summary Table**

A structured financial breakdown summarizing:

* Product and freight costs
* Total revenue and profit
* Order metrics and average order value

This section provides a compact financial view for performance evaluation.

---

# Key Insights

* Revenue growth is primarily driven by **order volume increases rather than repeat purchases**.
* **Health & Beauty** categories contribute the highest revenue share.
* Logistics costs represent a meaningful component of the overall revenue structure.
* Seasonal spikes suggest strong demand during promotional periods such as holiday sales events.

---

# Business Value

This diagnostic framework helps businesses:

* Monitor revenue performance through structured KPIs
* Identify category-level growth drivers
* Detect operational cost pressures
* Support data-driven pricing and optimization decisions

---

# Author

**Aditi Jatal**
Data Analyst
SQL • Python • Power BI
