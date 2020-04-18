#' Calculate mode of a dataset
#'
#' @param v Vector of numeric data to find the mode of
#'
#' @return The mode of the vector
#' @export
#'
#' @examples
#' 
#' getmode(c(1,3,3,4,7))
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


#' Standardise well names accross import types
#' 
#' Replaces A1 in strings with A01. Important for importing ABP files which may use either notation. Returns NA if the string could not be normalised, which can be configured to throw a warning in import code.
#'
#' @param well The well to be standardised 
#'
#' @return Standardised well names
#' 
#' @export
#'
#' @examples 
#' vascr_standardise_wells('A01')
#' vascr_standardise_wells('A 1')
#' vascr_standardise_wells('tortoise') # Non-standardisable becomes NA
#' vascr_standardise_wells(growth.df$Well)
#' 
vascr_standardise_wells = function(well) {
  
  # First try and fix the user input
  well = toupper(well) # Make it upper case
  well = gsub(" ", "", well, fixed = TRUE) # Remove spaces
  well = gsub("[^0-9A-Za-z///' ]","" , well ,ignore.case = TRUE)
  well = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", well, perl = TRUE) # Add 0's
  
  # Check that it now conforms

  
  if(is.na(match(well[1],vascr_96_well_names())))
  {
    return ("NA")
  }
  
  return(well)
}

#' All the well names of a 96 well plate
#'
#' @return Vector containing all wells of a 96 well plate
#' @export
#'
#' @examples
#' vascr_96_well_names()
#' 
vascr_96_well_names = function()
{
  
  wells = expand.grid(LETTERS[1:8],c(1:12))
  wells$pasted = paste(wells$Var1,wells$Var2)
  wells = as.vector(wells$pasted)
  wells = gsub(" ", "", wells, fixed = TRUE) # Remove spaces
  wells = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", wells, perl = TRUE) # Add O's
  return(wells)
}


#' Align times
#' 
#' When running analyasis, you can only run stats on a timepoint that exists in the dataset. These are not always logical or easy to remember. This function rounds the number given to the nearest timepoint that is actually in the dataset.
#'
#' @param data.df A standard ECIS data frame
#' @param time The time point that needs rounding
#'
#' @return A timepoint that exactly aligns with a measured datapoint
#'
#' @export
#'
#' @examples
#' vascr_find_time(growth.df, 146.2)
#' 
vascr_find_time = function(data.df, time) {
  times = unique(data.df$Time)
  numberinlist = which.min(abs(times - time))
  timetouse = times[numberinlist]
  
  return(timetouse)
}

#' Align frequencies
#' 
#' When running analyasis, you can only subset or plot a time that exists in the dataset. These are not always logical or easy to remember. This function rounds the number given to the nearest frequency that is actually in the dataset.
#'
#' @param data.df A standard ECIS data frame
#' @param frequency The tfrequency that needs rounding
#'
#' @return A timepoint that exactly aligns with a measured datapoint
#'
#' @export
#'
#' @examples
#' vascr_find_frequency(growth.df, 4382)
#' 
vascr_find_frequency = function(data.df, frequency) {
  data.df$Frequency = as.numeric(data.df$Frequency)
  times = unique(data.df$Frequency)
  numberinlist = which.min(abs(times - frequency))
  timetouse = times[numberinlist]
  
  return(timetouse)
}

#' Detect if an ECIS dataset has been normalised
#'
#' @param data.df an ECIS dataset
#'
#' @return The time the data was normalised to, or FALSE if not normalised
#' @export
#'
#' @examples
#' growth.df$Instrument = "ECIS"
#' standard = growth.df
#' normal = vascr_normalise(growth.df, 100)
#' vascr_detect_normal(standard)
#' vascr_detect_normal(normal)

vascr_detect_normal = function(data.df)
{
  timecrushed = data.df %>% group_by(Time) %>% 
    summarise(deviation = sd(Value))
  timecrushed = subset(timecrushed, deviation == 0)
  if (nrow(timecrushed)==0)
  {
    return (FALSE)
  }
  return(timecrushed$Time)
}


#' Remove all non-core ECIS data from a data frame
#' 
#' Usefull if you want to to further data manipluation, without having to worry about tracking multiple, unknown columns.
#' 
#' @param data.df An ECIS dataset
#' @param subset What to strip off. Default is all, more options to come.
#' 
#' @importFrom stringr str_trim
#'
#' @return A dataset containing only the core ECIS columns
#' @export
#'
#' @examples
#' growth.df$Instrument = "ECIS"
#' exploded.df = vascr_explode(growth.df)
#' cleaned.df = vascr_remove_metadata(exploded.df)
#' identical(growth.df,cleaned.df)
vascr_remove_metadata = function(data.df, subset = "all")
{
  
  summary_level = vascr_test_summary_level(data.df)
  
  if(summary_level == "summary" || summary_level == "experiment")
  {
    warning("You are removing some summary statistics. These are not re-generatable using vascr_explode alone, and must be regenerated with vascr_summarise.")
  }
  
  removed.df = data.df %>% select(vascr_cols())
  
  return(removed.df)
}



