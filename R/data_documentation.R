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
#' ,"instruments.df"



#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL




# # Build example data
# 
# 
# 
# #//////////// ECIS ////////////////////
# 
# library("vascr")
# 
# raw1.df = ecis_import_raw(system.file("/extdata/growth1_raw_TimeResample.abp", package = "vascr"), system.file("/extdata/growth1_samples.csv", package = "vascr"))
# raw2.df = ecis_import_raw(system.file("/extdata/growth2_raw_TimeResample.abp", package = "vascr"), system.file("/extdata/growth2_samples.csv", package = "vascr"))
# raw3.df = ecis_import_raw(system.file("/extdata/growth3_raw_TimeResample.abp", package = "vascr"), system.file("/extdata/growth3_samples.csv", package = "vascr"))
# 
# ecis_raw = vascr_combine(raw1.df, raw2.df, raw3.df)
# 
# vascr_plot(rawcombined, unit = "R", replication = "summary")
# 
# model1.df = ecis_import_model(system.file("/extdata/growth1_raw_TimeResample_RbA.csv", package = "vascr"), system.file("/extdata/growth1_samples.csv", package = "vascr"))
# model2.df = ecis_import_model(system.file("/extdata/growth2_raw_TimeResample_RbA.csv", package = "vascr"), system.file("/extdata/growth2_samples.csv", package = "vascr"))
# model3.df = ecis_import_model(system.file("/extdata/growth3_raw_TimeResample_RbA.csv", package = "vascr"), system.file("/extdata/growth3_samples.csv", package = "vascr"))
# 
# ecis_model = vascr_combine(model1.df, model2.df, model3.df)
# ecis_combined = vascr_combine(rawcombined, modelcombined)
# 
# ############# CellZScope
# 
# cellzscope_raw = cellzscope_import_raw(system.file("/extdata/mdckspectra.txt", package = "vascr"))
# cellzscope_model = cellzscope_import_model(system.file("/extdata/mdckmodel.txt", package = "vascr"))
# 
# cellzscope_combined = vascr_combine(cellzscope_raw, cellzscope_model)
# cellzscope_combined= vascr_subset(cellzscope_combined, time = c(0,1000))
# 
# vascr_plot(cellzscope_combined, unit = "TER", frequency = 0, preprocessed = TRUE)
# 
# 
# 
# ############ excelligence
# 
# excelligence_combined = excelligence_import(system.file("/extdata/xcell.txt", package = "vascr"))
# 
# vascr_plot(excelligence_combined, unit = "CI", frequency = 0, samplecontains = "ATP")
# 
# 
# data.df = cellzscope_raw
# 
# units_used = unique(data.df$Unit)
# 
# eraw = c("C","P", "R", "X", "Z")
# emodel = c("Alpha", "Cm", "Drift", "Rb", "RMSE")
# eall = c(eraw, emodel)
# 
# excelligence = c("CI")
# 
# zraw = c("I", "P")
# zmodel = c("CPE_A", "CPE_n", "TER",   "Ccl",   "Rmed")
# 
# data = cellzscope_raw
# data = ecis_raw
# 
# 
# units = unique(units)
# frequencies = unique(data$Frequency)
# isint = all((frequencies == floor(frequencies)))
# 
# if(isint)
# {
#   
# }
# 
# 

# Save the file down to be opened with the package

#save(file = "growth.df.rda", list = "growth.df", compress = "xz")

# 
# 
# # Count how many lines are in this package, cos
# 
# library(dplyr)
# library(stringr)
# # Count your lines of R code
# list.files(path = "/Users/jhuc964/Desktop/ECIS R/ECISR/R", recursive = T, full.names = T) %>%
#   str_subset("[.][R]$") %>%
#   sapply(function(x) x %>% readLines() %>% length()) %>%
#   sum()


# 
# toplot2.df = vascr_prep_graphdata(growth.df, unit = "Rb")
# 
# toplot2.df = vascr_summarise(toplot2.df, level = "summary")
# 
# plot = ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample, ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n), fill = Sample)) + ggplot2::geom_line()
# 
# plot = plot + geom_ribbon(alpha = 0.1)
# 
# plot = plot + geom_errorbar()
# 
# 
# install.packages("CodeDepends")
# install.packages("Rgraphviz")
# library(graph)
# library(CodeDepends)
# 
# 
# 
# gg = makeCallGraph("function:vascr_plot")
# if(require(Rgraphviz)) {
#   gg = layoutGraph(gg, layoutType = "circo")
#   graph.par(list(nodes = list(fontsize=55)))
#   renderGraph(gg) ## could also call plot directly
# }
# 
# f = system.file("samples", "R/heatmap_plot.R", package = "vascr")
# sc = readScript(f)
# g = makeVariableGraph( info = getInputs(sc))
# if(require(Rgraphviz))
#   plot(g)
# 
# 
# 
# devtools::install_github("datastorm-open/DependenciesGraphs")
# 
# 
# library("DependenciesGraphs")
# library(vascr) # A package I'm developing
# 
# dep <- envirDependencies("package:vascr")
# plot(dep)
# launch.app()
# 
# deps <- funDependencies("package:vascr", "vascr_plot")
# plot(deps)
# 
# 
# 
# 
# # library(rhub)
# validate_email()
# rhub::check()
# 
# cran_prep <- check_for_cran()
# cran_prep$cran_summary()

# 


