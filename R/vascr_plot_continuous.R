#' Plot a continuous ECIS variable
#'
#' @param data A standard ECIS dataset
#' @param cols The column names to display
#' @param priority Priority of variables to plot
#' @param level Level of data replication to plot
#' @param error Type of error to plot
#' @param ... Variables to be passed to vascr_prep_graphdata and vascr_polish_plot
#' 
#' @importFrom ggplot2 aes labs geom_point geom_line geom_errorbar geom_ribbon
#'
#' @return a ggplot 2 object
#' @export
#'
#' @examples
#'
#' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary")
#'
#' 
#' # vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "wells", 
#' #time = 100, error = Inf, priority = c("cells", "Experiment"))
#' # vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "experiments",
#' # time = 100, priority = c("cells", "Experiment"), error = 1)
#' # vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "summary",
#' # time = 100, continuous = "cells", error = Inf, priority = c("cells", "Experiment"))
#'
#'
#'#data = growth.df
#'
#' 
vascr_plot_continuous = function(data, cols, priority, level, error, ...)
{
  
  # Gather graph data based on the ...
  dots = list(...)
  
  dots[["priority"]] = priority
  dots[["level"]] = level
  dots[["error"]] = error
  
  data = do.call_relevant("vascr_prep_graphdata", data, dots)
  
  if(is.null(xlab))
  {
    xlab = continuous
  }
  
  # Fix that the first variable must be numeric
  
  data[,priority[[1]]] = as.numeric(unlist(data[,priority[[1]]]))
  
  # Plot out individual wells
  
  if(level == "wells")
  {
    
    plot = ggplot(data, aes_string(priority[[1]], "Value")) +
      geom_point(aes_string(color = priority[[2]]))
    
    plot = do.call_relevant("vascr_polish_plot", plot, dots)
    
    return(plot)
    
  }
  
  
  # Plot out experimetal wells
  
  if (level == "experiments")
  {
    
    plot = ggplot(data, aes_string(x = priority[[1]], y = "Value", ymax = "ymax", ymin = "ymin", fill = priority[[2]], color = priority[[2]])) +
      geom_line()
    
  }
  
  ### Now make the summary graphs
  if (level == "summary")
  {
    plot = ggplot(data, aes_string(x = priority[[1]], y = "Value", ymax = "ymax", ymin = "ymin")) +
      geom_line()
  }
  
  if (is.infinite(error))
  {
    plot = plot + geom_ribbon(alpha = 0.1) 
  } else if (error>0)
  {
    plot = plot+ geom_errorbar()
  }
  
  return(plot)
  
}