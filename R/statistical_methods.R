# // This file contains the statistical data analyasis

#' ANOVA analyasis of a single ECIS timepoint
#' 
#' This function takes a standard ECIS dataset and runs two way ANOVA on it. It then runs a post-hoc test to determine which groups are significatnly difference. Results are printed to the console as text.
#' 
#' 
#' This analyasis requires multiple experiments, as working out the differences in a single experiment is a terrible idea (statisticaly speaking).
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
    
    # Cut the dataset down to a useable size (IE, )
    filtered.df = data.df
    filtered.df = subset(filtered.df, Time == timetouse)
    filtered.df = subset(filtered.df, Unit == unit)
    filtered.df = subset(filtered.df, Frequency == frequency)
    
    print(filtered.df)
    
    # Run a basic ANOVA
    dat = filtered.df
    hist(dat$Value)
    fit <- lm(Value ~ Experiment + Sample, data = dat)
    s20x::normcheck(fit, s = TRUE)
    print(anova(fit))
    fit <- aov(Value ~ Experiment + Sample, data = dat)
    print(TukeyHSD(fit))
    
    
}




