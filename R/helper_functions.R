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
#' ecis_standardise_wells('tortoise') # Non-standardisable becomes NA
#' ecis_standardise_wells(growth.df$Well)
#' 
ecis_standardise_wells = function(well) {
  
  # First try and fix the user input
  well = toupper(well) # Make it upper case
  well = gsub(" ", "", well, fixed = TRUE) # Remove spaces
  well = gsub("[^0-9A-Za-z///' ]","" , well ,ignore.case = TRUE)
  well = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", well, perl = TRUE) # Add 0's
  
  # Check that it now conforms

  
  if(is.na(match(well[1],ecis_96_well_names())))
  {
    return ("NA")
  }
  
  return(well)
}

#' All the well names of a 96 well plate
#'
#' @return Vector containing all wells of a 96 well plate
#' @export
#'
#' @examples
#' ecis_96_well_names()
#' 
ecis_96_well_names = function()
{
  
  wells = expand.grid(LETTERS[1:8],c(1:12))
  wells$pasted = paste(wells$Var1,wells$Var2)
  wells = as.vector(wells$pasted)
  wells = gsub(" ", "", wells, fixed = TRUE) # Remove spaces
  wells = gsub("(?<![0-9])([0-9])(?![0-9])", "0\\1", wells, perl = TRUE) # Add O's
  return(wells)
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

#' Detect if an ECIS dataset has been normalised
#'
#' @param data.df an ECIS dataset
#'
#' @return The time the data was normalised to, or FALSE if not normalised
#' @export
#'
#' @examples
#' 
#' standard = growth.df
#' normal = ecis_normalise(growth.df, 100)
#' ecis_detect_normal(standard)
#' ecis_detect_normal(normal)

ecis_detect_normal = function(data.df)
{
  timecrushed = data.df %>% group_by(Time) %>% 
    summarise(deviation = sd(Value))
  timecrushed = subset(timecrushed, deviation == 0)
  if (nrow(timecrushed)==0)
  {
    return (FALSE)
  }
  return(timecrushed$Time)
}


#' Generate CSV separated continuous variables
#'
#' @param string The string to be converted to a continuous vector
#'
#' @return A CSV separated list of continuous variables
#' 
#' @importFrom stringr str_length
#' 
#' @export 
#'
#' @examples
#' 
#' ecis_generate_continuous("  30,000.01 cells + 1 mg/ml TNFa")
#' 
ecis_generate_continuous = function(string)
{
  string2 = gsub(",", "", string)     #Remove commas from numbers
  string3 = paste( "#", string2, "#") #Add protective filler so we can strip off end characters later
  string4 = gsub("[^0-9.-]", "#", string3) # Replace everything non-numeric with #'s 
  
  
  tempstring = "" # setup a placeholer to keep track of if the optimisation is still doing something
  
  while(!identical(tempstring,string4)) # Itterate, removing all duplicate #'s
  {
    tempstring = string4
    string4 = gsub("##", "#", string4)
  }
  
  rm(tempstring)
  
  string5 = substr(string4, 2, str_length(string4)-1) # Remove the protective #'s we added earlier
  
  string6 = gsub("#", ",", string5) # Switch out the # for a , to be standard
  
  return(string6)
  
}

#' Explode continuous variables in an ECIS dataframe
#'
#' @param data.df A standard ECIS dataframe
#' @param fields The names of the fields that will be split from the name
#'
#' @return A dataframe with the sample variables exploded
#' 
#' @importFrom magrittr "%>%"
#' @importFrom tidyr separate
#' 
#' @export
#'
#' @examples
#' data.df = growth.df
#' data.df$Sample = paste(data.df$Sample, " 10nm nothing")
#' ecis_explode_continuous(data.df, c("Cells", "Nothing"))

#' 
ecis_explode_continuous = function(data.df, fields)
{
  data.df$Sample = ecis_generate_continuous(data.df$Sample)
  data.df = data.df %>% separate(Sample, fields)
  return(data.df)
}


#' Title
#'
#' @param unit The unit to submit
#' @param frequency The frequency to submit
#'
#' @return An expression containing the correct data label for the unit
#' @export
#'
#' @examples
#' 
#' ecis_titles("Rb")
#' 
ecis_titles = function (unit, frequency = 0)
{
  
  # Modeled paramater
  if (unit == "Rb"){return (expression(paste("Rb (",Omega," cm"^2, ")")))}
  if (unit == "Cm"){return (expression(paste("Cm (",mu,"F/cm"^2, ")")))}
  if (unit == "Alpha"){return (expression(paste("Alpha (",ohm," cm"^2, ")")))}
  if(unit == "RMSE") { return("Model Fit RMSE")}
  if(unit == "Drift") { return("Drift (%)")}
  
  # Measured quantaties
  if(unit == "C") { return(expression(paste("Capacitance (",mu,"F)")))}
  if(unit == "R") { return("Resistance (ohm)")}
  if(unit == "P") { return("Phase (degrees)")}
  if(unit == "X") { return("Reactance (ohm)")}
  if(unit == "Z") { return("Impedance (ohm)")}
  
  # If not overriden, return what was input
  return(unit)
  
}

