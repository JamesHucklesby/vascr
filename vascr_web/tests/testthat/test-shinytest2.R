library(shinytest2)

test_that("{shinytest2} recording: vascr_web", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web", height = 1277, 
      width = 2228)
  app$expect_screenshot()
  app$set_inputs(experiment_name = "Test")
  app$set_inputs(experiment_name = "Test1")
  app$click("run_import")
  app$expect_values()
})


test_that("{shinytest2} recording: vascr_web_import", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web_import", height = 1277, 
      width = 2228)
  app$click("load_default")
  app$expect_screenshot()
  app$expect_screenshot()
  app$expect_screenshot()
  app$set_inputs(qc_wells_excluded = "D01")
  app$expect_screenshot()
})


test_that("{shinytest2} recording: vascr_web_linegraph", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web_linegraph", 
      height = 1277, width = 2228)
  app$click("load_default")
  app$expect_screenshot()
})


test_that("{shinytest2} recording: linegraph v2", {
  app <- AppDriver$new(variant = platform_variant(), name = "linegraph v2", height = 1277, 
      width = 2228)
  app$set_inputs(wells_excluded_state = c(1736230799380, 0, 10, "", TRUE, FALSE, 
      TRUE, c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, 
          "", TRUE, FALSE, TRUE)), allow_no_input_binding_ = TRUE)
  app$click("load_default")
  app$expect_screenshot()
})


test_that("{shinytest2} recording: vascr_web_line3", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web_line3", height = 1277, 
      width = 2228)
  app$click("load_default")
  app$set_inputs(`line2-unit` = "P")
  app$set_inputs(`line2-frequency` = "1000")
  app$set_inputs(`line2-sample` = c("35,000_cells + HCMEC D3_line", "30,000_cells + HCMEC D3_line", 
      "25,000_cells + HCMEC D3_line", "20,000_cells + HCMEC D3_line", "15,000_cells + HCMEC D3_line", 
      "10,000_cells + HCMEC D3_line", "5,000_cells + HCMEC D3_line"))
  app$set_inputs(`line2-sample` = c("35,000_cells + HCMEC D3_line", "30,000_cells + HCMEC D3_line", 
      "25,000_cells + HCMEC D3_line", "20,000_cells + HCMEC D3_line", "15,000_cells + HCMEC D3_line", 
      "10,000_cells + HCMEC D3_line"))
  app$expect_screenshot()
})


test_that("{shinytest2} recording: vascr_web 5", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web 5", height = 1277, 
      width = 2228)
  app$click("load_default")
  app$set_inputs(edit_labels_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), allow_no_input_binding_ = TRUE)
  app$set_inputs(edit_labels_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 
      13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24), allow_no_input_binding_ = TRUE)
  app$set_inputs(edit_labels_state = c(1736231624696, 0, 10, "", TRUE, FALSE, TRUE, 
      c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", 
          TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE)), allow_no_input_binding_ = TRUE)
  app$set_inputs(wells_excluded_state = c(1736231644578, 0, 10, "", TRUE, FALSE, 
      TRUE, c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, 
          "", TRUE, FALSE, TRUE)), allow_no_input_binding_ = TRUE)
  app$expect_screenshot()
})


test_that("{shinytest2} recording: vascr_web 6", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web 6", height = 1277, 
      width = 2228)
  app$click("load_default")
  app$set_inputs(edit_labels_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), allow_no_input_binding_ = TRUE)
  app$set_inputs(edit_labels_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 
      13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24), allow_no_input_binding_ = TRUE)
  app$set_inputs(edit_labels_state = c(1736231907030, 0, 10, "", TRUE, FALSE, TRUE, 
      c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", 
          TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE)), allow_no_input_binding_ = TRUE)
  app$expect_screenshot()
})
