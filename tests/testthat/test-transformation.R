


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
  
  expect_snapshot(vascr_normalise(growth.df, NULL))

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

#vascr auc
test_that("vascr AUC works", 
          {
            expect_snapshot(vascr_auc(growth.df %>% vascr_subset(experiment = 1, well = "A01", unit = "R", frequency = 4000)))
          })

# plot resample range
test_that("plot of resample degradation works", 
  {
    vdiffr::expect_doppelganger("plot resample accuracy 1", vascr_plot_resample_range(data.df = growth.df))
})

# plot resample

test_that("Data can be resampled and plotted",{
            vdiffr::expect_doppelganger("vascr_plot_resample raw data", vascr_plot_resample(growth.df))
            vdiffr::expect_doppelganger("vascr_plot_resample raw data", vascr_plot_resample(growth.df, plot = TRUE))
          })

test_that("remove metadata",
{
  expect_snapshot(growth.df%>% vascr_remove_metadata())
  expect_snapshot(vascr_summarise(growth.df, "experiments") %>% vascr_remove_metadata())
})

future::plan("multisession")

test_that("resample stretching works", {
  
  future::plan("multisession")
  
  data.df = growth.df %>% vascr_subset(unit = "R", frequency = "4000", sample =c(1,3,8), time = c(0,50))
  
   t1 = growth.df %>% vascr_subset(unit = "R", frequency = 4000, experiment = 1, sample = "10,000_cells + HCMEC D3_line") %>% vascr_summarise(level = "experiments")
   t2 = growth.df %>% vascr_subset(unit = "R", frequency = 4000, experiment = 1, sample = "30,000_cells + HCMEC D3_line") %>% vascr_summarise(level = "experiments")
   
    expect_snapshot({stretch_cc(t1, t2)})
  
    expect_snapshot(vascr_summarise_cc_stretch_shift(data.df, 8))
    
    expect_snapshot(vascr_summarise_cc_stretch_shift_stats(data.df, 8))
    
    vdiffr::expect_doppelganger("stretch shift stats", vascr_plot_cc_stretch_shift_stats(data.df, 8))
    vdiffr::expect_doppelganger("stretch shift stats all comps", vascr_plot_cc_stretch_shift_stats(data.df))
  
})





























































