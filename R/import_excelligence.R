#' This is the old xcelligence import file. This is no longer needed as importing can be done straight from the datafile, rather than having to export first
#' 
#' 
#' #' Import excelligence data files
#' #'
#' #' @param file Path to the excelligence file to be imported
#' #' @param key Optional, standard keyfile that will overwrite what is stored in the excelligence file
#' #'
#' #' @return A standard impedr data frame
#' #' 
#' #' @importFrom stringr str_split str_replace
#' #' @importFrom dplyr select left_join
#' #' @importFrom stats na.omit
#' #' @importFrom tidyr separate fill pivot_longer
#' #'
#' #' @export
#' #'
#' #' @examples
#' #' filename = "inst/extdata/xcell.txt"
#' #' dataset = xcelligence_import(filename)
#' #' ecis_plot(dataset, unit = "CI", frequency = 0 , replication = "experiments", time = c(170,220) , samplecontains = "Nerifollin", normtime = 185, preprocessed = TRUE)
#' #' 
#' xcelligence_import = function(file, key)
#' {
#'   
#' # Import the raw excelligence file as a data frame
#' data = readLines(file, warn = FALSE)
#' data.df = as.data.frame(data)
#' 
#' 
#' ### Generate lookup table #################################
#' 
#' #Find the line locations of key parts of the layout section 
#' layouttitle = which(data.df$data == "Layout")+1
#' minlayout = which(data.df$data == "Layout")+2
#' maxlayout = which(data.df$data == "Schedule")-2
#' 
#' # Make a vector containing the layout titles
#' layouttitle = data.df[layouttitle, 1]
#' layouttitle = as.character(layouttitle)
#' layouttitles = strsplit(layouttitle, "\t")
#' layouttitles = layouttitles[[1]]
#' 
#' # Grab the content of the lookups table, and apply the correct titles
#' layout = as.data.frame(data.df[minlayout:maxlayout,1])
#' colnames(layout)[1] = "data"
#' lookups = separate(layout, "data", layouttitles, sep = "\t")
#' 
#' # Fix data types as appropriate
#' lookups$`Cell-Number` = as.numeric(lookups$`Cell-Number`)
#' lookups$Concentration = as.numeric(lookups$Concentration)
#' 
#' 
#' # Combine excelligence format into that used in this package, and clean up
#' lookups$treatment = paste(lookups$Concentration,"_", lookups$Unit, " ", lookups$`Compound Name` , sep = "")
#' lookups$cells = paste(lookups$`Cell-Number`,"_", lookups$`Cell-Type`, sep = "")
#' lookups$Sample = paste(lookups$treatment, lookups$cells, sep = "+")
#' lookups = select(lookups, Sample, `Well ID`)
#' 
#' 
#' 
#' ### Import datasets ########################################3
#' 
#' # Find locaitons of key lines needed to import data
#' mindata = which(data.df$data == "Cell Index")+1
#' maxdata = which(data.df$data == "Message")-2
#' 
#' 
#' # Generate a data frame containing the appropriate data
#' rawdata = as.data.frame(data.df[mindata:maxdata,1])
#' colnames(rawdata)[1] = "data"
#' 
#' # Separate out the cell index data
#' rawdata = separate(rawdata, data, into = c("data", "time"), sep = "Cell Index at: ", fill = "right")
#' rawdata = fill (rawdata, "time")
#' 
#' # Split out each column of the dataset and clean up the empty space
#' splitdata = separate(rawdata, data, into = as.character(c("row", 1:12)), sep = "\t", fill = "right")
#' splitdata = na.omit(splitdata)
#' splitdata = subset(splitdata, `12` != "12")
#' 
#' # Generate a long dataset for each row, and generate standard well names and clean up
#' longdata = pivot_longer(splitdata, as.character(c(1:12)), names_to = "col")
#' longdata$well = paste(longdata$row, longdata$col, sep = "")
#' longdata$row = NULL
#' longdata$col = NULL
#' 
#' # Fix the timestamps so they all are decimal rather than H:M:S format and clean up
#' longdata = separate(longdata, time, c("h", "m", "s"))
#' longdata$time = as.numeric(longdata$h) + as.numeric(longdata$m)/60 + as.numeric(longdata$s)/60/60
#' longdata$h = NULL
#' longdata$m = NULL
#' longdata$s = NULL
#' 
#' # Rename all the columns to package standards
#' names(longdata)[names(longdata) == "value"] <- "Value"
#' names(longdata)[names(longdata) == "well"] <- "Well"
#' names(longdata)[names(longdata) == "time"] <- "Time"
#' 
#' # Join in the lookup table
#' fulldata = left_join(longdata, lookups, by = c(Well = "Well ID"))
#' 
#' # Fix a few bits of metadata
#' fulldata$Sample = str_replace(fulldata$Sample, "_mM", "000_nM") # Align orders of magnitude for graphing
#' fulldata$Sample = str_replace(fulldata$Sample, "_ +", "") # Remove hanging spaces
#' fulldata$Unit = "CI" # Set all units equal to CI
#' fulldata$Instrument = "xCELLigence"
#' fulldata$Frequency = 0 # Set frequency to 0
#' fulldata$Experiment =  file # Set experiment name equal to filename
#' fulldata$Value = as.numeric(fulldata$Value) # make value names numeric
#' fulldata$Well = ecis_standardise_wells(fulldata$Well)
#' 
#' return(fulldata)
#' 
#' }
#' 
#' excelligence_import = function(file1, file2, key)
#' {
#'   warning("Incorrect spelling, please use xcelligence_import(file,key)")
#'   xcelligence_import(file, key)
#'   
#' }
