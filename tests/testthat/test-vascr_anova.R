# round_prob = function(test)
# {
#   test$Tukey.level = signif(test$Tukey.level,3)
#   test$p.adj = signif(test$p.adj,3)
#   return(test)
# }


test_that("Can make a significance table", {
  
  expect_snapshot(vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95))
  expect_snapshot(vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data"))
  
})


test_that("Vascr LM", {
  expect_snapshot(vascr_lm(growth.df, "R", 4000, 100))
  
})

test_that("Vascr_residuals", {
  expect_snapshot(vascr_residuals(growth.df, "R", "4000", 100))
})

test_that("Vascr Shapiro test checks", {
  expect_snapshot(vascr_shapiro(growth.df, "R", 4000, 100))
})

test_that("Levene test", {
  expect_snapshot(vascr_levene(growth.df, "R", 4000, 100))
})

test_that("QQ plot", {
  vdiffr::expect_doppelganger("QQ plot", vascr_plot_qq(growth.df, "R", 4000, 100) + labs(title = "NONE"))
})

test_that("Normality plot", {
  vdiffr::expect_doppelganger("normality plot", vascr_plot_normality(growth.df, "R", 4000, 100))
})

test_that("Levene plot", {
  vdiffr::expect_doppelganger("Levene plot", vascr_plot_levene(growth.df, "R", 4000, 100))
})


test_that("Plot Time Vline", {
  vdiffr::expect_doppelganger("time vline", vascr_plot_time_vline(growth.df, "R", 4000, 100))
})


test_that("Box plot replicate", {
  vdiffr::expect_doppelganger("Box plot replicate", vascr_plot_box_replicate(growth.df, "R", 4000, 100))
})


test_that("Tukey tests", {
  expect_snapshot(vascr_tukey(growth.df, "R", 4000, 100))
  expect_snapshot(vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE))
})

test_that("Anova bar against reference", {
  vdiffr::expect_doppelganger("Anova reference", vascr_plot_anova_bar_reference(growth.df, "R", 4000, 50))
  vdiffr::expect_doppelganger("Anova reference 2", vascr_plot_anova_bar_reference(growth.df, "R", 4000, 50, breaklines = FALSE))
})

test_that("Plot bar anova", {
  vdiffr::expect_doppelganger("anova bar", vascr_plot_bar_anova(data = growth.df, confidence = 0.95, unit = "R", time = 100, frequency = 4000, rotate_x_angle = 45))
})

test_that("Plot overall ANOVA tabulation", {
  vdiffr::expect_doppelganger("Overall anova plot", vascr_plot_anova(data.df = growth.df, unit = "R", frequency = 4000, time = 100))
  
  
  nines = vascr_combine(growth.df %>% mutate(Experiment = paste(Experiment, "1")), growth.df %>% mutate(Experiment = paste(Experiment, "2")), growth.df %>% mutate(Experiment = paste(Experiment, "3")))
  vdiffr::expect_doppelganger("Overall anova plot, nine reps", vascr_plot_anova(data.df = nines, unit = "R", frequency = 4000, time = 100))
  
})


test_that("Can plot out the anova graphics", {
  vdiffr::expect_doppelganger("overall plot", vascr_plot_anova_grid(growth.df, "R", 4000, 100))
})