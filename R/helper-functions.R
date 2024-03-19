# This script contains custom functions partially adapted or completely copied from MrConradHarrison @ github https://github.com/MrConradHarrison/IRT-modelling-for-the-OHS-and-OKS/blob/main/Functions.R 

#### Histogram ####

#' @importFrom ggplot2 ggplot aes geom_line geom_bar xlab ylab theme_minimal
#'
histo <- function(x, y){
  
  df <-  x |>
    dplyr::select(y) |>
    table() |>
    as.data.frame() 
  
  colnames(df) <- c(".", "Freq")
  
  p <- ggplot2::ggplot(df) +
    ggplot2::geom_bar(aes(x = ., y = Freq), stat = "identity", fill = "cyan4") +
    ggplot2::theme_minimal() +
    ggplot2::xlab("") +
    ggplot2::ylab("Frequency")
  
  return(p)
  
}


#### Scree plot ####

scree.plot <- function (x, 
                        xlim = 4,
                        translucency = 0.5,
                        colour = "darkmagenta") {
  
  
  fa.values <- x$fa.values
  
  factors <- seq(from = 1, to = length(fa.values))
  
  value.table <- cbind(factors, fa.values) |> 
    as.data.frame() |>
    slice(1:xlim)
  
  colnames(value.table) <- c("Factors", "Eigenvalues")
  
  table <- value.table
  
  p <- ggplot(table, aes(x = Factors, y = Eigenvalues)) +
    geom_line(size = 1, alpha = translucency, colour =colour) +
    geom_point(size = 3, alpha = translucency, colour = colour) +
    scale_x_continuous(name='Factor Number', breaks=(1:xlim)) +
    theme_minimal() +
    labs(colour = "") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black")) +
    geom_hline(yintercept = 1, linetype = "dashed") +
    theme(text = element_text(size = 20))
  
  p
}


#### Covariance network ####

network <- function(items){
  
  cormatrix <- cor_auto(items)
  
  qgraph(cormatrix, 
         graph = "glasso", 
         layout = "spring", 
         sampleSize = nrow(items), 
         vsize = 7, 
         cut = 0, 
         maximum = .45, 
         borderwidth = 1.5, 
         labels = names(items),
         label.cex = 1.2, 
         curve = 0.3, 
         curveAll = T, 
         posCol = "cyan4",
         node.width = 1.2, 
         node.height = 1.2)
}



#### Correlation of sum scores and EAP scores ####

EAPcor <- function(model, items){
  
  
  fscores <- fscores(model)
  sumscores <- rowSums(items)
  cor <- cor(fscores, sumscores)
  
  score.df <- cbind(fscores, sumscores) |> 
    as.data.frame()
  
  ggplot(score.df, aes(x = F1, y = sumscores)) +
    geom_point(colour = "seagreen4", alpha = 0.1, size = 0.3) +
    theme_minimal() +
    xlab("EAP score") +
    ylab("Sum-score") +
    annotate("text", x = -2.5, y = 43, label = paste("r = ", as.character(round(cor, 3)),sep =""))
  
}

# Below are custiom functions from Constantin Yves Plessen

print_red <- function(msg) {
  cat(paste0("\033[31m", msg, "\033[0m\n"))
}

print_orange <- function(msg) {
  cat(paste0("\033[33m", msg, "\033[0m\n"))
}

# Define a function that prints a message in cyan color
print_cyan <- function(msg) {
  cat(paste0("\033[36m", msg, "\033[0m\n"))
}


# Function to filter the data by country and select the relevant items
filter_data <- function(data, countries) {
  data <- data %>% filter(country %in% countries) 
  
  # Select items
  
  return(data)
}

filter_items <- function(data, countries) {
  data <- data %>% filter(country %in% countries) 
  
  # Select items
  items <- data %>%
    dplyr::select(starts_with("PF")) %>% 
    dplyr::select_if(~ !any(is.na(.))) # remove items with missing values
  
  return(items)
}

# Function to create the group vector
create_grouping_vector <- function(data) {
  grouping_vector <- data %>% dplyr::pull(country_vector)
  return(grouping_vector)
}

# Create violin plot
geom_flat_violin <- function(mapping = NULL, data = NULL, stat = "ydensity",
                             position = "dodge", trim = TRUE, scale = "area",
                             show.legend = NA, inherit.aes = TRUE, ...) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomFlatViolin,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      trim = trim,
      scale = scale,
      ...
    )
  )
}


# Helper function to prepare regression data
prepare_regression_data <- function(dat, items, corrected_model) {
  reg_dat <- data.frame(sample_id = dat$sample_id, 
                        country = dat$country, 
                        age = dat$age,
                        dat[, names(items)], 
                        theta = fscores(corrected_model, full.scores=TRUE)[, "F1"])
  return(reg_dat)
}
