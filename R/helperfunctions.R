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
#' @param samplesubset 
#'
#' @return A smaller ECIS dataset
#' 
#' @importFrom dplyr filter
#' @importFrom magrittr "%>%"
#' @importFrom stringr str_detect
#' @export 
#'
#' @examples
#' ecis_subset(data.df, time = c(20.23,50.73), frequency = 4000, unit = "R", samplesubset = "05,000", experiment = "2")
#' 
ecis_subset = function(data.df, time = Inf, unit = "", frequency = Inf, samplesubset = "", experiment = ""){
  
  if (length(time) == 2) # If a vector of length 2 was submitted (ie two times) then we subset to that
  {
    data.df = data.df %>% filter(Time > time[1])
    data.df = data.df %>% filter(Time < time[2])
  }
  
  else if(is.finite(time)) # Check that time finite. If so, trim down the dataset to the single finite time point given.
  {
  time = as.numeric(time) # Clean up the data type just in case the user is lazy
  actualtime = ecis_roundtime(data.df, time)
  data.df = data.df %>% filter(Time == actualtime)
  }
  else # The number is infinity, so return everything
  {
  
  }

  #Then we deal with the frequency
  
  if(is.finite(frequency)) # Check that time finite. If so, trim down the dataset to the single finite time point given.
  {
    frequency = as.numeric(frequency) # clean up the data type just in case the user is lazy
    data.df = data.df %>% filter(Frequency == frequency)
  }

  #Then we deal with the textey ones
  
  data.df = data.df %>% filter(str_detect(Unit, unit))
  data.df = data.df %>% filter(str_detect(Sample, samplesubset))
  data.df = data.df %>% filter(str_detect(Experiment, experiment))
  
  return(data.df)
  
  
}



#' Standardise how well numbers are represented
#'
#' @param data.df A standard ECIS data frame
#' @param time The time point that needs rounding
#'
#' @return A timepoint that exactly aligns with a measured datapoint
#'
#' @export
#'
#' @examples
#' ecis_roundtime(data.df, 100)
#' 
ecis_roundtime = function(data.df, time) {
  times = unique(data.df$Time)
  numberinlist = which.min(abs(times - time))
  timetouse = times[numberinlist]
  
  return(timetouse)
}