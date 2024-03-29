% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Naming_functions.R
\name{vascr_zero_time}
\alias{vascr_zero_time}
\title{Title}
\usage{
vascr_zero_time(data.df, time = 0)
}
\arguments{
\item{data.df}{The data frame to use}

\item{time}{The time to set to zero}
}
\description{
Title
}
\examples{
zeroed = growth.df \%>\% vascr_subset(unit = "R", frequency = "4000") \%>\%
          vascr_zero_time(100)
          
zeroed \%>\% vascr_plot_line()

}
