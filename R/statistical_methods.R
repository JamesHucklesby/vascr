# This file contains the statistical data analyasis

#' ANOVA analyasis of a single ECIS timepoint
#' 
#' This function takes a standard ECIS dataset and runs two way ANOVA on it based on the variaiton between treatments and experiments. It then runs a post-hoc test to determine which pairs of groups are statistically different. Results are printed to the console as text.
#' 
#' 
#' This analyasis requires multiple experiments, as working out the differences in a single experiment is not a good idea because it does not account for experimental variaiton, making the analyasis weaker and more unreliable as results may not be repeatable.
#' 
#' Firstly, a histogram is generated for a visual check of the data. This should mimic what you are expecting.
#' 
#' To interpret the data first check that the data is roughly linear on the Shapiro-Wilk normailty graph,and that the p<0.05. This is more important for smaller datasets, and becomes irrelevant once n>9. Therefore you can be relativley non-stringent when applying this test to three independent experiments, where each experiment had triplicates. Also check that the residuals on the right hand graph are roughly normal, this is easier for larger datasets.
#' 
#' Finally look at the Analysis of Variance Table. This will tell you if you had any differences between 
#'
#' @param data.df A standard ECIS dataset.
#' @param unit Unit to be analysed.
#' @param frequency Frequency to be used. All modeled units have a frequency of 0.
#' @param time  Time to be used.
#'
#' @return ANOVA results printed to the console.
#' 
#' @importFrom graphics hist
#' @importFrom stats lm anova aov TukeyHSD residuals shapiro.test
#' @importFrom s20x normcheck 
#' @importFrom ggpubr ggqqplot
#' @importFrom ggplot2 geom_density geom_rug position_jitter geom_histogram geom_vline geom_boxplot stat_smooth geom_hline ggtitle xlab ylab position_stack
#' @importFrom car leveneTest
#' 
#' @importFrom cowplot plot_grid
#' @importFrom gridExtra arrangeGrob
#' 
#' 
#' 
#' @export
#'
#' @examples
#' growth.df$Instrument = "ECIS"
#' ecis_ANOVA(growth.df, 'R',4000,50)
#' 
ecis_ANOVA = function(data.df, unit, frequency, time) {
    
    # Round the number given to the function to the nearest actual measurement
    timetouse = ecis_find_time(data.df, time)
    
    # Cut the dataset down to a useable size (IE, only pull out the timepoint we want to analyse)
    #FUTURE: Impliment this off the back of ecis_subset
    
    filtered.df = data.df
    filtered.df = subset(filtered.df, Unit == unit)
    filtered.df = subset(filtered.df, Frequency == frequency)
    
    timeplot = ecis_plot(data.df, unit = unit, frequency = frequency, title = "Time Selected")
    timeplot = timeplot + geom_vline(xintercept = timetouse, color = "blue")
    timeplot = timeplot + labs(title = "Timepoint selected")
    
    # Not we get rid of all the data points we don't need, leaving only the one key one
    filtered.df = subset(filtered.df, Time == timetouse)
    
    exploded = ecis_explode(filtered.df)
    imploded = ecis_implode(exploded, stripidentical = TRUE)
    
    overallplot <- ggplot(imploded, aes(x=Sample, y=Value, color = Experiment)) + 
      geom_boxplot() + labs(title = "Replicate data")
  
    
    # Run a basic ANOVA, normcheck and Tukey's HSD
    dat = filtered.df
    fit <- lm(Value ~ Experiment + Sample, data = dat)
    
    aov_residuals <- residuals(object = fit)
    
    qqplot = ggqqplot(aov_residuals)
    shapirotest = shapiro.test(aov_residuals)
    shapirow = round(shapirotest$statistic[[1]],3)
    shapirop = round(shapirotest$p,3)
    
    if(shapirop>0.05)
    {
      passes = "Pass"
    }else
    {
      passes = "Fail"
    }
    
    qqplot = qqplot + labs(title = "Normality test",
                           subtitle = paste("Shapiro-Wilk, W=", shapirow, ", P=", shapirop, ",", passes))
    
    levenetest = leveneTest(Value ~ Experiment*Sample, data = dat)
    
    f = round(levenetest$`F value`[1],3)
    p = round(levenetest$`Pr(>F)`[1],3)
    
    if(p>0.05)
    {
      pass = "Pass"
    }else
    {
      pass = "Fail"
    }
  
    
    filtered.df$residuals <- residuals(fit)
    filteredplot.df = filtered.df
    filteredplot.df$Value = filtered.df$residuals
    
    normaloverlayplot = ggplot2::ggplot(filteredplot.df, aes(x = Value)) + 
      ggplot2::geom_histogram(aes(y =..density..),
                              colour = "black",
                              bins = 10,
                              fill = "white") +
      ggplot2::stat_function(fun = dnorm, args = list(mean = mean(filteredplot.df$Value), sd = sd(filteredplot.df$Value))) + labs(title = "Normality of residuals check", subtitle = "Normal curve and histogram should align")
    
    qqplot = ecis_polish_plot(qqplot)
    normaloverlayplot = ecis_polish_plot(normaloverlayplot)
    
    p1<-ggplot(fit, aes(.fitted, .resid))+geom_point()
    p1<-p1+stat_smooth(method="loess")+geom_hline(yintercept=0, col="red", linetype="dashed")
    p1<-p1+xlab("Fitted values")+ylab("Residuals")
    p1<-p1+ggtitle("Residual vs Fitted Plot")+theme_bw()
    p1 = p1 + labs(title = "Homogeneity of Variances test",
           subtitle = paste("Levene's Test, F=", f, ", P=", f, ",", pass))
    
    overallplot = ecis_polish_plot(overallplot)
    p = ecis_polish_plot(p)
    timeplot = ecis_polish_plot(timeplot)
    p1 = ecis_polish_plot(p1)
    
    differences = ecis_plot(data.df, unit = unit, frequency = frequency, time = time, replication = "summary", confidence = 0.949999)
    
    ##normcheck = grid.arrange(qqplot, normaloverlayplot, ncol = 2)
    
    ##checks = grid.arrange(overallplot,timeplot,qqplot, normaloverlayplot, p1, ecis_polish_plot(differences), ncol = 2)
    
    ##overall = grid.arrange(checks, differences)
    
   grid =  plot_grid(arrangeGrob(timeplot, overallplot, ncol = 2),
             arrangeGrob(qqplot, normaloverlayplot, p1, ncol = 3),
              arrangeGrob(differences, nrow = 1),
              nrow = 3, rel_heights = c(1/4, 1/4, 1/2)) 
    
    
    print(anova(fit))
    fit <- aov(Value ~ Experiment + Sample, data = dat)
    print ("");
    print ("");
    print(TukeyHSD(fit))
    
    return(grid)
    #multiplot = grid_arrange_shared_legend(plot, plot2)
    #return(multiplot)
}

