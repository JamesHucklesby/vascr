# norun = function()
# {
# 
# library(vascr)
# 
# 
# growth1.df = ecis_import("growth1_raw.abp", "growth1_modeled.csv", "growth1_samples.csv", 5, 0,200, experiment = "Experiment 1")
# vascr_plot(growth1.df, replication = "plate")
# 
# growth2.df = ecis_import("growth2_raw.abp", "growth2_modeled.csv", "growth2_samples.csv", 5, 0,200, experiment = "Experiment2")
# vascr_plot(growth1.df, replication = "plate")
# 
# growth3.df = ecis_import("growth3_raw.abp", "growth3_modeled.csv", "growth3_samples.csv", 5, 0,200, experiment = "Experiment3")
# vascr_plot(growth1.df, replication = "plate")
# 
# growth = vascr_combine(growth1.df, growth2.df, growth3.df)
# 
# vascr_plot(growth, replication = "wells")
# vascr_plot(growth, replication = "experiments")
# vascr_plot(growth, replication = "summary")
# 
# vascr_plot(growth, replication = "summary", error = 2)
# vascr_plot(growth, replication = "summary", error = 0)
# 
# vascr_plot(growth, time = c(0,50))
# 
# vascr_plot(growth, unit = "Rb")
# vascr_plot(growth, unit = "R", frequency = 4000)
# 
# vascr_plot_spectra(growth, "R")
# vascr_plot_model(growth)
# vascr_plot_model(growth, error = 1)
# 
# vascr_plot(growth, title = "Growth of HCMEC/D3 cells", xlab = "Time in hours", ylab = "Resistance in ohm")
# 
# vascr_plot(growth, time = 50, replication = "summary")
# vascr_plot(growth, time = 50, replication = "experiments")
# vascr_plot(growth, time = 50, replication = "wells")
# 
# vascr_plot(growth, time = 50, replication = "summary", confidence = .95, preprocessed = FALSE)
# vascr_ANOVA(growth, time = 50, unit = "R", frequency = 4000)
# 
# vascr_plot(growth, replication = "experiments")
# 
# vascr_plot(growth, replication = "plate")
# 
# vascr_plot(growth, time = 0, unit = "Rb", confidence = 0.95, alignkey = "max", replication = "experiments")
# }
# 
# 
