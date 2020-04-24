#' #' Title
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' demoplots = function()
#' {
#' 
#' #Initial installation (only needs to be run once, or when an update goes out)
#' install.packages("devtools")
#' devtools::install_github("JamesHucklesby/vascr")
#' 
#' # First we open up the ECISR library (or install it if needed)
#' library(vascr)
#' 
#' # Access help files
#' ?ecis_import
#' ?vascr_plot
#' ?vascr_ANOVA
#' ?vascr_export_prism
#' 
#' #Then we import each of the data frames, resampling them as we do so
#' 
#' modeled1 = system.file('extdata/growth1_raw_TimeResample_RbA.csv', package = 'vascr')
#' modeled2 = system.file('extdata/growth2_raw_TimeResample_RbA.csv', package = 'vascr')
#' modeled3 = system.file('extdata/growth3_raw_TimeResample_RbA.csv', package = 'vascr')
#' 
#' raw1 = system.file('extdata/growth1_raw_TimeResample.abp', package = 'vascr')
#' raw2 = system.file('extdata/growth2_raw_TimeResample.abp', package = 'vascr')
#' raw3 = system.file('extdata/growth3_raw_TimeResample.abp', package = 'vascr')
#' 
#' key1 = system.file('extdata/growth1_samples.csv', package = 'vascr')
#' key2 = system.file('extdata/growth2_samples.csv', package = 'vascr')
#' key3 = system.file('extdata/growth3_samples.csv', package = 'vascr')
#' 
#' growth1.df = ecis_import(raw1, modeled1, key1, "One")
#' growth2.df = ecis_import(raw2, modeled2, key2, "Two")
#' growth3.df = ecis_import(raw3, modeled3, key3, "Three")
#' 
#' # Then we resample these datasets 
#' growth1_resample.df = vascr_resample(growth1.df, 10, 0, 200)
#' growth2_resample.df = vascr_resample(growth2.df, 10, 0, 200)
#' growth3_resample.df = vascr_resample(growth3.df, 10, 0, 200)
#' 
#' # Then we check that the samples look ok
#' vascr_plot(growth1_resample.df, replication = "plate")
#' vascr_plot(growth2_resample.df, replication = "plate")
#' vascr_plot(growth3_resample.df, replication = "plate")
#' 
#' # We remove growth1 well D1 (and another test well to demonstrate we can) because it is defective. We also remove the 0 cells as it is not sensible to include
#' vascr_plot_isolate(growth1_resample.df, well = "D01")
#' 
#' growth1_resample.df=  vascr_exclude(growth1_resample.df, wells = c("D01", "I04"), sample = "0_cells + HCMEC D3_line")
#' 
#' vascr_plot(growth1_resample.df, replication = "plate")
#' 
#' #Then we combine the datsets
#' growth = vascr_combine(growth1_resample.df, growth2_resample.df, growth3_resample.df)
#' 
#' # Demonstrate the three resolutions we can use to display data
#' vascr_plot(growth, replication = "wells")
#' vascr_plot(growth, replication = "experiments")
#' vascr_plot(growth, replication = "summary")
#' 
#' # Demonstrate that error can be changed
#' vascr_plot(growth, error = 1)
#' vascr_plot(growth, error = 5)
#' vascr_plot(growth, error = 0)
#' vascr_plot(growth, error = Inf)
#' 
#' # Demonstrate some style changes
#' vascr_plot(growth, linesize = 5)
#' vascr_plot(growth, alphavalue = 0.8)
#' 
#' # Demonstrate that arguements are cumulative
#' vascr_plot(growth, replication = "wells", linesize = 3, error = 5, normtime = 100)
#' 
#' # Demonstrate that only some samples can be plotted, or that the default name-trimming behaviour can be turned off
#' vascr_plot(growth, samplecontains = "5,000")
#' vascr_plot(growth, stripidentical = FALSE)
#' 
#' # Show that we can zoom in on a time area if needed, and that this time can be a variable
#' timetoplot = c(0,100)
#' vascr_plot(growth, time = timetoplot)
#' vascr_plot(growth, time = timetoplot, replication = "wells")
#' 
#' #Show how to select different units and frequencies
#' vascr_plot(growth, unit = "Rb")
#' vascr_plot(growth, unit = "R", frequency = 4000)
#' 
#' # Data can be normalised by division or subtraction
#' vascr_plot(growth, normtime = 100) # Subtraction is the default
#' vascr_plot(growth, normtime = 100, divide = TRUE)
#' 
#' # Show some of the pre-prepared matrices for lots of data
#' vascr_plot_spectra(growth, "R")
#' vascr_plot_model(growth)
#' vascr_plot_model(growth, error = 1) # You can also pass vascr_plot arguements through if you want to affect how the plot looks
#' 
#' # Tiles can be customised, although they are automatically generated
#' vascr_plot(growth, title = "Growth of HCMEC/D3 cells", xlab = "Time in hours", ylab = "Resistance in ohm")
#' 
#' #Show that a single key time point can be plotted
#' vascr_plot(growth, time = 50, replication = "summary")
#' vascr_plot(growth, time = 50, replication = "experiments")
#' vascr_plot(growth, time = 50, replication = "wells")
#' 
#' #Add statistics to the plot
#' vascr_plot(growth, time = 50, replication = "summary", confidence = .05)
#' 
#' # Run ANOVA analyasis
#' vascr_ANOVA(growth, time = 50, unit = "R", frequency = 4000)
#' vascr_ANOVA(growth, time = 100, unit = "R", frequency = 4000)
#' 
#' }
