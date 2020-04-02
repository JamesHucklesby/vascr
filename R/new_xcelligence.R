# 
# library(RODBC)
# library(svSocket)
# 

#' Internal Function to import MDB files from access
#'
#' xCELLigence files are stored in a proprietary Microsoft database format. This funciton launches a local copy of 32 bit R, then connects to Access and pulls the table through. This is in a separate function to the main file, as multiple sessions are needed to pull out various tables and this is the cleanest way to achieve that.
#'
#' This funciton will only run if Microsoft Access is installed on the PC
#'
#' @param file Path to the file to import
#' @param table Name of the acess table to be imported
#'
#' @importFrom svSocket startSocketServer stopSocketServer
#'
#' @return A table, as outlined in the Access database
#'
#' @export
#'
#' @examples
#' 
#' file = "inst/extdata/xcell.mdb"
#' table = "Org10K"
import_mdb = function(file, table)

{

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
      s$pwd <- "PWD=RTCaDaTa"
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



# Import data in full -----------------------------------------------------


# Arguments to push through the function
# file = "inst/extdata/xcell.mdb"
# xcell = import_xcelligence(file)
# 
# subset = ecis_subset_continuous(xcell, c("ATP", "Adenosine"))
# subset = ecis_implode(subset)
# ecis_plot(subset, unit = "Z", frequency = "10000", replication = "experiments", normtime = 160)

import_xcelligence = function(file, key)
{

## Start function (once all plummed in)

# Hard code in the list of tables we need to import from access. This will be pruned later to speed things up
tables = c("Calibration","ENotes", "ErrLog", "ETimes", "Index1", "Index2", "Index3", "Layout", "Messages", "mIndex1", "Org10K", "Org25K", "Org50K", "ScanPlate", "ScanPlateData", "StepStatus", "TTimes", "WellColor")

# Import all the tables in the list, saving them back to global variables by the same name.
for(table in tables)
{
  assign(table, import_mdb(file, table))
}

# Where needed, set the appropriate frequencies into the org datafiles, then bind them together
Org10K$Frequency = 10000
Org25K$Frequency = 25000
Org50K$Frequency = 50000
MasterOrg = rbind(Org10K, Org25K, Org50K)

# Pivot the xcelligence columns into one row per data point, then remove the C's and attach them together to give well ID's
LongOrg = pivot_longer(MasterOrg, cols = starts_with("C"), names_to = "Cols", values_to = "Value")
LongOrg$Cols = str_remove(LongOrg$Cols, "C")
LongOrg$Well = paste(LongOrg$Row, LongOrg$Cols, sep = "")

# Clean up the mess created in making well ID's and standardise
LongOrg$Row = NULL
LongOrg$Cols = NULL
LongOrg$StepID = NULL
LongOrg$Well = ecis_standardise_wells(LongOrg$Well)


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
TimeOrg$Experiment = file # Assign file name as experiment name
TimeOrg$Instrument = "xCELLigence" # Assign instrument name

TimeOrg$Sample = "TEST" ########################################### Overwrite sample names. For testing only

# Code for assigning samples from file

if(missing(key))
{

      # Pivot table longer, and merge cols together to give well ID. Standardise
      lookuptable = pivot_longer(Layout, cols = starts_with("C"), names_to = "Cols", values_to = "Value")
      lookuptable$Cols = str_remove(lookuptable$Cols, "C")
      lookuptable$Well = paste(lookuptable$Row, lookuptable$Cols, sep = "")
      lookuptable$Well = ecis_standardise_wells(lookuptable$Well)
      # Clean up
      lookuptable$Cols = NULL
      lookuptable$Row = NULL
      
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
      ingested2$NS = NULL # Remove anything that claims that no Vehicle was added. Obveously.
      
      
      labeleddata = left_join(TimeOrg, ingested2, by = "Well")
      labeleddata$Sample = "NS"
      
      finaldata = ecis_implode(labeleddata)
      finaldata = ecis_explode(finaldata)
} else # Code for assigning samples from a standard file
{
      finaldata = ecis_assign_samples(TimeOrg,key)
}

return(finaldata)
}

# 
# 
# # Calculate CI
# tomatch = subset(TimeOrg, Time ==0)
# tomatch = select(tomatch, Frequency, Value, Well)
# 
# unifieddata = left_join(TimeOrg, tomatch, by = c("Frequency", "Well"))
# unifieddata$Value = (unifieddata$Value.x-unifieddata$Value.y)/15
# 
# ecis_plot(unifieddata, preprocessed = TRUE, unit = "Z", frequency = "10000")
# 
# dataset$Sample = "TEST"
# ecis_plot(dataset, preprocessed = TRUE, unit = "CI", frequency = "0")
# 
# 
# ecis_plot(TimeOrg, unit = "Z", frequency = "10000", replication = "experiments", preprocessed = TRUE, normtime = 0)
# ecis_plot(TimeOrg, unit = "Z", frequency = "25000", preprocessed = TRUE)
# ecis_plot(TimeOrg, unit = "Z", frequency = "50000", preprocessed = TRUE)
# 
# 
# 
# ecis_plot(dataset, unit ="CI", frequency = 0, replication = "experiments", preprocessed = TRUE)


# TODO
# Add in CI generation data
# Speed up ECIS_Explode
# Test joining of a custom file
# Test different xcelligence files from AA

