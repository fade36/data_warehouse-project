## Overview

This project demonstrates the development of a modern data warehouse using MySQL, following the Medallion Architecture: Bronze, Silver, and Gold layers.

The warehouse integrates sales-related data from CRM and ERP source systems provided as CSV files. It focuses on data ingestion, data cleansing, standardization, and analytical data modeling.

The project is designed as a data engineering portfolio project to practice SQL, ETL processes, data quality validation, and dimensional modeling.

---
## Data Architecture

The project follows the Medallion Architecture, consisting of three layers:

1. **Bronze Layer** — stores raw data ingested from CRM and ERP CSV files with minimal transformations.
2. **Silver Layer** — cleanses and standardizes data, handles duplicates and missing or invalid values, and converts source data into appropriate data types.
3. **Gold Layer** — provides business-ready dimension and fact views designed for analytical queries and reporting.

---
## Project Structure

The project is organized into scripts for database initialization, table creation, data loading, transformations, and data quality checks.

The SQL scripts are separated by processing layer to make the workflow easier to understand and maintain.

---

## Current Implementation

### Bronze Layer

- Created the data warehouse database and Bronze tables.
- Imported CRM and ERP datasets from CSV files.
- Preserved source data with minimal transformations.

### Silver Layer

- Defined tables with appropriate data types.
- Implemented data cleansing and standardization.
- Handled duplicate records and inconsistent values.
- Transformed dates, identifiers, and other source fields.
- Added data quality checks to validate the transformed data.

### Gold Layer

- Created `gold_dim_customers` to combine customer attributes from CRM and ERP sources.
- Created `gold_dim_products` to provide product and category information, filtering for current products.
- Created `gold_fact_sales` to connect sales transactions with customer and product dimensions.
- Used surrogate keys in the dimension views to support analytical joins.

The Gold layer follows a star-schema-oriented dimensional model, making the data easier to query for analytical purposes.

---

## Data Sources

The warehouse integrates two source systems:

- **CRM** — customer information, product information, and sales transactions.
- **ERP** — additional customer attributes, geographical information, and product category details.

The source datasets are provided as CSV files.

---
