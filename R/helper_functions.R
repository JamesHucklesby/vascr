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

#' Standardise well names accross import types
#' 
#' Replaces A01 in strings with A0. Important for importing ABP files which may use either notation.
#'
#' @param well The well to be standardised 
#'
#' @return Standardised well names
#' 
#' @export
#'
#' @examples 
#' ecis_standardise_wells('A01')
#' 
ecis_standardise_wells = function(well) {
  sub("(?<![0-9])0*(?=[0-9])", "", well, perl = TRUE)
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
#' ecis_roundtime(growth.df, 100)
#' 
ecis_roundtime = function(data.df, time) {
  times = unique(data.df$Time)
  numberinlist = which.min(abs(times - time))
  timetouse = times[numberinlist]
  
  return(timetouse)
}