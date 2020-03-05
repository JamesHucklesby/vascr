# library("tidyverse")
# library("ecisr")
# 
# 
# # Grab the files from thier locations (to be incorporated into the function eventually)
# modeldata = "excluded/mdckmodel.txt"
# spectradata = "excluded/mdckspectra.txt"
# 
# output = cellzscope_import_raw(spectradata)
# 
# output = ecis_subset(output, time = c(0,50))
# 
# ecis_plot(output, unit = "I", frequency = 35938.14, preprocessed = TRUE, replication = "wells")
# 
# data = cellzscope_import_model(modeldata)
# 
# data = ecis_subset(data, time = c(0,50))
# 
# ecis_plot(data, unit = "Ccl", frequency = 0, preprocessed = TRUE, replication = "wells")



#' Import modeled cellZScope data
#' 
#' Imports modeled data previously exported from the cellZscope package. Will not assign names unless a keyfile or raw dataset is provided, as no well naming data is provided in this filetype.
#' 
#'
#' @param model The location of modeled data exported from the cellZscope data
#' @param key Optional, a keyfile containing data on which well contains which sample
#' 
#' @importFrom stringr str_remove str_split
#' @importFrom tidyr separate fill pivot_longer
#' @importFrom magrittr %>%
#' @importFrom textclean replace_non_ascii
#'
#' @return A vascar compatable dataset.
#' @export
#'
#' @examples
cellzscope_import_model  = function(model, key)
{
  
## TODO add the right match function from ECIS to apply names

# Read in the file to a data table
spectrafile = readLines(model)
data.df = as.data.frame(spectrafile)

# Clean out the strange encoding marks and units (not required, will be substituted in later)
data.df$spectrafile = replace_non_ascii(data.df$spectrafile, replacement = "")
data.df$spectrafile = str_remove(data.df$spectrafile, "saa>>AAA mu F/cmA")
data.df$spectrafile = str_remove(data.df$spectrafile, "I\\(C\\)AcmA")
data.df$spectrafile = str_remove(data.df$spectrafile, "I\\(C\\)")
data.df$spectrafile = str_remove(data.df$spectrafile, "A mu F/cm")
data.df$spectrafile = str_remove(data.df$spectrafile, "\\(\\)")
data.df$spectrafile = str_remove(data.df$spectrafile, "\\(A\\)")


# Make a dedicated column for the units (expressed as titles) and copy them down
separatedata = separate(data.df, "spectrafile", into = c("Data", "Unit"), remove = TRUE, sep = "Parameter : ")
separatedata = separatedata %>% fill(names(separatedata), .direction = "down")

# Generate the new column titles and use them to split the main dataset
newcols = subset(separatedata, grepl("time \\(h\\)", separatedata$Data))

newcols = strsplit(newcols[1,1], ",")
newcols = unlist(newcols)
newcols[1] = "Time"
separatedata = separate(separatedata, col = Data, into = newcols, sep = ",", fill = "right")

# Clean up the  wide dataset
separatedata = subset(separatedata, !is.na(separatedata[,2]))
separatedata = subset(separatedata, separatedata$Time !="time (h)")
separatedata = subset(separatedata, separatedata$Time !="")

# Pivot the table so each well expressed as a column becomes it's own row
separatedata = pivot_longer(separatedata, c(-Unit, -Time), names_to = "Well", values_to = "Value")

# Add variables fixed throughout the import
separatedata$Experiment = model
separatedata$Sample = "NA"
separatedata$Frequency = 0

# Fix data types
separatedata$Time = as.numeric(separatedata$Time)
separatedata$Value = as.numeric(separatedata$Value)
separatedata$Well = ecis_standardise_wells(separatedata$Well)

return(separatedata)
}



