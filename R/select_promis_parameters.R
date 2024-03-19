#' Select PROMIS Parameters
#'
#' This function processes item response data to estimate multigroup parameters using mirt. 
#' It filters the data for specified countries and returns a dataframe containing the estimated parameters.
#'
#' @param grouping_vector A vector of country names to be included in the analysis.
#' @param parameters_promis A dataframe of the prepared parameters for the multigroup IRT model.
#'
#' @return A dataframe with PROMIS item parameters for the specified countries.
#' @importFrom dplyr filter mutate
#'
#' @seealso mirt::multipleGroup for underlying model estimation.

select_promis_parameters <- function(parameters_promis, grouping_vector) {
  
  parameters_promis %>% 
    dplyr::filter(group %in% grouping_vector) %>% 
    dplyr::mutate(parnum = 1:nrow(.))
}