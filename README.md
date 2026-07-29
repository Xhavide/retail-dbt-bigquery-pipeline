# End-to-End Retail Data Pipeline (dbt Core + Google BigQuery)

An advanced ELT data engineering pipeline and business intelligence infrastructure built to process, model, and visualize high-volume transactional retail data. This project transforms chaotic, raw point-of-sale data into optimized, audit-ready data marts using dbt Core and Google BigQuery, culminating in a production-grade executive dashboard hosted on Google Looker Studio.

Explore the Live Interactive Dashboard 👉  [Here](https://datastudio.google.com/s/pjSqJ-0k70Y)

## 🚀 Executive Project Summary
Modern retail environments generate massive volumes of transactional data that remain underutilized due to fragmented structures and unoptimized query paths. This project establishes a robust data lifecycle ecosystem that bridges the gap between raw data collection and strategic executive decision-making. 

By applying rigorous data warehousing principles, software engineering best practices via dbt, and multi-dimensional reporting structures, this infrastructure slashes database compute costs, guarantees strict data isolation, and delivers sub-second dashboard query latency for enterprise stakeholders.

--------
## 🗂️ Dataset Overview

The project operates on a transactional retail dataset capturing point-of-sale (POS) operations and customer interactions. Key data features include:
* **Core Ledger:** Transaction ID, Transaction Date, Customer ID
* **Demographics:** Age, Gender
* **Sales Matrix:** Product Category, Quantity, Price per Unit, Total Amount

---------


### 🎯 Business Questions Addressed

* How do customer age cohorts and gender identifiers influence purchasing behavior?
* Are there discernible, macro-level patterns in revenue across different seasonal periods?
* Which specific product categories hold the highest transactional appeal among customers?
* What are the relationships between age, spending tiers, and product preferences?
* Are there distinct purchasing behaviors based on the number of items bought per transaction?
* What insights can be gleaned from the distribution of product prices within each category?

------------

## 🏗️ Architecture & Data Lineage

The data architecture implements a formalized Medallion (Multi-Layer) Architecture pattern within Google BigQuery to decouple compute, ensure strict schema compliance, and maintain clean lineage isolation:

[ Raw CSV Ingestion ] ──> [ Google BigQuery DDL ] ──> [ Staging View (Silver) ] ──> [ Gold Data Marts (Tables) ] ──> [ Looker Studio BI Layer ] 

### 1. Source Layer (Raw Ingestion & Schema Alignment)
* Lands the raw, uncompressed retail text rows into BigQuery.
* **Optimization Phase:** Enforced structural schema alignment directly via BigQuery Data Definition Language (DDL). Explicitly resolved column alignment anomalies (mismatched string headers) and strictly typecast raw fields to their natural formats (`INT64` for identifiers, native `DATE` objects, and `FLOAT64` for currency metrics). This eliminates execution-level parsing latency downstream.

### 2. Staging Layer (Silver Zone / Clean & Modular)
* **Model:** `stg_retail_sales`
* **Transformation Mechanics:** Configured directly via a production-grade `sources.yml` metadata boundary file to track explicit upstream lineage. Bypasses chaotic parsing strings to surface uniform, standardized fields ready for dimensional consumption.
* **Materialization Strategy:** Materialized as a virtual **View**. This design pattern minimizes static cloud storage duplication costs and ensures that downstream elements dynamically read raw definitions without indexing duplicate blocks.

### 3. Mart Layer (Gold Zone / Analytics & Dimensional Modeling)
* **Transformation Mechanics:** Pre-computes complex, heavy mathematical aggregates and business conditional logic, completely eliminating raw calculations during live dashboard sessions.
* **Materialization Strategy:** Configured as physical, materialized **Tables** to radically optimize query latency, cache aggregate result sets, and eliminate runtime slot-time compute costs.
* **`mart_customer_behavior_and_pricing`:** Isolates purchasing habits by dynamically segmenting consumer demographics into structured age cohorts (Gen Z, Millennials, Gen X, Boomers) cross-referenced against custom product tier distributions (Budget, Mid-Range, Premium Tiers).
* **`mart_sales_time_and_trends`:** Executes time-series extraction, mapping raw timestamps into distinct calendar components, localized business quarters, and seasonal cycles (Winter, Spring, Summer, Fall) while profiling transaction basket scales based on unit quantities.

---------

## 🛠️ Comprehensive Step-by-Step Project Walkthrough
**Phase 1: Environment Setup & Cloud Architecture** 

Before transforming any data, the infrastructure has been securely initialized across the cloud data warehouse and the transformation framework.

**Step 1.1: Google BigQuery Ingestion**

I have created a Google Cloud Platform (GCP) project, initialized a BigQuery dataset instance, and uploaded the raw Kaggle Retail Transactions CSV file.

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/3508450fb81171306161b04b60d915babfa13e98/Google%20BigQuery%20Ingestion.png)

**Step 1.2: dbt Cloud / dbt Core Initialization**

Before Initializing a new dbt project I created a dbt folder in the User Home Directory that maintains the profiles.yml where database connections and user credentials are stored. Configured profiles.yml to establish a secure connection using a GCP Service Account JSON key, granting dbt permission to execute queries inside BigQuery.
Here is a dbt interface showing a successful connection test with ‘dbt debug’ command after initializing the new dbt project:

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/a51929aef6519e0a963be421f71f10e9a5687bae/Successful%20connection%20test%20(dbt%20debug).png)


**Phase 2: The Staging Layer (Silver Zone)**

This phase focuses on isolating data, standardizing raw columns, fixing structural text discrepancies, and enforcing strong typing.

**Step 2.1: Declaring dbt Sources**

