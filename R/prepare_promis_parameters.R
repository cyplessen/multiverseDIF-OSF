#' Prepare PROMIS Parameters for Multigroup IRT Model
#'
#' This function prepares PROMIS parameters for use with a multigroup item response theory (IRT) model. It involves filtering parameters and transforming them to the mirt convention.
#'
#' @param pars A dataframe containing the initial parameter set.
#' @param pf_items A vector of item IDs to be included in the analysis.
#' @param data A dataframe containing the complete dataset including country and item response data.
#'
#' @return A dataframe of the prepared parameters for the multigroup IRT model.
#'
#' @importFrom dplyr filter mutate select arrange if_else all_of
#' @importFrom mirtCAT generate.mirt_object
#' @importFrom mirt traditional2mirt
#' @importFrom tidyr pivot_longer
#' @export

prepare_promis_parameters <- function(pars, 
                                      pf_items, 
                                      data) { # formerly dat_usa_ger_arg
  
  # Filter parameters for specified items
  parameters_promis <- dplyr::filter(pars, ID %in% pf_items)
  
  # Transform from traditional to mirt convention
  parameters_promis_for_mirt <- mirt::traditional2mirt(parameters_promis[,-1], 
                                                 cls = "graded", 
                                                 ncat = 5)
  
  # Generate mirt model object from parameters
  model_from_parameters_promis <- mirtCAT::generate.mirt_object(parameters_promis_for_mirt, 
                                                       itemtype = "graded")
  
  # Factorize group variable
  group <- factor(data$country, 
                  levels = c("usa", "ger", "arg")) 
  
  # Generate initial data using multipleGroup
  initial_data <- mirt::multipleGroup(data[, pf_items], 
                                      group = group, 
                                      model = 1, 
                                      itemtype = "graded", 
                                      pars = "values") # parameter table
  
  # Store column names
  table_names <- names(initial_data)
  
  # Prepare initial parameters
  initial_parameters <- parameters_promis_for_mirt %>% 
    dplyr::mutate(item = pf_items) %>% 
    tidyr::pivot_longer(cols = c("a1", "d1", "d2", "d3", "d4"), names_to = "name")
  
  # Join initial data with parameters
  initial_joined_data <- dplyr::left_join(initial_data, initial_parameters, by = c("item", "name"))
  
  # Finalize parameters
  parameters_promis <- initial_joined_data %>% 
    dplyr::mutate(value = dplyr::if_else(is.na(value.y), value.x, value.y),
                  est = FALSE) %>% 
    dplyr::select(dplyr::all_of(table_names)) %>% 
    dplyr::arrange(parnum)
  
  return( parameters_promis)
}