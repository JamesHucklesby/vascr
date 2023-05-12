

#' Guess at what the default values are for a dataframe
#'
#' @param dataframe The data frame to detect the defaults from
#'
#' @return A list of values with the recommended defaults
#' 
#' @noRd
#'
#' @examples
#' vascr_find_defaults(growth.df)
#' 
vascr_find_defaults = function(dataframe)
{
  # Create a named list to fill
  defaults = list()
  
  # Create a mini version of the dataset, with only the distinct values this function deals with for speed
  subset = dataframe %>% select(Instrument, Unit, Frequency, Time, Experiment, Sample, Well, Value) %>% distinct
  
  # Calcuate the default instrument, and subset the dataframe so clashes don't happen later
  instrument_priority = c("ECIS", "xCELLigence","cellZscope")
  defaults$Instrument = find_priority(instrument_priority, subset$Instrument)
  subset = subset %>% filter(Instrument == defaults$Instrument)
  
  # Calculate the default unit
  unit_priority = c("R", "Rb", "TER", "Z", "CI", "Alpha", "Cm", "Ccl",  "X", "C" , "P" , "Drift", "RMSE","CPE_A", "CPE_n","Rmed")
  defaults$Unit = find_priority(unit_priority, subset$Unit)
  subset = subset %>% filter(Unit == defaults$Unit) 
  
  # Find the default frequency, closest to 4000
  defaults$Frequency = closest_value(4000, subset$Frequency)
  subset = subset %>% filter(Frequency == defaults$Frequency) 
  
  # Default experiment, the one with the most values in the remaining dataset
  defaults$Experiment = categorical_mode(subset$Experiment)
  subset = subset %>% filter(Experiment == defaults$Experiment) 
  
  # Find the default time, at the middle of the dataset
  defaults$Time = locked_median(subset$Time)
  subset = subset %>% filter(Time == defaults$Time) 
  
  # Default Sample, the first one remaining in the dataset
  defaults$Sample = subset$Sample[1]
  subset = subset %>% filter(Sample == defaults$Sample) 
  
  # Default Well, the first one remaining in the dataset
  defaults$Well = subset$Well[1]
  subset = subset %>% filter(Well == defaults$Well) 
  
  # Default Value, the median remaining in the dataset
  defaults$Value = locked_median(subset$Value)
  subset = subset %>% filter(Value == defaults$Value)
  
  return(defaults)

  }


#' Title
#'
#' @param priority 
#' @param data_vector 
#'
#' @return
#' @noRd
#'
#' @examples
find_priority = function(priority, data_vector)
  {
  
  # Generate unique values to speed up the match later if needed
  data_vector = unique(data_vector)
  
  # Add all values of the data vector onto the end of the priority list in the order they appear, just in case there was an oversight in generating the priority listing
  priority = unique(c(priority, data_vector))
  
  # Work through each priority until one is found that is in the current list
  for(current in priority) 
  {
    if(current %in% data_vector)
    {
      return(current) # If the current priority is in the dataset, return it
    } # otherwise keep working through
  }
  
  # This should never run, as everything in the data vector is by definition in the priority list
  stop("Priority matching failure")
  
}

#' Title
#'
#' @param data_vector A vector of data to calculate the locked median of
#'
#' @return
#' @noRd
#'
#' @examples
locked_median = function(data_vector)
{
  numeric_vector = as.numeric(data_vector)
  median = median(as.numeric(data_vector)) # Find the median, however this may be between two values
  locked_median = closest_value(median, data_vector)
  return(locked_median)
}

#' Title
#'
#' @param target 
#' @param data_vector 
#'
#' @return
#' 
#' @noRd
#'
#' @examples
closest_value = function(target, data_vector)
{
  target_location = which.min(abs(data_vector - target)) # Find which value in the vector is closest to the actual median
  return(data_vector[target_location])
}





