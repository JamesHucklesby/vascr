#' Find which modeled units in the dataset
#'
#' @param data The dataset to analyse
#'
#' @return A vector of the modeled units in the dataset
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_modeled_in_data(growth.df)
#' 
#' 
vascr_modeled_in_data = function(data)
{
  allunits = unique(data$Unit)
  return(allunits[vascr_is_modeled_unit(allunits)])
}

#' Return the raw units in the dataset
#'
#' @param data The dataset to search
#'
#' @return A vector containing the raw units present in the data
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_raw_in_data(growth.df)
#' 
vascr_raw_in_data = function(data)
{
  allunits = unique(data$Unit)
  return(allunits[!vascr_is_modeled_unit(allunits)])
}

#' Split out all the frequenices if all is presented
#'
#' @param data.df The dataet to analyse
#' @param frequency The frequency to analyse
#'
#' @return A number of a frequency in the dataset
#' 
#' @keywords internal
#'
#' @examples
#' 
#' #vascr_realise_frequencies(growth.df, c(4594, 3000, "all"))
#' 
vascr_realise_frequencies = function(data.df, frequency)
{
  units = c()
  
  for(fre in frequency)
  {
    if(tolower(fre) == "all")
    {
      units = c(units, unique(data.df$Frequency))
    } else
    {
      units = c(units, fre)
    }
  }
  
  returndata = c()
  
  for(uni in units)
  {
    
    returndata = c(returndata, vascr_find_frequency(data.df, as.numeric(uni)))
  }
  
  returndata = unique(returndata) 
  
  return(returndata)
  
}




