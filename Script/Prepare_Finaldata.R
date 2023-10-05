library(tidyverse)
library(here)

# Read in the covariate data

covariate_data <- read.csv(here("original", "covariates.csv"), header = TRUE)

# Change the variable name from "year" to "Year"

names(covariate_data)[names(covariate_data) == "year"] <- "Year"
names(conflict_data)[names(conflict_data) == "year"] <- "Year"
# Source the R scripts

source(here("Script", "Prepare_Conflict.R"))
source(here("Script", "Prepare_Disaster.R"))
source(here("Script", "Prepare_cleaning_function.R"))

# Merge all data frames in list

alllist <- list(covariate_data, conflict_data, cleandat, merged_data)
finaldata <- alllist |> reduce(left_join, by = c('ISO', 'Year'))

final_data<-alllist |> purrr::reduce(left_join, by = c('ISO', 'Year')) 
# Replace NA's with 0's

final_data <- final_data |>
  mutate(armed_conflict = replace_na(armed_conflict, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         best = replace_na(best, 0))

# Output results into different sub-folder

write.csv(final_data, file = here("data", "final_data.csv"), row.names = FALSE)

dim(final_data)
names(final_data)
length(unique(final_data$ISO))
