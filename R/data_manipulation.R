
# Normalisation function --------------------------------------------------

#' Normalise ECIS data to a single time point
#' 
#' This function normalises each unique experiment/well combination to it's value at the specified time. Contains options to do this either by division or normalisation. Can be run twice if both operations are desired.
#'
#' @param data.df Standard ECIS Dataframe
#' @param normtime Time to normalise the data to
#' @param divide  If set to true, data will be normalsed via a division. If set to false (default) data will be normalsed by subtraction.
#'
#' @return A standard ECIS dataset with each value normalised
#' 
#' @importFrom dplyr left_join
#' 
#' @export
#'
#' @examples
#' 
#' ecis_normalise(data.df, 100)
#' 
ecis_normalise = function(data.df, normtime, divide = FALSE)
{
  
  roundedtime = ecis_roundtime(data.df, normtime)
  
  mininormaltable = subset(data.df, Time == roundedtime)
  
  fulltable = left_join(data.df, mininormaltable, by = c("Well" = "Well", "Frequency" = "Frequency", "Experiment" = "Experiment", "Unit" = "Unit", "Sample" = "Sample"))
  
  fulltable$Time = fulltable$Time.x
  
  
  if (divide == TRUE){
    fulltable$Value = fulltable$Value.x / fulltable$Value.y
  }
  else{
    fulltable$Value = fulltable$Value.x - fulltable$Value.y
  }
  
  fulltable$Time.y = NULL
  fulltable$Time.x = NULL
  fulltable$Value.x = NULL
  fulltable$Value.y = NULL
  
  
  if(isFALSE(all(is.finite(fulltable$Value)))){
    warning("NaN values or infinities generated in normalisation. Proceed with caution")
  }
  
  return(fulltable)
  
}

# Align key ECIS datapoints -----------------------------------------------


#' Align key points in an ECIS trace
#'
#'This will either align the max or minimum points from each graph. As specified.
#'
#'Sets the time at which each replicate well is maximal to time 0. Results in variables aligned by maximum time, rather than time from seeding.
#'
#' @param data.df A standard ECIS data file
#' @param point Which key point, either "max" or "min"
#' @param discrepancy A standard rounding constant to compensate for rounding errors in the subtraciton process
#'
#' @return An ECIS dataset where the key time points all happen at time 0
#' 
#' @importFrom magrittr "%>%"
#' @importFrom stringr str_detect
#' @importFrom dplyr group_by arrange mutate
#' 
#' @export
#'
#' @examples
#' 
#' ecis_align_key(data.df, "max")
#' ecis_align_key(data.df, "min")

ecis_align_key = function(data.df, point, discrepancy = 5){
  
  if (point == "max")
  {
    returndata.df = data.df %>%
      dplyr:: group_by(Unit, Well, Sample, Frequency, Experiment) %>%
      dplyr:: arrange(Time) %>%
      dplyr:: mutate (Time = Time- Time[which.max(Value)])
  }
  
  else if (point == "min")
  {
    returndata.df = data.df %>%
      dplyr:: group_by(Unit, Well, Sample, Frequency, Experiment) %>%
      dplyr:: arrange(Time) %>%
      dplyr:: mutate (Time = Time- Time[which.min(Value)])
  }
  
  else
  {
    warning("No supported key point string entered. Please try again")
    return (FALSE)
  }
  
  
  returndata.df$Time = round(returndata.df$Time,discrepancy)
  
  return (returndata.df)
}


# Generate summary data ---------------------------------------------------


#' Generate summary data from combining experiments
#'
#' @param ... A series of data frames to be combined
#'
#' @return A standard ECIS data frame with summary statistics for each row. One row per sample and time combination.
#' @export
#' 
#'
#' @examples
#' 
#' #Generate two pretend datasets
#' experiment1.df = data.df
#' experiment2.df = data.df
#' 
#' #ecis_combine_mean(experiment1.df, experiment2.df)
#' warning("This funciton is broken")
#' 
ecis_combine_mean = function (...)
{
  warning("This funciton is broken")
  
  dataframes = list(...)
  
  alldata = ecis_summarise(dataframes[[1]][0,])
  loops = 1
  
  for(i in dataframes){
    indata = ecis_summarise(i)
    indata$Experiment = loops
    loops = loops + 1
    alldata = rbind(alldata, indata)
  }
  
  return (alldata)
  
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
#' ecis_subset(data.df, 50)
#' 
ecis_subset = function(data.df, nth)
{
  
  Time = unique(data.df$Time)
  TimeID = c(1:length(Time))
  time.df = data.frame(TimeID, Time)
  
  withid.df = dplyr::left_join(data.df, time.df, by="Time")
  subset.df = subset(withid.df, (TimeID %% nth) == 1)
  
  data.df = subset.df
  subset.df$TimeID = NULL
  
  return(data.df)
  
}

# Summary function --------------------------------------------------------

#' Summarise ECIS datasets from a single experiment
#' 
#' Creates and ECIS dataset that has had all samples of the same type averaged together. Assumes that each sample is independent, IE that this function has already been run on individual experiments
#'
#' @param data.df An ECIS dataset in standard format
#'
#' @return An ECIS dataset supplimented with summary statistics
#' 
#' @export
#' @importFrom dplyr summarise
#'
#' @examples
#' 
#' ecis_summarise(data.df)
#' 
ecis_summarise <- function(data.df){
  
  average.df = summarise(group_by(data.df, Sample, Time, Unit, Frequency),                     
                         sd=sd(Value), n=n(), sem = sd/sqrt(n),Value=mean(Value))
  
  average.df$Experiment = "Derrivative";
  return (average.df)
  
}



