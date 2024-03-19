#' Prepare Regression Data
#'
#' Helper function to prepare data for regression analysis. This function extracts
#' specified items and demographic information from the dataset, computes theta scores
#' using a provided IRT model, and combines these into a new data frame for regression analysis.
#'
#' @param dat A data frame containing the dataset with sample IDs, country, age, and item responses.
#' @param items Item responses.
#' @param corrected_model An IRT model object created with reest_model().
#'
#' @return A data frame for regression analysis containing sample IDs, country, age, selected item responses, and theta scores.
#' @export
#'
prepare_regression_data <- function(dat, items, corrected_model) {
  
  reg_dat <- data.frame(sample_id = dat$sample_id, 
                        country = dat$country, 
                        age = dat$age,
                        dat[, names(items)], 
                        theta = fscores(corrected_model, full.scores=TRUE)[, "F1"])
  return(reg_dat)
}