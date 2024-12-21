#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
library(DT)
library(vascr)



vascr_matrix_dropdown = function(var, id){
  selectInput(paste(id, var, sep ="_"), paste(id,var, sep ="_"), choices = c("test1", "test2"))
}

vascr_matrix_checklist = function(var, id){
  checkboxGroupInput(paste(id, var, sep ="_"), paste(id,var, sep ="_"), choices = c("test1", "test2"))
}

vascr_matrix = function(id, var1) {
  

  stringlist = paste(
      if("frequency" %in% var1){vascr_matrix_dropdown("frequency", id)},
      if("unit" %in% var1){vascr_matrix_dropdown("unit", id)},
      if("level" %in% var1){vascr_matrix_dropdown("level", id)},
      if("single_time" %in% var1){vascr_matrix_dropdown("single_time", id)},
      if("sample" %in% var1){vascr_matrix_checklist("sample", id)}
  )
  
  wellPanel(HTML(stringlist))
  
}


vascr_matrix_update_dropdown = function(session, id, var, input, item, title, choices)
{
  id = glue("{id}_{item}")
  
  observeEvent(input[[id]], {
    if(var[[item]] != input[[id]])
    {
      var[[item]] = input[[id]]
    }
  })
  
  observe({ updateSelectInput(session, id , label = title, choices  = choices, selected = var[[item]])})
  
}

vascr_matrix_update_checklist = function(session, id, var, input, item, title, choices)
{
  id = glue("{id}_{item}")
  
  observeEvent(input[[id]], {
    if(!identical(var[[item]], input[[id]]))
    {
      var[[item]] = input[[id]]
    }
  })
  
  observe({ updateCheckboxGroupInput(session, id , label = title, choices  = choices, selected = var[[item]])})
  
}

