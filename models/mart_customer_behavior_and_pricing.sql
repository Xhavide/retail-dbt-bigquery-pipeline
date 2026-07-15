{{ config(
    materialized='table'
) }}

WITH customer_pricing_distribution AS (
    SELECT
        transaction_id,
        customer_gender,
        customer_age,
        product_category,
        price_per_unit,
        total_amount,

        -- Age Buckets for easier relational grouping
        CASE 
            WHEN customer_age < 25 THEN '18-24 (Gen Z)'
            WHEN customer_age BETWEEN 25 AND 39 THEN '25-39 (Millennials)'
            WHEN customer_age BETWEEN 40 AND 54 THEN '40-54 (Gen X)'
            ELSE '55+ (Boomers)'
        END AS age_cohort,

        -- Price Distribution: Segmenting products by price brackets
        CASE 
            WHEN price_per_unit < 30 THEN 'Low Tier (<$30)'
            WHEN price_per_unit BETWEEN 30 AND 100 THEN 'Mid Tier ($30-$100)'
            ELSE 'Premium Tier (>$100)'
        END AS price_distribution_bracket

    FROM {{ ref('stg_retail_sales') }}
)

SELECT
    age_cohort,
    customer_gender,
    product_category,
    price_distribution_bracket,
    COUNT(transaction_id) AS customer_count,
    ROUND(SUM(total_amount), 2) AS cumulative_spending,
    ROUND(AVG(total_amount), 2) AS avg_customer_spend,
    
    -- Price Distribution Insights: Min, Max, and Avg prices inside this bracket
    ROUND(MIN(price_per_unit), 2) AS min_item_price,
    ROUND(MAX(price_per_unit), 2) AS max_item_price,
    ROUND(AVG(price_per_unit), 2) AS avg_item_price

FROM customer_pricing_distribution
GROUP BY 1, 2, 3, 4
ORDER BY age_cohort, cumulative_spending DESC
