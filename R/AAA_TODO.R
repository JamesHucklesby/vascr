#' TODO
#'
#' Fix well isolation plot
#' Fix the continuous plot with multiple experiments and single well replication
#' Fix error = 5
#' Fix continuous strip_identical
#' Trace down why cells.x and cells.y is cropping up. Suspect it's in implode???
#' Fix ordering in ecis_anova
#' 
#' Include heatmap resolution into vascr_plot
#' 
#' Fix geom_path errors in plotting
#' 
#' vascar_mulitplot impliment multiple continuous samples
#'
#' Re-organise what's in what file
#'
#'update data conditioning in ecis_plot_continuous
#' 
#' Detection algorythm for wether a baked in or ecisr specific data table is used with potential code that allows for datasets to be revived as needed
#' 
#' Get R CMD Build working again (well)
#' 
#' Fix resampling code so it works better for all import types
#' 
#' Think about how ecis_subset_continous deals with veichles. Function written but need to finish implimenting this
#' 
#' ecis_implode but only non-0 things are written out + some kind of graphical representation of this
#' Do this by making lots of rows and then imploding them
#' 
#' Delete IsVehicleControl from graphics generation code
#' 
#' Line up data that I own and can include with the dataset
#' 
#' Move labeling of x and y, add addition of points to ecis_polish_plot
#' 
#' Deal with time specificaiton vs time selection
#' 
#' Optimise the speed of ecis_import_cellzscope, and/or remove it from CRAN checks
#' 
#' Future R versions
#' * Import CellZScope direct from file rather than through an intermediary
#' * Resurect ecis_animate
#' * Allow excell to be used for lookup files
#' * More advanced ANOVA
#' 
#' 
#' 