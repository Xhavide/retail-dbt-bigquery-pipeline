{{ config(
    materialized='view'
) }}

WITH raw_source AS (
    SELECT * 
    FROM {{ source('retail_source_data', 'retail_sales_dataset') }}

)

SELECT
    transaction_id,
    transaction_date,
    customer_id,
    gender,
    age,
    product_category,
    quantity,
    price_per_unit,
    total_amount
FROM raw_source








