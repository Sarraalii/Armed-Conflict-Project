install.packages("naniar")
install.packages("VIM")
install.packages("finalfit")
library(naniar)
library(VIM)
library(finalfit)
install.packages("texreg")
library(texreg)
library(dplyr)

naniar::vis_miss(finaldata)
#recode iso to factor, it will be treated as character

VIM::aggr(finaldata, numbers = TRUE, prop = c(TRUE, FALSE))

finaldata$GDP1000<-finaldata$GDP/1000
finaldata$popdens100<-finaldata$popdens/100

preds<- as.formula(("~armconf1+ GDP1000+ popdens100 + 
                    urban +agedep+ male_edu + temp + earthquake +drought+ISO+as.factor(Year)"))

matmord <- lm(update.formula(preds, MatMort ~ .), data= finaldata)
print(matmord)

un5mormod <- lm(update.formula(preds, Under5Mort ~ .), data= finaldata)
print(un5mormod)

infomormod<-lm(update.formula(preds, InfantMort ~ .), data= finaldata)
print(infomormod)

neomormod<-lm(update.formula(preds, NeoMort ~ .), data= finaldata)

print(neomormod)
screenreg(list(matmord, un5mormod,infomormod, neomormod), 
       ci.force =TRUE, 
       custom.model.names= c("Maternal mortality", "Under-5 mortality","Infant mortality", "Neonatal mortality"),
       caption=" Results from linear regression models")
       


install.packages("mice")
library(mice)



# Load your dataset, assuming it's named 'final_data'
final_data <- read.csv("your_data.csv")  # Replace with the actual data file path or data loading code

# Convert 'ISO' back to a factor
finaldata$ISO <- as.numeric(factor(finaldata$ISO))
finaldata$ISO 

#remove country and region
finaldata1<-select(finaldata, -1, -3)

     

# Define the variables to impute

# Create a data frame with the variables to impute
data_to_impute <- finaldata1[,c("Year", "GDP1000", "male_edu", "temp", "totdeath", "MatMort", "InfantMort", "NeoMort", "Under5Mort", "urban", "agedep")]

# Now, use mice with the created data frame
mi0 <- mice(data_to_impute, seed = 1, m = 1, maxit = 0, print = FALSE)


VIM::aggr(finaldata1, numbers = TRUE, prop = c(TRUE, FALSE))


meth <- mi0$method
meth

mice.multi.out1 <- mice(finaldata1, seed = 1, m = 10, maxit = 20, method = meth, print = F)
mice.multi.out1$meth

#plot the 
plot(mice.multi.out1)

complete.data.multi1 <- complete(mice.multi.out1, "all")

## check the first imputed dataset
head(complete.data.multi1$`1`, 20)
pred <- mice.multi.out1$predictorMatrix
pred
pred[c("Year", "GDP1000", "male_edu", "temp", "totdeath", "MatMort", "InfantMort", "NeoMort", "Under5Mort", "urban", "agedep"), "ISO"] <- -2
pred


methods(mice)


meth["Year"] <- "2l.pan"
meth["GDP1000"] <- "2l.pan"
meth["male_edu"] <- "2l.pan"
meth["temp"] <- "2l.pan"
meth["totdeath"] <- "2l.pan"
meth["MatMort"] <- "2l.pan"
meth["InfantMort"] <- "2l.pan"
meth["NeoMort"] <- "2l.pan"
meth["Under5Mort"] <- "2l.pan"
meth["urban"] <- "2l.pan"


##fit analysis model and pool results 

# Load the mice package
library(mice)

# Fit the model using mice
infantmort2 <- with(mice.multi.out, 
                   lm(InfantMort ~ ISO + as.factor(Year) + GDP + popdens + OECD + urban + agedep + male_edu + temp + armconf1 + drought + earthquake, scale.fix = TRUE, corstr = "ar1")
)

# Pool the estimates using the mice package
pooled_estimates <- pool(infantmort2)
summary(pooled_estimates)

___


matmort2 <- with(mice.multi.out, 
                 lm(MatMort ~ ISO + as.factor(Year) + GDP + popdens + OECD + urban + agedep + male_edu + temp + armconf1 + drought + earthquake, scale.fix = TRUE, corstr = "ar1")
)
matmort_pooled <- pool(matmort2)
summary(matmort_pooled)

___
neomort2 <- with(mice.multi.out, 
                 lm(NeoMort ~ ISO + as.factor(Year) + GDP + popdens + OECD + urban + agedep + male_edu + temp + armconf1 + drought + earthquake, scale.fix = TRUE, corstr = "ar1")
)
neomort_pooled <- pool(neomort2)
summary(neomort_pooled)

___

under5mort2 <- with(mice.multi.out, 
                    lm(Under5Mort ~ ISO + as.factor(Year) + GDP + popdens + OECD + urban + agedep + male_edu + temp + armconf1 + drought + earthquake, scale.fix = TRUE, corstr = "ar1")
)
under5mort_pooled <- pool(under5mort2)
summary(under5mort_pooled)

library(usethis)
usethis::use_git()
