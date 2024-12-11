
vascr_ccf = function() {

timepoints = c(1:100)

ccf_curves = tribble(~"Experiment", ~"Well", ~"Sample", ~`Value`,
                     "1", "A1", "One", c(sin(timepoints))) %>%
  mutate(Unit = "R", Frequency = 4000, Time = list(timepoints), Instrument = "ECIS", SampleID = as.numeric(as.factor(Sample)))

ccf.df = ccf_curves %>% unnest(cols = c(Value, Time))

vascr_plot_line(ccf.df)


vascr:::vascr_find_metadata(vascr::growth.df)

data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000)



curves = data.df %>% group_by(Well, SampleID, Sample, Experiment) %>%
                arrange(Time) %>%
                mutate(Time = NULL) %>%
                summarise(values = list(.data$Value), .groups = "keep") %>%
                ungroup("Well") # %>%
                # mutate(GroupID = cur_group_id()) %>%
                # mutate(CurveID = cur_group_rows()) %>%
                # mutate(ReplicateID = c(1:n()))





curves


pairs = combn(c(1:nrow(curves)), 2, simplify = FALSE)
pairs



cli_progress_bar("Processing cross-correlation data", total = length(pairs))

ccf_overall = foreach (ii  = pairs, .combine = rbind) %do% {
    
    i = ii[[1]]
    j = ii[[2]]
  
    c1 = curves[i,"values"] %>% unlist()
    c2 = curves[j,"values"] %>% unlist()
    
    c1 = c1[!is.na(c1)]
    c2 = c2[!is.na(c2)]
    
    corr = ccf(c1, c2, plot = FALSE)
    
    unlist(corr[0])["acf"] %>% as.numeric()
    
    cli_progress_update()
    
    return(bind_cols(curves[i,] %>% rename_with(.fn = function(name){paste(name,"1")}), 
              curves[j,] %>% rename_with(.fn = function(name){paste(name,"2")})) %>%
      mutate(cc = unlist(corr[0])["acf"] %>% as.numeric()))
    
    }

cli_process_done()


ccf_overall %>% ggplot() +
  geom_tile(aes(x = paste(`Experiment 1`, `Well 1`, sep = "\n"), y = paste(`Experiment 2`, `Well 2`, sep = "\n"), fill = cc)) +
  facet_wrap(vars(`Sample 1`, `Sample 2`), scales = "free")

ccf_overall %>% ggplot() +
  geom_tile(aes(x = paste(`Experiment 1`, `Well 1`, sep = "\n"), y = paste(`Experiment 2`, `Well 2`, sep = "\n"), fill = cc)) +
  facet_wrap(vars(`Sample 1`, `Sample 2`), scales = "free")


ccf_exp = ccf_overall %>% group_by_at(vars(-"Well 1", -`Well 2`, -`values 1`, -`values 2`, -`cc`)) %>%
  summarise(ccm = mean(cc))
  
ccf_exp %>% ggplot() +
  geom_tile(aes(x = `Experiment 1`, y = `Experiment 2`, fill = ccm)) +
  facet_wrap(vars(`Sample 1`, `Sample 2`), scales = "free")


ccf_sum = ccf_exp %>% ungroup("Experiment 1", "Experiment 2") %>%
  summarise(ccsem = sd(ccm)/n(), ccm = mean(ccm)) %>%
  mutate(title = paste(`Sample 1`, `Sample 2`))

ccf_sum %>% ggplot() +
  geom_tile(aes(x = `Sample 1`, y = `Sample 2`, fill = ccm))

ccf_sum %>% ggplot() +
  geom_point(aes(y = title, x = ccm)) +
  geom_errorbar(aes(y = title, xmin = ccm-ccsem, xmax = ccm + ccsem))


}


