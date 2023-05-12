#' Title
#'
#' @param data.df The vascr data set to plot
#' @param errorbars Type of error bars, Inf for ribbons, 0 for no errors and any interger to plot every nth line
#' @param alpha Transparency of the error ribbon plotted
#' 
#' @importFrom mdthemes md_theme_grey
#'
#' @return
#' @export
#'
#' @examples
vascr_plot_line = function(data.df, errorbars = Inf, alpha = 0.3)
{
  
  
  data_level = vascr_detect_level(data.df)
  
  data.df = data.df %>% filter(!is.na(Value))
  
  
  
  if(data_level == "wells")
  {
    gplot = ggplot() +
      geom_line(data = data.df, aes(x = Time, y = Value, color = Sample, group = Well))
    
    errorbars = 0;
  }
  
  if(data_level == "experiments")
  {
    gplot = ggplot() +
      geom_line(data = data.df, aes(x = Time, y = Value, color = Sample, linetype = Experiment))
  }
  
  if(data_level == "summary")
  {
    gplot = ggplot() +
      geom_line(data = data.df, aes(x = Time, y = Value, color = Sample))
  }
  
  
  if(errorbars == Inf)
  {
   gplot =  gplot + geom_ribbon(data = data.df, 
                        aes(x = Time, ymax = Value + sem, ymin = Value - sem, fill = Sample, group = paste(Sample, Experiment)), 
                        alpha = alpha)
    
    }
  
  
  gplot = gplot + md_theme_grey()
  
  gplot = gplot + labs(y = vascr_graph_titles(data.df), x = "Time (hours)")
  
  return(gplot)
  
}


#' Title
#'
#' @param plot 
#' @param key_events 
#' @param labelx
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis guide_axis scale_y_continuous
#' @importFrom ggnewscale new_scale_fill
#' @importFrom patchwork wrap_plots
#'
#' @return
#' @noRd
#'
#' @examples
vascr_plot_keyrange = function(plot, key_events, labelx = TRUE)
{
  specialcolours = vascr_gg_color_hue(nrow(key_events), start = 45, l = 50)
  
  if(! "colour" %in% colnames(key_events))
  {
  key_events$colour = specialcolours
  }
  
  key_events = key_events %>% mutate(middle = (start+end)/2)
  
  key_events = key_events %>%
    mutate(formatted = paste("<span style = 'color:", colour, ";'>", title, "</span>")) %>%
    mutate(formatted = factor(formatted, unique(formatted))) %>%
    mutate(title = factor(title, unique(title)))
  
  plot1 = plot + theme(legend.position = "bottom") +
    new_scale_fill() + new_scale_color() +
    geom_rect(aes(xmin = start, xmax = end, ymin = Inf, ymax = -Inf, fill = title), alpha = 0.4, data = key_events) +
    scale_fill_manual(values = key_events$colour) +
    labs(fill = "Key Timepoint") +
    theme(legend.direction = "vertical")
  
  plot1

  
  return(plot1)
  
}


#' Title
#'
#' @param plot 
#' @param key_events
#' @param labelx
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis
#'
#' @return
#' @noRd
#'
#' @examples
vascr_plot_keyrange_labeled = function(plot, key_events, labelx = TRUE)
{
  specialcolours = vascr_gg_color_hue(nrow(key_events), start = 45, l = 20)
  
  key_events$colour = specialcolours
  
  key_events = key_events %>% mutate(middle = (start+end)/2)
  
  key_events = key_events %>%
    mutate(formatted = paste("<span style = 'color:", colour, ";'>", title, "</span>"))
  
  plot1 = plot + theme(legend.position = "bottom") +
    scale_x_continuous(sec.axis = dup_axis(breaks = rev(c(key_events$middle)), 
                                           labels = rev(c(key_events$formatted)),
                                           name = NULL,
                                           guide = guide_axis(n.dodge=3))) +
    theme(axis.text.x.top = element_markdown(angle = 0, hjust = 0)) +
    new_scale_fill() +
    geom_rect(aes(xmin = start, xmax = end, ymin = Inf, ymax = -Inf), fill = key_events$colour, alpha = 0.4, data = key_events)
  
  plot1
  
  return(plot1)
  
}


