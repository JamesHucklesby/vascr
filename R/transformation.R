
#' Summarise a vascr data set down to a particular level
#'
#' @param data.df Data set to summarize
#' @param level Level to summarise to, either "summary", "experiment" or "wells"
#'
#' @return The summarized data set
#' 
#' @importFrom stringr str_length
#' @importFrom dplyr reframe summarise
#' 
#' @export
#'
#' @examples
#' rbgrowth.df = vascr_subset(growth.df, unit = "Rb")
#' 
#' vascr_summarise(rbgrowth.df, level = "summary")
#' vascr_summarise(rbgrowth.df, level = "experiment")
#' vascr_summarise(rbgrowth.df, level = "wells")
#' 
vascr_summarise = function(data.df, level = "wells")
{
  level = vascr_match(level, c("summary", "wells", "experiments", "median_deviation"))
  
  
    data.df = vascr_force_resampled(data.df)

    if(level == "summary")
    {
      data.df = vascr_summarise_summary(data.df)
    }
    
    if(level == "experiments")
    {
      data.df = vascr_summarise_experiments(data.df)
    }
    
    if(level == "median_deviation")
    {
      data.df = vascr_summarise_deviation(data.df)
    }
    
  
  return(data.df)
  
}


#' Summarise a vascr data set to the level of deviation
#'
#' @param data.df The data set to summarise
#'
#' @return The dataset, summarized with deviations
#' 
#' @noRd
#' 
#' @importFrom dplyr group_by
#'
#' @examples
#' vascr_summarise_deviation(growth.df %>% vascr_subset(unit = "Rb"))
#' 
vascr_summarise_deviation = function(data.df){
  
processed = data.df %>% 
  group_by(.data$Time, .data$Experiment, .data$SampleID) %>% 
  mutate(Median_Deviation = abs(.data$Value/median(.data$Value)-1)) %>%
  mutate(Median_Value = median(.data$Value))

return(processed)

}



#' Summarise a vascr dataset to the level of experiments
#'
#' @param data.df A dataset, must be at the wells level
#' @return A vascr dataset, summarised to the level of experiments
#' 
#' @importFrom dplyr n
#' 
#' @noRd
#'
#' @examples
#' vascr_summarise_experiments(rbgrowth.df)
vascr_summarise_experiments = function(data.df)
{
  
  summary_level = vascr_find_level(data.df)
  
  if(summary_level == "wells")
  {
    experiment.df = data.df %>%
      group_by(.data$Time, .data$Unit, .data$Frequency, .data$Sample, .data$Experiment, .data$Instrument, .data$SampleID) %>%
      reframe(sd = sd(.data$Value), n = n(),min = min(.data$Value), max = max(.data$Value), Well = paste0(unique(.data$Well), collapse = ","),Value = mean(.data$Value), sem = .data$sd/sqrt(.data$n), .groups = "drop")
    
    
    experiment.df = experiment.df %>% ungroup()
    
  } else
  {
    stop("Requested data is less summarised than the data input, try again")
  }
  
  return(experiment.df)
}


#' Summarise a vascr dataset to the level of an overall summary
#'
#' @param data.df A vascr dataset, at either wells or experiments level
#'
#' @return A vascr dataset at overall summary level
#' 
#' @importFrom dplyr group_by reframe
#' 
#' @noRd
#'
#' @examples
#' vascr_summarise_summary(rbgrowth.df)
#' 
vascr_summarise_summary = function(data.df)
{
  
  summary_level = vascr_find_level(data.df)
  
  if(summary_level == "wells")
  {
    data.df = vascr_summarise_experiments(data.df)
    summary_level = vascr_find_level(data.df)
  }
  
  if(summary_level == "experiments")
  {
    summary.df = data.df %>%
      group_by(.data$Time, .data$Unit, .data$Frequency, .data$Sample, .data$Instrument) %>%
      reframe(sd = sd(.data$Value), totaln = sum(.data$n), n = n(), min = min(.data$Value), max = max(.data$Value), Well = paste0(unique(.data$Well), collapse = ","), 
              Value = mean(.data$Value), Experiment = "Summary", sem = .data$sd/sqrt(.data$n),  .groups = "drop")
    return(summary.df)
  }
  
  else if(summary_level == "summary")
  {
    return(data.df)
  }

}



