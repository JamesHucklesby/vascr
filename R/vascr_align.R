#' Subset a vascr datset based on a numebr of factors
#'
#' @param data.df Vascr dataset to subset
#' @param time Specified times. Individual values in a list will be subset out. If vectors are present in the list, values between the two most extreme values will be returned.
#' @param unit Units to subset. These are checked for integrity against possible units and the dataset itself
#' @param well Wells to select
#' @param value_greater_than Select lines where the value is greater than a certain value
#' @param value_less_than Select lines where the value is less than a certain value
#' @param value_equal_to Select lines where the value is equal to a certain value
#' @param sample_contains Return lines where the sample contains a particular value
#' @param sample_not_contains Return lines where theh sample does not contain particular values
#' @param sample_equal_to Return lines when the sample exactly matches a particular string
#' @param variable_set Vector of variables. Lines will be returned if a variable is set.
#' @param variable_unset Vector of variables. Lines will be returned if a variable is not set.
#' @param variable_equal_to Vector of pairs of variables and values. Rows will be returned where each variable matches the value following it.
#' @param variable_not_equal_to Vector of pairs of variables and values. Rows will be returned where each selected variable does not match the value following it.
#' @param variable_greater_than Vector of pairs of variables and values. Rows will be returned where each selected variable is larger than value following it.
#' @param variable_less_than Vector of pairs of variables and values. Rows will be returned where each selected variable is less than value following it.
#' @param include_vehicle Should all relevant vehicle control wells be included in the dataset.
#' @param frequency Frequencies to include in the dataset.
#' @param experiment Experiments to include in the dataset. Can be addressed either by name, or by the numerical order that they were loaded into vascr_combine in
#' @param instrument Which instruments to include values from
#' @param max_deviation Maximum deviation to allow between replicates
#' @param subsample Frequency values shoud be subsampled to
#' @param return_lists Return lists of the varibles to select rather than the subset dataset
#'
#' @return The subset dataset, based on the values selected
#' 
#' @export
#'
#' @examples
#' # vascr_subset(growth.df)
#' # vascr_subset(growth.df, time = 40)
#' # vascr_subset(growth.df, time = NULL)
#'  
#' # vascr_subset(growth.df, unit = "Rb")
#' # vascr_subset(growth.df, unit = "R")
#' # vascr_subset(growth.df, well = "A1")
#' # vascr_subset(growth.df, value_less_than = 100)
#' # vascr_subset(growth.df, max_deviation = 10)
#' 
#' # vascr_subset(growth.df, time = c(5,20))
#' 
#' vascr_subset(growth.df, unit = "Rb")
#' 
vascr_subset = function(subset.df, 
                        time = NULL, 
                        unit = NULL, 
                        well = NULL, 
                        value_greater_than = NULL, 
                        value_less_than = NULL, 
                        value_equal_to = NULL,   
                        sample_contains = NULL,
                        sample_not_contains = NULL,
                        sample_equal_to = NULL,
                        variable_set = NULL,
                        variable_unset = NULL,
                        variable_equal_to = NULL,
                        variable_not_equal_to = NULL,
                        variable_greater_than = NULL,
                        variable_less_than = NULL,
                        include_vehicle = TRUE,
                        frequency = NULL,
                        experiment = NULL,
                        instrument = NULL,
                        max_deviation = NULL,
                        subsample = NULL,
                        return_lists = FALSE,
                        sampleid = NULL,
                        remake_name = FALSE)
{
  
  
  # Subsample (this is the cheapest so let's do it first)
  if(!is.null(subsample))
  {
  subset.df = vascr_subsample(subset.df, subsample)
  }
  
  
  # Unit
  if(!is.null(unit))
  {
  units = vascr_find_unit(subset.df, unit)
  subset.df = subset(subset.df, subset.df$Unit %in% unique(units))
  subset.df$Unit = factor(subset.df$Unit, unique(units))
  }

  
  # Frequency
  if(!is.null(frequency))
  {
    if(typeof(subset.df$Frequency) != "double")
    {
      subset.df = subset.df %>% mutate(Frequency = as.double(Frequency))
    }
    
    frequencies = vascr_find_frequency(subset.df, frequency)
    subset.df = subset(subset.df, subset.df$Frequency %in% frequencies)
  }
  
  
  # Well
  if(!is.null(well))
  {
  wells = vascr_find_well(subset.df, well)
  subset.df = subset(subset.df, subset.df$Well %in% wells)
  }
  
  # Value
  if(!is.null(value_greater_than) | !is.null(value_less_than) | !is.null(value_equal_to))
  {
  values = vascr_find_value(subset.df, value_greater_than, value_less_than, value_equal_to)
  subset.df = subset(subset.df, subset.df$Value %in% values)
  }
  

  
  # Time
  if(!is.null(time))
  {
    times = vascr_find_time(subset.df, time)
    subset.df = subset(subset.df, subset.df$Time %in% times)
  }
  
  # Experiment
  if(!is.null(experiment))
  {
  experiments = vascr_find_experiment(subset.df, experiment)
  subset.df = subset(subset.df, subset.df$Experiment %in% experiments)
  }
  
  # Instrument
  if(!is.null(instrument))
  {
  instruments = vascr_find_instrument(subset.df, instrument)
  subset.df = subset(subset.df, subset.df$Instrument %in% instruments)
  }
  
  # Sample (s) (this is second to last as it is highly CPU intensive, and therefore shoud be imposed on the smallest dataset)

  subset.df = vascr_sample_subset(subset.df, sampleid)
  
  
  # Max deviation (This is last, as it is by far the most expensive operation computationally)
  if(!is.null(max_deviation))
  {
    
    subset.df = vascr_exclude_deviation(data.df = subset.df, deviation = max_deviation, frequency = vascr_find_frequency(subset.df,NA), unit = vascr_find_unit(subset.df, NA))
    
  }

  if(isTRUE(return_lists))
  {
    lists = list(times = times, units = units, well = wells, values = values, samples = samples, frequencies = frequencies, experiments = experiments, instruments = instruments)
    return(lists)
  }
  
  # Check if there is still some data here, and if not sound a warning
  if(nrow(subset.df)==0)
  {
    warning("No data returned from dataset subset. Check your frequencies, times and units are present in the dataset")
  }
  
  if(isTRUE(remake_name) & vascr_detect_level(subset.df) == "wells")
  {
    subset.df = vascr_make_name(subset.df)
  }
  
  return(subset.df)
}




