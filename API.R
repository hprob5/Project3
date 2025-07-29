#title: API.R
#author: Holly Probasco
#

library(plumber)
library(tidymodels)
library(ranger)

# our best model fit to the entire dataset
final_model_api <- readRDS("final_model.rds")

# read in data that we need
diabetes_data_api <- readRDS("diabetes_data.rds")

# using the best model fit on the full data set to make predictions
overall_preds <- predict(final_model_api, new_data = diabetes_data_api, type = "prob")

#* @apiTitle ST 558 Project 3
#* @apiDescription This API will work with the best fit model found in the Modeling.qmd file

#* Use the best model with different predictors
#* @param Health_level excellent, verygood, good, fair or poor
#* @param BP_lvl no or high
#* @param BMI:numeric input numeric for BMI
#* @param Chol_lvl no or high
#* @param HeartDA no or yes
#* @param Sex M or F
#* @param Smoking_status no or yes
#* @get /pred
function(Health_level = "verygood", BP_lvl = "no", BMI = 28.38, Chol_lvl  = "no",
         HeartDA = "no", Sex = "F", Smoking_status = "no") {
  
    # specifying that BMI is a numeric variable so it doesn't try to convert
    BMI <- as.numeric(BMI) 
  
    pred_data <- data.frame(Health_level = Health_level, 
                            BP_lvl = BP_lvl, 
                            BMI = BMI, 
                            Chol_lvl = Chol_lvl,
                            HeartDA = HeartDA,
                            Sex = Sex, 
                            Smoking_status = Smoking_status)

    prediction <- predict(final_model_api, pred_data, type = "prob")
    
    return(list(prediction = prediction)) }

#* API information
#* @get /info
function() {
  list(
    api_name = "My Plumber API",
    githubpages_url = "https://hprob5.github.io/Project3/"
  )
}

# 3 example URLs
# http://localhost:8000/pred?Health_level=verygood&BP_lvl=no&BMI=28.38&Chol_lvl=no&HeartDA=no&Sex=F&Smoking_status=no

# http://localhost:8000/pred?Health_level=excellent&BP_lvl=no&BMI=28.38&Chol_lvl=no&HeartDA=no&Sex=M&Smoking_status=yes

# http://localhost:8000/pred?Health_level=good&BP_lvl=high&BMI=25&Chol_lvl=no&HeartDA=no&Sex=F&Smoking_status=no

