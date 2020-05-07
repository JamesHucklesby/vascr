

#######################################################################################
#
#   Plot line data
#
#######################################################################################

#' Title
#'
#' @param data 
#' @param replication 
#' @param error 
#' @param alpha
#'
#' @return
#' @export
#'
#' @examples
#' vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary", title = "AAA")
#' vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "experiments", title = "AAA")
#' vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "wells", title = "AAA")
#' vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "deviation", title = "AAA")
#' 
vascr_plot_line = function(data, priority = NULL, error = Inf, alpha = 0.1, ...)
{
  
  dots = list(...)
  if(dots["level"] == "deviation")
  {
    plot = vascr_plot_deviation(data, visualisation = "line", priority = priority, ...)
    plot = do.call_relevant("vascr_polish_plot", plot, dots)
    return(plot)
  }
  
  
  # Gather graph data based on the ...
  dots = list(...)
  dots["error"] = error
  data = do.call_relevant("vascr_prep_graphdata", data, dots)


  # Search for priority if it's not found
  priority = vascr_priority(data, c("Time", "Value"), priority = priority)
  
  xaxis = "Time"
  yaxis = "Value"
  well = "Well"
  ymax = "ymax"
  ymin = "ymin"
  
# First we deal with plotting single wells, as these pan out quite differently to the other levels of replication
replication = vascr_detect_level(data)
  
if (replication == "wells") {
  
  error = 0
  
  priority = priority[!priority == "Well"] # Remove well from the priority as it's no longer required
  
  if(length(priority) ==1)
  {
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = interaction(data$Well, priority[1]), colour = priority[1])) + geom_line()
  }
  else if (length(priority) == 2)
  {
    plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = interaction(data$Well, priority[2]), colour = priority[1], linetype = priority[2]))    + geom_line()
  }
  
}

else{  
  
if (length(priority) == 0) {
  
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, ymin = ymin, ymax = ymax)) + geom_line()
  
}else if (length(priority) == 1) {
  
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[1], ymin = ymin, ymax = ymax, fill = priority[1])) + geom_line()
  
}else if (length(priority)>1) {
  
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[1], linetype = priority[2], fill = priority[1], ymin = "ymin", ymax = "ymax")) + geom_line()
}
}

if(is.infinite(error))
{
  plot = plot + geom_ribbon(alpha = alpha)
}
  
plot = do.call_relevant("vascr_polish_plot", plot, dots)

return(plot)

}




#' Prepare a dataset to be graphed by vascar_graph_xxx
#' 
#' Central data subset, cleanup and label prep function
#'
#' @param data 
#' @param unit 
#' @param frequency 
#' @param time 
#' @param samplecontains 
#' @param experiment 
#' @param error 
#' @param alignkey 
#' @param normtime 
#' @param divide 
#' @param preprocessed 
#' @param continuouscontains 
#' @param stripidentical 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "summary")
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "experiments")
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "wells")
#' 
#' 
vascr_prep_graphdata = function(data, unit = "", frequency = Inf, time = Inf, samplecontains = "", experiment = "", error = Inf, alignkey = NULL, normtime = NULL, divide = FALSE, preprocessed = FALSE, continuouscontains = NULL , stripidentical = TRUE, sortkeyincreasing = TRUE, level = "", errortype = "sem")
{
  # First subset away what we don't need for normalising to a particular point (speeds up things a lot)
  data = vascr_subset(data, unit = unit, frequency = frequency, samplecontains = samplecontains, experiment = experiment)
  
  # Subsample the data if only some time points are required for error plotting
  if (error>1 && !is.infinite(Inf))
  {
    data = vascr_subsample(data, error)
  }
  
  # Then normalise or align key points, if required. Alignment then normalisation are preformed, as the final data, not the transposed data is usually what is requested. This behaviour can be changed by manually formulating the data ahead of time.
  if(!is.null(alignkey))
  {
    data = vascr_align_key(data, alignkey)
  }
  
  if(!is.null(normtime))
  {
    data = vascr_normalise(data, normtime, divide)
  }
  
  # Then subset down to the timepoints that are required
  data = vascr_subset(data, time = time)

  
  # If data is not preprocessed and data is not exploded already, explode the dataset
  if (isFALSE(preprocessed) & isFALSE(vascr_test_exploded(data)))
  {
    data = vascr_explode(data)
  }
  
  # If  data is being subset based on a continuous column, run that now
  if(!is.null(continuouscontains))
  {
    data = vascr_subset_continuous(data, continuouscontains)
  }
  
  if(stripidentical)
  {
    data$Sample = (vascr_implode(data, stripidentical = TRUE))$Sample
  } 
  
  data = vascr_summarise(data, level = level)
  
  if(isFALSE(preprocessed))
  {
  # Replace all the underscores in titles with spaces
  data$Sample = str_replace(data$Sample, "_", " ")
  }
  
  # Sort the order of titles as numbers
  if(!is.null(sortkeyincreasing))
  {
    data$Sample = vascr_factorise_and_sort(data$Sample, sortkeyincreasing)
  }
  
  # Remove any values that are unplottable, IE generation of SD or SEM failed, likely due to missing values from modeling failures
  data = drop_na(data, Value)
  
  
  if(level == "summary" || level =="experiments")
  {
  
  if(errortype == "sem")
  {
    data$sem = data$sd/sqrt(data$n)
    data$ymax = data$Value + data$sem
    data$ymin = data$Value - data$sem
  }
  else if (errortype == "sd")
  {
    data$ymax = data$Value + data$sd
    data$ymin = data$Value  - data$sd
  }
  else if(errortype == "range")
  {
    data$ymax = data$max
    data$ymin = data$min
  }
  else
  {
    warning("No error specified,  and hence won't be generated")
  }
  
  
    
  # Remove impossible error bars for the avoidance of errors. Replaces both max and min with the actual value.
  data = mutate(data, ymax = coalesce(ymax, Value))
  data = mutate(data, ymin = coalesce(ymin, Value))
      
}
  
  return(data)
  
}




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
#' @param name 
#' @param payload 
#' @param arguments 
#'
#' @return
#' @export
#'
#' @examples
do.call_relevant = function(name, payload, arguments)
{
  function_args = formals(name)
  
  toforward = names(function_args) %in% names(arguments)
  
  toforwardnames = as.vector(names(function_args))[toforward]
  
  present_args = arguments[toforwardnames]

  if(is.data.frame(payload))
  {
   present_args[["data"]] = payload
  }
  else if(is.ggplot(payload))
  {
    present_args[["plot"]] = payload
  }
  
  return(do.call(name, present_args))
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



