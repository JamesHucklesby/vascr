% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subsetting_continuous.R
\name{vascr_detect_vehicle}
\alias{vascr_detect_vehicle}
\title{Detect vehicles in an vascr dataset}
\usage{
vascr_detect_vehicle(data, force_replace = FALSE)
}
\arguments{
\item{data}{An vascr dataset}

\item{force_replace}{Should vehicles be replaced, if they already exist. True replaces the column, false does not. Default FALSE.}
}
\value{
An vascr dataset with an extra IsVehicleControl column
}
\description{
Detect vehicles in an vascr dataset
}
\examples{
#vascr_detect_vehicle(growth.df)

}
\keyword{internal}