vascr_matrix_update = function(session, id, var, input, masterdata, glob){
  vascr_matrix_update_dropdown(session, id, var, input, "frequency", "Frequency", unique(masterdata$Frequency))
  vascr_matrix_update_dropdown(session, id, var, input, "unit", "unit", unique(masterdata$Unit))
  vascr_matrix_update_dropdown(session, id, var, input, "level", "level", c("wells", "experiments", "summary"))
  vascr_matrix_update_dropdown(session, id, var, input, "single_time", "single_time", unique(masterdata$Time))
  vascr_matrix_update_checklist(session, id, var, input, "sample", "sample", unique(masterdata$Sample))
}

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # spinner css
  tags$head(
    tags$style(HTML("
          /* Centered text styling */
      .centered-text {
          position:fixed; 
          z-index:8; 
          top:10%; left:45%;
          height:100vh;
      }
      

      /* Loader styling */
      .loader {
        z-index: 8;
        border: 16px solid #999999;
        border-top: 16px solid #8B0000; /* Red top border for spinner */
        border-radius: 50%;
        width: 120px;
        height: 120px;
        animation: spin 2s linear infinite;
        background-color: transparent;
        margin-top: 60px; /* Space between text and loader */
      } 

      /* Prevent click overlay styling */
      .prevent_click {
        position: fixed; 
        z-index: 9;
        width: 100%;
        height: 100vh;
        background-color: transparent;   
      }

      /* Keyframes for loader animation */
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
"))
  ),
  
  #display load spinner when shiny is busy
  # conditionalPanel(
  #   condition = "$(\'html\').hasClass(\'shiny-busy\')",
  #   tags$div(class = "loader"),
  #   tags$div(class = "load_message", "loading ..."),
  #   tags$div(class = "prevent_click")
  # ),
  
   conditionalPanel(
    condition = "$(\'html\').hasClass(\'shiny-busy\')",
    tags$div(class = "centered-text", tags$div(class = "loader"), "Welcome to the Shiny App!"),
    tags$div(class = "prevent_click")
  ),
  
  navbarPage("My Application",
             tabPanel(
               "Import Raw Data",
               sidebarLayout(
                 sidebarPanel(
                     selectInput("import_instrument", "Select Instrument", c("ECIS", "xCELLigence", "cellZscope")),
                     fileInput("raw", "Upload a raw file"),
                     fileInput("model", "Upload a modeled file")
                 ),
                 mainPanel(DTOutput("import_data"))
               )
             ),
             tabPanel("Assign Labels",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput("key", "Upload a key"),
                          actionButton("add_row", "Add Row")
                        ),
                        mainPanel(DTOutput("edit_labels"))
                      )
             ),
             tabPanel("Detect outliers",
                        sidebarLayout(
                          sidebarPanel(
                            uiOutput("active_expt"),
                            uiOutput("qc_well_list"),
                          ),
                          mainPanel(plotOutput("qc"), DTOutput("wells_excluded"))
                        )
                      ),
             tabPanel("Line Graph 2",
                      sidebarLayout(
                        sidebarPanel(
                          vascr_matrix("line2", c("unit", "frequency", "level", "sample"))
                        ),
                        mainPanel(
                          plotOutput("line2_graph")
                        )
                      )),
             tabPanel("anova",
                      sidebarLayout(
                        sidebarPanel(
                          vascr_matrix("anova", c("unit", "frequency", "single_time", "sample"))
                        ),
                        mainPanel(
                          plotOutput("anova_graph")
                        )
                      )),
             tabPanel("CC",
                      sidebarLayout(
                        sidebarPanel(
                          vascr_matrix("cc", c("unit", "frequency", "sample")),
                          input_task_button("btn", "Add numbers"),
                        ),
                        mainPanel(
                          plotOutput("cc_graph")
                        )
                      ))
  )
)
  

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$progpopup <- renderText({"TEST LOAD"}) 
  
  glob = reactiveValues()
  glob[["frequency"]] = "0"
  glob[["unit"]] = "0"
  glob[["level"]] = "0"
  glob[["single_time"]] = "0"
  glob[["sample"]] = "0"
  glob[["frequency_options"]] = c("1", "100")
  
  vascr_matrix_update(session,"cc", glob, input, all_data_named(), glob)
  vascr_matrix_update(session,"anova", glob, input, all_data_named(), glob)
  vascr_matrix_update(session,"line2", glob, input, all_data_named(), glob)
  
  #all_data = growth.df %>% filter(FALSE)
  #screen_data = growth.df %>% filter(FALSE)
  
  all_data = reactive({
    req(input$raw)
    print(input$raw)
    ecis_import(input$raw$datapath, input$model$datapath)
  })
  
  output$import_data = renderDT({
    all_data()
  })
  
  map_data = reactiveValues(data = {
    tribble(~Row, ~Column, ~Sample, 1,2,3) %>%
      dplyr::mutate(
        dplyr::across(Row, as.character),
        dplyr::across(Column, as.character),
        dplyr::across(Sample, as.character))
  })
  
    # Auxiliary function
  shinyInput <- function(FUN, len, id, ...) {
    inputs <- character(len)
    for (i in seq_len(len)) {
      inputs[i] <- as.character(FUN(paste0(id, i), ...))
    }
    inputs
  }
  
  output$edit_labels <- renderDT({
        table_to_print = map_data$data
        table_to_print$delete =shinyInput(actionButton, nrow(table_to_print),'delete_',label = "Delete",icon=icon("trash"),
                                                      style = "color: red;background-color: white",
                                                      onclick = paste0('Shiny.onInputChange( \"delete_button\" , this.id, {priority: \"event\"})'))
         datatable(table_to_print, editable = TRUE, escape = F)
  })
  
  observeEvent( input$delete_button, {
    selectedRow <- as.numeric(strsplit(input$delete_button, "_")[[1]][2])
    print(selectedRow)
    map_data$data <<- map_data$data[-selectedRow,]
  })
  
  
  observeEvent(input$add_row, {
     print("Row added")
      map_data$data[nrow(map_data$data) +1,] = NA
  })
  
  observeEvent(input$key, {
    map_data$data = read.csv(input$key$datapath)
  })
  
  observeEvent(input$edit_labels_cell_edit, {
    #get values
    info = input$edit_labels_cell_edit
    i = as.numeric(info$row)
    j = as.numeric(info$col)
    k = info$value
    
    #write values to reactive
    map_data$data[i,j] <- k
    
    print(map_data$data)
    
    print(vascr_import_map(map_data$data))
  })
  
  
  ################################## QC pages ############################################
  all_data_named = reactive({
    growth.df
    # Change to vascr_plot_grid(vascr_apply_map(all_data(), map_data$data) %>% mutate(Experiment = "TEST")
  })
  
  output$active_expt = renderUI({
    selectInput("active_expt_select", "Active Experiment", 
                       choices = unique(all_data_named()$Experiment)
                       )
  })
  
  all_active_expt = reactive({
    growth.df %>% filter(Experiment == input$active_expt_select)
  })
  
  excluded_wells = reactiveValues(data = {
      tribble(~Well, ~Experiment)
  })
  
  observeEvent(input$qc_wells_excluded, {
    new_input = input$qc_wells_excluded
    
    new_data = tibble(Well = input$qc_wells_excluded) %>% mutate(Experiment = input$active_expt_select)
    
    excluded_wells$data = excluded_wells$data %>% filter(!Experiment == input$active_expt_select) %>% rbind(new_data)
  }, ignoreNULL = FALSE)
  
  output$wells_excluded = renderDT({excluded_wells$data %>% as.data.frame()})
  
  
  
  all_data_filtered = reactive({
    newdat = all_data_named() %>% filter(!(Experiment %in% excluded_wells$data$Experiment & Well %in% excluded_wells$data$Well))
    
    glob[["frequency"]] = "1000"
    glob[["unit"]] = "R"
    glob[["level"]] = "experiments"
    glob[["single_time"]] = max(newdat$Time)
    glob[["sample"]] = unique(newdat$Sample)
    
    newdat
  })
  
  all_data_subset_freq = reactive({
    newdat = all_data_filtered() %>% 
      vascr_subset(unit = glob[["unit"]])
    newdat
  })
  
  all_data_subset_all_samples = reactive({
    all_data_subset_freq() %>% vascr_subset(frequency = glob[["frequency"]])
  })
  
  all_data_subset= reactive({

    newdat = all_data_subset_freq() %>% vascr_subset(frequency = glob[["frequency"]]) %>%
              filter(Sample %in% glob[["sample"]])
      
    glob[["single_time"]] = max(newdat$Time)
    
    newdat
  })
  
  
  
  deviation = reactive({
                              all_data_named() %>% 
                                vascr_subset(unit = "R", frequency = 4000) %>% 
                                vascr:::vascr_summarise_deviation() %>%
                                group_by(Well, Experiment) %>% 
                                summarise(max = max(Median_Deviation, na.rm = TRUE))
  })
  
  
  output$qc_well_list = renderUI({
    already_chosen = (excluded_wells$data %>% filter(Experiment == input$active_expt_select))$Well
    devs = (deviation() %>% filter(Experiment == input$active_expt_select))
    
    names = as.list(paste0(devs$Well, ifelse(devs$max > 0.2, "<span style = 'color:red'>   &#9888;</span>", "")))
    names = lapply(names, HTML)
    checkboxGroupInput("qc_wells_excluded", "Exclude wells", 
                       choiceNames = names,
                       choiceValues = devs$Well,
                       selected = already_chosen
                       
                       )
  })
  
  
  grid_data_all = reactive({
    all_data_named() %>% 
      vascr_subset(unit = "R", frequency = 4000, experiment = input$active_expt_select) %>%
      vascr_resample_time(npoints = min(40, vascr_find_count_timepoints(all_data_named())))
  })
  
  grid_data_excluded = reactive({
   grid_data_all() %>%
      filter(!(Experiment %in% excluded_wells$data$Experiment & Well %in% excluded_wells$data$Well)) 
  })
  
  output$qc = renderPlot({
    vascr_plot_grid(grid_data_excluded())
  }) %>% bindCache(grid_data_excluded())
  
  
  ############################## Line Plots ##############################

   
   output$line2_graph = renderPlot({
     all_data_subset() %>% vascr_summarise(level = input$line2_level) %>% vascr_plot_line()
   }) %>%
    bindCache(all_data_subset(), input$line2_level)
   
   ########################## ANOVA ############################################
   
   output$anova_graph = renderPlot({
     alldat = all_data_subset() %>% vascr_resample_time()
     print(alldat)
     vascr_plot_anova(alldat, frequency = input$anova_frequency, unit = input$anova_unit, time = as.numeric(input$anova_single_time))
   })  %>%
      bindCache(all_data_subset(), input$anova_single_time)
   
  ########################## CC ############################################
  
   output$cc_graph = renderPlot({
     all_data_subset() %>% vascr_cc() %>% vascr_summarise_cc() %>% vascr_plot_cc()
      }) %>%
    bindCache(all_data_subset_all_samples(), input$cc_sample)
  
}

# Run the application 
shinyApp(ui = ui, server = server)
