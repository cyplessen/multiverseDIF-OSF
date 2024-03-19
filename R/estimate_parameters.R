#' Estimate Parameters
#'
#' This function processes item response data to estimate multigroup parameters using mirt. 
#' It filters the data for specified countries and returns a dataframe containing the estimated parameters.
#'
#' @param dat A dataframe containing item responses and country information.
#'      It should include columns for each item and a column named 'country'.
#' @param grouping_vector A vector of country names to be included in the analysis.
#'
#' @return A dataframe with estimated multigroup parameters for the specified countries.
#'
#' @importFrom mirt mod2values
#' @importFrom mirt multipleGroup
#' @importFrom dplyr filter
#' @export
#' @seealso mirt::multipleGroup for underlying model estimation.

estimate_parameters <- function(dat, grouping_vector) {
  
  dat <- dat %>% dplyr::filter(country %in% grouping_vector)
  
  item_responses <- filter_items(dat, grouping_vector)
  
  group <- factor(dat$country, 
                  levels = grouping_vector)
  
  multigroup_baseline <- mirt::multipleGroup(
    item_responses, 
    group = group, 
    model=1, 
    itemtype="graded", 
    invariance=c('slopes', 
                 'intercepts', 
                 'free_vars',
                 'free_means'
    ))
  
  parameters_multigroup <- mirt::mod2values(multigroup_baseline) %>% 
    dplyr::mutate(est = FALSE)
  
  return(parameters_multigroup)
}