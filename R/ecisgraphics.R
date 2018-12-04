#Graphics generation

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
ecis_plotvariable <- function (data.df, unit, frequency)
{
  
  requireNamespace('ggplot2')
  
  toplot.df = data.df
  toplot.df = subset(data.df, Unit == unit)
  toplot.df = subset(toplot.df, Frequency == frequency)
  toplot2.df = summarise(group_by(toplot.df, Sample, Time),
                        sd=sd(Value), n=n(), se = sd/sqrt(n), Value=mean(Value))
  
  plot = ggplot(data=toplot2.df, aes(x=Time, y=Value, colour=Sample)) +
    geom_errorbar(aes(ymin=Value-se, ymax=Value+se)) +
    labs(title = unit)+
    geom_line()
  
  return(plot)
}

# Multiplot with common key -------------------------------------------------------

#' Title
#'
#' @param ... 
#' @param ncol 
#' @param nrow 
#' @param position 
#'
#' @return
#' @export
#'
#' @examples
grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, position = c("bottom", "right")) {
  
  requireNamespace('ggplot2')
  requireNamespace('gridExtra')
  requireNamespace('grid')
  
  plots <- list(...)
  position <- match.arg(position)
  g <- ggplotGrob(plots[[1]] + theme(legend.position = position))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  lwidth <- sum(legend$width)
  gl <- lapply(plots, function(x) x + theme(legend.position="none"))
  gl <- c(gl, ncol = ncol, nrow = nrow)
  
  combined <- switch(position,
                     "bottom" = arrangeGrob(do.call(arrangeGrob, gl),
                                            legend,
                                            ncol = 1,
                                            heights = unit.c(unit(1, "npc") - lheight, lheight)),
                     "right" = arrangeGrob(do.call(arrangeGrob, gl),
                                           legend,
                                           ncol = 2,
                                           widths = unit.c(unit(1, "npc") - lwidth, lwidth)))
  
  #grid.newpage()
  grid.draw(combined)
  
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
  
  p1 = ecis_plotvariable(data, variable , 250)
  p2 = ecis_plotvariable(data, variable, 500)
  p3 = ecis_plotvariable(data, variable , 1000)
  p4 = ecis_plotvariable(data, variable , 2000)
  p5 = ecis_plotvariable(data, variable , 4000)
  p6 = ecis_plotvariable(data, variable , 8000)
  p7 = ecis_plotvariable(data, variable , 16000)
  p8 = ecis_plotvariable(data, variable , 32000)
  p9 = ecis_plotvariable(data, variable , 64000)
  
  grid_arrange_shared_legend(p1, p2, p3, p4, p5, p6, p7, p8, p9, ncol = 3, nrow = 3)
  
}

#' Title
#'
#' @param alldata.df 
#'
#' @return
#' @export
#'
#' @examples
ecis_plotmodel <- function (alldata.df){
  
  m1 = ecis_plotvariable(alldata.df, "R" , 4000)
  m2 = ecis_plotvariable(alldata.df, "Rb", 0)
  m3 = ecis_plotvariable(alldata.df, "Cm" , 0)
  m4 = ecis_plotvariable(alldata.df, "Alpha" , 0)
  m5 = ecis_plotvariable(alldata.df, "RMSE" , 0)
  m6 = ecis_plotvariable(alldata.df, "Drift" , 0)
  
  grid_arrange_shared_legend(m1, m2, m3, m4, m5, m6, ncol = 2, nrow = 3)
  
}


# Animate -----------------------------------------------------------------
#' Title
#'
#' @param alldata.df 
#' @param unittoplot 
#' @param frames 
#'
#' @return
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
  
  p = ggplot(toplot2.df, aes(Frequency, Value, colour = Sample)) +
    geom_line( show.legend = TRUE) +
    labs(title = 'Days: {round(frame_time,1)}', x = 'Frequency (Hz)', y = 'Value (ohms)') +
    scale_x_log10() +
    scale_y_log10() +
    geom_errorbar(aes(ymin=Value-se, ymax=Value+se), width=.1) +  
    transition_time(Time)
  
  animate(p, nframes = frames)
}