#' Make a dataframe of what is statistically significant
#'
#' @param data.df The dataframe to analyse
#' @param time The time to analyse
#' @param unit The unit to analyse
#' @param frequency The frequency to analyse
#' @param confidence The confidence level to analyse - default is 0.95
#' @param format The format to return the data frame in
#' 
#' @importFrom stats aov lm TukeyHSD symnum
#' @importFrom data.table setDT
#' @importFrom tidyr separate
#' @importFrom stringr str_c
#' @importFrom magrittr "%>%"
#'
#' @return A table of what is significant
#' @export
#'
#' @examples
#' 
#' ecis_make_significance_table(growth.df, 50, "R", 4000, 0.95)
#' ecis_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data")
#' 
#' 
ecis_make_significance_table = function(data.df, time, unit, frequency, confidence = 0.95, format = "toplot")
{
  
  data = ecis_subset(data.df, time = time, unit = unit, frequency = frequency)
  
  
  
  # What is the effect of the treatment on the value ?
  model=lm(data$Value ~ data$Experiment + data$Sample)
  ANOVA=aov(model)
  
  # Tukey test to study each pair of treatment :
  TUKEY <- TukeyHSD(x=ANOVA,conf.level=0.95)
  
  # Tuckey test representation :, shouldn't be included here
  #plot(TUKEY , las=1 , col="brown")
  
  # Extract labels and factor levels from Tukey post-hoc 
  Tukey.levels <- TUKEY[["data$Sample"]][,4] # pull out the tukey significance levels
  Tukey.labels <- data.frame(Tukey.levels)
  
  
  Tukey.labels = setDT(Tukey.labels, keep.rownames = TRUE)[]
  
  Tukey.labels = Tukey.labels %>% separate(rn, c("A", "B"), sep = "-")
  
  Tukey.labels$Significance <- symnum(Tukey.labels$Tukey.level, corr = FALSE, na = FALSE, 
                                      cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                                      symbols = c("***", "**", "*", ".", " "))
  
  if (format == "Tukey_data")
  {
 
  return(Tukey.labels)
  }
  else if (format == "toplot")
  {
  # Reformat for graphics
  Tukey.labels = subset(Tukey.labels, Tukey.levels<(1-confidence))
  
  #Generate a list of all the row names
  alllabels = c(Tukey.labels$A, Tukey.labels$B)
  alllabels = unique(alllabels)
  
  sources = c()
  sinks = c()
  
  Tukey.labels$Asig = paste(Tukey.labels$A, Tukey.labels$Significance)
  Tukey.labels$Bsig = paste(Tukey.labels$B, Tukey.labels$Significance)
  
  for(label in alllabels)
  {
    source = (label)
    sink = (c(subset(Tukey.labels, A == label)$Bsig,subset(Tukey.labels, B == label)$Asig))
    sink = str_c(sink, collapse = "\n")
    sources = append(sources, source)
    sinks = append(sinks, sink)
    
  }
  
  labeltable = data.frame("Sample" = sources, "Label" = sinks)
  return(labeltable)
  }
  else
  {
    warning("Unknown output format. Check and try again")
  }
  
}

