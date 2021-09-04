#' Prep data for statistical analyasis
#'
#' @param data.df The dataset to analyse
#' @param unit The unit to analyse
#' @param frequency Frequency to use
#' @param time  Timepoint to use
#'
#' @return A conditioned vascr dataset
#' @keywords internal
#'
#' @examples
#' #vascr_prep_statdata(growth.df, "R", 4000, 100)
#' 
vascr_prep_statdata = function(data.df, unit, frequency, time)
{
# Round the number given to the function to the nearest actual measurement
timetouse = vascr_find_time(data.df, time)

# Cut the dataset down to a useable size (IE, only pull out the timepoint we want to analyse)
filtered.df = data.df
filtered.df = vascr_subset(filtered.df, unit = unit, frequency = frequency, time = timetouse, remake_name = FALSE)

return(filtered.df)
}


#' Prep priority for statistical data
#'
#' @param data.df The dataset to use
#' @param priority Manual priority (if set)
#'
#' @return A priority list for use in a vascr dataset
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_prep_stat_priority(growth.df)
vascr_prep_stat_priority = function(data.df,priority = NULL)
{
  priority = vascr_priority(data = data.df, explicit = "Value", priority = priority)
  
 if (length(priority)<2)
  {
    ## TODO One Way
    error("Priority must be at least 2 values long for a 2 way ANOVA. One way not yet supported")
  }
  return(priority)
}


#' Generate an anova formula
#'
#' @param priority The priority to use
#'
#' @return An ANOVA formula
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_formula(c("cells","well"))
vascr_formula = function(priority)
{
  formula = paste(priority[[1]]," ~ ",priority[[3]]," + ", priority[[2]])
  return(formula)
}

#' Generate a linear model of vascr data
#'
#' @param data.df the dataset to use
#' @param unit Unit to select
#' @param frequency Frequency to select
#' @param time Time to select
#' @param priority override the default vascr priority list
#'
#' @return A linear model object
#' 
#' @keywords internal
#' 
#' @importFrom stats lm
#'
#' @examples
#' # vascr_lm(growth.df, "R", 4000, 100)
#' 
vascr_lm = function(data.df, unit, frequency, time, priority = NULL)
{
  data.df = vascr_prep_statdata(data.df = data.df, unit = unit, frequency = frequency, time = time)
  
  priority = vascr_priority(data.df, priority)
  
  formula = vascr_formula(priority)
  print(formula)
  
  fit <- lm(formula, data = data.df)
  return(fit)
}

#' Generate the residuals from a vascr linear model
#'
#' @param data.df the dataset to model
#' @param unit the unit to generate data from
#' @param frequency Frequency to model
#' @param time Time point to model
#' @param priority Priority to model
#'
#' @return A data frame of residuals
#' 
#' @importFrom stats residuals
#' 
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_residuals(growth.df, "R", "4000", 100)
#' 
vascr_residuals = function(data.df, unit, frequency, time, priority = NULL)
{
  model = vascr_lm(data.df, unit, frequency, time, priority)
  aov_residuals <- residuals(object = model)
  return(aov_residuals)
}

#' Generate a qq plot and shapiro test from a vascr data frame
#'
#' @param data.df vascr dataset to use
#' @param unit Unit to return
#' @param frequency Frequency to return
#' @param time Timepoint to use
#' @param priority vascr priority list for analyasis, if blank default will be used
#' 
#' @importFrom ggpubr ggqqplot
#' @importFrom stats shapiro.test
#' @importFrom ggplot2 labs
#'
#' @return A ggpubr ggqqplot object
#' @keywords internal
#'
#' @examples
#' # vascr_plot_qq(growth.df, "R", 4000, 100)
#' 
vascr_plot_qq = function(data.df, unit, frequency, time, priority = NULL)
{
  aov_residuals = vascr_residuals(data.df, unit, frequency, time, priority)
  
  qqplot = ggqqplot(aov_residuals)
  
  shapirotest = vascr_shapiro(data.df, unit, frequency, time, priority)
  shapirow = round(shapirotest$statistic[[1]],3)
  shapirop = round(shapirotest$p,3)
  
  if(shapirop>0.05)
  {
    passes = "Pass"
  }else
  {
    passes = "Fail"
  }
  
  qqplot = qqplot + labs(title = "Normality test", subtitle = paste("Shapiro-Wilk, W=", shapirow, ", P=", shapirop, ",", passes))
  qqplot = vascr_polish_plot(qqplot)
  return(qqplot)
}

