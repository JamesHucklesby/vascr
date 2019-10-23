# Graphics generation


#' ECIS plot
#'
#' @param data A standard ECIS data frame to plot
#' @param unit Unit to plot
#' @param frequency The frequency of data to display. All modelled variables have a frequency of 0
#' @param replication How much of the replicaiton to display. Options are 'all', 'experiment', 'summary'.
#' @param time The time to subset if a slice is required. If set to Inf all data will be displayed
#' @param samplecontains Optional, only samples that contain this string will be plotted. Standard search and wildcard
#' @param experiment Optional, allows you to limit the experiment plotted. Experiment names should be separated with |
#' searches apply.
#' @param error Display error bars. 0 displays no error bars, 1 displays them all. Higher numbers will reduce the frequency of error bars plotted.
#' @param linesize Width of mean lines shown on graphs
#' @param errorsize Width of error bars shown on graphs
#' @param alphavalue Alpha value of area enclosed by error bars. May be lowered for buisy graphs
#' @param confidence The confidence to use when generating basic significance plots
#' @param xlab X axis value
#' @param ylab Y axis value
#'
#' @return A ggplot2 object
#' 
#' @export
#' 
#' @importFrom stats sd
#' @importFrom dplyr filter group_by summarise
#' @importFrom ggplot2 ggplot geom_line labs aes geom_bar position_dodge theme element_text geom_text
#'
#' @examples
#' ecis_plot(growth.df, 'Rb', replication = 'summary', 
#' error = 2, linesize = 1, errorsize = 1, alphavalue = .1, title = "Cars", xlab = "Hours")
#' ecis_plot(growth.df, 'Rb', replication = 'all',
#'  error = 2, linesize = .1, errorsize = 1, alphavalue = .1, title = "Cars", xlab = "Hours")
#'  ecis_plot(growth.df, 'Rb', replication = 'experiment',
#'  error = 2, linesize = .1, errorsize = 1, alphavalue = .1, title = "Cars", ylab = "Rb", xlab = "Hours")
#' ecis_plot(growth.df, 'R', 4000, 'summary', time = 75)
#' ecis_plot(growth.df, "R", "4000", "summary", 50, confidence = 0.1)
#'


ecis_plot = function(data, unit = "R", frequency = 4000, replication = "summary", time = Inf, samplecontains = "", experiment = "", error = 1, linesize = 1, errorsize = 1, alphavalue = 0.1, confidence = 1, xlab = "Time (hours)", ylab = "Value", title = "Title") {
  
  rawdata = data
  
  # If possible, adjust non-specific unit
  if (ylab == "Value")
  {
    ylab = ecis_titles(unit)
    print ("Title updated")
  }
  else
  {
    print ("Title ignored")
  }
  
  if (error>1)
  {
    data = ecis_subsample(data, error)
  }
    
  data = ecis_subset(data, unit = unit, frequency = frequency, time = time, samplecontains = samplecontains, experiment = experiment)
    
  # First we deal with if the graph requested is a line graph
    
    if (length(unique(data$Time))>1) { # Check if we are plotting a single, or multiple, time points
        
        if (replication == "all") {
              
              plot = ggplot2::ggplot(data = data, ggplot2::aes(x = Time, y = Value, group = interaction(Well,                       Experiment), colour = Sample, size = linesize)) + ggplot2::labs(title = title, x=xlab, y=ylab) + ggplot2::geom_line(size = linesize)
          
          return(plot)
        }
      
        else if (replication == "experiment") {
          toplot2.df = summarise(group_by(data, Sample, Time, Experiment), sd = sd(Value), 
                                 n = n(), Value = mean(Value))
          
          plot = ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample, linetype =   Experiment)) + labs(title = title, x=xlab, y=ylab) + ggplot2::geom_line(size = linesize)
          
          if (error == 1)
          {
            plot = plot + ggplot2::geom_ribbon(ggplot2::aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n), fill = Sample), alpha = alphavalue)  
          }
          
          return(plot)
          
        }
        else if (replication == "summary") {
          # Average each experiment, working out the average alone
          toplot2.df = dplyr::summarise(group_by(data, Sample, Time, Experiment), Value = mean(Value))
          
          # Now repeat the calculation, but work out the intra-experimental error and statistics
          toplot2.df = summarise(group_by(toplot2.df, Sample, Time), sd = sd(Value), n = n(), Value = mean(Value))
          
          plot = ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample)) + labs(title = title, x=xlab, y=ylab) + ggplot2::geom_line(size = linesize)
          
          if (error >0)
          {
          plot = plot + ggplot2::geom_ribbon(ggplot2::aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n), fill = Sample), alpha = alphavalue) 
          }
          
          return(plot)
          
        }
        else
        {
          warning("Unrecognised level of replicaton selected. Please state either 'all', 'experiment' or 'summary'")
        }
        
     # Then we deal with if a single time point has been requested
        
    } else {
        if (replication == "all") {
          
          filtered.df = data
          
          filtered.df$Sample = paste(filtered.df$Sample, filtered.df$Well)
          

          plot = ggplot(filtered.df, aes(x = Sample, y = Value, fill = Experiment)) 
          if(error == 1)
          {
          plot = plot + geom_bar(stat = "identity",  position = position_dodge()) + theme(axis.text.x = element_text(angle = 90))
          }
            
          return(plot)
        }

      if (replication == "experiment")
      {
      filtered2.df = summarise(group_by(data, Experiment, Sample), sd = sd(Value), n = n(), 
                               Value = mean(Value))
      
      plot = ggplot(filtered2.df, aes(x = Sample, y = Value, fill = Experiment)) + geom_bar(stat = "identity", 
                                                                                     position = position_dodge()) 
      
      if(error == 1)
      {
      plot = plot + geom_errorbar(aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n)), width = 0.2, position = position_dodge(0.9))
      }
      
      return (plot)
        }
        if (replication == "summary") {
          
          # Then use two dplyr statements to prepare the data for graphing
          filtered2.df = summarise(group_by(data, Experiment, Sample), Value = mean(Value))
          filtered2.df = summarise(group_by(filtered2.df, Sample), sd = sd(Value), n = n(), Value = mean(Value))
          if (confidence<1)
          {
            if(!(ecis_detect_normal(rawdata)==FALSE))
            {
              warning("Normalised dataset detected, ANOVA results will be invalid")
            }
            labeltable = ecis_make_significance_table(data, time, unit, frequency, confidence, format = "toplot")
            filtered2.df = left_join(filtered2.df, labeltable, by = "Sample")
            plot = ggplot(filtered2.df, aes(x = Sample, y = Value, label = Label)) + geom_bar(stat = "identity") +
           geom_text(aes(label=Label),position=position_stack(0.5))
          }
          
          else
          {
          # Then graph the output
          plot = ggplot(filtered2.df, aes(x = Sample, y = Value)) + geom_bar(stat = "identity") 
          }
          
          if(error == 1)
          {
          plot = plot + geom_errorbar(aes(ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n)), width = 0.2)
          }
          
          return (plot)
        }
    }
}

