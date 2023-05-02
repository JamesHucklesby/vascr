
#' Detect the deviation between wells and the median well
#' 
#' This function detects the proportion deviation between the median of each sample and each well in that sample for each time point. This will return zero for the median wel at each time point, however which well is the median may change between time points.
#' 
#' This function is not as diagnostic or sensitive compared to vascr_detect_max_deviation but is usefull if you need to find out when and where a well differs from the remainder of the triplicate.
#'
#' @param data.df A vascr dataset to process
#' @param frequency The frequency to run the calculations on. Only one frequency should be selected, default is 4000.
#' @param unit The unit to run calculations on. Only one unit should be selected, and generally this should be a raw frequency. Default R.
#'
#' @return A vascr dataset containing the deviaiton at each time point
#' @export
#' 
#' @importFrom dplyr group_by mutate
#' @importFrom stats median
#' @importFrom magrittr "%>%"
#'
#' @keywords internal
#'
#' @examples
#' # example = vascr_summarise_deviation(growth.df)
#' 
#' 
#' 
vascr_summarise_deviation = function(data.df, frequency = NA, unit = NA, ...)
{
  cleandata.df = subset(data.df, !is.na(Value)) # Exclude wells where there is no data available (IE connection lost)
  
  unit = vascr_find_unit(data.df, unit)
  frequency = vascr_find_frequency(data.df, frequency)
  
  cleandata.df = vascr_subset(cleandata.df, unit = unit, frequency = frequency) # Run the diagnosis on only one frequency to save time, at R4000
  
  # This is the linchpin function for this family, so we run checks here
  if(vascr_detect_level(data) == "experiments" || vascr_detect_level(data)=="summary")
  {
    warning("This function only makes sense for data that is not summarised. Please input un-normalised data")
  }
  
  if(length(unique(cleandata.df$Unit))>1 || length(unique(cleandata.df$Frequency))>1)
  {
    warning("This funciton only works for a single unit or frequency. Please try this function again with only a single one of each of these variables.")
  }
  
  
  #Calculate the fractional difference between the sample mean and the value of the well in each experiment at each timepoint
  
  metadata =  cleandata.df %>%
    group_by(Experiment, Sample, Time) %>%
    mutate(Deviation = (abs(Value - median(Value)))/median(Value)) 
  
  
  return(metadata)
}

vascr_detect_deviation = function(...)
{
  vascr_summarise_deviation(...)
}



#' Automatically detect erronious wells in a vascr dataset
#' 
#' As with all high-throughput measurements, replicaes can behave badly. This dataset automatically detects these values.
#'
#' This function is sensitive to two factors, wells with large differences between replicates and sudden spikes in datasets caused by a transient loss of connection. Max_Deviation is calculated by determining the fractional difference between any well and the median well for that sample:experiment combination at each individual timepoint. This will identify wells that sit well away from the centre of the dataset, as median is not affected by large outliers. Secondly we select the largest of the values calculated for each time point and show this as the score. This makes the score highly sensitive to transient spikes in the dataset, that would be dulled by averaging the dataset as a whole.
#' 
#' This function can be applied to a whole dataset. Selecting smaller areas does not make the detection more sensitive, but can be used to exclude particular wells. Various units can be screened, though raw units are often more appropriate for diagnosing technical issues.
#' 
#' A dataframe is returned with a score for each well, fully labeled minus Time and Value as these are inappropriate for a summarised unit.
#' 
#' @param data.df A standard ECIS data frame
#' @param max_deviation Maximum deviation that is acceptable, lower is more stringent
#' @param frequency Frequency to run numbers on, default is 4000
#' @param unit Unit to use in detection, default is R
#'
#' @return  A tibble containing the offending wells, which experiment they are from and the score they were removed with
#' 
#' 
#' @keywords internal
#' 
#' @importFrom magrittr "%>%"
#' @importFrom dplyr group_by summarise arrange select distinct left_join ungroup
#'
#' @examples
#' # Return the results as a table
#' # vascr_detect_max_deviation(growth.df)
#' # Then return a graphical representaiton
#' #vascr_plot_deviation(growth.df)
vascr_detect_max_deviation = function(data.df, max_deviation = 0, frequency = 4000, unit = "R")
{
  
   data = data.df
  
    # First we use a related funciton to detect the deviation for each data point. Do not strip out any data at this point, as any high values need the whole well removed when this funciton is called
     deviation =  vascr_detect_deviation(data = data, frequency = frequency, unit = unit)
  
    # Then we ungroup, and find the maximum well for each well:experiment pair
      metadata = deviation%>%
      ungroup() %>%
      group_by(Well, Experiment) %>%
      summarise(Max_Deviation = max(Deviation)) %>%
      arrange(desc(Max_Deviation))
    
    # Then we generate a lookup for the remaining data, ignoring Time, Value and Deviation as these are no longer relevant
    mergedata = deviation %>% ungroup() %>% select(-Time, -Value, -Deviation) %>% distinct()
    metadata = left_join(metadata, mergedata, by = c("Well", "Experiment"))
    
    # Subset out any wells where the max deviation is greater than the max deviation specified
    metadata = subset(metadata, metadata$Max_Deviation >= max_deviation)
    
    return(metadata)
  
}


