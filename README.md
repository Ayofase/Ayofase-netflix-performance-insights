# Analysis of Netflix Revenue, Membership, and Content Strategy (2019-2024)

## Project Overview
This project analyzes Netflix's streaming performance, focusing on revenue trend, subscriber growth and content engagment over the years 2019 to 2024. The Netflix revenue datasets includes key metrics that provide insight into subscribers growth such as global streaming revenue, regional streaming revenue, membership growth, and ARPU (Average Revenue Per User) for different regions: UCAN, EMEA, LATM, and APAC while it provides insights into Netflix's streaming performance and engagement metrics, focusing on release dates, views and hours viewed. All revenue are in US dollars.

## Table Of Content
  - [Project Goals](#project-goals)
  - [Data source](#data-source)
  - [Tools](#tools)
  - [Project Goals](#project-goals)

### Project Goals:

Identify Key Revenue Drivers: Explore trends in streaming revenue, ARPU (Average Revenue Per User), and membership growth, both globally and regionally. Note that engagement metrics are not available at the regional level due to data source constraints and hence will be presented globally.

Analyze Content Performance: Examine viewer engagement metrics (total views, total hours viewed, average runtime) to understand content consumption patterns and identify top-performing movies and TV shows.

Inform Content Strategy: Provide data-driven insights to inform Netflix's content acquisition and production decisions, focusing on maximizing viewership and engagement.

Develop an Interactive Dashboard: Create a user-friendly Tableau Public dashboard that allows stakeholders to explore the data dynamically, uncover key trends and insights, and make data-informed decisions about revenue, user base growth, and content acquisition/creation strategies.

### Data source
Revenue data: This dataset used for the analysis is gotten from Kaggle, contains detailed information of quarterly revenue, membership, and ARPU figures, broken down by region (UCAN, EMEA, LATM, APAC).

Engagement data: This dataset was downloaded from https://about.netflix.com/en/news/what-we-watched-the-first-half-of-2024, contains detailes information of aggregated viewership metrics (total views, total hours viewed, and runtime) for individual movies and TV shows. This dataset does not contain regional data, limiting regional analysis to revenue metrics.

Date : Month-Year

Global Revenue: Revenue collected Worldwide.

UACN : United States and Canada

EMEA : Europe, Middle East and Africa

APAC : Asia-Pacific

LATM : Latin America

RPU : revenue per member.

### Tools
- Excel
- SQL Server
- R 
- Tableau

## Data Cleaning/Prepation
Data cleaning process with the use of Excel, SQL and R to critical ensure good data quality and consistency before analysis. Below are the steps used for cleaning and preparing the dataset

#### 1. **Handling Missing Values**
   - Using Conditional Formatting to highlight missing values.
   - **TMDb API Integration:**
Missing Netflix release dates for movies and tv shows were retrieved using the TMDb API (The Movie Database). A custom R function was implemented to perform this integration using the `httr` package for making API requests and the `jsonlite` package for parsing JSON responses from the TMDb API. If no matches were found for a title the corresponding release date field for that title was set to NA. 

#### 2. **Standardize Data Types**
   - Date column standardise to date format.
   - Remove commas from numeric column (eg. Streaming_revenue and hours_viewed) in the revenue and engagement dataset for consistency
   - Standardise all column title to text.
   - Replace column name from CamelCase to snake_case.
#### 3. **Remove Duplicates in the primary id column, date in revenue data and title in engagement data**
   - No duplicate fund in the primary id column.

#### 4. **Flitering out irrelevant data**
   - Remove irrelevant data in the release date (any year below 2019) column and availability columns in engagement dataset
   
## Exploratory Data Analysis (EDA)
Exploratory data analysis (EDA) conducted on the Netflix revenue and engagement data to understand the data's structure, identify trends and patterns, and inform the development of the Tableau dashboards to answer key questions, such as: 
   - What are the key trends in Netflix's global streaming revenue and membership growth?
   - How does revenue performance vary across different regions (UCAN, EMEA, LATM, APAC)?
   - What are the global content viewing patterns and engagement trends for movies vs. TV shows?
   - Which content types are driving the most viewership and watch time globally?
   - How is the average runtime of Netflix content trending, and does it differ between movies and TV shows?
   - What are the top 10 most viewed movies and TV shows globally (based on hours viewed)?"

**Data Overview and Summary Statistics**

Initial exploration involved examining the structure of both the revenue data and engagement datasets. Summary statistics (mean, median, min, max, quartiles) were calculated for key metrics, including:

Revenue Data: streaming_revenue, members, arpu, streaming_revenue_growth_rate, membership_growth_rate, arpu_growth_rate (by region).

Engagement Data: clean_title, hours_viewed, views, runtime_min.

## Data Analysis and Visualisation

   - R: [Data analysis]
   - Tableau: [Data Visualisation]
   
     

---
