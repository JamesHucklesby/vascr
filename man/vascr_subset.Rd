% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_align.R
\name{vascr_subset}
\alias{vascr_subset}
\title{Subset a vascr data set based on a number of factors}
\usage{
vascr_subset(
  data.df,
  time = NULL,
  unit = NULL,
  well = NULL,
  frequency = NULL,
  experiment = NULL,
  instrument = NULL,
  max_deviation = NULL,
  subsample = NULL,
  return_lists = FALSE,
  sampleid = NULL,
  remake_name = TRUE
)
}
\arguments{
\item{data.df}{Vascr dataset to subset}

\item{time}{Specified times. Individual values in a list will be subset out. If vectors are present in the list, values between the two most extreme values will be returned.}

\item{unit}{Units to subset. These are checked for integrity against possible units and the dataset itself}

\item{well}{Wells to select}

\item{frequency}{Frequencies to include in the dataset.}

\item{experiment}{Experiments to include in the dataset. Can be addressed either by name, or by the numerical order that they were loaded into vascr_combine in}

\item{instrument}{Which instruments to include values from}

\item{max_deviation}{Maximum deviation to allow between replicates}

\item{subsample}{Frequency values shoud be subsampled to}

\item{return_lists}{Return lists of the variables to select rather than the subset data set}

\item{sampleid}{List of ID's to be used. Sample names will be re-ordered accordingly for display.}

\item{remake_name}{Should the name be re-formatted}
}
\value{
The subset dataset, based on the values selected
}
\description{
Subset a vascr data set based on a number of factors
}
\examples{
# vascr_subset(growth.df)
# vascr_subset(growth.df, time = 40)
# vascr_subset(growth.df, time = NULL)
 
# vascr_subset(growth.df, unit = "Rb")
# vascr_subset(growth.df, unit = "R")
# vascr_subset(growth.df, well = "A1")
# vascr_subset(growth.df, value_less_than = 100)
# 

# vascr_subset(growth.df, time = c(5,20))

vascr_subset(growth.df, unit = "Rb")

}
