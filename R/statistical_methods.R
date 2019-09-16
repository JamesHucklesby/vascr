# // This file contains the statistical data analyasis

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
#' ecis_ANOVA(ECISR::data.df, 'Rb',0,75)
#' 
ecis_ANOVA = function(data.df, unit, frequency, time, posthoc = "bonferoni") {
    
    # Round the number given to the function to the nearest actual measurement
    timetouse = ecis_roundtime(data.df, time)
    
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
#' ecis_summarise(data.df)
#' 
ecis_summarise <- function(data.df) {
  
  average.df = summarise(group_by(data.df, 'Sample', 'Time', 'Unit', 'Frequency'), sd = sd(Value), n = n(), sem = sd/sqrt(n), Value = mean(Value))
  
  average.df$Experiment = "Derrivative"
  return(average.df)
  
}