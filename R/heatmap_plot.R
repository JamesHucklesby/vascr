#' Title
#'
#' @param data 
#' @param time 
#' @param unit 
#' @param frequency 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' vascr_plot_heatmap(growth.df, 100, "Rb")
#' vascr_plot_heatmap(growth.df, 100, "R", 4000)
#' 
vascr_plot_heatmap = function(data, time, unit, frequency, title ="Title")
{

data = vascr_subset(data, time = time, unit = unit, frequency = frequency)

sumdata = group_by(data, Well)
sumdata = summarise(sumdata, number = n())

if(max(sumdata$number)>1)
{
  warning("More than one record per well. More than one plate may have been superimposed. Use plot with care.")
}

if(var(data$Time)>0)
{
  warning("More than one time point selected. Plotting mean time point in range")
  time = vascr_find_time(data,mean(time))
}

data = vascr_explode_wells(data)

plot = ggplot(data, aes(col, row, fill= Value)) + 
  geom_tile()  +
  scale_fill_gradient(low="white", high="blue")+
  xlab("Column") +
  ylab("Row")+
  scale_x_discrete(position = "top")+
  ggtitle(title)

return(vascr_polish_plot(plot, rotate_x = FALSE))
}

#' Title
#'
#' @param data 
#'
#' @return
#' @export
#'
#' @examples
vascr_test_multi_plate = function(data)
{
  # Select distinct experiment:well pairs
  sumdata = data %>% select(Well,Experiment)%>%  distinct(Well, Experiment)
  # Count how many times each well comes up
  sumdata = sumdata %>% group_by(Well) %>% summarise(number = n())
  
  # Warn and return false if any well is present in more than one experiment
  if(max(sumdata$number)>1)
  {
    warning("More than one record per well. More than one plate may have been superimposed. Use plot with care.")
    return(TRUE)
  }
  
  return(FALSE)
}


#' ECIS plot samplemap
#'
#' @param data The datapoint to plot
#' @param title Title to be placed on the graph
#'
#' @return
#' @export
#'
#' @examples
#' 
#' vascr_plot_samplemap(growth.df)
#' 
vascr_plot_samplemap = function(data, title ="Title", stripidentical = TRUE)
{
  
  # Warn if trying to plot multiple plates
  vascr_test_multi_plate(data)
  
  # Cut out everythign we don't care about, and remove remaining duplicates
  data$Time = 0
  data$Value = 0
  data$Unit = 0
  data$Frequency = 0
  data = vascr_remove_metadata(data)
  data = distinct(data)
  
  # Prep graphdata, IE, re-consitute names for plotting
  data = vascr_prep_graphdata(data, stripidentical = stripidentical)
  
  # Explode out wells, then select only the distinct data we need for plotting
  data = vascr_explode_wells(data)
  data = data %>% select(col, row, Sample) %>% distinct()
  data$Sample = as.factor(data$Sample)

  plot = ggplot(data, aes(col, row)) + 
    geom_tile(aes(fill = Sample), colour = "white")+
    xlab("Column") +
    ylab("Row")+
    scale_x_discrete(position = "top")+
    ggtitle(title)
  
  return(vascr_polish_plot(plot, rotate_x = FALSE))
}

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
#' @param title 
#' @param xlab 
#' @param ylab 
#' @param linesize 
#' @param alphavalue 
#'
#' @return
#' @export
#'
#' @examples
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "wells")
#' vascr_plot_line(data)
#' vascr_plot_line(data, priority = c("Experiment", "Sample"))
#' 
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "experiments")
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "summary")
#' 
#' 
vascr_plot_line = function(data, priority = NULL)
{

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
  
  priority = priority[!priority == "Well"] # Remove well from the priority as it's no longer required
  
  if(length(priority) ==1)
  {
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = interaction(data$Well, priority[1]), colour = priority[1])) + geom_line()
  return(plot)
  }
  else if (length(priority) == 2)
  {
    plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = interaction(data$Well, priority[2]), colour = priority[1], linetype = priority[2]))    + geom_line()
    return(plot)
  }
  else
  {
    error("Supported number of variables exceeded. Please don't attemtpt to plot more than two more variables on top of time and value at once")
    stop()
  }
  
}
  
  
if (length(priority) == 1) {
  
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[1], ymin = ymin, ymax = ymax, fill = priority[1])) + geom_line()
  return(plot)
  
}else if (length(priority)==2) {
  
  plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[1], linetype = priority[2], fill = priority[1], ymin = "ymin", ymax = "ymax")) + geom_line()
  plot
} else
{
  error("Supported number of variables exceeded. Please don't attempt to plot more than two variables on top of time and value at once")
  stop()
}
  

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
  
  
    
  # Remove impossible error bars for the avoidance of errors. Replaces both max and min with the      actual value.
  data = mutate(data, ymax = coalesce(ymax, Value))
  data = mutate(data, ymin = coalesce(ymin, Value))
      
}
  
  return(data)
  
}