#' Standardise well names accross import types
#' 
#' Replaces A1 in strings with A01. Important for importing ABP files which may use either notation. Returns NA if the string could not be normalised, which can be configured to throw a warning in import code.
#'
#' @param well The well to be standardised 
#'
#' @return Standardised well names
#' 
#' @noRd
#'
#' @examples 
#' #vascr_standardise_wells('A01')
#' #vascr_standardise_wells('A 1')
#' #vascr_standardise_wells('tortoise') # Non-standardisable becomes NA
#' #vascr_standardise_wells(growth.df$Well)
#' 
vascr_standardise_wells = function(well) {
  
  
  uniquewell = unique(well)
  original_unique = uniquewell
  
  # First try and fix the user input
  uniquewell = toupper(uniquewell) # Make it upper case
  uniquewell = gsub(" ", "", uniquewell, fixed = TRUE) # Remove spaces
  uniquewell = gsub("[^0-9A-Za-z///' ]","" , uniquewell ,ignore.case = TRUE)
  uniquewell = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", uniquewell, perl = TRUE) # Add 0's
  uniquewell = gsub("00", "0", uniquewell)
  
  # Check that it now conforms
  
  validnames = vascr_96_well_names()
  uniquewell = if_else(uniquewell %in% validnames, uniquewell, "NA" )
  
  exchange = data.frame(well = original_unique, uniquewell)
  wells = data.frame(well)
  
  return = wells %>% left_join(exchange,  by = "well")
  
  return(return$uniquewell)
}

#' All the well names of a 96 well plate
#'
#' @return Vector containing all wells of a 96 well plate
#' 
#' @noRd
#'
#' @examples
#' #vascr_96_well_names()
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




#' Detect if an ECIS dataset has been normalised
#'
#' @param data.df an ECIS dataset
#'
#' @return The time the data was normalised to, or FALSE if not normalised
#' 
#' @noRd
#'
#' @examples
#' #growth.df$Instrument = "ECIS"
#' #standard = growth.df
#' #normal = vascr_normalise(growth.df, 100)
#' #vascr_detect_normal(standard)
#' #vascr_detect_normal(normal)

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
#' @return The level of the dataset analysed
#' 
#' @noRd
#'
#' @examples
#' #vascr_detect_level(growth.df)
#' #vascr_detect_level(vascr_summarise(growth.df, level = "experiments"))
#' #vascr_detect_level(vascr_summarise(growth.df, level = "summary"))
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
#' @importFrom dplyr any_of
#'
#' @return A dataset containing only the core ECIS columns
#' 
#' @noRd
#'
#' @examples
#' #growth.df$Instrument = "ECIS"
#' #exploded.df = vascr_explode(growth.df)
#' #cleaned.df = vascr_remove_metadata(exploded.df)
#' #identical(growth.df,cleaned.df)
vascr_remove_metadata = function(data.df, subset = "all")
{
  
  summary_level = vascr_detect_level(data.df)
  
  if(summary_level == "summary" || summary_level == "experiment")
  {
    warning("You are removing some summary statistics. These are not re-generatable using vascr_explode alone, and must be regenerated with vascr_summarise.")
  }
  
  removed.df = data.df %>% select(any_of(vascr_cols()))
  
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
#' @noRd
#'
#' @examples
#' #vascr_priority()
#' #vascr_priority(growth.df)
#' #vascr_priority(growth.df, priority = c("cells", "...", "Well"))
#' 
#' #vascr_priority(data = growth.df, priority = c("Sample"))
#' 
#' #vascr_priority(data = growth.df)
#' 
#' #missing.df = growth.df
#' #missing.df$Value = NULL
#' 
#' #vascr_priority(missing.df)
#' 
#' # vascr_priority(filtered.df)
#' 
#' # vascr_priority(data)
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
  }else {
    stack = defaultstack
  }
  
  
  # Stop here if not a data frame
  if(!is.data.frame(data))
  {
    return (stack)
  }
  
  # Strip out anything from the stack that is not actually changing in the data
  datacols = vascr_find_changing_cols(data)
  cols = stack[stack %in% datacols]

  return(cols)
  
}




