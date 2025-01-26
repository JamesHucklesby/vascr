
#' Summarise a vascr data set down to a particular level
#'
#' @param data.df Data set to summarize
#' @param level Level to summarise to, either "summary", "experiment" or "wells"
#'
#' @return The summarized data set
#' 
#' @importFrom stringr str_length
#' @importFrom dplyr reframe summarise filter
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
#' @importFrom stats median
#'
#' @examples
#' vascr_summarise_deviation(growth.df %>% vascr_subset(unit = "R", frequency = 4000, time = 5, well =c("A01","A02", "A03", "A04", "A05")))
#' 
vascr_summarise_deviation = function(data.df){
  
processed = data.df %>% 
  group_by(.data$Time, .data$Experiment, .data$SampleID) %>% 
  mutate(Median_Deviation = abs(.data$Value/median(.data$Value)-1)) %>%
  mutate(Median_Value = median(.data$Value)) %>%
  mutate(MAD = median(.data$Value - .data$Median_Value))

processed

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
      reframe(sd = sd(.data$Value), n = n(),min = min(.data$Value), max = max(.data$Value), Well = paste0(unique(.data$Well), collapse = ","),Value = mean(.data$Value), sem = .data$sd/sqrt(.data$n))
    
    
    experiment.df = experiment.df %>% ungroup()
    
  } else
  {
    vascr_notify("error","Requested data is less summarised than the data input, try again")
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
              Value = mean(.data$Value), Experiment = "Summary", sem = .data$sd/sqrt(.data$n))
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
  
  if(is.null(normtime))
  {
    return(data.df)
  }
  
  data.df = vascr_force_resampled(data.df)
  
  data.df = vascr_remove_metadata(data.df)
  
  data.df = ungroup(data.df)
  
  # Create a table that contains the full data set at the time we are normalizing to
  mininormaltable = data.df %>% dplyr::filter(.data$Time == vascr_find_time(data.df, normtime))
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
    vascr_notify("warning","NaN values or infinities generated in normalisation. Proceed with caution")
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
    vascr_notify("error","vascr_interpolate_time only supports one unit and frequency at a time")
  }
  
  
  # originalsample = unique(data.df$Sample)
  
  xout = seq(from = from, to = to, length.out = npoints)
  
  # approx(data.df$Time, data.df$Value, method = "linear", n = npoints)
  
  processed = data.df %>% group_by(across(c(-"Value", -"Time"))) %>%
    reframe(New_Value = approx(.data$Time, .data$Value, xout = xout, rule = 2)$y, New_Time = approx(.data$Time, .data$Value, xout = xout, rule = 2)$x) %>%
    rename(Value = "New_Value", Time = "New_Time") %>%
    ungroup()
  
  return(processed)
}


