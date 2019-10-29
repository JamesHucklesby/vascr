# Register the data frames column names used for dplyr manipulation to satisfy CMD check

utils::globalVariables("Unit")
utils::globalVariables("Well")
utils::globalVariables("Sample")
utils::globalVariables("Frequency")
utils::globalVariables("Experiment")
utils::globalVariables("Time")
utils::globalVariables("Value")
utils::globalVariables("Stream")

utils::globalVariables(c("A","B","Label","Score","desc","geom_text","median","movementfrommean","position_stack","rn", "deviation", "expwells", "badremoved", "V1", "V2", "V3","V4", "V5", "mapvalues", "V1.1", "V2.1", "V3.1", "V4.1", "V5.1", "Var1"))

utils::globalVariables(c("Var1", "Var2", "Var3", "Var4", "Var5"))
utils::globalVariables(c("Val1", "Val2", "Val3", "Val4", "Val5"))


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
