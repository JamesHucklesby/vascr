
# Graphics generation

#' # Plot multiple ggplots
#' 
#' # This function splits out multiple ggplots into a grid when more than one is requested.
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


#' Combine multiple VASCR plots into a single panel
#' 
#'
#' @param ... The plots that need to be combined
#' @param plots A vector of plots, if not available in ... format
#' @param legend_from_index Which plot in the list to clone the legend from
#' @param ncols Number of colums
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
vascr_make_panel <- function(..., plots = NULL, legend_from_index = 1, ncols = 1) {
  
  if(!is.null(plots))
  {
    plots = plots
  }
  else
  {
    plots = list(...)
  }
  
  
  
  legendplot = plots[[legend_from_index]] +
    theme(legend.spacing =  unit(10, "cm"), legend.position="bottom",
          legend.title = element_text(face="bold"),
          ) 
  
  legendplot
  
  g <- ggplotGrob(legendplot)$grobs
  
  
  if(any(sapply(g, function(x) x$name) == "guide-box"))
  {
    
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  
  final = grid.arrange(
    
    do.call(arrangeGrob, lapply(plots, function(x)
      
      x + theme(legend.position="none"))),
    
    legend,
    
    ncol = ncols,
    
    heights = unit.c(unit(1, "npc") - lheight, lheight))
  
  }
  else
  {
    legend = NULL
   grid.arrange(
      
      do.call(arrangeGrob, lapply(plots, function(x)
        
        x + theme(legend.position="none"))),
      
      ncol = ncols)
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
#' @return A standardized ggplot2 object
#' 
#' @keywords internal
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


#' Graph a single well that is misbehaving
#'
#' @param data.df The dataset the well is in
#' @param well The well to be isolated
#' @param ... Other conditions to pass on to the vascr_plot command that generates the graph
#' 
#' @importFrom magrittr "%>%"
#' @importFrom dplyr group_by mutate ungroup
#' 
#' @keywords internal
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
#' @importFrom ggplot2 aes geom_line facet_grid labs scale_y_continuous
#'
#' @return A GGplot2 matrix
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_plot_matrix(growth.df, unit = "Rb")
#' 
vascr_plot_matrix = function(data.df)
{

  well_exploded = vascr_explode_wells(data.df)
  
  well_exploded$row <- factor(well_exploded$row, levels=sort(levels(well_exploded$row)))
  
  plot =  ggplot(data=well_exploded, aes(x=Time, y = Value, colour = Sample, linetype = Experiment)) + geom_line() + facet_grid(row~col, switch = "y") + labs(x = "Time(hours)", y = "Unit") + scale_y_continuous(position = "right")
  
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
#' @keywords internal
#' 
#' @examples
#' # vascr_factorise_and_sort(growth.df$Sample)
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
#' @keywords internal
#'
#' @examples
#' # vascr_plot_blank()
vascr_plot_blank = function()
{
  plot = ggplot()+ theme_bw() +   theme(
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank())
    
    return(plot)
}