#' Title
#'
#' @param plot Plot to add arrows to
#' @param key_events the events to plot
#' @param labelx Place the time point labels on the x axis
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis element_line guide_axis
#' @importFrom ggnewscale new_scale_fill
#'
#' @return
#' @noRd
#'
#' @examples
vascr_plot_keyarrows = function(plot, key_events, labelx = TRUE)
{
  key_events = key_events %>% mutate(middle = (start+end)/2)
  
  
  if(labelx)
  {

    
    # Plot with stacked and arrows
    
  # plot +
  #   scale_x_continuous(sec.axis = dup_axis(breaks = rev(c(key_events$middle)), 
  #                                          labels = rev(c(key_events$title)),
  #                                          name = NULL,
  #                                          guide = guide_axis(n.dodge=3))) +
  #   theme(axis.text.x.top = element_text(hjust = 0, vjust = 0.5), 
  #         axis.ticks.x.top = element_line(color = "red",
  #                                         arrow = arrow(angle = 30, ends = "first", type = "closed", 
  #                                                       unit(6, "pt"))),
  #         axis.ticks.length.x.top = unit(12, "pt")
  #         )
    
   plot =  plot + theme(legend.position = "bottom") +
      scale_x_continuous(sec.axis = dup_axis(breaks = rev(c(key_events$middle)), 
                                             labels = rev(c(key_events$title)),
                                             name = NULL,
                                             guide = guide_axis(n.dodge=1))) +
      theme(axis.text.x.top = element_text(angle = 20, hjust = 0), 
            axis.ticks.x.top = element_line(color = "red",
                                            arrow = arrow(angle = 30, ends = "first", type = "closed", 
                                                          unit(6, "pt"))),
            axis.ticks.length.x.top = unit(12, "pt")
      )
  

  }
  
  plot = plot +
    geom_rect(aes(xmin = start, xmax = end, ymin = Inf, ymax = -Inf), alpha = 0.2, data = key_events)
  
  return(plot)
  
}


#' Title
#'
#' @param plot 
#' @param key_events 
#' @param labelx
#' @param linetype 
#' @param linesize Size of the line to plot
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis
#'
#' @return
#' 
#' @noRd
#'
#' @examples
vascr_plot_keylines = function(plot, key_events, labelx = TRUE, linetype = "dashed", linesize = 1)
{
  
  if(!("time" %in% colnames(key_events)))
  {
  key_events = key_events %>% mutate(middle = (start+end)/2)
  } else
  {
    key_events$middle = key_events$time
  }
  
  if(!("color" %in% colnames(key_events)))
  {
    key_events$color = vascr_gg_color_hue(n = nrow(key_events))
  }
  
  key_events$title = factor(key_events$title, unique(key_events$title))
  
  plotr = plot + new_scale_color() +
    geom_vline(aes(xintercept = middle, color = title), linetype = linetype, size = linesize, data = key_events) +
    scale_color_manual(values = key_events$color) +
    labs(color = "Key Timepoint") + 
    guides(color  = guide_legend(order = 2))
    
  
  plotr
  
}




#' Title
#'
#' @param data.df 
#' @param key_points 
#'
#' @return
#' @noRd
#'
#' @examples
vascr_plot_line_panel = function(data.df, key_points = NULL)
{
  
  units = unique(data.df$Unit)
  
  graphlist = list()
  
  for(unit in units)
  {
    graphlist[[unit]] = (data.df %>% 
                           vascr_subset(unit = unit) %>%
                           vascr_plot_line())
    
    if(!is.null(key_points))
    {
      graphlist[[unit]] = graphlist[[unit]] %>% 
        vascr_plot_keylines(key_points)
    }
    
  }
  
  layout =  wrap_plots(graphlist) + plot_layout(ncol = 1, guides = "collect")
  
  layout 
}