#' Various plots that show the deviation between the median well and various datapoints
#' 
#' This function by default outputs three sets of diagnostic plots that describe where, by how much and when a well has drifted from the median for that dataset. Individual visualisations from this set can also be requested using the visualisation paramater. The max_deviation and deviation paramaters can be used to annotate these plots, allowing acceptable variation.
#'
#' @param data A vascr dataset to show
#' @param max_deviation The maximum deviation of interest
#' @param deviation The maximum allowable deviation at any one time point. Defaults to the same as max_deviation.
#' @param priority The priority of vascr (or other) variables should be displayed in. See vascr_priority for details.
#' @param unit The unit you wish to run the analyasis on. A raw unit is usually best. Default is R.
#' @param frequency The frequency you want to run the analyasis on. Default is 4000.
#' @param visualisation The visualisation you want to focus in on. Options are "bar", "plate" or "line". The default is to tile all three.
#' @param title The title to place on the plot
#' @param ... Any other arguements to be passed on to either vascr_subset or vascr_polish_plot
#'
#' @return A ggplot object, or matrix of ggplot objects
#' @keywords internal
#' 
#' @importFrom ggplot2 ggplot aes_string geom_line geom_hline facet_wrap geom_bar xlab ylab theme element_text scale_x_discrete vars scale_fill_gradient2 ggplotGrob ggtitle
#' @importFrom stats reorder
#' @importFrom gridExtra grid.arrange
#' @importFrom grid unit.c
#' @importFrom ggpubr get_legend
#' @importFrom patchwork plot_layout
#'
#' @examples
#' #grid = vascr_plot_deviation(growth.df)
#' #vascr_plot_deviation(growth.df, visualisation = "bar")
#' #vascr_plot_deviation(growth.df, visualisation = "plate")
#' #vascr_plot_deviation(growth.df, visualisation = "line")
#' #vascr_plot_deviation(growth.df, max_deviation = 0.2)
#' 
#' data = growth.df %>% subset(unit = "R", frequency = 4000)
#' 
vascr_plot_deviation= function(data, max_deviation = 0, deviation =0 ,visualisation = NULL, title = "")
{
  
  
  
  # Generate the line visualisation ##########################################################
  
  
  if(visualisation == "line" || is.null(visualisation))
  {
    
    # Run the deviation calculation
    
    deviationdata = vascr_detect_deviation(data) %>% mutate(Sample = factor(Sample, unique(data$Sample)))
    
      grouping = interaction(deviationdata$Well, deviationdata$Sample)
      plot = ggplot(deviationdata, aes(x = Time, y = Deviation, group = grouping, color = Sample, fill = Sample)) + 
        geom_line() +
        ggnewscale::new_scale_color()+
        facet_wrap(vars(Experiment),scales = "free_x") +
        geom_hline(aes(yintercept = deviation, color = "Threshold deviation specified"))
        
      


    
      p0 = plot
    
    if(!is.null(visualisation))
    {
      return(p0)
    }
  }
  
  # Calculate the Max_Deviations for all wells
  scores = vascr_detect_max_deviation(data, max_deviation = 0) %>% 
    mutate(Sample = factor(Sample, unique(data$Sample)))
  
  if(visualisation == "bar" || is.null(visualisation))
  {
    

        x = reorder(scores$Well, -scores$Max_Deviation)
        
        plot = ggplot(scores, aes(x=x, y= Max_Deviation, fill = Sample, color = Sample, group = Well)) +
          geom_bar(stat="identity") + xlab("Well") +
          facet_wrap(vars(Experiment),scales = "free_x") + 
          ggnewscale::new_scale_color() +
          geom_hline(aes(yintercept = deviation, color = "Threshold deviation specified")) +
          labs(color = "", y = "Maximum deviation")
          
      
      plot = plot + theme(axis.text.x = element_text(angle = 90))
      
      plot
      
      p1 = plot
      
      if(!is.null(visualisation))
      {
      return(p1)
      }

  }
  
  
  if(visualisation == "plate" || is.null(visualisation))
  {
  
  scores = vascr_explode_wells(scores)
    
  plot = ggplot(scores, aes(col, row, fill= Max_Deviation)) + 
    geom_tile() +
    xlab("Plate Column") +
    ylab("Plate Row")+
    scale_x_discrete(position = "top") +
    facet_wrap(vars(Experiment),scales = "free_x")
  
  
  # If deviation is not set (i.e: 0), max out the deviation for the purposes of generating the plot so no red is displayed
  if(max_deviation==0)
  {
     max_deviation = max(scores$Max_Deviation)
  }
  
  plot =  plot + scale_fill_gradient2(low = "white", mid = "blue", midpoint = deviation, high = "red")
  
  p2 = plot
  
  
  if(!is.null(visualisation))
  {
  return(p2)
  }
  
  }
  
  if(is.null(p1) & is.null(p2) & is.null(p0))
  {
    stop("Invalid visualisation type selected")
  }
  
  else
  {
    
    p1 = p1 + labs(tag = "B")
    p0 = p0 + labs(tag = "C")
    p2 = p2 + labs(tag = "A")
    
    p2 = p2 + labs(fill = "Maximum Deviation")
    
    if(length(unique(data$Experiment)) == 1)
    {
    
    p1 = p1 + theme(strip.text.x = element_blank(), strip.background = element_blank())
    p0 = p0 + theme(strip.text.x = element_blank(), strip.background = element_blank())
    p2 = p2 + theme(strip.text.x = element_blank(), strip.background = element_blank())
    
    }
    
    extract_legend <- function(my_ggp) {
      step1 <- ggplot_gtable(ggplot_build(my_ggp))
      step2 <- which(sapply(step1$grobs, function(x) x$name) == "guide-box")
      step3 <- step1$grobs[[step2]]
      return(step3)
    }
    
  
    # legend = grid.arrange(extract_legend(p2), extract_legend(p1))
    # 
    # grid = ggarrange(p1, p0, ncol = 1, common.legend = TRUE, legend = "right", legend.grob = legend)
    # 
    # grid
    # 
    # grid2 = ggarrange(p2, grid, ncol = 1, heights = c(0.33, 0.66))
    # 
    # grid2
    
    grid2 = (p2 + p1 + p0 + get_legend(p2) + get_legend(p1) & theme(legend.position = "none")) + plot_layout(design = "
                                                                            AAAD
                                                                            BBBE
                                                                            CCCE")
    

    
    
    
    return(grid2)
  }
  
  
}

#' Exclude automatically detected wells that have a connection issue from the dataset
#'
#' @param data.df The dataset to parse
#' @param deviation The threshold stringency to use in detection. Default is 5, the range of 1-10 may be appropriate. Higher numbers are less stringent.
#' @param max_deviation The maximum deviation tollerable before a well is excluded.
#' @param frequency The frequency to use for detection, default is 4000 Hz
#' @param unit  The unit to run the detection on, default is R
#' @param verbose Prints which wells have been removed in the terminal. Should be used when first investigating data to allow for follow up plots with vascr_isolate_well to be conducted.
#'
#' @return A standard ECIS dataframe, minus the detected wells
#' 
#' @importFrom dplyr filter select
#' 
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_plot_deviation(growth.df, max_deviation = 0.3)
#' 
#' # datum = vascr_exclude_deviation(growth.df, max_deviation = 0.3)
#' 
#' # vascr_plot_deviation(datum)
#' 
#' 
vascr_exclude_deviation = function(data.df, deviation = 0.5, max_deviation = 0, frequency = 4000, unit = "R", verbose = TRUE)
{
  data = data.df
  
  # Calculate both sets of deviation data
  toremovedeviation = vascr_detect_deviation(data, deviation = deviation, frequency = frequency, unit = unit)
  toremovemaxdeviation = vascr_detect_max_deviation(data, max_deviation = max_deviation, frequency = frequency, unit = unit)
  
  
  # If nothing is bad, just return the data frame
  if((nrow(toremovedeviation) + nrow(toremovemaxdeviation)) ==0) 
  {
    print("No wells with an unacceptably high deviation detected")
    return(data.df)
  }
  
  # Then we go through and remove wells with a high max deviation
  toremovemaxdeviation$expwells = paste(toremovemaxdeviation$Experiment, ":", toremovemaxdeviation$Well, sep="")
  data$expwells = paste(data$Experiment, ":", data$Well, sep="")
  
  expwellstogo = toremovemaxdeviation$expwells
  
  if(verbose)
  {
    print("Wells removed due to high max deviation:")
    print(expwellstogo)
  }
  
  toreturn = filter(data,!expwells %in% expwellstogo)
  toreturn = select(toreturn, -c("expwells"))
  
  # Then we go through and remove wells at time points with a high deviation
  toremovedeviation$expwells = paste(toremovedeviation$Experiment, ":", toremovedeviation$Well, ":", toremovedeviation$Time, sep="")
  toreturn$expwells = paste(toreturn$Experiment, ":", toreturn$Well, ":", toreturn$Time, sep="")
  
  expwellstogo = toremovedeviation$expwells
  
  if(verbose)
  {
    print("Wells and time points removed due to high deviation at those specific points:")
    print(expwellstogo)
  }
  
  toreturn = filter(toreturn,!expwells %in% expwellstogo)
  toreturn = select(toreturn, -c("expwells"))
  
  return(toreturn)
  
  
}




