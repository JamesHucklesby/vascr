#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

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
    stopApp = shiny::stopApp

  vascr_sub_ui <- function(id, variables) {
    ns <- NS(id)
    tagList(if ("unit" %in% variables) {
      selectInput(ns("unit"), "unit", c("R", "C"))
    }, if ("frequency" %in% variables) {
      selectInput(ns("frequency"), "Frequency", c(4000))
    }, if ("time" %in% variables) {
      selectInput(ns("time"), "time", c(0))
    }, if ("time_range" %in% variables) {
      sliderInput(
        ns("time_range"),
        "Time Range",
        min = 1,
        max = 100,
        value = c(1, 100)
      )
    }, if ("reference" %in% variables) {
      selectInput(ns("reference"), "Reference sample", c("none"))
    }, if ("level" %in% variables) {
      selectInput(ns("level"), "level", c("well", "experiment", "summary"))
    }, if ("sample" %in% variables) {
      checkboxGroupInput(ns("sample"), "Sample", c("yes"))
    })
  }
  
  vascr_sub_server <- function(id, masterdata) {
    moduleServer(id, function(input, output, session) {
      ######### Units
      observe({
        updateSelectInput(
          session,
          "unit",
          selected = session$userData$unit(),
          choices = unique(masterdata()$Unit)
        )
      })
      
      observeEvent(input$unit, {
        session$userData$unit(input$unit)
        session$userData$unit()
      })
      
      
      ################## Frequency
      observe({
        updateSelectInput(
          session,
          "frequency",
          selected = session$userData$frequency(),
          choices = unique(masterdata()$Frequency)
        )
      })
      
      observeEvent(input$frequency, {
        session$userData$frequency(input$frequency)
        session$userData$frequency()
      })
      
      ############# Samples
      observe({
        updateCheckboxGroupInput(
          session,
          "sample",
          selected = session$userData$sample(),
          choices = unique(masterdata()$Sample)
        )
      })
      
      observeEvent(input$sample, {
        session$userData$sample(input$sample)
        session$userData$sample()
      })
      
      ######### Reference
      observe({
        updateSelectInput(
          session,
          "reference",
          selected = session$userData$reference(),
          choices = unique(c("none",c(masterdata()$Sample)))
        )
      })
      
      observeEvent(input$reference, {
        session$userData$reference(input$reference)
        session$userData$reference()
      })
      
      ############# Level
      observe({
        updateCheckboxGroupInput(session, "level", selected = session$userData$level())
      })
      
      observeEvent(input$level, {
        session$userData$level(input$level)
        session$userData$level()
      })
      
      
      ################## time
      observe({
        updateSelectInput(
          session,
          "time",
          selected = session$userData$time(),
          choices = unique(masterdata()$Time)
        )
      })
      
      observeEvent(input$time, {
        session$userData$time(unique(input$time))
      })
      
      ################## time_range
      observe({
        updateSliderInput(
          session,
          "time_range",
          value = session$userData$time_range(),
          max = max(masterdata()$Time),
          min = min(masterdata()$Time)
        )
      })
      
      observeEvent(input$time_range, {
        session$userData$time_range(input$time_range)
      })
      
      
    })
  }
  
  
  # Define UI for application that draws a histogram
  ui <- fluidPage(
    # Activate shinyJS
    useShinyjs(),
    
    # spinner css
    tags$head(tags$style(
      HTML(
        "
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
"
      )
    )),
    
    
    conditionalPanel(
      condition = "$(\'html\').hasClass(\'shiny-busy\')",
      tags$div(class = "centered-text", tags$div(class = "loader"), "Loading - Please wait"),
      tags$div(class = "prevent_click")
    ),
    
    navbarPage(
      "My Application",
      tabPanel("Import Data", sidebarLayout(
        sidebarPanel(
          selectInput(
            "import_instrument",
            "Select Instrument",
            c("ECIS", "xCELLigence", "cellZscope")
          ),
          fileInput("raw", "Upload a raw file"),
          fileInput("model", "Upload a modeled file"),
          fileInput("platemap", "Upload a platemap"),
          textInput("experiment_name", "Experiment Name"),
          actionButton("run_import", "Run Import"),
          actionButton("save_data", "Save current experiment"),
          actionButton("load_default", "Load the default growth.df dataset"),
          fileInput("load_previous", "Upload a previous vascr file")
        ),
        mainPanel(DTOutput("import_data"))
      )),
      tabPanel("Assign Labels", sidebarLayout(
        sidebarPanel(
          uiOutput("label_active_expt"),
          actionButton("add_row", "Add row")
        ), mainPanel(DTOutput("edit_labels"))
      )),
      tabPanel("Detect outliers", sidebarLayout(
        sidebarPanel(uiOutput("active_expt"), uiOutput("qc_well_list"), ),
        mainPanel(plotOutput("qc"), DTOutput("wells_excluded"))
      )),
      tabPanel("Line Graph 2", fluidRow(
        sidebarLayout(
          sidebarPanel(vascr_sub_ui(
            "line2", c("frequency", "sample", "unit", "level", "time_range")
          )),
          mainPanel(plotOutput("line2_graph", height = "90vh"), fluid = FALSE),
          fluid = FALSE
        ), fluid = FALSE
      ), ),
      tabPanel("anova", sidebarLayout(
        sidebarPanel(vascr_sub_ui(
          "anova", c("frequency", "sample", "unit", "time", "reference")
      )),
      mainPanel(
        plotOutput("anova_graph", height = "90vh")
      ))),
      tabPanel("CC", sidebarLayout(
        sidebarPanel(vascr_sub_ui("cc", c(
          "frequency", "sample", "unit", "reference"
        ))), mainPanel(plotOutput("cc_graph", height = "90vh"))
      )),
      tabPanel("Export",
               sidebarPanel(
                 downloadButton('downloadData', 'Download vascr dataframe'),
                 downloadButton('downloadDataP', 'Download prism compatable xlsx spreadsheet'),
                 actionButton("return_to_r", "Return values to R")
               ),
               mainPanel(
                 
               ))
    )
  )
  
  
  # Define server logic required to draw a histogram
  server <- function(input, output, session) {
    
    if(exists("data.df")){
      all_data = reactiveVal({data.df})
      
    } else
    {
      # Setup blank df at outset
      all_data = reactiveVal({
        tibble::tribble( ~ Time, ~ Unit, ~ Well, ~ Value, ~ Frequency, ~ Experiment)
      })
    }
    
    output$progpopup <- renderText({
      "TEST LOAD"
    })
    options(shiny.maxRequestSize = 2^30)


    
    session$userData$unit = reactiveVal("R")
    session$userData$frequency = reactiveVal("100")
    session$userData$sample = reactiveVal("sample")
    session$userData$level = reactiveVal(c("wells"))
    session$userData$time = reactiveVal("0")
    session$userData$time_range = reactiveVal(c(0, 100))
    session$userData$reference = reactiveVal("reference")
    
    
    # Pass through the metadata files for creation
    metadat = reactiveVal({
      growth.df
    })
    
    observe({
      metadat(all_data())
    })
    
    observe({
      vascr_sub_server("line2", metadat)
      vascr_sub_server("cc", metadat)
      vascr_sub_server("anova", metadat)
    })
    
    #///////////////////////////// Import Data /////////////////////////////////////
    
    current_expt_import = eventReactive(input$run_import, {
      req(input$raw)
      importing = ecis_import(input$raw$datapath,
                              input$model$datapath,
                              input$experiment_name)
      
      if (!is.null(input$platemap)) {
        importing = importing %>% vascr_apply_map(input$platemap$datapath)
      } else
      {
        importing$Sample = NA
        importing$SampleID = 1
      }
      
      return(importing)
    })
    
    # Render the test output to screen
    output$import_data = renderDT({
      current_expt_import()
    })
    
    
    observeEvent(input$save_data, {
      # Merge the datasets
      current_data = all_data()
      exp_moving = unique(current_expt_import()$Experiment)
      
      print(exp_moving)
      
      if (exp_moving %in% unique(current_data$Experiment))
      {
        current_data = current_data %>% filter(!Experiment == exp_moving)
        showNotification(glue("Experiment {exp_moving} already imported, overwriting"),
                         type = "warning")
      }
      
      to_output = rbind(current_data, current_expt_import())
      all_data(to_output)
      
      shinyjs::reset("raw")
      shinyjs::reset("model")
      shinyjs::reset("experiment_name")
      shinyjs::reset("platemap")
      
      # current_expt_import(NULL)
      
      print(all_data())
      
    })
    
    
    observeEvent(input$load_previous, {
      req(input$load_previous)
      load_in = read_csv2(input$load_previous$datapath)
      print(load_in)
      all_data(load_in)
    })
    
    
    
    #////////////////////////// Platemap import
    
    output$label_active_expt = renderUI({
      selectInput("active_expt_select",
                  "Active Experiment",
                  choices = unique(all_data()$Experiment))
    })
    
    platemap = reactive({
      all_data(all_data() %>% mutate(Experiment = str_replace_all(Experiment, " ", "_")))
      
      all_data() %>% select("Experiment", "Well", "Sample") %>% distinct() %>%
        group_by(Experiment, Sample) %>%
        summarise(Well = paste(Well, collapse = " "))
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
      table_to_print = platemap()
      datatable(table_to_print, editable = TRUE, escape = F)
    })
    
    observeEvent(input$add_row, {
      all_dat = all_data()
      print(all_dat)
      all_dat[nrow(all_dat) + 1, ] <- NA
      print(all_dat)
      all_data(all_dat)
    })
    
    observeEvent(input$edit_labels_cell_edit, {
      #get values
      info = input$edit_labels_cell_edit
      selectedrow = as.numeric(info$row)
      selectedcol = as.numeric(info$col)
      k = info$value
      
      #write values to reactive
      
      updatedpm = platemap()
      updatedpm[selectedrow, selectedcol] = k
      
      updatedpm = updatedpm %>% separate_longer_delim("Well", delim = " ") %>%
        separate_longer_delim("Experiment", delim = " ")
      
      updateddf = all_data() %>% mutate(Sample = NULL) %>%
        full_join(updatedpm, by = join_by(Well, Experiment)) %>%
        ungroup()
      
      all_data(updateddf)
    })
    
    
    observeEvent(input$load_default, {
      all_data(vascr::growth.df)
    })
    
    all_data_named = reactive({
      alldat = all_data() %>% filter(!is.na(Value))
      session$userData$sample(unique(alldat$Sample))
      alldat
    })
    
    ################################## QC pages ############################################
    
    output$active_expt = renderUI({
      selectInput(
        "active_expt_select",
        "Active Experiment",
        choices = unique(all_data_named()$Experiment)
      )
    })
    
    all_active_expt = reactive({
      all_data_named() %>% filter(Experiment == input$active_expt_select)
    })
    
    excluded_wells = reactiveValues(data = {
      tribble( ~ Well, ~ Experiment)
    })
    
    observeEvent(input$qc_wells_excluded, {
      new_input = input$qc_wells_excluded
      
      new_data = tibble(Well = input$qc_wells_excluded) %>% mutate(Experiment = input$active_expt_select)
      
      excluded_wells$data = excluded_wells$data %>% filter(!Experiment == input$active_expt_select) %>% rbind(new_data)
    }, ignoreNULL = FALSE)
    
    output$wells_excluded = renderDT({
      excluded_wells$data %>% as.data.frame()
    })
    
    
    
    all_data_filtered = reactive({
      newdat = all_data_named() %>% filter(
        !(
          Experiment %in% excluded_wells$data$Experiment &
            Well %in% excluded_wells$data$Well
        )
      )
      
      newdat
    })
    
    all_data_subset_freq = reactive({
      newdat = all_data_filtered() %>%
        vascr_subset(unit = session$userData$unit())
      newdat
    })
    
    all_data_subset_all_samples = reactive({
      all_data_subset_freq() %>% vascr_subset(frequency = session$userData$frequency())
    })
    
    all_data_subset = reactive({
      newdat = all_data_subset_freq() %>% vascr_subset(frequency = session$userData$frequency()) %>%
        filter(Sample %in% session$userData$sample())
      
      print(newdat)
      
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
      
      names = as.list(paste0(
        devs$Well,
        ifelse(
          devs$max > 0.2,
          "<span style = 'color:red'>   &#9888;</span>",
          ""
        )
      ))
      names = lapply(names, HTML)
      checkboxGroupInput(
        "qc_wells_excluded",
        "Exclude wells",
        choiceNames = names,
        choiceValues = devs$Well,
        selected = already_chosen
        
      )
    })
    
    
    grid_data_all = reactive({
      all_data_named() %>%
        vascr_subset(
          unit = "R",
          frequency = 4000,
          experiment = input$active_expt_select
        ) %>%
        vascr_resample_time(npoints = min(
          40,
          vascr:::vascr_find_count_timepoints(all_data_named())
        ))
    })
    
    grid_data_excluded = reactive({
      grid_data_all() %>%
        filter(
          !(
            Experiment %in% excluded_wells$data$Experiment &
              Well %in% excluded_wells$data$Well
          )
        )
    })
    
    output$qc = renderPlot({
      vascr_plot_grid(grid_data_excluded())
    }) %>% bindCache(grid_data_excluded())
    
    
    ############################## Line Plots ##############################
    
    
    output$line2_graph = renderPlot({
      all_data_subset() %>% vascr_subset(time = session$userData$time_range()) %>%
        vascr_summarise(level = session$userData$level()) %>% vascr_plot_line()
    }, height = "100%") %>%
      bindCache(all_data_subset(),
                session$userData$level(),
                session$userData$time_range())
    
    ########################## ANOVA ############################################
    
    output$anova_graph = renderPlot({
      alldat = all_data_subset() %>% 
        vascr_resample_time()
      print(alldat)
      vascr:::vascr_plot_anova(
        alldat,
        frequency = session$userData$frequency(),
        unit = session$userData$unit(),
        time = as.numeric(session$userData$time()),
        reference = session$userData$reference()
      )
      
    })  %>%
      bindCache(all_data_subset(), session$userData$time(), session$userData$reference())
    
    ########################## CC ############################################
    
    output$cc_graph = renderPlot({
      all_data_subset() %>% 
        vascr_cc(reference = session$userData$reference()) %>% 
        vascr:::vascr_summarise_cc() %>% 
        vascr:::vascr_plot_cc()
    }) %>%
      bindCache(all_data_subset(), session$userData$reference())
    
    
    
    ####################### Export ####################################
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("vascr_output", format(Sys.time()), '.csv', sep='')
      },
      content = function(con) {
        write_csv2(all_data(), con)
      }
    )
    
    output$downloadDataP <- downloadHandler(
      filename = function() {
        paste("vascr_output_prism", format(Sys.time()), '.xlsx', sep='')
      },
      content = function(con) {
        vascr_export(all_data(), con)
      }
    )
    
    observe({
      if(input$return_to_r > 0){
        stopApp(all_data())
      }
    })
    
  }
  
  # Run the application
  shinyApp(ui = ui, server = server)
  
