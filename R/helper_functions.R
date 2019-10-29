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
#' ecis_generate_continuous("  30,000.01 cells ")
#' 
ecis_generate_continuous = function(string)
{
  
  string2 = gsub(",", "", string)     #Remove commas from numbers
  string3 = paste( "#", string2, "#") #Add protective filler so we can strip off end characters later
  string3.5 = gsub("[^0-9.-]", "#", string3) # Replace everything non-numeric with #'s 
  string4 = ecis_collapse_hash(string3.5) # Remove duplicate #'s
  string5 = substr(string4, 2, str_length(string4)-1) # Remove the protective #'s we added earlier
  string6 = gsub("#", ",", string5) # Switch out the # for a , to be standard
  
  title1 = string # Make a copy of the string
  title1.5 = trimws(title1) # Trim off any leading or trailing white spaces. We can't just strip the lot as some will be in titles and we want to conserve these
  title2 = gsub("[,+:_*-]","#",title1.5) # Hash out any deliniators that might be used
  title2.5 = paste( "#", title2, "#", sep = "") # Add protective endplates
  title4 = gsub("[0-9.]", "#", title2.5) # Hash out all numbers, as these are effectivley deliniators
  title4.6 = gsub("# ", "#", title4) # Remove any spaces between hashes, as they delineate nothing
  title4.6 = gsub("# ", "#", title4) # Repeat a few times for completeness
  title4.6 = gsub("# ", "#", title4) # Finish the job hash space job
  title4.7 = gsub(" #", "#", title4.6) # Finish the job hash space job
  title4.7 = gsub(" #", "#", title4.7) # Finish the job hash space job
  title4.7 = gsub(" #", "#", title4.7) # Finish the job hash space job
  title5 = ecis_collapse_hash(title4.7) # Itterativley delete all the hashes
  title6 = substr(title5, 2, str_length(title5)-1) # Remove the protective #'s we added earlier
  title7 = gsub("#", ",", title6) # Switch out the # for a , to be standard
  
  return(paste(string6, title7, sep = ":"))
}

ecis_collapse_hash = function(string)
{
tempstring = "" # setup a placeholer to keep track of if the optimisation is still doing something

while(!identical(tempstring,string)) # Itterate, removing all duplicate #'s
{
  tempstring = string
  string = gsub("##", "#", string)
}

return(string)

}

#' Explode continuous variables in an ECIS dataframe
#'
#' @param data.df A standard ECIS dataframe
#' @param fields The names of the fields that will be split from the name
#' @param selectformat Force the software to use something other than the most common format
#'
#' @return A dataframe with the sample variables exploded
#' 
#' @importFrom magrittr "%>%"
#' @importFrom tidyr separate
#' @importFrom plyr mapvalues
#' @importFrom purrr map_lgl
#' 
#' @export
#'
#' @examples
#' data.df = growth.df
#' data.df$Sample = paste(data.df$Sample, "+ 10nm nothing")
#' exploded = ecis_explode_continuous(data.df)
ecis_explode_continuous = function(data.df, fields, selectformat = 1)
{
  # Explode out each factor, as delineated with a + 
  
   data.df = data.df %>% separate(Sample, c("V1", "V2", "V3", "V4", "V5"), sep = "[+]", remove = FALSE, fill = "right")
   
   # Now we replace the values with the machine standardised versions. we use map_values as this is much, much faster than processing each of the strings individualy, as they are often repeated many thousand times
   
   uniquenames = unique(data.df$V1)
   correctuniquenames = ecis_generate_continuous(uniquenames)
   data.df$V1.1 = mapvalues(data.df$V1, uniquenames, correctuniquenames)
   
   uniquenames = unique(data.df$V2)
   correctuniquenames = ecis_generate_continuous(uniquenames)
   data.df$V2.1 = mapvalues(data.df$V2, uniquenames, correctuniquenames)
   
   uniquenames = unique(data.df$V3)
   correctuniquenames = ecis_generate_continuous(uniquenames)
   data.df$V3.1 = mapvalues(data.df$V3, uniquenames, correctuniquenames)
   
   uniquenames = unique(data.df$V4)
   correctuniquenames = ecis_generate_continuous(uniquenames)
   data.df$V4.1 = mapvalues(data.df$V4, uniquenames, correctuniquenames)
   
   uniquenames = unique(data.df$V5)
   correctuniquenames = ecis_generate_continuous(uniquenames)
   data.df$V5.1 = mapvalues(data.df$V5, uniquenames, correctuniquenames)
  
   
   # Then separate the machine readable columns into the relevant parts
   
   data.df = data.df %>% separate(V1.1, into = c("Val1","Var1"), sep = ":")
   data.df = data.df %>% separate(V2.1, into = c("Val2","Var2"), sep = ":")
   data.df = data.df %>% separate(V3.1, into = c("Val3","Var3"), sep = ":")
   data.df = data.df %>% separate(V4.1, into = c("Val4","Var4"), sep = ":")
   data.df = data.df %>% separate(V5.1, into = c("Val5","Var5"), sep = ":")
   
   # Then clean up anu un-used columns
   emptyindex <- map_lgl(data.df, ~ all(is.na(.)))
   data.df <- data.df[, !emptyindex]
   
   return (data.df)
}


#' Generate human readable versions of the unit variable for graphing
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


#' Fix typographical errors in an ECIS dataframe
#' 
#' This function will go through all the sample and experiment names and replace all the values that are incorrect. Usefull for fixing up typographical errors, or places where you have named things differently inadvertently.
#'
#' @param data.df the data to correct
#' @param incorrect the error to be corrected
#' @param correct the corrrect string
#' @param limit can be set to "Sample or "Experiment" to limit the replacement to a single variable
#'
#' @return the repared dataframe
#' @export
#'
#' @examples
#' 
#' ecis_fix_error(growth.df, "cells", "cells plated")
#' 
ecis_fix_error = function (data.df, incorrect, correct, limit = "None")
{
  
  if (limit == "None" || limit == "Sample")
  {
  data.df$Sample = gsub(incorrect, correct, data.df$Sample)
  }
  
  if (limit == "None" || limit == "Experiment")
  {
  data.df$Experiment = gsub(incorrect, correct, data.df$Experiment)
  }
  
  return(data.df)
}

