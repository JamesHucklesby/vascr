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
#' @export
#'
#' @examples
#' 
#' ecis_normalise(data.df, 100)
#' 
ecis_normalise = function(data.df, normtime, divide = FALSE)
{
    
    if (divide == TRUE){
      returndata.df = data.df %>%
        dplyr:: group_by(Unit,Well,Sample,Frequency, Experiment) %>%
        dplyr:: arrange(Time) %>%
        dplyr:: mutate(Value = Value / Value[Time == normtime])
    }
    else{
      returndata.df = data.df %>%
        dplyr:: group_by(Unit,Well,Sample,Frequency, Experiment) %>%
        dplyr:: arrange(Time) %>%
        dplyr:: mutate(Value = Value - Value[Time == normtime])
    }
    

  if(isFALSE(all(is.finite(returndata.df$Value)))){
    warning("NaN values or infinities generated in normalisation. Proceed with caution")
  }
  
  return(returndata.df)
  
  }
