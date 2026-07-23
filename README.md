# End-to-End Retail Data Pipeline (dbt Core + Google BigQuery)

An enterprise-grade ELT data pipeline built using **dbt Core** and hosted on a cloud **Google BigQuery Data Warehouse**. This project transforms raw, chaotic transactional retail sales data from Kaggle into structured, optimized dimensional analytical data marts ready for Business Intelligence dashboarding.

## 🏗️ Architecture & Data Lineage
The data architecture follows the standard **Medallion (Multi-Layer) Architecture** pattern to guarantee clean data isolation:

1. **Source Layer (Raw):** Ingested Kaggle Retail Transactions dataset containing raw POS data rows.
2. **Staging Layer (Silver/Clean):** `stg_retail_sales` handles column standardization, handles syntax snake_casing, maps problematic column spaces using safe backtick compilation, and applies strict datatyping casting (`SAFE_CAST`). Materialized as a virtual **View** to reduce database duplication storage costs.
3. **Mart Layer (Gold/Analytics):** Pre-computes complex heavy aggregates and mathematical metrics. Materialized as physical **Tables** to optimize query latency for downstream reporting.
   * `mart_customer_behavior_and_pricing`: Segments user age cohorts (Gen Z, Millennials, Gen X, Boomers) and price brackets against spending.
   * `mart_sales_time_and_trends`: Extracts time patterns, maps transactions to seasons, and classifies basket sizes based on unit quantities.

## 📈 Core Business Insights Extracted
Through exploratory data analysis via dbt's analytical playground (`analyses/`), the pipeline successfully uncovers key retail trends:
* **High-Value Demographic:** **Gen X Males** generate the highest singular revenue stream, specifically dominating the purchase of **Premium Tier Electronics (>$100)**.
* **Product Category Appeal:** **Premium Clothing** maintains the highest cross-gender appeal, generating identical revenue patterns among both male and female groups.
* **Seasonal Micro-Trends:** **Winter** stands as the ultimate peak seasonal revenue driver, heavily populated by **Medium Basket (2-3 items)** transactions in clothing and beauty. 

## 🛡️ Data Quality & Pipeline Integrity Testing
Automated data assertions run across the ecosystem (`dbt test`) to safeguard metric tracking:
* **Primary Key Invariance:** The `transaction_id` is subjected to continuous `unique` and `not_null` constraints.
* **Financial Controls:** Key revenue pillars like `gross_revenue` and `cumulative_spending` run schema tests to validate that financial metrics never drop into corrupt negative bounds.

## 🛠️ Tech Stack & Setup
* **Transformations & Testing:** dbt Core (v1.11)
* **Cloud Data Warehouse:** Google BigQuery Sandbox (US Multi-Region)
* **Environment Management:** Isolated Python 3.13 Virtual Environments (`dbt-env`)
* **Version Control:** Git & GitHub Workflow
------

## 📊 Interactive Analytics Dashboard (Google Looker Studio)
An enterprise-grade executive dashboard built to visualize customer cohorts and sales trends. 

*   **Executive Scorecards**: High-level tracking of core revenue metrics and item price distributions (Min, Max, Avg) with optimized decimal precision for quick scanning.
*   **Demographic Segmentation**: Multi-dimensional breakdown of cumulative spending across different age cohorts and gender identifiers.
*   **Time-Series Forecasting**: Seasonal trend analysis highlighting performance fluctuations across Winter, Spring, Summer, and Fall cycles.


## 📷 Dashboard Preview


![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/ca66241962f18f03aa2829ba03d12b211df6ace1/Screenshot%202026-07-23%20031142.png)

🔗 [Explore the Live Interactive Dashboard Here](https://datastudio.google.com/s/pjSqJ-0k70Y)