#' Remove columns in the dataset, if they exist
#'
#' @param data.df Dataset to remove cols from
#' @param cols Columns to remove from the dataset
#'
#' @returns Revised dataset
#' 
#' @noRd
#'
#' @examples
#' vascr_remove_cols(growth.df, "Sample")
#' 
vascr_remove_cols = function(data.df, cols){
  
  processed.df = data.df
  
  for(col in cols){
    
    if(col %in% colnames(data.df))
    {
      processed.df[col] = NULL
    }
  }
  
  return(processed.df)
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
#' vascr_resample_time(growth.df, 5, 0, 200)
#' vascr_resample_time(growth.df, 5)
#' 
vascr_resample_time = function(data.df, npoints = vascr_find_count_timepoints(data.df), start = min(data.df$Time), end = max(data.df$Time))
{
  datasplit = data.df %>% vascr_remove_cols(c("sd", "n", "min", "max", "sem")) %>% group_by(.data$Frequency, .data$Unit) %>% group_split() 
  
  baseline_times = npoints
  
  i = 1
  
  resampled = foreach(i = datasplit, .combine = rbind) %do%
    {
      vascr_interpolate_time(i, baseline_times, start, end)
    }
  
  return(resampled)
  
}


#' Calculate the area under the curve of a trace
#'
#' @param data.df vascr data set containing a single trace
#' 
#' @importFrom dplyr lead group_by_all mutate filter
#'
#' @return The calcaulted area under the curve
#' 
#' @noRd
#'
#' @examples
#' vascr_auc(growth.df %>% vascr_subset(unit = "R", frequency = 4000, well = "A01"))
#' 
vascr_auc = function(data.df) {

      auc = data.df %>% mutate(Time2 = lead(.data$Time), Value2 = lead(.data$Value)) %>% 
                  dplyr::filter(!(is.na(.data$Time2) | is.na(.data$Value2) | is.na(.data$Value))) %>%
                  group_by_all() %>%
                  mutate(auc = abs((.data$Time2 - .data$Time) * mean(.data$Value, .data$Value2)))

      sum(auc$auc)
}




#' Plot showing the sensitivity of resampling
#'
#' @param data.df 
#'
#' @returns A plot showing sensitivity of resamping
#' 
#' @noRd
#' 
#' @importFrom cli cli_progress_cleanup cli_progress_update cli_progress_bar
#' @importFrom foreach foreach `%do%`
#' @importFrom dplyr filter
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 geom_line ylim geom_hline aes
#'
#' @examples
#' vascr_plot_resample_range(growth.df)
#' 
#' bigdata = vascr_import("ECIS", raw ="raw_data/growth/growth1_raw.abp", experiment = 1)
#' 
#' toprocess = bigdata %>% dplyr::mutate(Experiment = "1", Sample = "Test")
#' 
#' vascr_plot_resample_range(data.df = growth.df)
#' 
vascr_plot_resample_range = function(data.df, unit = "R", frequency  = 4000, well = "A01"){
  
  data.df = data.df %>% vascr_subset(unit = unit, frequency = frequency, well = well) 
  
  checktimes = seq(from = vascr_find_count_timepoints(data.df), to = 2, length.out = 20) %>% round() %>% unique()
  
  cli_progress_bar(total = length(checktimes))
  
    boot = foreach (i = checktimes, .combine = rbind) %do% {
            cli_progress_update()
            vascr_plot_resample(data.df, plot = FALSE, newn = i)  
    }

  cli_progress_cleanup()
  
  boot %>% dplyr::filter(r2 > 0.999)

boot2 = boot %>%
          pivot_longer(-n, names_to = "variable", values_to = "value") %>%
          dplyr::filter(value>0.9, value<1.1)

ggplot(boot2) +
  geom_line(aes(x = n, y = value, colour = variable)) +
  ylim(c(0.9,1)) +
  geom_hline(aes(yintercept = 0.999))


}





#' Plot the data resampling process
#'
#' @param data.df Dataset to analyse
#' @param unit Unit to use, defaults to R
#' @param frequency Frequency to use, defaults to 4000
#' @param well Well to use, defaults to A01 (or first well in plate)
#' 
#' @importFrom ggplot2 geom_rug geom_line ylim aes
#' @importFrom stats ccf
#' @importFrom dplyr filter
#'
#' @export
#'
#' @returns A plot showing how well the resampled data conforms to the actual data set
#'
#' @examples
#' vascr_plot_resample(growth.df)
#' vascr_plot_resample(growth.df, plot = FALSE)
#' 
#' 
vascr_plot_resample = function(data.df, unit = "R", frequency = "4000", well = "A01", newn = 20, plot = TRUE)
      {
          base_data = data.df %>% dplyr::filter(!is.na(.data$Value))
          
          to_return = list()
          
          to_return["n"] = newn
  
          # Create resampled set
          original_data = base_data %>% vascr_subset(unit = "R", frequency = 4000, well = "A01")
          oldn = vascr_find_count_timepoints(original_data)
          new_data = original_data %>% vascr_resample_time(npoints = newn)
          reverse_processed = new_data %>% vascr_resample_time(npoints = oldn)
          
          # Calculate change in ACF
          old_auc = vascr_auc(original_data)
          new_auc = vascr_auc(new_data)
          d_auc = 1-(old_auc-new_auc)/old_auc
          
          to_return["d_auc"] = d_auc
          
          # original_data$Time == reverse_processed$Time
          
          # diff.df = tibble(time = original_data$Time, original = original_data$Value, processed = reverse_processed$Value)
          
          # diff.df$residuals = diff.df$original - diff.df$processed
          
          
          to_return["r2"] = 1 - mean((original_data$Value - reverse_processed$Value)^2) / (mean((original_data$Value - mean(original_data$Value))^2))

          
          # lmod = lm('processed ~ original', diff.df %>% select("processed", "original"))
          # stats:::plot.lm(lmod)
          # print(summary(lmod))
          
          
          # lm_original = lm('Value ~ .', original_data %>% select("Value"))
          # lm_resampled = lm('Value ~ .', new_data %>% select("Value"))
          
          # to_return["aic"] = (AIC(lm_original, lm_resampled)$AIC[2])
          # to_return["aic"] = (AIC(lmod))
          # to_return["Bic"] = (BIC(lmod))
          
          
          # diff.df = diff.df %>% mutate(d2 =  abs(processed-original)^2)
          
          # sqrt(mean(diff.df$d2))
          
          rmse = sqrt(mean((original_data$Value - reverse_processed$Value)^2))
          
          
          
          to_return["ccf"] = ccf(original_data$Value, reverse_processed$Value, lag.max = 0, plot = FALSE)[[1]] %>% as.numeric()
          
          
          if(isFALSE(plot))
          {
            return(to_return %>% as.data.frame())
          }
          
          original_data$source = "original"
          new_data$source = "resampled"
          
          all = rbind(original_data, new_data)
          
          ggplot(all) +
            geom_line(aes(x = Time, y = Value, colour = source)) +
            geom_rug(aes(x = Time, colour = source))

}


#' Remove all non-core ECIS data from a data frame
#' 
#' Useful if you want to to further data manipulation, without having to worry about tracking multiple, unknown columns.
#' 
#' @param data.df An ECIS data set
#' @param subset What to strip off. Default is all, more options to come.
#' 
#' @importFrom stringr str_trim
#' @importFrom dplyr any_of select
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
    vascr_notify("warning","You are removing some summary statistics. These are not re-generatable using vascr_explode alone, and must be regenerated with vascr_summarise.")
  }
  
  removed.df = data.df %>% select(any_of(vascr_cols()))
  
  return(removed.df)
}



