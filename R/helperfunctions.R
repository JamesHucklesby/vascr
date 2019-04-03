#' Retitle
#' 
#' Recapitulation of the funciton in tidyR, allows the re-titling of a data frame from the top row of a dataset. Used in import funcitons to set titles from the content of ABP files. For internal use only.
#'
#' @param df A data frame containing the desired values in the top row
#'
#' @return A dataframe where the top row has been converted to titles.
#
retitle = function(df){
  
  names(df) = as.character(unlist(df[1,]))
  df = df[-1,]
  df
}


#' Round time to the nearest actual data point
#' 
#' This sub-function allows the package to round a given data point to align with a measured datapoint. This is important, as it prevents the program trying to use data it does not have.
#'
#' @param data.df The data frame that contains the full list of times
#' @param time The time to be rounded
#'
#' @return A timepoint found in data.df
#' @export
#'
#' @examples
#' ecis_roundtime(data.df, 100)
#' 
#' 
ecis_roundtime = function(data.df, time)
{
  times = unique (data.df$Time)
  numberinlist = which.min(abs(times - time)) 
  timetouse = times[numberinlist]
  
  return(timetouse)
}

