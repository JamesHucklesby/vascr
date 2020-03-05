
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
#' data = ecis_normalise(growth.df, 100)
#' head(data)
#' 
ecis_normalise = function(data.df, normtime, divide = FALSE) {
    
    # Create a table that contains the full dataset at the time we are normalising to
    mininormaltable = ecis_subset(data.df, time = normtime)
    
    # Now use left_join to match this time point to every other time point.This creates a table with an additional column that everything needs to be    normalised to, allowing for the actual normalisation to be done via vector maths. Not the most memory efficent, but is explicit and clean.
    
    fulltable = left_join(data.df, mininormaltable, by = c('Well' = "Well", 'Frequency' = "Frequency", 
        Experiment = "Experiment", Unit = "Unit", Sample = "Sample"))
    
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
#' data = ecis_align_key(growth.df, 'max')
#' head(data)
#' data = ecis_align_key(growth.df, 'min')
#' head(data)

ecis_align_key = function(data.df, point, discrepancy = 5) {
    
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
#' data = ecis_subsample(growth.df, 50)
#' head(data)
#' 
ecis_subsample = function(data.df, nth) {
    
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
#' ecis_current_frequency(growth.df)
#' 
#' 
ecis_current_frequency = function (data.df)
{
  times = unique (data.df$Time) # Make a list of unique datapoints 
  return((max(times)-min(times))/(length(times)-1)) # Then divide the total time by the number of times to give the frequency
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
#' data = ecis_resample(growth.df, 10, 50 ,100, 50)
#' head (data)
#' 
ecis_resample = function (data.df, by, from = Inf, to = Inf, zero_time = 0)
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
  
  movedata = ecis_remove_metadata(data.df)
  movedata = ecis_subset(movedata, time = c(from,to))
  
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
  
  movedata6 = ecis_remove_metadata(movedata5)
  movedata6 = ecis_explode(movedata6)
  
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
#' data = ecis_subset(growth.df, time = c(20.23,50.73), frequency = 4000, unit = "R", 
#' samplecontains = "05,000", experiment = "2", well = "G5")
#' head(data)
#' data = ecis_subset(growth.df, time = c(20.23,50.73), frequency = 4000, unit = "R", 
#' samplecontains = "05,000", experiment = "2")
#' head(data)
#' 

ecis_subset = function(data.df, time = Inf, unit = "", frequency = Inf, samplecontains = "", experiment = "", well = ""){
  
  if (all(well != ""))
      {
        well = ecis_standardise_wells(well)
      }
  
  
  data.df$Well = ecis_standardise_wells(data.df$Well)
  
  
  if(unit == "Rb" || unit == "Cm" || unit == "Alpha" || unit == "RMSE" || unit == "Drift") # Wipe out frequency if it is a modelled variable as that makes no sense
  {
    frequency = 0
  }
  
  if (length(time) == 2) # If a vector of length 2 was submitted (ie two times) then we subset to that
  {
    data.df = data.df %>% filter(Time > time[1])
    data.df = data.df %>% filter(Time < time[2])
  }
  
  else if(is.finite(time)) # Check that time finite. If so, trim down the dataset to the single finite time point given.
  {
    time = as.numeric(time) # Clean up the data type just in case the user is lazy
    actualtime = ecis_find_time(data.df, time)
    data.df = data.df %>% filter(Time == actualtime)
  }
  else # The number is infinity, so return everything
  {
    
  }
  
  #Then we deal with the frequency
  
  if(frequency == "raw")
  {
    data.df = data.df %>% filter(Frequency > 0 )
    
  } else if (frequency == "modeled")
  {
    data.df = data.df %>% filter(Frequency == 0)
  }
  
  else if(is.finite(frequency)) # Check that time finite. If so, trim down the dataset to the single finite time point given.
  {
    frequency = as.numeric(frequency) # clean up the data type
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
  
  return(data.df)
  
  
}


#' Automatically strip badly connected wells from an ECIS dataset
#'
#' @param data.df A standard ECIS data frame
#' @param threshold How stringent to be in excluding wells. Higher is less stringent. Default is 5.
#' @param frequency Frequency to run numbers on, default is 4000
#' @param unit Unit to use in detection, default is R
#'
#' @return  A tibble containing the offending wells, which experiment they are from and the score they were removed with
#' @export
#' 
#' @importFrom dplyr group_by mutate summarise arrange distinct left_join
#' @importFrom magrittr "%>%"
#'
#' @examples
#' # Make a defective well in the dataset
#' baddata = growth.df
#' welltobreak = "B1"
#' baddata$randoms = sample(baddata$Value*2, size = nrow(baddata), replace = TRUE)
#' baddata$Value = baddata$Value + ((baddata$Well == welltobreak)*baddata$randoms)
#' 
#' welltobreak = "H4"
#' baddata$randoms = sample(baddata$Value*2, size = nrow(baddata), replace = TRUE)
#' baddata$Value = baddata$Value + ((baddata$Well == welltobreak)*baddata$randoms)
#' 
#' # Plot out the well, and then try to detect it
#' ecis_detect_badwells(baddata,1)
#' 
#' # Check it works for a good dataset
#' ecis_detect_badwells(growth.df,1)
#' 
ecis_detect_badwells = function(data.df, threshold = 5, frequency = 4000, unit = "R")
{
  
  cycles = 0
  runagain = TRUE
  
  cleandata.df = subset(data.df, !is.na(Value)) # Exclude wells where there is no data available (IE connection lost)
  
  cleandata.df = ecis_subset(cleandata.df, unit = unit, frequency = frequency) # Run the diagnosis on only one frequency to save time, at R4000
  
  
  #Calculate the fractional difference between the sample mean and the value of the well in each experiment at each timepoint
  while(runagain == TRUE)
  {
    
    metadata =  cleandata.df %>%
      group_by(Experiment, Sample, Time) %>%
      mutate(movementfrommean = abs(Value - mean(Value))/mean(Value)) %>%
      group_by(Well, Experiment) %>%
      summarise(Score = max(movementfrommean)) %>%
      arrange(desc(Score)) %>%
      left_join(cleandata.df, by = c("Well", "Experiment"))
    
    togo = metadata %>%
      distinct(Well, Score, Experiment) %>%
      subset(Score>threshold)
    
    cleandata.df = ecis_exclude(cleandata.df, wells = togo$Well[1]) # Remove the most offending well. Do this itterativley so the scores have less of an effect on each other (important if a spikey well hits one that is continuously highly raised)
    
    if(nrow(togo)==0 & cycles == 0)
    {
      runagain = FALSE
      strippedwells = togo
    }
    
    else if(nrow(togo)==0)
    {
      runagain = FALSE
    }
    else if (cycles == 0)
    {
      strippedwells = togo[1,]
      cycles = cycles + 1
    }
    else
    {
      strippedwells = rbind(strippedwells, togo[1,])
      cycles = cycles+1
    }
    
    
  }
  
  
  return(strippedwells)
  
}




#' Exclude automatically detected wells that have a connection issue from the dataset
#'
#' @param data.df The dataset to parse
#' @param threshold The threshold stringency to use in detection. Default is 5, the range of 1-10 may be appropriate. Higher numbers are less stringent.
#' @param frequency The frequency to use for detection, default is 4000 Hz
#' @param unit  The unit to run the detection on, default is R
#' @param verbose Prints which wells have been removed in the terminal. Should be used when first investigating data to allow for follow up plots with ecis_isolate_well to be conducted.
#'
#' @return A standard ECIS dataframe, minus the detected wells
#' 
#' @importFrom dplyr filter select
#' 
#' @export
#'
#' @examples
#' # Make a defective well in the dataset
#' baddata = growth.df
#' welltobreak = "B1"
#' baddata$randoms = sample(baddata$Value*2, size = nrow(baddata), replace = TRUE)
#' baddata$Value = baddata$Value + ((baddata$Well == welltobreak)*baddata$randoms)
#' 
#' welltobreak = "H4"
#' baddata$randoms = sample(baddata$Value*2, size = nrow(baddata), replace = TRUE)
#' baddata$Value = baddata$Value + ((baddata$Well == welltobreak)*baddata$randoms)
#' 
#' ecis_exclude_badwells(baddata, threshold = 1)
#' ecis_exclude_badwells(growth.df, threshold = 1)
#' 
ecis_exclude_badwells = function(data.df, threshold = 5, frequency = 4000, unit = "R", verbose = TRUE)
{

 # Detect if any bad wells are present
  
 toremove = ecis_detect_badwells(data.df, threshold = threshold, frequency = frequency, unit = unit)
 
 if(nrow(toremove) ==0) # If nothing is bad, just return the data frame
 {
   if (verbose)
   {
   print("No bad wells detected")
   }
   return(data.df)
 }
 
 
 toremove$expwells = paste(toremove$Experiment, ":", toremove$Well, sep="")
 data.df$expwells = paste(data.df$Experiment, ":", data.df$Well, sep="")
 
 expwellstogo = toremove$expwells
 
 if(verbose)
 {
 print("Wells Removed:")
 print(expwellstogo)
 }
 
 toreturn = dplyr::filter(data.df,!expwells %in% expwellstogo)
 toreturn = dplyr::select(toreturn, -c("expwells"))
 
 return(toreturn)
 
  
}



ecis_subset_continuous = function(data, continuous)
{
  
  cols = colnames(data)
  
  # Add the standard ECIS cols
  colstokeep = ecis_cols()
  
  # Match the columns that are detected
  for(grab in continuous)
  {
    colstokeep = c(colstokeep, (cols[str_detect(cols, grab)]))
  }
  
  exploded[,colstokeep]
  
}