Created a sources.yml file to cleanly define the raw BigQuery schema and table locations. 


**Step 2.2: Building the Staging Model (stg_retail_sales.sql)**

Wrote an atomic SQL script utilizing the {{ source() }} macro. I converted inconsistent string headers into universal snake_case, used backticks to handle fields containing blank spaces, and wrapped critical fields in SAFE_CAST statements to handle null values gracefully. Configured the model config block to materialize strictly as a dynamic View to keep compute costs at zero until requested.

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/d78d816162ab2ed9ba85355ac791fe6e0fc60599/stg_retail_sales.sql%20model%20file.png)

**Phase 3: The Analytical Mart Layer (Gold Zone)** 

Here, the standardized staging views are joined, aggregated, and compiled into specialized, physically materialized analytical tables optimized for fast query retrieval.

**Step 3.1: Constructing mart_customer_behavior_and_pricing.sql**

Developed a dimensional metrics script. Built conditional logic (CASE WHEN) to cleanly segment ages into recognized cohorts (Gen Z, Millennials, Gen X, Boomers). I have simultaneously grouped prices into analytical tiers to track how spending habits fluctuate across demographic lines.

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/441a20e6fd847b0b84cd903370f38c858b26ab53/aggregation%20functions%20for%20user%20cohorts.png)

**Step 3.2: Constructing mart_sales_time_and_trends.sql** 

Built an analytical time-series script. Applied BigQuery date extraction functions to translate raw timestamps into distinct seasonal buckets (Winter, Spring, Summer, Fall) and calculated unit boundaries to isolate bulk order patterns from individual sales. And finely materialized both mart models as physical Tables in dbt_project.yml to minimize report compute latency.

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/4da49424f04ced4edb1a86e5613e95c321c4a5b3/mart_sales_time_and_trends.sql.png)

**Phase 4: Quality Assurance, Testing, & Lineage** 

To guarantee production-grade trust, data assets are documented and evaluated against testing suites before deployment.

**Step 4.1: Writing Schema Testing Suites (schema.yml)**

Configured assertion constraints inside model definition YAML files. Applied schema-level validation criteria—such as checking for not_null and unique rules on primary keys—to block bad or corrupted rows from surfacing in reports.

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/5dafe9d149fe5e697796effcb9a3d109b82242fd/YAML%20file%20configuration%20showing%20testing%20blocks.png)

**Step 4.2: Data Lineage & Documentation Compilation**

Executed terminal commands dbt test and dbt docs generate to automatically parse code dependencies, evaluate data constraints, and map the full end-to-end lineage network.

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/1261b1cbc1c10f20b641318193c5bdd3df16aeeb/dbt%20Directed%20Acyclic%20Graph%20(DAG)%20%20Lineage%20graph.png)

![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/55ef90689f9a993d16686fe229f454eef70b285e/Documentation%20Compilation.png)

**Phase 5: Business Intelligence Infrastructure**

The final phase surfaces the optimized, physical cloud data marts into a polished, highly fast semantic dashboard for executive decision-makers.

**Step 5.1: Looker Studio Semantic Data Connections**

I opened Looker Studio, connected directly via the BigQuery native connector, and referenced physical gold tables. This bypasses structural processing entirely at runtime, allowing Looker Studio to consume pre-computed metrics immediately.


## 📊 Interactive Analytics Dashboard (Google Looker Studio)
An enterprise-grade executive dashboard built to visualize customer cohorts and sales trends. 

*   **Executive Scorecards**: High-level tracking of core revenue metrics and item price distributions (Min, Max, Avg) with optimized decimal precision for quick scanning.
*   **Demographic Segmentation**: Multi-dimensional breakdown of cumulative spending across different age cohorts and gender identifiers.
*   **Time-Series Forecasting**: Seasonal trend analysis highlighting performance fluctuations across Winter, Spring, Summer, and Fall cycles.


## 📷 Dashboard Preview


![](https://github.com/Xhavide/retail-dbt-bigquery-pipeline/blob/ca66241962f18f03aa2829ba03d12b211df6ace1/Screenshot%202026-07-23%20031142.png)

🔗 [Explore the Live Interactive Dashboard Here](https://datastudio.google.com/s/pjSqJ-0k70Y)

------------

## 🛡️ Data Quality & Pipeline Integrity Testing
Automated data assertions run across the ecosystem (`dbt test`) to safeguard metric tracking:
* **Primary Key Invariance:** The `transaction_id` is subjected to continuous `unique` and `not_null` constraints.
* **Financial Controls:** Key revenue pillars like `gross_revenue` and `cumulative_spending` run schema tests to validate that financial metrics never drop into corrupt negative bounds.

-----------

## 📈 Core Business Insights Extracted
Through exploratory data analysis via dbt's analytical playground (`analyses/`), the pipeline successfully uncovers key retail trends:
* **High-Value Demographic:** **Gen X Males** generate the highest singular revenue stream, specifically dominating the purchase of **Premium Tier Electronics (>$100)**.
* **Product Category Appeal:** **Premium Clothing** maintains the highest cross-gender appeal, generating identical revenue patterns among both male and female groups.
* **Seasonal Micro-Trends:** **Winter** stands as the ultimate peak seasonal revenue driver, heavily populated by **Medium Basket (2-3 items)** transactions in clothing and beauty. 

-------------

## 🛠️ Tech Stack & Setup
* **Transformations & Testing:** dbt Core (v1.11)
* **Cloud Data Warehouse:** Google BigQuery Sandbox (US Multi-Region)
* **Environment Management:** Isolated Python 3.13 Virtual Environments (`dbt-env`)
* **Version Control:** Git & GitHub Workflow







