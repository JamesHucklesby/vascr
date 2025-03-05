#' Plot a line graph with vascr
#'
#' @param data.df The vascr data set to plot
#' @param errorbars Type of error bars, Inf for ribbons, 0 for no errors and any integer to plot every nth line
#' @param alpha Transparency of the error ribbon plotted
#' @param text_labels Show or hide well labels
#' @param facet_expt Facet out different experiments, defaults to TRUE
#' 
#' @importFrom ggplot2 geom_ribbon geom_line geom_text facet_grid vars
#' @importFrom ggtext element_markdown
#' @importFrom dplyr filter
#'
#' @return a ggplot containing the data
#' @export
#'
#' @examples
#' vascr_plot_line(data.df = growth.df %>% vascr_subset(unit = "Rb"))
#' vascr_plot_line(growth.df %>% vascr_subset(unit = "Rb") %>% vascr_summarise(level = "experiments"))
#' data.df = growth.df %>% vascr_subset(unit = "Rb") %>% vascr_summarise(level = "summary")
#' vascr_plot_line(data.df, text_labels = FALSE)
#' 
#' vascr_plot_line(data.df = growth.df %>% vascr_subset(unit = "R", frequency = 4000), facet = FALSE)
#' 
vascr_plot_line = function(data.df, errorbars = Inf, alpha = 0.3, text_labels = TRUE, facet_expt = TRUE)
{
  
  
  data_level = vascr_find_level(data.df)
  
  # data.df = data.df %>% filter(!is.na(.data$Value))
  
  
  
  if(data_level == "wells")
  {
    
    overall_data = data.df
    
    if(isTRUE(text_labels)){
    final_times = overall_data %>%
      filter(.data$Time == max(.data$Time))
    }else{
      final_times = overall_data %>% filter(FALSE)
    }
    

    
    if(isTRUE(facet_expt)){
      gplot = ggplot() +
        geom_line(aes(x = .data$Time, y = .data$Value, color = .data$Sample, group = paste(.data$Well, .data$Experiment)), data = overall_data) +
        geom_text(aes(x = .data$Time, y = .data$Value, color = .data$Sample, label = .data$Well), data = final_times, hjust = 0) +
        facet_grid(vars(row = .data$Experiment))
    } else{
      gplot = ggplot() +
        geom_line(aes(x = .data$Time, y = .data$Value, color = .data$Sample, group = paste(.data$Well, .data$Experiment), linetype = .data$Experiment), data = overall_data) #+
        #geom_text_repel(aes(x = .data$Time, y = .data$Value, color = .data$Sample, label = .data$Well), data = final_times, hjust = 0, direction = "y")
    }
    
    errorbars = 0;
  }
  
  if(data_level == "experiments")
  {
      gplot = ggplot() +
        geom_line(data = data.df, aes(x = .data$Time, y = .data$Value, color = .data$Sample, linetype = .data$Experiment))
  }
  
  if(data_level == "summary")
  {
    gplot = ggplot() +
      geom_line(data = data.df, aes(x = .data$Time, y = .data$Value, color = .data$Sample))
  }
  
  
  if(errorbars == Inf)
  {
    
    gplot =  gplot + geom_ribbon(data = data.df, 
                                 aes(x = .data$Time, ymax = .data$Value + .data$sem, ymin = .data$Value - .data$sem, fill = .data$Sample, group = paste(.data$Sample, .data$Experiment)), 
                                 alpha = alpha)
    
  }
  
  
  gplot = gplot + labs(y = vascr_titles(data.df), x = "Time (hours)") +
    theme(axis.title.y = element_markdown())
  
  return(gplot)
  
}