#' Remove columns if they exist in a dataset, otherwise do nothing
#'
#' @param data.df The dataset to remove
#' @param cols The name, or names, of cols to remove
#'
#' @return The truncated data set
#' 
#' @noRd
#'
#' @examples
#' #remove_cols_if_exists(growth.df, c("Unit", "Sample", "Donkey"))
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
#' @return A vascr dataset, without any statistical columns
#' 
#' @noRd
#'
#' @examples
#' #vascr_remove_stats(vascr_summarise(growth.df,level = "summary"))
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
#' 
#' @noRd
#'
#' @examples
#' 
#' #vascr_titles("Rb")
#' #vascr_titles("R")
#' 
#' 
vascr_titles= function (unit, frequency = 0, prefix = "")
{

  # Electrical quantaties
  if(unit == "C") { return(bquote(.(prefix)~"Capacitance ("~mu~"F "~frequency~" Hz)"))}
  if(unit == "R") { return(paste(prefix,"Resistance (ohm, ", frequency," Hz)"))}
  if(unit == "P") { return(paste(prefix,"Phase (ohm, ", frequency," Hz)"))}
  if(unit == "Pr") { return(paste(prefix,"Phase (radians, ", frequency," Hz)"))}
  if(unit == "X") { return(paste(prefix,"Reactance (ohm, ", frequency," Hz)"))}
  if(unit == "Z") { return(paste(prefix,"Impedance \n (ohm, ", frequency," Hz)"))}
  
  # ECIS paramaters
  if (unit == "Rb"){return ("Rb (ohm cm^2)")}
  if (unit == "Cm"){return (bquote(bold(atop(" ",.(prefix)~"Cm ("~mu~"F/cm"^2~")"))))}
  if (unit == "Alpha"){return (expression(bold(paste("Alpha (",ohm," cm"^2, ")"))))}
  if(unit == "RMSE") {return(paste(prefix,"Model Fit RMSE"))}
  if(unit == "Drift") {return(paste(prefix,"Drift (%)"))}
  
  # xCELLigence
  if(unit == "CI") {return("Cell Index")}
  
  # cellZscope
  if(unit == "CPE_A") {return(expression(paste(prefix,"CPE_A (s"^(n-1),mu,"F/cm"^2, ")")))}
  if(unit == "CPE_n") {return(paste(prefix,"CPE_n"))}
  if(unit == "TER") {return (bquote(atop(" ",.(prefix)~"TER ("~Omega~" cm"^2~")")))}
  if(unit == "Ccl") {return(bquote(atop(" ",.(prefix)~C[CL]~ "("~mu~"F/cm"^2~ ")")))}
  if(unit == "Rmed") { return(paste(prefix,"Rmed (ohm)"))}
  
  # If not found, return what was input
  return(unit)
  
}

# data.df = growth.df %>% vascr_subset(unit = "Rb") %>%
#   vascr_normalise(normtime = 100)

#' Title
#'
#' @param data.df 
#'
#' @return
#' 
#' @noRd
#'
#' @examples
#' data.df = growth.df %>% vascr_subset(unit = "Rb") %>% 
#' vascr_normalise(normtime = 100)
#' 
#' 
vascr_df_title = function(data.df)
{
  
  keyunit = data.df$Unit %>% unique() %>% as.character()
  keyunit = keyunit[[1]]
  
  keyfrequency = data.df$Frequency %>% unique() %>% as.character()
  keyfrequency = keyunit[[1]]
  
  basetitle = vascr_titles(keyunit, keyfrequency)
  
  is_normalised = vascr_test_normalised(data.df)
  
  if(is_normalised)
  {
    basetitle = paste("Fold change in", keyunit)
  }
  
  return(basetitle)
  
}



#' Title
#'
#' @param string1 First string
#' @param string2 Second string
#'
#' @return
#' @noRd
#'
#' @examples
#' 
#' "cat" %p% "hat"
`%p%` = function(string1, string2)
{
  return(paste(string1, string2, sep = ""))
}


