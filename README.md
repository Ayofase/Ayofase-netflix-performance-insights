# Netflix Streaming Performance (2019-2024): A Data-Driven Analysis of Revenue, Membership, and Content Engagement Trends

## Project Overview
This project analyzes Netflix's streaming performance, focusing on revenue trend, membership growth and content engagment over the years 2019 to 2024. The Netflix revenue datasets includes key metrics such as global streaming revenue, regional streaming revenue, membership growth, and ARPU (Average Revenue Per User) for different regions: UCAN, EMEA, LATM, and APAC while it provides insights into Netflix's streaming revenue and content engagement performance.

## Table Of Content
  - [Project Goals](#project-goals)
  - [Data source](#data-source)
  - [Tools](#tools)
  - [Data Cleaning](#data-cleaning)
  - [Exploratory Data Analysis](#exploratory_data_analysis)
  - [Data Analysis and Visualisation](#data_analysis_and_visualisation)
  - [Results](#results)
  - [Recommendation](#recommendation)

### Project Goals:

Identify Key Revenue Drivers: Explore trends in streaming revenue, ARPU (Average Revenue Per User), and membership growth, both globally and regionally. 

Analyze Content Performance: Examine viewer engagement metrics (total views, total hours viewed, average runtime) to understand content consumption patterns and identify top-performing movies and TV shows. Note the engagement metric has no regional data.

Inform Content Strategy: Provide data-driven insights to inform Netflix's content acquisition and production decisions, focusing on maximizing viewership and engagement.

Develop an Interactive Dashboard: Create a user-friendly Tableau Public dashboard that allows stakeholders to explore the data dynamically, uncover key trends and insights, and make data-informed decisions about revenue, user base growth, and content acquisition/creation strategies.

### Data source
Revenue data: This dataset used for the analysis is gotten from Kaggle, contains detailed information of quarterly revenue, membership, and ARPU figures, broken down by region (UCAN, EMEA, LATM, APAC) from 2019 to 2024 first quarter.

Engagement data: This dataset was downloaded from [Netflix](https://about.netflix.com/en/news/what-we-watched-the-first-half-of-2024), contains detailes information of aggregated viewership metrics (total views, total hours viewed, and runtime) for individual movies and TV shows. This dataset does not contain regional data, limiting regional analysis to revenue metrics.

UACN : United States and Canada
EMEA : Europe, Middle East and Africa
APAC : Asia-Pacific
LATM : Latin America
ARPU : Average revenue per member.
Currency: US Dollars

### Tools
- Excel
- SQL Server
- R 
- Tableau

## Data Cleaning
Data cleaning process with the use of Excel, [SQL](netflix_data_cleaning_and_quality_checks.sql) and [R](netflix_revenue_engagement_R.R) to critical ensure good data quality and consistency before analysis. Below are the steps used for cleaning and preparing the dataset

#### 1. **Handling Missing Values**
   - Using Conditional Formatting in Microsoft Excel to highlight missing values. 9,836 missing release date data where found for both tv show and movies data with a total row number of 16,163
   - **TMDb API Integration:**
Missing release dates for movies and tv shows were retrieved using the TMDb API. [R](#netflix_tv_movie_tmdb.R) was implemented to perform this integration using the `httr` package for making API requests and the `jsonlite` package for parsing JSON responses from the TMDb API. If no matches were found for a title the corresponding release date field for that title was set to NA. 
#### 2. **Standardize Data Types**
   - Date column standardise to date format.
   - Remove commas from numeric column (eg. Streaming_revenue and hours_viewed) in the revenue and engagement dataset for consistency
   - Standardise all column title to text.
   - Replace column name from CamelCase to snake_case.
#### 3. **Remove Duplicates in the primary id column, date in revenue data and title in engagement data**
   - No duplicate fund in the primary id column.
#### 4. **Replacing NA**
   - Replace NA in the release_date column in the revenue data which was as a result of unmatched titles from TMDb API integration process.
#### 5. **Flitering out irrelevant data**
   - Remove irrelevant data in the release date (any year below 2019) column and availability columns in engagement dataset

   
## Exploratory Data Analysis (EDA)
Exploratory data analysis (EDA) conducted on the revenue and engagement data with the use of R to understand the data's structure, identify trends and patterns, and inform the development of the Tableau dashboards that answer key questions, such as: 
   - What are the key trends in global streaming revenue and membership growth?
   - How does revenue performance vary across different regions (UCAN, EMEA, LATM, APAC)?
   - What are the global content viewing patterns and engagement trends for movies vs. TV shows?
   - Which content types are driving the most viewership and watch time globally?
   - Does the runtime of movies and TV shows influence viewer engagement (total hours viewed) on Netflix, and how does this influence vary by content type? 
   - What are the top 10 most viewed movies and TV shows globally (based on hours viewed)?

**Data Overview and Summary Statistics**

Initial exploration involving examination of the structure of revenue data and engagement data. Summary statistics (mean, median, min, max, quartiles) were calculated for key metrics, including:

Revenue Data: streaming_revenue, members, arpu, streaming_revenue_growth_rate, membership_growth_rate, arpu_growth_rate (by region).
Engagement Data: clean_title, hours_viewed, views, runtime_min.

Further exploration using Tableau to visualize data for potential insights

## Data Analysis and Visualisation

   - R: [Data analysis](netflix_revenue_engagement_R.R)
   - Tableau: [Revenue Performance](https://public.tableau.com/app/profile/ayomide.fase2159/viz/Netflixrevenueandengagement/REVENUEARPUANALYSIS2019-2024?publish=yes) and 
              [Content Engagement](https://public.tableau.com/app/profile/ayomide.fase2159/viz/Netflixrevenueandengagement/CONTENTVIEWERSHIPANDENGAGEMENTTRENDS#3)

## Results
### Global Revenue, Membership and ARPU Performance 
Substantial growth in global streaming revenue and membership between Q1 2019 and Q1 2024. Global streaming revenue more than doubled, reaching $9.4 billion in Q1 2024, signifying strong financial performance. This impressive revenue growth was accompanied by a considerable rise in global membership, which peaked at 270 million subscribers in Q1 2024, a remarkable increase from 149 million in Q1 2019. 
While both revenue and membership experienced consistent growth, the pace of expansion varied. Notably, Q1 2024 saw the highest quarterly revenue and membership figures, with a quarterly revenue increase of approximately 31% and a substantial 15% surge in membership. Although the specific data is presented in the image below it suggest that  the growth both revenue and memberships peaked in Q1 2020 with a revenue increase of 33.6% and membership increase of 48.3%, consistent with when the global pandemic and lockdowns started leading to a boost in demand for home entertainment.  Global ARPU reached its highest point ($10.7) in Q1 2021, driven by a 4.66% quarterly increase, indicating effective pricing strategies 

![revenue_performance_chart](https://github.com/user-attachments/assets/0288f626-f184-417b-b3d5-087a4d4c86d4)


### Regional Revenue, Membership and ARPU Performance
   
 - UCAN: UCAN showed solid growth in both revenue and membership. Revenue kept getting stronger, hitting its highest point at 17.5% year-over-year growth in Q1 2024. Membership growth was flunctuating, with the biggest jump (4.6%) in Q2 2020, right when the COVID-19 lockdowns started. It seems like attracting new subscribers has become a bit tougher, even though the market is still performing well. ARPU has been generally increasing, with a big spike of 9.3% year-over-year growth in Q2 2019.
 -EMEA: EMEA initially showed strong performance, with both streaming revenue and membership experiencing substantial growth, peaking at 10.3% and 13.4% respectively, in Q1 2020. This aligns with the onset of the COVID-19 pandemic and suggests a significant impact from stay-at-home restrictions. The subsequent rise in ARPU, reaching a 4.6% year-over-year growth in Q1 2021, indicated successful monetization of these new subscribers. However, there was a notable decline in ARPU in Q4 2022 (-3.5%) that should spike some questions.
 - LATM: LATM's performance was a mixed bag. Revenue growth was at its best in Q3 2019 (9.5%) but wasnt stable after that. Membership also peaked in Q1 2020 at 9.2%. ARPU had good growth too, highest in Q3 2019 (6%).
 - APAC: APAC was the most interesting region, with big changes. Membership shot up a lot in Q1 2020 (22.2%), but the biggest revenue jump happened later, in Q1 2021 (11.4%). ARPU growth was there, but smaller and peaking at 4.2% in Q1 2021 alongside membership growth.
   
![regional revenue](https://github.com/user-attachments/assets/a2dfaf90-f718-405a-a0ad-49a2fef52adb)

### Content Performance Trend

 - Content Release and Engagement: Netflix significantly increased content releases in the latter half of 2022, with Q3 and Q4 seeing the highest volume. Q3 2022 had 203 movie releases and 191 TV show releases, while Q4 2022 saw a further increase to 212 movie releases and a consistent 191 TV show releases. This surge in content availability appears to have contributed to a substantial increase in overall viewership, culminating in peak engagement in Q1 2024.

 - Peak Engagement (Q1 2024): Total views and hours viewed reached their highest levels in Q1 2024. Movies achieved 985 million views and 1.7 billion hours viewed, while TV shows garnered an impressive 1.03 billion views and 6 billion hours viewed. (What specific factors might explain this exceptional performance in Q1 2024? Were there specific popular releases, marketing campaigns, or external factors influencing viewership? Analyzing trends immediately following Q1 2024 will help understand if this surge was sustained.)
   
![total contnt release, total views, total hours viewed](https://github.com/user-attachments/assets/2d648de7-5483-4a89-8a35-771e65685c76)


- Average Views per Title: The average views per title also peaked in Q1 2024, with movies averaging 9.3 million views per title and TV shows averaging a remarkable 7.8 million views per title. Investigating the titles released during this period and their genres can provide valuable insights into content preferences.

 - Runtime and Engagement: A scatter plot analysis reveals a positive correlation between average runtime and average hours viewed for both movies and TV shows. This suggests that, generally, longer content tends to accumulate more viewing hours. However, it's important to consider this trend in conjunction with the total views and average views per title. While longer runtimes might lead to higher total viewing hours, shorter, more easily consumable content might attract a broader audience and generate higher total views. Further analysis of specific genres and subgenres within movies and TV shows could help refine this understanding.

 - Top Performing Content: An analysis of the top 10 titles by hours viewed reveals a dominance of TV shows, with 5 of the top 5 spots occupied by series. Notably, "Bridgerton Season 3" leads with an impressive 734 million hours viewed and 91.9 million views, highlighting the popularity and binge-worthy nature of episodic content. Examining the characteristics of these top-performing titles (genre, themes, target audience) can offer valuable insights for Netflix's content strategy.
   
![avg views, avg hours viewed](https://github.com/user-attachments/assets/fcd1c722-6699-4383-b7ab-bf2d2a54e225)

## Recommendation
 1. Prioritize global membership growth: Expand into new markets and leverage targeted marketing campaigns informed by regional preferences.
 2. Optimize pricing strategies: Closely monitor ARPU trends and implement dynamic pricing models that balance subscriber acquisition and revenue maximization.
 3. Address EMEA's ARPU decline: Implement targeted promotions, invest in localized content, or adjust pricing strategies in the EMEA region.
 4. Maintain UCAN's growth: Continue investing in high-quality content tailored to the UCAN market.
 5. Maximize APAC's potential: Focus on content acquisition and production aligned with regional preferences and explore innovative ARPU growth strategies.
 6. Prioritize binge-worthy TV series: Invest in high-quality, long-form episodic content while optimizing runtime based on genre and audience.
 7. Replicate Q1 2024 success: Analyze the factors driving peak engagement and apply learnings to future content and marketing strategies.
 8. Diversify content offerings: Explore new genres, international productions, and niche content to expand audience reach and maximize engagement.



   