#' Plot a shapiro test
#'
#' @param data.df vascr dataset to analyse
#' @param unit Unit to plot
#' @param frequency Frequency to plot
#' @param time Time to plot
#' @param priority Vascr priority list
#'
#' @return A shapiro test of the selected data
#' @keywords internal
#'
#' @examples
#' # vascr_shapiro(growth.df, "R", 4000, 100)
#' 
vascr_shapiro = function(data.df, unit, frequency, time, priority = NULL)
{
  aov_residuals = vascr_residuals(data.df, unit, frequency, time, priority)
  shapirotest = shapiro.test(aov_residuals)
  return(shapirotest)
}


#' Plot rediduals overlaid with a normal curve
#'
#' @param data.df The dataset to plot
#' @param unit  Unit to plot
#' @param frequency Frequency to plot
#' @param time Time to plot
#' @param priority Vascr priority list, will use the default if available
#' 
#' @importFrom ggplot2 stat_function ggplot geom_histogram aes
#'
#' @return a ggplot with rediduals overlaid by a normal curve
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_plot_normality(growth.df, "R", 4000, 100)
#' 
vascr_plot_normality = function(data.df, unit, frequency, time, priority = NULL)
{
  data = vascr_prep_statdata(data.df, unit, frequency, time)
  aov_residuals = vascr_residuals(data, unit, frequency, time, priority)
  
  filtered.df = data
  filtered.df$residuals <- aov_residuals
  filteredplot.df = filtered.df
  filteredplot.df$Value = filtered.df$residuals
  
  normaloverlayplot = ggplot(filteredplot.df, aes(x = Value)) + 
    geom_histogram(aes(y =..density..),
                            colour = "black",
                            bins = 10,
                            fill = "white") +
    stat_function(fun = dnorm, args = list(mean = mean(filteredplot.df$Value), sd = sd(filteredplot.df$Value))) + labs(title = "Normality of residuals check", subtitle = "Normal curve and histogram should align", y="Density")
  
  normaloverlayplot = vascr_polish_plot(normaloverlayplot)
  return(normaloverlayplot)
}

#' Run a Levene's test of normailty on a vascr dataset
#' 
#' Runs a test for homogenicity of variance, to ensure that the conditions of an ANOVA are met. Built into anova plotting functions and anova summary.
#'
#' @param data.df vascr dataset to analyse
#' @param unit unit to plot
#' @param frequency frequency to plot
#' @param time time to plot
#' @param priority vascr priority list
#' 
#' @importFrom car leveneTest
#' @importFrom stats lm
#'
#' @return A Levene Test object
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_levene(growth.df, "R", 4000, 100)
#' 
vascr_levene = function(data.df, unit, frequency, time, priority = NULL)
{
  data.df = vascr_prep_statdata(data.df, unit, frequency, time)
  fpriority = vascr_priority(data.df, priority)
  
  leveneformula = paste("Value ~ ",fpriority[[2]]," * ", fpriority[[3]])
  modeltest = lm(leveneformula, data = data.df)
  levenetest = leveneTest(modeltest)
  
  return(levenetest)
}

# 

