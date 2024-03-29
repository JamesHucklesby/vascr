

test_that("All continuous replications can be drawn", {
  plot <- growth.df %>% vascr_subset(unit = "R", frequency = 4000) %>% vascr_plot_line()
  vdiffr::expect_doppelganger("continuous, summary", plot)

  # plot = vascr_plot(growth.df, 'Rb', replication = 'all')
  # vdiffr::expect_doppelganger("continuous, all", plot)
  # 
  # plot = vascr_plot(growth.df, 'Rb', replication = 'experiment')
  # vdiffr::expect_doppelganger("continuous, experiment", plot)
})

test_that("Outlier QC", {
  plot <- vascr_plot_deviation(growth.df)
  vdiffr::expect_doppelganger("outlier finder", plot)
  
})


# test_that("All moddeled variables work", {
#   plot <- vascr_plot(growth.df,"Rb", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Rb", plot)
# 
#   plot <- vascr_plot(growth.df,"Cm", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Cm", plot)
# 
#   plot <- vascr_plot(growth.df,"Alpha", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Alpha", plot)
# 
#   plot <- vascr_plot(growth.df,"RMSE", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, RMSE", plot)
# 
#   plot <- vascr_plot(growth.df,"Drift", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Drift", plot)
# 
# })



