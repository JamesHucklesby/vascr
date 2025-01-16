
function (){
# timepoints = c(1:10)/10*pi*1
# 
# ccf_curves = tribble(~"Experiment", ~"Well", ~"Sample", ~`Value`,
#                      "1", "A1", "Baseline", c(sin(timepoints)),
#                      "1", "A4", "Smaller magnitude", c(sin(timepoints)*0.7),
#                      "1", "A5", "Larger magnitude", c(sin(timepoints)*0.7),
#                      "1", "A6", "Flatline", c(sin(timepoints*5))) %>%
#                     mutate(Unit = "R", Frequency = 4000, Time = list(timepoints), Instrument = "ECIS", SampleID = as.numeric(as.factor(Sample)))
# 
# ccf.df = ccf_curves %>% unnest(cols = c(Value, Time))
# 
# vascr_plot_line(ccf.df, text_labels = FALSE)
# 
# cc = ccf.df %>% vascr_cc() 
# ccf.df %>% vascr_cc() %>% vascr_summarise_cc()
# ccf.df %>% vascr_cc() %>% vascr_summarise_cc() %>% vascr_plot_cc()
# 
# v1 = cc[5,][10] %>% unlist() %>% as.vector()
# v2 = cc[5,][5] %>% unlist() %>% as.vector()
# 
# ccf(v1, v2)
# 
# 
# vascr:::vascr_find_metadata(vascr::growth.df)
# 
# data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000)
# 
# 
# flat_growth = growth.df %>% group_by_all() %>% ungroup("Value", "Time") %>%
#               mutate(Value = Value/max(Value, na.rm = TRUE))
# 
# vascr_plot_line(flat_growth %>% vascr_subset(unit = "R", frequency = 4000))
# 
# 
# vascr_find_metadata(ecis)
# 
# 
# d1 = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000,  sampleid = c(1,2,5), well = "A01") %>% filter(!is.na(Value))
# d2 = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000,  sampleid = c(1,2,5), well = "A02") %>% filter(!is.na(Value))
# d2 = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000, well = "H02") %>% filter(!is.na(Value))
# 
# ggplot() +
#   geom_point(aes(x = d1$Value, y = d2$Value))
# 
# ccf(d1$Value, d2$Value) %>% print()
# ccf(d2$Value, d1$Value) %>% print()
# 
# cor.test(d1$Value, d2$Value, method = "pearson")
# 
# devtools::install_github("SigurdJanson/ccf21")
# 
# cc = ccf21::ccf(d1$Value, d2$Value, lag.max = 0, ci = "0.95")
# 
# ccf1 = ccf(d1$Value, d2$Value, lag.max = 0)
# 
# 2 * (1 - pnorm(as.numeric(ccf1[[1]]), mean = 0, sd = 1/sqrt(ccf1$n.used)))
# 
# data.df = ecis %>% vascr_subset(unit = "R", frequency = "4000", sampleid = c(1,3,6), time = c(40,85))
# 
# vascr_plot_line(data.df)
# 
# ccf.df = vascr_cc(data.df)
# 
# ccf.df %>% vascr_summarise_cc("summary") %>% vascr_plot_cc()
# 
# 
# 
# t1 = original_data$Value
# t2 = reverse_processed$Value
# 
# ccf(t1, t2, lag.max = 0, plot = FALSE)[[1]] %>% as.numeric()
# 
# 
# data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000) # experiment = 1,
# 
# data.df %>% vascr_plot_line()
# 
# result = vascr_cc(data.df, reference = 1)
# 
# result %>% vascr_summarise_cc() %>% vascr_plot_cc()
# 
# vec = result$cc
# 
# qqnorm(vec)
# qqline(vec)
# 
# t.test(vec, mu = 0.1, alternative = "less")
# 
# result = result %>% mutate(pair = paste(Sample.x, Sample.y)) %>%
#                 mutate(pair = str_remove_all(pair, ",000_cells \\+ HCMEC D3_line"))
# result
# 
# 
# s1 = result %>% filter(SampleID.x ==5, SampleID.y ==5) %>% filter(Experiment == "1 : Experiment 1")
# s2 = result %>% filter(SampleID.x ==5, SampleID.y ==5) %>% filter(Experiment == "2 : Experiment2")
# 
# 
# t.test(s1$cc, s2$cc)
# 
# # lmod =lm(cc ~ Sample.y, result)
# 
# lmod = aov(cc ~ Sample.x + Experiment, result)
# summary(lmod)
# TukeyHSD(lmod)
# 
# lmod = aov(cc ~ Sample.x/Experiment, result)
# lmod
# TukeyHSD(lmod)
# 
# 
# ## Have a go a the Dunnett Test
# 
# rs = result %>% vascr_summarise_cc(level = "experiments") %>%
#   mutate(pair = paste(Sample.x, Sample.y)) %>%
#   mutate(pair = str_remove_all(pair, ",000_cells \\+ HCMEC D3_line"))
# 
# rs
# 
# DescTools::DunnettTest(rs$cc, rs$Sample.x, control = "0_cells + HCMEC D3_line")
# 
# DescTools::DunnettTest(rs$cc, rs$pair, control = "15 15")
#                        
# 
# kruskal.test(rs$cc ~ rs$Sample.x, data = rs)
# 
# dunnTest(cc ~ Sample.x,
#          data=rs,
#          method="bonferroni")
# 
# 
#                        
# lmod = aov(cc ~ Sample.x/Experiment, rs)
# lmod
# TukeyHSD(lmod)
# 
# lmod = aov(cc ~ Sample.x, rs)
# lmod
# TukeyHSD(lmod)
# 
# 
# DescTools::DunnettTest(rs$cc, rs$Sample.x, control = "0_cells + HCMEC D3_line")
# 
# rs2 = rs %>% mutate(Sample.x = as.factor(Sample.x))
# 
# lmod = aov(cc ~ Sample.x, rs2)
# lmod
# 
# Dunnett <- glht(lmod, linfct = mcp(Sample.x = "Tukey"))
# summary(Dunnett)
# 
# 
# 
# lm(Value)

  # 2 * (1 - pnorm(as.numeric(ccf1[[1]]), mean = 0, sd = 1/sqrt(30)))
  
  
  # ccf_calc %>% ggplot() +
  #   geom_point(aes(y = title, x = cc, color = expid))
  
  
  # Used in core package Value ~ Experiment + Sample
  # ccf_aov = aov(cc ~ Experiment + title, ccf_calc)
  # 
  # ccf_aov
  # 
  # anova(ccf_aov)
  # 
  # hsd = tukey_hsd(ccf_calc, cc ~ expid + title)
  # 
  # hsd
  
  
}


