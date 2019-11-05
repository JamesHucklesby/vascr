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
#' ecis_standardise_wells('A01')
#' ecis_standardise_wells('A 1')
#' ecis_standardise_wells('tortoise') # Non-standardisable becomes NA
#' ecis_standardise_wells(growth.df$Well)
#' 
ecis_standardise_wells = function(well) {
  
  # First try and fix the user input
  well = toupper(well) # Make it upper case
  well = gsub(" ", "", well, fixed = TRUE) # Remove spaces
  well = gsub("[^0-9A-Za-z///' ]","" , well ,ignore.case = TRUE)
  well = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", well, perl = TRUE) # Add 0's
  
  # Check that it now conforms

  
  if(is.na(match(well[1],ecis_96_well_names())))
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
#' ecis_96_well_names()
#' 
ecis_96_well_names = function()
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
#' ecis_find_time(growth.df, 146.2)
#' 
ecis_find_time = function(data.df, time) {
  times = unique(data.df$Time)
  numberinlist = which.min(abs(times - time))
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
#' 
#' standard = growth.df
#' normal = ecis_normalise(growth.df, 100)
#' ecis_detect_normal(standard)
#' ecis_detect_normal(normal)

ecis_detect_normal = function(data.df)
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
#' exploded.df = ecis_explode(growth.df)
#` cleaned.df = ecis_remove_metadata(exploded.df)
#` identical(growth.df,cleaned.df)
ecis_remove_metadata = function(data.df, subset = "all")
{
  
  summary_level = ecis_test_summary_level(data.df)
  
  if(summary_level == "summary" || summary_level == "experiment")
  {
    warning("You are removing some summary statistics. These are not re-generatable using ecis_explode alone, and must be regenerated with ecis_summarise.")
  }
  
  removed.df = data.df %>% select(Time, Unit, Well, Value, Sample, Frequency, Experiment)
  
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
#' ecis_titles("Rb")
#' 
ecis_titles = function (unit, frequency = 0)
{
  
  # Modeled paramater
  if (unit == "Rb"){return (expression(paste("Rb (",Omega," cm"^2, ")")))}
  if (unit == "Cm"){return (expression(paste("Cm (",mu,"F/cm"^2, ")")))}
  if (unit == "Alpha"){return (expression(paste("Alpha (",ohm," cm"^2, ")")))}
  if(unit == "RMSE") { return("Model Fit RMSE")}
  if(unit == "Drift") { return("Drift (%)")}
  
  # Measured quantaties
  if(unit == "C") { return(expression(paste("Capacitance (",mu,"F)")))}
  if(unit == "R") { return("Resistance (ohm)")}
  if(unit == "P") { return("Phase (degrees)")}
  if(unit == "X") { return("Reactance (ohm)")}
  if(unit == "Z") { return("Impedance (ohm)")}
  
  # If not overriden, return what was input
  return(unit)
  
}


#' Fix typographical errors in an ECIS dataframe
#' 
#' This function will go through all the sample and experiment names and replace all the values that are incorrect. Usefull for fixing up typographical errors, or places where you have named things differently inadvertently.
#'
#' @param data.df the data to correct
#' @param incorrect the error to be corrected
#' @param correct the corrrect string
#' @param limit can be set to "Sample or "Experiment" to limit the replacement to a single variable
#'
#' @return the repared dataframe
#' @export
#'
#' @examples
#' 
#' ecis_fix_error(growth.df, "cells", "cells plated")
#' 
ecis_fix_error = function (data.df, incorrect, correct, limit = "None")
{
  
  if (limit == "None" || limit == "Sample")
  {
  data.df$Sample = gsub(incorrect, correct, data.df$Sample)
  }
  
  if (limit == "None" || limit == "Experiment")
  {
  data.df$Experiment = gsub(incorrect, correct, data.df$Experiment)
  }
  
  return(data.df)
}


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

