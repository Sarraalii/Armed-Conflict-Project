
install.packages("dplyr")
install.packages("table1")
install.packages ('ggplot2')
library(ggplot2)
library(tidyverse)
library(table1)
library(dplyr)
library(here)

library(readr)
finaldata <- read_csv("Data/finaldata.csv")
View(finaldata)

df2 <- finaldata %>% filter(Year == 2000)



df2$OECD <- factor(df2$OECD)
df2$armed_conflict <- factor(df2$armconf1, levels = c(0, 1), labels = c("No Conflict", "Conflict"))

df2$drought <- factor(df2$drought, levels = c(0, 1), labels = c("No Drought", "Drought"))
df2$earthquake <- factor(df2$earthquake, levels = c(0, 1), labels = c("No Earthquake", "Earthquake"))
df2$OECD <- factor(df2$OECD, levels = c(0, 1), labels = c("No OECD", "OECD"))


label(df2$MatMort) <- "Maternal Mortality"
label(df2$urban) <- "% living in urban residence"
label(df2$armed_conflict) <- "Armed Conflict"
label(df2$drought) <- "Drought"
label(df2$male_edu) <- "Male Education"
label(df2$temp) <- "Temperature"
label(df2$popdens) <- "Population Density"
label(df2$earthquake) <- "Earthquake"
label(df2$agedep) <- "Age Dependency Ratio"


table1(~.-Year-ISO-country_name-OECD2023-region-infant_mort-neonatal_mort-under5_mort|armed_conflict, data = d2, caption = "Summary statistics for the year 2000") #take off region, bin code oecd, remove

# Create df3, a data frame containing the initial and final years of data for each country
df3 <- finaldata %>%
  group_by(ISO) %>%     # Group the data by country code (ISO)
  arrange(Year) %>%     # Arrange the data by year in ascending order
  filter(row_number() %in% c(1, n())) %>%  # Select the first and last rows for each group
  select(c(Year, MatMort, ISO)) %>%  # Select columns Year, MatMort, and ISO
  ungroup()  # Remove the grouping information

#  Arrange df3 by ISO
df4 <- df3 %>% arrange(ISO)

# Create df5, a data frame with differences in Maternal Mortality
df5 <- df4 %>%
  group_by(ISO) %>%  # Group the data by country code (ISO)
  mutate(diffs = MatMort - lag(MatMort)) %>%  # Calculate differences between consecutive years
  filter(diffs > 0) %>%  # Filter rows where differences are greater than 0 (indicating an increase)
  select(ISO)  # Select the ISO column

#  Create dfinal, a data frame with maternal mortality differences
dfinal <- finaldata |>
  dplyr::select(country_name, ISO, Year, MatMort) |>  # Select specific columns
  dplyr::filter(Year < 2018) |>  # Filter data for years before 2018
  arrange(ISO, Year) |>  # Arrange data by ISO and Year
  group_by(ISO) |>  # Group data by country code (ISO)
  mutate(diffmatmor = MatMort - MatMort[1L])  # Calculate differences from the initial year for each country

# Further filter dfinal to keep countries with an increase in maternal mortality in 2017
dfinal <- dfinal %>% filter(Year == 2017 & diffmatmor > 0)

# Create a line plot (fig1) of maternal mortality trends for selected countries
fig1 <- finaldata %>%
  filter(ISO %in% dfinal$ISO) %>%  # Filter to include only countries from dfinal
  ggplot(aes(x = Year, y = MatMort, col = ISO)) +  # Define the plot aesthetics
  geom_line(aes(group = ISO)) +  # Add lines for each country
  theme_minimal() +  # Apply a minimal theme to the plot
  labs(title = "Maternal mortality trends in countries that experienced a rise between 2000 and 2017", y = "Maternal Mortality Ratio")  # Set plot labels

#Save your plot on a new figures folder
ggsave(fig1, file = here("figures", "fig1_incmatmor.png"), width = 8, height = 5)

