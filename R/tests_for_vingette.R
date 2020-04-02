# norun = function()
# {
# 
# library(ecisr)
# 
# 
# growth1.df = ecis_import("growth1_raw.abp", "growth1_modeled.csv", "growth1_samples.csv", 5, 0,200, experiment = "Experiment 1")
# ecis_plot(growth1.df, replication = "plate")
# 
# growth2.df = ecis_import("growth2_raw.abp", "growth2_modeled.csv", "growth2_samples.csv", 5, 0,200, experiment = "Experiment2")
# ecis_plot(growth1.df, replication = "plate")
# 
# growth3.df = ecis_import("growth3_raw.abp", "growth3_modeled.csv", "growth3_samples.csv", 5, 0,200, experiment = "Experiment3")
# ecis_plot(growth1.df, replication = "plate")
# 
# growth = ecis_combine(growth1.df, growth2.df, growth3.df)
# 
# ecis_plot(growth, replication = "wells")
# ecis_plot(growth, replication = "experiments")
# ecis_plot(growth, replication = "summary")
# 
# ecis_plot(growth, replication = "summary", error = 2)
# ecis_plot(growth, replication = "summary", error = 0)
# 
# ecis_plot(growth, time = c(0,50))
# 
# ecis_plot(growth, unit = "Rb")
# ecis_plot(growth, unit = "R", frequency = 4000)
# 
# ecis_plot_spectra(growth, "R")
# ecis_plot_model(growth)
# ecis_plot_model(growth, error = 1)
# 
# ecis_plot(growth, title = "Growth of HCMEC/D3 cells", xlab = "Time in hours", ylab = "Resistance in ohm")
# 
# ecis_plot(growth, time = 50, replication = "summary")
# ecis_plot(growth, time = 50, replication = "experiments")
# ecis_plot(growth, time = 50, replication = "wells")
# 
# ecis_plot(growth, time = 50, replication = "summary", confidence = .95, preprocessed = FALSE)
# ecis_ANOVA(growth, time = 50, unit = "R", frequency = 4000)
# 
# ecis_plot(growth, replication = "experiments")
# 
# ecis_plot(growth, replication = "plate")
# 
# ecis_plot(growth, time = 0, unit = "Rb", confidence = 0.95, alignkey = "max", replication = "experiments")
# }
# 
# 
