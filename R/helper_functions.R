#' Calculate mode of a dataset
#'
#' @param v Vector of numeric data to find the mode of
#'
#' @return The mode of the vector
#' @export
#'
#' @examples
#' getmode(c(1,3,3,4,7))
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


#' Calculate the median well in a set of wells
#' 
#' This function finds the well that is the median of a set. This will be the most spacially central well on a plate. Using median eliminates the risk of well locations clashing, as the returned well will always be one of the set input. This also eliminates the noise associated with single replicates that need to be moved to the edge of a plate for technical reasons, however it will also mask that this movement has happened.
#' 
#' Works for both vertical, horrosontal and diffuse well configurations
#'
#' @param wells A vector of wells to find the median of
#'
#' @return The name of the median well
#' @export
#'
#' @examples
#' vascr_median_well (c("A1", "B2", "C3"))
#' vascr_median_well(c("A1", "NA", "NA", "NA"))
vascr_median_well = function(wells)
{
  
  # First we create a temporary data frame to hold the transformations. Each well entered is a row
  Well = vascr_standardise_wells(wells)
  Well = as.data.frame(Well)
  
  if(any("NA" %in% Well$Well))
  {
    warning("NA's in averaged wells, these will be removed")
    Well = subset(Well, Well != "NA")
  }
  
  # Explode out rows and columns
  explodedwells = vascr_explode_wells(Well)
  
  # Convert row letters on the plate into numbers for finding the median
  letternums <- letters[1:26]
  explodedwells$lowerrow = casefold(explodedwells$row, upper = FALSE)
  explodedwells$numberrow = match(explodedwells$lowerrow, letternums)
  
  # Check everything is numeric to avoid errors
  explodedwells$numberrow = as.numeric(explodedwells$numberrow)
  explodedwells$numbercol = as.numeric(explodedwells$col)
  
  medianrow = median(explodedwells$numberrow)
  mediancol = median(explodedwells$numbercol)
  
  medianrow = letternums[medianrow]
  
  finalwell = paste(medianrow, mediancol)
  finalwell = vascr_standardise_wells(finalwell)
  
  return(finalwell)
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
#' vascr_find_frequency(data, frequency = 4000)
#' 
#' data.df = data
#' 
vascr_find_frequency = function(data.df, frequency) {
  if(!is.numeric(frequency))
  {
    allowedtext = c("raw", "model")
    
    if(frequency %in% allowedtext)
    {
      return(frequency)
    }
    else
    {
      warning("Frequency specified is not a number, 'raw' or 'model'. Please correct this argument")
    }
  }
  
  data.df$Frequency = as.numeric(as.character(data.df$Frequency))
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

#' Check the level of a vascr data frame
#'
#' @param data The data frame to analyse
#'
#' @return
#'
#' @examples
#' vascr_detect_level(growth.df)
#' vascr_detect_level(vascr_summarise(growth.df, level = "experiments"))
#' vascr_detect_level(vascr_summarise(growth.df, level = "summary"))
vascr_detect_level = function(data)
{
  if("totaln" %in% colnames(data))
  {
    return("summary")
  }
  else if ("n" %in% colnames(data))
  {
    return("experiments")
  }
  else
  {
    return("wells")
  }
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


#' Calculate the variable priority for a vascr dataset
#' 
#' This function calculates the order of priority of variables in a vascr dataset so they can be plotted in the most meaningfull way
#' 
#' @param data The dataset to generate priorities for
#' @param explicit Any varaibles that are explicity used in graph generation, and therefore are removed from the priority vector
#' @param priority Non-standard priority order. All values in this will be returned, and supplimented with the default set if "..." is inserted into the list
#'
#' @return A vector of priorities to plot
#' 
#' @export
#'
#' @examples
#' vascr_priority()
#' vascr_priority(growth.df)
#' vascr_priority(growth.df, priority = c("cells", "...", "Well"))
#' 
#' vascr_priority(data = growth.df, priority = c("Sample"))
#' 
#' vascr_priority(data = growth.df)
#' 
#' missing.df = growth.df
#' missing.df$Value = NULL
#' 
#' vascr_priority(missing.df)
#' 
#' # vascr_priority(filtered.df)
#' 
#' vascr_priority(data)
vascr_priority = function(data = NULL, explicit = NULL, priority = NULL)
{
  
  # Load in the default built-in priority order
  builtin = c("Value","Time","Frequency", "Sample",  "Experiment", "Instrument", "Unit", "Well")
  
  level = vascr_detect_level(data)
  
  if(level == "experiments" || level=="summary")
  {
    data$Well = "NA"
  }
  
  # Return this list if no data was provided to compare against, or that data is an inappropriate format
  if(!is.data.frame(data))
  {
    if(is.null(data))
    {
      builtin = builtin
    }else
    {
      warning("Data is not a data frame, the whole priority vector has been returned")
      bulitin = builtin
    }
  } 
  
  
  
  # Modify the default list to suit the request
  if(is.null(priority))
  {
    defaultstack = builtin # Use default, as no priority given
  } else
  {
    
   #We must use what the user gave us, adding in the default where "..." is seen
    
   dot = match("...",priority)
   dot = as.numeric(min(dot))
   
   if(is.na(dot))
   {
     defaultstack = priority
   }else if(dot == length(priority))
   {
     defaultstack = c(priority,builtin)
   }
   else if(dot == 1)
   {
     defaultstack = c(builtin, priority)
   }else
   {
     defaultstack = c(priority[1:(dot-1)], builtin, priority[(dot+1):length(priority)])
   }
   
   # Check that each priority is only in there once
   defaultstack = unique(defaultstack)
   
  }
  
  # Remove explicit variables, if not specified use the defaultstack
  if(!is.null(explicit))
  {
    stack = defaultstack[!defaultstack %in% explicit]
  }else
  {
    stack = defaultstack
  }
  
  
  # Stop here if not a data frame
  if(!is.data.frame(data))
  {
    return (stack)
  }
  
  # Strip out anything from the stack that is not actually in the data
  datacols = colnames(data)
  cols = stack[stack %in% datacols]
  unique = c()
  
  for(val in cols)
  { # Stack not generated yet
    unique = c(unique, as.vector(unique(data[val])))
  }
  
  # Then calculate if the length of each one is greater than 1 (IE it's worth plotting as they're not all the same)
  lengths = c()
  for (val in unique){
    lengths = c(lengths,(length(val))>1)
  }
  
  #Filter out the columns that are relevant
  stack = cols[lengths]
  
  return(stack)
  
}


#' Remove columns if they exist in a dataset, otherwise do nothing
#'
#' @param data.df The dataset to remove
#' @param cols The name, or names, of cols to remove
#'
#' @return The truncated data set
#'
#' @examples
#' remove_cols_if_exists(data.df, c("Unit", "Sample", "Donkey"))
remove_cols_if_exists = function(data.df, cols)
{
  
  for(col in cols)
  {
    if(col %in% colnames(data.df))
    {
      data.df = select(data.df, -col)
    }
  }
  
  return(data.df)
}


#' Clean the statistics off a vascr dataset
#'
#' @param data.df The dataset to clean
#'
#' @return
#'
#' @examples
#' vascr_remove_stats(vascr_summarise(growth.df,level = "summary"))
#' 
vascr_remove_stats = function(data.df)
{
  data.df = remove_cols_if_exists(data.df, cols = c("sd", "sem", "min", "max", "ymin", "ymax", "sd", "n", "totaln"))
  return(data.df)
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
#' vascr_titles("R")
#' 
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



#' Title
#'
#' @param units 
#'
#' @return
#' @export
#'
#' @examples
#' vascr_titles_vector(c("Rb", "R", "Cm"))
#' 
vascr_titles_vector = function(units)
{
return = c()

for(uni in units)
{
  
  if(uni == "Rb"){parsed = "Rb (chm cm squared)"}
  else if(uni == "Cm"){parsed = "Cm (microfarad / cm squared)"}
  else if(uni == "Alpha"){parsed = "Alpha (ohm cm squared)"}
  else if(uni == "C"){parsed = "Capacatance (microfarad)"}
else if(uni == "CPE_A"){parsed = "Capacatance (microfarad)"}
else if(uni == "TER"){parsed = "TER (ohm cm squared)"}
  
  else {parsed = vascr_titles(uni)}

  
  return = c(return, parsed)
}

return(return)

}



#' Table of units used in the vascr package
#'
#' @return A data frame of units, their content and if they are modeled
#' @export 
#'
#' @examples
#' 
#' vascr_units_table()
#' 
vascr_units_table = function()
{
allunits = vascr_instrument_units("all")
vascr_unit_table = data.frame(allunits)
colnames(vascr_unit_table) = "Unit"

vascr_unit_table$Content = vascr_titles_vector(vascr_unit_table$Unit)

vascr_unit_table$Modeled = vascr_is_modeled_unit(vascr_unit_table$Unit)

vascr_unit_table$Instrument = vascr_instrument_from_unit(vascr_unit_table$Unit)


return(vascr_unit_table)
}


#' Find which modeled units in the dataset
#'
#' @param data The dataset to analyse
#'
#' @return A vector of the modeled units in the dataset
#'
#' @examples
#' vascr_modeled_in_data(growth.df)
#' 
#' 
vascr_modeled_in_data = function(data)
{
  allunits = unique(data$Unit)
  return(allunits[vascr_is_modeled_unit(allunits)])
}
  
#' Return the raw units in the dataset
#'
#' @param data The dataset to search
#'
#' @return A vector containing the raw units present in the data
#'
#' @examples
#' vascr_raw_in_data(growth.df)
#' 
vascr_raw_in_data = function(data)
{
  allunits = unique(data$Unit)
  return(allunits[!vascr_is_modeled_unit(allunits)])
}

#' Split out all the frequenices if all is presented
#'
#' @param data.df The dataet to analyse
#' @param frequency The frequency to analyse
#'
#' @return A number of a frequency in the dataset
#'
#' @examples
#' 
#' vascr_realise_frequencies(growth.df, c(4594, 3000, "all"))
#' 
vascr_realise_frequencies = function(data.df, frequency)
{
  units = c()
  
  for(fre in frequency)
  {
    if(tolower(fre) == "all")
    {
      units = c(units, unique(data.df$Frequency))
    } else
    {
      units = c(units, fre)
    }
  }
  
 returndata = c()
  
 for(uni in units)
 {
   
   returndata = c(returndata, vascr_find_frequency(data.df, as.numeric(uni)))
 }
  
 returndata = unique(returndata) 
 
  return(returndata)
  
}


#' Realise vascr units
#'
#' @param data The dataset to process
#' @param unit The unit(s) to return
#'
#' @return A vector of vascr units
#'
#' @examples
#' vascr_realise_units(growth.df, c("Rb", "R", "Cm"))
#' vascr_realise_units(growth.df, "all")
#' vascr_realise_units(growth.df, "modeled")
#' vascr_realise_units(growth.df, "raw")
#' 
vascr_realise_units = function (data, unit)
{
  return = c()
  
  for(uni in unit)
  {
      if(tolower(uni) == "raw")
      {
        return = c(return,(vascr_raw_in_data(data)))
      } else if(tolower(uni) == "modeled")
      {
        return = c(return,(vascr_modeled_in_data(data)))
      } else if (tolower(uni) == "all")
      {
        return = c(return,unique(data$Unit))
      } else
      {
        return = c(return,uni)
       }
  
  }
  
  # Weed out any duplicates, if present
  return = unique(return)
  return(return)
}


#' Check if a selected unit is modelled
#'
#' @param unit The vascr symbol for the unit
#'
#' @return A boolean, true if it is modelled, false if it is raw electrical data
#' @export
#'
#' @examples
#' vascr_is_modeled_unit("R")
#' vascr_is_modeled_unit("Rb")
#' vascr_is_modeled_unit(c("R", "Rb"))
#' 
vascr_is_modeled_unit = function(unit)
{
  return = c()
  model_units = c("Rb","Cm","Alpha","RMSE","Drift","CPE_A" ,"CPE_n" ,"TER" , "Ccl", "Rmed")
  
  for(uni in unit)
  {
    return = c(return, uni %in% model_units)
  }
  
  return(return)
}

#' Return the units created by a certain instrument
#'
#' @param instrument The instrument to find the units for
#'
#' @return a vector of units provided by an instrument
#'
#' @examples
#' vascr_instrument_units("ECIS")
#' vascr_instrument_units("xCELLigence")
#' vascr_instrument_units("cellZscope")
#' 
vascr_instrument_units =  function(instrument)
{
  instrument = tolower(instrument)
  
  if(instrument =="ecis") {return (c("Alpha" ,"Cm"   , "Drift", "Rb"   , "RMSE" , "C"   ,  "P"     ,"R"   ,  "X"  ,   "Z"))}
  if(instrument =="xcelligence") {return(xcelligence = c("Z", "CI"))}
  if(instrument =="cellzscope") { return(c("CPE_A", "CPE_n", "TER", "Ccl", "Rmed", "C"   ,  "P"     ,"R"   ,  "X"  ,   "Z"))}
  
  # If all are selected, build the full list by calling this same funciton recusivley
  if(instrument =="all"){return(unique(c(vascr_instrument_units("ecis"), vascr_instrument_units("xcelligence"), vascr_instrument_units("cellzscope"))))}
}

#' Work out which instrument(s) generated a unit
#'
#' @param unit The unit(s) to test
#'
#' @return The instrument(s) separated by "+" that could have generated that value. If more than one unit was entered a stirng will be generated for each unit.
#'
#' @examples
#' 
#' vascr_instrument_from_unit("Rb")
#' vascr_instrument_from_unit("CI")
#' vascr_instrument_from_unit("TER")
#' 
#' vascr_instrument_from_unit(c("Rb", "TER"))
#' 
#' vascr_instrument_from_unit("NA")
vascr_instrument_from_unit = function(unit)
{
  
  ecis = vascr_instrument_units("ecis")
  xcelligence = vascr_instrument_units("xcelligence")
  cellzscope = vascr_instrument_units("cellzscope")
  instruments = c()
  return = c()
  
for (uni in unit)
  {
  if (uni %in% ecis)
  {
    instruments = c(instruments, "ECIS")
  }
  if (uni %in% xcelligence)
  {
    instruments = c(instruments, "xCELLigence")
  }
  if (uni %in% cellzscope)
  {
    instruments = c(instruments, "cellZscope")
  }

  return = c(return,(paste(instruments, collapse = " + ")))
  instruments = c()
  }
 
  return(return) 
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
    alldata = vascr_resample(alldata, frequency, min(alldata$Time), max(alldata$Time))
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


#' Execute do.call for all variables that exist in the funciton being called
#'
#' @param name Name of the funciton to call
#' @param payload The key data frame or graph to be passed on
#' @param arguments Any arguements to apply
#'
#' @return The returned value from the function applied
#'
#' @examples
#' # Not relevant here
#' 
do.call_relevant = function(name, payload, arguments)
{
  function_args = formals(name)
  
  toforward = names(function_args) %in% names(arguments)
  
  toforwardnames = as.vector(names(function_args))[toforward]
  
  present_args = arguments[toforwardnames]
  
  if(is.data.frame(payload))
  {
    present_args[["data"]] = payload
  }
  else if(is.ggplot(payload))
  {
    present_args[["plot"]] = payload
  }
  
  return(do.call(name, present_args))
}

