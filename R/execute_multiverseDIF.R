#' Execute Multiverse Differential Item Functioning (DIF) Analysis
#'
#' This function performs a multiverse analysis for detecting differential item functioning (DIF).
#' It iteratively fits models, checks for DIF using various criteria, and flags items.
#' The process continues until the set of flagged items stabilizes.
#'
#' @param criterion A character vector indicating the statistical criteria to be used for DIF detection.
#' Options include "lr" (Likelihood Ratio), "lr_bon" (Likelihood Ratio with Bonferroni correction), 
#' "lr_ben" (Likelihood Ratio with Benjamini-Hochberg correction), "beta" (Beta change), 
#' "CoxSnell" (Cox-Snell pseudo R2), "Nagelkerke" (Nagelkerke pseudo R2), and "McFadden" (McFadden pseudo R2).
#' @param correction A parameter or method used for correction in the DIF detection process. Either "age" or "no"
#'
#' @return A list containing the results of the DIF analysis for the last iteration.
#' This includes the model fit, flagged items, and the criteria values used for flagging items.
#' The specific structure and components of the returned list should be described here.
#' @export
#'
#' @importFrom plyr ldply
#' @importFrom plyr llply
#' @importFrom stats pchisq
#' @importFrom mirt fscores
#' @importFrom mirt expected.test
#' @importFrom stats p.adjust
#' @importFrom stats p.adjust.methods
#' @importFrom utils head
execute_multiverseDIF <- function(
    criterion = c(
      "lr", 
      "lr_bon",
      "lr_ben",
      "beta", 
      "CoxSnell",  
      "Nagelkerke", 
      "McFadden"),
    correction
)
{
  criterion = match.arg(criterion) # matches the criterion
  flagged_items_saved = 1          # Initial placeholder
  flagged_items = "Initialize"     # Initial placeholder
  
  results = list()                 # save results in list
  
  counter <- 0                     # count number of while loops
  while (!identical(flagged_items, # are the flagged items identical to items flagged before?
                    flagged_items_saved)){
    
    flagged_items_saved <- flagged_items # a vector, eg c(PFM1, PFM4) breaks if all items flagged
    
    # print_cyan(paste0("Specification ", i, "/", nrow(specifications)))
    
    # print(paste("Estimate Model without Flagged Items"))
    
    if(length(flagged_items) <= 33 | length(flagged_items)  == 0){  # here at least 2 anchor items
      
      corrected_model <- reest_model(flagged_items, 
                                     dat = dat,
                                     grouping_vector = grouping_vector,
                                     parameters = parameters) 
    } else{
      #print_red("Not enough items without DIF --> NEXT")
      next
    }
    #print("__________________________________________________________________________")
    
    #print(paste ("Fit regression models for country comparison: ",                specifications$wf_1_comparison[i]))
    
    reg_dat <- prepare_regression_data(dat, items, corrected_model)
    
    if (correction == "no") {
      DIF_model <- llply(names(items), function(x) DIF_models(item = x, 
                                                              data = reg_dat)) # fit DIF models for each item
    } else if (correction == "age"){
      DIF_model <- llply(names(items), function(x) DIF_models_age(item = x, 
                                                                  data = reg_dat)) # fit DIF models for each item
    }
    # print("calculate criteria")
    
    print(paste0("calculate criteria based on: ", 
                 paste(
                   specifications$wf_1_comparison[i], 
                   paste(specifications$hf_1_correction[i], "correction"),
                   specifications$hf_2_parameter_vector[i],
                   specifications$hf_3_criterion[i],
                   specifications$hf_4_threshold[i],
                   sep = " & ", collapse = "")))
    
    LR_tests <- ldply(DIF_model, function(x) lrtest(x[[1]],x[[3]])$stats) %>%  # The lrtest function does likelihood ratio tests for two nested models, from fits that have stats components with "Model L.R." values. For models such as psm, survreg, ols, lm which have scale parameters, it is assumed that scale parameter for the smaller model is fixed at the estimate from the larger model (see the example).
      cbind(.id = names(items))
    
    #lordif
    lordif_values <- ldply(DIF_model, function(x) {
      
      #pseudo r2s
      data <- data.frame(
        deviance0          = x[[3]][["deviance"]][1],
        deviance1          = x[[3]][["deviance"]][2],
        deviance2          = x[[2]][["deviance"]][2],
        deviance3          = x[[1]][["deviance"]][2],
        pseudo1.CoxSnell   = 1-exp(diff(x[[3]]$deviance)/nrow(items)),
        pseudo2.CoxSnell   = 1-exp(diff(x[[2]]$deviance)/nrow(items)),
        pseudo3.CoxSnell   = 1-exp(diff(x[[1]]$deviance)/nrow(items))
      )
      data$pseudo1.Nagelkerke <- data$pseudo1.CoxSnell/(1-exp(-data$deviance0/nrow(items)))
      data$pseudo2.Nagelkerke <- data$pseudo2.CoxSnell/(1-exp(-data$deviance0/length(items)))
      data$pseudo3.Nagelkerke <- data$pseudo3.CoxSnell/(1-exp(-data$deviance0/length(items)))
      data$pseudo1.McFadden   <- 1-data$deviance1/data$deviance0
      data$pseudo2.McFadden   <- 1-data$deviance2/data$deviance0
      data$pseudo3.McFadden   <- 1-data$deviance3/data$deviance0
      data$pseudo12.CoxSnell  <-round(data$pseudo2.CoxSnell  -data$pseudo1.CoxSnell,4)   # Model 2 (2 vs 1 = uniform DIF)
      data$pseudo13.CoxSnell  <-round(data$pseudo3.CoxSnell  -data$pseudo1.CoxSnell,4)   # Model 1 (1 vs 3 = total DIF)
      data$pseudo23.CoxSnell  <-round(data$pseudo3.CoxSnell  -data$pseudo2.CoxSnell,4)   # Model 3 (3 vs 2 = non-uniform DIF)
      
      data$pseudo12.Nagelkerke<-round(data$pseudo2.Nagelkerke-data$pseudo1.Nagelkerke,4) # Model 2 (2 vs 1 = uniform DIF)
      data$pseudo13.Nagelkerke<-round(data$pseudo3.Nagelkerke-data$pseudo1.Nagelkerke,4) # Model 1 (1 vs 3 = total DIF)
      data$pseudo23.Nagelkerke<-round(data$pseudo3.Nagelkerke-data$pseudo2.Nagelkerke,4) # Model 3 (3 vs 2 = non-uniform DIF)
      
      data$pseudo12.McFadden  <-round(data$pseudo2.McFadden  -data$pseudo1.McFadden,4)   # Model 2 (2 vs 1 = uniform DIF)
      data$pseudo13.McFadden  <-round(data$pseudo3.McFadden  -data$pseudo1.McFadden,4)   # Model 1 (1 vs 3 = total DIF)
      data$pseudo23.McFadden  <-round(data$pseudo3.McFadden  -data$pseudo2.McFadden,4)   # Model 3 (3 vs 2 = non-uniform DIF)
      
      #beta change
      data$beta12 <- round(abs((x[[2]]$coefficients[["theta"]]-x[[3]]$coefficients[["theta"]])/x[[3]]$coefficients[["theta"]]),4)
      data$df12<-length(table(grouping_vector))-1
      data$df13<-2*(length(table(grouping_vector))-1)
      data$df23<-length(table(grouping_vector))-1
      
      #chisquare
      data$chi12<-round(1-pchisq(data$deviance1-data$deviance2, data$df12),4)
      data$chi13<-round(1-pchisq(data$deviance1-data$deviance3, data$df13),4)
      data$chi23<-round(1-pchisq(data$deviance2-data$deviance3, data$df23),4)
      
      return(data)
    }) %>% 
      cbind(.id = names(items))
    
    result = merge_recurse(list(
      LR_tests, 
      lordif_values),
      by=".id")
    
    # print(paste("Criterion:", criterion))  
    flagged_items <- switch(criterion,
                            
                            #Beta
                            beta = result$.id[abs(result$beta12)>threshold], 
                            
                            # Chi-Square
                            lr = result$.id[result$P < threshold],
                            lr_bon = result$.id[result$P < threshold/length(items)],
                            lr_ben = result$.id[p.adjust(result$P, 
                                                         method = p.adjust.methods, 
                                                         n = length(result$P)) < threshold],
                            #lordif
                            CoxSnell  = result$.id[result$pseudo13.CoxSnell > threshold],
                            Nagelkerke = result$.id[result$pseudo13.Nagelkerke > threshold],
                            McFadden   = result$.id[result$pseudo13.McFadden > threshold]
                            
    )
    
    counter = counter + 1
    if (counter > 10) {
      break
    }
    
    print_red(paste(length(flagged_items), "Items flagged for DIF: ", paste(flagged_items, collapse=", "))) # print items flagged for DIF
    
    results[[1]] = list( # if all iterations should be saved: results[[length(results)+1]]
      
      corrected_model = list(model = corrected_model, # corrected model
                             parameter = mod2values(corrected_model),
                             thetas = fscores(corrected_model),
                             theta_se = fscores(corrected_model, full.scores.SE = T)[, "SE_F1"] %>% as.vector(),
                             ets = mirt::expected.test(corrected_model, 
                                                       Theta = fscores(corrected_model), 
                                                       group = 1)
                             #coefs = coef(corrected_model, IRTpars = TRUE)
      ), 
      
      DIF_model = list(model = DIF_model,
                       data = reg_dat
      ),
      Criteria = result, 
      Flagged_items = flagged_items)
  }
  
  names(results) = "last iteration"  #paste("iteration", 1:length(results), sep = "_") # if all should be saved
  
  return(invisible(results))
}