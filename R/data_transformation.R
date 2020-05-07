# Summary function --------------------------------------------------------

#' Summarise ECIS datasets from a single experiment
#' 
#' Creates and ECIS dataset that has had all samples of the same type averaged together. Assumes that each sample is independent, IE that this function has already been run on individual experiments
#'
#' @param data.df An ECIS dataset in standard format
#' @param level The level of replication to generate the summary at. Options are "experiment" or "summary"
#'
#' @return An ECIS dataset supplimented with summary statistics
#' 
#' @export
#' @importFrom dplyr summarise group_by n
#' @importFrom magrittr "%>%"
#'
#' @examples
#' 
#' vascr_summarise(growth.df, "summary")
#' vascr_summarise(growth.df, "experiments")
#' vascr_summarise(growth.df, "wells")
#' 
#' data = vascr_summarise(growth.df, "summary")
#' 
#' 
#' 
vascr_summarise <- function(data.df, level = "summary") {
  
  # Use a test to check what the current summary level of the data is
  summary_level = vascr_test_summary_level(data.df)
  
  if(level == "" || level == "deviation")
  {
    return(data.df)
  }
  
  if(level == summary_level)   # Return the same data if summary level is already in place
  {
    return (data.df)
  }
  
  # If possible, make experimental resolution
  
  if(summary_level == "wells")
  {
    experiment.df = data.df %>%
      group_by(Time, Unit, Frequency, Sample, Experiment, Instrument) %>%
      summarise(sd = sd(Value), n = n(),min = min(Value), max = max(Value), Well = paste0(unique(Well), collapse = ","),Value = mean(Value))
    
    othervars.df = select(data.df, -Value, -Well) %>% distinct()
    
    experiment.df = experiment.df %>% ungroup() %>% left_join(othervars.df, by = c("Time", "Unit", "Frequency", "Sample", "Experiment", "Instrument"))
  }else if(summary_level == "experiments")
  {
    experiment.df = data.df
  }
  
  # If possible, make summary resolution
  
  if (summary_level == "experiments" || summary_level == "wells")
  {
    summary.df = experiment.df %>%
      group_by(Time, Unit, Frequency, Sample, Instrument) %>%
      summarise(sd = sd(Value), totaln = sum(n), n = n(), min = min(Value), max = max(Value), Well = paste0(unique(Well), collapse = ","), Value = mean(Value), Experiment = "Summary")
    
    othervars.df = select(experiment.df, -'Value', -'Well', -'Experiment', -'n', -'sd', -'min', -'max') %>% distinct()
    
    summary.df = left_join(summary.df, othervars.df, by = c("Time", "Unit", "Frequency", "Sample", "Instrument"))
  }
  else
  {
    warning ("Can't determine summary level, check data frame integrity")
    return ("NA")
  }
  
  
  if(level == "summary" && exists ("summary.df"))
  {
    summary.df = ungroup(summary.df)
    return(summary.df)
  }else if(level == "experiments" && exists ("experiment.df"))
  {
    experiment.df = ungroup(experiment.df)
    return(experiment.df)
  }else
  {
    warning("Invalid level requested. Please check level is valid and you have presented a data frame that has a higher resolution than the summary you have requested")
    return("NA")
  }
  
}





# Normalisation function --------------------------------------------------

