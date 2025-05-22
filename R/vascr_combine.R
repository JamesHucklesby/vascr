# Worker functions for importing files ------------------------------------

#' Combine ECIS data frames end to end
#' 
#' This function will combine ECIS data sets end to end. Preferential to use over a simple rbind command as it runs additional checks to ensure that data points are correctly generated
#'
#' @param ... List of data frames to be combined
#' @param resample Automatically try and re sample the data set. Default is FALSE
#'
#' @return A single data frame containing all the data imported, automatically incremented by experiment
#' 
#' @export
#'
#' @examples
#' #Make three fake experiments worth of data
#' experiment1.df = vascr_subset(growth.df, experiment = "1")
#' experiment2.df = vascr_subset(growth.df, experiment = "2")
#' experiment3.df = vascr_subset(growth.df, experiment = "3")
#' 
#' data = vascr_combine(experiment1.df, experiment2.df, experiment3.df)
#' head(data)
#' 
#' 
vascr_combine = function(..., resample = FALSE) {
  
  dataframes = list(...)
  
  # Generate an empty data frame with the correct columns to fill later
  alldata = dataframes[[1]][0, ]
  loops = 1
  
  # Check that both data frames have the same time base
  for (i in dataframes)
  {
    if (!(exists("timepointstomerge")))
    {
      timepointstomerge = unique(i$Time)
    }
    
    if ((!identical(timepointstomerge,unique(i$Time))) & isFALSE(resample))
    {
      vascr_notify("warning","Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.")
    }
  }
  
  # Mash all the data frames together
  
  for (i in dataframes) {
    indata = i
    indata = vascr_remove_metadata(indata)
    indata$Experiment = paste(loops, ":", indata$Experiment)
    loops = loops + 1
    alldata = rbind(alldata, indata)
  }
  
  alldata$Experiment = as.factor(alldata$Experiment)
  
  if(isTRUE(resample))
  {
    alldata = vascr_resample_time(alldata)
  }
  
  
  return(alldata)
  
}