#' Title
#'
#' @param t1 
#' @param t2 
#'
#' @returns
#' @noRd
#' 
#' @importFrom dplyr mutate filter
#'
#' @examples
#'  t1 = growth.df %>% vascr_subset(unit = "R", frequency = 4000, experiment = 1, sample = "10,000_cells + HCMEC D3_line") %>% vascr_summarise(level = "experiments")
#'  t2 = growth.df %>% vascr_subset(unit = "R", frequency = 4000, experiment = 1, sample = "30,000_cells + HCMEC D3_line") %>% vascr_summarise(level = "experiments")
#' 
#' stretch_cc(t1, t2)
stretch_cc = function(t1, t2)
{
  
  # print(t1)
  # print(t2)
  
stretch = 1.5

stretch_series = (c(1:25)/5)

stretching = foreach(stretch = stretch_series, .combine = rbind) %do%{

      
      t2b1 = t2 %>% mutate(Time = Time*stretch) %>% 
            dplyr::mutate(Time = Time - min(Time)) %>%
            vascr_subset(time = c(min(t1$Time), max(t1$Time))) 
      
      
      # t2b1 %>% vascr_resample_time(npoints = 10)
      
      # t2b1 %>% vascr_resample_time(npoints = 3)
      
      t2b = t2b1 %>%
            vascr_resample_time(npoints = vascr_find_count_timepoints(t1), start = min(t1$Time), end = max(t1$Time))
      
      # print(t2b$Value)
      # rbind(t1, t2, t2s) %>% vascr_plot_line
      
      # cc = ccf(t1$Value, t2$Value, lag.max = 0, plot = FALSE)$acf[1]
      cc_full = ccf(t1$Value, t2b$Value, plot = FALSE)
      cc.df = data.frame(lag = cc_full$lag, cc = cc_full$acf)
      stretch_cc = cc.df %>% dplyr::filter(lag == 0) %>% .$cc
      stretch_shift_cc  = cc.df %>% dplyr::filter(cc == max(cc)) %>% .$cc
      stretch_shift_shift  = cc.df %>% dplyr::filter(cc == max(cc)) %>% .$lag
      
      # print(cc)
      
       # t2b %>% mutate(cc = cc, stretch = stretch)
      
      return(tribble(~"stretch_cc", ~"stretch_factor", ~"stretch_shift_cc", ~"stretch_shift_shift", stretch_cc, stretch, stretch_shift_cc, stretch_shift_shift))

}

# ad = rbind(t1 %>% vascr_remove_cols(c("n", "sem", "sd", "min", "max")) %>% mutate(cc = 0), stretching) %>%
#     group_by(Experiment, Sample) %>%
#     mutate(Value = (Value - min(Value))/(max(Value) - min(Value))) %>%
#     ungroup()
# 
# 
#  (ad %>% ggplot()+
#   geom_line(aes(x = Time, y = Value, colour = cc, group = Experiment)) +
#   scale_colour_viridis_c()) %>%
#   plotly::ggplotly()
# 
# (ad %>% ggplot()+
#     geom_line(aes(x = Time, y = Value, colour = as.character(cc), group = Experiment))) %>%
#   plotly::ggplotly()
# 
# (stretching %>% select("Experiment","cc") %>%
#   distinct() %>%
#   ggplot() +
#   geom_point(aes(x = Experiment, y = cc))) %>%
#   plotly::ggplotly()
# 


stretching

tr1 = stretching %>% dplyr::filter(stretch_cc == max(stretch_cc)) %>% select(stretch_cc, stretch_factor)

tr2 = stretching %>% dplyr::filter(stretch_shift_cc == max(stretch_shift_cc)) %>% 
  select(stretch_shift_cc, stretch_factor, stretch_shift_shift) %>% 
  mutate(stretch_shift_factor = stretch_factor, stretch_factor = NULL)

tr3 = stretching %>% dplyr::filter(stretch_factor == 1) %>% 
  dplyr::select("stretch_cc", "stretch_shift_cc", "stretch_shift_shift") %>%
  dplyr::mutate(cc = stretch_cc, stretch_cc = NULL) %>%
  dplyr::mutate(shift_cc = stretch_shift_cc, stretch_shift_cc = NULL) %>%
  dplyr::mutate(shift_shift = stretch_shift_shift, stretch_shift_shift = NULL)

tr = cbind(tr3, tr2, tr1)


return(tr)
}





