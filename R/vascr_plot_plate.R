


#' Title
#'
#' @param data The dataset to plot out
#'
#' @return
#' 
#' @noRd
#'
#' @examples
vascr_plot_well_grid = function(data) {
  data = vascr_explode_wells(data)
  
  plot = ggplot(data, aes(x = Time, y = Value, color= Sample)) + 
    geom_line()  +
    facet_grid(rows = vars(row), cols = vars(col))
  
  return(plot)
}

#' Title
#'
#' @param data 
#'
#' @return
#' @noRd
#'
vascr_plot_treatment_grid = function(data) {
  data = vascr_explode_wells(data)
  
  
  graphstack = list()
  
  for(sample in unique(data$Sample)){
    localdata = subset(data, data$Sample == sample)
    
    plot = ggplot(localdata, aes(x = Time, y = Value, color= Well, group = Well)) + 
      geom_line() +
      facet_wrap(vars(Sample))
    
    graphstack[[sample]] = plot
  }
  
  wrap_plots(graphstack)
  
  return(plot)
}






#' #' Plot a heatmap of a particular timepoint
#' #'
#' #' @param data Vascr dataset to plot
#' #' @param priority Vascr priority to plot
#' #' @param ... Other values to pass on to data conditioning funcions
#' #' 
#' #' @importFrom ggplot2 ggplot geom_tile scale_fill_gradient xlab ylab scale_x_discrete facet_wrap
#' #'
#' #' @return A vascr platemap of the selected data
#' #' 
#' #' @keywords internal
#' #'
#' #' @examples
#' #' 
#' #' #vascr_plot_plate(growth.df, time = 100, unit = "Rb")
#' #' #vascr_plot_plate(growth.df, time = 100, unit = "R", frequency = "4000")
#' #' #vascr_plot_plate(growth.df, time = 100, unit = "R", frequency = "4000", level = "deviation")
#' #' #vascr_plot_plate(growth.df, time = 100, unit = "R", frequency = 4000, level = "structure")
#' #' 
#' vascr_plot_plate= function(data, priority = NULL,  ...)
#' {
#'   
#'   
#'   dots = list(...)
#'   
#'   if(dots["level"] == "structure")
#'   {
#'     return(vascr_plot_structure(data))
#'   }
#'   
#'   
#'   if(dots["level"] == "deviation")
#'   {
#'     plot = vascr_plot_deviation(data, visualisation = "plate", priority = priority, ...)
#'     plot = do.call_relevant("vascr_polish_plot", plot, dots)
#'     return(plot)
#'   }
#'   
#'   # Gather graph data based on the ...
#'   dots = list(...)
#'   data = do.call_relevant("vascr_prep_graphdata", data, dots)
#'   
#'   priority = vascr_priority(data, priority = priority)
#'   
#'   # Warn and fix if more than one time is selected (deal with this in a bit) -------------------------------------
#'   if(var(data$Time)>0)
#'   {
#'     warning("More than one time point selected. This function can only plot one time point at a time. Plotting mean time point in range")
#'     time = vascr_find_time(data,mean(time))
#'   }
#'   
#'   data = vascr_explode_wells(data)
#'   
#'   legendtitle = vascr_titles(dots["unit"])
#'   
#'   plot = ggplot(data, aes_string("col", "row", fill= priority[1])) + 
#'     geom_tile()  +
#'     scale_fill_gradient(low="white", high="blue")+
#'     xlab("Column") +
#'     ylab("Row")+
#'     scale_x_discrete(position = "top")+
#'     facet_wrap(vars(Experiment), scales = "free_x")
#'   
#'   plot = plot + guides(fill=guide_legend(title=legendtitle))
#'   
#'   plot = do.call_relevant("vascr_polish_plot", plot, dots)
#'   
#'   return(plot)
#' }
#' 




#' Test if multiple plates are present in a dataset
#'
#' @param data Dataset to test
#'
#' @return Boolean, true if multiple plates are present. Also returns an error if true.
#' 
#' @noRd
#'
#' @examples
#' #vascr_test_multi_plate(growth.df)
#' #vascr_test_multi_plate(vascr_combine(growth.df, growth.df)
#' 
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


#' Plot the plate structure of a dataset
#'
#' @param data The data point to plot
#' @param title Title to be placed on the graph
#' @param stripidentical Should identical wells be removed form the dataset
#' @param ... Variables to be passed onto prep_graphdata and polish_plot
#'
#' @return A map of the data sampled
#' 
#' @importFrom magrittr '%>%'
#' @importFrom dplyr select
#' @importFrom ggplot2 ggplot ylab xlab scale_x_discrete facet_wrap vars geom_tile scale_fill_gradient guides guide_legend
#' 
#' @noRd
#'
#' @examples
#' 
#' #vascr_plot_structure(growth.df)
#' 
vascr_plot_structure = function(data, title ="Title", stripidentical = TRUE, ...)
{
  
  # Cut out everythign we don't care about, and remove remaining duplicates
  graphdata = data %>% select(Well, Sample, Experiment) %>% distinct
  
  # Explode out wells, then select only the distinct data we need for plotting
  graphdata = vascr_explode_wells(graphdata, separate_rows = TRUE)
  
  plot = ggplot(graphdata, aes(col, row)) + 
    geom_tile(aes(fill = Sample), colour = "white")+
    xlab("Column") +
    ylab("Row")+
    scale_x_discrete(position = "top")+
    facet_wrap(vars(Experiment), scales = "free_x")
  
  return(vascr_polish_plot(plot))
}
