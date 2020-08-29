# Graphics generation


#' ECIS plot
#' 
#' The master function for generating ggplot2 objects from ECIS data. Incorporates all the summarising, testing and graphing operations into a single function.
#'
#' @param data A standard ECIS data frame to plot
#' @param unit Unit to plot
#' @param frequency The frequency of data to display. All modelled variables have a frequency of 0
#' @param level How much of the replicaiton to display. Options are 'all', 'experiment', 'summary" or "plate"
#' @param time The time to subset if a slice is required. If set to Inf all data will be displayed
#' @param samplecontains Optional, only samples that contain this string will be plotted. Standard search and wildcard
#' @param experiment Optional, allows you to limit the experiment plotted. Experiment names should be separated with |
#' searches apply.
#' @param error Display error bars. 0 displays no error bars, 1 displays them all. Higher numbers will reduce the frequency of error bars plotted.
#' @param linesize Width of mean lines shown on graphs
#' @param normtime The time to normalise the data to
#' @param divide Selector for if normalisation should be done by division or subtraction. Default is subtraction (FALSE)
#' @param errorsize Width of error bars shown on graphs
#' @param alphavalue Alpha value of area enclosed by error bars. May be lowered for buisy graphs
#' @param confidence The confidence to use when generating basic significance plots
#' @param xlab X axis value
#' @param ylab Y axis value
#' @param title The title of the ggplot
#' @param stripidentical Remove cols from the data where all data points are identical. Default is true
#' @param cols The columns of data to display in the names of plots. Allows for shortening of names where the automatic stripidentical fails
#' @param verbose Outputs where in the funtion ploting is happening. Usefull for debugging as needed
#' @param preprocessed Selects if the data is preprocessed. Will not run explosion and implosion if that is the case
#' @param continuous Selects a continuous point for plotting
#' @param alignkey Aligns key points (max, min ect). See vascr_align_key for details
#' @param continuouscontains Subset of samplecontains, only returns data where the continuous value contains this data
#' @param returndata Return the dataset, rather than the graph. Default FALSE, usefull for debugging
#' @param showpoints Show the time points on the graph
#' @param sortkeyincreasing Sort the data specified in an increasing way.
#' @param singleplot Merge all the data specified into a single plot.
#' @param priority The priority of variables to plot. Will be automatically filled if not available.
#' @param errortype Type of error to plot. Can be SEM or SD.
#' @param visualisation How to visualise the data
#' @param threshold The threshold value to place on the graph
#'
#' @return A ggplot2 object
#' 
#' @export
#' @examples
#' 
#' 
#' 
#' #vascr_plot(growth.df, 'Rb', level = 'summary',
#' #error = 2, linesize = 1, errorsize = 1, alphavalue = .1, title = "Cars", xlab = "Hours")
#' #vascr_plot(growth.df, 'Rb', level = 'wells',
#' #  error = 2, linesize = .1, errorsize = 1, alphavalue = .1, title = "Cars", xlab = "Hours")
#' # vascr_plot(growth.df, 'Rb', level = 'experiments',
#'  #error = 2, linesize = .1, errorsize = 1, alphavalue = .1, title = "Cars", ylab = "Rb"
#'  #, xlab = "Hours")
#' #vascr_plot(growth.df, 'R', 4000, 'summary', time = 75)
#' #vascr_plot(growth.df, "R", 4000, "summary", 50, confidence = 0.1, sortkeyincreasing = FALSE)
#' 
#' #vascr_plot(growth.df, sortkeyincreasing = TRUE)
#' 
#' #vascr_plot(growth.df, continuous = "cells", level = "summary", time = 50)
#'
#' #vascr_plot(growth.df, level = "plate", time = 100)
#' 
#' #vascr_plot(growth.df, time = list(c(100,190)), 
#' #unit = list("Rb", "Cm", "Alpha", "R"),  frequency = 4000)
#'
#' #vascr_plot(growth.df, time = 100, unit = "Cm",  frequency = 4000, level = "summary")
#' 
#' #vascr_plot(growth.df, level = "deviation")
#' 
#' #vascr_plot(growth.df, visualisation = "line", level = "summary")
#' 
#' 
#' #vascr_plot(growth.df)
#' 


