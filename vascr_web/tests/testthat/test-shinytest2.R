library(shinytest2)

test_that("{shinytest2} recording: vascr_web", {
  app <- AppDriver$new(variant = platform_variant(), name = "vascr_web", height = 911, 
      width = 1619)
  rlang::warn(paste0("`raw` should be the path to the file, relative to the app's tests/testthat directory.\n", 
      "Remove this warning when the file is in the correct location."))
  app$upload_file(raw = "growth1_raw_TimeResample.abp")
  app$click("run_import")
  app$expect_screenshot()
  app$expect_screenshot()
  app$expect_values()
})
