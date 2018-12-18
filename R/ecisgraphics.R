#Graphics generation

#' Generate a standard ECIS data representation
#' 
#' THIS FUNCTION IS DEPRECIATED, Use ECIS_plot_xxx series of funcitons for finer control over how to deal with replicate experiments. This graphic will underestimate error from replicate experiments.
#'
#' @param data.df An ECIS data set. Must be 
#' @param unit The unit to plot
#' @param frequency Frequency to plot. All modeled units have a default frequency of 0
#'
#' @return A GGplot2 object
#' 
#' @export 
#'
#' @examples
#' ecis_plotvariable(data.df, "Rb", 0)
#' 
ecis_plotvariable <- function (data.df, unit, frequency)
{
  
  warning("THIS FUNCTION IS DEPRECIATED, USE ECIS_PLOT_XXX IN THE FUTURE")
  
  toplot.df = data.df
  toplot.df = subset(data.df, Unit == unit)
  toplot.df = subset(toplot.df, Frequency == frequency)
  toplot2.df = summarise(group_by(toplot.df, Sample, Time),
                       sd=sd(Value), n=n(), se = sd/sqrt(n), Value=mean(Value))
  
  plot = ggplot2::ggplot(data=toplot2.df, ggplot2::aes(x=Time, y=Value, colour=Sample)) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin=Value-se, ymax=Value+se)) +
    ggplot2::labs(title = unit)+
    ggplot2::geom_line()
  
  return(plot)
}

#' Title
#'
#' @param data.df 
#' @param unit 
#' @param frequency 
#'
#' @return
#' @export
#'
#' @examples
ecis_plot_all = function(toplot.df, unit, frequency)
{
  
  toplot.df = subset(toplot.df, Unit == unit)
  toplot.df = subset(toplot.df, Frequency == frequency)
  
  plot = ggplot2::ggplot(data=toplot.df, ggplot2::aes(x=Time, y=Value, group = interaction(Well, Experiment), colour = Sample)) +
    ggplot2::labs(title = unit)+
    ggplot2::geom_line()
  
  return (plot)
}

#' Plot individual experiments
#' 
#' This funciton plots individual experiments as separate lines on an ECIS data plot. Each experiment has a different line style. No error bars are included to keep the plot nice and clean.
#'
#' @param data.df An ECIS dataset
#' @param unit    Unit of interest
#' @param frequency  Frequency of unit. All derrived units have a frequency of 0.
#'
#' @return A ggplot2 object
#' @export
#'
#' @examples
ecis_plot_experiments = function(toplot.df, unit, frequency)
{
  
  toplot.df = subset(toplot.df, Unit == unit)
  toplot.df = subset(toplot.df, Frequency == frequency)
  toplot2.df = summarise(group_by(toplot.df, Sample, Time, Experiment),
                         sd=sd(Value), n=n(), se = sd/sqrt(n), Value=mean(Value))
  
  plot = ggplot2::ggplot(data=toplot2.df, ggplot2::aes(x=Time, y=Value, colour=Sample, linetype =  Experiment)) +
    # geom_errorbar(ggplot2::aes(ymin=Value-se, ymax=Value+se)) +
    ggplot2::labs(title = unit)+
    ggplot2::geom_line()
  
  plot
  
  return (plot)
}

