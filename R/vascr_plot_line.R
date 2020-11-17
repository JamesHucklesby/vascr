#' Plot a line graph from a vascr dataset
#'
#' @param data.df Vascr dataset to plot
#' @param priority Priority list of variables to plot
#' @param error Error to plot
#' @param alpha Alpha value of the line plotted
#' @param ... Values to be passed onto prep_graphdata and polish_plot
#'
#' @return A ggplot2 object of the graph created
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary", error = Inf)
#' 
#' 
#' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "experiments", title = "AAA")
#' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "wells", title = "AAA")
#' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "deviation", title = "AAA")
#' 
#' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary",
#' # title = "AAA")
#' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary",
#' # title = "AAA", error = 1)
#' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary",
#' # title = "AAA", error = 5)
#' 
#' #vascr_plot_line(growth.df, unit = "R", frequency = "raw", time = 50,
#' # level = "experiments", title = "AAA", error = 0, logscale = "x")
#' 
vascr_plot_line = function(data.df, priority = NULL, error = Inf, alpha = 0.1)
{
  data = data.df
  
  # Search for priority if it's not found
  priority = vascr_priority(data, c("Value"), priority = priority)
  
  if(!(priority[1]=="Time" || priority[1]=="Frequency"))
  {
    warning("Priority 1 is not Time or Frequency. This may cause issues")
  }
  
  xaxis = priority[1]
  yaxis = "Value"
  well = "Well"
  ymax = "ymax"
  ymin = "ymin"
  
  # First we deal with plotting single wells, as these pan out quite differently to the other levels of replication
  replication = vascr_detect_level(data)
  data$Frequency = as.numeric(data$Frequency)
  
  if (replication == "wells") {
    
    error = 0
    
    priority = priority[!priority == "Well"] # Remove well from the priority as it's no longer required
    
    data = unite(data, col = "wellstamp", Well, priority[2], priority[3], remove = FALSE)
    wellstamp = "wellstamp"
    
    if(length(priority) ==2)
    {
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = wellstamp, colour = priority[2])) + geom_line()
    }
    else if (length(priority)>2)
    {
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = wellstamp, colour = priority[2], linetype = priority[3])) + geom_line()
    }
    
  }
  
  else{  
    
    if (length(priority) == 1) {
      
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis)) + geom_line()
      
    }else if (length(priority) == 2) {
      
      plot = ggplot(data = data, aes_string(x = priority[1], y = "Value", colour = priority[2],fill = priority[2], ymax = ymax, ymin = ymin)) + geom_line()
      
    }else if (length(priority)>2) {
      
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[2], linetype = priority[3], fill = priority[2], ymax = ymax, ymin = ymin)) + geom_line()
    }
  }
  
  if(is.infinite(error))
  {
    plot = plot + geom_ribbon(alpha = alpha)
  }
  else if(error>0)
  {
    plot = plot + geom_errorbar()
  }
  
  return(plot)
  
}

