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
#' @param posthoc Post hoc test to use. Options include Tukey. More to be added in the future.
#'
#' @return ANOVA results printed to the console.
#' 
#' @importFrom graphics hist
#' @importFrom stats lm anova aov TukeyHSD
#' @importFrom s20x normcheck 
#' 
#' 
#' @export
#'
#' @examples
#' ecis_ANOVA(growth.df, 'Rb',0,75)
#' 
ecis_ANOVA = function(data.df, unit, frequency, time, posthoc = "bonferoni") {
    
    # Round the number given to the function to the nearest actual measurement
    timetouse = ecis_find_time(data.df, time)
    
    # Cut the dataset down to a useable size (IE, only pull out the timepoint we want to analyse)
    #FUTURE: Impliment this off the back of ecis_subset
    
    filtered.df = data.df
    filtered.df = subset(filtered.df, Time == timetouse)
    filtered.df = subset(filtered.df, Unit == unit)
    filtered.df = subset(filtered.df, Frequency == frequency)
    
    # Run a basic ANOVA, normcheck and Tukey's HSD
    dat = filtered.df
    hist(dat$Value)
    fit <- lm(Value ~ Experiment + Sample, data = dat)
    s20x::normcheck(fit, s = TRUE)
    print(anova(fit))
    fit <- aov(Value ~ Experiment + Sample, data = dat)
    print ("");
    print ("");
    print(TukeyHSD(fit))
    
    
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
#' @importFrom stats aov lm TukeyHSD
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
  model=lm( data$Value ~ data$Sample )
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
  
  if (format == "Tukey_data")
  {
    
 Tukey.labels$Significance <- symnum(Tukey.labels$Tukey.level, corr = FALSE, na = FALSE, 
            cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
            symbols = c("***", "**", "*", ".", " "))
 
  return(Tukey.labels)
  }
  else if (format == "toplot")
  {
  # Reformat for graphics
  Tukey.labels = subset(Tukey.labels, Tukey.levels<0.05)
  
  #Generate a list of all the row names
  alllabels = c(Tukey.labels$A, Tukey.labels$B)
  alllabels = unique(alllabels)
  
  sources = c()
  sinks = c()
  
  for(label in alllabels)
  {
    source = (label)
    sink = (c(subset(Tukey.labels, A == label)$B, subset(Tukey.labels, B == label)$A))
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
#'
#' @return An ECIS dataset supplimented with summary statistics
#' 
#' @export
#' @importFrom dplyr summarise
#'
#' @examples
#' 
#' ecis_summarise(growth.df)
#' 
ecis_summarise <- function(data.df) {
  
  average.df = summarise(group_by(data.df, 'Sample', 'Time', 'Unit', 'Frequency'), sd = sd(Value), n = n(), sem = sd/sqrt(n), Value = mean(Value))
  
  average.df$Experiment = "Derrivative"
  return(average.df)
  
}