#' Title
#'
#' @param data 
#' @param replication 
#' @param error 
#' @param title 
#' @param xlab 
#' @param ylab 
#' @param time 
#' @param unit 
#' @param frequency 
#' @param confidence 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "summary", time = list(50))
#' vascr_plot_column(data)
#' 
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "experiments", time = list(50,100))
#' vascr_plot_column(data)
#' 
#' data = vascr_prep_graphdata(growth.df, unit = "Rb", level = "wells", samplecontains = c("35,000", "30,000"), time = list(50,100,150))
#' vascr_plot_column(data, priority = c("Experiment","Time", "Sample", "Experiment"))
#' 
#' unique(data$Well) 
#' 
vascr_plot_column = function(data, priority = NULL)
{
  
  priority = vascr_priority(data, c("Value", "Well"), priority)
  data$Sample = as.character(data$Sample)
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
    
    return(plot)
    
  }
    
  if(length(priority)==2)
  {
    
    data[priority[2]] = lapply(data[priority[2]],as.character)
    
    plot =  ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], group = interaction(data$Well, data[,priority[1]]))) + geom_bar(stat = "identity", position = position_dodge())
    
    plot = plot + geom_text(aes(label=Well), vjust=1.6,
                     position = position_dodge(0.9), size=2)
    
    return(plot)
  }
    
    if(length(priority)==3)
    {
      
      data[priority[2]] = lapply(data[priority[2]],as.character)
      data[priority[3]] = lapply(data[priority[3]],as.character)
      
      plot =  ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], colour = priority[3], group = interaction(data$Well, data[,priority[1]], data[,priority[2]], data[,priority[3]]))) + geom_bar(stat = "identity", position = position_dodge())
      
      plot = plot + geom_bar(stat = "identity", size = 1, position = position_dodge()) + scale_colour_grey(start = 0, end = 1)
      
      plot = plot + geom_text(aes(label=Well), vjust=1.6,position = position_dodge(0.9), size=2)
      
      return(plot)
    }
    
    if(length(priority)>3)
    {
      stop("No more than 3 variables is supported for this graph type. Please subset your data more rigourously")      
    }
    
  }
  
  if (any(replication == "experiments", replication == "summary"))
  {

    if(length(priority)==1)
    {
    plot = ggplot(growth.df, aes_string(x = priority[1], y = "Value")) + geom_bar(stat = "identity", position = position_dodge())
    
    return(plot)
    }
    
    else if(length(priority)==2)
    {
      plot = ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], group = interaction(data[,priority[1]], data[,priority[2]]))) + geom_bar(stat = "identity", position = position_dodge(),group = interaction(data[,priority[1]], data[,priority[2]]))
      
      return(plot)
    }
    
    else if(length(priority)==3)
    {

        plot = ggplot(data, aes_string(x = priority[1], y = "Value", fill = priority[2], color = priority[3], group = interaction(data[,priority[1]], data[,priority[2]], data[,priority[3]])))
      
      plot = plot + geom_bar(stat = "identity", size = 1, position = position_dodge(), group = interaction(data[,priority[1]], data[,priority[2]], data[,priority[3]])) + scale_colour_grey(start = 0, end = 1)
      
      return(plot)

    }
    else if(length(priority)>3)
    {
      stop("Only up to a stack of 3 variables is supported. Please try again.")
    }
    
  }
  
  stop("Graph not classed. Please try again")
  
}







