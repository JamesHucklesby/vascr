
#' Export a prism-compatable data set
#'
#' @param data.df ECIS dataframe
#' @param unit Unit of data to export
#' @param frequency Frequency of data requored, modeled data defaults to 0
#'
#' @return A data frame that can be copied and pasted into prism
#' @export
#' 
#' @importFrom tidyr spread
#' @importFrom tibble as_tibble
#' @importFrom dplyr summarise group_by
#'
#' @examples
#' ecis_prism(data.df, "Rb", 0)
#' 

ecis_prism = function(data.df, unit, frequency){
  
  #Cut the data frame down to what can reasonably be represented on one prism table
  
  data.df = subset(data.df, Frequency == frequency)
  data.df = subset(data.df, Unit == unit)
  
  data.df = dplyr::summarise(group_by(data.df, Sample, Time, Experiment),
                             Value=mean(Value))
  
  #Get rid of all the variables that are not required in prism
  data.df$"n" = NULL
  data.df$"sd" = NULL
  data.df$"sem" = NULL
  data.df$"Unit" = NULL
  data.df$"Frequency" = NULL
  data.df$"TimeID" = NULL
  
  #Generate a row title
  data.df$"ExpSam" = paste(data.df$Sample, "(",data.df$Experiment,")")
  data.df$"Experiment" = NULL
  data.df$"Sample" = NULL
  
  #Do the magic bit
  data.df = tibble :: as_tibble(data.df) #This row just makes tidyR work nicley
  data.df = tidyr::spread(data.df, "ExpSam", "Value")
  
  #Now delete all the bracketed bits
  base::colnames(data.df) = gsub("\\s*\\([^\\)]+\\)","",as.character(colnames(data.df)))
  
  return (data.df)
}


