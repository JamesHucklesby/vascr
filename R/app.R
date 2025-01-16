library(shiny)
library(bslib)
library(ggplot2)
data(penguins, package = "palmerpenguins")


test_page = function(pages)
{
  paste("input.nav === '", pages, "'", sep = "", collapse = " | ")
}


ui <- page_navbar(
  title = "Penguins dashboard",
  id = "nav",
  sidebar =   sidebar(
          conditionalPanel(test_page(c("Line graph", "ANOVA")), uiOutput("select_unit")),
          conditionalPanel(test_page(c("Line graph", "ANOVA")), uiOutput("select_frequency")),
          conditionalPanel(test_page(c("Line graph", "ANOVA")), uiOutput("select_sample")),
          conditionalPanel(test_page(c("ANOVA")), uiOutput("select_time_single"))
      ),
  nav_spacer(),
  nav_panel("Line graph", card(plotOutput("plot_line"))),
  nav_panel("ANOVA", card(plotOutput("plot_ANOVA"))),
)

server <- function(input, output) {
  
  
  dat = reactiveVal({
    growth.df
  })
  
  eventReactive(input$sample,
                {
                  print(input$sample)
                }
  )
  
  output$select_unit = renderUI(selectInput("unit", "Select unit", choices = unique(dat()$Unit)))
  output$select_sample = renderUI(checkboxGroupInput("sample", "Select sample", choices = unique(dat()$Sample), selected = unique(dat()$Sample)))
  output$select_frequency = renderUI(selectInput("frequency", "Select Frequency", choices = unique(dat() %>% filter(Unit == input$unit))$Frequency))
  output$select_time_single = renderUI(selectInput("time_single", "Select time", choices = unique(dat()$Time)))
  

  output$plot_line <- renderPlot(dat() %>% vascr_subset(unit = input$unit, frequency = input$frequency) %>%
                                   filter(Sample %in% input$sample) %>%
                                   vascr_summarise(level = "summary") %>% 
                                   vascr_plot_line())
  
  
  output$plot_ANOVA <- renderPlot(dat() %>% vascr_plot_anova(unit = input$unit, frequency = input$frequency, time = as.numeric(input$time_single)))

}

shinyApp(ui, server)
