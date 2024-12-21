


test_that("Can summarise", {
  
  rbgrowth.df = growth.df %>% vascr_subset(unit = "Rb")
  
  expect_snapshot(vascr_summarise(rbgrowth.df, level = "summary"))
		
  expect_snapshot(vascr_summarise(rbgrowth.df, level = "experiments"))
  
  expect_snapshot(vascr_summarise(rbgrowth.df, level = "experiments") %>% vascr_summarise(level = "summary"))
	
  expect_snapshot(vascr_summarise(rbgrowth.df, level = "wells"))
  
  expect_snapshot(vascr_summarise(rbgrowth.df, level = "median_deviation"))
  
  
  expect_snapshot_error(vascr_summarise_experiments(vascr_summarise(rbgrowth.df, "summary")))
  
  expect_snapshot(vascr_summarise_summary(vascr_summarise(rbgrowth.df, "summary")))
  
  expect_snapshot(vascr_summarise(growth_unresampled.df %>% vascr_subset(unit = "R", frequency = 4000), "summary"))
  
})


test_that("Can summarise deviation",{
  expect_snapshot(vascr_summarise(rbgrowth.df, level = "median_deviation"))
})

test_that("Can normalise", {
  
  rgrowth.df = growth.df %>% vascr_subset(unit = "R", frequency = 4000, time = c(5,100))
  expect_snapshot(vascr_normalise(data.df = rgrowth.df, 100))
  expect_snapshot(vascr_normalise(rgrowth.df, 100, divide = TRUE))
  
  rgrowth.df = growth.df %>% vascr_subset(unit = "R", frequency = 4000)
  expect_snapshot(vascr_normalise(rgrowth.df, 100))

})


test_that("Can subsample", {
  
  expect_snapshot(vascr_subsample(growth.df, 10))
  expect_snapshot(vascr_subsample(growth.df, Inf))
  expect_snapshot(vascr_subsample(growth.df %>% vascr_subset(time = 10), 10))
  
})

test_that("Can interpolate time", {
  expect_snapshot(vascr_interpolate_time(growth.df %>% vascr_subset(unit = "Rb")))
  expect_error(vascr_interpolate_time(growth.df))
})

test_that("vascr_force_resampled", {
  expect_snapshot(vascr_force_resampled(growth.df))
  expect_snapshot(vascr_force_resampled(growth_unresampled.df))
})

test_that("vascr time samples counts correctly", 
{
  expect_snapshot(vascr_find_count_timepoints(growth.df))
})


test_that("remove metadata",
{
  expect_snapshot(growth.df%>% vascr_remove_metadata())
  expect_snapshot(vascr_summarise(growth.df, "experiments") %>% vascr_remove_metadata())
})
























