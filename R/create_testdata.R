# # Build example data
# 
# 
# 
# #//////////// ECIS ////////////////////
# 
# library("vascr")
# 
# raw1.df = ecis_import_raw(system.file("/extdata/growth1_raw_TimeResample.abp", package = "vascr"), system.file("/extdata/growth1_samples.csv", package = "vascr"))
# raw2.df = ecis_import_raw(system.file("/extdata/growth2_raw_TimeResample.abp", package = "vascr"), system.file("/extdata/growth2_samples.csv", package = "vascr"))
# raw3.df = ecis_import_raw(system.file("/extdata/growth3_raw_TimeResample.abp", package = "vascr"), system.file("/extdata/growth3_samples.csv", package = "vascr"))
# 
# ecis_raw = vascr_combine(raw1.df, raw2.df, raw3.df)
# 
# vascr_plot(rawcombined, unit = "R", replication = "summary")
# 
# model1.df = ecis_import_model(system.file("/extdata/growth1_raw_TimeResample_RbA.csv", package = "vascr"), system.file("/extdata/growth1_samples.csv", package = "vascr"))
# model2.df = ecis_import_model(system.file("/extdata/growth2_raw_TimeResample_RbA.csv", package = "vascr"), system.file("/extdata/growth2_samples.csv", package = "vascr"))
# model3.df = ecis_import_model(system.file("/extdata/growth3_raw_TimeResample_RbA.csv", package = "vascr"), system.file("/extdata/growth3_samples.csv", package = "vascr"))
# 
# ecis_model = vascr_combine(model1.df, model2.df, model3.df)
# ecis_combined = vascr_combine(rawcombined, modelcombined)
# 
# ############# CellZScope
# 
# cellzscope_raw = cellzscope_import_raw(system.file("/extdata/mdckspectra.txt", package = "vascr"))
# cellzscope_model = cellzscope_import_model(system.file("/extdata/mdckmodel.txt", package = "vascr"))
# 
# cellzscope_combined = vascr_combine(cellzscope_raw, cellzscope_model)
# cellzscope_combined= vascr_subset(cellzscope_combined, time = c(0,1000))
# 
# vascr_plot(cellzscope_combined, unit = "TER", frequency = 0, preprocessed = TRUE)
# 
# 
# 
# ############ excelligence
# 
# excelligence_combined = excelligence_import(system.file("/extdata/xcell.txt", package = "vascr"))
# 
# vascr_plot(excelligence_combined, unit = "CI", frequency = 0, samplecontains = "ATP")
# 
# 
# data.df = cellzscope_raw
# 
# units_used = unique(data.df$Unit)
# 
# eraw = c("C","P", "R", "X", "Z")
# emodel = c("Alpha", "Cm", "Drift", "Rb", "RMSE")
# eall = c(eraw, emodel)
# 
# excelligence = c("CI")
# 
# zraw = c("I", "P")
# zmodel = c("CPE_A", "CPE_n", "TER",   "Ccl",   "Rmed")
# 
# data = cellzscope_raw
# data = ecis_raw
# 
# 
# units = unique(units)
# frequencies = unique(data$Frequency)
# isint = all((frequencies == floor(frequencies)))
# 
# if(isint)
# {
#   
# }
# 
# 

# Save the file down to be opened with the package

#save(file = "growth.df.rda", list = "growth.df", compress = "xz")

# 
