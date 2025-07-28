#title: API.R
#author: Holly Probasco
#

library(plumber)

#* @apiTitle ST 558 Project 3
#* @apiDescription This API will work with the best fit model found in the Modeling.qmd file

#* Use the best model with different predictors
#* @get /predict
#* @param Health_level excellent verygood good fair or poor
#* @param BP_lvl no or high
#* @param BMI:numeric input numeric for BMI
function(Health_level = "verygood", BP_lvl = "no", BMI = 28.38) {
    pred_data <- data.frame(Health_level,BP_lvl,BMI)
    
    prediction <- predict(rf_final_fit, pred_data, type = "prob")
    
    return(prediction) }

#* API information
#* @get /info
function() {
  list(
    api_name = "My Plumber API",
    github_url = 
  )
}