#' #' Plot a line graph from a vascr dataset
#' #'
#' #' @param data.df Vascr dataset to plot
#' #' @param priority Priority list of variables to plot
#' #' @param error Error to plot
#' #' @param alpha Alpha value of the line plotted
#' #' @param ... Values to be passed onto prep_graphdata and polish_plot
#' #'
#' #' @return A ggplot2 object of the graph created
#' #' 
#' #' @keywords internal
#' #'
#' #' @examples
#' #' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary", error = Inf)
#' #' 
#' #' 
#' #' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "experiments", title = "AAA")
#' #' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "wells", title = "AAA")
#' #' # vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "deviation", title = "AAA")
#' #' 
#' #' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary",
#' #' # title = "AAA")
#' #' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary",
#' #' # title = "AAA", error = 1)
#' #' #vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary",
#' #' # title = "AAA", error = 5)
#' #' 
#' #' #vascr_plot_line(growth.df, unit = "R", frequency = "raw", time = 50,
#' #' # level = "experiments", title = "AAA", error = 0, logscale = "x")
#' #' 
#' vascr_plot_line = function(data.df, priority = NULL, error = Inf, alpha = 0.3, level = NULL, line_width = 1)
#' {
#'   
#'   if(is.finite(error) && error != 0)
#'   {
#'     return(vascr_plot_line_suberror(data.df, subsampling = error, priority = priority, alpha = alpha))
#'   }
#'  
#'   
#'   if(!is.null(level))
#'   {
#'   data = vascr_summarise(data.df, level)
#'   }
#'   else
#'   {
#'     data = data.df
#'   }
#' 
#'   
#'   # Search for priority if it's not found
#'   priority = vascr_priority(data, c("Value"), priority = priority)
#'   
#'   if(!(priority[1]=="Time" || priority[1]=="Frequency"))
#'   {
#'     warning("Priority 1 is not Time or Frequency. This may cause issues")
#'   }
#'   
#'   xaxis = priority[1]
#'   yaxis = "Value"
#'   well = "Well"
#'   ymax = "max"
#'   ymin = "min"
#'   
#'   # First we deal with plotting single wells, as these pan out quite differently to the other levels of replication
#'   replication = vascr_detect_level(data)
#'   data$Frequency = as.numeric(data$Frequency)
#'   
#'   if (replication == "wells") {
#'     
#'     error = 0
#'     
#'     priority = priority[!priority == "Well"] # Remove well from the priority as it's no longer required
#'     data = unite(data, col = "wellstamp", priority[[2]], Well, remove = FALSE)
#'     wellstamp = "wellstamp"
#' 
#'    if(length(priority) ==2)
#'     {
#'       plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = wellstamp, colour = priority[2])) + geom_line(size = line_width) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'       plot = plot+ mdthemes::md_theme_gray()
#'       return(plot)
#'     }
#'     else if (length(priority)>2)
#'     {
#'       plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, group = wellstamp, colour = priority[2], linetype = priority[3])) + geom_line(size = line_width) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'       plot = plot+ mdthemes::md_theme_gray()
#'       return(plot)
#'     }
#'     
#'   }
#'   
#'   else{  
#'     
#'     if (length(priority) == 1) {
#'       
#'       plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis)) + geom_line(size = line_width) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'       
#'     }else if (length(priority) == 2) {
#'       
#'       plot = ggplot(data = data, aes_string(x = priority[1], y = "Value", colour = priority[2],fill = priority[2])) + geom_line(size = line_width) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'       
#'     }else if (length(priority)>2) {
#'       
#'       plot = ggplot(data = data, aes_string(x = xaxis, y = yaxis, colour = priority[2], linetype = priority[3], fill = priority[2])) + geom_line(size = line_width) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'     }
#'   }
#'   
#'   if(is.infinite(error))
#'   {
#'     plot = plot + geom_ribbon(aes(ymin = Value - sem, ymax = Value + sem),alpha = alpha, color = NA) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'   }
#'   else if(error>0)
#'   {
#'     plot = plot + geom_errorbar(aes(ymin = data.df$Value - data.df$sem, ymax = data.df$Value + data.df$sem)) + ylab(vascr_titles(unique(data$Unit), unique(data$Frequency))) + xlab("Time (hours)")
#'   }
#'   
#'   plot = plot+ mdthemes::md_theme_gray()
#'   return(plot)
#'   
#' }
#' 
#' 
#' #' Sub-sample the number of error bars on a graph
#' #'
#' #' @param data.df 
#' #' @param subsampling 
#' #'
#' #' @return A sub sampled plot for error bars
#' #' @noRd
#' #'
#' #' @examples
#' vascr_plot_line_suberror = function(data.df, subsampling = 10, priority = NULL, alpha = 0.1)
#' {
#'   
#'   data.df_small = vascr_subsample(data.df, subsampling)
#'   
#'   returnplot = vascr_plot_line(data.df, error = 0, priority = priority, alpha = alpha) +
#'     geom_errorbar(aes(ymin = Value - sem, ymax = Value+sem, x = Time, color = Sample), data = data.df_small, width = 1)
#'   
#'   return(returnplot)
#' }

