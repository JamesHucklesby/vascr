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
library(shinyjs)
library(vascr)

# Run the application
x_e <- new.env(parent = emptyenv())
x_e$data <- vascr::growth.df

shinyApp(vascr:::vascr_ui(), vascr:::vascr_serve(NULL))