vascr_plot = function(data, unit = "R", frequency = 4000, level = "summary", time = Inf, samplecontains = "", experiment = NULL, error = Inf, linesize = 1, normtime = NULL, divide = FALSE,  errorsize = 1, alphavalue = 0.1, confidence = 1, xlab = "Time (hours)", ylab = "Value", title = "Title", stripidentical = TRUE, cols = NULL, verbose = FALSE, preprocessed = FALSE, continuous = NULL, alignkey = NULL, continuouscontains = NULL, returndata = FALSE, sortkeyincreasing = TRUE, showpoints = FALSE, singleplot = FALSE, priority = NULL, errortype = "sem", visualisation = NULL, threshold = 0) 
  {
  

   # Use recursion to plot anything that is a list

  if(any(is.list(unit), is.list(frequency), is.list(time)) & !singleplot)
  {
    singleplot = TRUE
    allarguements = as.list(environment())
    multiplot = do.call(vascr_multiplot, allarguements)
    return(multiplot)
  }
  
  if(level == "deviation")
  {
    plot = do.call("vascr_plot_deviation", as.list(environment()))
    return(plot)
  }
  
  # Start calling subservient plotting functions ----------------------------
  if(is.null(visualisation))
  {
    if(level == "plate")
    {
      plot = do.call("vascr_plot_plate", as.list(environment()))
    }
    
    else if(level == "structure")
    {
      plot = do.call("vascr_plot_structure", as.list(environment()))
    }
    
    else if(length(time)>0)
    {
      plot = do.call("vascr_plot_line", as.list(environment()))
      return(plot)
    }
    else
    {
    plot = do.call("vascr_plot_bar", as.list(environment()))
    return(plot)
    }
  }
  
  # Deal with level is a special way

  if(level == "anova")
  {
    plot = do.call("vascr_plot_anova", as.list(environment()))
    return(plot)
  }
  
  if(level == "structure")
  {
    plot = do.call("vascr_plot_structure", as.list(environment()))
    return(plot)
  }
  
  if(isTRUE(visualisation == "line"))
  {
    plot = do.call("vascr_plot_line", as.list(environment()))
    return(plot)
  }
  
  if(isTRUE(visualisation == "bar"))
  {
      plot = do.call("vascr_plot_bar", as.list(environment()))
      return(plot)
  }

  if(isTRUE(visualisation == "plate"))
  {
    plot = do.call("vascr_plot_plate", as.list(environment()))
    return(plot)
  }
  
  
}

#' Plot multiple ggplots
#' 
#' This function splits out multiple ggplots into a grid when more than one is requested.
#'
#' @param data A vascr dataset
#' @param unit The unit to plot. "raw" will plot all raw units and "modeled" will plot all modeled units.
#' @param frequency The frequency to plot
#' @param time The time to plot. Multiple time plots can be plotted with list(1,2) and multiple ranges can be plotted with list(c(1,2), c(3,4))
#' @param ... Other conditions to be passed into data conditioning and graph preparing steps
#'
#' @return An array of requested ggplots
#' @export
#'
#' @examples
#' #vascr_multiplot(data = growth.df, frequency = 4000, time = list(50, 100))
#' 
#' #vascr_multiplot(data = growth.df, frequency = 4000, time = list(c(50, 100),100), level = "wells")
#' 
#' #vascr_multiplot(growth.df, frequency = c(2000,4000), unit = "R")
#' 
#' 
vascr_multiplot = function(data, unit = "all", frequency = 0, time = Inf, ...)
{

  units =  vascr_realise_units(data, unit) 
  frequencies = vascr_realise_frequencies(data, frequency)
  
  plots = list()
  n = 1

 for(tim in time)
 {
   tim = unlist(tim)
  for(uni in units)
  {
    uni = unlist(uni)
    if(vascr_is_modeled_unit(uni))
    {
      p = vascr_plot(data, unit = uni, time = tim, ...)
      plots[[n]]= p
      n=n+1
    }else
    {
    for(fre in frequencies)
    {
      fre = unlist(fre)
      if(as.numeric(fre)>0)
      {

        p = vascr_plot(data, unit = uni, frequency = as.numeric(fre), time = tim, ...)
        plots[[n]] = p
        n=n+1
      }
      
    }
    }
  }
 }
  panel = do.call(vascr_make_panel, plots)
  return(panel)
}


#' Combine mulitple VASCR plots into a single pannel
#' 
#'
#' @param ... The plots that need to be combined
#' @param plots A vector of plots, if not available in ... format
#' @param legend_from_index Which plot in the list to clone the legend from
#' 
#' @importFrom gridExtra arrangeGrob grid.arrange
#' @importFrom ggplot2 ggplotGrob theme
#' @importFrom grid unit.c unit
#'
#' @return A panel with multiple plots on it
#' @export
#'
#' @examples
#' #plots = list()
# #plots[[1]] = vascr_plot(growth.df, "Rb")
# #plots[[2]] = vascr_plot(growth.df, "Cm")
# #vascr_make_panel(plots = plots)
# 
# #vascr_make_panel(vascr_plot(growth.df, unit = "Cm"), vascr_plot(growth.df, unit = "Rb"))
# 
# #vascr_multiplot(data = growth.df, frequency = 4000, time = c(100, 50))
# 
# #vascr_multiplot(data = growth.df, frequency = 4000, time = list(c(50, 100), 10))
#' 
vascr_make_panel <- function(..., plots = NULL, legend_from_index = 1) {
  
  if(!is.null(plots))
  {
    plots = plots
  }
  else
  {
    plots = list(...)
  }
  
  
  g <- ggplotGrob(plots[[legend_from_index]] + theme(legend.position="bottom"))$grobs
  
  
  if(any(sapply(g, function(x) x$name) == "guide-box"))
  {
    
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  
  final = grid.arrange(
    
    do.call(arrangeGrob, lapply(plots, function(x)
      
      x + theme(legend.position="none"))),
    
    legend,
    
    ncol = 1,
    
    heights = unit.c(unit(1, "npc") - lheight, lheight))
  
  }
  else
  {
    legend = NULL
   grid.arrange(
      
      do.call(arrangeGrob, lapply(plots, function(x)
        
        x + theme(legend.position="none"))),
      
      ncol = 1)
  }
  
}
  

