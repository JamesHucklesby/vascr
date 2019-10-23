# context("Plots work effectivley")
# 
# 
# test_that("All continuous replications can be drawn", {
#   plot <- ecis_plot(growth.df,"Rb", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, summary", plot)
#   
#   plot = ecis_plot(growth.df, 'Rb', replication = 'all')
#   vdiffr::expect_doppelganger("continuous, all", plot)
#   
#   plot = ecis_plot(growth.df, 'Rb', replication = 'experiment')
#   vdiffr::expect_doppelganger("continuous, experiment", plot)
# })
# 
# 
# test_that("All moddeled variables work", {
#   plot <- ecis_plot(growth.df,"Rb", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Rb", plot)
#   
#   plot <- ecis_plot(growth.df,"Cm", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Cm", plot)
#   
#   plot <- ecis_plot(growth.df,"Alpha", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Alpha", plot)
#   
#   plot <- ecis_plot(growth.df,"RMSE", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, RMSE", plot)
#   
#   plot <- ecis_plot(growth.df,"Drift", replication = "summary")
#   vdiffr::expect_doppelganger("continuous, Drift", plot)
#   
# })
# 
# 
# 