#' Normalise ECIS data to a single time point
#' 
#' This function normalises each unique experiment/well combination to it's value at the specified time. Contains options to do this either by division or subtraction. Can be run twice on the same dataset if both operations are desired.
#'
#' @param data.df Standard ECIS Dataframe
#' @param normtime Time to normalise the data to
#' @param divide  If set to true, data will be normalsed via a division. If set to false (default) data will be normalsed by subtraction. Default is subtraction
#'
#' @return A standard ECIS dataset with each value normalised to the selected point.
#' 
#' @importFrom dplyr left_join
#' 
#' @export
#'
#' @examples
#' 
#' data = vascr_normalise(growth.df, 100)
#' head(data)
#' 
vascr_normalise = function(data.df, normtime, divide = FALSE) {
    
    # Create a table that contains the full dataset at the time we are normalising to
    mininormaltable = vascr_subset(data.df, time = normtime)
    
    # Now use left_join to match this time point to every other time point.This creates a table with an additional column that everything needs to be    normalised to, allowing for the actual normalisation to be done via vector maths. Not the most memory efficent, but is explicit and clean.
    
    fulltable = left_join(data.df, mininormaltable, by = c('Well' = "Well", 'Frequency' = "Frequency", 
        Experiment = "Experiment", Unit = "Unit", Sample = "Sample", Instrument = "Instrument"))
    
    #Adjust naming so that the time variable is set to the time of each timepoint, not the time we are normalising to
    fulltable$Time = fulltable$Time.x
    
    
    # Run the actual maths for each row
    
    if (divide == TRUE) {
        fulltable$Value = fulltable$Value.x/fulltable$Value.y
    } else {
        fulltable$Value = fulltable$Value.x - fulltable$Value.y
    }
    
    # Clean up temporary rows
    fulltable$Time.y = NULL
    fulltable$Time.x = NULL
    fulltable$Value.x = NULL
    fulltable$Value.y = NULL
    
    
    # Warn if maths errors have occoured
    if (isFALSE(all(is.finite(fulltable$Value)))) {
        warning("NaN values or infinities generated in normalisation. Proceed with caution")
    }
    
    #Return the whole table
    return(fulltable)
    
}

# Align key ECIS datapoints -----------------------------------------------


#' Align key points in an ECIS trace
#'
#'This will either align the max or minimum points from each graph as specified
#'
#'Sets the time at which each replicate well is maximal to time 0. Results in variables aligned by maximum time, rather than time from seeding.
#'
#' @param data.df A standard ECIS data file
#' @param point Which key point, either 'max' or 'min'
#' @param discrepancy A standard rounding constant to compensate for rounding errors in the subtraciton process
#'
#' @return An ECIS dataset where the key time points all happen at time 0
#' 
#' @importFrom magrittr '%>%'
#' @importFrom stringr str_detect
#' @importFrom dplyr group_by arrange mutate
#' 
#' @export
#'
#' @examples
#' 
#' data = vascr_align_key(growth.df, 'max')
#' head(data)
#' data = vascr_align_key(growth.df, 'min')
#' head(data)

vascr_align_key = function(data.df, point, discrepancy = 5) {
    
    #These actions are implimented as big dplyr pipelines that group the datasets together, sort it by time     and then subtract the minimimum/maximum point in the dataset from each point. This leverages the            efficencies of dplyr making it faster than a raw implementation. 
  
    if (point == "max") {
        returndata.df = data.df %>% dplyr::group_by(Unit, Well, Sample, Frequency, Experiment) %>% 
            dplyr::arrange(Time) %>% dplyr::mutate(Time = Time - Time[which.max(Value)])
    
    } else if (point == "min") {
        returndata.df = data.df %>% dplyr::group_by(Unit, Well, Sample, Frequency, Experiment) %>% 
            dplyr::arrange(Time) %>% dplyr::mutate(Time = Time - Time[which.min(Value)])
   
    } else {
        warning("No supported key point string entered. Please try again")
        return(FALSE)
    }
    
    
    #This line is a bit of a hack job, as it fixes the fact that sometimes points come misaligned in the       subtraciton process. Will be better implimented in the future by resampling.
  
    returndata.df$Time = round(returndata.df$Time, discrepancy)
    
    return(returndata.df)
}



# subsample data ---------------------------------------------------------


