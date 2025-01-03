#' Title
#'
#' @param data.df 
#'
#' @returns
#' 
#' @importFrom dplyr full_join ungroup tibble tribble filter group_by summarise
#' 
#' 
#' @export
#'
#' @examples
#' #vascr_shiny(growth.df)
#' #vascr_shiny()
vascr_shiny = function(data.df){
  
  rlang::check_installed(c("shiny", "DT", "shinyjs"))
  
  selectInput = shiny::selectInput
  moduleServer = shiny::moduleServer
  checkboxGroupInput = shiny::checkboxGroupInput
  DTOutput = DT::DTOutput
  plotOutput = shiny::plotOutput
  fluidRow = shiny::fluidRow
  tagList = shiny::tagList
  shinyApp = shiny::shinyApp
  NS = shiny::NS
  tags = shiny::tags
  HTML = shiny::HTML
  conditionalPanel = shiny::conditionalPanel
  navbarPage = shiny::navbarPage
  title = graphics::title
  tabPanel = shiny::tabPanel
  selectInput= shiny::selectInput
  checkboxGroupInput= shiny::checkboxGroupInput
  observe= shiny::observe
  updateSelectInput= shiny::updateSelectInput
  moduleServer= shiny::moduleServer
  observeEvent= shiny::observeEvent
  updateCheckboxGroupInput= shiny::updateCheckboxGroupInput
  selectInput= shiny::selectInput
  updateSliderInput= shiny::updateSliderInput
  sliderInput= shiny::sliderInput
  fluidPage= shiny::fluidPage
  useShinyjs= shinyjs::useShinyjs
  conditionalPanel= shiny::conditionalPanel
  tabPanel= shiny::tabPanel
  sidebarPanel= shiny::sidebarPanel
  sidebarLayout = shiny::sidebarLayout
  mainPanel= shiny::mainPanel
  fileInput= shiny::fileInput
  textInput= shiny::textInput
  actionButton= shiny::actionButton
  uiOutput= shiny::uiOutput
  tabPanel= shiny::tabPanel
  downloadButton= shiny::downloadButton
  renderText= shiny::renderText
  reactiveVal= shiny::reactiveVal
  reactive= shiny::reactive
  reactiveValues= shiny::reactiveValues
  renderDT = DT::renderDT
  eventReactive= shiny::eventReactive
  observeEvent= shiny::observeEvent
  reset = shinyjs::reset
  req= shiny::req
  renderUI= shiny::renderUI
  checkboxGroupInput= shiny::checkboxGroupInput
  bindCache= shiny::bindCache
  renderPlot= shiny::renderPlot
  
  ui = NULL
  server = NULL
  
source("vascr_web/app.R", local = TRUE)

shinyApp(ui = ui, server = server)


}


