
install.packages("tidyverse")
library(tidyverse)
install.packages("usethis")
library(usethis) 
library(readr)


library(here)
here()

rawdat <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)

# Subset the data to have only the variables Country.Name, X2000 – X2019

library(tidyverse)

cleandat <- rawdat %>%
  select(Country.Name, X2000:X2019)

# Convert the data set into a long format

cleandat <- cleandat %>%
  pivot_longer(cols = X2000:X2019, names_to = "Year", values_to = "MatMor") %>%
  mutate(Year = as.numeric(sub("^X", "", Year)))

head(cleandat, 20)
tail(cleandat, 20)

# Check if the year variable is stored as numeric 

print(is.numeric(cleandat$Year))

# Output results into different sub-folder

write.csv(cleandat, here("data", "clean_maternalmortality_data.csv"), row.names = FALSE)