#' Generate human readable versions of the unit variable for graphing
#'
#' @param unit The unit to submit
#' @param frequency The frequency to submit
#'
#' @return An expression containing the correct data label for the unit
#' 
#' @keywords internal
#'
#' @examples
#' 
#' #vascr_titles("Rb")
#' #vascr_titles("R")
#' 
#' 
vascr_graph_titles= function (data.df)
{
  
  unit = unique(data.df$Unit) %>% as.character()
  frequency = unique(data.df$Frequency) %>% as.character()
  normalised = vascr_test_normalised(data.df)
  
  title = unit %p% " (" %p% frequency %p% " Hz)"
  
  if(unit == "R" & normalised)
  {
    title = "**Overall resistance**<br>Ohm (" %p% frequency %p% " Hz)"
  }
  
  
  if(unit == "Rb" & normalised)
  {
    title = "**Cell-Cell interaciton**<br>Fold change in Rb"
  }
  
  if(unit == "Cm" & normalised)
  {
    title = "**Membrane capacatance**<br>Fold change in Cm"
  }
  
  if(unit == "Alpha" & normalised)
  {
    title = "**Basolateral adhesion**<br>Fold change in Alpha"
  }
  

  return(title)
  
  # # Electrical quantaties
  # if(unit == "C") { return(bquote(.(prefix)~"Capacitance ("~mu~"F "~frequency~" Hz)"))}
  # if(unit == "R") { return(paste(prefix,"Resistance (ohm, ", frequency," Hz)"))}
  # if(unit == "P") { return(paste(prefix,"Phase (ohm, ", frequency," Hz)"))}
  # if(unit == "Pr") { return(paste(prefix,"Phase (radians, ", frequency," Hz)"))}
  # if(unit == "X") { return(paste(prefix,"Reactance (ohm, ", frequency," Hz)"))}
  # if(unit == "Z") { return(paste(prefix,"Impedance \n (ohm, ", frequency," Hz)"))}
  # 
  # # ECIS paramaters
  # if (unit == "Rb"){return ("Rb (ohm cm^2)")}
  # if (unit == "Cm"){return (bquote(bold(atop(" ",.(prefix)~"Cm ("~mu~"F/cm"^2~")"))))}
  # if (unit == "Alpha"){return (expression(bold(paste("Alpha (",ohm," cm"^2, ")"))))}
  # if(unit == "RMSE") {return(paste(prefix,"Model Fit RMSE"))}
  # if(unit == "Drift") {return(paste(prefix,"Drift (%)"))}
  # 
  # # xCELLigence
  # if(unit == "CI") {return("Cell Index")}
  # 
  # # cellZscope
  # if(unit == "CPE_A") {return(expression(paste(prefix,"CPE_A (s"^(n-1),mu,"F/cm"^2, ")")))}
  # if(unit == "CPE_n") {return(paste(prefix,"CPE_n"))}
  # if(unit == "TER") {return (bquote(atop(" ",.(prefix)~"TER ("~Omega~" cm"^2~")")))}
  # if(unit == "Ccl") {return(bquote(atop(" ",.(prefix)~C[CL]~ "("~mu~"F/cm"^2~ ")")))}
  # if(unit == "Rmed") { return(paste(prefix,"Rmed (ohm)"))}
  # 
  # # If not found, return what was input
  # return(unit)
  
}




#' Convert a vector of titles into full names of units
#'
#' @param units A vector of units to return
#'
#' @return A vector of names of the units returned
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_titles_vector(c("Rb", "R", "Cm"))
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
#' 
#' @noRd
#'
#' @examples
#' #vascr_units_table()
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


#' Check if a selected unit is modelled
#'
#' @param unit The vascr symbol for the unit
#'
#' @return A boolean, true if it is modelled, false if it is raw electrical data
#' 
#' @noRd
#'
#' @examples
#' #vascr_is_modeled_unit("R")
#' #vascr_is_modeled_unit("Rb")
#' #vascr_is_modeled_unit(c("R", "Rb"))
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
#' @noRd
#'
#' @examples
#' #vascr_instrument_units("ECIS")
#' #vascr_instrument_units("xCELLigence")
#' #vascr_instrument_units("cellZscope")
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
#' @noRd
#'
#' @examples
#' 
#' #vascr_instrument_from_unit("Rb")
#' #vascr_instrument_from_unit("CI")
#' #vascr_instrument_from_unit("TER")
#' 
#' #vascr_instrument_from_unit(c("Rb", "TER"))
#' 
#' #vascr_instrument_from_unit("NA")
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