#' Plot the results of a Levene's test with a fitted variables and residuals plot
#'
#' @param data.df a vascr dataset
#' @param unit Unit to analyse
#' @param frequency Frequency to analyase
#' @param time Time to analyse
#' @param priority A vascr list of priorities. If left blank default will be used.
#' 
#' @importFrom ggplot2 ggplot xlab ylab labs stat_smooth geom_hline geom_point
#'
#' @return A ggplot of a levene's test and the underlying data analysed
#' @keywords internal
#'
#' @examples
#' # vascr_plot_levene(growth.df, "R", 4000, 100)
#' 
#' 
vascr_plot_levene = function(data.df, unit, frequency, time, priority = NULL)
{
  
  levenetest = vascr_levene(data.df, unit, frequency, time, priority)
  
  f = round(levenetest$`F value`[1],3)
  p = round(levenetest$`Pr(>F)`[1],3)
  
  if(p>0.05)
  {
    pass = "Pass"
  }else
  {
    pass = "Fail"
  }
  
  fit = vascr_lm(data.df, unit, frequency, time, priority)
  
  p1<-ggplot(fit, aes(.fitted, .resid))+geom_point()
  p1<-p1+stat_smooth(method="loess", formula = 'y ~ x')+geom_hline(yintercept=0, col="red", linetype="dashed")
  p1<-p1+xlab("Fitted values")+ylab("Residuals")
  p1 = p1 + labs(title = "Homogeneity of Variances test",
                 subtitle = paste("Levene's Test, F=", f, ", P=", p, ",", pass))
  p1 = vascr_polish_plot(p1)
  
  return(p1)
}

#' Plot a line graph with a vertical line on it
#'
#' @param data.df A vascr dataset
#' @param unit Unit to plot
#' @param frequency Frequency to plot
#' @param time Time to plot
#' @param priority Vascr priority list. Blank will use the baked in default.
#' @param ... Other arguements to be passed on to vascr_plot_line
#'
#' @importFrom ggplot2 geom_vline
#'
#' @return A ggplot2 object
#' @keywords internal
#'
#' @examples
#' # vascr_plot_time_vline(growth.df, "R", 4000, 100)
#' 
vascr_plot_time_vline = function(data.df, unit, frequency, time, priority = NULL)
{
  
  # Round the number given to the function to the nearest actual measurement
   timetouse = vascr_find_time(data.df, time)
  
  
    dataset = vascr_prep_graphdata(data.df,unit = unit, frequency = frequency, level = "summary")
    timeplot = vascr_plot_line(dataset)
    timeplot = timeplot + geom_vline(xintercept = timetouse, color = "blue")
    timeplot = timeplot + labs(title = "Timepoint selected")
    timeplot = vascr_polish_plot(timeplot)
  
    return(timeplot)
}


#' Plot replicate data sets as a box plot
#'
#' @param data.df The dataset to plot
#' @param unit Unit to plot
#' @param frequency Frequency to plot
#' @param time Time to plot
#' @param priority vascr priority, if empty default will be used
#' 
#' @importFrom ggplot2 ggplot aes geom_boxplot labs
#' @importFrom stringr str_replace_all
#'
#' @return A ggplot2 box plot of replicate experiments
#' @keywords internal
#'
#' @examples
#' # vascr_plot_box_replicate(growth.df, "R", 4000, 100)
#' 
vascr_plot_box_replicate = function(data.df, unit, frequency, time, priority = NULL)
{
  
  data = vascr_prep_statdata(data.df, unit, frequency, time)
  fpriority = vascr_priority(data, priority)
  
  data$Sample = str_replace_all(data$Sample, "\\+", "\\\n")
  data$Sample = vascr_factorise_and_sort(data$Sample)
  
 overallplot <- ggplot(data, aes_string(x=fpriority[2], y="Value", color = fpriority[3])) + 
  geom_boxplot() + labs(title = "Replicate data")

return(overallplot)
}