#' Generate human readable versions of the unit variable for graphing
#'
#' @param unit The unit to submit
#' @param frequency The frequency to submit
#'
#' @return An expression containing the correct data label for the unit
#' @export
#'
#' @examples
#' 
#' vascr_titles("Rb")
#' 
vascr_titles = function (unit, frequency = 0)
{
  # Electrical quantaties
  if(unit == "C") { return(expression(paste("Capacitance (",mu,"F)")))}
  if(unit == "R") { return("Resistance (ohm)")}
  if(unit == "P") { return("Phase (degrees)")}
  if(unit == "Pr") { return("Phase (radians)")}
  if(unit == "X") { return("Reactance (ohm)")}
  if(unit == "Z") { return("Impedance (ohm)")}
  
  # ECIS paramaters
  if (unit == "Rb"){return (expression(paste("Rb (",Omega," cm"^2, ")")))}
  if (unit == "Cm"){return (expression(paste("Cm (",mu,"F/cm"^2, ")")))}
  if (unit == "Alpha"){return (expression(paste("Alpha (",ohm," cm"^2, ")")))}
  if(unit == "RMSE") {return("Model Fit RMSE")}
  if(unit == "Drift") {return("Drift (%)")}
  
  # xCELLigence
  if(unit == "CI") {return("Cell Index")}
  
  # cellZscope
  if(unit == "CPE_A") {return(expression(paste("CPE_A (s"^(n-1),mu,"F/cm"^2, ")")))}
  if(unit == "CPE_n") {return("CPE_n")}
  if(unit == "TER") {return (expression(paste("TER (",Omega," cm"^2, ")")))}
  if(unit == "CcL") {return(expression(paste("CcL (",mu,"F/cm"^2, ")")))}
  if(unit == "Rmed") { return("Rmed (ohm)")}
  
  # If not found, return what was input
  return(unit)
  
}


#' #' Fix typographical errors in an ECIS dataframe
#' #' 
#' #' This function will go through all the sample and experiment names and replace all the values that are incorrect. Usefull for fixing up typographical errors, or places where you have named things differently inadvertently.
#' #'
#' #' @param data.df the data to correct
#' #' @param incorrect the error to be corrected
#' #' @param correct the corrrect string
#' #' @param limit can be set to "Sample or "Experiment" to limit the replacement to a single variable
#' #'
#' #' @return the repared dataframe
#' #' @export
#' #'
#' #' @examples
#' #' 
#' #' #vascr_fix_error(growth.df, "cells", "cells plated")
#' #' 
#' vascr_fix_error = function (data.df, incorrect, correct, limit = "None")
#' {
#'   
#'   if (limit == "None" || limit == "Sample")
#'   {
#'   data.df$Sample = gsub(incorrect, correct, data.df$Sample)
#'   }
#'   
#'   if (limit == "None" || limit == "Experiment")
#'   {
#'   data.df$Experiment = gsub(incorrect, correct, data.df$Experiment)
#'   }
#'   
#'   return(data.df)
#' }


#' Find the mode of a categorical variable
#'
#' @param x vector to find mode of
#'
#' @return the most commonly occouring character 
#' @export
#'
#' @examples
#' categorical_mode(c("Cat", "Cat", "Monkey"))
#' 
categorical_mode = function(x){
  
  if(length(unique(x))==1)
  {
    return (unique(x)) 
  }
  
  ta = table(x)
  tam = max(ta)
  if (all(ta == tam))
    mod = NA
  else
    if(is.numeric(x))
      mod = as.numeric(names(ta)[ta == tam])
  else
    mod = names(ta)[ta == tam]
  return(mod)
}


#' Exclude erronious data from an ECIS dataframe
#'
#' @param data.df The source dataset
#' @param samples The sample(s) to exclude
#' @param wells The well(s) to exclude
#' @param experiments The experiment(s) to exclude
#' @param times The time(s) to exclude
#' @param values The value(s) to exclude
#' @param vs The isolated variables-unit pairs to exclude
#' @param vars The isolated variables to exclude
#' @param vals The isolated values to exclude
#'
#' @return The altered dataset
#' @export
#' 
#' @importFrom dplyr filter
#' @importFrom magrittr "%>%"
#'
#' @examples
#' 
#' unique(growth.df$Sample)
#' excludedgrowth.df = vascr_exclude(growth.df, samples = c("35,000 cells", "0 cells"))
#' unique(excludedgrowth.df$Sample)
#' 
#' unique(growth.df$Well)
#' excludedgrowth.df = vascr_exclude(growth.df, wells = c("A1", "B1", "C1"))
#' unique(excludedgrowth.df$Well)
#' 
#' unique(growth.df$Experiment)
#' excludedgrowth.df = vascr_exclude(growth.df, experiment = c(1,2))
#' unique(excludedgrowth.df$Experiment)
#' 


