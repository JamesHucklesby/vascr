#' Generate frequency plots
#' 
#' Library of pre-formed ggplot functions that generate frequency vs value plots for a range of different combinations of instruments, samples and experimental replication levels. Indexed with conditioned data from vascr_plot.
#'
#' @param data A vascr formatted datapoint
#' @param unit The unit to plot
#' @param time The time to plot at
#' @param frequency The frequency to plot
#' @param samplecontains Subset by sample containing frequency
#' @param experiment 
#' @param error 
#' @param alignkey 
#' @param normtime 
#' @param preprocessed 
#' @param continuouscontains 
#' @param stripidentical 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' vascr_plot_frequency(growth.df, replication = "summary", unit = "C", errorbars = Inf, samplecontains = "35,000")
#' vascr_plot_frequency(growth.df, replication = "experiments", unit = "C", errorbars = 1)
#' vascr_plot_frequency(growth.df, replication = "wells", unit = "C", errorbars = 1)
#' vascr_plot(growth.df)
#' 
#' vascr_plot_frequency(time = 100)
#' 
#' data = growth.df
#' replication = "wells"
#' 
vascr_plot_frequency = function(data = growth.df, replication = "summary", unit = "R", time = 50, frequency = "raw", samplecontains = "", experiment = "", errorbars = Inf, errorcalc = "sem", alignkey = NULL, normtime = NULL, preprocessed = FALSE, continuouscontains = NULL, stripidentical = TRUE, alpha = 0.1)
{

replication = vascr_test_summary_level(data)
  
summarised$Frequency = as.numeric(summarised$Frequency)

multiplesamples = length(unique(summarised$Sample))>1
multipleinstruments = length(unique(summarised$Instrument))>1
multipleexperiments = length(unique(summarised$Experiment))>1

if(errorbars>0 & !(replication=="wells"))
{
  summarised$errormin = as.numeric(unlist(summarised$Value - summarised[errorcalc]))
  summarised$errormax = as.numeric(unlist(summarised$Value + summarised[errorcalc]))
}



if(replication == "summary")
{

    if(multiplesamples & multipleinstruments)
    {
          plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample))+
            geom_line(aes(linetype=Instrument))
          
          if(is.infinite(errorbars))
          {
            plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample, linetype = Instrument), alpha = alpha)
          }
          else if (errorbars>0)
          {
            plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax, linetype = Instrument), alpha = 1)
          }
      
    }else if(multiplesamples)
    {
          plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample))+
            geom_line()
          
          if(is.infinite(errorbars))
          {
            plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample), alpha = alpha)
          }
          else if (errorbars>0)
          {
            plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
          }

    }else if (multipleinstruments)
        {
          plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Instrument))+
              geom_line()
          
          if(is.infinite(errorbars))
          {
            plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Instrument), alpha = alpha)
          }
          else if (errorbars>0)
          {
            plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
          }
      
    } else # Only one instrument and one sample, plot in black and white
    {
              plot = ggplot(data=summarised, aes(x=Frequency, y=Value))+
                geom_line()
            
            if(is.infinite(errorbars))
            {
              plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax), alpha = alpha)
            }
            else if (errorbars>0)
            {
              plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
            }
    
  }
  


} else if (replication == "experiments")
{
  
  if(all(multiplesamples, multipleinstruments, multipleexperiments))
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample, shape = Instrument))+
      geom_point()+
      geom_line(aes(linetype=Experiment))
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample, linetype = Experiment), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax, linetype = Experiment), alpha = 1)
    }
  }
  else if(all(multiplesamples, multipleinstruments)) # one experiment
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample))+
      geom_line(aes(linetype=Instrument))
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample, linetype = Instrument), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax, linetype = Instrument), alpha = 1)
    }
  }
  else if(all(multipleexperiments, multiplesamples))
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample))+
      geom_line(aes(linetype=Experiment))
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample, linetype = Experiment), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax, linetype = Experiment), alpha = 1)
    }

  }
  else if(all(multipleinstruments, multiplesamples))
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample))+
      geom_line(aes(linetype=Experiment))
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample, linetype = Instrument), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax, linetype = Instrument), alpha = 1)
    }

  }
  else if(mulitpleexperiments)
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Experiment))+
      geom_line()
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Experiment), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
    }

  }
  else if(mulitiplesamples)
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample))+
      geom_line()
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Sample), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
    }

  }
  else if(multipleinstruments)
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Instrument))+
      geom_line()
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax, fill = Instrument), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
    }
    
  }else
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value))+
      geom_line()
    
    if(is.infinite(errorbars))
    {
      plot= plot + geom_ribbon(aes(ymin= errormin, ymax= errormax), alpha = alpha)
    }
    else if (errorbars>0)
    {
      plot = plot + geom_errorbar(aes(ymin= errormin, ymax= errormax), alpha = 1)
    }

  }
}

if(replication == "wells")
{
  if(all(multiplesamples, multipleinstruments, multipleexperiments))
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample, shape = Instrument, group = interaction(Well, Instrument, Experiment, Sample)))+
      geom_point()+
      geom_line(aes(linetype=Experiment))
  }
  else if(all(multiplesamples, multipleinstruments))
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample, group = interaction(Well, Instrument, Sample)))+
      geom_point()+
      geom_line(aes(linetype=Instrument))
  }
  else if(all(multipleexperiments, multiplesamples))
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample, group = interaction(Well, Experiment, Sample)))+
      geom_point()+
      geom_line(aes(linetype=Experiment))
  }
  else if(mulitpleexperiments)
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Experiment, group = interaction(Well, Experiment)))+
      geom_point()+
      geom_line()
  }
  else if(mulitiplesamples)
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Sample, group = interaction(Well, Sample)))+
      geom_point()+
      geom_line()
  }
  else if(multipleinstruments)
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Instrument, group = interaction(Well, Instrument)))+
      geom_point()+
      geom_line()
  } else
  {
    plot = ggplot(data=summarised, aes(x=Frequency, y=Value, color = Well, group = interaction(Well)))+
      geom_point( alpha = 0)+
      geom_line()
  }
}

return(plot)

}