#' Subsample data
#' 
#' Returns a subset of the original data set that has only every nth value. Greatly increases computational preformance for a minimal loss in resolution during time course experiments.
#'
#' @param data.df An ECIS dataset
#' @param nth  An integer. Every nth value will be preserved in the subsetting
#'
#' @return Downsampled ECIS data set
#' 
#' @importFrom dplyr left_join
#' 
#' @export
#'
#' @examples
#' 
#' data = vascr_subsample(growth.df, 50)
#' head(data)
#' 
vascr_subsample = function(data.df, nth) {
    
    Time = unique(data.df$Time)
    TimeID = c(1:length(Time))
    time.df = data.frame(TimeID, Time)
    
    withid.df = dplyr::left_join(data.df, time.df, by = "Time")
    subset.df = subset(withid.df, (TimeID%%nth) == 1)
    
    data.df = subset.df
    subset.df$TimeID = NULL
    
    return(data.df)
    
}


#' Current aquisition rate
#'
#' @param data.df The dataframe to compute the current data aquisition frequency of
#'
#' @return The current aquisition rate of the data frame
#' @export
#'
#' @examples
#' 
#' vascr_current_frequency(growth.df)
#' 
#' 
vascr_current_frequency = function (data.df)
{
  times = unique (data.df$Time) # Make a list of unique datapoints 
  times = sort(times) # Sort them
  difftimes = diff(times) # Calculate differences
  
  if (!(mean(difftimes) == getmode(difftimes)))
  {
    warning("Gaps in the dataset, use resampling with care")
  }
  return(getmode(difftimes))
}


#' Resample ECIS data onto a constant time base
#' 
#' This will currently over-sample data, use with care
#'
#' @param data.df A standard ECIS data frame
#' @param by  The frequency at which to resample
#' @param from The value at which to start resampling
#' @param to  The max value to resample
#' @param zero_time The value that will be set as 0 after the normalisation is done. Usefull for aligning treatment times of multiple experiments.
#' 
#' @importFrom stringr str_remove
#' @importFrom tidyr unite spread gather separate
#' @importFrom stats approxfun
#' @importFrom magrittr "%>%"
#'
#' @return An ECIS dataset with re-located time points
#' 
#' @export
#'
#' @examples
#' 
#' data = vascr_resample(growth.df, 10, 50 ,100, 50)
#' head (data)
#' 
vascr_resample = function (data.df, by, from = Inf, to = Inf, zero_time = 0)
{
  
  if(from == Inf)
  {
    from = min(data.df$Time)
  }
  if(to == Inf)
  {
    to = max(data.df$Time)
  }
  
  if(from<min(data.df$Time))
  {
    warning(paste("From is below than the minimum time in the dataset. Please select a number above", min(data.df$Time)))
  }
  
  if(to>max(data.df$Time))
  {
    warning(paste("To is greater than the maximum of the dataset. Please select a number below", max(data.df$Time)))
  }
  
  movedata = vascr_remove_metadata(data.df)
  movedata = vascr_subset(movedata, time = c(from,to))
  
  movedata$Time = movedata$Time - zero_time
  
  combinedcolnames = colnames(movedata)
  cleancolnames = str_remove(combinedcolnames, "Time")
  cleancolnames = str_remove(cleancolnames, "Value")
  cleancolnames = cleancolnames[cleancolnames!= ""]
  
  movedata = unite(movedata, col = "Stream", -Value, -Time, sep = "#")
  movedata = unique(movedata)
  movedata2 = spread(movedata, Stream, Value)
  
  # Generate new times
  newtimepoints= seq(from=from,to=to,by=by)
  oldtimepoints = movedata2$Time
  
  # Construct an empty data frame to take the new data
  movedata3 <- movedata2[0,]
  movedata3[nrow(movedata3)+length(newtimepoints),] <- NA
  movedata3$Time = newtimepoints
  
  currentcol = 2
  totalcols = length(colnames(movedata2))
  
  while(currentcol<(totalcols+1))
  {
    replot = approxfun(oldtimepoints, movedata2[,currentcol])
    movedata3[,currentcol] = replot(newtimepoints)
    currentcol = currentcol + 1
  }
  
  movedata4 = gather(movedata3, Stream, Value, -Time)
  movedata5 = movedata4 %>% separate(Stream, cleancolnames, sep = "#")
  
  if (length(unique(movedata5$Time))>length(unique(data.df$Time)))
  {
    warning("You have oversampled your data, meaning that you now have more datapoints than you originally collected. This may be misleading, use with care.")
  }
  
  movedata6 = vascr_remove_metadata(movedata5)
  movedata6 = vascr_explode(movedata6)
  
  return(movedata6)
  
}