# Normalization function --------------------------------------------------

#' Normalize ECIS data to a single time point
#' 
#' This function normalises each unique experiment/well combination to it's value at the specified time. Contains options to do this either by division or subtraction. Can be run twice on the same dataset if both operations are desired.
#'
#' @param data.df Standard vascr dataframe
#' @param normtime Time to normalise the data to
#' @param divide  If set to true, data will be normalized via a division. If set to false (default) data will be normalsed by subtraction. Default is subtraction
#'
#' @return A standard ECIS dataset with each value normalised to the selected point.
#' 
#' @export
#' 
#' @importFrom dplyr left_join right_join filter
#'
#' @examples
#' 
#' data = vascr_normalise(growth.df, normtime = 100)
#' head(data)
#' 
vascr_normalise = function(data.df, normtime, divide = FALSE) {
  
  data.df = vascr_force_resampled(data.df)
  
  data.df = vascr_remove_metadata(data.df)
  
  data.df = ungroup(data.df)
  
  # Create a table that contains the full data set at the time we are normalizing to
  mininormaltable = data.df %>% filter(.data$Time == vascr_find_time(data.df, normtime))
  mininormaltable$NormValue = mininormaltable$Value
  mininormaltable$Value = NULL
  mininormaltable$NormTime = normtime
  mininormaltable$Time = NULL
  
  # Now use left_join to match this time point to every other time point.This creates a table with an additional column that everything needs to be normalised to, allowing for the actual normalization to be done via vector maths. Not the most memory efficient, but is explicit and clean.
  
  fulltable = right_join(data.df, mininormaltable, by = c("Frequency", "Well", "Unit", "Instrument", "Experiment", "Sample", "SampleID"))
  
  
  # Run the actual maths for each row
  
  if (divide == TRUE) {
    fulltable$Value = fulltable$Value/fulltable$NormValue
  } else {
    fulltable$Value = fulltable$Value - fulltable$NormValue
  }
  
  # Clean up temporary rows
  fulltable$NormTime = NULL
  fulltable$NormValue = NULL
  
  
  # Warn if maths errors have occoured
  if (isFALSE(all(is.finite(fulltable$Value)))) {
    warning("NaN values or infinities generated in normalisation. Proceed with caution")
  }
  
  #Return the whole table
  return(fulltable)
  
}

# subsample data ---------------------------------------------------------


#' Subsample data
#' 
#' Returns a subset of the original data set that has only every nth value. Greatly increases computational preformance for a minimal loss in resolution during time course experiments.
#'
#' @param data.df An ECIS dataset
#' @param nth  An integer. Every nth value will be preserved in the subsetting
#'
#' @return Downsampled ECIS data set
#' 
#' @importFrom dplyr left_join
#' 
#' @noRd
#'
#' @examples
#' 
#' unique(vascr_subsample(growth.df, 10)$Time)
#' 
vascr_subsample = function(data.df, nth) {
  
  Time = unique(data.df$Time)
  TimeID = c(1:length(Time))
  
  if(is.infinite(nth) || nth == 1 || length(Time)==1)
  {
    return(data.df)
  }
  
  
  time.df = data.frame(TimeID, Time)
  
  withid.df = dplyr::left_join(data.df, time.df, by = "Time")
  subset.df = subset(withid.df, (TimeID%%nth) == 1)
  
  subset.df$TimeID = NULL
  
  subset.df = as_tibble(subset.df)
  
  return(subset.df)
  
}




