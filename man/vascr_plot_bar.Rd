% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_plot_bar.R
\name{vascr_plot_bar}
\alias{vascr_plot_bar}
\title{Plot a vascr data set as a bar}
\usage{
vascr_plot_bar(data, error = Inf, confidence = NULL, ...)
}
\arguments{
\item{data}{Vascr dataset to plot}

\item{error}{The level of error to display}

\item{confidence}{Minimum confidence level of results to show on the graph}

\item{...}{Any argument to be passed to vascr_polish_plot or vascr_prep_graphdata}
}
\value{
A ggplot bar plot
}
\description{
Plot a vascr data set as a bar
}
\examples{
#vascr_plot_bar(growth.df, level = "experiments", frequency = 4000, unit = "R"
#, time = list(50,100), error = Inf)

#vascr_plot_bar(growth.df, level = "wells", frequency = 4000, unit = "R", 
#time = 50, error = Inf)
#vascr_plot_bar(data = growth.df, level = "experiments", frequency = 4000, 
#unit = "R", time = 50, error = Inf)
#vascr_plot_bar(growth.df, level = "summary", frequency = 4000, unit = "R", 
#time = 50, error = Inf)

#vascr_plot_bar(growth.df, level = "deviation", frequency = 4000, unit = "R")

#vascr_plot_bar(growth.df, frequency = 4000, unit = "R", time = 50, confidence = 0.5)
}
\keyword{internal}
