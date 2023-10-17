# Load your dataset (replace "your_data" with your dataset)
# For this example, we'll create a simple dataset with random data
set.seed(123)

install.packages("expss")
install.packages("tableone")
library(expss)
library(tableone)


# Create a subset for years from 2000 to 2017
tabledata <- finaldata[finaldata$Year >= 2000 & finaldata$Year <= 2017, ]

# Now, subset_final_data contains only the rows with years from 2000 to 2017



apply_labels(tabledata, 
             MatMort= "Maternal mortality ratio
per 100,000
live births",
             Under5Mort= "Under-5
mortality rate
per 1,000 live
births", 
             InfantMort= "Infant
             mortality rate
             per 1,000 live
             births",
             NeoMort= "
             Neonatal
             mortality rate
             per 1,000 live
             births" ,
             armconf1= "Armed conflict
exposure")






# Create a variable list which we want in Table 1
listVars <- c("NeoMort", "", "Cholesterol", "SystolicBP", "BMI", "Smoking", "Education")

# Define categorical variables
catVars <- c("Gender","Smoking","Education")

table1 <- CreateTableOne(vars = listVars, data = table_one_copy_1, factorVars = catVars, strata = c("Gender"))


a <- print(table1, quote = TRUE, noSpaces = TRUE)

as.data.frame(a)