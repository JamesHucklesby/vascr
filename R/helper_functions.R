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
#' Replaces A1 in strings with A01. Important for importing ABP files which may use either notation. Returns NA if the string could not be normalised, which can be configured to throw a warning in import code.
#'
#' @param well The well to be standardised 
#'
#' @return Standardised well names
#' 
#' @export
#'
#' @examples 
#' ecis_standardise_wells('A01')
#' ecis_standardise_wells('A 1')
#' 
ecis_standardise_wells = function(well) {
  
  # First try and fix the user input
  well = toupper(well) # Make it upper case
  well = gsub(" ", "", well, fixed = TRUE) # Remove spaces
  well = gsub("[^0-9A-Za-z///' ]","" , well ,ignore.case = TRUE)
  well = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", well, perl = TRUE) # Add 0's
  
  # Check that it now conforms
  
  wells = expand.grid(LETTERS[1:8],c(1:12))
  wells$pasted = paste(wells$Var1,wells$Var2)
  wells = as.vector(wells$pasted)
  wells = gsub(" ", "", wells, fixed = TRUE) # Remove spaces
  wells = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", wells, perl = TRUE) # Add O's
  
  if(!(well %in% wells))
  {
    return ("NA")
  }
  
  return(well)
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
#' @export
#'
#' @examples
#' ecis_find_time(growth.df, 146.2)
#' 
ecis_find_time = function(data.df, time) {
  times = unique(data.df$Time)
  numberinlist = which.min(abs(times - time))
  timetouse = times[numberinlist]
  
  return(timetouse)
}