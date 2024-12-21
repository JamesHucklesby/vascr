

test_that("Linear model", {
  
  expect_snapshot(vascr_lm(growth.df, "R", 4000, 100))
  expect_snapshot(vascr_lm(growth.df, "Rb", 0, 25))
  
})

test_that("Significance table", {
  
  expect_snapshot(vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95))
  expect_snapshot(vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data"))
  
  expect_warning(vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "NA"))
  
})


test_that("Residuals", {
  
  expect_snapshot(vascr_residuals(growth.df, "R", "4000", 100))
  
})


test_that("Shapiro Test", {
  
  expect_snapshot(vascr_shapiro(growth.df, "R", 4000, 100))
  
})

test_that("Levene Test", {
  
  expect_snapshot(vascr_levene(growth.df, "R", 4000, 100))
  
})

test_that("Tukey Test", {
  
  expect_snapshot(vascr_tukey(growth.df, "R", 4000, 100))
  expect_snapshot(vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE))
  
})


# Check ggplots

library(vdiffr)

test_that("ggqqplots work", {
  
  expect_doppelganger("ggqqplot", vascr_plot_qq(growth.df, "R", 4000, 100))
  expect_doppelganger("ggqqplot sans data, fails test)", vascr_plot_qq(growth.df %>% vascr_subset(time = 5), "R", 4000, 5))
  
})




test_that("Normality plot check works", {
  
  expect_doppelganger("Residual normality check", vascr_plot_normality(growth.df, "R", 4000, 100))
  
})



test_that("Levene plot check works", {
  
   expect_doppelganger("Levene test check", vascr_plot_levene(growth.df, "R", 4000, 100))
  
  d1 = growth.df %>% vascr_subset(time = 100, sampleid = c(1,8), unit = "R", frequency = 4000)

  d1 = arrange(d1, Sample)
  d1$Value =  c(-1.807710e+11, -8.325051e+10,  2.175577e+11, -2.248432e+12, -5.538635e+11,
                8.941986e+11, 7.148180e+02, 1.143010e+03, -2.431950e+03,  2.469797e+01,
                -2.769885e+02, -1.683658e+02, -6.513760e-07, -1.502642e-06, -2.265438e-08,
               1.136598e-06,  1.083374e-06, -1.988207e-07)
  
   expect_doppelganger("Levene test check deprived data failure", vascr_plot_levene(d1, "R", 4000, 100))
})


test_that("Check vertical line plot works", {
  
  expect_doppelganger("vline check", vascr_plot_time_vline(growth.df, "R", 4000, 100))
  
})

test_that("Check replicate variation plot works", {
  
  expect_doppelganger("Replicate variation", vascr_plot_box_replicate(growth.df, "R", 4000, 100))
  
})


test_that("anova grid plot works", {
  
  expect_doppelganger("Box plot grid", vascr_plot_anova_grid(growth.df, "R", 4000, 100))
  
})


test_that("Anova bar reference", {
  
  expect_doppelganger("anova bar reference", vascr_plot_anova_bar_reference(growth.df, "R", 4000, 50))
  expect_doppelganger("anova bar reference non broken", vascr_plot_anova_bar_reference(growth.df, "R", 4000, 50, breaklines = FALSE))
  expect_error(vascr_plot_anova_bar_reference(growth.df, "R", 4000, 50, reference = 100))
  
})

test_that("Vascr plot qq", {
  
  expect_doppelganger("ggqqplot",vascr_plot_qq(data = growth.df, unit = "R", 
                                                      time = 100, frequency = 4000))
  
})

test_that("Plot bar anova", {
  
  expect_doppelganger("plot bar anova",vascr_plot_bar_anova(data = growth.df, confidence = 0.95, unit = "R", 
                      time = 100, frequency = 4000, rotate_x_angle = 45))
  expect_warning(vascr_plot_bar_anova(data = growth.df %>% vascr_subset(time = c(5, 150)) %>% vascr_normalise(50), confidence = 0.95, unit = "R", 
                                      time = 100, frequency = 4000, rotate_x_angle = 45))
  
})

test_that("Overall plot works", {

  expect_doppelganger("vascr_plot_anova overall plot", 
                      vascr_plot_anova(data.df = growth.df, unit = "R", frequency = 4000, time = 100))

})

