% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_naming.R
\name{vascr_explode}
\alias{vascr_explode}
\title{Separate names in a vascr plate map}
\usage{
vascr_explode(data.df)
}
\arguments{
\item{data.df}{the dataset to separate}
}
\value{
a separated vascr dataset, with additional columns for each variable
}
\description{
Separate names in a vascr plate map
}
\examples{
vascr_explode(growth.df)
}