#' Title
#'
#' @param data.df 
#' @param reference 
#' 
#' @importFrom dplyr as_tibble
#' @importFrom progressr progressor
#' @importFrom doFuture %dofuture%
#'
#' @returns
#' @noRd
#'
#' @examples
#' future::plan("multisession")
#' vascr_summarise_cc_stretch_shift(growth.df)
#' vascr_summarise_cc_stretch_shift(growth.df, 5)
vascr_summarise_cc_stretch_shift = function(data.df = growth.df, reference = "none"){

    toprocess = data.df %>% vascr_subset(unit = "R", frequency = 4000) %>% vascr_summarise(level = "experiments")
    # vascr_plot_line(toprocess)
    cc_data = toprocess %>% vascr_cc(reference)
    
    cli_progress_bar(total = nrow(cc_data))
    
    # progressr::handlers("cli")
    # progressr::handlers(global = TRUE)

    p <- progressr::progressor(along = c(1:nrow(cc_data)))
    
    s_cc = foreach (i  =  c(1:nrow(cc_data)), .combine = rbind) %dofuture% {
      
      cc_row = cc_data[i,]
      
      t1 = toprocess %>% dplyr::filter(Sample == cc_row$Sample.x & Experiment == cc_row$Experiment.x)
      t2 = toprocess %>% dplyr::filter(Sample == cc_row$Sample.y & Experiment == cc_row$Experiment.y)
      
      str = vascr:::stretch_cc(t1, t2)
      p()
      
      
      toreturn = cbind(cc_row %>% dplyr::select(-"cc"), str) %>% dplyr::as_tibble()
    }

    
    s_cc
    
    s_long = s_cc %>%
      rowwise() %>%
      mutate(title = paste(as.character(Sample.x), as.character(Sample.y), sep = " - ")) %>%
      select(title, Sample.x, Sample.y, cc, shift_cc, shift_shift, stretch_cc, stretch_factor, stretch_shift_cc, stretch_shift_factor, stretch_shift_shift) %>%
      pivot_longer(cols = c(-title, -Sample.x, -Sample.y))
    
    s_long

}


