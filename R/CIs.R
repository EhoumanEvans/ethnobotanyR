#' Cultural Importance index (CI)
#'
#' This function allows you to calculate the Cultural Importance Index (CI) per species.
#' @source Tardío, J., and M. Pardo-de-Santayana, 2008. Cultural Importance Indices: A Comparative Analysis Based on the Useful Wild Plants of Southern Cantabria (Northern Spain) 1. Economic Botany, 62(1), 24-39.
#' @param data is an ethnobotany data set with column 1 'informant' and 2 'sp_name' as row identifiers of informants and of species names respectively.
#' The rest of the columns are the identified ethnobotany use categories. The data should be populated with counts of uses per person (should be 0 or 1 values).
#' @keywords quantitative ethnobotany, cultural importance
#'
#' @examples
#' 
#' CIs(ethnobotanydata)
#'
#'@export CIs
#'
CIs <- function(data) {
    if (!requireNamespace("plyr", quietly = TRUE)) {
        stop("Package \"plyr\" needed for this function to work. Please install it.",
            call. = FALSE)
    }
  data$URps <- rowSums(data[, -c(1:2)])
    data_URs <- plyr::ddply(data, ~sp_name,
        summarise, URs = sum(URps))
    data_Ci <- data_URs
    data_Ci$Ci <- data_URs$URs/(length(unique(data$informant)) *
        ncol(data[, -c(1:2)]))
    print("Cultural Importance index (CI) for each species in the data set")
    print(data_Ci[c(1, 3)])
}