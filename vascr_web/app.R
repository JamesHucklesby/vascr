#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)
library(vascr)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  navbarPage("vascr",
             tabPanel(
               "Import Data",
               sidebarLayout(
                 sidebarPanel(
                   fileInput("raw", "Raw Data"),
                   fileInput("model", "Modeled Data"),
                   fileInput("map", "Platemap"),
                   textInput("name", "Experiment name"),
                   actionButton("run_import", "Run the import")
                 ),
                 mainPanel(dataTableOutput("importtable"))
               )
             ),
             tabPanel("Component 2"),
             tabPanel("Component 3")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$importtable <- renderDataTable(growth.df)
  
  
  # output$distPlot <- renderPlot({
  #   
  #   file_location = (input$upload)$datapath
  #   
  #   print(input$upload)
  #   print(tools::file_path_sans_ext(basename(file_location)))
  #   
  #   importeddata = ecis_import(raw = file_location, experiment = tools::file_path_sans_ext((input$upload)$name))
  #   
  #   importeddata$Sample = importeddata$Well
  #   
  #   localgrowth = importeddata
  #   
  #   for (well in input$wellexclude) {
  #     metadata = str_split("A => B", " => ")
  #     localgrowth = vascr_subset(localgrowth, well = paste("-", metadata[2], sep = ""))
  #   }
  #   
  #   localgrowth %>% vascr_subset(unit = input$Unit, frequency = 4000) %>%
  #     vascr_plot_line()
  #   
  # })
}

# Run the application 
shinyApp(ui = ui, server = server)