#' Title
#'
#' @param data.df 
#' @param reference 
#'
#' @returns
#' @noRd
#'
#' @examples
vascr_summarise_cc_stretch_shift_stats = function(data.df, reference = "none"){

s_long = vascr_summarise_cc_stretch_shift(data.df, reference)

s_long %>% filter(str_count(name, "cc")>0) %>%
 ggplot() +
  geom_point(aes(x = value, y = title, colour = name))



pairs = s_long %>% ungroup() %>% 
  filter(str_count(name, "cc") > 0) %>%
  select("Sample.x", "Sample.y", "title", "name") %>% distinct() %>%
  rowwise() %>%
  group_split()

reference_sample = vascr_find_sample(data.df, reference)

output = foreach (pair = pairs, .combine = rbind) %do% {
  
      
      s1 = pair$Sample.x
      s2 = pair$Sample.y
      sta = pair$name
      
      t1 = s_long %>% filter(Sample.x == s1, Sample.y ==s2) %>% filter(name == sta)
      
      if(isTRUE(reference == "none"))
      {
        t2 = rbind( s_long %>% filter(Sample.x == s1, Sample.y ==s1) %>% filter(name == sta),
                    s_long %>% filter(Sample.x == s2, Sample.y ==s2) %>% filter(name == sta))
      } else
      {
        t2 = rbind( s_long %>% filter(Sample.x == reference_sample, Sample.y == reference_sample) %>% filter(name == sta))
      }
      
      if(length(unique(c(t1$value, t2$value))) == 1){
        p$p.value = 1
      } else {
       p = t.test(t1$value, t2$value, var.equal = FALSE)
      }
      
      
      return(tribble(~name,     ~title,     ~p,        ~mean, ~sd, ~nsample, ~ncontrol,~Sample.x, ~Sample.y, ~refs,
                     pair$name, pair$title, p$p.value, mean(t1$value), sd(t1$value), length(t1$value), length(t2$value), s1, s2, paste(t2$value, collapse = ",")))
}


output$padj = p.adjust(output$p, "fdr")

output$stars <- symnum(output$p, corr = FALSE, na = FALSE, 
                       cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                       symbols = c("***", "**", "*", ".", " "))

 return(output)
}


#' Title
#'
#' @param data.df 
#' @param reference 
#'
#' @returns
#' @noRd
#'
#' @examples
#' vascr_plot_cc_stretch_shift_stats(growth.df)
#' vascr_plot_cc_stretch_shift_stats(growth.df, 5)
#' 
#' 
vascr_plot_cc_stretch_shift_stats = function(data.df, reference = "none"){

output = vascr_summarise_cc_stretch_shift_stats(data.df, reference)
  
output %>%
ggplot() +
  geom_point(aes(x = mean, y = title, color = name)) +
  geom_errorbar(aes(xmin = mean-sd, xmax = mean+sd, y = title, color = name)) +
  geom_text_repel(aes(x = mean, y = title, color = name, label = as.character(stars)), direction = "y", seed = 10, nudge_y = 0.2, box.padding = 0, point.padding = 0)



# s_sum = s_long %>% rowwise() %>%
#   group_by(title, name) %>%
#   reframe(mean = mean(value), sd = sd(value))
# 
# s_sum %>% filter(str_count(name, "cc")>0) %>%
# ggplot() +
#   geom_point(aes(x = mean, y = title, color = name))

}

