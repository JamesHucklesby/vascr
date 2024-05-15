
# Graphics generation


#' Combine multiple vascr plots into a single panel
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
#' #p1 = growth.df %>% vascr_subset(unit = "Rb") %>% vascr_plot_line()
#' #p2 = growth.df %>% vascr_subset(unit = "Cm") %>% vascr_plot_line()
#' 
#' #vascr_make_panel(p1, p2)
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
  
  
  
  legendplot = plots[[legend_from_index]] 
  
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
