SELECT 
    age_cohort,
    customer_gender,
    product_category,
    price_distribution_bracket,
    SUM(customer_count) AS total_individual_purchases,
    ROUND(SUM(cumulative_spending), 2) AS gross_revenue_generated
FROM `dbt-bigquery-project-501223.dbt_project_dataset.mart_customer_behavior_and_pricing`
GROUP BY 1, 2, 3, 4
ORDER BY gross_revenue_generated DESC;

