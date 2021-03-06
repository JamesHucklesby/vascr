% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_quality.R
\name{vascr_exclude_deviation}
\alias{vascr_exclude_deviation}
\title{Exclude automatically detected wells that have a connection issue from the dataset}
\usage{
vascr_exclude_deviation(
  data.df,
  deviation = 0.5,
  max_deviation = 0,
  frequency = 4000,
  unit = "R",
  verbose = TRUE
)
}
\arguments{
\item{data.df}{The dataset to parse}

\item{deviation}{The threshold stringency to use in detection. Default is 5, the range of 1-10 may be appropriate. Higher numbers are less stringent.}

\item{max_deviation}{The maximum deviation tollerable before a well is excluded.}

\item{frequency}{The frequency to use for detection, default is 4000 Hz}

\item{unit}{The unit to run the detection on, default is R}

\item{verbose}{Prints which wells have been removed in the terminal. Should be used when first investigating data to allow for follow up plots with vascr_isolate_well to be conducted.}
}
\value{
A standard ECIS dataframe, minus the detected wells
}
\description{
Exclude automatically detected wells that have a connection issue from the dataset
}
\examples{

# vascr_plot_deviation(growth.df, max_deviation = 0.3)

# datum = vascr_exclude_deviation(growth.df, max_deviation = 0.3)

# vascr_plot_deviation(datum)


}
\keyword{internal}
