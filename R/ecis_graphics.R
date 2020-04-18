# Graphics generation


#' ECIS plot
#' 
#' The master function for generating ggplot2 objects from ECIS data. Incorporates all the summarising, testing and graphing operations into a single function.
#'
#' @param data A standard ECIS data frame to plot
#' @param unit Unit to plot
#' @param frequency The frequency of data to display. All modelled variables have a frequency of 0
#' @param replication How much of the replicaiton to display. Options are 'all', 'experiment', 'summary" or "plate"
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
#' @param alignkey Aligns key points (max, min ect). See ecis_align_key for details
#' @param continuouscontains Subset of samplecontains, only returns data where the continuous value contains this data
#' @param returndata Return the dataset, rather than the graph. Default FALSE, usefull for debugging
#' @param showpoints Show the time points on the graph
#'
#' @return A ggplot2 object
#' 
#' @export
#' 
#' @importFrom stats sd
#' @importFrom dplyr filter group_by summarise
#' @importFrom ggplot2 ggplot geom_line labs aes geom_bar position_dodge theme element_text geom_text geom_ribbon geom_point geom_errorbar
#'
#' @examples
#' growth.df$Instrument = "ECIS"
#' 
# ecis_plot(growth.df, 'Rb', replication = 'summary',
# error = 2, linesize = 1, errorsize = 1, alphavalue = .1, title = "Cars", xlab = "Hours")
# ecis_plot(growth.df, 'Rb', replication = 'wells',
#  error = 2, linesize = .1, errorsize = 1, alphavalue = .1, title = "Cars", xlab = "Hours")
#  ecis_plot(growth.df, 'Rb', replication = 'experiments',
#  error = 2, linesize = .1, errorsize = 1, alphavalue = .1, title = "Cars", ylab = "Rb"
#  , xlab = "Hours")
# ecis_plot(growth.df, 'R', 4000, 'summary', time = 75)
# ecis_plot(growth.df, "R", 4000, "summary", 50, confidence = 0.1, sortkeyincreasing = FALSE)
# 
# ecis_plot(growth.df, sortkeyincreasing = TRUE)
# 
# ecis_plot(growth.df, continuous = "cells", replication = "summary", time = 50)
#
# ecis_plot(growth.df, replication = "plate", time = 100)


ecis_plot = function(data, unit = "R", frequency = 4000, replication = "summary", time = Inf, samplecontains = "", experiment = "", error = Inf, linesize = 1, normtime = NULL, divide = FALSE,  errorsize = 1, alphavalue = 0.1, confidence = 1, xlab = "Time (hours)", ylab = "Value", title = "Title", stripidentical = TRUE, cols = NULL, verbose = TRUE, preprocessed = FALSE, continuous = NULL, alignkey = NULL, continuouscontains = NULL, returndata = FALSE, sortkeyincreasing = TRUE, showpoints = FALSE) 
  {
  

# Subset data -------------------------------------------------------------
  data = ecis_prep_graphdata(data, unit, frequency, time, samplecontains, experiment, error, alignkey, normtime, divide, preprocessed, continuouscontains, stripidentical)
  

# Create labels -----------------------------------------------------------
  
  # Use the default name of the unit on the Y axis
  if (ylab == "Value")
  {
    ylab = ecis_titles(unit)
  }
  
  # Check frequency is a real value
  frequency = ecis_find_frequency(data, frequency)
  
  # Generate a title, containing the Hz if the unit is not modeled
  if (title == "Title")
  {
    if(ecis_is_modeled_unit(unit))
    {
      title = unit
    }
    else
    {
    title = paste(unit, " (",frequency," Hz)", sep = "")
    }
  }



# Start calling subservient plotting functions ----------------------------

  
  # Deal with if a continuous variable has been selected
  if(!is.null(continuous))
  {
    plot = ecis_plot_continuous(data = data, unit = unit, frequency = frequency, replication = replication, time = time, error = error,alphavalue  = alphavalue, xlab = xlab, ylab = ylab, title = title, cols = cols, continuous = continuous)
    
    return(ecis_polish_plot(plot))
  }
  
  # Deal with if a platemap has been requested
  
  if(replication == "plate")
  {
    if(length(unique(data$Time))>1)
    {
    return(ecis_polish_plot(ecis_plot_plate(data, unit, frequency, verbose)))
    }
    else
    {
    return(ecis_plot_heatmap(data, time, unit, frequency, title))
    }
  }
  
    
  # First we deal with if the graph requested is a line graph
    
    if (length(unique(data$Time))>1) { # Check if we are plotting a single, or multiple, time points
        
      {
        return(ecis_plot_line(data, replication, error, title, xlab, ylab, linesize, alphavalue))
      }
        
     # Then we deal with if a single time point has been requested
        
    } else {
      ecis_plot_column(data, replication, error = Inf, title, xlab, ylab, time, unit, frequency, confidence)
    }
}

