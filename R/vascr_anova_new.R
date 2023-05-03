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
#' #vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95)
#' #vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data")
#' 
vascr_make_significance_table = function(data.df, time, unit, frequency, priority, confidence = 0.95, format = "toplot")
{
  
  data.df = vascr_subset(data.df, unit = unit, time = time, frequency = frequency, remake_name = FALSE)
  
  data.df$Sample = str_replace(data.df$Sample, "-", "~")
  
  data.df = ungroup(data.df)
  
  # What is the effect of the treatment on the value ?
  lm = vascr_lm(data.df, unit, frequency, time)
  
  data.df$Sample = factor(data.df$Sample, unique(data.df$Sample))
  ANOVA = Anova(lm, type = "III")
  
  
  # Tukey test to study each pair of treatment :
  tukeyanova = aov(lm)
  TUKEY <- TukeyHSD(x=tukeyanova)
  
  # Tuckey test representation :, shouldn't be included here
  #plot(TUKEY , las=1 , col="brown")
  
  # Extract labels and factor levels from Tukey post-hoc 
  Tukey.levels <- TUKEY[[2]][] # pull out the tukey significance levels
  Tukey.labels <- data.frame(Tukey.levels)
  
  Tukey.labels$Samplepair = rownames(Tukey.labels)
  
  Tukey.labels = Tukey.labels %>% separate(Samplepair, c("A", "B"), sep = "-")
  
  Tukey.labels$Tukey.level = Tukey.labels$p.adj
  
  Tukey.labels$Significance <- symnum(Tukey.labels$Tukey.level, corr = FALSE, na = FALSE, 
                                      cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                                      symbols = c("***", "**", "*", ".", " "))
  
  if (format == "Tukey_data")
  {
    
    return(Tukey.labels)
  }
  else if (format == "toplot")
  {
    
    #Generate a list of all the row names
    alllabels = c(Tukey.labels$A, Tukey.labels$B)
    alllabels = unique(data.df$Sample) %>% as.character()
    
    # Reformat for graphics
    # Tukey.labels = subset(Tukey.labels, Tukey.levels<(1-confidence))
    
    
    
    sources = c()
    sinks = c()
    
    Tukey.labels$Asig = paste(Tukey.labels$A, Tukey.labels$Significance)
    Tukey.labels$Bsig = paste(Tukey.labels$B, Tukey.labels$Significance)
    
    for(label in alllabels)
    {
      sink1 = subset(Tukey.labels, B == label) %>% mutate(samp = A, lab = Asig, source = B) %>% select(samp, lab, source)
      sink2 = subset(Tukey.labels, A == label) %>% mutate(samp = B, lab = Bsig, source = A) %>% select(samp, lab, source)
      sink = rbind(sink1, sink2)
      sink = sink %>% mutate(samp = factor(samp, alllabels)) %>% arrange(samp) %>% mutate(samp = as.character(samp))
      sinktext = str_c("",sink$lab, collapse = "\n")
      sources = append(sources, unique(sink$source))
      sinks = append(sinks, sinktext)
      
    }
    
    labeltable = data.frame("Sample" = alllabels, "Label" = sinks)
    
    labeltable
    
    return(labeltable)
  }
  else
  {
    warning("Unknown output format. Check and try again")
  }
  
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
  data.df = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  
  priority = vascr_priority(data.df, priority)
  
  formula = "Value ~ Experiment + Sample"
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
  
  qqplot = qqplot + labs(title = "C) Normality test", subtitle = paste("Shapiro-Wilk, W=", shapirow, ", P=", shapirop, ",", passes)) +
    labs(x = "Theoretical quantiles", y = "Sample quantiles")
  
  qqplot
  
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
  data = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
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
    stat_function(fun = dnorm, args = list(mean = mean(filteredplot.df$Value), sd = sd(filteredplot.df$Value))) + labs(title = "D) Normality of residuals check", subtitle = "Normal curve and histogram should align", y="Density")
  
  normaloverlayplot
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
  data.df = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
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
  p1 = p1 + labs(title = "E) Homogeneity of Variances test",
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
#' @param ... Other arguments to be passed on to vascr_plot_line
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
  
  
    dataset = data.df %>% vascr_subset(unit = unit, frequency = frequency) %>%
      vascr_summarise("summary")
    timeplot = vascr_plot_line(dataset)
    
    timeplot
    
    timeplot = timeplot + geom_vline(xintercept = timetouse, color = "blue")
    timeplot = timeplot + labs(title = "A) Timepoint selected")
  
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
  
  data = vascr_subset(data.df, unit = unit, frequency = frequency, time = vascr_find_time(data.df, time))
  
  data$Sample = str_replace_all(data$Sample, "\\+", "\\\n")
  data$Sample = vascr_factorise_and_sort(data$Sample)
  
 overallplot <- ggplot(data, aes_string(x="Sample", y="Value", color = "Experiment")) + 
  geom_boxplot() + labs(title = "B) Replicate data") + 
   theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
   labs(y = vascr_titles(unique(data$Unit), unique(data$Frequency)))
 
 overallplot

return(overallplot)
}


#' Make a display with all the anova analysis pre-conducted
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
#' @importFrom ggtext element_markdown
#' 
#' @keywords internal
#'
#' @examples
#' 
#' # vascr_plot_anova(data.df = growth.df, unit = "R", frequency = 4000, time = 100)
#' 
vascr_plot_anova = function(data.df, unit, frequency, time, priority = NULL, ...)
{
  
timeplot = vascr_plot_time_vline(data.df, unit, frequency, time, priority) + labs(y = "Resistance  
                                                                                  (ohm, 4000 Hz)")


overallplot = vascr_plot_box_replicate(data.df, unit, frequency, time, priority) + labs(y = "Resistance  
                                                                                  (ohm, 4000 Hz)") + mdthemes::md_theme_grey() +
  scale_color_manual(values=c("orange", "blue", "green"))

qqplot = vascr_plot_qq(data.df, unit, frequency, time, priority)
normaloverlayplot = vascr_plot_normality(data.df, unit, frequency, time, priority)
leveneplot = vascr_plot_levene(data.df, unit, frequency, time, priority)

differences = vascr_plot_bar_anova(data.df, unit = unit, time = time, frequency = frequency, confidence = 0.95, priority = NULL) +
             theme(legend.position = "none") + labs(title = "G) ANOVA results", y = "Resistance   
                                                    (ohm, 4000 Hz)") + mdthemes::md_theme_grey() +
  theme(legend.position = "none")

tile = vascr_plot_anova_grid(data.df, unit, frequency, time)  + labs(title = "F) P values") +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) +
  theme(legend.position = "bottom") 

tile

grid =  plot_grid(arrangeGrob(timeplot, overallplot, ncol = 2),
                  arrangeGrob(qqplot, normaloverlayplot, leveneplot, ncol = 3),
                  arrangeGrob(tile, differences, nrow = 1, widths = c(0.3, 0.7)),
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
  data21.df = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  filledpriority = vascr_priority(data = data21.df, priority)
  
  formula = "Value ~ Experiment + Sample"
  
  newlm = lm(Value~ Experiment + Sample,
             contrasts=list(Sample='contr.sum', Experiment ='contr.sum'), data = data21.df)

  newanova = Anova(newlm, type='III')
  
  # 
   # fit.lm2<- aov(Value~Sample + Experiment, data = data21.df)  
   # thsd<-TukeyHSD(fit.lm2)
  
  
  # lm = vascr_lm(data21.df, unit, frequency, time, priority)
  # anova = anova(lm)
  
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



#' Title
#'
#' @param data.df 
#' @param unit 
#' @param frequency 
#' @param time 
#' 
#'
#' @return
#' @export
#'
#' @examples
vascr_plot_anova_grid = function (data.df, unit =  "R", frequency = 4000, time = 100)
{
  
  
  ggplotColours <- function(n = 6, h = c(0, 360) + 15){
    if ((diff(h) %% 360) < 1) h[2] <- h[2] - 360/n
    hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
  }
  
  pal = ggplotColours(8)

sigdata = vascr_make_significance_table(data.df, unit = unit, frequency = frequency, time = time, format = "Tukey_data")

sigdata2 = sigdata %>% mutate(temp = A, A = B, B = temp, temp = NULL) %>%
  rbind(sigdata)

sigplot = sigdata2 %>% mutate(A = factor(A,(unique(data.df$Sample)))) %>%
  mutate(Significance = cut(sigdata2$Tukey.level, breaks = c(0, 0.01, 0.05, 0.1, 1), 
                            labels = c("< 0.01", "<0.05", "< 0.1", "<1"))) %>%
  mutate(Significance = factor(Significance, c("< 0.01", "<0.05", "< 0.1", "<1"))) %>%
  mutate(B = factor(B, (unique(data.df$Sample)))) %>%
  ggplot() +
  geom_tile(aes(x = A, y = B, fill = Significance)) +
  labs(fill = "P value",
       x = "Treatment 1", y = "Treatment 2") +
  mdthemes::md_theme_gray() +
  theme(axis.text.x = element_markdown(angle = 90, vjust = 0.5, hjust=0.5))+
scale_fill_manual(values = c(pal[[5]], pal[[2]], pal[[3]], pal[[4]]),
              labels = c("< 0.01", "<0.05", "< 0.1", "<1"),
                    drop = FALSE)

  sigplot

return(sigplot)
}



#' Make a bar graph with ANOVA stars annotated against a set reference
#'
#' @param data.df a vascr dataframe
#' @param unit the unit to use
#' @param frequency the frequency to use
#' @param time the time to use for the bar plot and ANOVA
#' @param reference SampleID of the sample to use as the reference for statistical analysis
#' 
#' @importFrom mdthemes md_theme_gray
#'
#' @return
#' @export
#'
#' @examples
#' 
#' vascr_plot_anova_bar_reference(growth.df, "R", 4000, 48)
#' 
vascr_plot_anova_bar_reference = function(data.df, unit, frequency, time, reference = min(data.df$SampleID), breaklines = TRUE)
{

  if(!(reference %in% data.df$SampleID))
  {
    stop('Reference sample not in data frame')
  }
  

  
  if(breaklines == TRUE)
  {
    data2.df = data.df %>% mutate(Sample = str_replace_all(Sample, "\\+", "<br>+ ")) %>%
      mutate(Sample = factor(Sample, unique(Sample)))
  }
  
  ids = data2.df %>% select(Sample, SampleID) %>% distinct() %>% mutate(Sample = as.character(Sample))

  rawsamples = unique(data2.df$Sample)


  significance = data2.df %>% vascr_tukey(unit = unit, frequency = frequency, time = time, raw = FALSE) %>%
    left_join(ids, by = c("A"="Sample")) %>% mutate(SampleA = SampleID, SampleID = NULL) %>%
    left_join(ids, by = c("B"="Sample")) %>% mutate(SampleB = SampleID, SampleID = NULL) %>%
    filter(SampleA == reference | SampleB == reference) %>%
    mutate(Sample = ifelse(SampleB == reference, A, B))


    pd1r3 = (data2.df %>% vascr_subset(frequency = frequency, unit = unit, time = time))
    
  
   reference_name = ((data2.df %>% filter(SampleID == reference) %>% select(SampleID, Sample) %>% distinct) %>% mutate(Sample = as.character(Sample)))[[2]]
    

  unique(pd1r3$Experiment)

  pd1r4 = pd1r3 %>% vascr_summarise("experiments") %>%
    subset(Sample == reference_name) %>%
    select(Value, Experiment) %>%
    group_by(Experiment) %>%
    summarise(normvalue = mean(Value)) %>%
    ungroup() %>%
    left_join(pd1r3 %>% vascr_summarise("experiments")) %>%
    mutate(Value = Value / normvalue)

  ymaxval = min(pd1r4$Value) * 0.8
  


  toplotdata = pd1r4 %>% vascr_summarise("summary") %>%
    left_join(significance %>% select(Sample, Significance)) %>%
    mutate(Sample = factor(Sample, unique(Sample)))
  
  print(toplotdata)
  
  
  summdata = toplotdata %>%
    ggplot() +
    geom_col(aes(x = Sample, y = Value), data = toplotdata) +
    md_theme_gray()+
    geom_text(aes(x = Sample, label = Significance), y = ymaxval, color = "white") +
    geom_errorbar(aes(x = Sample, ymin = Value - sem, ymax = Value + sem)) +
    theme(legend.position = "none") +
    geom_point(aes(x = Sample, y = Value, color = Sample), data = pd1r4)



  
  return(summdata)

}