#' Make a display with all the anova analyasis pre-conducted
#'
#' @param data.df vascr dataset to plot
#' @param unit unit to plot
#' @param frequency frequnecy to plot
#' @param time timepoint to plot at
#' @param priority analyasis priority. Will use default if not filled in.
#' @param ... other controls to be pushed to publish plot and generate graphdata
#'
#' @return A matrix of different ANOVA tests
#' 
#' @importFrom cowplot plot_grid
#' 
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_plot_anova(data.df = growth.df, unit = "R", frequency = 4000, time = 100)
#' 
vascr_plot_anova = function(data.df, unit, frequency, time, priority = NULL, ...)
{
  
timeplot = vascr_plot_time_vline(data.df, unit, frequency, time, priority)
overallplot = vascr_plot_box_replicate(data.df, unit, frequency, time, priority)

qqplot = vascr_plot_qq(data.df, unit, frequency, time, priority)
normaloverlayplot = vascr_plot_normality(data.df, unit, frequency, time, priority)
leveneplot = vascr_plot_levene(data.df, unit, frequency, time, priority)

differences = vascr_plot_bar_anova(data.df, unit = unit, time = time, frequency = frequency, confidence = 0.95, priority = NULL)

grid =  plot_grid(arrangeGrob(timeplot, overallplot, ncol = 2),
                  arrangeGrob(qqplot, normaloverlayplot, leveneplot, ncol = 3),
                  arrangeGrob(differences, nrow = 1),
                  nrow = 3, rel_heights = c(1/4, 1/4, 1/2))

return(grid)
}

#' Generate a tukey analyasis of vascr data
#'
#' @param data.df The dataset to analyse
#' @param unit Unit to analyse
#' @param frequency Frequency to analyse
#' @param time Time to analyse
#' @param priority Priority of units for statistical analyasis
#' @param raw If true, a non-processed form of the tukey results will be returned
#' 
#' @importFrom dplyr arrange
#'
#' @return A table or Tukey HSD test result
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_tukey(growth.df, "R", 4000, 100)
#' # vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE)
#' 
vascr_tukey = function(data.df, unit, frequency, time, priority = NULL, raw = FALSE)
{
  if(raw)
  {
  sigtable = vascr_make_significance_table(data.df, time, unit, frequency, 1, format = "Tukey_data")
  }
  else
  {
  sigtable = vascr_make_significance_table(data.df, time, unit, frequency, 1, format = "Tukey_data")
  sigtable = arrange(sigtable, "Tukey.levels")
  }
  
  return(sigtable)
}


#' Run a standard panel of ANOVA tests and return the results in text format
#'
#' @param data.df  The dataset to analyse
#' @param unit Unit to analyse
#' @param frequency Frequency to analyse
#' @param time Time to analyse
#' @param priority Priority list of variables to run tests on
#' 
#' @importFrom stats anova
#' @importFrom car Anova
#' 
#' @keywords internal
#'
#' @return Prints out the summary data for an ANOVA analysis
#'
#' @examples
#' #vascr_summarise_anova(growth.df, "R", 4000, 100)
#' 
vascr_summarise_anova = function(data.df, unit, frequency, time, priority = NULL)
{
  data21.df = vascr_prep_statdata(data.df, unit, frequency, time)
  filledpriority = vascr_priority(data = data21.df, priority)
  
  model = vascr_formula(filledpriority)
  
  newlm = lm(Value~ Experiment + Sample,
             contrasts=list(Sample='contr.sum', Experiment ='contr.sum'), data = data21.df)

  newanova = Anova(newlm, type='III')
  
  # 
   # fit.lm2<- aov(Value~Sample + Experiment, data = data21.df)  
   # thsd<-TukeyHSD(fit.lm2)
  
  
  lm = vascr_lm(data21.df, unit, frequency, time, priority)
  anova = anova(lm)
  
  tukey =  vascr_tukey(data21.df, unit, frequency, time, priority, raw = TRUE)
  levene = vascr_levene(data21.df, unit, frequency, time, priority)
  shapiro = vascr_shapiro(data21.df, unit, frequency, time, priority)
  
  print(data21.df)
  print(filledpriority)
  print(model)
  print(newanova)
  print(levene)
  print(shapiro)
  print(tukey)
}












