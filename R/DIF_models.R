#' Estimate Differential Item Functioning (DIF) Models Including Age
#'
#' This function extends the `DIF_models` function by including 'age' in the model estimation. 
#' It estimates logistic regression models for differential item functioning with respect to 'theta', 
#' 'country', and 'age' for a given item.
#'
#' @param item The name of the item variable as a string, e.g. PFM1
#' @param data The dataframe containing the item responses along with 'theta', 'country', and 'age' variables.
#'
#' @export
#' @return A list of model objects for full DIF, uniform DIF, and non-uniform DIF including the 'age' variable.
#' @importFrom rms lrm
#' 
#' @seealso rms::lrm() for the logistic regression model estimation.

DIF_models <- function(item, data)
{
  list(
    full_DIF = rms::lrm(stats::as.formula(paste0(item, "~ theta * country")), data=data),    # md3 in lordif, Model 3 (3 vs 2 = non-uniform DIF)
    uniform_DIF = rms::lrm(stats::as.formula(paste0(item, "~ theta + country")), data=data), # md2 in lordif, Model 2 (2 vs 1 = uniform DIF)
    no_DIF = rms::lrm(stats::as.formula(paste0(item, "~ theta")), data=data))                # md1 in lordif, Model 1 (1 vs 3 = total DIF)
}

DIF_models_age  <- function(item, data)
{
  list(
    full_DIF = rms::lrm(stats::as.formula(paste0(item, "~ theta * country + age")), data=data),    # Model 3 (3 vs 2 = non-uniform DIF)
    uniform_DIF = rms::lrm(stats::as.formula(paste0(item, "~ theta + country + age")), data=data), # Model 2 (2 vs 1 = uniform DIF)
    no_DIF = rms::lrm(stats::as.formula(paste0(item, "~ theta + age")), data=data))                # Model 1 (1 vs 3 = total DIF)
}