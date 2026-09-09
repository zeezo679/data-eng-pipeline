-- Demographic Churn Analysis
SELECT 
    c.geography,
    CASE 
        WHEN c.age < 25 THEN 'Under 25'
        WHEN c.age BETWEEN 25 AND 35 THEN '25-35'
        WHEN c.age BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(DISTINCT f.cust_key) AS churned_customers
FROM churn_gold.FACT_MONTHLY_USAGE f
JOIN churn_gold.DIM_CUSTOMER c ON f.cust_key = c.cust_key
WHERE f.is_churned = TRUE
GROUP BY 
    c.geography,
    CASE 
        WHEN c.age < 25 THEN 'Under 25'
        WHEN c.age BETWEEN 25 AND 35 THEN '25-35'
        WHEN c.age BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END
ORDER BY churned_customers DESC


-- Support Service Impact on Churn
SELECT 
    t.satisfaction_score,
    CASE 
        WHEN u.is_churned = TRUE THEN 'Churned' 
        ELSE 'Retained' 
    END AS customer_status,
    COUNT(DISTINCT u.cust_key) AS customer_count
FROM churn_gold.FACT_SUPPORT_TICKETS t
JOIN churn_gold.FACT_MONTHLY_USAGE u ON t.cust_key = u.cust_key
GROUP BY 
    t.satisfaction_score,
    CASE 
        WHEN u.is_churned = TRUE THEN 'Churned' 
        ELSE 'Retained' 
    END
ORDER BY 
    t.satisfaction_score ASC;


-- Customer Lifetime Value (CLV) Risk Assessment
SELECT 
    product_type,
    COUNT(DISTINCT cust_key) AS churned_customers,
    ROUND(AVG(clv_ltv), 2) AS avg_lost_clv
FROM churn_gold.FACT_MONTHLY_USAGE
WHERE is_churned = TRUE
GROUP BY product_type
ORDER BY avg_lost_clv DESC;


-- Product Stickiness & Retention
SELECT 
    num_products,
    COUNT(DISTINCT cust_key) AS total_customers,
    SUM(CAST(is_churned AS INT)) AS churned_customers,
    ROUND(
        (SUM(CAST(is_churned AS INT)) * 100.0 / COUNT(DISTINCT cust_key)), 
        2
    ) AS churn_rate_percentage
FROM churn_gold.FACT_MONTHLY_USAGE
GROUP BY num_products
ORDER BY num_products;


-- Support Channel Bottlenecks
SELECT 
    t.ticket_channel,
    COUNT(t.ticket_key) AS total_tickets,
    ROUND(AVG(t.resolution_hrs), 2) AS avg_resolution_hours
FROM churn_gold.FACT_SUPPORT_TICKETS t
JOIN churn_gold.FACT_MONTHLY_USAGE u ON t.cust_key = u.cust_key
WHERE u.is_churned = TRUE
GROUP BY t.ticket_channel
ORDER BY avg_resolution_hours DESC;