#' Returns a list of the instruments supported by the VASCR package
#'
#' @return A vector of all the supported instrument names
#' 
#' @noRd
#'
#' @examples
#' # vascr_instrument_list()
vascr_instrument_list = function()
{
  return(c("ECIS", "xCELLigence", "cellZscope"))
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
#' #unique(growth.df$Sample)
#' #excludedgrowth.df = vascr_exclude(growth.df, samples = c("35,000 cells", "0 cells"))
#' #unique(excludedgrowth.df$Sample)
#' 
#' #unique(growth.df$Well)
#' #excludedgrowth.df = vascr_exclude(growth.df, wells = c("A1", "B1", "C1"))
#' #unique(excludedgrowth.df$Well)
#' 
#' #unique(growth.df$Experiment)
#' #excludedgrowth.df = vascr_exclude(growth.df, experiment = c(1,2))
#' #unique(excludedgrowth.df$Experiment)
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
#' #experiment1.df = vascr_subset(growth.df, experiment = "1")
#' #experiment2.df = vascr_subset(growth.df, experiment = "2")
#' #experiment3.df = vascr_subset(growth.df, experiment = "3")
#' 
#' #data = vascr_combine(experiment1.df, experiment2.df, experiment3.df)
#' #head(data)
#' 
vascr_combine = function(..., resample = FALSE) {
  
  dataframes = list(...)
  
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
    indata = vascr_remove_metadata(indata)
    indata$Experiment = paste(loops, ":", indata$Experiment)
    loops = loops + 1
    alldata = rbind(alldata, indata)
  }
  
  alldata$Experiment = as.factor(alldata$Experiment)
  
  if(isTRUE(resample))
  {
    alldata = vascr_resample_time(alldata)
  }
  
  
  return(alldata)
  
}



#' Retitle
#' 
#' Recapitulation of the funciton in tidyR, allows the re-titling of a data frame from the top row of a dataset. Used in import funcitons to set titles from the content of ABP files. For internal use only.
#'
#' @param df A data frame containing the desired values in the top row
#' 
#' @noRd
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
#' @noRd
#'
#' @examples
#' # A working dataset
#' # comma_to_numeric(c("100.001", "10,839", "882,292,939"))
#' 
#' # And one with non-numeric and broken data
#' # comma_to_numeric(c("Foo", "77,00", "88.88.88"))
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



#' Execute do.call for all variables that exist in the funciton being called
#'
#' @param name Name of the funciton to call
#' @param payload The key data frame or graph to be passed on
#' @param arguments Any arguements to apply
#' 
#' @importFrom ggplot2 is.ggplot
#'
#' @return The returned value from the function applied
#' 
#' @noRd
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
    present_args[["data.df"]] = payload
  }
  else if(is.ggplot(payload))
  {
    present_args[["plot"]] = payload
  }
  
  return(do.call(name, present_args))
}



#' Generate ggplot colour hues, for manually specifiying colours that match the default theme
#'
#' @param n Number of variables to access
#' 
#' @importFrom grDevices hcl
#'
#' @return A vector of ggplot colours
#' 
#' @noRd
#' 
#' @examples
vascr_gg_color_hue <- function(n, start = 15, values_needed = c(1:n), l = 65, c = 100) {
  hues = seq(0,365+start, length = n + 1)
  hues = hues + start
  hue_codes = hcl(h = hues, l = l, c = c)[1:n]
  
  hue_codes[values_needed] %>% as.vector()
}


#' Rename a column - cleanup of the built in funciton
#'
#' @param data.df The datset to rename
#' @param old Old column name
#' @param new Replacement column name
#'
#' @return The updated dataset
#' 
#' @noRd
#'
#' @examples
#' # vascr_rename_columns(data.df, "Unit", "Measurement")
#' 
vascr_rename_columns = function(data.df, old, new)
{
  names(data.df)[names(data.df) == old] <- new
  return(data.df)
}


#' Remove an item from a vector
#' 
#' This function cleans up the default R syntax
#'
#' @param values The value(s) to remove
#' @param vector The vector to search and modify
#'
#' @return The modified vector
#' 
#' @noRd
#'
#' @examples
#' 
#' #vector = unique(growth.df$Unit)
#' #vector = vascr_remove_from_vector("Rb", vector)
#' 
vascr_remove_from_vector = function(values, vector)
{
  for (value in values)
  {
    vector = vector[!(vector == value)]
  }
  
  return(vector)
}



#' Title
#'
#' @param df 
#'
#' @return
#' @noRd
#'
#' @examples
#' remove_if_exists(m)
#' 
remove_if_exists = function(df)
{
  if(exists(deparse(substitute(df))))
  {
    rm(df)
  }
}


#' Title
#'
#' @param x 
#' @param table 
#'
#' @return
#' @noRd
#'
#' @examples
"%notin%" <- function(x, table) { match(x, table, nomatch = 0) == 0}


