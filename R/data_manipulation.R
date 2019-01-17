#' Align key points in an ECIS trace
#'
#'This will either align the max or minimum points from each graph. As specified.
#'
#'Sets the time at which each replicate well is maximal to time 0. Results in variables aligned by maximum time, rather than time from seeding.
#'
#' @param data.df A standard ECIS data file
#' @param point Which key point, either "max" or "min"
#' @param discrepancy A standard rounding constant to compensate for rounding errors in the subtraciton process
#'
#' @return An ECIS dataset where the key time points all happen at time 0
#' 
#' @export
#'
#' @examples
#' 
#' ecis_align_key(data.df, "max")
#' ecis_align_key(data.df, "min")

ecis_align_key = function(data.df, point, discrepancy = 5){
  
  if (point == "max")
  {
    returndata.df = data.df %>%
      dplyr:: group_by(Unit, Well, Sample, Frequency, Experiment) %>%
      dplyr:: arrange(Time) %>%
      dplyr:: mutate (Time = Time- Time[which.max(Value)])
  }
  
  else if (point == "min")
  {
    returndata.df = data.df %>%
      dplyr:: group_by(Unit, Well, Sample, Frequency, Experiment) %>%
      dplyr:: arrange(Time) %>%
      dplyr:: mutate (Time = Time- Time[which.min(Value)])
  }
  
  else
  {
    warning("No supported key point string entered. Please try again")
    return (FALSE)
  }
  
  
  returndata.df$Time = round(returndata.df$Time,discrepancy)
  
  return (returndata.df)
}