#' Plot summary statistics from replicate experiments
#' 
#' This funciton plots averages and SEM from multiple expeiments. Each experiment is averaged and then the averages are plotted. This gives a better idea of the inter-experimetnal variaton, while minimising the effect of technical variation within experiments.
#'
#' @param toplot.df An ECIS data file to plot
#' @param unit The unit of interest
#' @param frequency Frequency of interest
#' 
#' @return A ggplot2 graph
#' @export
#'
#' @examples
ecis_plot_summary <- function (toplot.df, unit, frequency)
{
  
  # Delete any un-needed data for this graph
  toplot.df = subset(toplot.df, Unit == unit)
  toplot.df = subset(toplot.df, Frequency == frequency)
  
  # Average each experiment, working out the average alone
  toplot2.df = dplyr::summarise(group_by(toplot.df, Sample, Time, Experiment),
                                Value=mean(Value))
  
  # Now repeat the calculation, but work out the intra-experimental error and statistics
  toplot2.df = summarise(group_by(toplot2.df, Sample, Time),
                         sd=sd(Value), n=n(), se = sd/sqrt(n), Value=mean(Value))
  
  plot = ggplot2::ggplot(data=toplot2.df, ggplot2::aes(x=Time, y=Value, colour=Sample)) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin=Value-se, ymax=Value+se)) +
    ggplot2::labs(title = unit)+
    ggplot2::geom_line()
  
  return(plot)
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
#' @export
#'
#' @examples
grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, position = c("bottom", "right")) {

  requireNamespace('gridExtra')
  requireNamespace('grid')
  
  plots <- list(...)
  position <- match.arg(position)
  g <- ggplot2::ggplotGrob(plots[[1]] + ggplot2::theme(legend.position = position))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  lwidth <- sum(legend$width)
  gl <- lapply(plots, function(x) x + ggplot2::theme(legend.position="none"))
  gl <- c(gl, ncol = ncol, nrow = nrow)
  
  combined <- switch(position,
                     "bottom" = gridExtra::arrangeGrob(do.call(gridExtra::arrangeGrob, gl),
                                            legend,
                                            ncol = 1,
                                            heights = grid::unit.c(grid::unit(1, "npc") - lheight, lheight)),
                     "right" = gridExtra::arrangeGrob(do.call(gridExtra::arrangeGrob, gl),
                                           legend,
                                           ncol = 2,
                                           widths = grid::unit.c(grid::unit(1, "npc") - lwidth, lwidth)))
  
  #grid.newpage()
  grid::grid.draw(combined)
  
  # return gtable invisibly
  invisible(combined)
  
}

#' Title
#'
#' @param data 
#' @param variable 
#'
#' @return
#' @export
#'
#' @examples
ecis_plotspectra = function(data, variable){
  
  data = subset(data, Unit == variable)
  
  p1 = ecis_plot_summary(data, variable , 250)
  p2 = ecis_plot_summary(data, variable, 500)
  p3 = ecis_plot_summary(data, variable , 1000)
  p4 = ecis_plot_summary(data, variable , 2000)
  p5 = ecis_plot_summary(data, variable , 4000)
  p6 = ecis_plot_summary(data, variable , 8000)
  p7 = ecis_plot_summary(data, variable , 16000)
  p8 = ecis_plot_summary(data, variable , 32000)
  p9 = ecis_plot_summary(data, variable , 64000)
  
  grid_arrange_shared_legend(p1, p2, p3, p4, p5, p6, p7, p8, p9, ncol = 3, nrow = 3)
  
}

#' Plot all values generated by the ECIS model
#' 
#' This is a pre-generated piece of code that automaticaly plots all the variables generated by the ECIS model against time. Resistance at 4000 Hz is also included as a sensible sanity check of the model. 
#'
#' @param alldata.df An ECIS data frame
#'
#' @return A matrix containing graphs of all the variables generated by the ECIS model.
#' @export
#'
#' @examples
#' 
ecis_plotmodel <- function (alldata.df){
  
  m1 = ecis_plot_summary(alldata.df, "R" , 4000)
  m2 = ecis_plot_summary(alldata.df, "Rb", 0)
  m3 = ecis_plot_summary(alldata.df, "Cm" , 0)
  m4 = ecis_plot_summary(alldata.df, "Alpha" , 0)
  m5 = ecis_plot_summary(alldata.df, "RMSE" , 0)
  m6 = ecis_plot_summary(alldata.df, "Drift" , 0)
  
  multiplot(m1, m2, m3, m4, m5, m6, cols = 2)
  
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
#' @export
#'
#' @examples
ecis_animatefrequency = function (alldata.df, unittoplot, frames){
  
  alldatasum.df = summarise(group_by(alldata.df, Sample, Time, Unit, Frequency),
                            sd=sd(Value), n=n(), se = sd/sqrt(n),Value=mean(Value))
  
  toplot.df = alldatasum.df
  toplot.df = subset(toplot.df, Unit == unittoplot)
  toplot.df$Frequency = as.numeric(toplot.df$Frequency)
  toplot.df = subset(toplot.df, Time < 6)
  
  toplot2.df = toplot.df
  
  p = ggplot2::ggplot(toplot2.df, ggplot2::aes(Frequency, Value, colour = Sample)) +
    ggplot2:: geom_line( show.legend = TRUE) +
    ggplot2::labs(title = 'Days: {round(frame_time,1)}', x = 'Frequency (Hz)', y = 'Value (ohms)') +
    ggplot2::scale_x_log10() +
    ggplot2::scale_y_log10() +
    ggplot2::geom_errorbar(ggplot2::aes(ymin=Value-se, ymax=Value+se), width=.1) +  
    gganimate::transition_time(Time)
  
  gganimate::animate(p, nframes = frames)
}
