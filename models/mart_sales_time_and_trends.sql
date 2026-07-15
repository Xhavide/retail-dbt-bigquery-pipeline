{{ config(
    materialized='table'
) }}

WITH time_features AS (
    SELECT
        transaction_id,
        transaction_date,
        product_category,
        quantity_purchased,
        total_amount,
        
        -- Time Patterns: Extract Month and Year
        EXTRACT(YEAR FROM transaction_date) AS tx_year,
        EXTRACT(MONTH FROM transaction_date) AS tx_month,
        FORMAT_DATE('%B', transaction_date) AS month_name,
        
        -- Seasonal Trends: Map months to seasons
        CASE 
            WHEN EXTRACT(MONTH FROM transaction_date) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM transaction_date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM transaction_date) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END AS sales_season,

        -- Basket Size Behavior: Segment by quantity bought per transaction
        CASE 
            WHEN quantity_purchased = 1 THEN 'Single Item Basket'
            WHEN quantity_purchased BETWEEN 2 AND 3 THEN 'Medium Basket (2-3)'
            ELSE 'Bulk Basket (4+)'
        END AS basket_size_segment

    FROM {{ ref('stg_retail_sales') }}
)

SELECT
    tx_year,
    tx_month,
    month_name,
    sales_season,
    basket_size_segment,
    product_category,
    COUNT(transaction_id) AS total_orders,
    SUM(quantity_purchased) AS total_units_sold,
    ROUND(SUM(total_amount), 2) AS gross_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM time_features
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY tx_year DESC, tx_month ASC
