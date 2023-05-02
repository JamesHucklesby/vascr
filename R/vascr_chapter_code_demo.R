function(){

growth.df = vascr_implode(vascr::growth.df, cleanup_sample = TRUE) %>%
  arrange(Well) %>% mutate(Experiment = str_replace(Experiment, "Experiment2", "Experiment 2")) %>% 
  mutate(Experiment = str_replace(Experiment, "Experiment3", "Experiment 3"))

smallsample = as.character(growth.df$Sample) %>% unique() %>% rev()


growth.df$Sample = factor(growth.df$Sample, smallsample)

p1 = growth.df %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_plot_line () +
  theme(legend.position = "none", legend.box = "horizontal") +
  labs(color = "Seeding Density:  ", fill = "Seeding density", linetype = "Experimental replicate")


p2 = growth.df %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_summarise(level = "experiments") %>%
  vascr_plot_line ()+
  theme(legend.position = "none")

p3 = growth.df %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_interpolate_time() %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line ()+
  theme(legend.position = "none")

p4 = get_legend(p1 + theme(legend.position = "right", legend.justification = "centre"))

ggarrange(p1, p2, p3, p4, labels = LETTERS[1:3])



growth.df %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_interpolate_time() %>%
  vascr_normalise(normtime = 0) %>%
  vascr_summarise(level = "experiments") %>%
  vascr_plot_line ()


colnames(growth.df)

vascr::growth.df %>% vascr_subset(experiment = 1) %>%
  vascr_make_name(fill_blank = "0 cells")%>%
  mutate(Sample = factor(Sample, rev(c("35,000 cells", "30,000 cells", "25,000 cells", "20,000 cells",
                                       "15,000 cells", "10,000 cells", "5,000 cells", 
                                       "0 cells" )))) %>%
 vascr_plot_deviation(deviation = 0.2)


temp = growth.df %>%
  mutate(Sample = str_replace(Sample, "Control", "0 cells")) %>%
  vascr_subset(unit = "R", frequency = 4000, experiment = 1) %>%
  vascr_interpolate_time(100) %>%
  mutate(Sample = factor(Sample, rev(c("35,000 cells", "30,000 cells", "25,000 cells", "20,000 cells",
                                   "15,000 cells", "10,000 cells", "5,000 cells", 
                                   "0 cells" ))))


temp$Sample

temp %>%
  vascr_plot_matrix() + labs(y = "Overall Resistance (4000 Hz)") +
  labs(tag = "Plate row") +
  theme(plot.tag.position = "left", plot.tag = element_text(angle = 90, vjust = 1.1, hjust=1)) +
  labs(title = "Plate column", colour = "Cells seeded per well") +
  theme(plot.title.position = "panel", plot.title = element_text(hjust = 0.5)) + 
  guides(linetype = "none")



data = growth.df %>%
  vascr_make_name(fill_blank = "0 cells") %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  arrange(str_remove(cells, ",") %>% as.numeric()) %>% 
  mutate(Sample = factor(Sample, unique(Sample)))


  vascr_plot_deviation(data, deviation = 0.2) 

  
  growth.df %>%
    vascr_subset(unit = "Rb") %>%
    vascr_plot_line()


  growth.df %>%
    vascr_subset(unit = "Rb") %>%
    vascr_summarise("experiments") %>%
    vascr_plot_line()

  growth.df %>%
    vascr_subset(unit = "Rb") %>%
    vascr_summarise("summary") %>%
    vascr_plot_line()
  
  
  filtered.df = growth.df %>% filter(!Well %in% c("D01", "B05", "D08")) %>%
    vascr_subset(unit = "R", frequency = 4000) %>%
    select(-line) %>%
    vascr_implode() %>%
    mutate(cells = ifelse(Sample == "", 0, cells)) %>%
    mutate(Sample = ifelse(Sample == "", "0_cells", Sample)) %>%
    vascr_interpolate_time(200)
  
  vascr_plot_anova(filtered.df, "R", time = 100, frequency = 4000)

  data.df = filtered.df %>%
    vascr_summarise("summary")
  
  vascr_plot_cross_correlation(data.df)
  
  
  temp = growth.df %>%
    mutate(Sample = str_replace(Sample, "Control", "0 cells")) %>%
    vascr_subset(unit = "R", frequency = 4000) %>%
    vascr_interpolate_time(100) %>%
    mutate(Experiment = recode(Experiment,"1 : Experiment 1" =  "Experiment 1"))%>%
    mutate(Experiment = recode(Experiment,"2 : Experiment 2" =  "Experiment 2"))%>%
    mutate(Experiment = recode(Experiment,"3 : Experiment 3" =  "Experiment 3")) %>%
    mutate(Sample = str_replace(Sample, "000 ", ",000 ")) %>%
    mutate(Sample = str_replace(Sample, "Control", "0 cells")) %>%
    mutate(Sample = factor(Sample, unique(Sample))) %>%
    mutate(Sample = fct_rev(Sample)) %>%
    arrange(Sample)
  
  
  
  vascr_plot_bar_anova(data.df = temp, unit =  "R", frequency = 4000, time = 100)
  vascr_plot_anova_grid(data.df = temp, unit =  "R", frequency = 4000, time = 100) 

  
  vascr_plot_anova(data.df = temp, unit =  "R", frequency = 4000, time = 100) 

  
  
 pa = temp %>%
    vascr_subset(time = 40) %>%
    vascr_summarise(level = "summary") %>%
    ggplot() +
    geom_point(aes(x = Sample, y = Value)) +
    geom_line(aes(x = Sample, y = Value, group = Time)) +
    geom_errorbar(aes(x = Sample, ymin = Value - sem, ymax = Value + sem), width = 0.5)+
    labs(x = "Seeding Density (cells/well)", y = "Resistance at 40 hours (ohm, 4000 Hz)")
  
  
  pb = growth.df %>%
    mutate(Sample = str_replace(Sample, "Control", "0 cells")) %>%
    vascr_subset(unit = "R", time = 40) %>%
    mutate(Experiment = recode(Experiment,"1 : Experiment 1" =  "Experiment 1"))%>%
    mutate(Experiment = recode(Experiment,"2 : Experiment2" =  "Experiment 2"))%>%
    mutate(Experiment = recode(Experiment,"3 : Experiment3" =  "Experiment 3")) %>%
    mutate(Frequency = as.numeric(Frequency)) %>%
    vascr_subset(time = 40) %>%
    vascr_summarise(level = "summary") %>%
    ggplot() +
    geom_point(aes(x = Frequency, y = Value, color = Sample)) +
    geom_line(aes(x = Frequency, y = Value, color = Sample)) +
    geom_ribbon(aes(x = Frequency, ymin = Value - sem, ymax = Value + sem, fill = Sample),
                alpha = 0.3) +
    scale_x_log10() +
    labs(x = "Log Frequency (Hz)", y = "Resistance at 40 hours (ohm)",
         color = "Seeding Density (cells/well)", fill = "Seeding Density (cells/well)")
  
  
  ggarrange(pb, pa, labels = LETTERS, nrow = 2)


  

deviation = growth.df %>% vascr_subset(experiment = 1) %>%
  mutate(Sample = str_replace(Sample, "000 ", ",000 ")) %>%
  mutate(Sample = str_replace(Sample, "Control", "0 cells")) %>%
  mutate(Sample = factor(Sample, unique(Sample))) %>%
  mutate(Sample = fct_rev(Sample)) %>%
  arrange(Sample)


  p3 = vascr_plot_deviation(deviation, visualisation = "plate") + theme(strip.background = element_blank(), strip.text.x = element_blank()) +
      labs(fill = "Maximum Deviation", tag = "A")

  p1 = vascr_plot_deviation(deviation, visualisation = "bar", deviation = 0.2) + 
    theme(strip.background = element_blank(), strip.text.x = element_blank(), legend.position = "right") +
    labs(tag = "B")
  
  p2 = vascr_plot_deviation(deviation, visualisation = "line", max_deviation = 0.2, deviation = 0.2) + 
    theme(strip.background = element_blank(), strip.text.x = element_blank(), legend.position = "none") +
    labs(tag ="C", x = "Time (hours)")
  
  p2 + theme(legend.position = "right")
  
  (p3) + p1 + p2 +
    plot_layout(ncol = 1, guides = "collect")
}
    