
function (){
timepoints = c(1:10)/10*pi*1

ccf_curves = tribble(~"Experiment", ~"Well", ~"Sample", ~`Value`,
                     "1", "A1", "Baseline", c(sin(timepoints)),
                     "1", "A4", "Smaller magnitude", c(sin(timepoints)*0.7),
                     "1", "A5", "Larger magnitude", c(sin(timepoints)*0.7),
                     "1", "A6", "Flatline", c(sin(timepoints*5))) %>%
                    mutate(Unit = "R", Frequency = 4000, Time = list(timepoints), Instrument = "ECIS", SampleID = as.numeric(as.factor(Sample)))

ccf.df = ccf_curves %>% unnest(cols = c(Value, Time))

vascr_plot_line(ccf.df, text_labels = FALSE)

cc = ccf.df %>% vascr_cc() 
ccf.df %>% vascr_cc() %>% vascr_summarise_cc()
ccf.df %>% vascr_cc() %>% vascr_summarise_cc() %>% vascr_plot_cc()

v1 = cc[5,][10] %>% unlist() %>% as.vector()
v2 = cc[5,][5] %>% unlist() %>% as.vector()

ccf(v1, v2)


vascr:::vascr_find_metadata(vascr::growth.df)

data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000)


flat_growth = growth.df %>% group_by_all() %>% ungroup("Value", "Time") %>%
              mutate(Value = Value/max(Value, na.rm = TRUE))

vascr_plot_line(flat_growth %>% vascr_subset(unit = "R", frequency = 4000))


vascr_find_metadata(ecis)
data.df = ecis %>% vascr_subset(unit = "R", frequency = "4000", sampleid = c(1,3,6), time = c(40,85))

vascr_plot_line(data.df)

ccf.df = vascr_cc(data.df)

ccf.df %>% vascr_summarise_cc("summary") %>% vascr_plot_cc()




}

#' Title
#'
#' @return
#' @export
#' 
#' @importFrom cli cli_progress_bar cli_progress_update cli_process_done
#' @importFrom dplyr bind_cols group_by arrange summarise rename_with 
#'
#' @examples
#' data.df = vascr::growth.df %>% vascr_subset(unit = "R", frequency = 4000, sampleid = c(1,4,7))
#' 
#' vascr_cc(data.df)
vascr_cc = function(data.df) {
  
curves = data.df %>%
                filter(!is.na(.data$Value)) %>% 
                group_by(Well, SampleID, Sample, Experiment) %>%
                arrange(Time, SampleID) %>%
                mutate(Time = NULL) %>%
                summarise(values = list(.data$Value), .groups = "keep") %>%
                ungroup("Well") %>%
                arrange("SampleID") 


pairedcurves = inner_join(curves, curves, by = c("Experiment"), relationship = "many-to-many") %>%
                filter(SampleID.x < SampleID.y)



to_export = pairedcurves %>% rowwise() %>% mutate(cc = ccf(unlist(values.x), unlist(values.y), plot = FALSE, lag.max = 0)[["acf"]][[1]])

return(to_export)

}


#' Title
#'
#' @param data.df 
#' @param level 
#'
#' @return
#' 
#' @importFrom dplyr group_by_at summarise ungroup mutate select
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
  
  ccf_exp = data.df %>% ungroup() %>% group_by_at(vars("Sample.x", "Sample.y", "SampleID.x", "SampleID.y", "Experiment")) %>%
    summarise(cc = mean(cc), n = n())
  
  distinct(ccf_exp %>% select(-"cc"))
  
  if(level == "experiments"){
    return(ccf_exp)
  }
  
  ccf_sum = ccf_exp %>% group_by(`Sample.x`, `Sample.y`) %>%
    summarise(ccsem = sd(cc)/n(), cc = mean(cc), totaln = sum(n)) %>%
    mutate(title = paste(`Sample.x`, `Sample.y`, sep = "\n"))
  
  return(ccf_sum)
  
}


#' Title
#'
#' @return
#' 
#' @importFrom ggplot2 geom_tile geom_text facet_wrap scale_colour_manual geom_point geom_errorbar
#' @importFrom dplyr tibble 
#' @importFrom ggtext element_markdown
#' 
#'
#' @examples
#' data.df = vascr::growth.df %>% 
#'             vascr_subset(unit = "R", frequency = 4000, sampleid = c(1,4,7,8), time = c(1,20)) %>%
#'             vascr_cc()
#'
#' data.df %>% vascr_plot_cc()
#' data.df %>% vascr_summarise_cc("experiments") %>% vascr_plot_cc()
#' data.df %>% vascr_summarise_cc("summary") %>% vascr_plot_cc()
#' 
vascr_plot_cc = function(data.df){

if(vascr_find_level(data.df) == "wells"){
  toreturn = data.df %>% ggplot() +
    geom_tile(aes(x = paste(`Experiment`, `Well.x`, sep = "\n"), y = paste(`Experiment`, `Well.y`, sep = "\n"), fill = cc)) +
    geom_text(aes(x = paste(`Experiment`, `Well.x`, sep = "\n"), y = paste(`Experiment`, `Well.y`, sep = "\n"), label = round(cc,3))) +
    facet_wrap(vars(`Sample.x`, `Sample.y`), scales = "free")
 
   return(toreturn)
}

if(vascr_find_level(data.df) == "experiments"){
  toreturn = data.df %>% ggplot() +
  geom_tile(aes(x = `Experiment`, y = `Experiment`, fill = cc)) +
  facet_wrap(vars(`Sample.x`, `Sample.y`), scales = "free")
  
  return(toreturn)
}
  
  data.df %>% ggplot() +
    geom_tile(aes(x = `Sample.x`, y = `Sample.y`, fill = cc))

colours = vascr_gg_color_hue(length(unique(c(data.df$`Sample.x`, data.df$`Sample.y`))))

hue = tibble(Sample = unique(c(data.df$`Sample.x`, data.df$`Sample.y`)), colours = colours)

toplot = data.df %>% left_join(hue, join_by(`Sample.x` == `Sample`)) %>% 
  mutate(hue1 = colours, colours = NULL) %>% 
  left_join(hue, join_by(`Sample.y` == `Sample`)) %>% 
  mutate(hue2 = colours, colours = NULL) %>%
  mutate(title = glue("<span style = 'color:{hue1};'>{`Sample.x`}</span><br>
                       <span style = 'color:{hue2};'>{`Sample.y`}</span>"))
  
toplot %>%
  ggplot() +
  geom_point(aes(y = title, x = cc, color = `Sample.x`)) +
  geom_errorbar(aes(y = title, xmin = cc-ccsem, xmax = cc + ccsem, color = `Sample.y`)) +
  theme(axis.text.y = element_markdown()) +
  scale_colour_manual(values = colours)


}


