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
vascr_plot_line = function(data.df, priority = NULL, error = Inf, alpha = 0.1, level = NULL)
{
  
  if(is.finite(error) && error != 0)
  {
    return(vascr_plot_line_suberror(data.df, subsampling = error, priority = priority, alpha = alpha))
  }
 
  
  if(!is.null(level))
  {
  data = vascr_summarise(data.df, level)
  }
  else
  {
    data = data.df
  }

  
  # Search for priority if it's not found
  priority = vascr_priority(data, c("Value"), priority = priority)
  
  if(!(priority[1]=="Time" || priority[1]=="Frequency"))
  {
    warning("Priority 1 is not Time or Frequency. This may cause issues")
  }
  
  xaxis = priority[1]
  yaxis = "Value"
  well = "Well"
  ymax = "max"
  ymin = "min"
  
  # First we deal with plotting single wells, as these pan out quite differently to the other levels of replication
  replication = vascr_detect_level(data)
  data$Frequency = as.numeric(data$Frequency)
  
  if (replication == "wells") {
    
    error = 0
    
    priority = priority[!priority == "Well"] # Remove well from the priority as it's no longer required
    
    data = unite(data, col = "wellstamp", Well, priority[2], remove = FALSE)
    wellstamp = "wellstamp"
    
    if(length(priority) ==2)
    {
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = wellstamp, colour = priority[2])) + geom_line() + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
      return(plot)
    }
    else if (length(priority)>2)
    {
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = wellstamp, colour = priority[2], linetype = priority[3])) + geom_line() + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
      return(plot)
    }
    
  }
  
  else{  
    
    if (length(priority) == 1) {
      
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis)) + geom_line() + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
      
    }else if (length(priority) == 2) {
      
      plot = ggplot(data = data, aes_string(x = priority[1], y = "Value", colour = priority[2],fill = priority[2])) + geom_line() + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
      
    }else if (length(priority)>2) {
      
      plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[2], linetype = priority[3], fill = priority[2])) + geom_line() + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
    }
  }
  
  if(is.infinite(error))
  {
    plot = plot + geom_ribbon(aes(ymin = Value - sem, ymax = Value + sem),alpha = alpha) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
  }
  else if(error>0)
  {
    plot = plot + geom_errorbar(aes(ymin = data.df$Value - data.df$sem, ymax = data.df$Value + data.df$sem)) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
  }
  
  return(plot)
  
}


#' Title
#'
#' @param data.df 
#' @param subsampling 
#'
#' @return
#' @export
#'
#' @examples
vascr_plot_line_suberror = function(data.df, subsampling = 10, priority = NULL, alpha = 0.1)
{
  
  data.df_small = vascr_subsample(data.df, subsampling)
  
  returnplot = vascr_plot_line(data.df, error = 0, priority = priority, alpha = alpha) +
    geom_errorbar(aes(ymin = Value - sem, ymax = Value+sem, x = Time, color = Sample), data = data.df_small, width = 1)
  
  return(returnplot)
}