#' Post-processing on ECIS plots to make them a bit more pretty
#'
#' @param plot The plot to format
#' @param rotate_x_angle Angle by which X axis values should be rotated
#' @param logscale Should X, Y or XY axes be log10 transformed
#' @param title Title of the graph
#'
#' @importFrom ggplot2 theme_bw ggtitle
#' @importFrom ggpubr rotate_x_text
#'
#' @return A standardised ggplot2 object
#' @export
#'
#' @importFrom ggplot2 scale_x_log10 scale_y_log10
#'
#' @examples
#' # Automatically applied to ggplot, should not be required externaly
#' 
#' #plot = vascr_plot(growth.df)
#' #vascr_polish_plot(plot)
#' #vascr_polish_plot(plot, rotate_x_angle = FALSE)
#' 
vascr_polish_plot = function(plot, rotate_x_angle = 45, logscale = "", title = NULL)
{
  
  # # Create labels -----------------------------------------------------------
  # 
  # # Use the default name of the unit on the Y axis
  # if (ylab == "Value")
  # {
  #   ylab = vascr_titles(unit)
  # }
  # 
  # # Check frequency is a real value
  # frequency = vascr_find_frequency(data, frequency)
  # 
  # # Generate a title, containing the Hz if the unit is not modeled
  # if (title == "Title")
  # {
  #   if(vascr_is_modeled_unit(unit))
  #   {
  #     title = unit
  #   }
  #   else
  #   {
  #     title = paste(unit, " (",frequency," Hz)", sep = "")
  #   }
  # }
  
  
  if(!(is.null(title)))
  {
    plot = plot + ggtitle(title)
  }
  
  if(str_detect(logscale, "x"))
  {
    plot = plot +scale_x_log10()
  }
  
  if(str_detect(logscale, "y"))
  {
    plot = plot +scale_y_log10()
  }
  
  if(!missing(rotate_x_angle))
  {
  plot = plot + theme(axis.text.x = element_text(angle = rotate_x_angle))
  }

  return(plot)
}


#' Animation removed due to compatabilty issues with CRAN. To be re-introduced later.
#' 
#' 
#' # Animate -----------------------------------------------------------------
#' #' Animate frequency
#' #' 
#' #' Generate a gganimate graphic of frequency vs resistance. Each frame of the video represents a different time point
#' #'
#' #' @param alldata.df An ECIS dataframe
#' #' @param unittoplot Which ECIS unit is to be plotted. Can't plot modeled variables as these are derrivative from ECIS models.
#' #' @param frames Number of frames to render. More frames gives a smoother graphic, but is more computationaly expensive to generate.
#' #'
#' #' @return A gganimate gif. Future itteration may include the ability to return the un-rendered object.
#' #' 
#' #' @importFrom ggplot2 ggplot geom_line aes labs scale_x_log10 scale_y_log10 geom_errorbar position_stack
#' #' @importFrom gganimate transition_time animate
#' #' @importFrom dplyr n
#' #' @importFrom stats sd
#' #' 
#' #' @export
#' #'
#' #' @examples
#' #' #vascr_animatefrequency(growth.df, 'R', 3)
#' #' 
#' vascr_animatefrequency = function(alldata.df, unittoplot, frames) {
#'     
#'     alldatasum.df = summarise(group_by(alldata.df, Sample, Time, Unit, Frequency), sd = sd(Value), 
#'         n = n(), Value = mean(Value))
#'     
#'     toplot.df = alldatasum.df
#'     toplot.df = subset(toplot.df, Unit == unittoplot)
#'     toplot.df$Frequency = as.numeric(toplot.df$Frequency)
#'     
#'     toplot2.df = toplot.df
#'     
#'     p = ggplot2::ggplot(toplot2.df, ggplot2::aes(Frequency, Value, colour = Sample)) + ggplot2::geom_line(show.legend = TRUE) + 
#'         ggplot2::labs(title = "Days: {round(frame_time,1)}", x = "Frequency (Hz)", y = "Value (ohms)") + 
#'         ggplot2::scale_x_log10() + ggplot2::scale_y_log10() + ggplot2::geom_errorbar(ggplot2::aes(ymin = Value - 
#'         sd/sqrt(n), ymax = Value + sd/sqrt(n)), width = 0.1) + gganimate::transition_time(Time)
#'     
#'     gganimate::animate(p, nframes = frames)
#' }

