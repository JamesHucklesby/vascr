#' 
#' library(RODBC)
#' library(svSocket)
# 

#' Lengthen out an excelligence platemap
#' 
#' Switches the xcelligence format of having each column as a column and each row as a row, then stacking timepoints to a standardised tidy data format
#'
#' @param data The raw xcelligence dataset to deal with
#' 
#' @importFrom tidyr pivot_longer
#' @importFrom stringr str_remove
#' 
#' @keywords internal
#'
#' @return A slighlty tidier dataset
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


#' Internal Function to import MDB files from access
#'
#' xCELLigence files are stored in a proprietary Microsoft database format. This funciton launches a local copy of 32 bit R, then connects to Access and pulls the table through. This is in a separate function to the main file, as multiple sessions are needed to pull out various tables and this is the cleanest way to achieve that.
#'
#' This funciton will only run if Microsoft Access is installed on the PC
#'
#' @param file Path to the file to import
#' @param table Name of the acess table to be imported
#'
#' @importFrom svSocket startSocketServer stopSocketServer evalServer
#' @importFrom RODBC odbcDriverConnect odbcCloseAll
#' 
#' @keywords internal
#'
#' @return A table, as outlined in the Access database
#'
#' @examples
#' # This file is used in import_cellzScope exclisivley so can be tested with it
#' 
import_mdb = function(file, table, password)

{
  
  vascr_validate_file(file, "mdb")

  # Set enviromental variables for the import
  sock_port <- 8642L
  sock_con <- "sv_con"
  ODBC_con <- "a32_con"
  db_path <- file
  db_table <- table
  table_out <- "import_mdb_return_TEMP_object_from_32_bit_R"

  
   # If the database is found, create strings needed to connect to it as an object
  if (file.exists(db_path)) {

    # build ODBC string
    ODBC_str <- local({
      s <- list()
      s$path <- paste0("DBQ=", gsub("(/|\\\\)+", "/", path.expand(db_path)))
      s$driver <- "Driver={Microsoft Access Driver (*.mdb, *.accdb)}"
      s$threads <- "Threads=4"
      s$buffer <- "MaxBufferSize=4096"
      s$timeout <- "PageTimeout=5"
      s$pwd <- paste("PWD=", password, sep = "")
      paste(s, collapse=";")
    })

    # start socket server to transfer data to 32 bit session
    # The 32 bit session is needed as this is an old type of data file, and we want to be able to keep running 64 bit R for data manipulation in the rest of the package
    
    startSocketServer(port=sock_port, server.name="access_query_32", local=TRUE)

    # build expression to pass to 32 bit R session
    expr <- "library(svSocket)"
    expr <- c(expr, "library(RODBC)")
    expr <- c(expr, sprintf("%s <- odbcDriverConnect('%s')", ODBC_con, ODBC_str))
    expr <- c(expr, sprintf("if('%1$s' %%in%% sqlTables(%2$s)$TABLE_NAME) {%1$s <- sqlFetch(%2$s, '%1$s')} else {%1$s <- 'table %1$s not found'}", db_table, ODBC_con))
    expr <- c(expr, sprintf("%s <- socketConnection(port=%i)", sock_con, sock_port))
    expr <- c(expr, sprintf("evalServer(%s, %s, %s)", sock_con, table_out, db_table))
    expr <- c(expr, "odbcCloseAll()")
    expr <- c(expr, sprintf("close(%s)", sock_con))
    expr <- paste(expr, collapse=";")

    # launch 32 bit R session and run expressions
    prog <- file.path(R.home(), "bin", "i386", "Rscript.exe")
    system2(prog, args=c("-e", shQuote(expr)), stdout=NULL, wait=TRUE, invisible=TRUE)

    # stop socket server
    stopSocketServer(port=sock_port)

  } else { # Print a warning if file not found
    warning("database not found: ", db_path)
  }

  localreturn = import_mdb_return_TEMP_object_from_32_bit_R
  rm(import_mdb_return_TEMP_object_from_32_bit_R, pos = ".GlobalEnv")
  return(localreturn)
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
#'
#' @return A vascr datafile
#' 
#' @keywords internal
#' 
#' @export
#'
#' @examples
#' # xCELLigence test
#' rawdata = system.file('extdata/instruments/xcell.plt', package = 'vascr')
#' sampledefine = system.file('extdata/instruments/xcellkey.csv', package = 'vascr')
#' 
#' # data7 = import_xcelligence(file = rawdata, key = sampledefine, "TEST7")
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
  tempfile = paste(folder,"/","TEMPMDBFORIMPORT.mdb", sep = "")
  if(!file.copy(from = file, to = tempfile))
  {
    errorCondition("ERROR - file could not be duplicated to be opened. Ensure you have write capabilities in the new folder, and the file TEMPMDBFORIMPORT.mdb does not exist. Also check that the plt file is not open when you run this command")
  }
  file = tempfile

# Hard code in the list of tables we need to import from access. This will be pruned later to speed things up
# tables = c("Calibration","ENotes", "ErrLog", "ETimes", "Index1", "Index2", "Index3", "Layout", "Messages", "mIndex1", "Org10K", "Org25K", "Org50K", "ScanPlate", "ScanPlateData", "StepStatus", "TTimes", "WellColor")
  
 tables = c("Layout","Org10K", "Org25K", "Org50K", "TTimes")

# Import all the tables in the list, saving them back to global variables by the same name.
for(table in tables)
{
  assign(table, import_mdb(file, table, password))
}

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

# # Normalise the data to the minimum timepoint in the dataset (should be 0). This satisfies the top of the CI equation
# xcellCI = vascr_normalise(finaldata, min(finaldata$Time), divide = FALSE)
# 
# # Generate a divisor column, switch in the correct numbers, divide by each other and clean up
# xcellCI$divisor = xcellCI$Frequency
# xcellCI$divisor = as.character(xcellCI$divisor)
# xcellCI$divisor = str_replace(xcellCI$divisor, "10000", "15")
# xcellCI$divisor = str_replace(xcellCI$divisor, "25000", "12")
# xcellCI$divisor = str_replace(xcellCI$divisor, "50000", "10")
# xcellCI$divisor = as.numeric(xcellCI$divisor)
# xcellCI$Value = xcellCI$Value/xcellCI$divisor
# xcellCI$divisor = NULL
# 
# # Fix up the unit, as they are now all CI
# xcellCI$Unit = "CI"
# 
# returndata = vascr_combine(xcellCI, finaldata)

# Make CI
#returndata = xcelligence_import_generate_CI(finaldata)

return(finaldata)
}


