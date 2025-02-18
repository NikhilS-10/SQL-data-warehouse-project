# Data Warehouse and Analytics Project 🚀

Welcome to the Data Warehouse and Analytics Project repository! This project demonstrates the design and implementation of a modern data warehouse with a focus on ETL pipelines, data modeling, and analytics.

## 📖 Project Overview
- **Data Architecture**: Using Medallion Architecture (Bronze, Silver, Gold layers).
- **ETL Pipelines**: Extract, transform, and load data from source systems.
- **Data Modeling**: Creating fact and dimension tables for analysis.
- **Analytics & Reporting**: SQL-based reports and dashboards for actionable insights.

## 🎯 Skills Covered
- SQL Development
- Data Engineering & Architecture
- ETL Pipeline Development
- Data Analytics & Reporting

## 🛠️ Tools & Links
- **Datasets**: Access to CSV files (ERP and CRM data).
- **SQL Server**: SQL Server Express & SSMS.
- **GitHub**: Manage, version, and collaborate on code.
  
## 🚀 Project Requirements
### Data Warehouse (Data Engineering)
- **Objective**: Develop a modern data warehouse for sales data analysis.
- **Data Sources**: Import data from ERP and CRM systems (CSV files).
- **Scope**: Focus on the latest dataset, data cleansing included.

### BI & Analytics (Data Analysis)
- **Objective**: Generate insights into customer behavior, product performance, and sales trends.
  
## 🏗️ Data Architecture
The architecture follows the Medallion Model:
- **Bronze Layer**: Raw data from source systems.
- **Silver Layer**: Data cleansing and transformation.
- **Gold Layer**: Business-ready star schema for reporting.

## 📂 Repository Structure
data-warehouse-project/
│
├── datasets/                             # Raw datasets used for the project (ERP and CRM data)
│

├── docs/                                 # Project documentation and architecture details

│   ├── etl.drawio                        # Draw.io file showing different ETL techniques and methods

│   ├── data_architecture.drawio          # Draw.io file illustrating the project's data architecture

│   ├── data_catalog.md                   # Catalog of datasets, including field descriptions and metadata

│   ├── data_flow.drawio                  # Draw.io file for the data flow diagram

│   ├── data_models.drawio                # Draw.io file for data models (star schema)

│   ├── naming-conventions.md             # Consistent naming guidelines for tables, columns, and files
│

├── scripts/                              # SQL scripts for ETL and transformations

│   ├── bronze/                           # Scripts for extracting and loading raw data from source systems

│   ├── silver/                           # Scripts for data cleansing, normalization, and transformation

│   ├── gold/                             # Scripts for creating analytical models and star schema
│

├── tests/                                # Test scripts and quality checks for data integrity
│

├── README.md                             # Project overview, setup instructions, and key information

├── LICENSE                               # License information for the repository (MIT License)

├── .gitignore                            # Files and directories to be ignored by Git

└── requirements.txt                      # Project dependencies and libraries

## 🛡️ License
MIT License. Feel free to use, modify, and share with proper attribution.

## 🌟 About Me
