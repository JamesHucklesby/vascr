# # This file contains the statistical data analyasis
# 
# # ANOVA analyasis of a single ECIS timepoint
# #
# # This function takes a standard ECIS dataset and runs two way ANOVA on it based on the variaiton between treatments and experiments. It then runs a post-hoc test to determine which pairs of groups are statistically different. Results are printed to the console as text.
# #
# #
# # This analyasis requires multiple experiments, as working out the differences in a single experiment is not a good idea because it does not account for experimental variaiton, making the analyasis weaker and more unreliable as results may not be repeatable.
# #
# # Firstly, a histogram is generated for a visual check of the data. This should mimic what you are expecting.
# #
# # To interpret the data first check that the data is roughly linear on the Shapiro-Wilk normailty graph,and that the p<0.05. This is more important for smaller datasets, and becomes irrelevant once n>9. Therefore you can be relativley non-stringent when applying this test to three independent experiments, where each experiment had triplicates. Also check that the residuals on the right hand graph are roughly normal, this is easier for larger datasets.
# #
# #
# # @param data.df A standard ECIS dataset.
# # @param unit Unit to be analysed.
# # @param frequency Frequency to be used. All modeled units have a frequency of 0.
# # @param time  Time to be used.
# #
# # @return ANOVA results printed to the console.
# #
# # @importFrom graphics hist
# # @importFrom stats lm anova aov TukeyHSD residuals shapiro.test
# # @importFrom ggpubr ggqqplot
# # @importFrom ggplot2 geom_density geom_rug position_jitter geom_histogram geom_vline geom_boxplot stat_smooth geom_hline ggtitle xlab ylab position_stack
# # @importFrom car leveneTest
# # @importFrom cowplot plot_grid
# # @importFrom gridExtra arrangeGrob
# # @importFrom tidyr drop_na
# #
# # @export
# #
# # @examples
# # #vascr_plot_anova(growth.df, unit = 'R', frequency = 4000,time = 50)
# #
# #
# vascr_plot_anova = function(data.df, unit, frequency, time, visualisation = NULL, priority = NULL, ...) {
# 
#     dots = list(...)
# 
#     # Round the number given to the function to the nearest actual measurement
#     timetouse = vascr_find_time(data.df, time)
# 
#     # Cut the dataset down to a useable size (IE, only pull out the timepoint we want to analyse)
# 
#     filtered.df = data.df
#     filtered.df = vascr_subset(filtered.df, unit = unit, frequency = frequency)
# 
#     if(is.null(visualisation) || visualisation == "line")
#     {
#     timeplot = vascr_plot_line(data.df, unit = unit, frequency = frequency, title = "Time Selected", level = "summary")
#     timeplot = timeplot + geom_vline(xintercept = timetouse, color = "blue")
#     timeplot = timeplot + labs(title = "Timepoint selected")
#     timeplot = do.call_relevant("vascr_polish_plot", timeplot, dots)
# 
#     if(!is.null(visualisation))
#     {
#       return(timeplot)
#     }
# 
#     }
# 
#     # Further subset and recondition data
#     filtered.df = vascr_subset(filtered.df, time = timetouse)
# 
#     if(!vascr_test_exploded(filtered.df))
#     {
#     exploded = vascr_explode(filtered.df)
#     }
#     else
#     {
#       exploded = filtered.df
#     }
# 
#     imploded = vascr_implode(exploded, stripidentical = TRUE)
# 
#     if (is.null(visualisation) || visualisation == "replicates")
#     {
#     imploded$Sample = vascr_factorise_and_sort(imploded$Sample)
#     overallplot <- ggplot(imploded, aes(x=Sample, y=Value, color = Experiment)) +
#       geom_boxplot() + labs(title = "Replicate data")
# 
#     if(!is.null(visualisation))
#     {
#       return(overallplot)
#     }
#     }
# 
#     # Calculate priority, as this will be important later
#     priority = vascr_priority(data = filtered.df, explicit = "Value", priority = priority)
# 
#     if(length(priority)>2)
#     {
#       warning("Priority is >2 values in lengh. Using the first two. The list is:", priority)
#     }else if (priority<2)
#     {
#       ## TODO One Way
#       error("Priority must be at least 2 values long for a 2 way ANOVA. One way not yet supported")
#     }
# 
#     # Run a basic ANOVA, normcheck and Tukey's HSD
#     dat = filtered.df
#     formula = paste("Value ~ ",priority[[1]]," + ", priority[[2]])
#     fit <- lm(formula, data = dat)
# 
#     aov_residuals <- residuals(object = fit)
# 
#     # Generate qqplot
#     qqplot = ggqqplot(aov_residuals)
#     shapirotest = shapiro.test(aov_residuals)
#     shapirow = round(shapirotest$statistic[[1]],3)
#     shapirop = round(shapirotest$p,3)
# 
#     if(shapirop>0.05)
#     {
#       passes = "Pass"
#     }else
#     {
#       passes = "Fail"
#     }
# 
#     qqplot = qqplot + labs(title = "Normality test", subtitle = paste("Shapiro-Wilk, W=", shapirow, ", P=", shapirop, ",", passes))
#     qqplot = vascr_polish_plot(qqplot)
# 
# 
# 
#     # Normality overlay
#     filtered.df$residuals <- residuals(fit)
#     filteredplot.df = filtered.df
#     filteredplot.df$Value = filtered.df$residuals
# 
#     normaloverlayplot = ggplot2::ggplot(filteredplot.df, aes(x = Value)) +
#       ggplot2::geom_histogram(aes(y =..density..),
#                               colour = "black",
#                               bins = 10,
#                               fill = "white") +
#       ggplot2::stat_function(fun = dnorm, args = list(mean = mean(filteredplot.df$Value), sd = sd(filteredplot.df$Value))) + labs(title = "Normality of residuals check", subtitle = "Normal curve and histogram should align")
# 
# 
#     normaloverlayplot = vascr_polish_plot(normaloverlayplot)
# 
#     # Homogenicity of variances
# 
#     leveneformula = paste("Value ~ ",priority[[1]]," * ", priority[[2]])
#     modeltest = lm(leveneformula, data = dat)
#     levenetest = leveneTest(modeltest)
# 
#     f = round(levenetest$`F value`[1],3)
#     p = round(levenetest$`Pr(>F)`[1],3)
# 
#     if(p>0.05)
#     {
#       pass = "Pass"
#     }else
#     {
#       pass = "Fail"
#     }
# 
#     p1<-ggplot(fit, aes(.fitted, .resid))+geom_point()
#     p1<-p1+stat_smooth(method="loess", formula = 'y ~ x')+geom_hline(yintercept=0, col="red", linetype="dashed")
#     p1<-p1+xlab("Fitted values")+ylab("Residuals")
#     p1<-p1+ggtitle("Residual vs Fitted Plot")+theme_bw()
#     p1 = p1 + labs(title = "Homogeneity of Variances test",
#            subtitle = paste("Levene's Test, F=", f, ", P=", p, ",", pass))
#     p1 = vascr_polish_plot(p1)
# 
# 
#     differences = vascr_plot_bar(data.df, unit = "R", time = 100, frequency = 4000, confidence = 0.0499)
# 
# 
#    grid =  plot_grid(arrangeGrob(timeplot, overallplot, ncol = 2),
#              arrangeGrob(qqplot, normaloverlayplot, p1, ncol = 3),
#               arrangeGrob(differences, nrow = 1),
#               nrow = 3, rel_heights = c(1/4, 1/4, 1/2))
# 
#     return(grid)
# }

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
#' @keywords internal
#'
#' @examples
#' #vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95)
#' #vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data")
#' 
vascr_make_significance_table = function(data.df, time, unit, frequency, confidence = 0.95, format = "toplot")
{
  
  data = vascr_subset(data.df, time = time, unit = unit)
  
  vascr_find_frequency(data.df, 4000)
  
  
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