#' Title
#'
#' @param data.df 
#'
#' @returns
#' @export
#'
#' @examples
#' 
#' vascr_plot_cc_stats(growth.df)
#' 
vascr_plot_cc_stats = function(data.df, unit = "R", frequency = 4000){
  
ccf_calc = data.df %>% vascr_subset(unit = unit, frequency = frequency) %>%
            vascr_summarise("experiments") %>%
            vascr_cc() %>%
            mutate(title = paste(Sample.x, Sample.y , sep = "x")) %>%
            mutate(expid = paste(Experiment.x, Experiment.y))



pairs = ccf_calc %>% ungroup() %>% select("Sample.x", "Sample.y", "title") %>% distinct() %>%
          rowwise() %>%
          group_split()

output = foreach (pair = pairs, .combine = rbind) %do% {
  
  s1 = pair$Sample.x
  s2 = pair$Sample.y
  
  t1 = ccf_calc %>% filter(Sample.x == s1, Sample.y ==s2)
  t2 = rbind( ccf_calc %>% filter(Sample.x == s1, Sample.y ==s1),
              ccf_calc %>% filter(Sample.x == s2, Sample.y ==s2))
  
  p = t.test(t1$cc, t2$cc)
  
  
  return(tribble(~title, ~p, ~cc, ~sd,
                 pair$title, p$p.value, mean(t1$cc), sd(t1$cc)))
}


ggplot() +
  geom_point(aes(x = t1$cc, y = "test"))+
  geom_point(aes(x = t2$cc, y = "control"))


output$padj = p.adjust(output$p, "fdr")

output$stars <- symnum(output$p, corr = FALSE, na = FALSE, 
                cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                symbols = c("***", "**", "*", ".", " "))

output %>% ggplot() +
  geom_point(aes(y = title, x = cc)) +
  geom_errorbar(aes(y = title, xmin = cc-sd, xmax = cc+sd, colour = as.character(stars))) +
  geom_text(aes(x = 1.1, y = title, label = round(padj, 3)))


}

