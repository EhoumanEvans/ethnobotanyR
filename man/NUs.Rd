% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/NUs.R
\name{NUs}
\alias{NUs}
\title{Number of Uses (NU)}
\usage{
NUs(data)
}
\arguments{
\item{data}{is an ethnobotany data set with column 1 'informant' and 2 'sp_name' as row identifiers of informants and of species names respectively.
The rest of the columns are the identified ethnobotany use categories. The data should be populated with counts of uses per person (should be 0 or 1 values).}
}
\description{
This function allows you to calculate the number of uses (NU) per species.
}
\examples{

#Use built-in ethnobotany data example
NUs(ethnobotanydata)

#Generate random dataset of three informants uses for four species
eb_data <- data.frame(replicate(10,sample(0:1,20,rep=TRUE)))
names(eb_data) <- gsub(x = names(eb_data), pattern = "X", replacement = "Use_")  
eb_data$informant<-sample(c('User_1', 'User_2', 'User_3'), 20, replace=TRUE)
eb_data$sp_name<-sample(c('sp_1', 'sp_2', 'sp_3', 'sp_4'), 20, replace=TRUE)
NUs(eb_data)

}
\keyword{ethnobotany,}
\keyword{number}
\keyword{of}
\keyword{quantitative}
\keyword{uses}
