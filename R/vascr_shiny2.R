# library(shiny)
# library(bslib)
# library(ggplot2)
# library(vascr)
# library(DT)
# library(tidyverse)

vascr_ui = function(){
  test_page = function(pages)
  {
    paste("input.nav === '", pages, "'", sep = "", collapse = " | ")
  }
  
  cpan = function(output, pages){
    conditionalPanel(test_page(pages), uiOutput(output))
  }
  
  nd = function()
  {
    card("No data",  actionButton("load_default", "Load the default growth.df dataset"))
  }
  
  ui <- page_navbar(
    shinyjs::useShinyjs(),
    title = "vascr dashboard",
    id = "nav",
    sidebar =   sidebar(
      cpan("select_unit", c("line", "anova", "cc")),
      cpan("select_frequency", c("line", "anova", "cc")),
      cpan("select_sample", c("line", "anova", "cc")),
      cpan("select_time_single", c("anova")),
      cpan("select_reference", c("anova", "cc")),
      cpan("select_level", c("line", "cc")),
      cpan("select_experiment", c("qc")),
      cpan("qc_wells", c("qc")),
      cpan("select_normalise", c("line"))
    ),
    
    nav_panel("Import data", uiOutput("import_controls", fill = "item")),
    nav_panel("Edit labels", card(DTOutput("edit_labels")), value = "label"),
    nav_panel("Resample time", card(textOutput("original_times"), uiOutput("resample_controls")), plotOutput("resample_graph"), plotOutput("resample_graph_range"), value = "resample"),
    nav_panel("QC", card(plotOutput("plot_qc")), value = "qc"),
    nav_panel("Line graph", card(plotOutput("plot_line")), value = "line"),
    nav_panel("ANOVA", card(plotOutput("plot_ANOVA")), value = "anova"),
    nav_panel("Cross Correlation", card(plotOutput("plot_cc")), value = "cc"),
    nav_panel("Export", card(uiOutput("export_controls"))),
    nav_panel("Log", card(verbatimTextOutput("log")), value = "log"),
    fillable = c("label","qc", "line", "anova", "cc")
  )
  
  return(ui)
}


