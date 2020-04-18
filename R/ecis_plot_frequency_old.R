#' if(vascr_test_summary_level(df) == "wells")
#' {
#'   
#'   group = interaction(df$Well, df$Experiment)
#'   
#'   if(all(missing(line), missing(color)))
#'   {
#'     plot = ggplot(data=df, aes_string(x=x, y=y, group = group))
#'   }
#'   else
#'   {
#'     plot = ggplot(data=df, aes_string(x=x, y=y, color = color, group = group))
#'   }
#'   
#' }
#' 
#' 
#' 
#' # vascr_plot_frequency_ggcode(summarised, color = "Sample", errorbars = 0, errorcalc = "sem", alpha = 0.1)
#' 
#' vascr_plot_frequency_ggcode = function(df, color = NULL, line, errorbars, errorcalc, alpha)
#' {
#' 
#'   x = "Frequency"
#'   y = "Value"
#' 
#' 
#' 
#'   if(all(missing(line), missing(color)))
#'   {
#'     plot = ggplot(data=df, aes_string(x=x, y=y))
#'   }
#'   else
#'   {
#'     plot = ggplot(data=df, aes_string(x=x, y=y, color = color))
#'   }
#' 
#'   if(!missing(line))
#'   {
#'     plot = plot + geom_line(aes_string(linetype=line))
#'   }else
#'   {
#'     plot = plot + geom_line()
#'   }
#' 
#'   if(errorbars>0)
#'   {
#'     df$errormin = as.numeric(unlist(df[y] - df[errorcalc]))
#'     df$errormax = as.numeric(unlist(df[y] + df[errorcalc]))
#'   }
#' 
#'   if(is.infinite(errorbars))
#'   {
#'     if(!missing(line))
#'     {
#'       plot= plot + geom_ribbon(aes_string(ymin= errormin, ymax= errormax, fill = color, linetype = line), alpha = alpha)
#'     }else
#'     {
#'       plot= plot + geom_ribbon(aes_string(ymin= errormin, ymax= errormax, fill = color), alpha = alpha)
#'     }
#'   }else if (errorbars>0)
#'   {
#'     plot = plot + geom_errorbar(aes_string(ymin= errormin, ymax= errormax), alpha = 1)
#'   }
#' 
#'   return(plot)
#' }
#' 
#' 
#' #' Title
#' #'
#' #' @param data
#' #' @param unit
#' #' @param time
#' #' @param frequency
#' #' @param samplecontains
#' #' @param experiment
#' #' @param error
#' #' @param alignkey
#' #' @param normtime
#' #' @param preprocessed
#' #' @param continuouscontains
#' #' @param stripidentical
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' #' vascr_plot_frequency(growth.df, replication = "summary", unit = "C", errorbars = Inf)
#' #' vascr_plot_frequency(growth.df, replication = "experiments", unit = "C", errorbars = 1)
#' #' vascr_plot_frequency(growth.df, replication = "wells", unit = "C", errorbars = 1)
#' #' vascr_plot(growth.df)
#' #'
#' #' vascr_plot_frequency(time = 100)
#' #'
#' vascr_plot_frequency = function(data = growth.df, replication = "summary", unit = "R", time = 50, frequency = "raw", samplecontains = "", experiment = "", errorbars = Inf, errorcalc = "sem", alignkey = NULL, normtime = NULL, preprocessed = FALSE, continuouscontains = NULL, stripidentical = TRUE, alpha = 0.1)
#' {
#' 
#'   data = vascr_prep_graphdata(data = data, unit = unit, time = time, frequency = frequency, samplecontains = samplecontains, experiment = experiment, error = errorbars, alignkey = alignkey, normtime = normtime, preprocessed = preprocessed, continuouscontains = continuouscontains, stripidentical = stripidentical)
#' 
#' 
#'   # This should be in the above sample
#'   summarised = vascr_summarise(data, level = replication)
#' 
#'   summarised$Frequency = as.numeric(summarised$Frequency)
#' 
#'   multiplesamples = length(unique(summarised$Sample))>1
#'   multipleinstruments = length(unique(summarised$Instrument))>1
#'   multipleexperiments = length(unique(summarised$Experiment))>1
#' 
#' 
#' 
#'   if(replication == "summary")
#'   {
#' 
#'     if(multiplesamples & multipleinstruments)
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", line = "Instrument", errorbars = errorbars, errorcalc = errorcalc, "alpha" = alpha)
#' 
#'     }else if(multiplesamples)
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", errorbars = errorbars, errorcalc = errorcalc, alpha = alpha)
#'     }else if (multipleinstruments)
#' 
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised,color = "Instrument", errorbars = errorbars, errorcalc = errorcalc, alpha = alpha)
#' 
#'     } else # Only one frequency and one sample, plot in black and white
#' 
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, errorbars = errorbars, errorcalc = errorcalc, alpha = alpha)
#'     }
#' 
#'   } else if (replication == "experiments")
#'   {
#' 
#'     if(all(multiplesamples, multipleinstruments, multipleexperiments))
#'     {
#'       error("Mulitple samples, multiple instruments and multiple experiments selected. Please limit yourself to any two of these three variables in order to plot properly")
#'     }
#'     else if(all(multiplesamples, multipleinstruments)) # one experiment
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", line = "Instrument", "errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(all(multipleexperiments, multiplesamples))
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", line = "Experiment", "errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(all(multipleinstruments, multiplesamples))
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", line = "Instrument", "errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(mulitpleexperiments)
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Experiment", "errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(mulitiplesamples)
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", "errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(multipleinstruments)
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Instrument","errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#' 
#'     }else
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, "errorbars" = errorbars, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'   }
#' 
#'   if(replication == "wells")
#'   {
#'     if(all(multiplesamples, multipleinstruments, multipleexperiments))
#'     {
#'       error("Mulitple samples, multiple instruments and multiple experiments selected. Please limit yourself to any two of these three variables in order to plot properly")
#'     }
#'     else if(all(multiplesamples, multipleinstruments))
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", line = "Instrument", "errorbars" = 0, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(all(multipleexperiments, multiplesamples))
#'     {
#'       plot = vascr_plot_frequency_ggcode(summarised, color = "Sample", line = "Experiment", "errorbars" = 0, "errorcalc" = errorcalc, "alpha" = alpha)
#'     }
#'     else if(mulitpleexperiments)
#'     {
#' 
#'     }
#'     else if(mulitiplesamples)
#'     {
#' 
#'     }
#'     else if(multipleinstruments)
#'     {
#' 
#'     } else
#'     {
#'     }
#'   }
#' 
#'   return(plot)
#' 
#' }
#' 
#' 
