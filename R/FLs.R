#' Fidelity Level (FL)
#' 
#' Calculate the fidelity level (FL) of species uses in ethnobotany studies
#'
#' Allows users to calculate the fidelity level (FL) of species in ethnobotany studies. 
#' @source Friedman, J., Yaniv, Z., Dafni, A., Palewitch, D., 1986. A preliminary classification of the healing potential of medicinal plants, based on a rational analysis of an ethnopharmacological field survey among Bedouins in the Negev Desert, Israel. Journal of Ethnopharmacology 16, 275-287. <https://www.ncbi.nlm.nih.gov/pubmed/3747566>
#' @param data is an ethnobotany data set with column 1 'informant' and 2 'sp_name' as row identifiers of informants and of species names respectively.
#' The rest of the columns are the identified ethnobotany use categories. The data should be populated with counts of uses per person (should be 0 or 1 values).
#' 
#' @importFrom magrittr %>%
#' @importFrom reshape melt
#' @importFrom dplyr filter summarize select left_join group_by
#' @importFrom assertthat validate_that see_if
#' 
#' @keywords ethnobotany, cultural value, use report, fidelity
#'
#' @examples
#' 
#' #Use built-in ethnobotany data example
#' FLs(ethnobotanydata)
#' 
#' #Generate random dataset of three informants uses for four species
#' eb_data <- data.frame(replicate(10,sample(0:1,20,rep=TRUE)))
#' names(eb_data) <- gsub(x = names(eb_data), pattern = "X", replacement = "Use_")  
#' eb_data$informant<-sample(c('User_1', 'User_2', 'User_3'), 20, replace=TRUE)
#' eb_data$sp_name<-sample(c('sp_1', 'sp_2', 'sp_3', 'sp_4'), 20, replace=TRUE)
#' FLs(eb_data)
#' 
#' @export FLs
FLs <- function(data) {
  if (!requireNamespace("reshape", quietly = TRUE)) {
    stop("Package \"reshape\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package \"dplyr\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  if (!requireNamespace("magrittr", quietly = TRUE)) {
    stop("Package \"magrittr\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  
  URspecies <- URcategory <- variable <-  value <- URspdata <- mat <- FLs <- URdata <- UR_sum <- sp_name <- informant <- NULL # Setting the variables to NULL first, appeasing R CMD check
  
  #add error stops with validate_that
  assertthat::validate_that("informant" %in% colnames(data), msg = "The required column called \"informant\" is missing from your data. Add it.")
  assertthat::validate_that("sp_name" %in% colnames(data), msg = "The required column called \"sp_name\" is missing from your data. Add it.")
  
  assertthat::validate_that(is.factor(data$informant), msg = "The \"informant\" is not a factor variable. Transform it.")
  assertthat::validate_that(is.factor(data$sp_name), msg = "The \"sp_name\" is not a factor variable. Transform it.")
  
  assertthat::validate_that(all(sum(dplyr::select(data, -informant, -sp_name)>0)) , msg = "The sum of all UR is not greater than zero. Perhaps not all uses have values or are not all are numeric.")
  
  ## Use 'complete.cases' from stats to get to the collection of obs without NA
  data_complete<-data[stats::complete.cases(data), ]
  #message about complete cases
  assertthat::see_if(length(data_complete) == length(data), msg = "Some of your observations included \"NA\" and were removed. Consider using \"0\" instead.")
  
  FLsdata <- data #create subset-able data
  
  #Melt ethnobotany data
  mat<- reshape::melt(FLsdata, id=c("informant","sp_name")) %>% dplyr::filter(value >=1) %>% dplyr::select(-informant) 
  
 #Calculate uses per category
 URcatdata <- mat %>% dplyr::group_by(sp_name, variable) %>%
   dplyr::summarize(URcategory = sum(value, na.rm = TRUE)) 
      
 #Calculate uses per species        
 URspdata <- mat %>%
   dplyr::group_by(sp_name) %>%
   dplyr::summarize(URspecies = sum(value, na.rm = TRUE))
 
 #Bind data
 FLspdata <- dplyr::left_join(URspdata, URcatdata, by = "sp_name", na.rm = TRUE)
 
 #Calcualte FLs
 FLspdata$FLs <- FLspdata$URcategory / FLspdata$URspecies * 100
  
 FLs <- dplyr::select(FLspdata, -URcategory, -URspecies) %>%
   dplyr::arrange(-FLs)
  
  print(as.data.frame(FLs))
}