#' Find values within particular paramaters
#'
#' @param data.df The dataset to analyse
#' @param value_greater_than Values will be returned if they're greater than this value 
#' @param value_less_than Values will be returned if less than this value
#' @param value_equal_to Values will be returned if equal to this value
#'
#' @return A list of values that fit the criteria
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_find_value(data.df)
#' 
vascr_find_value = function(data.df, value_greater_than = NULL, value_less_than = NULL, value_equal_to = NULL)
{
  values =unique(data.df$Value)
  
  if(!is.null(value_greater_than))
  {
  values = subset(values, values!="NA")
  values = subset(values, values>value_greater_than)
  }
  
  if(!is.null(value_less_than))
  {
    values = subset(values, values!="NA")
    values = subset(values, values<value_less_than)
  }
  
  if(!is.null(value_equal_to))
  {
    values = subset(values, values!="NA")
    values = subset(values, values == value_equal_to)
  }
  
  return(values)
}


#' Match a string with the closest available option
#'
#' @param tomatch The string to match
#' @param vector The vector to match into
#'
#' @return A character string of the closest matched string
#' 
#' @importFrom utils adist
#' 
#' @keywords internal
#'
#' @examples
#' # vector = vascr_find_unit(growth.df, "all")
#' # vascr_match("Re", vector)
#' # vascr_match("Rb", vector)
#' # vascr_match(c("Rb", "Cm"), vector)
vascr_match = function(match, vector)
{
  toreturn = c()
  
  for(tomatch in match)
  {
  # If an exact match is present, return the matched value
  if(tomatch %in% vector)
  {
    toreturn = c(toreturn, tomatch)
  }
  else
  {
  # Make a data table of the distances between the tables 
  match_table = data.frame(vector)
  match_distance = as.vector(adist(tomatch, vector))
  match_table$Distance = match_distance
  
  # Calculate the change in length, so this can be used as a secondary differentiating factor
  match_table$Delta_Length = abs(str_length(match_table$vector) - str_length(tomatch))
  
  # Sort the table
  match_table = arrange(match_table, Distance, Delta_Length)
  
  matched = match_table[1,1]
  
  string = paste("[",tomatch, "] corrected to [", matched, "]. Please check the argeuments for your functions are correctly typed.", sep = "")
  
  warning(string)
  
  toreturn = c(toreturn, matched)
  }
    
  }
  
  return(toreturn)
  
}

