% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Naming_functions.R
\name{vascr_summarise_change}
\alias{vascr_summarise_change}
\title{Create a data frame summarising the changing variables in a dataset in a single column}
\usage{
vascr_summarise_change(data.df, showblank = FALSE)
}
\arguments{
\item{data.df}{The dataset to summarise}
}
\value{
A full dataset
}
\description{
Create a data frame summarising the changing variables in a dataset in a single column
}
\examples{
data.df = vascr_subset(growth.df, unit = "Rb")
data.df = vascr_summarise(data.df, level = "experiments")

dat = vascr_summarise_change(data.df)
}
