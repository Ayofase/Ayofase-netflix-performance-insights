# ayofase.github.io
# Subscriber Growth and User Engagement Analysis in the Streaming Industry: A Netflix Case Study (2019-2024)

## Project Overview
This project analyzes Netflix's subscriber growth and user engagement trends over the years 2019 to 2024. The dataset includes key metrics such as global revenue, regional streaming revenue, subscriber count, and ARPU (Average Revenue Per User) for different regions: UCAN, EMEA, LATM, and APAC.

The goal is to clean, analyze, and visualize Netflix's growth and user engagement to derive actionable insights.
## Data Cleaning in Microsoft Excel
The data cleaning process is critical for ensuring data quality and consistency before analysis. Below are the steps used to clean and prepare the dataset in **Microsoft Excel** for analysis.

### Step 1: Initial Data Inspection and Preparation

#### 1. **Check for Missing Values**
   - **Using Conditional Formatting to Highlight Missing Values**
     
   - **Using Filter to Find Missing Values**
   - No missing Values found.
#### 2. **Standardize Data Types**
   - **Date Column**:
     - Select the **Date** column.
     - Right-click > **Format Cells** > **Date** format.
     - Choose a consistent date format (e.g., `YYYY-MM-DD`).
     
   - **Revenue and ARPU Columns**:
     - Select the columns for **Global Revenue**, **Regional Revenues (UCAN, EMEA, LATM, APAC)**, and **ARPU**.
     - Right-click > **Format Cells** > **Currency** or **Accounting** for revenue columns and **Number** for ARPU.
     - Ensure that the currency columns have appropriate decimal places (e.g., 2 decimal places).
     
   - **Membership Columns**:
     - Select the **Memberships** columns (e.g., **UCAN Members**, **EMEA Members**, etc.).
     - Right-click > **Format Cells** > **Number** format, and ensure there are no decimals (whole numbers).
     
   - **Region Columns (e.g., UCAN, EMEA, LATM, APAC)**:
     - Ensure that these columns are formatted as **Text** to maintain consistency in the region names.

#### 3. **Remove Duplicates**
   - Select the entire dataset.
   - Go to the **Data** tab > **Remove Duplicates**.
   - In the dialog box that appears, check the **Date** column to remove duplicate rows based on the date.
   - Click **OK** to remove any duplicate rows.

---