#' Subset an ECIS dataset on multiple factors
#' 
#' Generates a cut down dataset for processing purposes. Used heavily by all other internal functions, but may also be useful for inspecting digestable chunks of raw data.
#'
#' @param data.df A standard ECIS dataset
#' @param time The time to subset at. Default will line plot all data, can also submit a vector of length 2
#'  and the times between those two points will be submited.
#' @param unit The unit requred
#' @param frequency The frequency at which the reading was taken. All modeled variables have a frequency of 0
#' @param experiment The experiment to plot. Default is all experiments
#' @param samplecontains The samples to plot. A string that is searched accross all sample names, and those that match are plotted.
#' @param well The wells required
#'
#' @return A smaller ECIS dataset
#' 
#' @importFrom dplyr filter
#' @importFrom magrittr "%>%"
#' @importFrom stringr str_detect
#' @export 
#'
#' @examples
#' data = vascr_subset(growth.df, time = c(20.23,50.73), frequency = 4000, unit = "R", 
#' samplecontains = "05,000", experiment = "2", well = "G5")
#' head(data)
#' data = vascr_subset(growth.df, time = c(20.23,50.73), frequency = 4000, unit = "R", 
#' samplecontains = "05,000", experiment = "2")
#' head(data)
#' 
#' data = vascr_subset(growth.df, time = list(50,100))
#' unique(data$Time)
#' 
#' data = vascr_subset(growth.df, time = c(50,70))
#' unique(data$Time)
#' 
#' data = vascr_subset(growth.df, samplecontains = "5000")
#' data.df = growth.df
#' 
#' unique(vascr_subset(growth.df, max_deviation = 0.3)$Well)

vascr_subset = function(data.df, time = Inf, unit = "", frequency = Inf, samplecontains = "", experiment = "", well = "", deviation = 0, max_deviation = 0){
  
  if(!(is.data.frame(data.df)))
  {
    stop("Data is not a data frame. This function can only be used on vascr data frames")
  }
  
  defaultfrequency = frequency
  defaultunit = unit
  
  data.df$Well = vascr_standardise_wells(data.df$Well)
  
  
  if(vascr_is_modeled_unit(unit)) # Wipe out frequency if it is a modelled variable as that makes no sense
  {
    frequency = 0
    defaultfrequency = 0
  }
  
  
  
  # Deal with time
  
  if(is.list(time))
  {
    subsetdata = data.df[0, ]
    for(tim in time)
    {
      localdata = vascr_subset(data.df, time = tim)
      subsetdata = rbind(subsetdata, localdata)
    }
    data.df = subsetdata
  }
  
  else if (length(time) == 2) # If a vector of length 2 was submitted (ie two times) then we subset to that
  {
    data.df = data.df %>% filter(Time >= time[1])
    data.df = data.df %>% filter(Time <= time[2])
  }
  
  else if(is.finite(time)) # Check that time finite. If so, trim down the dataset to the single finite time point given.
  {
    time = as.numeric(time) # Clean up the data type just in case the user is lazy
    actualtime = vascr_find_time(data.df, time)
    data.df = data.df %>% filter(Time == actualtime)
  }
  else if(is.infinite(time)) # The number is infinity, so return everything (IE do nothing)
  {
    
  } else
  {
    warning("Time argument could not be parsed. No time subsetting completed")
  }
  
  #Then we deal with the frequency
  
  if(frequency == "raw")
  {
    data.df = data.df %>% filter(Frequency > 0 )
    
  } else if (frequency == "modeled")
  {
    data.df = data.df %>% filter(Frequency == 0)
  }
  
  else if(is.finite(frequency)) # Check that time finite. If so, trim down the dataset to the single finite frequency given, or the nearest rounded one.
  {
    frequency = as.numeric(frequency) # clean up the data type
    frequency = vascr_find_frequency(data.df, frequency)
    data.df = data.df %>% filter(Frequency == frequency)
  }
  
  #Then we deal with the textey ones
  
  data.df = data.df %>% filter(str_detect(Unit, unit))
  data.df = data.df %>% filter(str_detect(Sample, samplecontains))
  data.df = data.df %>% filter(str_detect(Experiment, experiment))
  
  if (!all((well == "")))
  {
  data.df = data.df %>% filter(Well == well)
  }
  
  
  if(deviation>0 || max_deviation>0)
  {
    if(length(frequency>0) || length(unit)>0)
    {
      warning("Mulitple units selected, deviation calculations will be inaccurate due to comparing non-like units")
    }
    
    data.df = vascr_exclude_deviation(data = data.df, deviation = deviation, frequency = frequency, unit = unit)
    
  }
  
  
  # Check if there is still some data here, and if not sound a warning
  if(nrow(data.df)==0)
  {
    warning("No data returned from dataset subset. Check your frequencies, times and units are present in the dataset")
  }
  
  return(data.df)
  
  
}



