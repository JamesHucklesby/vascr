% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vascr_plot_continuous.R
\name{vascr_plot_continuous}
\alias{vascr_plot_continuous}
\title{Plot a continuous ECIS variable}
\usage{
vascr_plot_continuous(data, cols, priority, level, error, ...)
}
\arguments{
\item{data}{A standard ECIS dataset}

\item{cols}{The column names to display}

\item{priority}{Priority of variables to plot}

\item{level}{Level of data replication to plot}

\item{error}{Type of error to plot}

\item{...}{Variables to be passed to vascr_prep_graphdata and vascr_polish_plot}
}
\value{
a ggplot 2 object
}
\description{
Plot a continuous ECIS variable
}
\examples{

#vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary")


# vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "wells", 
#time = 100, error = Inf, priority = c("cells", "Experiment"))
# vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "experiments",
# time = 100, priority = c("cells", "Experiment"), error = 1)
# vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "summary",
# time = 100, continuous = "cells", error = Inf, priority = c("cells", "Experiment"))


#data = growth.df


}