#' Calculate the cross correlation coefficients of a vascr dataset
#'
#' @param data.df a vascr dataset to calculate
#' @param reference  The sample to reference all CC's against. Defaults to all comparisons
#'
#' @return a vascr dataset containing the cross correlation coefficients between curves
#' 
#' @importFrom cli cli_progress_bar cli_progress_update cli_process_done
#' @importFrom dplyr bind_cols group_by arrange summarise rename_with inner_join rowwise
#' @importFrom stats ccf
#' 
#' @noRd
#'
#' @examples
#' data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000, sampleid = c(1,4,7), experiment = "1 : Experiment 1", time = c(5,50))
#' 
#' data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000, sampleid = c(1,4,7), time = c(5,50)) %>%
#' vascr_summarise(level = "experiments")
#' 
#' vascr_cc(data.df)
#' 
#' vascr_cc(data.df, reference = "35,000_cells + HCMEC D3_line")
#' vascr_cc(data.df, reference = c("35,000_cells + HCMEC D3_line", "5,000_cells + HCMEC D3_line"))
#' 
vascr_cc = function(data.df, reference = "none") {
  
curves = data.df %>%
                filter(!is.na(.data$Value)) %>% 
                group_by(.data$Well, .data$SampleID, .data$Sample, .data$Experiment) %>%
                arrange(.data$Time, .data$SampleID) %>%
                mutate(Time = NULL) %>%
                summarise(values = list(.data$Value), .groups = "keep") %>%
                ungroup("Well") %>%
                arrange("SampleID") 

if(vascr_find_level(data.df) == "wells")
  {
  pairedcurves = inner_join(curves, curves, by = c("Experiment"), relationship = "many-to-many") %>%
                  filter(.data$SampleID.x <= .data$SampleID.y)
  } else
  {
    # c1 = curves
    # c2 = curves

    # # pairedcurves = tidyr::crossing(c1, c2)
    
    c1 = curves %>% mutate(expid = as.numeric(Experiment))
    c2 = curves %>% mutate(expid = as.numeric(Experiment))
    
    colnames(c1) = paste(colnames(c1), ".x", sep = "")
    colnames(c2) = paste(colnames(c2), ".y", sep = "")
    
    pairedcurves = inner_join(c1, c2, by = join_by(expid.x < expid.y))

  }

if(!isTRUE(reference == "none")){
  reference = vascr_find_sample(data.df, reference)
  pairedcurves = pairedcurves %>% filter(.data$Sample.x %in% reference | .data$Sample.y %in% reference)
}



pairedcurves

to_export = pairedcurves %>% rowwise() %>% mutate(cc = ccf(unlist(.data$values.x), unlist(.data$values.y), plot = FALSE, lag.max = 0)[["acf"]][[1]])



return(to_export)

}


