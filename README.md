## Introduction

This project builds an end-to-end data pipeline for a **customer churn prediction** use case, following the medallion architecture (Bronze → Silver → Gold) on top of Hadoop/HDFS. Raw data from multiple heterogeneous sources is ingested, cleaned, conformed into a dimensional model, and ultimately exposed as an ML-ready feature set for churn modeling.

## Scope

The scope covers the full pipeline from raw data ingestion up to a query-ready, dimensionally modeled Gold layer:

- Ingesting data from three independent source systems (relational DB, CSV, JSON) into a raw/Bronze HDFS layer using Apache NiFi.
- Registering the Bronze layer as external Hive tables for schema-on-read access and validation.
- Cleaning, standardizing, and transforming the raw data into a Silver layer using PySpark.
- Modeling a Galaxy Schema (conformed dimensions + multiple fact tables) in the Gold layer, including a Hybrid SCD Type 1/2 customer dimension.
- Producing verification queries to confirm data integrity at each stage.

Out of scope: the actual training/evaluation of the churn prediction model itself — the pipeline's output (`FACT_MONTHLY_USAGE`, with its `is_churned` target label) is the hand-off point to the ML workflow.

## Problem Statement

The organization needs to predict which customers are likely to churn, but the relevant signals are scattered across disconnected systems: core customer/account data lives in a relational database, customer service friction is logged separately as support tickets, and product usage behavior is captured in usage logs. These sources differ in format (relational, CSV, JSON), update frequency, and grain (snapshot vs. transactional vs. periodic), making them unusable for modeling in their raw form. A unified, historically-accurate, analysis-ready dataset is needed — one that correctly tracks customer state over time (avoiding data leakage) and combines behavioral, demographic, and support signals into a single feature matrix.

## Data Source

| Source                   | Format               | System                   | Bronze Table              |
| ------------------------ | -------------------- | ------------------------ | ------------------------- |
| Customer master data     | Relational (MariaDB) | `source_rdbms.customers` | `bronze_customers` (Avro) |
| Customer support tickets | CSV                  | Flat file                | `bronze_tickets`          |
| Product usage logs       | JSON                 | Flat file                | `bronze_usage`            |

## Pipeline

<img width="1338" height="596" alt="image" src="https://github.com/user-attachments/assets/bc9b6c87-5948-4b2d-8939-3e8ceb0d469c" />

## Contributors

- [Zeyad Abdallah](https://github.com/zeezo679)
- [Mohamed Amgad](https://github.com/MohamedAmgad27)
- [Mohamed Wael](https://github.com/waelm14)
- Chris Mina
