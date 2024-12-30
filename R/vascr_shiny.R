#' Title
#'
#' @param data.df 
#'
#' @returns
#' 
#' @importFrom shiny fluidPage
#' @importFrom DT DTOutput
#' @importFrom shinyjs useShinyjs
#' 
#' @export
#'
#' @examples
#' vascr_shiny(growth.df)
#' vascr_shiny()
vascr_shiny = function(data.df){
  
  selectInput = shiny::selectInput
  moduleServer = shiny::moduleServer
  checkboxGroupInput = shiny::checkboxGroupInput
  DTOutput = DTOutput

source("vascr_web/app.R", local = TRUE)

shinyApp(ui = ui, server = server)


}