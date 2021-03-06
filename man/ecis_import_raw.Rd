% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_ecis.R
\name{ecis_import_raw}
\alias{ecis_import_raw}
\title{ECIS raw data importer}
\usage{
ecis_import_raw(rawdata, sampledefine, experimentname = "NA")
}
\arguments{
\item{rawdata}{A resampled ABP file containing the un-modeled data}

\item{sampledefine}{A CSV file containing well numbers and their corresponding sample names}

\item{experimentname}{Name of the experiment to be built into the dataset}
}
\value{
Data frame containing all the raw data readings from the ECIS Z0 instrument
}
\description{
Raw data importer, generates a r dataframe from a raw ABP file
}
\examples{

#First determine the locatins of your files relative to your dataset. 
#Here we use system.file to pull a default out of the filesystem, 
#but you can use a path relative to the file you are working on. 
#E.G 'Experiment1/Raw.abp'

#rawdata = system.file('extdata/growth1_raw_TimeResample.abp', package = 'vascr')
#sampledefine = system.file('extdata/growth1_samples.csv', package = 'vascr')

#Then run the import

#data1 = ecis_import_raw(rawdata, sampledefine, "TEST")
#data1$Experiment = "Growth_1"
#head(data1)
#vascr_plot(data1, unit = "X")

}
\keyword{internal}
