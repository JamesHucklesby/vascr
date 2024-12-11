#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          
          fileInput("upload", "Upload a file"),
          
          
            sliderInput("Time",
                        "Number of bins:",
                        min = min(vascr::growth.df$Time),
                        max = min(vascr::growth.df$Time),
                        value = 30),
            selectInput("Unit", "Unit", choices = unique(vascr::growth.df$Unit)),
            checkboxGroupInput("wellexclude", "What animals do you like?", unique(paste(vascr::growth.df$Experiment, "=>", vascr::growth.df$Well)))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        #x    <- faithful[, 2]
        #bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white',
        #      xlab = 'Waiting time to next eruption (in mins)',
        #      main = 'Histogram of waiting times')
      
      file_location = (input$upload)$datapath
      
      print(input$upload)
      print(tools::file_path_sans_ext(basename(file_location)))
      
      importeddata = ecis_import(raw = file_location, experiment = tools::file_path_sans_ext((input$upload)$name))
      
      importeddata$Sample = importeddata$Well
      
      localgrowth = importeddata
      
      for (well in input$wellexclude) {
          metadata = str_split("A => B", " => ")
         localgrowth = vascr_subset(localgrowth, well = paste("-", metadata[2], sep = ""))
      }
        
        localgrowth %>% vascr_subset(unit = input$Unit, frequency = 4000) %>%
          vascr_plot_line()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

