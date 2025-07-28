#title: API.R
#author: Holly Probasco
#

library(plumber)

# our best model fit to the entire dataset
final_model_api <- readRDS("final_model.rds")

# read in data that we need
diabetes_data_LR <- read_csv("diabetes_binary_health_indicators_BRFSS2015.csv") |> 
  drop_na() |> 
  mutate(BP_lvl = factor(if_else(HighBP == 0, "no", "high")), 
         Chol_lvl = factor(if_else(HighChol == 0, "no", "high")), HeartDA = factor(if_else(HeartDiseaseorAttack == 0, "no", "yes")), 
         Sex = factor(if_else(Sex == 0, "F", "M")), Diabetes = factor(if_else(Diabetes_binary == 0, "no", "yes")), 
         Smoking_status = factor(if_else(Smoker == 0, "no", "yes")), 
         Health_level = case_when(
  GenHlth == "1" ~ "excellent",
  GenHlth == "2" ~ "verygood",
  GenHlth == "3" ~ "good",
  GenHlth == "4" ~ "fair",
  GenHlth == "5" ~ "poor",
  .default = "NA" )) |>
  mutate(Health_level = factor(Health_level, levels = c("excellent", "verygood", "good", "fair", "poor"),ordered = TRUE)) |> 
  select(Diabetes, BMI, BP_lvl, Chol_lvl, HeartDA, Sex, Smoking_status, Health_level)


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
#* @post /pred
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