#' Add a key time range to a plot
#'
#' @param plot The plot to add to
#' @param key_events Table of key events
#' @param labelx
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis guide_axis scale_y_continuous
#' @importFrom ggnewscale new_scale_fill new_scale_color
#' @importFrom patchwork wrap_plots
#'
#' @return a plot, with the additional key range data overlaid
#' @noRd
#'
#' @examples
#' growth.df %>%
#' vascr_subset(unit = "Rb") %>%
#' vascr_plot_line() %>%
#' vascr_plot_keyrange(tribble(~start,~end, ~title, 5, 10, "Test"))
vascr_plot_keyrange = function(plot, key_events, labelx = TRUE)
{
  specialcolours = vascr_gg_color_hue(nrow(key_events), start = 45, l = 50)
  
  if(! "colour" %in% colnames(key_events))
  {
    key_events$colour = specialcolours
  }
  
  key_events = key_events %>% mutate(middle = (.data$start+ .data$end)/2)
  
  key_events = key_events %>%
    mutate(formatted = paste("<span style = 'color:", .data$colour, ";'>", .data$title, "</span>")) %>%
    mutate(formatted = factor(.data$formatted, unique(.data$formatted))) %>%
    mutate(title = factor(.data$title, unique(.data$title)))
  
  plot1 = plot + theme(legend.position = "bottom") +
    new_scale_fill() + new_scale_color() +
    geom_rect(aes(xmin = .data$start, xmax = .data$end, ymin = Inf, ymax = -Inf, fill = .data$title), alpha = 0.4, data = key_events) +
    scale_fill_manual(values = key_events$colour) +
    labs(fill = "Key Timepoint") +
    theme(legend.direction = "vertical")
  
  plot1
  
  
  return(plot1)
  
}


#' Add a key range to the plot, labeled on the plot itself
#'
#' @param plot the plot to add key range values to
#' @param key_events tibble containing the events in the format `tribble(start, end, title)`
#' @param labelx 
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis
#'
#' @return a labeled ggplot
#' 
#' @noRd
#'
#' @examples
#' growth.df %>%
#' vascr_subset(unit = "Rb") %>%
#' vascr_plot_line() %>%
#' vascr_plot_keyrange_labeled(tribble(~start,~end, ~title, 5, 10, "Test"))
vascr_plot_keyrange_labeled = function(plot, key_events, labelx = TRUE)
{
  specialcolours = vascr_gg_color_hue(nrow(key_events), start = 45, l = 20)
  
  key_events$colour = specialcolours
  
  key_events = key_events %>% mutate(middle = (.data$start+.data$end)/2)
  
  key_events = key_events %>%
    mutate(formatted = paste("<span style = 'color:", .data$colour, ";'>", .data$title, "</span>"))
  
  plot1 = plot + theme(legend.position = "bottom") +
    scale_x_continuous(sec.axis = dup_axis(breaks = rev(c(key_events$middle)), 
                                           labels = rev(c(key_events$formatted)),
                                           name = NULL,
                                           guide = guide_axis(n.dodge=3))) +
    theme(axis.text.x.top = element_markdown(angle = 0, hjust = 0)) +
    new_scale_fill() +
    geom_rect(aes(xmin = .data$start, xmax = .data$end, ymin = Inf, ymax = -Inf), fill = key_events$colour, alpha = 0.4, data = key_events)
  
  plot1
  
  return(plot1)
  
}


#' Title
#'
#' @param plot Plot to add arrows to
#' @param key_events the events to plot
#' @param labelx Place the time point labels on the x axis
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis element_line guide_axis arrow unit
#' @importFrom ggnewscale new_scale_fill
#'
#' @return A labeled ggplot
#' 
#' @noRd
#'
#' @examples
#' growth.df %>%
#' vascr_subset(unit = "Rb") %>%
#' vascr_plot_line() %>%
#' vascr_plot_keyarrows(tribble(~start,~end, ~title, 5, 10, "Test"))
vascr_plot_keyarrows = function(plot, key_events)
{
  key_events = key_events %>% mutate(middle = (.data$start+.data$end)/2)

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
    
  
  plot = plot +
    geom_rect(aes(xmin = .data$start, xmax = .data$end, ymin = Inf, ymax = -Inf), alpha = 0.2, data = key_events)
  
  return(plot)
  
}


