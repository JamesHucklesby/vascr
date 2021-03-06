% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_ecis.R
\name{ecis_calculate_quantaties}
\alias{ecis_calculate_quantaties}
\title{Calculate electrical properties of ECIS data}
\usage{
ecis_calculate_quantaties(data.df)
}
\arguments{
\item{data.df}{The dataset to calculate from}
}
\value{
An ecis data frame, with calculated values included
}
\description{
ECIS instrments capure phase and impedance data. This needs to be converted in software into resistance and capacatance values that are more directly interpretable. This function does that using trigonemetric functions. Validated against data produced by Applied Biophysics' ECIS software.
}
\details{
Function used by default as part of ecis_import_raw
}
\keyword{internal}
