% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_anova_new.R
\name{vascr_summarise_anova}
\alias{vascr_summarise_anova}
\title{Run a standard panel of ANOVA tests and return the results in text format}
\usage{
vascr_summarise_anova(data.df, unit, frequency, time, priority = NULL)
}
\arguments{
\item{data.df}{The dataset to analyse}

\item{unit}{Unit to analyse}

\item{frequency}{Frequency to analyse}

\item{time}{Time to analyse}

\item{priority}{Priority list of variables to run tests on}
}
\value{
Prints out the summary data for an ANOVA analysis
}
\description{
Run a standard panel of ANOVA tests and return the results in text format
}
\examples{
#vascr_summarise_anova(growth.df, "R", 4000, 100)

}
\keyword{internal}
