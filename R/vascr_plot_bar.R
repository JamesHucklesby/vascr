#' Plot a vascr data set as a bar
#'
#' @param data Vascr dataset to plot
#' @param error The level of error to display
#' @param confidence Minimum confidence level of results to show on the graph
#' @param ... Any argument to be passed to vascr_polish_plot or vascr_prep_graphdata
#'
#' @return A ggplot bar plot
#' 
#' @importFrom ggplot2 position_dodge scale_colour_grey ggplot geom_text aes_string aes geom_bar
#' 
#' @keywords internal
#' 
#' @examples
#' #vascr_plot_bar(growth.df, level = "experiments", frequency = 4000, unit = "R"
#' #, time = list(50,100), error = Inf)
#' 
#' #vascr_plot_bar(growth.df, level = "wells", frequency = 4000, unit = "R", 
#' #time = 50, error = Inf)
#' #vascr_plot_bar(data = growth.df, level = "experiments", frequency = 4000, 
#' #unit = "R", time = 50, error = Inf)
#' #vascr_plot_bar(growth.df, level = "summary", frequency = 4000, unit = "R", 
#' #time = 50, error = Inf)
#' 
#' #vascr_plot_bar(growth.df, level = "deviation", frequency = 4000, unit = "R")
#' 
#' #vascr_plot_bar(growth.df, frequency = 4000, unit = "R", time = 50, confidence = 0.5)

vascr_plot_bar = function(data, error = Inf, confidence = NULL, ...)
{

  # Gather graph data based on the ...
  dots = list(...)
  dots["error"] = error
  dots["confidence"] = confidence
  
  level = dots["level"]
  
  if(!is.null(confidence))
  {
    plot = vascr_plot_bar_anova(data, error = error, confidence = confidence, ...)
    return(plot) # Pre polished in function
  }
  
  if(dots["level"] == "deviation")
  {
    plot = vascr_plot_deviation(data, visualisation = "bar", ...)
    return(plot)
  }
  
  data = do.call_relevant("vascr_prep_graphdata", data, dots)
  
  priority = vascr_priority(data, c("Value", "Well"), priority)
  data$Sample = as.factor(data$Sample)
  data$Experiment = as.character(data$Experiment)
  data$Time = as.character(data$Time)
  
  print(priority)
  
  if (level == "wells") {
  
    # Remove well from the priority as it's no longer required
    
  if(length(priority)==1)
  {
    
    plot =  ggplot(data, aes_string(x = priority[1], y = "Value", group = interaction(data$Well, data[,priority[1]]))) + geom_bar(stat = "identity", position = position_dodge())
    
    plot = plot + geom_text(aes(label=Well), vjust=1.6,
                            position = position_dodge(0.9), size=2)
    
    
  }
    
  else if(length(priority)>=2)
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
  
  else if (any(level == "experiments", level == "summary"))
  {
    print(data)
    print(priority)
    print(length(priority))

    if(length(priority)==1)
    {
    plot = ggplot(data, aes_string(x = priority[1], y = "Value", ymin = "ymin", ymax = "ymax")) + geom_bar(stat = "identity", position = position_dodge(), orientation = "vertical")
    }
    
    else if(length(priority)>=2)
    {
      print("BITSSS")
      
      plot = ggplot(data, aes_string(x = "Sample", y = "Value", fill = "Experiment", color = "Experiment")) + geom_bar(stat = "identity", position = position_dodge()) 

    }
    
    # else if(length(priority)>=3)
    # {
    # 
    #     plot = ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], color = priority[3], group = interaction(data[,priority[1]], data[,priority[2]], data[,priority[3]])))
    #   
    #   plot = plot + geom_bar(stat = "identity", size = 1, position = position_dodge(), group = interaction(data[,priority[1]], data[,priority[2]], data[,priority[3]])) + scale_colour_grey(start = 0, end = 1)
    #   
    # 
    # }
    
  } else
  {
  stop("Graph not classed. Please try again")
  }
  
  print(level)
  
  if(error>0 & level != "wells")
  {
    plot = plot + geom_errorbar(aes(ymin = ymin, ymax = ymax), color = "black", position = position_dodge())
  }
  
  return(plot)
  
}

  


#' Plot a bar chart with ANOVA statistics superimposed on it
#'
#' @param data A vascr dataset
#' @param priority The priority of values to export
#' @param confidence The minmum confidence level to display
#' @param time Timepoint to plot
#' @param unit Unit to plot
#' @param frequency Frequency to plot
#' @param format Statistics format to return
#' @param error The style of eror bars to plot
#' @param ... Any arguement to vascr_prep_graphdata or vascr_polish_plot. Use this to select values ect.
#'
#' @return A vascr bar plot with statistics attached to it
#' 
#' @keywords internal
#' 
#' @importFrom ggplot2 geom_errorbar aes ggplot geom_text geom_bar
#'
#' @examples
#' #vascr_plot_bar(data = growth.df, confidence = 0.95, unit = "R", time = 100, 
#' #  frequency = 4000, rotate_x_angle = 45)
#' #vascr_plot_bar_anova(data = growth.df, confidence = 0.95, unit = "R", 
#' # time = 100, frequency = 4000, rotate_x_angle = 45)
#' 
vascr_plot_bar_anova = function(data.df ,priority = NULL ,confidence = 0.95, time, unit, frequency, format = toplot, error = Inf, ...)
{
  
  # Gather graph data based on the ...
  datum = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  priority = vascr_priority(datum, priority)
  
  # if(!length(unique(c(data$Time, data$Unit, data$Frequency, data$Instrument)))==4)
  # {
  #   stop("vascr_plot_bar_anova only supports a single time, unit, frequency and instrument at the moment. Please manually create an ANOVA if you need ot ask other  statistical quesitons.")
  # }
  
  # Add structure checks in here
  
  if(!(vascr_detect_normal(data.df)==FALSE))
  {
    warning("Normalised dataset detected, ANOVA results may be invalid")
  }

  summary = vascr_subset(data.df, frequency = frequency, time = time, unit = unit) %>%
    vascr_summarise(level = "summary")
  
  datum = arrange(datum, Sample)
  
  labeltable = vascr_make_significance_table(data.df = datum, time, unit, frequency, confidence, format = "toplot")
  
  summary$Sample = as.factor(summary$Sample)
  labeltable$Sample = as.factor(labeltable$Sample)
  
  filtered2.df = left_join(summary, labeltable, by = "Sample")
  
  if(is.null(filtered2.df$Label))
  {
    filtered2.df$Label = "NS"
  }
  
  # filtered2.df$Sample = reorder(filtered2.df$Sample, sort = mixedsort)
  print(filtered2.df)
  
  
  
  plot = ggplot(filtered2.df, aes(x = Sample, y = Value, label = Label, fill = Sample)) + 
    geom_bar(stat = "identity") +
    geom_text(aes(label=Label, y = min(Value)/2)) 
  
  plot
  
  
  if(error>0)
    { 
    plot = plot + geom_errorbar(aes(ymax = Value + sem, ymin = Value - sem), width = 0.6)
  }
  
  dots = list(...)
  
  plot
  
  return(plot)
}