# Multiplot with common key -------------------------------------------------------

#' Internal funciton for aligning grids
#'
#' @param ...  GGPlot objects to combine
#' @param ncol Number of columns
#' @param nrow Number of rows
#' @param position Where to place each graph. Unsure about this one.
#'
#' @return A multi-plot graph object
#' 
#' @importFrom ggplot2 ggplotGrob 
#' @importFrom graphics legend
#' @importFrom grid grid.draw unit
#' @importFrom gridExtra arrangeGrob
#'
#' @examples
#' 
#' #graph1 = ecis_plot(growth.df, 'Rb', 0, 'all')
#' #graph2 = ecis_plot(growth.df, 'Rb', 0, 'experiment')
#' #graph3 = ecis_plot(growth.df, 'Rb', 0, 'summary')
#' 
#' #grid_arrange_shared_legend(graph1, graph2, graph3, ncol = 1, nrow = 3)
#' 
grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, position = c("bottom", 
    "right")) {
    
    requireNamespace("gridExtra")
    requireNamespace("grid")
    
    plots <- list(...)
    position <- match.arg(position)
    g <- ggplot2::ggplotGrob(plots[[1]] + ggplot2::theme(legend.position = position))$grobs
    legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
    lheight <- sum(legend$height)
    lwidth <- sum(legend$width)
    gl <- lapply(plots, function(x) x + ggplot2::theme(legend.position = "none"))
    gl <- c(gl, ncol = ncol, nrow = nrow)
    
    combined <- switch(position, bottom = gridExtra::arrangeGrob(do.call(gridExtra::arrangeGrob, 
        gl), legend, ncol = 1, heights = grid::unit.c(grid::unit(1, "npc") - lheight, lheight)), 
        right = gridExtra::arrangeGrob(do.call(gridExtra::arrangeGrob, gl), legend, ncol = 2, 
            widths = grid::unit.c(grid::unit(1, "npc") - lwidth, lwidth)))
    
    # grid.newpage()
    grid::grid.draw(combined)
    
    # return gtable invisibly
    invisible(combined)
    
}

#' Plot graphs accross a standard ECIS spectra
#'
#' @param data A standard ECIS data frame 
#' @param variable Variable to plot. Can't be a modeled variable (use ecis_plot_model instead)
#' @param ... Other arguements may be included that will be passed through to ecis_plot
#'
#' @return A matrix of ggplot2 objects
#' @export
#'
#' @examples
#' 
#' ecis_plot_spectra(growth.df, 'R', replication = "summary")
#' 
ecis_plot_spectra = function(data, variable, ...) {
    
    data = subset(data, Unit == variable)
    
    expectedfrequencies = c(250,500,1000,2000,4000,8000,16000,32000,64000)
    
    if(!setequal(expectedfrequencies, unique(data$Frequency)))
    {
      warning("Frequencies do not match the standard set and therefore some graphs may not be shown")
    }
    
    p1 = ecis_plot(data, variable, 250, title = "250 Hz", ...)
    p2 = ecis_plot(data, variable, 500,title = "500 Hz", ...)
    p3 = ecis_plot(data, variable, 1000,title = "1,000 Hz", ...)
    p4 = ecis_plot(data, variable, 2000,title = "2,000 Hz", ...)
    p5 = ecis_plot(data, variable, 4000,title = "4,000 Hz", ...)
    p6 = ecis_plot(data, variable, 8000,title = "8,000 Hz", ...)
    p7 = ecis_plot(data, variable, 16000,title = "16,000 Hz", ...)
    p8 = ecis_plot(data, variable, 32000,title = "32,000 Hz", ...)
    p9 = ecis_plot(data, variable, 64000,title = "64,000 Hz", ...)
    
    return(grid_arrange_shared_legend(p1, p2, p3, p4, p5, p6, p7, p8, p9, ncol = 3, nrow = 3))
    
}

#' Plot all values generated by the ECIS model
#' 
#' This is a pre-generated piece of code that automaticaly plots all the variables generated by the ECIS model against time. Resistance at 4000 Hz is also included as a sensible sanity check of the model. 
#'
#' @param alldata.df An ECIS data frame
#' @param ... Any other arguements from ecis_plot that you might want passed through to all of the graphs
#'
#' @return A matrix containing graphs of all the variables generated by the ECIS model.
#' @export
#'
#' @examples
#' 
#' ecis_plot_model(growth.df, replication = "wells")
#' 
ecis_plot_model <- function(alldata.df, ...) {
    
    m1 = ecis_plot(alldata.df, "R", 4000, title = "R (4000 Hz)", ...)
    m2 = ecis_plot(alldata.df, "Rb", title = "Rb", ...)
    m3 = ecis_plot(alldata.df, "Cm", title = "Cm", ...)
    m4 = ecis_plot(alldata.df, "Alpha",title = "Alpha", ...)
    
    return(grid_arrange_shared_legend(m1, m2, m3, m4, ncol = 2, nrow = 2))
    
}


