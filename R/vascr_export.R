#' Export a vascr dataframe
#'
#' @param data.df a vascr dataset to export
#' @param filepath Path to save the dataframe in
#'
#'
#' @importFrom stats setNames
#' @importFrom utils write.csv
#'
#' @returns A dataframe in prism format, or writes to file if filepath specified
#' @export
#'
#' @examples
#' filepath = tempfile("test_export", fileext = ".xlsx")
#' vascr_export(growth.df %>% vascr_subset(unit = c("R", "Rb"), frequency = c(0,4000)), filepath)
#' 
vascr_export = function(data.df, filepath = NULL){
  
  if(!is.null(filepath)) {rlang::check_installed("writexl")}

comboes = data.df %>% select("Unit", "Frequency") %>%
  distinct() %>%
  mutate(names = paste(.data$Unit, .data$Frequency))

combo = 0

output = foreach(combo = c(1:nrow(comboes)), .final = function(x) setNames(x, comboes$names)) %do%
{
  combodata = comboes[combo,]
  prismed_expt = data.df %>%
    vascr_subset(unit = combodata$Unit, frequency = combodata$Frequency) %>%
    vascr_summarise(level = "experiments") %>%
    select("Sample", "Value", "Time", "Experiment") %>%
    mutate(Experiment = paste("[",as.numeric(.data$Experiment),"]", sep = "")) %>%
    mutate(Sample = str_replace_all(.data$Sample, ",", " ")) %>%
    pivot_wider(names_from = c("Sample", "Experiment"), values_from = "Value", names_repair = "minimal", id_cols = c("Time")) %>%
    arrange(.data$Time)
  
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



