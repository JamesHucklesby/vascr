test_that("export works", {

  small_growth = growth.df %>% vascr_subset(time = c(0,10), well = c("A01", "A02", "A03", "A04"), unit = c("R", "Rb"))
  expect_snapshot(vascr_export(small_growth))
  
  filepath = tempfile("test_export", fileext = ".xlsx")
  vascr_export(small_growth, filepath)
  expect_snapshot(readxl::read_xlsx(filepath))
  
})
