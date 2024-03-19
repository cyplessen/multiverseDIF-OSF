#' Reestimate Model with Freed Item Parameters for Flagged Items
#'
#' This function re-estimates a multigroup model using mirt, specifically freeing 
#' parameters for items identified with differential item functioning (DIF). 
#' It assumes prior filtering of data for specific countries.
#'
#' @param flagged_items A vector of item names flagged for DIF.
#' @param dat Dataframe containing item response data and country information.
#' @param grouping_vector A vector of country names to be included in the analysis.
#' @param parameters A dataframe of initial model parameters.
#'
#' @return A multigroup model object with freed parameters for the flagged items.
#'
#' @export
#' @importFrom mirt multipleGroup
#' @seealso mirt::multipleGroup for the underlying model estimation.

reest_model <- function(flagged_items, dat, grouping_vector, parameters) {
  
  item_responses <- filter_items(dat, grouping_vector)
  
  group <- factor(dat$country, 
                  levels = grouping_vector)
  
  tmp_para <- parameters
  tmp_para$est[tmp_para$item %in% flagged_items | tmp_para$item == "GROUP"] = TRUE 
  
  mirt::multipleGroup(item_responses, 
                group = group,  
                model = 1, 
                itemtype="graded", 
                pars = tmp_para)
}