#' Test if a unit is valid
#'
#' @param data.df The dataset to check against
#' @param unit The unit to test
#'
#' @return A boolean
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_is_valid_unit(growth.df, "TEER")
#' # vascr_is_valid_unit(growth.df, "TER")
#' # vascr_is_valid_unit(growth.df, "Rb")
#' 
vascr_is_valid_unit = function(data.df, unit)
{
  table = vascr_units_table()
  units = vascr_units_table()$Unit
  
  if(!(unit %in% units))
  {
    
    table$Distance = as.vector(adist(unit, units))
    table = arrange(table, Distance)
    
    errorcode = paste("No valid unit entered. Automatically corrected to: ",table$Unit[1],"?" )
    
    warning(errorcode)
    return(table$Unit[1])
    
  }
  
  if(!unit %in% unique(data.df$Unit))
  {
    warning("Unit(s) selected is not in dataset, use with care")
  }
  
  return(unit)
  
}


#' Find a valid unit in the dataset, and throw an error if the unit selected is not appropriate
#'
#' @param data.df The dataset to find the unit in
#' @param unit The unit to find
#'
#' @return A vector of units that have been identified
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_find_unit(growth.df, "raw")
#' # vascr_find_unit(growth.df, "modeled")
#' # vascr_find_unit(growth.df, "all")
#' # vascr_find_unit(growth.df, "Cm")
#' # vascr_find_unit(growth.df, NA)
#' # vascr_find_unit(growth.df, unit = c("Ci", "Rb"))
#' 
vascr_find_unit = function(data.df, unit = NA)
  {
  
  if(is.null(unit))
  {
    return(unique(data.df$Unit))
  }
  

  toreturn = c()

  for(uni in unit)
  {
    
    if(is.na(uni))
    {
      
      instruments = unique(data.df$Instrument)
      
      for(instrumentused in instruments)
      {
        if(instrumentused == "ECIS")
        {
          toreturn = c(toreturn, "R")
        }
        if(instrumentused == "cellZscope")
        {
          toreturn = c(toreturn, "TER")
        }
        if(instrumentused == "xCELLigence")
        {
          toreturn = c(toreturn, "CI")
        }
      }
      
    } else if(tolower(uni) == "raw")
    {
      toreturn = c(toreturn,(vascr_raw_in_data(data.df)))
    } else if(tolower(uni) == "modeled")
    {
      toreturn = c(toreturn,(vascr_modeled_in_data(data.df)))
    } else if (tolower(uni) == "all")
    {
      toreturn = c(toreturn,unique(data.df$Unit))
    } else
    {
      allunits = vascr_units_table()$Unit
      
      toreturn = c(toreturn,uni)
    }

  }

  toreturn = unique(toreturn)
  return(toreturn)
  
}

#' DEPRICATED: alias for vascr_find unit
#'
#' @param ... variables for vascr_find_unit
#'
#' @return results from vascr_find_unit
#' 
#' @keywords internal
#'
#' @examples
#' # See vascr_find_unit
vascr_realise_units = function(...)
{
  vascr_find_unit(...)
}


#' Find a well in a local dataset
#'
#' @param data.df The dataset to detect from
#' @param well The well to find
#'
#' @return The string of a valid well to return
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_find_well(growth.df, "A1")
#' # vascr_find_well(growth.df, NULL)
#' 
vascr_find_well = function(data.df, well)
{
  if(is.null(well))
  {
    return(unique(data.df$Well))
  }
  
  # Standardise the well
  well = vascr_standardise_wells(well)
  
  # Check that the well is actually in the dataset
  well = vascr_match(well, unique(data.df$Well))
  
  # Return said well
  return(well)
}
  