#' Subset a continuous variable
#'
#' Subset the columns that are exploded out of a continuous variable. Contains options to remove descriptors that are now defunct, so this will be repaired later.
#'
#' @param data A vascr dataset to subset
#' @param continuous The continuous variable to subset
#' @param exact_match Should the variables selected have an exact match to the column names input, or only contain the value input. Default is containing as otherwise you have to keep track of units.
#' @param strip_empty Should columns in which none of the selected variables are present be removed
#' @param implode Should the final data set be imploded, replacing the sample wells present
#'
#' @importFrom dplyr mutate_all
#' @importFrom stringr str_detect
#'
#' @return
#' @export
#'
#' @examples
# # Sub code for breaking out continuous datasets
# #exploded = vascr_explode(xcell)
# #subset = vascr_subset_continuous(exploded, continuous = "ATP", strip_empty = FALSE)
# #vascr_plot(exploded, unit = "CI", frequency = "10000", replication = "experiments", normtime = 160, continuouscontains = "ATP")
#'
#'
vascr_subset_continuous = function(data, continuous, exact_match = FALSE, strip_empty = TRUE, implode = TRUE)
{

  # We can only subset continuous data that is exploded, so fix this if it's not already done
  if(isFALSE(vascr_test_exploded(data)))
     {
       data = vascr_explode(data)
     }

  cols = colnames(data)

  # Add the standard ECIS cols
  colstokeep = c()

  # If exact match is specified
  if(exact_match)
  {
    colstokeep = continuous
  }

  else  # Otherwise find other matches
  {

  for(grab in continuous)
  {
    colstokeep = c(colstokeep, (cols[str_detect(cols, grab)]))
  }
  }

# Grab all the cols we want
  eciscols = data[,vascr_cols()]
  selectedcols = data[,colstokeep]


  # Clean whitespace off each column
  selectedcols = selectedcols %>% mutate_all(trimws)

  return = cbind(eciscols,selectedcols)


  # If removing remainging columns, check if all of the remaining columns are NA
  if(strip_empty)
  {
  return$allNA = rowSums(!(return[,colstokeep] == c("NA")))>0
  return = subset(return, allNA)
  return$allNA = NULL
  }

  # If requested, we implode to fix up the sample names
  if(implode)
  {
  return = vascr_implode(return)
  }

  return(return)
}


#' Explode the wells in a VASCR dataset
#'
#' @param data 
#'
#' @return
#' @export
#'
#' @examples
#' vascr_explode_wells(growth.df)
#' 
#' data = vascr_summarise(growth.df)
#' vascr_explode_wells(data)
#' vascr_explode_wells(data, separate_rows = TRUE)
#' 
vascr_explode_wells = function(data, separate_rows = FALSE)
{
   if(separate_rows & max(str_count(unique(data$Well), ","))>0)
   {
   data = separate_rows(growth.df, Well, sep = ",")
   }
  
  data$Well = vascr_standardise_wells(data$Well)
  data$row = vascr_factorise_and_sort(substr(data$Well, 1,1), sortkeyincreasing = FALSE)
  data$col = vascr_factorise_and_sort(as.numeric(substr(data$Well, 2,3)), sortkeyincreasing = TRUE)
  return(data)
}


