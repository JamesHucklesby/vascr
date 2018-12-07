#' Title
#'
#' @param data.df 
#' @param includemaxima 
#'
#' @return
#' @export
#'
#' @examples
ecis_align_max = function(data.df, includemaxima = FALSE)
{
  #Still does some strange crap but it's mostly there
  
  
  # Generate a summary table containing only the max values we need to triangulate
  result.df <- data.df %>% 
    dplyr::group_by(Sample, Unit, Frequency, Experiment, Well) %>%
    dplyr::filter(Value == max(Value))
  
  # Rename two of the summary variables so they don't clash
  result.df = dplyr::rename(result.df, Max_Value =  Value)
  result.df = dplyr::rename(result.df, Max_Time =  Time)
  result.df$TimeID = NULL
  
  #Reassemble time
  
  mergeddata.df = dplyr::left_join(data.df, result.df, by = c("Sample", "Experiment", "Frequency", "Unit", "Well"))
  
  mergeddata.df$Original_Time = mergeddata.df$Time
  mergeddata.df$Time = mergeddata.df$Time  - mergeddata.df$Max_Time
  
  #Deal to any rounding errors in the time subtraction (EG 5.00001 = 5.00000)
  mergeddata.df$Time = round(mergeddata.df$Time,5)
  
  if (includemaxima)
  {
    mergeddata.df$Max_Time = NULL
    mergeddata.df$Max_Value = NULL
    mergeddata.df$Original_Time = NULL
  }
  
}