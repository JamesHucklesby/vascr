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

utils::globalVariables(c('Data','Instrument', '..density..','dnorm','.fitted','.resid', 'data.df', 'Var', 'Val', "sem", ".", "allNA", 'import_mdb_return_TEMP_object_from_32_bit_R', 'starts_with', 'TTimes', 'Layout'))

utils::globalVariables(c("commaarray", "lsf.str", "Deviation", "Max_Deviation", "Vehicle", "count_na", "IsVehicleControl", "Vehicle", "growth.df", "unit", "error", "ymin", "ymax", "toplot", "continuous", "frequency", "title", "Tukey.levels", "Well ID", "12"))

utils::globalVariables(c("Distance", "Delta_Length", "value", "coeffs", "data"))


#' Example data set from an ECIS growth experiment
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{Experiment}{Date the experiment was conducted}
#'   \item{Frequency}{Frequency of colleciton, modeled units have a frequency of 0}
#'   \item{Sample}{Name of the sample located in that well, formated in a standardised way}
#'   \item{Time}{Capture time in hours since the start of the experiment}
#'   \item{Unit}{Unit that the value is measured in}
#'   \item{Value}{Numerical value in units}
#'   \item{Well}{Well of plate that was measured}
#'   \item{Instrument}{The instrument the data was collected on}
#'   \item{cells}{Number of cells added to each well}
#'   \item{line}{The cell line used in this experiment (all HCMEC/D3)}
#'   ...
#' }
#' @description A dataset containing growth curves from a variety of experiments
#' @source James Hucklesby 2020
"growth.df"


#' #' Example data on ECIS, xCELLigence and cellZscope instrumentation
#' #'
#' #' @format A data frame with 53940 rows and 10 variables:
#' #' \describe{
#' #'   \item{Experiment}{Date the experiment was conducted}
#' #'   \item{Frequency}{Frequency of colleciton, modeled units have a frequency of 0}
#' #'   \item{Sample}{Name of the sample located in that well, formated in a standardised way}
#' #'   \item{Time}{Capture time in hours since the start of the experiment}
#' #'   \item{Unit}{Unit that the value is measured in}
#' #'   \item{Value}{Numerical value in units}
#' #'   \item{Well}{Well of plate that was measured}
#' #'   \item{Instrument}{The instrument the data was collected on}
#' #'   \item{cells}{Number of cells added to each well}
#' #'   \item{line}{The cell line used in this experiment (all HCMVEC)}
#' #'   ...
#' #' }
#' #' @description A dataset containing growth curves from a variety of experiments
#' #' @source James Hucklesby 2020
#' "instruments.df"


