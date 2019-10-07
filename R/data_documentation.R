# Register the data frames column names used for dplyr manipulation to satisfy CMD check

utils::globalVariables("Unit")
utils::globalVariables("Well")
utils::globalVariables("Sample")
utils::globalVariables("Frequency")
utils::globalVariables("Experiment")
utils::globalVariables("Time")
utils::globalVariables("Value")
utils::globalVariables("Stream")



#' Example data set from an ECIS growth experiment
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{Experiment}{Date the experiment was conducted}
#'   \item{Frequency}{Frequency of colleciton, modeled units have a frequency of 0}
#'   \item{Sample}{Name of the sample located in that well}
#'   \item{Time}{Capture time}
#'   \item{Unit}{Unit that the value is measured in}
#'   \item{Value}{Numerical value in units}
#'   \item{Well}{Well of plate that was measured}
#'   ...
#' }
#' @description A dataset containing growth curves from a variety of experiments
#' @source James Hucklesby 2019
"growth.df"
