# Netflix Subscriber's Growth and User Engagement Analysis 2019-2024

## Project Overview
This project analyzes Netflix's subscriber growth and user engagement trends over the years 2019 to 2024. The Netflix revenue datasets includes key metrics that provide insight into subscribers growth such as global revenue, regional streaming revenue, subscriber count, and ARPU (Average Revenue Per User) for different regions: UCAN, EMEA, LATM, and APAC while the provides insights into Netflix's user engagement metrics, focusing on viewing hours, title availability, and release dates. All revenue are in US dollars.

### Data source
Revenue data: This dataset used for the analysis is gotten from Kaggle, contains detailed information of trends of quarterly revenue from 2019 to 2024.

Engagement data: This dataset was downloaded from https://about.netflix.com/en/news/what-we-watched-the-first-half-of-2024, contains detailes information of what people watch of netflix from 

Date : Month-Year

Global Revenue: Revenue collected Worldwide.

UACN : United States and Canada

EMEA : Europe, Middle East and Africa

APAC : Asia-Pacific

LATM : Latin America

RPU : revenue per member.

The goal is to clean, analyze, and visualize Netflix's growth and user engagement to derive actionable insights.
## Data Cleaning in Excel
Data cleaning process with the use of Excel to critical ensure good data quality and consistency before analysis. Below are the steps used to clean and prepare the dataset in **Microsoft Excel**.

#### 1. **Check for Missing Values**
   - Using Conditional Formatting to Highlight Missing Values.
#### 2. **Standardize Data Types**
   - Date column standardise to date format.
   - remove commas from numeric column (eg. global_plus_dvd_revenue and hours_viewed) in the revenue and engagement dataset for consistency
   - Standardise all column title to text.
   - replace column name from CamelCase to snake_case.
#### 3. **Remove Duplicates in the primary id column, date in revenue data and title in engagement data**
   - No duplicate fund in the primary id column.

---