# Multiplot with common key -------------------------------------------------------

#' Internal funciton for aligning grids
#'
#' @param ...  GGPlot objects to combine
#' @param ncol Number of columns
#' @param nrow Number of rows
#' @param position Where to place each graph. Unsure about this one.
#'
#' @return A multi-plot graph object
#' 
#' @importFrom ggplot2 ggplotGrob 
#' @importFrom graphics legend
#' @importFrom grid grid.draw unit
#' @importFrom gridExtra arrangeGrob
#'
#' @examples
#' 
#' #graph1 = ecis_plot(growth.df, 'Rb', 0, 'all')
#' #graph2 = ecis_plot(growth.df, 'Rb', 0, 'experiment')
#' #graph3 = ecis_plot(growth.df, 'Rb', 0, 'summary')
#' 
#' #grid_arrange_shared_legend(graph1, graph2, graph3, ncol = 1, nrow = 3)
#' 
grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, position = c("bottom", 
    "right")) {
    
    requireNamespace("gridExtra")
    requireNamespace("grid")
    
    plots <- list(...)
    position <- match.arg(position)
    g <- ggplot2::ggplotGrob(plots[[1]] + ggplot2::theme(legend.position = position))$grobs
    legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
    lheight <- sum(legend$height)
    lwidth <- sum(legend$width)
    gl <- lapply(plots, function(x) x + ggplot2::theme(legend.position = "none"))
    gl <- c(gl, ncol = ncol, nrow = nrow)
    
    combined <- switch(position, bottom = gridExtra::arrangeGrob(do.call(gridExtra::arrangeGrob, 
        gl), legend, ncol = 1, heights = grid::unit.c(grid::unit(1, "npc") - lheight, lheight)), 
        right = gridExtra::arrangeGrob(do.call(gridExtra::arrangeGrob, gl), legend, ncol = 2, 
            widths = grid::unit.c(grid::unit(1, "npc") - lwidth, lwidth)))
    
    # grid.newpage()
    grid::grid.draw(combined)
    
    # return gtable invisibly
    invisible(combined)
    
}

#' Plot graphs accross a standard ECIS spectra
#'
#' @param data A standard ECIS data frame 
#' @param variable Variable to plot. Can't be a modeled variable (use ecis_plot_model instead)
#' @param ... Other arguements may be included that will be passed through to ecis_plot
#'
#' @return A matrix of ggplot2 objects
#' @export
#'
#' @examples
#' 
#' ecis_plot_spectra(growth.df, 'R', replication = "summary")
#' 
ecis_plot_spectra = function(data, variable, ...) {
    
    data = subset(data, Unit == variable)
    
    expectedfrequencies = c(250,500,1000,2000,4000,8000,16000,32000,64000)
    
    if(!setequal(expectedfrequencies, unique(data$Frequency)))
    {
      warning("Frequencies do not match the standard set and therefore some graphs may not be shown")
    }
    
    p1 = ecis_plot(data, variable, 250, ...)
    p2 = ecis_plot(data, variable, 500, ...)
    p3 = ecis_plot(data, variable, 1000, ...)
    p4 = ecis_plot(data, variable, 2000, ...)
    p5 = ecis_plot(data, variable, 4000, ...)
    p6 = ecis_plot(data, variable, 8000, ...)
    p7 = ecis_plot(data, variable, 16000, ...)
    p8 = ecis_plot(data, variable, 32000, ...)
    p9 = ecis_plot(data, variable, 64000, ...)
    
    return(grid_arrange_shared_legend(p1, p2, p3, p4, p5, p6, p7, p8, p9, ncol = 3, nrow = 3))
    
}