vascr_exclude = function(data.df, samples = FALSE, wells = FALSE, experiments = FALSE, times = FALSE, values = FALSE, vars = FALSE, vals = FALSE, vs = FALSE)
{
  
  for (sample in samples)
  {
    data.df = data.df %>% filter(Sample != sample)
  }
  
  for (well in wells)
  {
    data.df = data.df %>% filter(Well != well)
  }
  
  for (experiment in experiments)
  {
    data.df = data.df %>% filter(Experiment != experiment)
  }
  
  for (time in times)
  {
    data.df = data.df %>% filter(Time != time)
  }
  
  for (value in values)
  {
    data.df = data.df %>% filter(Value != value)
  }
  
  
  return (data.df)
}




# Worker functions for importing files ------------------------------------


#' Combine ECIS data frames end to end
#' 
#' This funciton will combine ECIS datasets end to end. Preferential to use over a simple rbind command as it runs additional checks to ensure that datapoints are correctly generated
#'
#' @param ... List of data frames to be combined
#' @param resample Automatically try and resample the dataset. Default is FALSE
#'
#' @return A single data frame containing all the data imported, automaticaly incremented by experiment
#' 
#' @export
#'
#' @examples
#' 
#' #Make two fake experiments worth of data
#' 
#' experiment1.df = vascr_subset(growth.df, experiment = "1")
#' experiment2.df = vascr_subset(growth.df, experiment = "2")
#' experiment3.df = vascr_subset(growth.df, experiment = "3")
#' 
#' data = vascr_combine(experiment1.df, experiment2.df, experiment3.df)
#' head(data)
#' 
vascr_combine = function(..., resample = FALSE) {
  
  dataframes = list(...)
  
  # Test filler variables dataframes = list(child1.df, child2.df, child3.df) i = 1
  
  # Generate an empty data frame with the correct columns to fill later
  alldata = dataframes[[1]][0, ]
  loops = 1
  
  # Check that both dataframes have the same timebase
  for (i in dataframes)
  {
    if (!(exists("timepointstomerge")))
    {
      timepointstomerge = unique(i$Time)
    }
    
 if ((!identical(timepointstomerge,unique(i$Time))) & isFALSE(resample))
    {
      warning("Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.")
    }
  }
  
  # Mash all the dataframes together
  
  for (i in dataframes) {
    indata = i
    indata$Experiment = paste(loops, ":", indata$Experiment)
    loops = loops + 1
    alldata = rbind(alldata, indata)
  }
  
  alldata$Experiment = as.factor(alldata$Experiment)
  
  if(isTRUE(resample))
  {
    frequency = vascr_current_frequency(alldata)
    
  }
  
  
  return(alldata)
  
}


#' Retitle
#' 
#' Recapitulation of the funciton in tidyR, allows the re-titling of a data frame from the top row of a dataset. Used in import funcitons to set titles from the content of ABP files. For internal use only.
#'
#' @param df A data frame containing the desired values in the top row
#'
#' @return A dataframe where the top row has been converted to titles.
# 
retitle = function(df) {
  
  names(df) = as.character(unlist(df[1, ]))
  df = df[-1, ]
  df
}


#' Convert comma containing values to numeric ones
#' 
#' This function converts numbers formatted with commas, such as those used in text variables to numbers. This process is lossy, so is used as late as possible before a continuous variable is needed. Preserves decimal places. Vectorised.
#'
#' @param comma_array The array (and hence column of a data frame also works) containing comma separated values to process
#'
#' @return An array containing numeric data. NA will be returned if not numeric, and a warning will be generated
#'
#' @examples
#' 
# # A working dataset
# # comma_to_numeric(c("100.001", "10,839", "882,292,939"))
# 
# # And one with non-numeric and broken data
# # comma_to_numeric(c("Foo", "77,00", "88.88.88"))
#' 
comma_to_numeric = function(comma_array)
{
  # Remove commas and convert to numeric, ignoring any errors
  processed_array = suppressWarnings(as.numeric(gsub(",","",commaarray)))
  
  # Check if there were an problems. If so warn in plain english.
  if(any(is.na(processed_array)))
  {
    warning("Some values processed are not numeric and have been converted to NA. Use with care.")
  }
  
  return(processed_array)
}

#' Look up the default variable values for all supported instruments
#' 
#' Central source of lookup values for default graph settings for various instruments.
#'
#' @param data The dataset to derrive the instrument type from
#'
#' @return
#' @export
#'
#' @examples
#' vascr_default(growth.df)
#' 
vascr_default = function (data)
{

  instrument = categorical_mode(data$Instrument)
  
  if(instrument == "ECIS")
  {
    defaults = list(
      "frequency" = 4000,
      "unit" = "R"
    )
  }
  else if (instrument == "xCELLigence")
  {
    defaults = list(
      "frequency" = 10000,
      "unit" = "CI"
    )
  }
  else if (instrument == "cellZscope")
  {
    defaults = list(
      "frequency"  = 4000,
      "unit" = "R"
    )
  }
  
  return(defaults)
  
}


