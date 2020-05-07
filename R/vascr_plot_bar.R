#' Plot a vascr data set as a bar
#'
#' @param data 
#' @param priority
#' @param error
#' @param ... Any argument to be passed to vascr_polish_plot or vascr_prep_graphdata
#'
#' @return
#' @export
#'
#' @examples
#' 
#' vascr_plot_bar(growth.df, level = "experiments", frequency = 4000, unit = "R", time = list(50,100), error = Inf)
#' 
#' vascr_plot_bar(growth.df, level = "wells", frequency = 4000, unit = "R", time = 50, error = Inf)
#' vascr_plot_bar(growth.df, level = "experiments", frequency = 4000, unit = "R", time = 50, error = Inf)
#' vascr_plot_bar(growth.df, level = "summary", frequency = 4000, unit = "R", time = 50, error = Inf)
#' vascr_plot_bar(growth.df, level = "deviation", frequency = 4000, unit = "R")
#' 

vascr_plot_bar = function(data, priority = NULL, error = Inf, ...)
{
  # Gather graph data based on the ...
  dots = list(...)
  dots["error"] = error
  dots["priority"] = priority
  
  if(dots["level"] == "deviation")
  {
    plot = vascr_plot_deviation(data, visualisation = "bar", priority = priority, ...)
    return(plot)
  }
  
  data = do.call_relevant("vascr_prep_graphdata", data, dots)
  
  priority = vascr_priority(data, c("Value", "Well"), priority)
  data$Sample = as.factor(data$Sample)
  data$Experiment = as.character(data$Experiment)
  data$Time = as.character(data$Time)
  
  replication = vascr_test_summary_level(data)
  
  if (replication == "wells") {
  
    # Remove well from the priority as it's no longer required
    
  if(length(priority)==1)
  {
    
    plot =  ggplot(data, aes_string(x = priority[1], y = "Value", group = interaction(data$Well, data[,priority[1]]))) + geom_bar(stat = "identity", position = position_dodge())
    
    plot = plot + geom_text(aes(label=Well), vjust=1.6,
                            position = position_dodge(0.9), size=2)
    
    
  }
    
  else if(length(priority)==2)
  {
    
    plot =  ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], group = interaction(data$Well, data[,priority[1]]))) + geom_bar(stat = "identity", position = position_dodge())
    
    plot = plot + geom_text(aes(label=Well), vjust=1.6,
                     position = position_dodge(0.9), size=2)
    

  }
    
    else if(length(priority)>=3)
    {
      
      data[priority[2]] = lapply(data[priority[2]],as.character)
      data[priority[3]] = lapply(data[priority[3]],as.character)
      
      plot =  ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], colour = priority[3], group = interaction(data$Well, data[,priority[1]], data[,priority[2]], data[,priority[3]]))) + geom_bar(stat = "identity", position = position_dodge())
      
      plot = plot + geom_bar(stat = "identity", size = 1, position = position_dodge()) + scale_colour_grey(start = 0, end = 1)
      
      plot = plot + geom_text(aes(label=Well), vjust=1.6,position = position_dodge(0.9), size=2)
      
    }
    
  }
  
  else if (any(replication == "experiments", replication == "summary"))
  {
    print(data)
    print(priority)
    print(length(priority))

    if(length(priority)==1)
    {
    plot = ggplot(data, aes_string(x = priority[1], y = "Value", ymin = "ymin", ymax = "ymax")) + geom_bar(stat = "identity", position = position_dodge(), orientation = "vertical")
    }
    
    else if(length(priority)==2)
    {
      plot = ggplot(data, aes_string(x = "Sample", y = "Value", fill = "Experiment", color = "Experiment")) + geom_bar(stat = "identity", position = position_dodge()) 

    }
    
    else if(length(priority)>=3)
    {

        plot = ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], color = priority[3], group = interaction(data[,priority[1]], data[,priority[2]], data[,priority[3]])))
      
      plot = plot + geom_bar(stat = "identity", size = 1, position = position_dodge(), group = interaction(data[,priority[1]], data[,priority[2]], data[,priority[3]])) + scale_colour_grey(start = 0, end = 1)
      

    }
    
  } else
  {
  stop("Graph not classed. Please try again")
  }
  
  if(error>0 & replication != "wells")
  {
    plot = plot + geom_errorbar(aes(ymin = ymin, ymax = ymax), color = "black", position = position_dodge())
  }
  
  return(plot)
  
}

  


#' Title
#'
#' @param data 
#' @param priority
#' @param confidence 
#' @param ... Any arguement to vascr_prep_graphdata or vascr_polish_plot
#'
#' @return
#' @export
#'
#' @examples
#' vascr_plot_bar_anova(growth.df, confidence = 0.95, unit = "Rb", time = 100, rotate_x_angle = 45)
#' 
vascr_plot_bar_anova = function(data,priority,confidence, ...)
{
  
  # Gather graph data based on the ...
  dots = list(...)
  data = do.call_relevant("vascr_prep_graphdata", data, dots)
  
  if(!length(unique(c(data$Time, data$Unit, data$Frequency, data$Instrument)))==4)
  {
    stop("vascr_plot_bar_anova only supports a single time, unit, frequency and instrument at the moment. Please manually create an ANOVA if you need ot ask other  statistical quesitons.")
  }
  
  # Add structure checks in here
  
  if(!(vascr_detect_normal(data)==FALSE))
  {
    warning("Normalised dataset detected, ANOVA results may be invalid")
  }
  
  time = data$Time[1]
  unit = data$Unit[1]
  frequency = data$Frequency[1]
  
  summary = vascr_summarise(data, level = "summary")
  
  labeltable = vascr_make_significance_table(data, time, unit, frequency, confidence, format = "toplot")
  
  summary$Sample = as.character(summary$Sample)
  labeltable$Sample = as.character(labeltable$Sample)
  
  filtered2.df = left_join(labeltable, summary, by = "Sample")
  
  plot = ggplot(filtered2.df, aes(x = Sample, y = Value, label = Label)) + geom_bar(stat = "identity") +
    geom_text(aes(label=Label),position=position_stack(0.8))
  
  plot = do.call_relevant("vascr_polish_plot", payload = plot, arguments = dots)
  
  return(plot)
}