#' Generate CI from xcelligence data
#'
#' @param data.df The dataset to generate CI from
#'
#' @return An enlargened dataset
#' 
#' @keywords internal
#'
#' @examples
xcelligence_import_generate_CI = function(data.df)
{
  cidata = vascr_normalise(data.df, normtime = 0)
  cidata$Unit = "CI"
  
  returndata = vascr_combine(cidata, data.df)
  return(returndata)
}


# #//////////////////////////////// Subtract background (needs validation)
# 
# file = "inst/extdata/xcell.mdb"
# xcell = import_xcelligence(file)
# 
# filename = "inst/extdata/xcell.txt"
# dataset = xcelligence_import_exported(filename)
# 
# xcell = vascr_explode(xcell)
# xcell$Instrument = "XCELL"
# 
# 
# # Data to subtract calibration data. Needs more work to check this is correct
# background = xcelligence_lengthen_platemap(Calibration)
# background = background %>% rename("Background" = "Value")
# 
# # Then we GUESS what CI should look like. Will compare this to the old CellZScope data yet to do a guess and check
# # Change to strings, then replace, then convert back. Looks inefficent, but it's very explicit and better reflects the categorical nature of replacing arbitary numbers with meaningfull category names.
# background = background %>% rename("Frequency" = "TimePoint")
# background$Frequency = as.character(background$Frequency)
# 
# background$Frequency = str_replace(background$Frequency , "-1", "10000")
# background$Frequency = str_replace(background$Frequency , "-2", "25000")
# background$Frequency = str_replace(background$Frequency , "-3", "50000")
# 
# background$Frequency = as.integer(background$Frequency)
# 
# xcellwithnormal = left_join(xcell, background)
# 
# xcellminusbackground = xcellwithnormal
# xcellminusbackground$Value = xcellminusbackground$Value - xcellminusbackground$Background
# xcellminusbackground$Background = NULL
# 
# xcellCI$Instrument.x = NULL
# xcellCI$Instrument.y = NULL
# 
# old_xcell_compare = (vascr_subset(old_xcell, time = 10, well = "A1"))
# new_xcell_compare = (vascr_subset(xcellCI, time = 10, well = "A1"))
# 
# old_xcell$Frequency = "9000"
# old_xcell$Instrument = NULL
# old_xcell$Time = as.numeric(old_xcell$Time)
# 
# master_xcell = vascr_combine(xcellCI, old_xcell)
# master_xcell$Instrument = "THING"
# master_xcelle = vascr_explode(master_xcell)
# 
# master_xcellf = vascr_subset_continuous(master_xcelle, "Nerifollin")
# master_xcellf = vascr_implode(master_xcellf, stripidentical = TRUE)
# master_xcellg = vascr_subset(old_xcell, samplecontains = "Nerifollin")
# master_xcellf$Instrument = "THING"
# master_xcellg$Instrument = "THING"
# 
# master_xcellh = vascr_combine(master_xcellg, master_xcellf)
# 
# 
# master_xcellf$Unit = "CIT"
# 
# 
# master_xcelli = vascr_subset(master_xcellh, time = c(150,200))
# 
# toplot2.df = summarise(group_by(master_xcelli, Sample, Time, Frequency), sd = sd(Value),
#                        n = n(), Value = mean(Value))
# 
# ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample, linetype = Frequency))+ ggplot2::geom_line(size = 1)


# TODO
# Test joining of a custom file
# Test different xcelligence files from AA