#' Prepare a dataset to be graphed by vascar_graph_xxx
#' 
#' Central data subset, cleanup and label prep function
#'
#' @param data 
#' @param unit 
#' @param frequency 
#' @param time 
#' @param samplecontains 
#' @param experiment 
#' @param error 
#' @param alignkey 
#' @param normtime 
#' @param divide 
#' @param preprocessed 
#' @param continuouscontains 
#' @param stripidentical 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "summary")
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "experiments")
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "wells")
#' 
#' 
vascr_prep_graphdata = function(data, unit = "", frequency = Inf, time = Inf, samplecontains = "", experiment = "", error = Inf, alignkey = NULL, normtime = NULL, divide = FALSE, preprocessed = FALSE, continuouscontains = NULL , stripidentical = TRUE, sortkeyincreasing = TRUE, level = "", errortype = "sem")
{
  # First subset away what we don't need for normalising to a particular point (speeds up things a lot)
  data = vascr_subset(data, unit = unit, frequency = frequency, samplecontains = samplecontains, experiment = experiment)
  
  # Subsample the data if only some time points are required for error plotting
  if (error>1 && !is.infinite(Inf))
  {
    data = vascr_subsample(data, error)
  }
  
  # Then normalise or align key points, if required. Alignment then normalisation are preformed, as the final data, not the transposed data is usually what is requested. This behaviour can be changed by manually formulating the data ahead of time.
  if(!is.null(alignkey))
  {
    data = vascr_align_key(data, alignkey)
  }
  
  if(!is.null(normtime))
  {
    data = vascr_normalise(data, normtime, divide)
  }
  
  # Then subset down to the timepoints that are required
  data = vascr_subset(data, time = time)
  
  
  # If data is not preprocessed and data is not exploded already, explode the dataset
  if (isFALSE(preprocessed) & isFALSE(vascr_test_exploded(data)))
  {
    data = vascr_explode(data)
  }
  
  # If  data is being subset based on a continuous column, run that now
  if(!is.null(continuouscontains))
  {
    data = vascr_subset_continuous(data, continuouscontains)
  }
  
  if(stripidentical)
  {
    data$Sample = (vascr_implode(data, stripidentical = TRUE))$Sample
  } 
  
  data = vascr_summarise(data, level = level)
  
  if(isFALSE(preprocessed))
  {
    # Replace all the underscores in titles with spaces
    data$Sample = str_replace(data$Sample, "_", " ")
  }
  
  # Sort the order of titles as numbers
  if(!is.null(sortkeyincreasing))
  {
    data$Sample = vascr_factorise_and_sort(data$Sample, sortkeyincreasing)
  }
  
  # Remove any values that are unplottable, IE generation of SD or SEM failed, likely due to missing values from modeling failures
  data = drop_na(data, Value)
  
  
  if(level == "summary" || level =="experiments")
  {
    
    if(errortype == "sem")
    {
      data$sem = data$sd/sqrt(data$n)
      data$ymax = data$Value + data$sem
      data$ymin = data$Value - data$sem
    }
    else if (errortype == "sd")
    {
      data$ymax = data$Value + data$sd
      data$ymin = data$Value  - data$sd
    }
    else if(errortype == "range")
    {
      data$ymax = data$max
      data$ymin = data$min
    }
    else
    {
      warning("No error specified,  and hence won't be generated")
    }
    
    
    
    # Remove impossible error bars for the avoidance of errors. Replaces both max and min with the actual value.
    data = mutate(data, ymax = coalesce(ymax, Value))
    data = mutate(data, ymin = coalesce(ymin, Value))
    
  }
  
  return(data)
  
}