#' Find the median of a dataset, forced to a value from which the median is calculated
#' 
#' Usually, this would be the mean of the two centremost values, but that is not appropriate in some situations. Hence this function exists.
#'
#' @param vector Values to find the median of
#' @param round Should it be rounded "up" (default) or "down"
#'
#' @return The forced median value
#' 
#' @keywords internal
#'
#' @examples
#' # vector = unique(growth.df$Frequency)
#' # vascr_force_median(vector)
vascr_force_median = function(vector, round = "up")
{
  vector = as.numeric(vector)
  
  if(round == "up")
  {
    vector = sort(vector, decreasing = TRUE)
  }
  else
  {
    vector =  sort(vector, decreasing = FALSE)
  }
  
  median = median(vector)
  
  forced_median = vector[which.min(abs(vector-median))]
  return(forced_median)
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
#' @keywords internal
#'
#' @examples
#' #vascr_find_frequency(growth.df, 4382)
#' #vascr_find_frequency(growth.df, 4000)
#' #vascr_find_frequency(growth.df, NULL)
#' #vascr_find_frequency(growth.df, NA)
#' #vascr_find_frequency(growth.df, Inf)
#' 
#' #vascr_find_frequency(data.df = growth.df, frequency = c("raw", 0))
#' 
#' # THIS ONE IS CURRENT
#' 
vascr_find_frequency = function(data.df, frequency) {
  
  toreturn = c()
  
  if(is.null(frequency))
  {
    toreturn = c(toreturn,unique(data.df$Frequency))
  }
  
  for (freq in frequency)
  {
  if(is.null(freq))
   {
    toreturn = c(toreturn,unique(data.df$Frequency))
  }
  
  if(is.na(freq))
  {
    toreturn = c(toreturn,vascr_force_median(unique(growth.df$Frequency)))
  }
  
  if(isTRUE(grepl("^[A-Za-z]+$", freq)))
  {
    
    if(freq == "raw")
    {
      rawfrequencies = subset(unique(data.df$Frequency), unique(data.df$Frequency)>0)
      toreturn = c(toreturn, rawfrequencies)
    } else if (freq== "model"){
      toreturn = c(toreturn, 0)
    }else {
      warning("text not found")
    }
    
    
  } else
  {
      
     data.df = data.df %>% mutate(Frequency = as.double(Frequency))
      times = unique(data.df$Frequency)
      freq = as.numeric(freq)
      numberinlist = which.min(abs(times - freq))
      timetouse = times[numberinlist]
      toreturn = c(toreturn, timetouse)
  }
    
  }
  
  return(unique(toreturn))
  
}



#' Find an experiment in a vascr dataset
#'
#' @param data.df The dataset to find the experiment in
#' @param experiment The experiment to find. Either a name or a number from when the experiment is combined can be used.
#'
#' @return A character string of the most closley matched experiment
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_find_experiment(growth.df, 1)
#' # vascr_find_experiment(growth.df, "1 : Experiment 1")
#' 
vascr_find_experiment = function(data.df, experiment)
{
  
  if(is.null(experiment))
  {
    return(unique(data.df$Experiment))
  }
  
  if(is.numeric(experiment))
  {
    fullexperiment = as.vector(unique(data.df$Experiment))
    fullexperiment = sort(fullexperiment)
    return(fullexperiment[experiment])
  }
  
  experiment = vascr_match(experiment, unique(data.df$Experiment))
  return(experiment)
  
}



#' Find a time aligned with a vascr dataset
#'
#' @param data.df The dataset to align to
#' @param time The time to align
#'
#' @return A single time that aligns with the dataset
#' 
#' @keywords internal
#'
#' @examples 
#' #vascr_find_time(data.df, 43.78)
vascr_find_single_time = function(data.df, time)
{
  if(is.null(time))
  {
    return(unique(data.df$Time))
  }
  
  if(length(time)>1)
  {
    warning("Vascr_find_single_time deals with only one time in one call. Use find times if more parsing is needed.")
  }
  
  if(!is.data.frame(data.df))
  {
    stop("Data frame not provided to vascr_deoffset_time")
  }

  
  times = unique(data.df$Time)
  numberinlist = which.min(abs(times - time))
  timetouse = times[numberinlist]
  if(!(timetouse == time))
  {
    stringtoprint = paste("[",time,"]", " corrected to ","[",timetouse,"]. Please check the variables used.")
    warning(stringtoprint)
  }
  
  return(timetouse)
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
#' @keywords internal
#'
#' @examples
#' #vascr_find_time(growth.df, 146.2)
#' #vascr_find_time(growth.df)
#' #vascr_find_time(growth.df, Inf)
#' #vascr_find_time(growth.df, NULL)
#' 
#' #vascr_find_time(growth.df, time = c(5,20))
#' 
vascr_find_time = function(data.df, time = NULL) {
  
  if(is.null(time))
  {
    times = unique(data.df$Time)
    return(times)
  }
  
  
  if(is.list(time))
  {
    times = c()
    
    for(tim in time)
    {
      times = c(times, vascr_find_single_time(data.df, tim))
    }
    
    return(times)
  }
  
  if(all(is.infinite(time)))
  {
    return(unique(data.df$Time))
  }
  
  if(all(is.na(time)))
  {
    times = unique(data.df$Time)
    return(median(times))
  }
  
  

  
  if (length(time) == 2) # If a vector of length 2 was submitted (ie two times) then we subset to that
  {
    times = unique(data.df$Time)
    times = times[(times >= time[1])]
    times = times[(times <= time[2])]
    return(times)
  }
  
  times = vascr_find_single_time(data.df, time)
  return(times)
}





#' Find an instrument known to vascr
#'
#' @param data.df A vascr dataset to analyse
#' @param instrument The instrument to search for
#'
#' @return A vector of strings that match
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_find_instrument(growth.df, "Rb")
#' #vascr_find_instrument(growth.df, "cellZScope")
#' #vascr_find_instrument(growth.df, c("cellZscope", "ECIS"))
#' 
#' #vascr_find_instrument(growth.df, NULL)
vascr_find_instrument = function(data.df, instrument = NULL)
{

  if(is.null(instrument))
  {
    return(unique(data.df$Instrument))
  }
  
  returnvector =c()
  
  for (ins in instrument){
  instruments = vascr_instrument_list()
  repaired = vascr_match(ins, instruments)
  
  if(!repaired %in% unique(data.df$Instrument))
  {
    string = paste(repaired, " data is not present in the dataset. Use with care", sep = "")
    warning(string)
  }
  else
  {
    returnvector = c(returnvector, repaired)
  }
  
  }
  
  if(length(returnvector)==0)
  {
    warning("No selected instruments present in dataset. Use with care.")
  }
  else
  {
    returnvector = unique(returnvector)
  }
  
  return(returnvector)
}


#' Find exploded column names in teh dataset
#'
#' @param data.df The dataset to analyse
#' @param colname The column to look for
#'
#' @return The columns that match
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_find_colname(data.df, "ADP")
#' #vascr_find_colname(data.df, colname = "HCMVEC")
#' 
vascr_find_colname = function(data.df, colname = NULL)
{
  if(is.null(colname))
  {
    toreturn = unique(vascr_exploded_cols(data.df))
    return(toreturn)
  }
  
  explodednames = vascr_exploded_cols(data.df)
  stripednames = vascr_strip_unit(explodednames)
  allnames = c(explodednames, stripednames)
  
  colname = vascr_match(colname, allnames)
  
  if(colname %in% explodednames)
  {
    return(colname)
  }
  
  if(colname %in% stripednames)
  {
    colname = vascr_append_unit(colname, explodednames)
    return(colname)
  }
  
  error("Error in find_colname. Try again.")
  
}



#' Append the unit containing string from a second vector to a non-unit containing string
#'
#' @param strippedcol The column without a string present
#' @param allcols The full colunm names to search
#'
#' @return The appended unit
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_append_unit("ATP", xcell)
vascr_append_unit = function(strippedcol, allcols)
{
  if(is.data.frame(allcols))
  {
    allcols = vascr_exploded_cols(allcols)
  }
  
  allstrippedcols = vascr_strip_unit(allcols)
  strlocation = match(strippedcol, allstrippedcols)
  fullcol = allcols[strlocation]
  
  return(fullcol)
}




#' Strip units from a title containing string
#'
#' @param string The string to strip from
#'
#' @return The trimmed string
#' 
#' @keywords internal
#'
#' @examples
#' # string = c("nm.ml.Oleandrin", "nm.ATP")
#' # vascr_strip_unit(string)
vascr_strip_unit = function(string)
{
  removed = c()
  
  for(str in string)
  {
  lastdotlocation = regexpr("\\.[^\\.]*$", str)[1]
  rem = substr(str, lastdotlocation+1, str_length(str))
  removed = c(removed, rem)
  }
  
  return(removed)
}



#' Check if all arguements are null
#'
#' @param ... List of items, all of which may be null
#'
#' @return Boolean
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_all_null(NULL, TRUE)
vascr_all_null = function(...)
{
  arguments = list(...)
  
  for(var in arguments)
  {
    if(!is.null(var))
    {return(FALSE)}
  }
  
  return(TRUE)
}


#' Check if any of the arguements are null
#'
#' @param ... List of items, all of which may be null
#'
#' @return Boolean
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_all_null(NULL, TRUE)
vascr_any_null = function(...)
{
  arguments = list(...)
  
  for(var in arguments)
  {
    if(is.null(var))
    {return(TRUE)}
  }
  
  return(FALSE)
}

#' Find vascr samples that meet the criteria
#' 
#' Search the samples, based on pairs of datasets. Pass to any variable names of variables paired with what is beng screened for. Using include_vehicle will respect variable 
#'
#' @param data.df The dataset to screen
#' @param sample_contains Returns that samples that contain a string. This is very broad.
#' @param sample_not_contains Include sampels that do not contain this value
#' @param sample_equal_to Return where the sample is an exact match
#' @param variable_set Returns where the variable is set
#' @param variable_unset Returns where the variable is unset
#' @param variable_equal_to Returns if the variable, is equal to the second unit in the vector
#' @param variable_not_equal_to  Returns when the variable is not equal to the second in each pair
#' @param variable_greater_than Returns when the varaible first is greater than the second value.
#' @param variable_less_than Returns when the variable is less than the second value
#' @param include_vehicle Should the vehicle sample be included in the dataset
#'
#' @return A vector of samples that match the criterion
#' 
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_find_sample(xcell, variable_set = "ATP")
#' # vascr_find_sample(growth.df)
#' 
#' # vascr_find_sample(czs)
#' 
#' # data.df = vascr_subset(unifiedr, unit = "Rb")
#' # vascr_find_sample(data.df, variable_equal_to = c("HCMVEC", 20000))
#' 
vascr_find_sample = function(data.df, sample_contains = NULL, sample_not_contains = NULL, sample_equal_to = NULL, variable_set = NULL, variable_unset = NULL, variable_equal_to = NULL, variable_not_equal_to = NULL, variable_greater_than = NULL, variable_less_than = NULL, include_vehicle = TRUE)
{
  if(vascr_all_null(sample_contains, sample_not_contains, sample_equal_to, variable_set, variable_unset, variable_equal_to, variable_not_equal_to, variable_greater_than, variable_less_than))
  {
    return(unique(data.df$Sample))
  }
  
  # Generate a table of all the samples in the dataset
  sample_table = vascr_sample_table(data.df)
  
  # Save a copy for sticking the vehicle on the end later
  original_sample_table = sample_table
  
  # Sample contains
  
  if(!is.null(sample_contains))
  {
    
    sample_table = subset(sample_table, grepl(sample_contains, sample_table$Sample, fixed = TRUE))
    
  }
  
  
  # Sample not contains

  if(!is.null(sample_not_contains))
  {
    sample_table = subset(sample_table, !grepl(sample_not_contains, sample_table$Sample, fixed = TRUE))
  }
  
  # Sample equal to
  
  if(!is.null(sample_equal_to))
  {
    sample_table = subset(sample_table, sample_table$Sample == sample_equal_to)
  }
  
  # Variable set
  if(!is.null(variable_set))
  {
      for(var in variable_set)
      {
        var = vascr_find_colname(data.df, var)
        sample_table = subset(sample_table, !sample_table[var]=="NA")
      }
  }
  
  # Variable unset
  if(!is.null(variable_unset))
  {
    for(var in variable_unset)
    {
      var = vascr_find_colname(data.df, var)
      sample_table = subset(sample_table, sample_table[var]=="NA")
    }
  }
  
  
  # Variable equal to
  if(!is.null(variable_equal_to))
  {
    for(var in variable_equal_to)
    {
      # Only run this code for odd numbers in the vector, as even numbers will be used as the key
      if(vascr_odd_in_vector(var, variable_equal_to))
      {
      variable = vascr_find_colname(data.df, var)
      value = vascr_next_in_vector(var, variable_equal_to)
      
      sample_table = subset(sample_table, sample_table[variable]==value)
      
      }
    }
  }
  
  
  # Variable not equal to
  
  if(!is.null(variable_not_equal_to))
  {
    for(var in variable_not_equal_to)
    {
      # Only run this code for odd numbers in the vector, as even numbers will be used as the key
      if(vascr_odd_in_vector(var, variable_not_equal_to))
      {
        variable = vascr_find_colname(data.df, var)
        value = vascr_next_in_vector(var, variable_not_equal_to)
        
        sample_table = subset(sample_table, sample_table[variable]!=value)
        
      }
    }
  }
  
  # Variable greater than
  if(!is.null(variable_greater_than))
  {
    for(var in variable_greater_than)
    {
      # Only run this code for odd numbers in the vector, as even numbers will be used as the key
      if(vascr_odd_in_vector(var, variable_greater_than))
      {
        variable = vascr_find_colname(data.df, var)
        value = vascr_next_in_vector(var, variable_greater_than)
        
        sample_table = subset(sample_table, sample_table[variable]>value & sample_table[variable] !="NA")
        
      }
    }
  }
  
  # Variable less than
  if(!is.null(variable_less_than))
  {
    for(var in variable_less_than)
    {
      # Only run this code for odd numbers in the vector, as even numbers will be used as the key
      if(vascr_odd_in_vector(var, variable_less_than))
      {
        variable = vascr_find_colname(data.df, var)
        value = vascr_next_in_vector(var, variable_less_than)
        
        sample_table = subset(sample_table, sample_table[variable]<value & sample_table[variable] !="NA")
        
      }
    }
  }
  
  # Include Vehicle, by adding it back in from the original dataset
  
  if(isTRUE(include_vehicle))
  {
    
    # Find vehicles that are still present in the dataset
    vehicles_present = unique(sample_table$Vehicle)
    
    # Subset the vehcile controls present in the dataset that are also present in the subset dataset
    vehicle_samples = subset(original_sample_table, IsVehicleControl == TRUE)
    vehicle_samples = subset(vehicle_samples, vehicle_samples$Vehicle %in% vehicles_present)
    
    # Stick the datasets back together, and remove duplicates if present
    sample_table = rbind(sample_table, vehicle_samples)
    sample_table = distinct(sample_table)
  }
  else if(isFALSE(include_vehicle))
  {
    sample_table = subset(sample_table, IsVehicleControl == FALSE)
  }
  
  
  return(sample_table$Sample)
  
}


#' Checks if the value is placed in an odd position in a vector
#'
#' @param value The value to search for
#' @param vector Vector to search
#'
#' @return A boolean
#' 
#' @keywords internal
#'
#' @examples
#' # vector = vascr_units_table()$Unit
#' # vascr_odd_in_vector("Alpha", vector)
#' # vascr_odd_in_vector("Cm", vector)
#' # vascr_odd_in_vector("Drift", vector)
#' 
#' 
vascr_odd_in_vector = function(value, vector)
{
  location = match(value, vector)
  location = location/2
  testresult = !(round(location,0)==location)
  return(testresult)
}



#' Find the next value in a vector
#'
#' @param value Value to search for
#' @param vector Vector to search
#'
#' @return The value of the next element in the vector
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_next_in_vector("Cm", vector)
#' # vascr_next_in_vector("X", vector)
vascr_next_in_vector = function(value, vector)
{
  location = match(value, vector)
  location = location +1
  return(vector[location])
}


#' Check if a column exists in a dataset
#'
#' @param col Column to search for
#' @param data.df Dataset to search
#'
#' @return A boolean
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_col_exists("Well", data.df)
vascr_col_exists = function(col, data.df)
{
  return(col %in% colnames(data.df))
}


#' Calculate a table of samples present in a dataset
#'
#' @param data.df The dataset to create a table of
#'
#' @return The summarised sample table
#' 
#' @keywords internal
#'
#' @examples
#' # data.df = xcell
#' # samplecols = vascr_sample_table(data.df)
vascr_sample_table = function(data.df)
{
  # Detect vehicles if needed
  if(!vascr_test_exploded(data.df))
  {
    warning("Dataset being exploded, as not currently exploded and must be for this function to work")
    data.df = vascr_explode(data.df)
  }

data.df = vascr_detect_vehicle(data.df)

# Create a list the columns that contain sample information
samplecols = vascr_cols(data.df, set = "exploded")
samplecols = c(samplecols, "Sample")

# Select and find distinct samples
samplecols.df = select(data.df, all_of(samplecols))
samplecols.df = distinct(samplecols.df)

return(samplecols.df)
}


#' Title
#'
#' @param data.df 
#' 
#' @importFrom dplyr tibble left_join
#'
#' @return
#' @export
#'
#' @examples
vascr_number_sample = function(data.df)
{
  sample_list = tibble(Sample = unique(data.df$Sample), SampleID = 1:length(Sample))
  data.df$SampleID = NULL
  data.df = left_join(data.df, sample_list, by = "Sample")
  
  return(data.df)
}
