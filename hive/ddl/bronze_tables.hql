CREATE DATABASE IF NOT EXISTS churn_bronze;
USE churn_bronze;

CREATE EXTERNAL TABLE IF NOT EXISTS bronze_tickets (
    Ticket_ID STRING,
    customer_id STRING,
    Customer_Name STRING,
    Customer_Email STRING,
    Ticket_Subject STRING,
    Ticket_Description STRING,
    Issue_Category STRING,
    Priority_Level STRING,
    Ticket_Channel STRING,
    Submission_Date STRING,
    Resolution_Time_Hours STRING,
    Assigned_Agent STRING,
    Satisfaction_Score STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar" = "\""
)
STORED AS TEXTFILE
LOCATION '/bronze/tickets'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS bronze_usage (
    usage_log_id STRING,
    `timestamp` STRING,
    customer_id STRING,
    source_system STRING,
    product_type STRING,
    monthly_balance DOUBLE,
    num_products INT
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/bronze/usage';

CREATE EXTERNAL TABLE IF NOT EXISTS bronze_customers (
    customer_id STRING,
    name STRING,
    email STRING,
    age STRING,
    gender STRING,
    geography STRING,
    is_active STRING,
    tenure_months STRING,
    date_opened STRING,
    last_modified STRING
)
STORED AS AVRO
LOCATION '/bronze/customers';
