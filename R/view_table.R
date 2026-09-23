# pak::pak("rhandsontable")
# 
# library(shiny)
# library(rhandsontable)
# 
# wells = c()
# 
# foreach(i = c(1:12)) %do% {
#   foreach(j = LETTERS[1:8]) %do% {
#     wells = c(wells, paste0(j, i))
#     return()
#   }
# }
# 
# mutate(
#   Row = str_extract(well, "[A-H]"),
#   Column = str_extract(well, "[0-9]+"),
#   well = NULL,
#   Value = ""
# )
# 
# w2 = tibble(well = wells)
# 
# library(shiny)
# library(miniUI)
# 
# return_data_gadget <- function(data.df) {
#   
#   input_data =  data.df %>%
#     pivot_wider(names_from = Column, values_from = Sample)
#   
#   
#   ui <- miniPage(
#     gadgetTitleBar("Return Data Gadget", left = miniTitleBarCancelButton("cancel")),
#     miniContentPanel(
#       rHandsontableOutput("hot_table")
#     ),
#     miniContentPanel(
#       actionButton("save_btn", "Return Data")
#     )
#   )
#   
#   rv = reactiveValues(data = input_data)
#   
#   server <- function(input, output, session) {
#     
#     # observeEvent(input$save_btn, {
#     #   # The data you want to return to your R session
#     #   # Return the data and close the app
#     #   stopApp(rv$data)
#     # })
#     
#     # Initialize reactive data
#     
#     output$hot_table <- renderRHandsontable({
#       rhandsontable(rv$data) %>%
#         hot_cols(highlightRow = TRUE, highlightCol = TRUE,
#                   
#                   renderer = "
#             function(instance, td, row, col, prop, value, cellProperties) {
#             
#             function stringToHslColor(str, saturation = 70, lightness = 50) {
#             
#                     let h1 = 0xdeadbeef ^ 34598093, h2 = 0x41c6ce57 ^ 3945943;
#                     for (let i = 0, ch; i < str.length; i++) {
#                       ch = str.charCodeAt(i);
#                       h1 = Math.imul(h1 ^ ch, 2654435761);
#                       h2 = Math.imul(h2 ^ ch, 1597334677);
#                     }
#                     h1 = Math.imul(h1 ^ (h1 >>> 16), 2246822507);
#                     h1 ^= Math.imul(h2 ^ (h2 >>> 13), 3266489909);
#                     h2 = Math.imul(h2 ^ (h2 >>> 16), 2246822507);
#                     h2 ^= Math.imul(h1 ^ (h1 >>> 13), 3266489909);
#                     
#                     hash =  4294967296 * (2097151 & h2) + (h1 >>> 0);
#                     
#                     const hue = Math.abs(hash % 360);
#                         
#                         // Returns a CSS-ready HSL string
#                         return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
#                       }
#             
#               Handsontable.renderers.TextRenderer.apply(this, arguments);
#               td.style.background = stringToHslColor(value);
#             }
#           ")
#     })
#     
#     # 3. Capture edits and update reactiveVal on button click
#     observeEvent(input$save_btn, {
#       req(input$hot_table) # Ensure table exists
#       
#       # Convert Handsontable to R data.frame
#       updated_df <- hot_to_r(input$hot_table)
#       
#       # Save back to reactiveVal
#       stopApp(updated_df %>%
#                 pivot_longer(cols = -Row, names_to = "Column", values_to = "Sample"))
#     })
#     
#     observeEvent(input$cancel, {
#       stopApp(NULL)
#     })
#   }
#   
#   runGadget(ui, server)
# }
# 
# 
# 
# # w3 = return_data_gadget(w2)
# # 
# # 
# # w4 
# 
# return_data_gadget(read.csv("platemap.csv") %>% select(-X)) %>% write.csv("platemap.csv")
# 
# 