#' Plot all values generated by the ECIS model
#' 
#' This is a pre-generated piece of code that automaticaly plots all the variables generated by the ECIS model against time. Resistance at 4000 Hz is also included as a sensible sanity check of the model. 
#'
#' @param alldata.df An ECIS data frame
#' @param ... Any other arguements from ecis_plot that you might want passed through to generate the graphs
#'
#' @return A matrix containing graphs of all the variables generated by the ECIS model.
#' @export
#'
#' @examples
#' 
#' ecis_plot_model(growth.df, replication = "all")
#' 
ecis_plot_model <- function(alldata.df, ...) {
    
    m1 = ecis_plot(alldata.df, "R", 4000, ...)
    m2 = ecis_plot(alldata.df, "Rb", 0, ...)
    m3 = ecis_plot(alldata.df, "Cm", 0, ...)
    m4 = ecis_plot(alldata.df, "Alpha", 0, ...)
    m5 = ecis_plot(alldata.df, "RMSE", 0, ...)
    m6 = ecis_plot(alldata.df, "Drift", 0, ...)
    
    return(grid_arrange_shared_legend(m1, m2, m3, m4, m5, m6, ncol = 2, nrow = 3))
    
}


ecis_plot_dilution = function (data.df, unit, frequency, replication, time)
{
  
}


# Animate -----------------------------------------------------------------
#' Animate frequency
#' 
#' Generate a gganimate graphic of frequency vs resistance. Each frame of the video represents a different time point
#'
#' @param alldata.df An ECIS dataframe
#' @param unittoplot Which ECIS unit is to be plotted. Can't plot modeled variables as these are derrivative from ECIS models.
#' @param frames Number of frames to render. More frames gives a smoother graphic, but is more computationaly expensive to generate.
#'
#' @return A gganimate gif. Future itteration may include the ability to return the un-rendered object.
#' 
#' @importFrom ggplot2 ggplot geom_line aes labs scale_x_log10 scale_y_log10 geom_errorbar position_stack
#' @importFrom gganimate transition_time animate
#' @importFrom dplyr n
#' @importFrom stats sd
#' @import gifski
#' @import png
#' @import transformr
#' 
#' @export
#'
#' @examples
#' ecis_animatefrequency(growth.df, 'R', 3)
#' 
ecis_animatefrequency = function(alldata.df, unittoplot, frames) {
    
    alldatasum.df = summarise(group_by(alldata.df, Sample, Time, Unit, Frequency), sd = sd(Value), 
        n = n(), Value = mean(Value))
    
    toplot.df = alldatasum.df
    toplot.df = subset(toplot.df, Unit == unittoplot)
    toplot.df$Frequency = as.numeric(toplot.df$Frequency)
    
    toplot2.df = toplot.df
    
    p = ggplot2::ggplot(toplot2.df, ggplot2::aes(Frequency, Value, colour = Sample)) + ggplot2::geom_line(show.legend = TRUE) + 
        ggplot2::labs(title = "Days: {round(frame_time,1)}", x = "Frequency (Hz)", y = "Value (ohms)") + 
        ggplot2::scale_x_log10() + ggplot2::scale_y_log10() + ggplot2::geom_errorbar(ggplot2::aes(ymin = Value - 
        sd/sqrt(n), ymax = Value + sd/sqrt(n)), width = 0.1) + gganimate::transition_time(Time)
    
    gganimate::animate(p, nframes = frames)
}

#' Graph a single well that is misbehaving
#'
#' @param data.df The dataset the well is in
#' @param well The well to be isolated
#' 
#' @importFrom magrittr "%>%"
#' @importFrom dplyr group_by mutate ungroup
#' 
#'
#' @return A ggplot graph showing the isoated well and the experimental median well
#' @export 
#'
#' @examples
#' 
#' ecis_isolate_well(growth.df, "A3")
#' 
ecis_isolate_well= function(data.df, well)
{
  
  well = ecis_standardise_wells(well)
  data.df$Well = ecis_standardise_wells(data.df$Well)
  cleandata.df = ecis_subset(data.df, unit = "R", frequency = 4000, well = well)
  
  badwell = ecis_subset(cleandata.df, well = well)
  badwell$Sample = paste(badwell$Experiment, badwell$Sample, badwell$Well)
  
  medianwell = cleandata.df %>%
    group_by(Time) %>%
    mutate(Value = median(Value), Sample = "Experimental Mean Well", Well = "Z00") %>%
    ungroup
  
  toplot.df = rbind(badwell, medianwell)
  
  
  ecis_plot(toplot.df, "R", 4000, "all")
}




