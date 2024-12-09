# Install necessary packages
install.packages("httr")        # For making API requests
install.packages("dplyr")       # For data manipulation
install.packages("readr")       # For reading CSV files
install.packages("jsonlite")    # For handling JSON responses

library(httr)
library(dplyr)
library(readr)
library(jsonlite)
library(purrr)


# Load your CSV file
netflix_tv <- read_csv("Netflix_tv_engagement_report_clean.csv")

# Inspect the first few rows of the dataset
head(netflix_tv)

# Replace with your actual TMDb API key
api_key <- "b80ca36f7680ada40fba2e19e9bad8c5"

get_tmdb_data <- function(title, api_key) {
  # Try different title formats without 'Season X'
  variations <- c(title, gsub(":.*", "", title), gsub("Season.*", "", title))
  
  # Try fetching data for each variation
  for (var in variations) {
    url <- paste0("https://api.themoviedb.org/3/search/tv?api_key=", api_key, "&query=", URLencode(var))
    response <- fromJSON(url)
    
    # Check if 'results' contains data
    if (length(response$results) > 0) {
      # Look for exact match based on the current 'title'
      exact_match <- response$results[response$results$original_name == title, ]
      
      # If an exact match is found, prioritize it
      if (nrow(exact_match) > 0) {
        first_air_date <- exact_match$first_air_date[1]
        return(data.frame(title = title, first_air_date = first_air_date))
      }
      
      # If no exact match, check the results for the best match (e.g., based on popularity or first_air_date)
      # Here we prioritize the result with the highest popularity (this can be changed)
      best_match <- response$results[which.max(response$results$popularity), ]
      first_air_date <- best_match$first_air_date
      
      # If a valid first_air_date is found, return it
      if (!is.null(first_air_date)) {
        return(data.frame(title = title, first_air_date = first_air_date))
      }
    }
  }
  
  # If no matches found, return NA for the first_air_date
  return(data.frame(title = title, first_air_date = NA))
}


# Assuming 'netflix_tv' is your dataset with 'title' and 'release_date'
tv_show_titles <- netflix_tv$title

# Now loop through and update missing release dates
for (i in 1:nrow(netflix_tv)) {
  if (is.na(netflix_tv$release_date[i])) {
    # Fetch missing release date using get_tmdb_data
    result <- get_tmdb_data(netflix_tv$title[i], api_key)
    
    # Update the 'release_date' column if a valid date is fetched
    if (!is.na(result$first_air_date)) {
      netflix_tv$release_date[i] <- result$first_air_date[1]
    }
  }
}

# Check the updated dataset
head(netflix_tv)  # View the first few rows after updating
