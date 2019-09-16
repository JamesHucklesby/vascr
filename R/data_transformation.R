
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
#' ecis_normalise(data.df, 100)
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
#' ecis_align_key(data.df, 'max')
#' ecis_align_key(data.df, 'min')

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



# Downsample data ---------------------------------------------------------


#' Downsample data
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
#' ecis_subsample(data.df, 50)
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
#' ecis_currentfrequency(data.df)
#' 
#' 
ecis_currentfrequency = function (data.df)
{
  times = unique (data.df$Time)
  return((max(times)-min(times))/(length(times)-1))
}


#' Resample ECIS data onto a constant time base
#' 
#' This will currently over-sample data, use with care
#'
#' @param data A standard ECIS data frame
#' @param by  The frequency at which to resample
#' @param from The value at which to start resampling
#' @param to  The max value to resample
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
#' ecis_resample(data.df, 8, 50 ,100)
#' 
ecis_resample = function (data, by, from = -Inf, to = Inf)
{
  
  #First we chuck any data outside the time ranges as this is wasted modeling work
  #data = ecis_subset(data, time = c(from-0.000001,to+0.000001))
  
  #Now check that the ranges are sensible (don't do this)
  
  # New data set
  
  movedata = data
  movedata$TimeID = NULL
  
  combinedcolnames = colnames(movedata)
  cleancolnames = str_remove(combinedcolnames, "Time")
  cleancolnames = str_remove(cleancolnames, "Value")
  cleancolnames = cleancolnames[cleancolnames!= ""]
  
  movedata = unite(movedata, col = "Stream", -Value, -Time)
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
  movedata5 = movedata4 %>% separate(Stream, cleancolnames, sep = "_")
  
  return(movedata5)
  
}
