
# Conducting statistical tests --------------------------------------------


#' Make a data frame of what is statistically significant
#' 
#' @param data.df The dataframe to analyse
#' @param time The time to analyse
#' @param unit The unit to analyse
#' @param frequency The frequency to analyse
#' @param confidence The confidence level to analyse - default is 0.95
#' @param format The format to return the data frame in
#' 
#' @importFrom stats aov lm TukeyHSD symnum
#' @importFrom tidyr separate
#' @importFrom stringr str_c str_replace
#' @importFrom magrittr "%>%"
#' @importFrom car Anova
#'
#' @return A table of what is significant
#' 
#' @noRd
#'
#' @examples
#' vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95)
#' vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data")
#' 
vascr_make_significance_table = function(data.df, time, unit, frequency, confidence = 0.95, format = "toplot")
{
  
  data.df = vascr_subset(data.df, unit = unit, time = time, frequency = frequency)
  
  data.df$Sample = str_replace(data.df$Sample, "-", "~")
  data.df$Sample = str_replace_all(data.df$Sample, "[\\+]", "x")
  
  data.df$Sample
  
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
  
  Tukey.labels = Tukey.labels %>% separate("Samplepair", c("A", "B"), sep = "-")
  
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
      sink1 = filter(Tukey.labels, .data$B == label) %>%
                  mutate(samp = .data$A, lab = .data$Asig, source = .data$B) %>% 
                 select("samp", "lab", "source")
      sink2 = filter(Tukey.labels, .data$A == label) %>% 
                  mutate(samp = .data$B, lab = .data$Bsig, source = .data$A) %>% 
                  select("samp", "lab", "source")
      sink = rbind(sink1, sink2)
      sink = sink %>% mutate(samp = factor(.data$samp, alllabels)) %>% arrange("samp") %>% mutate(samp = as.character(.data$samp))
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
#' @noRd
#' 
#' @importFrom stats lm
#'
#' @examples
#' # vascr_lm(growth.df, "R", 4000, 100)
#' 
vascr_lm = function(data.df, unit, frequency, time)
{
  data.df = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  
  
  formula = "Value ~ Experiment + Sample"
# print(formula)
  
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
#' @noRd
#'
#' @examples
#' 
#' vascr_residuals(growth.df, "R", "4000", 100)
#' 
vascr_residuals = function(data.df, unit, frequency, time)
{
  model = vascr_lm(data.df, unit, frequency, time)
  aov_residuals <- residuals(object = model)
  return(aov_residuals)
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
#' @noRd
#'
#' @examples
#' # vascr_shapiro(growth.df, "R", 4000, 100)
#' 
vascr_shapiro = function(data.df, unit, frequency, time)
{
  aov_residuals = vascr_residuals(data.df, unit, frequency, time)
  shapirotest = shapiro.test(aov_residuals)
  return(shapirotest)
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
#' @noRd
#'
#' @examples
#' # vascr_levene(growth.df, "R", 4000, 100)
#' 
vascr_levene = function(data.df, unit, frequency, time)
{
  data.df = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  
  leveneformula = paste("Value ~ Sample * Experiment")
  modeltest = lm(leveneformula, data = data.df)
  levenetest = leveneTest(modeltest)
  
  return(levenetest)
}



# Plotting of statistical tests -------------------------------------------



#' Generate a qq plot and shapiro test from a vascr data frame
#'
#' @param data.df vascr dataset to use
#' @param unit Unit to return
#' @param frequency Frequency to return
#' @param time Timepoint to use
#' @param priority vascr priority list for analysis, if blank default will be used
#' 
#' @importFrom ggpubr ggqqplot
#' @importFrom stats shapiro.test
#' @importFrom ggplot2 labs
#'
#' @return A ggpubr ggqqplot object
#' @noRd
#'
#' @examples
#' # vascr_plot_qq(growth.df, "R", 4000, 100)
#' 
vascr_plot_qq = function(data.df, unit, frequency, time)
{
  aov_residuals = vascr_residuals(data.df, unit, frequency, time)
  
  qqplot = ggqqplot(aov_residuals)
  
  shapirotest = vascr_shapiro(data.df, unit, frequency, time)
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




#' Plot rediduals overlaid with a normal curve
#'
#' @param data.df The dataset to plot
#' @param unit  Unit to plot
#' @param frequency Frequency to plot
#' @param time Time to plot
#' @param priority Vascr priority list, will use the default if available
#' 
#' @importFrom ggplot2 stat_function ggplot geom_histogram aes after_stat
#' @importFrom stats dnorm sd
#'
#' @return a ggplot with rediduals overlaid by a normal curve
#' @noRd
#'
#' @examples
#' 
#' vascr_plot_normality(growth.df, "R", 4000, 100)
#' 
vascr_plot_normality = function(data.df, unit, frequency, time)
{
  data = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  aov_residuals = vascr_residuals(data, unit, frequency, time)
  
  filtered.df = data
  filtered.df$residuals <- aov_residuals
  filteredplot.df = filtered.df
  filteredplot.df$Value = filtered.df$residuals
  
  normaloverlayplot = ggplot(filteredplot.df, aes(x = .data$Value)) + 
    geom_histogram(aes(y =after_stat(.data$density)),
                   colour = "black",
                   bins = 10,
                   fill = "white") +
    stat_function(fun = dnorm, args = list(mean = mean(filteredplot.df$Value), sd = sd(filteredplot.df$Value))) + labs(title = "D) Normality of residuals check", subtitle = "Normal curve and histogram should align", y="Density")
  
  normaloverlayplot
  return(normaloverlayplot)
}



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
#' @noRd
#'
#' @examples
#' vascr_plot_levene(growth.df, "R", 4000, 100)
#' 
#' 
vascr_plot_levene = function(data.df, unit, frequency, time)
{
  
  levenetest = vascr_levene(data.df, unit, frequency, time)
  
  f = round(levenetest$`F value`[1],3)
  p = round(levenetest$`Pr(>F)`[1],3)
  
  if(p>0.05)
  {
    pass = "Pass"
  }else
  {
    pass = "Fail"
  }
  
  fit = vascr_lm(data.df, unit, frequency, time)
  
  p1<-ggplot(fit, aes(fit$fitted.values, fit$residuals))+geom_point()
  p1<-p1+stat_smooth(method="loess", formula = 'y ~ x')+geom_hline(yintercept=0, col="red", linetype="dashed")
  p1<-p1+xlab("Fitted values")+ylab("Residuals")
  p1 = p1 + labs(title = "E) Homogeneity of Variances test",
                 subtitle = paste("Levene's Test, F=", f, ", P=", p, ",", pass))
  
  return(p1)
}

#' Plot a line graph with a vertical line on it
#'
#' @param data.df A vascr dataset
#' @param unit Unit to plot
#' @param frequency Frequency to plot
#' @param time Time to plot
#' @param ... Other arguments to be passed on to vascr_plot_line
#'
#' @importFrom ggplot2 geom_vline geom_line
#'
#' @return A ggplot2 object
#' @noRd
#'
#' @examples
#' # vascr_plot_time_vline(growth.df, "R", 4000, 100)
#' 
vascr_plot_time_vline = function(data.df, unit, frequency, time)
{
  
  # Round the number given to the function to the nearest actual measurement
  timetouse = vascr_find_single_time(data.df, time)
  
  
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
#' 
#' @importFrom ggplot2 ggplot aes geom_boxplot labs aes_string element_text
#' @importFrom stringr str_replace_all
#'
#' @return A ggplot2 box plot of replicate experiments
#' 
#' @noRd
#'
#' @examples
#'vascr_plot_box_replicate(growth.df, "R", 4000, 100)
#' 
vascr_plot_box_replicate = function(data.df, unit, frequency, time)
{
  
  data = vascr_subset(data.df, unit = unit, frequency = frequency, time = vascr_find_time(data.df, time))
  
  data$Sample = str_replace_all(data$Sample, "\\+", "\\\n")
  
  overallplot <- ggplot(data, aes(x=.data$Sample, y=.data$Value, color = .data$Experiment)) + 
    geom_boxplot() + labs(title = "B) Replicate data") + 
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
    labs(y = vascr_titles(unique(data$Unit), unique(data$Frequency)))
  
  overallplot
  
  return(overallplot)
}



#' Generate a tukey analyasis of vascr data
#'
#' @param data.df The dataset to analyse
#' @param unit Unit to analyse
#' @param frequency Frequency to analyse
#' @param time Time to analyse
#' @param raw If true, a non-processed form of the tukey results will be returned
#' 
#' @importFrom dplyr arrange
#'
#' @return A table or Tukey HSD test result
#' 
#' @noRd
#'
#' @examples
#' vascr_tukey(growth.df, "R", 4000, 100)
#' vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE)
#' 
vascr_tukey = function(data.df, unit, frequency, time, raw = FALSE)
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


#' Create a grid of ANOVA significance
#' 
#' This function presents the significance of each pair of treatments in an ANOVA
#' dataset as a heatmap
#'
#' @param data.df vascr dataset to summarise
#' @param unit the unit to summarise
#' @param frequency frequency to summarise
#' @param time time at which to run the experiment
#' 
#' @importFrom dplyr mutate 
#' @importFrom ggplot2 ggplot geom_tile labs theme scale_fill_manual
#' @importFrom ggtext element_markdown
#'
#' @return a ggplot heatmap
#' 
#' @noRd
#'
#' @examples
#' vascr_plot_anova_grid(growth.df, "R", 4000, 100)
#' 
vascr_plot_anova_grid = function (data.df, unit =  "R", frequency = 4000, time = 100)
{
  
  ggplotColours <- function(n = 6, h = c(0, 360) + 15){
    if ((diff(h) %% 360) < 1) h[2] <- h[2] - 360/n
    hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
  }
  
  pal = ggplotColours(8)
  
  sigdata = vascr_make_significance_table(data.df, unit = unit, frequency = frequency, time = time, format = "Tukey_data")
  
  sigdata2 = sigdata %>% mutate(temp = .data$A, A = .data$B, B = .data$temp, temp = NULL) %>%
    rbind(sigdata)
  
  sigplot = sigdata2 %>% mutate(A = factor(.data$A,(unique(c(sigdata$A, sigdata$B))))) %>%
    mutate(Significance = cut(sigdata2$Tukey.level, breaks = c(0, 0.01, 0.05, 0.1, 1), 
                              labels = c("< 0.01", "<0.05", "< 0.1", "<1"))) %>%
    mutate(Significance = factor(.data$Significance, c("< 0.01", "<0.05", "< 0.1", "<1"))) %>%
    mutate(B = factor(.data$B, unique(c(sigdata$A, sigdata$B)))) %>%
    ggplot() +
    geom_tile(aes(x = .data$A, y = .data$B, fill = .data$Significance)) +
    labs(fill = "P value",
         x = "Treatment 1", y = "Treatment 2") +
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
#' @param breaklines Should each variable in the sample name be on a new line
#'
#' @importFrom ggplot2 geom_col geom_text geom_errorbar geom_point
#' @importFrom dplyr mutate left_join join_by filter reframe all_of
#'
#' @return an annotated bar graph
#' 
#' @noRd
#'
#' @examples
#' vascr_plot_anova_bar_reference(growth.df, "R", 4000, 50)
#' 
vascr_plot_anova_bar_reference = function(data.df, unit, frequency, time, reference = min(data.df$SampleID), breaklines = TRUE)
{
  
  if(!(reference %in% data.df$SampleID))
  {
    stop('Reference sample not in data frame')
  }
  
  # data.df$Sample = as.character(data.df$Sample)
   data.df$Sample = str_replace_all(data.df$Sample, "[\\+]", "x")
  
  
  if(breaklines == TRUE)
  {
    data2.df = data.df %>% mutate(Sample = str_replace_all(.data$Sample, "\\+", "<br>+ ")) %>%
      mutate(Sample = factor(.data$Sample, unique(.data$Sample)))
  } else(
    data2.df = data.df
  )
  
  ids = data2.df %>% select("Sample", "SampleID") %>% distinct() %>% mutate(Sample = as.character(.data$Sample))
  
  rawsamples = unique(data2.df$Sample)
  
  
  significance = data2.df %>% vascr_tukey(unit = unit, frequency = frequency, time = time, raw = FALSE) %>%
    left_join(ids, by = c("A"="Sample")) %>% mutate(SampleA = .data$SampleID, SampleID = NULL) %>%
    left_join(ids, by = c("B"="Sample")) %>% mutate(SampleB = .data$SampleID, SampleID = NULL) %>%
    filter(.data$SampleA == reference | .data$SampleB == reference) %>%
    mutate(Sample = ifelse(.data$SampleB == reference, .data$A, .data$B))
  
  
  pd1r3 = (data2.df %>% vascr_subset(frequency = frequency, unit = unit, time = time))
  
  
  reference_name = ((data2.df %>% filter(.data$SampleID == reference) %>% 
                       select("SampleID", "Sample") %>% distinct) %>% 
                      mutate(Sample = as.character(.data$Sample)))[[2]]
  
  
  unique(pd1r3$Experiment)
  
  pd1r4 = pd1r3 %>% vascr_summarise("experiments") %>%
    filter(.data$Sample == reference_name) %>%
    select(all_of(c("Value", "Experiment"))) %>%
    group_by(.data$Experiment) %>%
    reframe(normvalue = mean(.data$Value)) %>%
    ungroup() %>%
    left_join(pd1r3 %>% vascr_summarise("experiments"), by = join_by("Experiment")) %>%
    mutate(Value = .data$Value / .data$normvalue)
  
  ymaxval = min(pd1r4$Value) * 0.8
  
  
  
  toplotdata = pd1r4 %>% vascr_summarise("summary") %>%
    left_join(significance %>% select("Sample", "Significance"), by = join_by("Sample")) %>%
    mutate(Sample = factor(.data$Sample, unique(.data$Sample))) %>%
    mutate(Significance = if_else(!is.na(.data$Significance), as.character(.data$Significance), ""))
  
  
  summdata = toplotdata %>%
    ggplot() +
    geom_col(aes(x = .data$Sample, y = .data$Value), data = toplotdata) +
    geom_text(aes(x = .data$Sample, label = .data$Significance), y = ymaxval, color = "white") +
    geom_errorbar(aes(x = .data$Sample, ymin = .data$Value - .data$sem, ymax = .data$Value + .data$sem)) +
    theme(legend.position = "none") +
    geom_point(aes(x = .data$Sample, y = .data$Value, color = .data$Sample), data = pd1r4)
  
  return(summdata)
  
}


#' Plot a bar chart with ANOVA statistics superimposed on it as text
#'
#' @param data A vascr dataset
#' @param confidence The minimum confidence level to display
#' @param time Time point to plot
#' @param unit Unit to plot
#' @param frequency Frequency to plot
#' @param format Statistics format to return
#' @param error The style of eror bars to plot
#' @param ... Any argument to vascr_prep_graphdata or vascr_polish_plot. Use this to select values ect.
#'
#' @return A vascr bar plot with statistics attached to it
#' 
#' @noRd
#' 
#' @importFrom ggplot2 geom_errorbar aes ggplot geom_text geom_bar
#'
#' @examples
#' vascr_plot_bar(data = growth.df, confidence = 0.95, unit = "R", time = 100, 
#'   frequency = 4000, rotate_x_angle = 45)
#' vascr_plot_bar_anova(data = growth.df, confidence = 0.95, unit = "R", 
#'   time = 100, frequency = 4000, rotate_x_angle = 45)
#' 
vascr_plot_bar_anova = function(data.df , confidence = 0.95, time, unit, frequency, format = "toplot", error = Inf, ...)
{
  
  data.df$Sample = str_replace_all(data.df$Sample, "[\\+]", "x")
  
  # Gather graph data based on the ...
  datum = vascr_subset(data.df, unit = unit, frequency = frequency, time = time)
  
  # if(!length(unique(c(data$Time, data$Unit, data$Frequency, data$Instrument)))==4)
  # {
  #   stop("vascr_plot_bar_anova only supports a single time, unit, frequency and instrument at the moment. Please manually create an ANOVA if you need to ask other  statistical questions.")
  # }
  
  # Add structure checks in here
  
  if(!(vascr_find_normalised(data.df)==FALSE))
  {
    warning("Normalised dataset detected, ANOVA results may be invalid")
  }
  
  summary = vascr_subset(data.df, frequency = frequency, time = time, unit = unit) %>%
    vascr_summarise(level = "summary")
  
  datum = arrange(datum, .data$Sample)
  
  labeltable = vascr_make_significance_table(data.df = datum, time, unit, frequency, confidence, format = "toplot")
  
  summary$Sample = as.factor(summary$Sample)
  labeltable$Sample = as.factor(labeltable$Sample)
  
  filtered2.df = left_join(summary, labeltable, by = "Sample")
  
  plot = ggplot(filtered2.df, aes(x = .data$Sample, y = .data$Value, label = .data$Label, fill = .data$Sample)) + 
    geom_bar(stat = "identity") +
    geom_text(aes(label=.data$Label, y = min(.data$Value)/2)) 
  
  plot
  
  
  if(error>0)
  { 
    plot = plot + geom_errorbar(aes(ymax = .data$Value + .data$sem, ymin = .data$Value - .data$sem), width = 0.6)
  }
  
  dots = list(...)
  
  plot
  
  return(plot)
}





#' Make a display with all the anova analysis pre-conducted
#'
#' @param data.df vascr dataset to plot
#' @param unit unit to plot
#' @param frequency frequnecy to plot
#' @param time timepoint to plot at
#' @param priority analyasis priority. Will use default if not filled in
#'
#' @return A matrix of different ANOVA tests
#' 
#' @importFrom cowplot plot_grid
#' @importFrom ggtext element_markdown
#' @importFrom stringr str_replace_all
#' @importFrom ggplot2 scale_color_manual guides labs theme guide_legend
#' @importFrom gridExtra arrangeGrob
#' 
#' @noRd
#'
#' @examples
#' 
#' vascr_plot_anova(data.df = growth.df, unit = "R", frequency = 4000, time = 100)
#' 
vascr_plot_anova = function(data.df, unit, frequency, time, ...)
{
  
  timeplot = vascr_plot_time_vline(data.df, unit, frequency, time) + labs(y = "Resistance  
                                                                                  (ohm, 4000 Hz)")
  
  overallplot = vascr_plot_box_replicate(data.df, unit, frequency, time) + labs(y = "Resistance  
                                                                                  (ohm, 4000 Hz)") + 
    scale_color_manual(values=c("orange", "blue", "green", "purple", "red", "brown", "grey", "turquoise", "violet"))
  
  qqplot = vascr_plot_qq(data.df, unit, frequency, time)
  normaloverlayplot = vascr_plot_normality(data.df, unit, frequency, time)
  leveneplot = vascr_plot_levene(data.df, unit, frequency, time)
  
  differences = vascr_plot_bar_anova(data.df, unit = unit, time = time, frequency = frequency, confidence = 0.95, priority = NULL) +
    theme(legend.position = "none") + labs(title = "G) ANOVA results", y = "Resistance   
                                                    (ohm, 4000 Hz)") +
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