#' Interpolate times between two datapoints
#'
#' @param data.df Takes a vascr dataframe to interpolate, but may only contain one frequency and unit pair
#' @param npoints Number ofpoints to interpolate, defaults to same as submitted dataset
#' @param from Time to start interpolation at, default minimum in dataset
#' @param to Time to end interpolation at, default maximum in dataset
#' 
#' @importFrom stats approx
#' @importFrom dplyr reframe rename ungroup mutate group_by across
#'
#' @return A resampled vascr dataset
#' 
#' # Not exposed, as a component of vascr_resample_time
#' @noRd 
#' 
#' @examples
#'  data.df = growth.df %>% vascr_subset(time = c(1,10), unit = "R", frequency = 4000, well = c("D01", "D02", "D03"))
#'  vascr_interpolate_time(data.df)
vascr_interpolate_time = function(data.df, npoints = vascr_find_count_timepoints(data.df), from = min(data.df$Time), to = max(data.df$Time))
{
  
  if(length(unique(data.df$Frequency))>1 || length(unique(data.df$Unit))>1)
  {
    stop("vascr_interpolate_time only supports one unit and frequency at a time")
  }
  
  
  originalsample = unique(data.df$Sample)
  
  xout = seq(from = from, to = to, length.out = npoints)
  
  processed = data.df %>% group_by(across(c(-"Value", -"Time"))) %>%
    reframe(New_Value = approx(.data$Time, .data$Value, xout = xout, rule = 2)$y, New_Time = approx(.data$Time, .data$Value, xout = xout, rule = 2)$x) %>%
    rename(Value = "New_Value", Time = "New_Time") %>%
    ungroup()
  
  return(processed)
}

#' Resample a vascr dataset
#' 
#' Impedance sensing data is often not collected simultaneously, which creates issues
#' summarising and plotting the data. This function interpolates these data to allow
#' these downstream functions to happen.
#'
#' @param data.df The vascr dataset to resample
#' @param npoints Manually specificity the number of points to resample at, default is the same frequency as the input dataset
#' 
#' @importFrom foreach foreach `%do%`
#' @importFrom dplyr group_split group_by
#'
#' @return An interpolated vascr dataset
#' 
#' @export
#'
#' @examples
#' vascr_resample_time(growth.df, 5)
#' 
vascr_resample_time = function(data.df, npoints = vascr_find_count_timepoints(data.df))
{
  datasplit = data.df %>% group_by(.data$Frequency, .data$Unit) %>% group_split()
  
  baseline_times = npoints
  start = min(floor(data.df$Time))
  end = max(ceiling(data.df$Time))
  
  i = 1
  
  resampled = foreach(i = datasplit, .combine = rbind) %do%
    {
      vascr_interpolate_time(i, baseline_times, start, end)
    }
  
  return(resampled)
  
}


#' Remove all non-core ECIS data from a data frame
#' 
#' Useful if you want to to further data manipulation, without having to worry about tracking multiple, unknown columns.
#' 
#' @param data.df An ECIS data set
#' @param subset What to strip off. Default is all, more options to come.
#' 
#' @importFrom stringr str_trim
#' @importFrom dplyr any_of
#'
#' @return A dataset containing only the core ECIS columns
#' 
#' @noRd
#'
#' @examples
#' #growth.df$Instrument = "ECIS"
#' #exploded.df = vascr_explode(growth.df)
#' #cleaned.df = vascr_remove_metadata(exploded.df)
#' #identical(growth.df,cleaned.df)
vascr_remove_metadata = function(data.df, subset = "all")
{
  
  summary_level = vascr_find_level(data.df)
  
  if(summary_level == "summary" || summary_level == "experiments")
  {
    warning("You are removing some summary statistics. These are not re-generatable using vascr_explode alone, and must be regenerated with vascr_summarise.")
  }
  
  removed.df = data.df %>% select(any_of(vascr_cols()))
  
  return(removed.df)
}










