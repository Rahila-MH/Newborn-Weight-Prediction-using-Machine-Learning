#test


# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(corrplot)
library(caret)
library(tibble)
library(purrr)
library(DescTools)

# Load data -------------------------------------------------------------

newborn_train <- read.csv("data/newborn_train.csv")
newborn_test <- read.csv("data/newborn_test.csv")


### TRAIN DATASET 

# # Converting to factor class - NOMINAL ----------------------------------

cols_nominal <- c("mother_marital_status", "mother_race", "previous_cesarean", "newborn_gender", "prenatal_care_month")
newborn_train[cols_nominal] <- lapply(newborn_train[cols_nominal], factor)
newborn_test[cols_nominal] <- lapply(newborn_test[cols_nominal], factor)

newborn_train$father_education <- factor((newborn_train$father_education), 
                                         levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                         labels = c("8th grade or less", "9-12th grade, no diploma", "High school graduate or GED completed",
                                                    "Some college credit but no degree", "Associate degree", "Bachelor’s degree",
                                                    "Master’s degree", "Doctorate or Professional degree", "unknown"),
                                         ordered = TRUE)
#test
newborn_test$father_education <- factor((newborn_test$father_education), 
                                        levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                        labels = c("8th grade or less", "9-12th grade, no diploma", "High school graduate or GED completed",
                                                   "Some college credit but no degree", "Associate degree", "Bachelor’s degree",
                                                   "Master’s degree", "Doctorate or Professional degree", "unknown"),
                                        ordered = TRUE)
# # Converting to factor class - ORDINAL ----------------------------------

newborn_train$cigarettes_before_pregnancy <- ifelse(newborn_train$cigarettes_before_pregnancy==0,0,1)
newborn_train$cigarettes_before_pregnancy <- as.factor(newborn_train$cigarettes_before_pregnancy)
#test
newborn_test$cigarettes_before_pregnancy <- ifelse(newborn_test$cigarettes_before_pregnancy==0,0,1)
newborn_test$cigarettes_before_pregnancy <- as.factor(newborn_test$cigarettes_before_pregnancy)

#  Imputing missing values -----------------------------------------------

# with median

newborn_train <- newborn_train %>%
  mutate(
    father_age = if_else(is.na(father_age), median(newborn_train$father_age, na.rm = TRUE), father_age),
    mother_height = if_else(is.na(mother_height), median(newborn_train$mother_height, na.rm = TRUE), mother_height),
    mother_weight_gain = if_else(is.na(mother_weight_gain), median(newborn_train$mother_weight_gain, na.rm = TRUE), mother_weight_gain),
    mother_body_mass_index = if_else(is.na(mother_body_mass_index), median(newborn_train$mother_body_mass_index, na.rm = TRUE), mother_body_mass_index)
  )

#  with mode

mode_value <- names(which.max(table(newborn_train$mother_marital_status)))
newborn_train$mother_marital_status <- ifelse(is.na(newborn_train$mother_marital_status), mode_value, newborn_train$mother_marital_status)

# Drop rows with NA values in the variables with low % of missing values 
newborn_train <- newborn_train[complete.cases(newborn_train$cigarettes_before_pregnancy, newborn_train$number_prenatal_visits, newborn_train$mother_delivery_weight), ]

# CATEGORICAL VARIABLES ---------------------------------------------------

categorical_vars <- sapply(newborn_train, function(x) is.factor(x) || is.character(x))
cat_var_names <- names(newborn_train[categorical_vars])

# List of numeric variables -----------------------------------------------

newborn_numeric_vars <- 
  sapply(newborn_train, is.numeric) %>% 
  which() %>% 
  names()


# Qualitative (categorical) variables -------------------------------------

newborn_categorical <- 
  sapply(newborn_train, is.factor) %>% 
  which() %>% 
  names()


newborn_all_variables <- names(newborn_train)

#exclude those with near-zero variance - cigarettes_before_pregnancy)
newborn_all_variables <- 
  newborn_all_variables[-which(newborn_all_variables == "cigarettes_before_pregnancy")]

#exclude Multicollinearity: mother_body_mass_index

newborn_all_variables <- 
  newborn_all_variables[-which(newborn_all_variables == "mother_body_mass_index")]


# Feature Scaling - Standardization

newborn_train$mother_body_mass_index <- as.numeric(newborn_train$mother_body_mass_index)
newborn_train$father_age <- as.numeric(newborn_train$father_age)

newborn_train[, c(1, 3, 5:7, 11, 14)] <- scale(newborn_train[, c(1, 3, 5:7, 11, 14)])


# Data partition -------------------------------------------------


newborn_train_which_training <- createDataPartition(newborn_train$newborn_weight,
                                                    p = 0.75, 
                                                    list = FALSE) 

newborn_train_train <- newborn_train[c(newborn_train_which_training),]
newborn_train_test <- newborn_train[-c(newborn_train_which_training),]


regressionMetrics <- function(real, predicted) {
  # Mean Absolute Percentage Error
  MAPE <- mean(abs(real - predicted)/real)
  result <- data.frame(MAPE)
  return(result)
}





# RIDGE REGRESSION -------------------------------------------------------------------


newborn_numeric_vars <- 
  newborn_numeric_vars[-which(newborn_numeric_vars %in%
                                c("newborn_weight", 
                                  "mother_body_mass_index"))]


#Define cross-validation to find the optimal value of the lambda parameter
ctrl_cv5 <- trainControl(method = "cv",
                         number = 5)
lambdas <- exp(log(10)*seq(-2, 9, length.out = 200))
parameters_ridge <- expand.grid(alpha = 0, # ridge 
                                lambda = lambdas)



set.seed(123456789)
newborn_ridge <- train(newborn_weight ~ .,
                       data = newborn_train %>% 
                         dplyr::select(all_of(newborn_all_variables)),
                       method = "glmnet", 
                       tuneGrid = parameters_ridge,
                       trControl = ctrl_cv5)



regressionMetrics(real = newborn_train_train$newborn_weight,
                  predicted = predict(newborn_ridge)) #0.0445 MAPE
regressionMetrics(real = newborn_train_test$newborn_weight,
                  predicted = predict(newborn_ridge, newdata=newborn_train_test)) #0.07165 MAPE 


output_pred <- predict(newborn_ridge, newborn_test)
write.csv(output_pred, file="regression_predictions.csv")













