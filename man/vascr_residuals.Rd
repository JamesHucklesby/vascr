% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_anova_new.R
\name{vascr_residuals}
\alias{vascr_residuals}
\title{Generate the residuals from a vascr linear model}
\usage{
vascr_residuals(data.df, unit, frequency, time, priority = NULL)
}
\arguments{
\item{data.df}{the dataset to model}

\item{unit}{the unit to generate data from}

\item{frequency}{Frequency to model}

\item{time}{Time point to model}

\item{priority}{Priority to model}
}
\value{
A data frame of residuals
}
\description{
Generate the residuals from a vascr linear model
}
\examples{

# vascr_residuals(growth.df, "R", "4000", 100)

}
\keyword{internal}
