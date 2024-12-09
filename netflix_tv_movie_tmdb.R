# Installing necessary packages
install.packages("httr")        # For making API requests
install.packages("dplyr")       # For data manipulation
install.packages("readr")       # For reading CSV files
install.packages("jsonlite")    # For handling JSON responses

library(httr)
library(dplyr)
library(readr)
library(jsonlite)
library(purrr)


--Load your CSV file
netflix_tv <- read_csv("Netflix_tv_engagement_report_clean.csv")
netflix_tv <- read_csv("Netflix_tv_engagement_report_clean.csv")

--Inspecting the first few rows of the dataset
head(netflix_tv)
head(netflix_movie)

--assigning API key
api_key <- "b80ca36f7680ada40fba2e19e9bad8c5"

--Fetching first_air_date from the TMDb tv show search URL
get_tmdb_data <- function(title, api_key) {
  # Trying different title formats without 'Season X'
  variations <- c(title, gsub(":.*", "", title), gsub("Season.*", "", title))
  
  # Trying to fetch data for each variation
  for (var in variations) {
    url <- paste0("https://api.themoviedb.org/3/search/tv?api_key=", api_key, "&query=", URLencode(var))
    response <- fromJSON(url)
    
    # Checking if the results contain data
    if (length(response$results) > 0) {
      # Look for exact match based on the current 'title'
      exact_match <- response$results[response$results$original_name == title, ]
      
      # prioritising an actual match first
      if (nrow(exact_match) > 0) {
        first_air_date <- exact_match$first_air_date[1]
        return(data.frame(title = title, first_air_date = first_air_date))
      }
      
      # prioritizing the result with the highest popularity
      best_match <- response$results[which.max(response$results$popularity), ]
      first_air_date <- best_match$first_air_date
      
      # condition to return date if a valid first_air_date has been found
      if (!is.null(first_air_date)) {
        return(data.frame(title = title, first_air_date = first_air_date))
      }
    }
  }
  
  # condition to return NA for the first_air_date if no match found
  return(data.frame(title = title, first_air_date = NA))
}


-- updating missing release dates
for (i in 1:nrow(netflix_tv)) {
  if (is.na(netflix_tv$release_date[i])) {
    # Fetching missing release date using get_tmdb_data
    result <- get_tmdb_data(netflix_tv$title[i], api_key)
    
    # Updating the 'release_date' column if a valid date is fetched
    if (!is.na(result$first_air_date)) {
      netflix_tv$release_date[i] <- result$first_air_date[1]
    }
  }
}

--Checking the updated dataset
head(netflix_tv)  # View the first few rows after updating

--Fetching release_date from the TMDb movie search URL
get_tmdb_data <- function(title, api_key) {
  # remeving 'Season ' , any other non-alphabetical characters and spaces
  variations <- c(title, gsub(":.*", "", title), gsub("Season.*", "", title))
  
  # fetching data for each variation
  for (var in variations) {
    url <- paste0("https://api.themoviedb.org/3/search/movie?api_key=", api_key, "&query=", URLencode(var))
    response <- fromJSON(url)
    
    # Checking if the results contains data
    if (length(response$results) > 0) {
      # Look for exact match based on the current 'title'
      exact_match <- response$results[response$results$original_name == title, ]
      
      # # prioritising an actual match first
      if (nrow(exact_match) > 0) {
        release_date <- exact_match$release_date[1]
        return(data.frame(title = title, release_date = release_date))
      }
      
      # condition to return date if a valid first_air_date has been found
      best_match <- response$results[which.max(response$results$popularity), ]
      release_date <- best_match$release_date
      
      # If a valid first_air_date is found, return it
      if (!is.null(first_air_date)) {
        return(data.frame(title = title, release_date = release_date))
      }
    }
  }
  
  # condition to return date if a valid first_air_date has been found
  return(data.frame(title = title, release_date = NA))
}


-- updating missing release dates
for (i in 1:nrow(netflix_movie)) {
  if (is.na(netflix_movie$release_date[i])) {
    # Fetch missing release date using get_tmdb_data
    result <- get_tmdb_data(netflix_movie$title[i], api_key)
    
    # Updating the release_date column if a valid date is fetched
    if (!is.na(result$release_date)) {
      netflix_movie$release_date[i] <- result$release_date[1]
    }
  }
}

# Check the updated dataset
head(netflix_movie)  # View the first few rows after updating
