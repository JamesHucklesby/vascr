library(shiny)


vascr_matrix_dropdown = function(var, id){
  selectInput(paste(id, var, sep ="_"), paste(id,var, sep ="_"), choices = c("test1", "test2"))
}

vascr_matrix = function(id, var1) {
  
lapply(var1, vascr_matrix_dropdown, id)
  
}


vascr_matrix_update_dropdown = function(session, id, var, input, item, title, choices)
{
  id = glue("{id}_{item}")
  
  observe({ updateSelectInput(session, id , label = title, choices  = choices, selected = var[[item]])})
  
  observeEvent(input[[id]], {
    if(var[[item]] != input[[id]])
    {
      print(var[[item]])
      var[[item]] = input[[id]]
    }
  })
  
}

vascr_matrix_update = function(session, id, var, input){
  vascr_matrix_update_dropdown(session, id, var, input, "frequency", "Frequency", c("A", "B", "C"))
  vascr_matrix_update_dropdown(session, id, var, input, "unit", "unit", c("Rb", "B", "C"))
}

# Integrating the Module into a Shiny App
ui <- fluidPage(

  navbarPage("My Application",
             tabPanel(
               "Import Raw Data",
               sidebarLayout(
                 sidebarPanel(
                    vascr_matrix("id1", c("frequency", "unit"))
                 ),
                 mainPanel()
               )
             ),
             tabPanel(
               "Import Raw Data",
               sidebarLayout(
                 sidebarPanel(
                   vascr_matrix("id2", c("frequency", "unit"))
                 ),
                 mainPanel()
               )
             )
  )
)


server <- function(input, output, session) {
  glob = reactiveValues()
  glob[["frequency"]] = "0"
  glob[["unit"]] = "0"
  
  vascr_matrix_update(session,"id1", glob, input)
  vascr_matrix_update(session,"id2", glob, input)


}

shinyApp(ui, server)