#' Summarise Cross Correlation Data
#'
#' @param data.df The vascr dataset to summarise
#' @param level Level at which to summarise, options are wells, experiments, summary
#'
#' @return a vascr dataset of cross correlaions
#' 
#' @importFrom dplyr group_by_at summarise ungroup mutate select distinct
#' 
#' @noRd
#'
#' @examples
#' data.df = vascr::growth.df %>% 
#'             vascr_subset(unit = "R", frequency = 4000, sampleid = c(1,4,7)) %>%
#'             vascr_cc()
#'             
#' vascr_summarise_cc(data.df, level = "experiments")
#' vascr_summarise_cc(data.df, level = "summary")
vascr_summarise_cc = function(data.df, level = "summary")
{
  
  ccf_exp = data.df %>% ungroup() %>% 
    group_by_at(vars("Sample.x", "Sample.y", "SampleID.x", "SampleID.y", "Experiment")) %>%
    summarise(cc = mean(.data$cc), n = n())
  
  distinct(ccf_exp %>% select(-"cc"))
  
  if(level == "experiments"){
    return(ccf_exp)
  }
  
  ccf_sum = ccf_exp %>% group_by(.data$`Sample.x`, .data$`Sample.y`) %>%
    summarise(ccsem = sd(.data$cc)/n(), cc = mean(.data$cc), totaln = sum(.data$n)) %>%
    mutate(title = paste(.data$`Sample.x`, .data$`Sample.y`, sep = "\n"))
  
  return(ccf_sum)
  
}


#' Plot out a cross-correlation summarized dataset
#' 
#' @param data.df a cross-correlation summarised vascr dataset
#'
#' @return A ggplot of the dataset presented to be cropped
#' 
#' @importFrom ggplot2 geom_tile geom_text facet_wrap scale_colour_manual geom_point geom_errorbar
#' @importFrom dplyr tibble 
#' @importFrom ggtext element_markdown
#' 
#' @noRd
#'
#' @examples
#' data.df = vascr::growth.df %>% 
#'             vascr_subset(unit = "R", frequency = 4000) %>%
#'             vascr_cc()
#'
#' data.df %>% vascr_plot_cc()
#' data.df %>% vascr_summarise_cc("experiments") %>% vascr_plot_cc()
#' data.df %>% vascr_summarise_cc("summary") %>% vascr_plot_cc()
#' 
vascr_plot_cc = function(data.df){

if(vascr_find_level(data.df) == "wells"){
  toreturn = data.df %>% ggplot() +
    geom_tile(aes(x = paste(.data$`Experiment`, .data$`Well.x`, sep = "\n"), y = paste(.data$`Experiment`, .data$`Well.y`, sep = "\n"), fill = .data$cc)) +
    geom_text(aes(x = paste(.data$`Experiment`, .data$`Well.x`, sep = "\n"), y = paste(.data$`Experiment`, .data$`Well.y`, sep = "\n"), label = round(.data$cc,3))) +
    facet_wrap(vars(.data$`Sample.x`, .data$`Sample.y`), scales = "free")
 
   return(toreturn)
}

if(vascr_find_level(data.df) == "experiments"){
  toreturn = data.df %>% ggplot() +
  geom_tile(aes(x = .data$`Experiment`, y = .data$`Experiment`, fill = .data$cc)) +
  facet_wrap(vars(.data$`Sample.x`, .data$`Sample.y`), scales = "free")
  
  return(toreturn)
}
  

colours = vascr_gg_color_hue(length(unique(c(data.df$`Sample.x`, data.df$`Sample.y`))))

hue = tibble(Sample = unique(c(data.df$`Sample.x`, data.df$`Sample.y`)), colours = colours)

x = NULL
y = NULL
cc = NULL

toplot = data.df %>% left_join(hue, join_by(x$`Sample.x` == y$`Sample`)) %>% 
  mutate(hue1 = .data$colours, colours = NULL) %>% 
  left_join(hue, join_by(x$`Sample.y` == y$`Sample`)) %>% 
  mutate(hue2 = colours, colours = NULL) %>%
  mutate(title = glue("<span style = 'color:{hue1};'>{`Sample.x`}</span><br>
                       <span style = 'color:{hue2};'>{`Sample.y`}</span>"))


toplot %>%
  ggplot() +
  geom_point(aes(y = .data$title, x = .data$cc, color = .data$`Sample.x`)) +
  geom_errorbar(aes(y = .data$title, xmin = .data$cc -  .data$ccsem, xmax = .data$cc + .data$ccsem, color = .data$`Sample.y`)) +
  theme(axis.text.y = element_markdown()) +
  scale_colour_manual(values = colours)

}


