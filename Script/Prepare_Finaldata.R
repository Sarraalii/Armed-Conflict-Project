covs <- read.csv(here("original", "covariates.csv"), header = TRUE)

source(here("script", "Prepare_Mortality.R"))
source(here("script", "Prepare_Disaster.R"))
source(here("script", "Prepare_Conflict.R"))


disasters<- read_csv("Data/clean_disaster_data.csv")

# Change the variable name from "year" to "Year"

names(covariate_data)[names(covariate_data) == "year"] <- "Year"
names(confdata)[names(confdata) == "year"] <- "Year"
names(disasters)[names(disasters) == "year"] <- "Year"
disasters

#put all data frames into list
alllist <- list(covariate_data, confdata, disasters, clean_merged_mortality_data)

#merge all data frames in list
alllist |> reduce(left_join, by = c('ISO', 'Year')) -> finaldata

# need to fill in NAs with 0's for armconf1, drought, earthquake
finaldata <- finaldata |>
  mutate(armconf1 = replace_na(armconf1, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totdeath = replace_na(totdeath, 0))

write.csv(finaldata, file = here("data", "finaldata.csv"), row.names = FALSE)

dim(finaldata)
names(finaldata)
length(unique(finaldata$ISO))
