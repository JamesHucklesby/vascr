#' Title
#'
#' @param data.df A vascr dataset to maniuplate
#'
#' @returns a vascr dataset, with the modifications made
#' 
#' @importFrom dplyr full_join ungroup tibble tribble filter group_by summarise
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' vascr_shiny(growth.df)
#' vascr_shiny()
#' }
vascr_shiny = function(data.df = NULL){
  
  ui = NULL
  server = NULL
  
  source("R/vascr_web/app.R", local = TRUE)
  
  returned = shiny::runApp(list(ui = ui, server = server))

  return(returned)
}


#' Make a tribble from underlying R code
#'
#' @param toprint the tribble to print
#' 
#' @importFrom stringr str_remove
#'
#' @returns A copy and pasteable tribble
#' 
#' @noRd
#'
#' @examples
#' mc_tribble(growth.df[1:4,])
#' 
#' 
mc_tribble <- function(toprint) {
  name <- as.character(substitute(toprint))
  name <- name[length(name)]
  
  meat <- capture.output(write.csv(toprint, quote = TRUE, row.names = FALSE))
  meat = paste(meat, ",", sep = "")
  meat[[length(meat)]] = str_remove(meat[[length(meat)]], ",$")
  
  writeLines(meat)

}