#' Post-processing on ECIS plots to make them a bit more pretty
#'
#' @param plot The plot to format
#'
#' @importFrom ggplot2 theme_bw 
#' @importFrom ggpubr rotate_x_text
#'
#' @return A standardised ggplot2 object
#' @export
#'
#' @examples
#' # Automatically applied to ggplot, should not be required externaly
#' 
#' plot = ecis_plot(growth.df)
#' ecis_polish_plot(plot)
#' ecis_polish_plot(plot, rotate_x = FALSE)
#' 
ecis_polish_plot = function(plot, rotate_x_angle = 45, logscale = "")
{
  
  if(str_detect(logscale, "x"))
  {
    plot = plot +scale_x_log10()
  }
  
  if(str_detect(logscale, "y"))
  {
    plot = plot +scale_y_log10()
  }
  
  if(!missing(rotate_x))
  {
  plot = plot + rotate_x_text(angle = 45)
  }

  return(plot + theme_bw())
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
#' #' ecis_animatefrequency(growth.df, 'R', 3)
#' #' 
#' ecis_animatefrequency = function(alldata.df, unittoplot, frames) {
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
#' @param title The title of the plot
#' @param unit The unit to plot. Default is R
#' @param frequency The frequency to plot. Default is 4000
#' @param ... Other conditions to pass on to the ecis_plot command that generates the graph
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
#' ecis_plot_isolate(growth.df, well = "A3")
#' 
ecis_plot_isolate= function(data.df, well, title = "Well isolation plot", unit = "R", frequency = 4000, ...)
{
  
  if(title=="Title")
  {
    title = "Well Isolation Plot"
  }
  
  well = ecis_standardise_wells(well)
  data.df$Well = ecis_standardise_wells(data.df$Well)
  cleandata.df = ecis_subset(data.df, unit = unit, frequency = frequency)
  
  badwell = ecis_subset(cleandata.df, well = well)
  badwell$Sample = paste(badwell$Well, badwell$Sample,badwell$Experiment)
  
  medianwell = cleandata.df %>%
    group_by(Time) %>%
    mutate(Value = median(Value), Sample = "Experimental Mean Well", Well = "Z00") %>%
    ungroup
  
  toplot.df = rbind(badwell, medianwell)
  
  plot = ecis_plot(toplot.df, unit, frequency, "wells", title = title, preprocessed = TRUE, ...)
  
  return (plot)
}


#' Plot the wells of a 96 well plate
#'
#' @param data.df A standard ECIS dataframe. Ideally this will contain only one experiment, but multiple experiments are supported.
#' @param unit The unit to plot. Default is R
#' @param frequency The frequency to plot. Default is 4000
#' @param verbose Prints out the scores for each well. On by default.
#'
#' @importFrom ggplot2 aes geom_line facet_grid labs
#'
#' @return A GGplot2 matrix
#' @export 
#'
#' @examples
#' ecis_plot_plate(growth.df, unit = "Rb")
#' 
ecis_plot_plate = function(data.df, unit = "R", frequency = 4000, verbose = TRUE)
{
  # Cut the data down to what is needed
  data = ecis_subset(data.df, unit = unit, frequency = frequency)
  
  # Grab the column and row components from each well to allow plate separation
  data$col = substr(data$Well,1,1)
  data$row = substr(data$Well,2,3)
  
  plot =  ggplot(data=data, aes(x=Time, y = Value, colour = Sample, linetype = Experiment)) + geom_line() + facet_grid(col~row) + labs(x = "Time(hours)", y=ecis_titles(unit,frequency))
  
  print(ecis_detect_badwells(data.df, threshold = 0))
  
  return (plot)
}



#' Factorise and sort a the column of a data frame for plotting
#'
#' @param data A vector to sort and factorise. This uses stringr's numeric =TRUE to line up all numbers in order correctly
#' @param sortkeyincreasing Should samples be returned increasing or decreasing. Default increasing.
#' 
#' @importFrom stringr str_sort
#'
#' @returnA A factorised vector that can be saved directly back to a data frame
#' 
#' @export
#'
#' @examples
ecis_factorise_and_sort = function(data, sortkeyincreasing = TRUE)
{
  allsamples = unique(data)
  allsamples = str_sort(allsamples, numeric = TRUE, decreasing = !sortkeyincreasing)
  data = factor(data, allsamples)
  return(data)
}
