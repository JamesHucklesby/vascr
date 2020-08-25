#' Import modeled cellZScope data
#' 
#' Imports modeled data previously exported from the cellZscope package. Will not assign names unless a keyfile or raw dataset is provided, as no well naming data is provided in this filetype.
#' 
#'
#' @param model The location of modeled data exported from the cellZscope data
#' @param key Optional, a keyfile containing data on which well contains which sample
#' @param experimentname Name of the experiment to be built into the dataset
#' 
#' @importFrom stringr str_remove str_split
#' @importFrom tidyr separate fill pivot_longer
#' @importFrom magrittr %>%
#' @importFrom textclean replace_non_ascii
#'
#' @return An vascr compatable dataset
#' @export
#'
#' @examples
#' #model = system.file("extdata/mdckmodel.txt", package = "vascr")
#' #key = system.file("extdata/mdckkey.csv", package = "vascr")
#' 
#' #output = cellzscope_import_model(model, key)
#' #output = vascr_subset(output, time = c(0,50))
#' #vascr_plot(output, unit = "TER", frequency = 0,replication = "wells")
#' 
cellzscope_import_model  = function(model, key, experimentname)
{
  
# Check that the file is correct
  vascr_validate_file(model, "txt")
  
  if(!missing(key))
  {
  vascr_validate_file(key, "csv")
  }

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
if(!missing(experimentname))
{
  separatedata$Experiment = basename(model)
}
else
{
  separatedata$Experiment = experimentname
}



separatedata$Sample = "NA"
separatedata$Frequency = 0
separatedata$Instrument = "cellZscope"

# Fix data types
separatedata$Time = as.numeric(separatedata$Time)
separatedata$Value = as.numeric(separatedata$Value)
separatedata$Well = vascr_standardise_wells(separatedata$Well)

# Add keyfile
if(!missing(key))
{
  separatedata$Sample = NULL
  separatedata = vascr_assign_samples(separatedata, key)
}

return(separatedata)
}



#' Import a raw cellZScope dataset
#'
#' Data must first be exported from the cellZscope software. 
#'
#' @param raw the locaiton of spectral data exported from the cellZscope software.
#' @param key Optional, allows for sample names to be assigned to wells
#' @param experimentname Name of the experiment to be built into the dataset
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
#' #raw = system.file("extdata/mdckspectra.txt", package = "vascr")
#' #key = system.file("extdata/mdckkey.csv", package = "vascr")
#' 
#' #output = cellzscope_import_raw(raw, key)
#' #output = vascr_subset(output, time = c(0,50))
#' #vascr_plot(output, unit = "R", frequency = 4000, replication = "wells")
cellzscope_import_raw = function(raw, key, experimentname)
{
  
vascr_validate_file(raw, "txt")
  
  if(!(missing(key)))
  {
    vascr_validate_file(key, "csv")
  }

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
separatedata = subset(separatedata, separatedata$Date !="")
separatedata = subset(separatedata, separatedata$F !="")

separatedata$Run = str_remove(separatedata$Run, " Run.")

# Convert the date stamps to times, running them through an external array
dat = as.POSIXct(separatedata$Date, format='%d/%m/%Y %I:%M:%S %p')
dat = as.numeric(dat)
dat = dat-min(dat)
dat = dat/60/60
separatedata$Time = dat

# Add experiment metadat
if(!missing(experimentname))
{
  separatedata$Experiment = basename(raw)
}
else
{
  separatedata$Experiment = experimentname
}

separatedata$Instrument = "cellZscope"

# Make longer
separatedata2 = pivot_longer(separatedata, cols = c("I", "P"), names_to = "Unit", values_to = "Value")

# Clean up data types
separatedata2$Value = as.numeric(separatedata2$Value)
separatedata2$Frequency = as.numeric(separatedata2$Frequency)
separatedata2$Well = vascr_standardise_wells(separatedata2$Well)

# Remove internal columns that are no longer required
separatedata2$Date = NULL
separatedata2$Run = NULL

output2 = separatedata2
output2$Unit = str_replace(output2$Unit, "I", "Z")

# Wrangle data so it is in columns
child1.df = output2
child1.df$Value = abs(child1.df$Value)

widedata.df = pivot_wider(child1.df, names_from = "Unit", values_from = "Value")
widedata.df$Frequency = as.numeric(widedata.df$Frequency)

# Calculate new values
widedata.df$Pr = widedata.df$P / 360 * pi
widedata.df$X = sin(widedata.df$Pr) * widedata.df$Z
widedata.df$R = sin(widedata.df$Pr) * widedata.df$Z
widedata.df$C = 1/(2 * pi * widedata.df$Frequency * widedata.df$X) * 10^9

longdata.df = tidyr::gather(widedata.df, Unit, Value, -Well, -Time, -Frequency, -Sample, -Instrument, -Experiment)

# Fix data types
longdata.df$Unit = factor(longdata.df$Unit)
longdata.df$Well = as.character(longdata.df$Well)
longdata.df$Time = as.numeric(longdata.df$Time)

# Add keyfile
if(!missing(key))
{
longdata.df$Sample = NULL
longdata.df = vascr_assign_samples(longdata.df, key)
}

return(longdata.df)

}

#' Import cellSZcope data
#' 
#' Data must first be exported in two parts from the cellZScope software. This can then be imported to a standard vascar dataset with this function
#'
#' @param raw File location of the raw dataset
#' @param model File locaiton of the modeled dataset
#' @param key Location of a vascar standard lookup table. Optional, but can be used to import more granular data than possible with the built in row names
#' @param experimentname Name of the experiment to be built into the dataset
#' 
#' @importFrom dplyr select left_join 
#'
#' @return a standard vascar dataset
#' @export
#'
#' @examples
#' 
#' #model = system.file("extdata/mdckmodel.txt", package = "vascr")
#' #raw = system.file("extdata/mdckspectra.txt", package = "vascr")
#' #key = system.file("extdata/mdckkey.csv", package = "vascr")
#' 
#' #alldatakey = cellzscope_import(raw, model, key, "TEST")
#' #alldatakey$Instrument = "CZSII"
#' #vascr_plot(alldatakey, unit = "TER", frequency = 0, time = c(0,50))
#' 
cellzscope_import = function(raw, model, key = NULL, experimentname = "NA")
{
  
 vascr_validate_file(raw, "txt")
 vascr_validate_file(model, "txt")
 
 if(!missing(key))
 {
 vascr_validate_file(key, "csv")
 }
 
# Import both files. Don't specify a key as this will be applied globaly at the end
modeleddata = cellzscope_import_model(model, experimentname = experimentname)
rawdata = cellzscope_import_raw(raw, experimentname = experimentname)

# Combine and run checks
alldata = vascr_combine(modeleddata, rawdata)



if(missing(key)) # If the keyfile is not set
{
  # Build a lookup table of sample names from the modeleddata imported and apply them to the rawdata imported
  nametable = select(rawdata, "Well", "Sample")
  nametable = unique(nametable)
  alldata$Sample = NULL
  alldatanamed = left_join(alldata, nametable, by = c("Well"))
}

else
{
  # Use the standard allocation code for this package
  alldata$Sample = NULL
  alldatanamed = vascr_assign_samples(alldata, key)
}


return(alldatanamed)

}