# Summary function --------------------------------------------------------

#' Summarise ECIS datasets from a single experiment
#' 
#' Creates and ECIS dataset that has had all samples of the same type averaged together. Assumes that each sample is independent, IE that this function has already been run on individual experiments
#'
#' @param data.df An ECIS dataset in standard format
#' @param level The level of replication to generate the summary at. Options are "experiment" or "summary"
#'
#' @return An ECIS dataset supplimented with summary statistics
#' 
#' @export
#' @importFrom dplyr summarise group_by n
#' @importFrom magrittr "%>%"
#'
#' @examples
#' 
#' ecis_summarise(growth.df)
#' ecis_summarise(growth.df, "experiments")
#' ecis_summarise(growth.df, "wells")
#' 
#' 
#' exploded.df = ecis_explode(growth.df)
#' 
ecis_summarise <- function(data.df, level = "summary") {
  
  # Use a test to check what the current summary level of the data is
  summary_level = ecis_test_summary_level(data.df)
  
  # Don't run the calculation if summary level is already reached
  if(level == summary_level)
  {
    warning("Function not required, the data frame is already at that level")
    return (data.df)
  }
  
  # If possible, make experimental resolution
  
  if(summary_level == "wells")
  {
  experiment.df = data.df %>%
    group_by(Time, Unit, Frequency, Sample, Experiment, Instrument) %>%
    summarise(sd = sd(Value), n = n(),sem = sd/sqrt(n), Well = "Z00",Value = mean(Value))
  }else if(summary_level == "experiments")
  {
    experiment.df = data.df
  }
  
  # If possible, make summary resolution
  
  if (summary_level == "experiments" || summary_level == "wells")
  {
    summary.df = experiment.df %>%
      group_by(Time, Unit, Frequency, Sample, Instrument) %>%
      summarise(sd = sd(Value), totaln = sum(n), n = n(), Well = "Z00", sem = sd/sqrt(n), Value = mean(Value), Experiment = "Summary")
  }
  else
  {
    warning ("Can't determine summary level, check data frame integrity")
    return ("NA")
  }

  
  if(level == "summary" && exists ("summary.df"))
  {
    return(summary.df)
  }else if(level == "experiments" && exists ("experiment.df"))
  {
    return(experiment.df)
  }else
  {
    warning("Invalid level requested. Please check level is valid and you have presented a data frame that has a higher resolution than the summary you have requested")
    return("NA")
  }
  
}

