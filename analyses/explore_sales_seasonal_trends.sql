SELECT 
    sales_season,
    basket_size_segment,
    product_category,
    SUM(total_orders) AS total_orders_placed,
    SUM(total_units_sold) AS total_items_sold,
    ROUND(SUM(gross_revenue), 2) AS seasonal_revenue
FROM `dbt-bigquery-project-501223.dbt_project_dataset.mart_sales_time_and_trends`
GROUP BY 1, 2, 3
ORDER BY seasonal_revenue DESC;