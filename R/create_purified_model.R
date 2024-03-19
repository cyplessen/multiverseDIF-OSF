#' Calculate Purified Models
#'
#' This function estimates purified models by removing flagged items and re-estimating the parameters. It is used in the context of item response theory (IRT) to address differential item functioning (DIF).
#'
#' @param data A dataframe containing item response data and country information.
#' @param group_levels A vector specifying the levels for the grouping (factor), typically representing different countries.
#' @param hf_2_parameter_vector A string indicating the type of parameter vector to use, either "parameters_multigroup" or "parameters_promis".
#' @param flagged_items A vector of item names that have been flagged for exclusion in the model estimation.
#' @param param Additional parameters to be used if hf_2_parameter_vector is "parameters_promis".
#'
#' @return Returns the factor scores from the estimated model after the flagged items have been removed.
#'
#' @export
#' @importFrom mirt multipleGroup 
#' @importFrom mirt fscores 
#' @importFrom mirt mod2values 
#' @importFrom mirt expected.test 
create_purified_model <- function(data, group_levels, hf_2_parameter_vector, flagged_items, param) {
  
  # remove flagged items from data
  data_purified <- data[, !colnames(data) %in% flagged_items]
  
  # create group vector
  group <- factor(data_purified$country, levels = group_levels)
  
  #  estimate models for non-flagged items
  if (hf_2_parameter_vector == "parameters_multigroup") {
    
    model_purified <- mirt::multipleGroup(data_purified[, -c(1:3)],  # same as baseline #minus DIF items
                                          group = group,
                                          model=1,
                                          itemtype="graded",                                            
                                          invariance=c('slopes',
                                                       'intercepts',
                                                       'free_vars',
                                                       'free_means'))
    
  } else if (hf_2_parameter_vector == "parameters_promis") {
    
    model_purified <- multipleGroup(data_purified[, -c(1:3)], 
                                    group=group, 
                                    model=1, 
                                    itemtype="graded", 
                                    pars = param)
  }
  # Create and return the purified_model list similar to baseline_model
  theta_values <- mirt::fscores(model_purified)
  return(list(
    model = model_purified, # corrected model
    parameter = mirt::mod2values(model_purified),
    thetas = theta_values,
    theta_se = mirt::fscores(model_purified, full.scores.SE = TRUE)[, "SE_F1"] %>% as.vector(),
    ets = mirt::expected.test(model_purified, Theta = theta_values, group = 1)
  ))
}
