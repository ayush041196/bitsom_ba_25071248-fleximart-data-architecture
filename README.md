# bitsom_ba_25071248-fleximart-data-architecture

# FlexiMart Data Architecture Project

**Student Name: Ayush Singhania
**Student ID:** bitsom_ba_25071248
**Email: ayush.411singhania@gmail.com
**Date:** 20-Dec-25

## Project Overview

Project builds end-to-end data processing for FlexiMart—from cleaning CSV data using ETL, loading into SQL databases, designing star schema warehousing, and executing analytical queries, to implementing a NoSQL product catalog in MongoDB.


## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.x, pandas, mysql-connector-python
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0

## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/business_queries.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql


### MongoDB Setup

mongosh < part2-nosql/mongodb_operations.js

## Key Learnings

1. Gained hands-on experience in building an end-to-end ETL pipeline, including data extraction, transformation, loading, and handling real-world data quality issues such as duplicates, null values, and inconsistent formats.

2. Learned how to design and implement a relational database and a dimensional data warehouse using star schema concepts to support advanced analytics and drill-down reporting.

3. Developed skills in writing complex SQL analytical queries, involving joins, aggregations, window functions, segmentation, and performance-driven data modeling techniques.

4. Explored NoSQL concepts and understood when to use MongoDB over traditional RDBMS systems, especially for flexible schemas, nested documents, and scalable product catalog solutions.

## Challenges Faced

1.Challenge: Inconsistent and incomplete CSV data (missing emails, null prices, duplicate records, irregular date formats) made it difficult to load directly into the database.
Solution: Implemented a robust ETL pipeline in Python that removed duplicates, standardized phone numbers and categories, filled or handled missing values, and converted dates to a uniform format before loading into SQL.

2. Challenge: Designing a data warehouse that could support drill-down analytics while handling multiple product categories and diverse customer attributes.
Solution: Created a star schema with a fact_sales table at the transaction line-item granularity and conformed dimension tables (dim_date, dim_product, dim_customer) with surrogate keys, enabling easy aggregation, drill-down, and roll-up analysis.
