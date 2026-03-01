# Revenue & Profitability Diagnostic Analysis  
*(Work in Progress)*

##  Project Overview

This project analyzes large-scale e-commerce transaction data (100,000+ records) to evaluate revenue performance, margin trends, and segment-level profitability.

The objective is to build a structured revenue diagnostic framework that identifies key revenue drivers, detects margin erosion factors, and supports data-driven pricing and optimization decisions.

---

##  Business Objectives

- Evaluate revenue and profitability trends  
- Identify high-margin and underperforming product segments  
- Detect discount-driven margin erosion  
- Analyze customer and category-level revenue contribution  
- Build KPI framework for performance monitoring  

---

##  Tools & Technologies

- **Python (Pandas, NumPy)** – Data validation & statistical analysis  
- **SQL** – Data transformation & aggregation *(Upcoming)*  
- **Power BI** – KPI dashboards & visualization *(Upcoming)*  
- **Excel** – Supporting validation  

---

##  Dataset

- 100,000+ transaction-level records  
- Multiple relational CSV files:
  - Orders  
  - Order Items  
  - Payments  
  - Products  
  - Customers  
  - Sellers  

---

# Step 1: Data Validation & Cleaning (Python)

Initial validation performed using Python to ensure data accuracy before transformation and modeling.

### 1.Data Import & Structure Inspection

Validated dataset shape, schema consistency, and column data types.

![Data Import](python/screenshots/data_import.png)

---

### 2. Duplicate Record Checks

Verified uniqueness of primary keys and removed redundant records where required.

![Duplicate Check](python/screenshots/duplicate_check.png)

---

### 3.Missing Value Analysis

Identified null fields impacting revenue and margin calculations.

![Missing Values](python/screenshots/missing_values.png)

---

### 4. Data Type & Consistency Validation

- Checked numeric formatting for price and payment fields  
- Standardized date formats  
- Verified referential consistency across datasets  

---

# Step 2: Data Transformation (SQL) *(Upcoming)*

Planned transformation steps:

- Join transaction-level datasets  
- Calculate revenue and gross margin  
- Aggregate metrics by product, category, and customer segment  
- Create structured profitability views  

---

#  Step 3: KPI Development & Dashboarding (Power BI) *(Upcoming)*

Planned dashboard modules:

- Revenue Overview  
- Margin Trend Analysis  
- Segment-Level Profitability  
- Discount Impact Analysis  
- Contribution Analysis by Category  

Dashboard screenshots will be added as development progresses.

---

#  Expected Business Impact

This project aims to deliver a reusable revenue diagnostic framework capable of:

- Identifying profitability risks  
- Detecting margin erosion drivers  
- Highlighting high-value segments  
- Supporting pricing optimization strategies  

---

#  Project Status

Currently in the **data validation and cleaning phase (Python)**.  
SQL transformation and Power BI dashboard development will follow.


---

##  Author

Aditi Jatal  
Data Analyst | SQL | Python | Power BI  