vascr_serve  = function (data.df)
{
  
  
  server <- function(input, output) {
    
    options(shiny.maxRequestSize=1000*1024^2)
    
    
    l = reactiveVal({})
    
    
    vascr_log = function(l, string)
    {
      tolog = paste(l(), string, "\n")
      print(tolog)
    }
    
    setuplog = observe({
      
      l(vascr_log(l, "# Setup the dataset"))
      l(vascr_log(l, "data.df = vascr_blank_df()"))
      setuplog$destroy()
    })
    
    
    
    raw_dat = reactiveVal({
      growth.df %>% filter(FALSE) %>% mutate(Excluded = FALSE)
    })
    
    
    uniques = reactive({
      uni = list()
      
      unit = unique(dat()$Sample)
      
      return(uni)
    })
    
    # Generate floating UI
    
    output$select_unit = renderUI(selectInput("unit", "Select unit", choices = unique(dat()$Unit)))
    output$select_sample = renderUI(checkboxGroupInput("sample", "Select sample", choices = unique(dat()$Sample), selected = unique(dat()$Sample)))
    output$select_frequency = renderUI(selectInput("frequency", "Select Frequency", choices = unique((dat() %>% filter(Unit == input$unit))$Frequency)))
    output$select_time_single = renderUI(selectInput("time_single", "Select time", choices = unique(dat()$Time)))
    output$select_normalise = renderUI(selectInput("normalise", "Select time to normalise to", choices = c("none",unique(dat()$Time))))
    output$select_reference = renderUI(selectInput("reference", "Select reference", choices = c("none", unique(dat()$Sample)), selected = unique(dat()$Sample)))
    output$select_level = renderUI(selectInput("level", "Select level", choices = c("summary", "experiments", "wells")))
    
    
    
    #///////////////////////////// Import Data /////////////////////////////////////
    
    output$import_controls = renderUI({
      tagList(card(
        card_header("Import default"),
        card_body(
          actionButton("load_default", "Load the default growth.df dataset")),
      ),
      card(
        card_header("Import from instrument"),
        card_body(
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
          actionButton("save_data", "Save current experiment")
        )) ,
      card(
        card_header("Import previous data"),
        card_body(
          fileInput("load_previous", "Upload a previous vascr file"))
      )
      )
    })
    
    observeEvent(input$run_import, {
      
      l(vascr_log(l, "setup"))
      
      log1 = glue("ecis_import({input$raw$name},
                      {input$model$name},
                      {input$experiment_name})")
      
      print(log1)
      
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
      
      
      # Merge the datasets
      current_data = raw_dat()
      exp_moving = unique(importing$Experiment)
      
      print(exp_moving)
      
      if (exp_moving %in% unique(current_data$Experiment))
      {
        current_data = current_data %>% filter(!Experiment == exp_moving)
        showNotification(glue("Experiment {exp_moving} already imported, overwriting"),
                         type = "warning")
      }
      
      to_output = rbind(current_data, importing)
      raw_dat(to_output)
      
      l(vascr_log(l, "# Import a dataset"))
      tolog = paste("imported.df = vascr_import(instrument = '",input$import_instrument,"', raw = '",input$raw$name,"', modeled = '",input$model$name,"', map  = '",input$platemap$name,"', experiment = '",input$platemap$name,"')", sep = "")
      l(vascr_log(l, tolog))
      l(vascr_log(l, "data.df = vascr_combine(data.df, imported.df)"))
      
      shinyjs::reset("raw")
      shinyjs::reset("model")
      shinyjs::reset("experiment_name")
      shinyjs::reset("platemap")
      
      
      
    })
    
    
    observeEvent(input$load_previous, {
      req(input$load_previous)
      load_in = read_csv2(input$load_previous$datapath)
      print(load_in)
      all_data(load_in)
    })
    
    observeEvent(input$load_default, {
      raw_dat(growth.df %>% mutate(Excluded = "no") %>% filter(!is.na(Value)))
      
    })
    
    # ///////////// Re-sample time
    
    
    output$resample_controls = renderUI(
      sliderInput("resample_n", "Number of points to resample", min = 0, max = vascr:::vascr_find_count_timepoints(raw_dat()), value = vascr:::vascr_find_count_timepoints(raw_dat()))
    )
    
    output$original_times = renderText(paste(unique(raw_dat()$Time, collapse = ",")))
    
    output$resample_graph = renderPlot(vascr:::vascr_plot_resample(raw_dat(), newn = input$resample_n))
    
    output$resample_graph_range = renderPlot(vascr:::vascr_plot_resample_range(raw_dat()))
    
    dat = reactive({
      
      if(is.null(input$resample_n))
      {
        npoints = 40
      } else
      {
        npoints = input$resample_n
      }
      
      
      raw_dat() %>% vascr_resample_time(npoints)
    })
    
    
    #////////////////////////// Plate map import
    
    output$label_active_expt = renderUI({
      selectInput("active_expt_select",
                  "Active Experiment",
                  choices = unique(dat()$Experiment))
    })
    
    
    
    
    platemap = reactive({
      raw_dat(raw_dat() %>% mutate(Experiment = str_replace_all(Experiment, " ", "_")))
      
      dat() %>% vascr_subset(time = min(dat()$Time)) %>%
        select("Experiment", "Well", "Sample", "SampleID", "Excluded") %>% distinct() %>%
        group_by(Experiment, Sample, SampleID, Excluded) %>%
        summarise(Well = paste(Well, collapse = " "))
    })
    
    
    c_platemap = reactiveVal({
      tribble(~`Experiment`, ~`Well`, ~`Sample`, ~`SampleID`, ~`Excluded`)
    })
    
    observeEvent(input$nav, {
      
      if(input$nav == "label")
      {
        localmap = platemap()
        print(localmap)
        c_platemap(platemap())
      } else if(nrow(c_platemap())>0)
      {
        updatedpm = c_platemap() %>% separate_longer_delim("Well", delim = " ") %>%
          separate_longer_delim("Experiment", delim = " ")
        
        
        updateddf = raw_dat() %>% mutate(Sample = NULL, SampleID = NULL, Excluded = NULL) %>%
          full_join(updatedpm, by = join_by(Well, Experiment)) %>%
          ungroup()
        
        raw_dat(updateddf)
      }
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
      table_to_print = c_platemap()
      datatable(table_to_print, editable = TRUE, escape = F, options = list(pageLength = nrow(table_to_print)))
    })
    
    # observeEvent(input$add_row, {
    #   all_dat = raw_dat()
    #   print(all_dat)
    #   all_dat[nrow(all_dat) + 1, ] <- NA
    #   print(all_dat)
    #   raw_dat(all_dat)
    # })
    
    observeEvent(input$edit_labels_cell_edit, {
      #get values
      info = input$edit_labels_cell_edit
      selectedrow = as.numeric(info$row)
      selectedcol = as.numeric(info$col)
      k = info$value
      
      #write values to reactive
      
      updatedpm = platemap()
      updatedpm[selectedrow, selectedcol] = k
      
      c_platemap(updatedpm)
      
    })
    
    
    
    ### QC ################################################################
    
    selected_expt = reactiveVal(c("testing"))
    
    output$select_experiment = renderUI(selectInput("experiment", "Select experiment", choices = unique(dat()$Experiment), selected = selected_expt()))
    
    
    deviation = reactive({
      dat() %>%
        vascr_subset(unit = "R", frequency = 4000) %>%
        vascr:::vascr_summarise_deviation() %>%
        group_by(Well, Experiment) %>%
        summarise(max = max(Median_Deviation, na.rm = TRUE))
    })
    
    
    output$qc_wells = renderUI({
      already_chosen = (dat() %>% filter(Excluded == "yes"))$Well
      
      devs = (deviation() %>% filter(Experiment == input$experiment))
      
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
        "qc_wells",
        "Exclude wells",
        choiceNames = names,
        choiceValues = devs$Well,
        selected = already_chosen
        
      )
    })
    
    
    
    grid_data = reactive({
      dat() %>%
        vascr_subset(
          unit = "R",
          frequency = 4000,
          experiment = input$experiment
        ) %>%
        vascr_resample_time(npoints = min(
          40,
          vascr:::vascr_find_count_timepoints(dat())
        ))
    })
    
    output$plot_qc = renderPlot({
      vascr_plot_grid(grid_data())
    })
    
    
    observeEvent(input$qc_wells,{
      selected_expt(input$experiment)
      updatedat = raw_dat() %>% mutate(Excluded = ifelse(Well %in% input$qc_wells & Experiment %in% input$experiment, "yes", "no"))
      raw_dat(updatedat)
    })
    
    
    # Plotted outputs //////////////////////////////////////////////
    
    
    
    # Generate the plotted outputs
    protect = function(plot)
    {
      if (nrow(dat())==0)
      {
        return(ggplot() + geom_text(aes(x = 0, y = 0, label = "No Data")) + theme_void())
      } else
      {
        return(plot)
      }
    }
    
    
    observe({
      
      normtime = if(isTRUE(input$normalise =="none"))
      {
        normtime = NULL
      } else
      {
        normtime = as.numeric(input$normalise)
      }
      
      output$plot_line <- renderPlot(protect(dat() %>% vascr_subset(unit = input$unit, frequency = input$frequency) %>%
                                               filter(Excluded == "no") %>%
                                               filter(Sample %in% input$sample) %>%
                                               vascr_normalise(normtime) %>%
                                               vascr_summarise(level = input$level) %>%
                                               vascr_plot_line()))
      
      print(.Last.value)
    })
    
    
    output$plot_ANOVA <- renderPlot(dat() %>%
                                      filter(Excluded == "no") %>%
                                      filter(Sample %in% input$sample) %>%
                                      vascr_plot_anova(unit = input$unit, frequency = input$frequency,
                                                       time = as.numeric(input$time_single),
                                                       reference = input$reference))
    
    output$plot_cc <- renderPlot(dat() %>%
                                   filter(Excluded == "no") %>%
                                   filter(Sample %in% input$sample) %>%
                                   vascr_subset(unit = input$unit, frequency = input$frequency) %>%
                                   vascr_plot_cc_stats(unit = input$unit, frequency = input$frequency)
    )
    
    # Exporting data
    ####################### Export ####################################
    
    output$export_controls = renderUI({
      tagList(
        downloadButton('downloadDataR', 'Save data'),
        downloadButton('downloadDataCSV', 'Download vascr dataframe'),
        downloadButton('downloadDataP', 'Download prism compatable xlsx spreadsheet'),
        actionButton("return_to_r", "Return values to R"))
    })
    
    output$downloadDataR <- downloadHandler(
      filename = function() {
        paste("vascr_output", format(Sys.time()), '.RData', sep='')
      },
      content = function(con) {
        savedata = dat()
        save(savedata, file = con)
      }
    )
    
    output$downloadDataCSV <- downloadHandler(
      filename = function() {
        paste("vascr_output", format(Sys.time()), '.csv', sep='')
      },
      content = function(con) {
        write_csv2(dat(), con)
      }
    )
    
    output$downloadDataP <- downloadHandler(
      filename = function() {
        paste("vascr_output_prism", format(Sys.time()), '.xlsx', sep='')
      },
      content = function(con) {
        vascr_export(dat(), con)
      }
    )
    
    observeEvent(input$return_to_r , {
      stopApp(dat())
    })
    
    
    ######## Logs
    
    output$log = renderText(l())
    
  }
}

#' Title
#'
#' @returns
#' @export
#'
#' @examples
vascr_shiny = function(){
  
  library(shiny)
  library(bslib)
  library(ggplot2)
  library(DT)
  library(tidyverse)
  
  application = shinyApp(vascr_ui, vascr_serve(growth.df))
  
  # toreturn = runApp(application)
  
}

# vascr_shiny()

