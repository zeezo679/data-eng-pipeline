CREATE DATABASE IF NOT EXISTS churn_gold;
USE churn_gold;

CREATE EXTERNAL TABLE IF NOT EXISTS DIM_DATE (
    date_key INT,
    full_date DATE,
    day INT,
    month INT,
    quarter INT,
    year INT
)
STORED AS PARQUET
LOCATION '/gold/dim_date';

CREATE EXTERNAL TABLE IF NOT EXISTS DIM_CUSTOMER (
cust_key INT,
customer_id STRING,
name STRING,
email STRING,
age INT,
gender STRING,
geography STRING,
is_active BOOLEAN,
tenure_months INT,
join_date DATE,
dw_start_date TIMESTAMP,
dw_end_date TIMESTAMP,
is_current BOOLEAN
)
STORED AS PARQUET
LOCATION '/gold/dim_customer';


CREATE EXTERNAL TABLE IF NOT EXISTS FACT_SUPPORT_TICKETS (
ticket_key BIGINT,
date_key INT,
cust_key INT,
ticket_id STRING,
issue_type STRING,
priority_level STRING,
ticket_channel STRING,
assigned_agent STRING,
satisfaction_score INT,
resolution_hrs DOUBLE
)
STORED AS PARQUET
LOCATION '/gold/fact_support_tickets';


CREATE EXTERNAL TABLE IF NOT EXISTS FACT_MONTHLY_USAGE (
usage_key BIGINT,
date_key INT,
cust_key INT,
monthly_balance DOUBLE,
clv_ltv DOUBLE,
num_products INT,
product_type STRING,
source_system STRING,
is_churned BOOLEAN
)
PARTITIONED BY (month_id STRING)
STORED AS PARQUET
LOCATION '/gold/fact_monthly_usage';
