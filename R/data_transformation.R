# Summary function --------------------------------------------------------

#' Title
#'
#' @param set 
#'
#' @return
#' @keywords internal- /py
#'
#' @examples
vascr_levels = function(set = "all")
{
  vector = c("summary", "wells", "experiments")
  
  if(set == "all")
  {
    vector = c(vector, "explode")
  }
  
  return(vector)
}


# level = c("well", "explode")
# 
# vascr_summarise(growth.df, "summary")

#' Title
#'
#' @param data.df 
#' @param level 
#'
#' @return
#' @export
#'
#' @examples
#' vascr_summarise(growth.df, level = "summary")
#' 
vascr_summarise = function(data.df, level = "wells")
{
  levels = vascr_match(level, vascr_levels(set = "all"))
  
  if(!vascr_test_timebase(data.df))
  {
    data.df = vascr_interpolate_time(data.df)
  }
  
  for(lev in level)
  {
    
    if(lev == "summary")
    {
      data.df = vascr_summarise_summary(data.df)
    }
    
    if(lev == "experiments")
    {
      data.df = vascr_summarise_experiments(data.df)
    }
    
  }
  
  return(data.df)
  
}



#' Title
#'
#' @param data.df 
#'
#' @return
#' 
#' @importFrom dplyr n
#' 
#' @keywords internal
#'
#' @examples
# vascr_summarise_experiments(data.df = growth.df)
vascr_summarise_experiments = function(data.df)
{
  
  summary_level = vascr_detect_level(data.df)
 
  if(summary_level == "wells")
  {
    experiment.df = data.df %>%
      group_by(Time, Unit, Frequency, Sample, Experiment, Instrument) %>%
      summarise(sd = sd(Value), n = n(),min = min(Value), max = max(Value), Well = paste0(unique(Well), collapse = ","),Value = mean(Value), sem = sd/sqrt(n), .groups = "drop")

    
    experiment.df = experiment.df %>% ungroup()
    
  }else if(summary_level == "experiments")
  {
    experiment.df = data.df
  } else
  {
    stop("Requested data is less summarised than the data input, try again")
  }
  
  return(experiment.df)
}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#' 
#' @keywords internal
#'
#' @examples
vascr_summarise_summary = function(data.df)
{
  
  summary_level = vascr_detect_level(data.df)
  
  if(summary_level == "wells")
  {
    data.df = vascr_summarise_experiments(data.df)
    summary_level = vascr_detect_level(data.df)
  }
  
  if(summary_level == "experiments")
  {
  summary.df = data.df %>%
          group_by(Time, Unit, Frequency, Sample, Instrument) %>%
          summarise(sd = sd(Value), totaln = sum(n), n = n(), min = min(Value), max = max(Value), Well = paste0(unique(Well), collapse = ","), Value = mean(Value), Experiment = "Summary", sem = sd/sqrt(n),  .groups = "drop")
  return(summary.df)
  }
  
  else if(summary_level == "summary")
  {
    return(data.df)
  }
  
  stop("Invalid or impossible level detected")
  
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
#' @export
#' 
#' @importFrom dplyr left_join
#'
#' @examples
#' 
#' #data = vascr_normalise(growth.df, 100)
#' #head(data)
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
#' @keywords internal
#'
#' @examples
#' 
#' #data = vascr_align_key(growth.df, 'max')
#' #head(data)
#' #data = vascr_align_key(growth.df, 'min')
#' #head(data)

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
#' @keywords internal
#'
#' @examples
#' 
#' #unique(vascr_subsample(growth.df, 10)$Time)
#' #head(data)
#' 
vascr_subsample = function(data.df, nth) {
  
  Time = unique(data.df$Time)
  TimeID = c(1:length(Time))
  
   if(is.infinite(nth) || nth == 1 || length(Time)==1)
   {
     return(data.df)
   }
  
    
    time.df = data.frame(TimeID, Time)
    
    withid.df = dplyr::left_join(data.df, time.df, by = "Time")
    subset.df = subset(withid.df, (TimeID%%nth) == 1)
    
    subset.df$TimeID = NULL
    
    return(subset.df)
    
}


#' Current aquisition rate
#'
#' @param data.df The dataframe to compute the current data aquisition frequency of
#'
#' @return The current aquisition rate of the data frame
#' 
#' @keywords internal
#'
#' @examples
#' 
#' #vascr_current_frequency(growth.df)
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


#' Title
#'
#' @param data.df 
#' @param npoints 
#'
#' @return
#' @export
#'
#' @examples
vascr_interpolate_time = function(data.df, npoints = 50)
{
  
  xout = seq(from = min(floor(data.df$Time)), to = max(ceiling(data.df$Time)), length.out = npoints)
  
  processed = data.df %>% group_by(across(c(-Value, -Time))) %>%
    summarise(New_Value = approx(Time, Value, xout = xout, rule = 2)$y, New_Time = approx(Time, Value, xout = xout, rule = 2)$x) %>%
    rename(Value = New_Value, Time = New_Time) %>%
    ungroup()
  
  return(processed)
}


#' #' Resample ECIS data onto a constant time base
#' #' 
#' #' This will currently over-sample data, use with care
#' #'
#' #' @param data.df A standard ECIS data frame
#' #' @param by  The frequency at which to resample
#' #' @param from The value at which to start resampling
#' #' @param to  The max value to resample
#' #' @param zero_time The value that will be set as 0 after the normalisation is done. Usefull for aligning treatment times of multiple experiments.
#' #' 
#' #' @importFrom stringr str_remove
#' #' @importFrom tidyr unite spread gather separate
#' #' @importFrom stats approxfun
#' #' @importFrom magrittr "%>%"
#' #'
#' #' @return An ECIS dataset with re-located time points
#' #' 
#' #' @export
#' #'
#' #' @examples
#' #' 
#' #' #data = vascr_resample(data.df = growth.df, by = 10)
#' #' #head (data)
#' #' 
#' vascr_resample = function (data.df, by, from = -Inf, to = Inf, zero_time = 0)
#' {
#'   
#'   if(from == -Inf)
#'   {
#'     from = min(data.df$Time)
#'   }
#'   if(to == Inf)
#'   {
#'     to = max(data.df$Time)
#'   }
#'   
#'   if(from<min(data.df$Time))
#'   {
#'     warning(paste("From is below than the minimum time in the dataset. Please select a number above", min(data.df$Time)))
#'   }
#'   
#'   if(to>max(data.df$Time))
#'   {
#'     warning(paste("To is greater than the maximum of the dataset. Please select a number below", max(data.df$Time)))
#'   }
#'   
#'   movedata = vascr_remove_metadata(data.df)
#'   movedata = vascr_subset(movedata, time = c(from,to))
#'   
#'   movedata$Time = movedata$Time - zero_time
#'   
#'   combinedcolnames = colnames(movedata)
#'   cleancolnames = str_remove(combinedcolnames, "Time")
#'   cleancolnames = str_remove(cleancolnames, "Value")
#'   cleancolnames = cleancolnames[cleancolnames!= ""]
#'   
#'   movedata = unite(movedata, col = "Stream", -Value, -Time, sep = "#")
#'   movedata = unique(movedata)
#'   movedata2 = spread(movedata, Stream, Value)
#'   
#'   # Generate new times
#'   newtimepoints= seq(from=from,to=to,by=by)
#'   oldtimepoints = movedata2$Time
#'   
#'   # Construct an empty data frame to take the new data
#'   movedata3 <- movedata2[0,]
#'   movedata3 = as.data.frame(movedata3)
#'   movedata3[nrow(movedata3)+length(newtimepoints),] <- NA
#'   movedata3$Time = newtimepoints
#'   
#'   currentcol = 2
#'   totalcols = length(colnames(movedata2))
#'   
#'   movedata2 = as.data.frame(movedata2)
#'   
#'   while(currentcol<(totalcols+1))
#'   {
#'     oldtp = as.vector(oldtimepoints)
#'     oldval = as.vector(movedata2[,currentcol])
#'     replot = approxfun(oldtp, oldval)
#'     movedata3[,currentcol] = replot(newtimepoints)
#'     currentcol = currentcol + 1
#'   }
#'   
#'   movedata4 = gather(movedata3, Stream, Value, -Time)
#'   movedata5 = movedata4 %>% separate(Stream, cleancolnames, sep = "#")
#'   
#'   if (length(unique(movedata5$Time))>length(unique(data.df$Time)))
#'   {
#'     warning("You have oversampled your data, meaning that you now have more datapoints than you originally collected. This may be misleading, use with care.")
#'   }
#'   
#'   movedata6 = vascr_remove_metadata(movedata5)
#'   movedata6 = vascr_explode(movedata6)
#'   
#'   return(movedata6)
#'   
#' }



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
#' @return A vascr dataset subsampled on a continuous variable
#' 
#' @keywords internal
#'
#' @examples
#' # Sub code for breaking out continuous datasets
#' #exploded = vascr_explode(xcell)
#' #subset = vascr_subset_continuous(exploded, continuous = "ATP", strip_empty = FALSE)
#' #vascr_plot(exploded, unit = "CI", frequency = "10000", replication = "experiments"
#' # , normtime = 160, continuouscontains = "ATP")
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
#' Tools for exploding wells out into row and column variables, and separating comma separated well values if needed.
#'
#' @param data.df The dataset to explode
#' @param separate_rows Split cells onto multiple rows if wells such as "A1,A2" may be present in the dataset
#'
#' @return A vascr dataset with rows and columns exploded
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_explode_wells(growth.df)
#' #vascr_explode_wells(growth.df, separate_rows = TRUE)
#' 
vascr_explode_wells = function(data.df, separate_rows = FALSE)
{
   data = data.df
  
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
#' Central data subset, cleanup and label prep function for generation of graphics
#'
#' @param data.df Vascr dataset to plot
#' @param unit Unit to subset to
#' @param frequency Frequency to subset to
#' @param time Time to subset to
#' @param samplecontains Subset only sample names that contain this string
#' @param experiment Experiment to subset to
#' @param error How much error to plot. Required to allow subsampling if required
#' @param alignkey Should key points be aligned
#' @param normtime Time to normalise to
#' @param divide Should normalisation be by division (true) or subtraction (false)
#' @param preprocessed Is the data already processed and therefore should be left alone
#' @param continuouscontains Subset variables where the sample contains this string
#' @param stripidentical Should entireley identical columns be removed
#' @param sortkeyincreasing Should samples be sorted in an increasing way
#' @param level The level of summary to return
#' @param errortype SEM or SD errors to generate
#' @param subsample Number of points to subsample
#' 
#' @importFrom dplyr coalesce mutate
#' @importFrom tidyr drop_na
#' @importFrom stats sd
#'
#' @return A vascr dataset prepared for use in graphing
#' 
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_plot(growth.df, unit = "Rb", level = "experiments", frequency = 0)
#' 
#' # datum2 = vascr_prep_graphdata(growth.df, unit = "Rb", level = "summary", frequency = 0)
#' 
#' 
#' #data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "experiments")
#' #data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "wells")
#' 
#' 
vascr_prep_graphdata = function(data.df, unit = "", frequency = Inf, time = NULL, samplecontains = NULL, experiment = NULL, error = Inf, alignkey = NULL, normtime = NULL, divide = FALSE, preprocessed = FALSE, continuouscontains = NULL , stripidentical = TRUE, sortkeyincreasing = TRUE, level = "summary", errortype = "sem", subsample = NULL)
{
  
  if(preprocessed)
  {
    return(data.df)
  }
  
  # First subset away what we don't need for normalising to a particular point (speeds up things a lot)
    #If requested
  data2.df = vascr_subset(data.df, unit = unit, frequency = frequency, experiment = experiment)
    #And if error is low
  data2.df = vascr_subsample(data2.df, max(subsample, error,1))
  
  
  # Then normalise or align key points, if required. Alignment then normalisation are preformed, as the final data, not the transposed data is usually what is requested. This behaviour can be changed by manually formulating the data ahead of time.
  if(!is.null(alignkey))
  {
    data2.df = vascr_align_key(data2.df, alignkey)
  }
  # 
  if(!is.null(normtime))
  {
    data2.df = vascr_normalise(data2.df, normtime, divide)
  }

  # Then subset down to the timepoints that are required
  data2.df = vascr_subset(data2.df, time = time)


  if(stripidentical)
  {
    data2.df$Sample = (vascr_implode(data2.df, stripidentical = TRUE))$Sample
  }
  
  data2.df = vascr_summarise(data2.df, level = level)

   # Replace all the underscores in titles with spaces
    data2.df$Sample = str_replace(data2.df$Sample, "_", " ")


    # Sort the order of titles as numbers
    if(!is.null(sortkeyincreasing))
    {
      data2.df$Sample = vascr_factorise_and_sort(data2.df$Sample, sortkeyincreasing)
      data2.df$Frequency = vascr_factorise_and_sort(data2.df$Frequency, sortkeyincreasing)
    }

  # Remove any values that are unplottable, IE generation of SD or SEM failed, likely due to missing values from modeling failures
  data2.df = drop_na(data2.df, Value)

  data2.df = vascr_summarise_errortype(data2.df, errortype)

  
  return(data2.df)
  
}




#' Create a summary with correct errors
#'
#' @param data.df The dataset to analyse
#' @param errortype The type of error to generate for graphing
#'
#' @return An annotated up dataset, with ymax and ymin in place
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_summarise_errortype(growth.df, "sem")
#' 
vascr_summarise_errortype = function(data.df, errortype)
{
  
  level = vascr_detect_level(data.df)
  
  if(level == "summary" || level =="experiments")
  {
    
    if(errortype == "sem")
    {
      data.df$sem = data.df$sd/sqrt(data.df$n)
      data.df$ymax = data.df$Value + data.df$sem
      data.df$ymin = data.df$Value - data.df$sem
    }
    else if (errortype == "sd")
    {
      data.df$ymax = data.df$Value + data.df$sd
      data.df$ymin = data.df$Value  - data.df$sd
    }
    else if(errortype == "range")
    {
      data.df$ymax = data.df$max
      data.df$ymin = data.df$min
    }
    else
    {
      warning("No error specified,  and hence error cols won't be generated")
    }
    
    # Remove impossible error bars for the avoidance of errors. Replaces both max and min with the actual value.
    data.df = mutate(data.df, ymax = coalesce(ymax, Value))
    data.df = mutate(data.df, ymin = coalesce(ymin, Value))
    
  }
  else
  {
    data.df$ymax = 0
    data.df$ymin = 0
  }
  
  
  return(data.df)
}

