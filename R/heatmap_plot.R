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
vascr_plot_line = function(data, replication, error = Inf, title, xlab, ylab, linesize, alphavalue)
{

if (replication == "wells") {
  
  plot = ggplot2::ggplot(data = data, ggplot2::aes(x = Time, y = Value, group = interaction(Well,                       Experiment), colour = Sample, size = linesize)) + ggplot2::labs(title = title, x=xlab, y=ylab) + ggplot2::geom_line(size = linesize)
  
  return(vascr_polish_plot(plot))
}else if (replication == "experiments") {
  toplot2.df = summarise(group_by(data, Sample, Time, Experiment), sd = sd(Value), 
                         n = n(), Value = mean(Value))
  
  plot = ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample, linetype =   Experiment)) + labs(title = title, x=xlab, y=ylab) + ggplot2::geom_line(size = linesize)
  
  if (error == Inf)
  {
    plot = plot + ggplot2::geom_ribbon(ggplot2::aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n), fill = Sample), alpha = alphavalue)  
  }
  
  if (error>0 && error < Inf)
  {
    plot = plot + ggplot2::geom_errorbar(ggplot2::aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n)))  
  }
  
  return(vascr_polish_plot(plot))
  
}else if (replication == "summary") {
  # Average each experiment, working out the average alone
  toplot2.df = dplyr::summarise(group_by(data, Sample, Time, Experiment), Value = mean(Value))
  
  # Now repeat the calculation, but work out the intra-experimental error and statistics
  toplot2.df = summarise(group_by(toplot2.df, Sample, Time), sd = sd(Value), n = n(), Value = mean(Value))
  
  plot = ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample)) + labs(title = title, x=xlab, y=ylab) + ggplot2::geom_line(size = linesize)
  
  if (error == Inf)
  {
    plot = plot + ggplot2::geom_ribbon(ggplot2::aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n), fill = Sample), alpha = alphavalue) 
  }
  
  if (0< error && error < Inf)
  {
    plot = plot + ggplot2::geom_errorbar(ggplot2::aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n))) 
  }
  
  return(vascr_polish_plot(plot))(plot)
  
} else
{
  warning("Unrecognised level of replicaton selected. Please state either 'wells', 'experiments' or 'summary'")
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
#' vascr_prep_graphdata(growth.df)
#' 
#' 
vascr_prep_graphdata = function(data, unit = "", frequency = Inf, time = Inf, samplecontains = "", experiment = "", error = Inf, alignkey = NULL, normtime = NULL, divide = FALSE, preprocessed = FALSE, continuouscontains = NULL , stripidentical = TRUE, sortkeyincreasing = TRUE)
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
vascr_plot_column = function(data, replication, error = Inf, title, xlab, ylab, time, unit, frequency, confidence)
{
  if (replication == "wells") {
    
    filtered.df = data
    
    filtered.df$Sample = paste(filtered.df$Sample, filtered.df$Well)
    
    
    plot = ggplot(filtered.df, aes(x = Sample, y = Value, fill = Experiment))+
      ggplot2::labs(title = title, x=xlab, y=ylab) 
    if(error == Inf)
    {
      plot = plot + geom_bar(stat = "identity",  position = position_dodge()) + theme(axis.text.x = element_text(angle = 90))
    }
    
    return(vascr_polish_plot(plot))(plot)
  }
  
  if (replication == "experiments")
  {
    filtered2.df = summarise(group_by(data, Experiment, Sample), sd = sd(Value), n = n(), 
                             Value = mean(Value))
    
    plot = ggplot(filtered2.df, aes(x = Sample, y = Value, fill = Experiment)) + geom_bar(stat = "identity", position = position_dodge()) + ggplot2::labs(title = title, x=xlab, y=ylab)
    
    if(error == Inf)
    {
      plot = plot + geom_errorbar(aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n)), width = 0.2, position = position_dodge(0.9))
    }
    
    return(vascr_polish_plot(plot))
  }
  
  if (replication == "summary") {
    
    # Then use two dplyr statements to prepare the data for graphing
    filtered2.df = summarise(group_by(data, Experiment, Sample), Value = mean(Value))
    filtered2.df = summarise(group_by(filtered2.df, Sample), sd = sd(Value), n = n(), Value = mean(Value))
    if (confidence<1)
    {
      if(!(vascr_detect_normal(data)==FALSE))
      {
        warning("Normalised dataset detected, ANOVA results will be invalid")
      }
      labeltable = vascr_make_significance_table(data, time, unit, frequency, confidence, format = "toplot")
      filtered2.df = left_join(filtered2.df, labeltable, by = "Sample")
      plot = ggplot(filtered2.df, aes(x = Sample, y = Value, label = Label)) + geom_bar(stat = "identity") +
        geom_text(aes(label=Label),position=position_stack(0.8)) + ggplot2::labs(title = title, x=xlab, y=ylab)
    }
    
    else
    {
      # Then graph the output
      plot = ggplot(filtered2.df, aes(x = Sample, y = Value)) + geom_bar(stat = "identity") + ggplot2::labs(title = title, x=xlab, y=ylab)
    }
    
    if(error == Inf)
    {
      plot = plot + geom_errorbar(aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n)), width = 0.2)
    }
    
    return(vascr_polish_plot(plot))
  }
}







