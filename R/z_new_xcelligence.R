#' Lengthen out an excelligence platemap
#' 
#' Switches the xcelligence format of having each column as a column and each row as a row, then stacking timepoints to a standardised tidy data format
#'
#' @param data The raw xcelligence data set to deal with
#' 
#' @importFrom tidyr pivot_longer
#' @importFrom stringr str_remove
#' 
#' @noRd
#'
#' @return A slightly tidier dataset
#' 
xcelligence_lengthen_platemap = function(data)
{
  # Pivot table longer, and merge cols together to give well ID. Standardise
  lookuptable = pivot_longer(data, cols = starts_with("C"), names_to = "Cols", values_to = "Value")
  lookuptable$Cols = str_remove(lookuptable$Cols, "C")
  lookuptable$Well = paste(lookuptable$Row, lookuptable$Cols, sep = "")
  lookuptable$Well = vascr_standardise_wells(lookuptable$Well)
  # Clean up
  lookuptable$Cols = NULL
  lookuptable$Row = NULL
  
  return(lookuptable)
}

#' Generate CI from xcelligence data
#'
#' @param data.df The dataset to generate CI from
#'
#' @return An enlargened dataset
#' 
#' @noRd
#'
#' @examples
xcelligence_import_generate_CI = function(data.df)
{
  cidata = vascr_normalise(data.df, normtime = 0)
  cidata$Unit = "CI"
  
  returndata = vascr_combine(cidata, data.df)
  return(returndata)
}


#' Import an xcelligence file
#'
#' @param file The file to import
#' @param key A keyfile to apply. Optional, as the xCELLigence internal definitions will be used if no file is specified
#' @param experimentname Name of the experiment to be built into the dataset
#' 
#' @importFrom tidyr separate pivot_wider
#' @importFrom dplyr left_join
#' @importFrom stringr str_replace
#' @importFrom DBI dbReadTable
#' @importFrom odbc dbConnect odbc dbDisconnect
#'
#' @return A vascr datafile
#' 
#' @noRd
#' 
#'
#' @examples
#' # xCELLigence test
#' rawdata = system.file('extdata/instruments/xcell.plt', package = 'vascr')
#' sampledefine = system.file('extdata/instruments/xcellkey.csv', package = 'vascr')
#' import_xcelligence(file = rawdata, key = sampledefine, "TEST7")
#' 
#'  
import_xcelligence = function(file, key, experimentname = "NA", password = "RTCaDaTa")
{
  vascr_validate_file(file, "plt")
  
  if(!missing(key))
  {
  vascr_validate_file(key, c("csv", "xlsx"))
  }
  
  
  # Make a temporary copy of the file, with the correct extension so Microsoft Access can open it
  folder = dirname(file)
  tempfile = paste(tempdir(),"/","TEMPMDBFORIMPORT.mdb", sep = "")
  if(!file.copy(from = file, to = tempfile))
  {
    errorCondition("ERROR - file could not be duplicated to be opened. Ensure you have write capabilities in the new folder, and the file TEMPMDBFORIMPORT.mdb does not exist. Also check that the plt file is not open when you run this command")
  }
  file = tempfile

# Hard code in the list of tables we need to import from access. This will be pruned later to speed things up
# tables = c("Calibration","ENotes", "ErrLog", "ETimes", "Index1", "Index2", "Index3", "Layout", "Messages", "mIndex1", "Org10K", "Org25K", "Org50K", "ScanPlate", "ScanPlateData", "StepStatus", "TTimes", "WellColor")


 connection <- dbConnect(odbc(), .connection_string = paste("Driver={Microsoft Access Driver (*.mdb, *.accdb)};
                            DBQ=",tempfile,";
                            PWD=RTCaDaTa", sep = ""))
 
 Org10K <- dbReadTable(connection , "Org10K")
 Org25K <- dbReadTable(connection , "Org25K")
 Org50K <- dbReadTable(connection , "Org50K")
 TTimes <- dbReadTable(connection , "TTimes")
 Layout <- dbReadTable(connection , "Layout")
 
 dbDisconnect(connection)
 

# Delete the temporary file now we have what we need in R
file.remove(tempfile)

# Where needed, set the appropriate frequencies into the org datafiles, then bind them together
Org10K$Frequency = 10000
Org25K$Frequency = 25000
Org50K$Frequency = 50000
MasterOrg = rbind(Org10K, Org25K, Org50K)

# Pivot the xcelligence columns into one row per data point, then remove the C's and attach them together to give well ID's
LongOrg = xcelligence_lengthen_platemap(MasterOrg)

# Clean up the mess created in making well ID's and standardise
LongOrg$StepID = NULL


# Add times (in hours) to each time point by looking them up in another sheet
TimeOrg = left_join(LongOrg, TTimes, by = "TimePoint") #Stick timepoints to the dataset
TimeOrg$TestTime = as.character(TimeOrg$TestTime) # Make them characers (so the next line works)
TimeOrg$TestTime = as.POSIXct(TimeOrg$TestTime) # Parse the dates
TimeOrg$TestTime = as.numeric(TimeOrg$TestTime) # Convert to numbers
TimeOrg$TestTime = TimeOrg$TestTime - min(TimeOrg$TestTime) # Subtract time 0
TimeOrg$TestTime = TimeOrg$TestTime/60/60 # Convert seconds to hours

TimeOrg$Time = TimeOrg$TestTime # Clean up
TimeOrg$TestTime = NULL
TimeOrg$TimePoint = NULL
TimeOrg$StepID = NULL

TimeOrg$Unit = "Z" # Assign impedance (Z) as the unit for all time points. This is all the CellZScope can capture.

# Assign experiment name
if(experimentname=="NA")
{
  TimeOrg$Experiment = basename(file)
}
else
{
  TimeOrg$Experiment = experimentname
}


TimeOrg$Instrument = "xCELLigence" # Assign instrument name

# Code for assigning samples from file

if(missing(key))
{

      lookuptable = xcelligence_lengthen_platemap(Layout)
      
      # Re-constitute the samples so they are in the correct format
      ingested = separate(lookuptable, Value, into =c("cell line", "cell number", "drug", "concentration", "unit", "other"), sep = "\n|\t")
      ingested$title = paste(ingested$unit, ingested$drug)
      ingested$unit = NULL
      ingested$drug = NULL
      ingested$other = NULL
      
      # Fill in blanks
      ingested[ingested==""]<-"Vehicle"  # No concentration wells are tagged as Vehicle. This over-compensates as some wells are tagged "Vehicle" where nothing at all is speecified. This is fixed after the pivot.
      ingested[ingested==" "]<-"NS" # Set unset drugs to NS
      
      # Widen the data, for both all drugs and all cell lines
      ingested2 = pivot_wider(ingested, names_from = "title", values_from = "concentration")
      ingested2 = pivot_wider(ingested2, names_from = "cell line", values_from = "cell number")
      ingested2$NS = NULL # Remove anything that claims that nothing was added
      
      
      labeleddata = left_join(TimeOrg, ingested2, by = "Well")
      labeleddata$Sample = "NS"
      
      finaldata = vascr_implode(labeleddata)
} else # Code for assigning samples from a standard file
{
      finaldata = vascr_assign_samples(TimeOrg,key)
}


return(finaldata)
}