#' Plot key time points as lines on the graph
#'
#' @param plot a ggplot to add values to
#' @param key_events tibble containing the events to place on the plot
#' @param linetype style of line to use
#' @param linesize size of the line to plot
#' 
#' @importFrom ggplot2 geom_rect theme scale_x_continuous dup_axis
#'
#' @return an annotated ggplot
#' 
#' # Not exposed externally
#' @noRd
#'
#' @examples
#' growth.df %>%
#' vascr_subset(unit = "Rb") %>%
#' vascr_plot_line() %>%
#' vascr_plot_keylines(tribble(~start,~end, ~title, 5, 10, "Test"))
#' 
vascr_plot_keylines = function(plot, key_events, linetype = "dashed", linesize = 1)
{
  
  if(!("time" %in% colnames(key_events)))
  {
    key_events = key_events %>% mutate(middle = (.data$start+.data$end)/2)
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
    geom_vline(aes(xintercept = .data$middle, color = .data$title), linetype = linetype, linewidth = linesize, data = key_events) +
    scale_color_manual(values = key_events$color) +
    labs(color = "Key Timepoint") + 
    guides(color  = guide_legend(order = 2))
  
  
  plotr
  
}


#' Plot out each replicate well in a grid, with QC overlays
#'
#' @param data.df a vascr formatted data frame of single values
#' @param threshold threshold at which a datapoint is determined to be an outlier
#'
#' @return A plot to be used for QC
#' 
#' @export
#' 
#' @importFrom ggplot2 scale_colour_manual facet_grid element_rect theme geom_line geom_point labs
#' @importFrom ggnewscale new_scale_color
#' @importFrom stringr str_remove_all
#'
#' @examples
#' grid.df = growth.df %>% vascr_subset(unit = "R", frequency = "4000", experiment  = 1)
#' vascr_plot_grid(grid.df)
#' 
#' vascr_plot_grid(growth.df)
#' 
vascr_plot_grid = function(data.df, threshold = 0.2)
{
  
  processed =  data.df %>%
    vascr_single_param() %>%
    vascr_summarise_deviation() %>%
    mutate(Title = paste("**",.data$Well,"**", "<br>", .data$Sample, sep = "")) %>%
    mutate(col = str_remove_all(.data$Well, "[A-z]")) %>%
    mutate(row = str_remove_all(.data$Well, "[0-9]")) %>%
    filter(!is.na(.data$Value))
  
  processed %>% 
    ggplot() +
    geom_line(aes(x = .data$Time, y = .data$Median_Value, color = "Median technical replicate well")) +
    geom_point(aes(x = .data$Time, y = .data$Value, size = .data$Median_Deviation, color = "Oultier", group = .data$Title), 
               data = processed %>% filter(.data$Median_Deviation > threshold), shape = 1)+
    labs(color = "Markup", size = "Median Deviation")+
    labs(weight = "Other note") +   
    scale_colour_manual(values = c("darkgrey", "red")) +
    ggnewscale::new_scale_color() +
    geom_line(aes(x = .data$Time, y = .data$Value, color = .data$Sample)) +
    labs(color = "Sample") +
    facet_grid(vars(.data$row), vars(.data$col), drop = TRUE) +
    theme(strip.background = element_rect("white"))
}

#' Force data to have only a single pair of unit/frequency measurements
#'
#'  @param data.df vascr data set to confirm has a single parameter pair
#'
#' @returns A data frame with only one parameter, with a warning if additional data was removed
#' 
#' @noRd
#'
#' @examples
#' 
#' vascr_single_param(growth.df)
#' 
vascr_single_param = function(data.df){
  
  params = data.df %>% select("Frequency", "Unit") %>%
    distinct()
  
  if(nrow(params) >1){
        vascr_notify("warning", "More than one set of frequenices and units found, correcting")
      
        new_unit = vascr_find_unit(data.df, NA)  
        new_frequency = vascr_find_frequency(data.df, NA)
        data.df = data.df %>% vascr_subset(unit = new_unit, frequency = new_frequency)
      
  }
  
  return(data.df %>% as_tibble())
  
}



#' Plot multiple units simultaneously
#'
#' @param data.df 
#' @param key_points 
#' 
#' @importFrom patchwork wrap_plots plot_layout
#'
#' @return a grid of ggplots for various units entered
#' 
#' @noRd
#'
#' @examples
#' growth.df %>%
#' vascr_subset(unit = c("Rb", "Cm", "Alpha")) %>%
#' vascr_plot_line_panel()
#' 
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



