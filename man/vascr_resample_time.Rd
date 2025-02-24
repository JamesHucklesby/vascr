% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformation.R
\name{vascr_resample_time}
\alias{vascr_resample_time}
\title{Resample a vascr dataset}
\usage{
vascr_resample_time(
  data.df,
  npoints = vascr_find_count_timepoints(data.df),
  start = min(data.df$Time),
  end = max(data.df$Time),
  rate = NULL
)
}
\arguments{
\item{data.df}{The vascr dataset to resample}

\item{npoints}{Manually specificity the number of points to resample at, default is the same frequency as the input dataset}

\item{start}{Time to start at}

\item{end}{Time to end at}

\item{rate}{Time between timepoints}
}
\value{
An interpolated vascr dataset
}
\description{
Impedance sensing data is often not collected simultaneously, which creates issues
summarising and plotting the data. This function interpolates these data to allow
these downstream functions to happen.
}
\examples{
vascr_resample_time(growth.df, 5, 0, 200)
vascr_resample_time(growth.df, 5)
vascr_resample_time(growth.df, start = 5, end = 20, rate = 5)

}