#' Import a raw cellZScope dataset
#'
#' Data must first be exported from the cellZscope software. 
#'
#' @param raw the locaiton of spectral data exported from the cellZscope software.
#'
#' @return A vascar compatable dataset
#' 
#' @importFrom stringr str_remove
#' @importFrom tidyr separate fill pivot_longer
#' @importFrom magrittr %>%
#' @importFrom textclean replace_non_ascii
#' 
#' 
#' @export
#'
#' @examples
#' 
#' 
#' 
cellzscope_import_raw = function(raw)
{

# Read into a data frame and remove garbage
spectrafile = readLines(raw)
data.df = as.data.frame(spectrafile)
data.df$spectrafile = replace_non_ascii(data.df$spectrafile, "")

#Separate out the data that needs to be carried down
separatedata = separate(data.df, "spectrafile", into = c("Data", "Well"), remove = TRUE, sep = "Well: ")
separatedata = separate(separatedata, "Data", into = c("Data", "Time"), remove = FALSE, sep = "Spectrum:")
separatedata = separate(separatedata, "Time", into = c("Run", "Date"), remove = FALSE, sep = "measured at ")
separatedata = separate(separatedata, "Data", into = c("Frequency", "I", "P"), sep = ",")
separatedata = separate(separatedata, "Well", into = c("Well", "Sample"), sep = "-")

#Copy down the data
separatedata = separatedata %>% fill(names(separatedata), .direction = "down")


#Cleanup the data
separatedata = subset(separatedata, separatedata$F !="frequency (Hz)")
separatedata = subset(separatedata, separatedata$F !="")

separatedata$Run = str_remove(separatedata$Run, " Run.")

# Convert the date stamps to times, running them through an external array
dat = as.POSIXct(separatedata$Date, format='%d/%m/%Y %I:%M:%S %p')
dat = as.numeric(dat)
dat = dat-min(dat)
dat = dat/60/60
separatedata$Time = dat

# Add experiment metadat
separatedata$Experiment = spectra

# Make longer
separatedata2 = pivot_longer(separatedata, cols = c("I", "P"), names_to = "Unit", values_to = "Value")

# Clean up data types
separatedata2$Value = as.numeric(separatedata2$Value)
separatedata2$Frequency = as.numeric(separatedata2$Frequency)
separatedata2$Well = ecis_standardise_wells(separatedata2$Well)

# Remove internal columns that are no longer required
separatedata2$Date = NULL
separatedata2$Run = NULL

return(separatedata2)

}


#' Import cellSZcope data
#' 
#' Data must first be exported in two parts from the cellZScope software. This can then be imported to a standard vascar dataset with this function
#'
#' @param raw File location of the raw dataset
#' @param model File locaiton of the modeled dataset
#' @param key Location of a vascar standard lookup table. Optional, but can be used to import more granular data than possible with the built in row names
#'
#' @return a standard vascar dataset
#' @export
#'
#' @examples
#' 
#' 
#' 
cellzscope_import = function(raw, model, key)
{
# To Do - import keyfile and match to data. Steal this from the ECIS functions
  
  
# Import both files
modeleddata = cellzscope_import_model(model)
rawdata = cellzscope_import_raw(raw)

# Check timebases are the same, if not warn
modeledtime = unique(modeleddata$Time)
rawtime = unique(rawdata$Time)

if(setequal(unique(modeleddata$Time), unique(rawdata$Time)))
{
  warning("Timebases are not identical. Subsetting or resampling may be required")
}


# Stick the files together
alldata = rbind(modeleddata, rawdata)

# Build a lookup table of sample names from the modeleddata imported (grab the lot and remove duplicates)
nametable = select(rawdata, "Well", "Sample")
nametable = unique(nametable)

# Remove and replace well names with those from the lookup table
alldata$Sample = NULL
alldatanamed = left_join(alldata, nametable, by = c("Well"))

return(alldatanamed)

}

#alldata = cellzscope_import(modeldata, spectradata)
#ecis_plot(alldata, unit = "TER", preprocessed = TRUE, frequency = 0, time = c(0,50), replication = "experiments")