#' Graph a single well that is misbehaving
#'
#' @param data.df The dataset the well is in
#' @param well The well to be isolated
#' @param ... Other conditions to pass on to the vascr_plot command that generates the graph
#' 
#' @importFrom magrittr "%>%"
#' @importFrom dplyr group_by mutate ungroup
#' 
#'
#' @return A ggplot graph showing the isoated well and the experimental median well
#' @export 
#'
#' @examples
#' 
#' #datum = vascr_plot_isolate(growth.df, well = "A3", unit = "R", frequency = 4000,
#' # error = Inf, priority = NULL)
#' 
#' #vascr_plot_line(datum, preprocessed = TRUE, priority = c("Time", "Sample"))
#' 
vascr_plot_isolate= function(data.df, well, ...)
{
  data = data.df
  
  # Run the preparation command for a standard well
  dots = list(...)
  data = do.call_relevant("vascr_prep_graphdata", data, dots)
  
  if(length(unique(data$Frequency))>1)
  {
    warning("More than 1 frequency detected, use with care")
  }
  
  if(unique(data$Unit)>1)
  {
    warning("More than 1 unit detected, use with care")
  }
  
  # Standardise all wells
  well = vascr_standardise_wells(well)
  data$Well = vascr_standardise_wells(data$Well)

  # Generate a data frame 
  quality = vascr_subset(data, well = well)
  quality$Sample = paste(quality$Well, quality$Sample,quality$Experiment)
  
  medianwell = data %>%
    group_by(Time) %>%
    mutate(Value = median(Value), Sample = "Experimental Mean Well", Well = "Z00") %>%
    ungroup
  
  toplot.df = rbind(quality, medianwell)
  
  return(toplot.df)
  
  plot = vascr_plot_line(toplot.df, unit, frequency, "wells", title = title, ...)
  
  return (plot)
}


#' Plot the wells of a 96 well plate
#'
#' @param data.df A standard ECIS dataframe. Ideally this will contain only one experiment, but multiple experiments are supported.
#' @param unit The unit to plot. Default is R
#' @param frequency The frequency to plot. Default is 4000
#' @param ... Values to be passed onto prep_graphdata and polish_plot
#'
#' @importFrom ggplot2 aes geom_line facet_grid labs
#'
#' @return A GGplot2 matrix
#' @export 
#'
#' @examples
#' #vascr_plot_matrix(growth.df, unit = "Rb")
#' 
vascr_plot_matrix = function(data.df, unit = "R", frequency = 4000, ...)
{
  # Gather graph data based on the ...
  dots = as.list(environment())
  data = do.call_relevant("vascr_prep_graphdata", data.df, dots)
  
  # Grab the column and row components from each well to allow plate separation
  data$col = substr(data$Well,1,1)
  data$row = substr(data$Well,2,3)
  
  plot =  ggplot(data=data, aes(x=Time, y = Value, colour = Sample, linetype = Experiment)) + geom_line() + facet_grid(col~row) + labs(x = "Time(hours)", y=vascr_titles(unit,frequency))
  
  return (plot)
}



#' Factorise and sort a the column of a data frame for plotting
#'
#' @param data A vector to sort and factorise. This uses stringr's numeric =TRUE to line up all numbers in order correctly
#' @param sortkeyincreasing Should samples be returned increasing or decreasing. Default increasing.
#' 
#' @importFrom stringr str_sort str_replace
#'
#' @return A factorised vector that can be saved directly back to a data frame
#' 
#' @examples
#' vascr_factorise_and_sort(growth.df$Sample)
#' 
vascr_factorise_and_sort = function(data, sortkeyincreasing = TRUE)
{
  data  = str_replace(data, "_", " ")
  allsamples = unique(data)
  allsamples = str_sort(allsamples, numeric = TRUE, decreasing = !sortkeyincreasing)
  data = factor(data, allsamples)
  return(data)
}




#' Return a blank white box
#'
#' @return A blank ggplot2 object
#' 
#' @importFrom ggplot2 ggplot theme_bw theme element_blank
#'
#' @examples
#' vascr_plot_blank()
vascr_plot_blank = function()
{
  plot = ggplot()+ theme_bw() +   theme(
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank())
    
    return(plot)
}
