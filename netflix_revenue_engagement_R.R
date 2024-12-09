#data importation
install.packages(c("DBI", "odbc")) # If not already installed
library(DBI)
library(odbc)

con <- DBI::dbConnect(odbc::odbc(),
                      Driver       = "ODBC Driver 17 for SQL Server", # Or the exact name from ODBCAD32
                      Server       = "DESKTOP-T4V4HVU",  # Or just your_server_name
                      Database     = "netflix_project",
                      Trusted_Connection = "yes",
                      Port = 1433
)


netflix_revenue <- dbGetQuery(con, "SELECT * FROM cleaned_netflix_revenue_by_region")
netflix_engagement <- dbGetQuery(con, "SELECT * FROM quarterly_netflix_engagement")  
netflix_engagement_title <- dbGetQuery(con, "SELECT * FROM netflix_combine_data")
dbDisconnect(con)

##Initial data exploration and cleaning
# View the first few rows
head(netflix_revenue)
head(netflix_engagement)
head(netflix_engagement_title )

# View the last few rows
tail(netflix_revenue)
tail(netflix_engagement)
tail(netflix_engagement_title)

# Get the dimensions (rows and columns)
dim(netflix_revenue)
dim(netflix_engagement)
dim(netflix_engagement_title)

# Get the structure (data types of each column)
str(netflix_revenue)
str(netflix_engagement)
str(netflix_engagement_title)

#convert year to factors data type
netflix_engagement$years <- as.factor(netflix_engagement$years)

# Summary statistics (mean, median, quartiles, etc.)
summary(netflix_revenue)
summary(netflix_engagement)
summary(netflix_engagement_title)

# Check for missing values in each column
colSums(is.na(netflix_revenue))  
colSums(is.na(netflix_engagement))
colSums(is.na(netflix_engagement_title))          # NA values found in the title column

##Data transformation

#Handling NA
#Remove rows where title_clean is NA
 netflix_engagement_title <- netflix_engagement_title %>%
      filter(!is.na(title))
 
#creating a coumn for quarters with Q1...
library(lubridate) # For working with dates

netflix_revenue$quarter <- paste0("Q", quarter(netflix_revenue$dates), " ", year(netflix_revenue$dates))

netflix_revenue$quarter <- factor(netflix_revenue$quarter, levels = unique(netflix_revenue$quarter)) # Convert to an ordered factor


# Check the newly created column
head(netflix_revenue)

#seperating the quarter column to have quarter_label different from year
library(tidyr)  # For separating columns

netflix_revenue <- netflix_revenue %>%
  separate(quarter, into = c("quarter_label", "year"), sep = " ")

#convert year columns to numeric for netflix_revenue_long and netflix_engagement
netflix_revenue_long$year <- as.numeric(netflix_revenue_long$year)
netflix_engagement$year <- as.numeric(netflix_engagement$year)

#checking newly created separated column
head(netflix_revenue)


#Cleaning the tv show and movie title 
library(dplyr) # Ensure dplyr is loaded
netflix_engagement_title <- netflix_engagement_title %>%
       mutate(title_clean = str_replace_all(title, "[^\\x00-\\x7F]+", "")) %>% # Remove non-ASCII characters
       mutate(title_clean = str_replace_all(title_clean, "[[:punct:]]+", "")) # Remove punctuation
netflix_engagement <- netflix_engagement %>%
  mutate(quarter = case_when(
    quarters == 1 ~ paste0("Q1 ", years),
    quarters == 2 ~ paste0("Q2 ", years),
    quarters == 3 ~ paste0("Q3 ", years),
    quarters == 4 ~ paste0("Q4 ", years),
    TRUE ~ NA_character_
  )) %>%
  separate(quarter, into = c("quarter_label", "year"), sep = " ", remove = FALSE) # Keep original quarter column

netflix_engagement$quarter <- factor(netflix_engagement$quarter, levels = unique(netflix_engagement$quarter)) # Convert to an ordered factor

#calculating avg view per title and average hours viewed per title
# For netflix_engagement
netflix_engagement <- netflix_engagement %>%
  mutate(avg_views_per_title = total_views / no_content_type,
         avg_hours_viewed_per_title = total_hours_viewed / no_content_type)


library(bit64)  # Load the package

# Now your code should work:
netflix_revenue <- netflix_revenue %>%
  mutate(across(where(is.integer), as.numeric)) %>% # Convert standard integers
  mutate(across(where(~inherits(.x, "integer64")), as.numeric)) # Convert integer64 (from bit64)

# ... rest of your reshaping and transformation code

#seperating the region to a new column
netflix_revenue_long <- netflix_revenue %>%
  pivot_longer(cols = starts_with(c("ucan_", "emea_", "latm_", "apac_")),
               names_to = c("region", "metric"),
               names_sep = "_",
               values_to = "value") %>%  # Correctly specify values_to
  pivot_wider(names_from = metric, values_from = value)

#renaming the streaming column
netflix_revenue_long<- netflix_revenue_long %>%
  rename(streaming_revenue = streaming) # New name = old name


##calculating variables
# Calculate growth rates (Make sure to sort by year and quarter before this step)
netflix_revenue_long <- netflix_revenue_long %>% 
  arrange(year, quarter_label) %>%
  group_by(region) %>%
  mutate(streaming_revenue_growth_rate = (streaming_revenue - lag(streaming_revenue)) / lag(streaming_revenue) * 100,
         membership_growth_rate = (members - lag(members)) / lag(members) * 100,
         arpu_growth_rate = (arpu - lag(arpu)) / lag(arpu) * 100) %>%
  ungroup()

#change the growth rates column to percentage
netflix_revenue_long <- netflix_revenue_long %>%
  mutate(streaming_revenue_growth_rate_formatted = sprintf("%.2f%%", streaming_revenue_growth_rate),
         membership_growth_rate_formatted = sprintf("%.2f%%", membership_growth_rate),
         arpu_growth_rate_formatted = sprintf("%.2f%%", arpu_growth_rate))



netflix_engagement <- netflix_engagement %>%
     select(-quarter, -years, -quarters) # Remove the "quarters" column

# if your quarters are represented as "Q1", "Q2", etc. (strings)
# and you want them sorted correctly, you can convert to an ordered factor first:


netflix_engagement$quarter_label <- factor(netflix_engagement$quarter_label, levels = c("Q1", "Q2", "Q3", "Q4"))

netflix_engagement <- netflix_engagement %>%
  arrange(year, quarter_label)

# Then export the data
write.csv(netflix_revenue_long, "netflix_revenue_long.csv", row.names = FALSE)
write.csv(netflix_engagement, "netflix_engagement.csv", row.names = FALSE)



