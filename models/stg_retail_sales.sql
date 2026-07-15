{{ config(
    materialized='view'
) }}

SELECT
    `Transaction ID` AS transaction_id,
    `Customer ID` AS customer_id,
    SAFE_CAST(Date AS DATE) AS transaction_date,
    Gender AS customer_gender,
    SAFE_CAST(Age AS INT64) AS customer_age,
    `Product Category` AS product_category,
    SAFE_CAST(Quantity AS INT64) AS quantity_purchased,
    SAFE_CAST(`Price per Unit` AS FLOAT64) AS price_per_unit,
    SAFE_CAST(`Total Amount` AS FLOAT64) AS total_amount
FROM {{ ref('retail_sales_dataset') }}
