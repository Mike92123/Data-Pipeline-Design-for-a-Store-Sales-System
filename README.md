# Data Pipeline Design for a Store Sales System
## Introduction
Favorita, the largest retail chain in Ecuador, operates a network of supermarkets and hypermarkets, offering a wide range of products. The business strategy focuses on providing high-quality products at affordable prices across Ecuador.

## Business Background
Favorita offers an extensive range of products, including groceries, fresh produce, household items, electronics, clothing, and more, sourced from both local and international suppliers.

## Business Problems
The primary challenge is managing inventory levels to reduce waste and avoid stockouts or overstocking. It's crucial to identify popular products and effective marketing campaigns and adjust inventory and marketing strategies according to seasonal demands.

## Requirements
The project involves analyzing historical sales data to identify patterns and trends, focusing on understanding sales trends in time series.

## Data Pipeline
### Data Pipeline Outline
Data for this project, including five CSV files (holidays_events.csv, oil.csv, stores.csv, train.csv, transactions.csv), was sourced from Kaggle. The data was preprocessed using Python and Pandas, then loaded into MySQL. After normalization in MySQL, Tableau was connected to the database to create dashboards aligning with business requirements.

### Data Implementation
Import CSV Files: Using the Pandas library in Python for data preprocessing.
MySQL Database Management: Database creation, table creation, and data insertion.
### Data Normalization
Original Database: Addressed complex many-to-many relationships and transitive dependencies.
New Database: Implemented solutions for these issues, including left joins and distinct unions for many-to-many relationships and elimination of transitive dependencies.

## Data Visualization on Tableau

### Connecting Tableau with MySQL
Steps to establish a connection to the local database and set up the server as 'localhost'. The database, named store-sales, is then connected to Tableau.

### Creating Charts and Dashboard on Tableau
Graphs are created on separate sheets in Tableau, with data attributes used for analytical chart requirements. The designed sheets are then compiled into a dynamic dashboard.

## Descriptive Analysis
Analysis includes sales data from 2013 to 2017, with a focus on cities, weekdays, holidays, and product families. Trends and promotional impacts are also examined.

## Authors
Zheng Zheng
Yu Swe Zin Aung (Kelly)

Project Presented: April 22, 2023
Instructor: Rushdi Alsaleh
Institution: Northeastern University-Vancouver
