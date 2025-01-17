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
