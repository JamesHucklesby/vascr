#' Title
#'
#' @param data.df 
#' @param filepath 
#'
#' @returns A dataframe in prism format, or writes to file if filepath specified
#' @export
#'
#' @examples
#' filepath = tempfile("test_export", fileext = ".xlsx")
#' vascr_export(data.df, filepath)
#' 
vascr_export = function(data.df, filepath = NULL){
  
  if(!is.null(filepath)) {rlang::check_installed("writexl")}

comboes = data.df %>% select("Unit", "Frequency") %>%
  distinct() %>%
  mutate(names = paste(Unit, Frequency))


output = foreach(combo = c(1:nrow(comboes)), .final = function(x) setNames(x, comboes$names)) %do%
{
  combodata = comboes[combo,]
  prismed_expt = data.df %>%
    vascr_subset(unit = combodata$Unit, frequency = combodata$Frequency) %>%
    vascr_summarise(level = "experiments") %>%
    select("Sample", "Value", "Time", "Experiment") %>%
    mutate(Experiment = paste("[",as.numeric(Experiment),"]", sep = "")) %>%
    mutate(Sample = str_replace_all(Sample, ",", " ")) %>%
    pivot_wider(names_from = c("Sample", "Experiment"), values_from = "Value", names_repair = "minimal", id_cols = c("Time")) %>%
    arrange(Time)
  
   colnames(prismed_expt) = colnames(prismed_expt) %>% str_remove("_\\[.*")
   
   prismed_expt
}

 if(!is.null(filepath))
 {
  writexl::write_xlsx(output, filepath)
 } else
 {
   return(output)
 }
}



