# Import Raw ECIS data ---------------------------------------------------------


ecis_calculate_quantaties = function(data.df)
{
  # Wrangle data so it is in columns
  child1.df = data.df
  child1.df$Value = abs(child1.df$Value)
  widedata.df = tidyr::spread(child1.df, Unit, Value)
  widedata.df$Frequency = as.numeric(widedata.df$Frequency)
  
  # Calculate the new derrivative values
  widedata.df$Z = sqrt(widedata.df$X^2 + widedata.df$R^2)
  widedata.df$C = 1/(2 * pi * widedata.df$Frequency * widedata.df$X) * 10^9
  widedata.df$P = 90 - (atan(widedata.df$X/widedata.df$R)/(2 * pi) * 360)
  
  # Change format back
  longdata.df = tidyr::gather(widedata.df, Unit, Value, -Well, -Time, -Frequency)
  
  # Fix data types
  longdata.df$Unit = factor(longdata.df$Unit)
  longdata.df$Well = as.character(longdata.df$Well)
  longdata.df$Time = as.numeric(longdata.df$Time)
  
  return(longdata.df)
}



#' Internal function to assign sample names to a data frame
#'
#' @param data an ECIS data frame
#' @param sampledefine  path to the file containing the sample definitions
#'
#' @return A standard ECIS data frame, annotated
#' @export
#'
#' @examples
#' # This function is baked into ecis_import and it's parts
#' 
ecis_assign_samples = function (data, sampledefine)
{
  if(is.null(sampledefine)) # If samples are not defined, bypass this and just spit out well id's as names
  {
    data$Well = ecis_standardise_wells(data$Well)
    data$Sample = paste(data$Well, "Well", sep = "_")
    warning("The argument 'sampledefine' is not set. Defaulting to using well ID's as sample names")
    return(data)
  }
  
  # Read in the data table created by the user
  names.df = read.csv(sampledefine, as.is = TRUE)
  
  # Standardise all wells
  names.df$Well = ecis_standardise_wells(names.df$Well)
  data$Well = ecis_standardise_wells(data$Well)
  
  
  
  #Sanity check that the user has fed the right file
  if(colnames(names.df)[1] != "Well")
  {
    warning("The first column is not entitled 'Well'. Please check this and try to import again")
  }
  
  
  # Copy down the col name into each cell, separated by _
  for (col in colnames(names.df)[2:length(colnames(names.df))])
  {
    names.df[[col]] = paste(names.df[[col]],col, sep ="_")
  }
  
  # Unite the columns with full names
  names.df = names.df %>% unite(col = Sample,colnames(names.df)[2:length(colnames(names.df))], sep = " + ")
  combined.df = left_join(data, names.df, by = "Well")
  
  
  # Return dataset
  return(combined.df)
}



#' ECIS raw data importer
#' 
#' Raw data importer, generates a r dataframe from a raw ABP file
#'
#' @param rawdata A resampled ABP file containing the un-modeled data
#' @param sampledefine A CSV file containing well numbers and their corresponding sample names
#'
#' @return Data frame containing all the raw data readings from the ECIS Z0 instrument
#' 
#' @importFrom utils read.delim
#' @importFrom tidyr separate spread gather
#' @importFrom stringr str_detect str_replace
#' @importFrom dplyr left_join
#' 
#' 
#' 
#' @export
#'
#' @examples
#' 
#' #First determine the locatins of your files relative to your dataset. 
#' #Here we use system.file to pull a default out of the filesystem, 
#' #but you can use a path relative to the file you are working on. 
#' #E.G 'Experiment1/Raw.abp'
#' 
#' rawdata = system.file('extdata/growth1_raw_TimeResample.abp', package = 'ecisr')
#' sampledefine = system.file('extdata/growth1_samples.csv', package = 'ecisr')
#' 
#' #Then run the import
#' 
#' data1 = ecis_import_raw(rawdata, sampledefine)
#' data1$Experiment = "Growth_1"
#' head(data1)
#' ecis_plot(data1, unit = "X")
#' 
ecis_import_raw = function(rawdata, sampledefine) {
    
    # Grab all the rows of the file and dump them into a data frame
  
    file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
    colnames(file.df) = "Data"
    
    # Generate a data frame containing the titles
    titles.df = subset(file.df, str_detect(file.df$Data, "Index, Time,"))
    titlestring = titles.df[1, 1]
    titles = unlist(strsplit(titlestring, split = ","))
    titles = trimws(titles)
  
    
    # Import the meaty part of the data and clean up the dat types
    fulldata.df = subset(file.df, str_detect(file.df$Data, "^T[0-9]"))
    
    fulldata.df = fulldata.df %>% tidyr::separate("Data", titles, ",|=")
    
    # Clean out the row data from each well's ID
    fulldata.df = fulldata.df %>% tidyr::separate("Index", c("TimeID", "ID"), "W")
    fulldata.df$TimeID = NULL
    
    # Find the cell correlates
    format = subset(file.df, str_detect(file.df$Data, "WellNum"))
    
    if (format[1, 1] == "WellNum = 16") {
        id_to_well.df = structure(list(ID = 1:16, Well = structure(1:16, .Label = c("A1", 
            "A2", "A3", "A4", "A5", "A6", "A7", "A8", "B1", "B2", "B3", "B4", "B5", "B6", 
            "B7", "B8"), class = "factor")), class = "data.frame", row.names = c(NA, -16L))
    }
    
    if (format[1, 1] == "WellNum = 96") {
        id_to_well.df = structure(list(ID = 1:96, Well = structure(c(1L, 13L, 25L, 37L, 49L, 
            61L, 73L, 85L, 5L, 17L, 29L, 41L, 53L, 65L, 77L, 89L, 6L, 18L, 30L, 42L, 54L, 
            66L, 78L, 90L, 7L, 19L, 31L, 43L, 55L, 67L, 79L, 91L, 8L, 20L, 32L, 44L, 56L, 
            68L, 80L, 92L, 9L, 21L, 33L, 45L, 57L, 69L, 81L, 93L, 10L, 22L, 34L, 46L, 58L, 
            70L, 82L, 94L, 11L, 23L, 35L, 47L, 59L, 71L, 83L, 95L, 12L, 24L, 36L, 48L, 60L, 
            72L, 84L, 96L, 2L, 14L, 26L, 38L, 50L, 62L, 74L, 86L, 3L, 15L, 27L, 39L, 51L, 
            63L, 75L, 87L, 4L, 16L, 28L, 40L, 52L, 64L, 76L, 88L), .Label = c("A1", "A10", 
            "A11", "A12", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "B1", "B10", "B11", 
            "B12", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "C1", "C10", "C11", "C12", 
            "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "D1", "D10", "D11", "D12", "D2", 
            "D3", "D4", "D5", "D6", "D7", "D8", "D9", "E1", "E10", "E11", "E12", "E2", "E3", 
            "E4", "E5", "E6", "E7", "E8", "E9", "F1", "F10", "F11", "F12", "F2", "F3", "F4", 
            "F5", "F6", "F7", "F8", "F9", "G1", "G10", "G11", "G12", "G2", "G3", "G4", "G5", 
            "G6", "G7", "G8", "G9", "H1", "H10", "H11", "H12", "H2", "H3", "H4", "H5", "H6", 
            "H7", "H8", "H9"), class = "factor")), class = "data.frame", row.names = c(NA, 
            -96L))
    }
    
    fulldata.df$ID = as.integer(fulldata.df$ID)
    
    
    # Correlate the generated cell lookup table to ECIS's internal well id's
    fulldata.df = left_join(fulldata.df, id_to_well.df, by = "ID")
    
    # Make the wide dataset long
    fulldata_long.df = fulldata.df %>% tidyr::gather("Type", Value, -Well, -Time, -"ID")
    fulldata_long.df$Value = as.numeric(fulldata_long.df$Value)
    
    # Split out frequency and R/C as needed
    fulldata_long.df = fulldata_long.df %>% tidyr::separate("Type", c("Unit", "Frequency"), 
        " ")
    
    fulldata_long.df$ID = NULL
    
    # Generate the other physical quantaties
    
    longdata.df = ecis_calculate_quantaties(fulldata_long.df)
    
    # Add constants, standardise well format and assign samples
    longdata.df$Experiment = rawdata
    longdata.df$Instrument = "ECIS"
    longdata.df$Well = ecis_standardise_wells(longdata.df$Well)
    combined.df = ecis_assign_samples(longdata.df, sampledefine)
    
    
    # Explicitly return
    return(combined.df)
}


# Import modeled data -----------------------------------------------------


#' Import raw modeled data
#'
#' @param modeleddata Raw modeled data in APB format
#' @param sampledefine CSV file containing which wells correspond to which values
#'
#' @return Data frame containing modeled data
#' @export
#' 
#' @importFrom stringr str_detect
#' @importFrom tidyr separate gather
#' @importFrom magrittr '%>%'
#' @importFrom utils read.csv
#' 
#'
#' @examples
#' 
#'  #First determine the locatins of your files relative to your dataset.
#'  #Here we use system.file to pull a default out of the filesystem, but you 
#'  #can use a path relative to the file you are working on. 
#'  #E.G 'Experiment1/Raw.abp'
#' 
#' modeleddata = system.file('extdata/growth1_raw_TimeResample_RbA.csv', package = 'ecisr')
#' sampledefine = system.file('extdata/growth1_samples.csv', package = 'ecisr')
#' 
#' #Then run the import
#' 
#' data = ecis_import_model(modeleddata, sampledefine)
#' head(data)
#' ecis_plot(data, unit = "Rb", replication = "wells")
#' 
ecis_import_model = function(modeleddata, sampledefine) {
    
    rawdata = modeleddata
  
    file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
    colnames(file.df) = "Data"
    
    # Import the dataset in segments so that you can get rid of the ECIS crap
    cells.df = subset(file.df, str_detect(file.df$Data, "Well ID"))
    unit.df = subset(file.df, str_detect(file.df$Data, "Time "))
    data.df = subset(file.df, str_detect(file.df$Data, "^[0-9]"))
    
    cells = cells.df[1, 1]
    cells = unlist(strsplit(cells, split = ","))
    cells = base::trimws(cells)
    cells.df = cells
    
    unit = unit.df[1, 1]
    unit = unlist(strsplit(unit, split = ","))
    unit = base::trimws(unit)
    unit.df = unit
    
    # Rename the units something sensible
    unit.df = replace(unit.df, unit.df == "Rb (ohm.cm^2)", "Rb")
    unit.df = replace(unit.df, unit.df == "Alpha (cm.ohm^0.5)", "Alpha")
    unit.df = replace(unit.df, unit.df == "CellMCap(uF/cm^2)", "Cm")
    unit.df = replace(unit.df, unit.df == "Drift (%)", "Drift")
    unit.df = replace(unit.df, unit.df == "RMSE", "RMSE")
    
    # Generate unique names vector
    uniquenamesvector = paste(unit.df, cells.df, sep = "_")
    
    # Merge well ID and unit variables together
    
    data.df = data.df %>% tidyr::separate("Data", uniquenamesvector, ",", extra = "drop")
    alldata.df = rbind(cells.df, data.df)
    
    # Save the timestamps and rename the first one something sensible
    timestamps.df = alldata.df$`Time (hrs)_Well ID`
    timestamps.df[1] = "Time"
    
    # Split the dataframes
    alldataframes <- split.default(alldata.df, sub(x = as.character(names(alldata.df)), pattern = "\\_.*", 
        ""))
    
    Alpha.df = alldataframes$Alpha
    Cm.df = alldataframes$Cm
    Drift.df = alldataframes$Drift
    Rb.df = alldataframes$Rb
    RMSE.df = alldataframes$RMSE
    
    # Reattach the time stamps to each dataframe
    Alpha.df$timestamps = timestamps.df
    Cm.df$timestamps = timestamps.df
    Drift.df$timestamps = timestamps.df
    Rb.df$timestamps = timestamps.df
    RMSE.df$timestamps = timestamps.df
    
    rm(timestamps.df)
    
    
    # Re-adjust the headers
    Alpha.df = retitle(Alpha.df)
    Cm.df = retitle(Cm.df)
    Drift.df = retitle(Drift.df)
    Rb.df = retitle(Rb.df)
    RMSE.df = retitle(RMSE.df)
    
    # Set the title of each unit to that of it's dataframe
    Alpha.df$Unit = "Alpha"
    Cm.df$Unit = "Cm"
    Drift.df$Unit = "Drift"
    Rb.df$Unit = "Rb"
    RMSE.df$Unit = "RMSE"
    
    # Split each well into it's own line of a long format dataset
    
    Alpha.df = Alpha.df %>% tidyr::gather(Well, Value, -Time, -Unit)
    Cm.df = Cm.df %>% tidyr::gather(Well, Value, -Time, -Unit)
    Drift.df = Drift.df %>% tidyr::gather(Well, Value, -Time, -Unit)
    Rb.df = Rb.df %>% tidyr::gather(Well, Value, -Time, -Unit)
    RMSE.df = RMSE.df %>% tidyr::gather(Well, Value, -Time, -Unit)
    
    
    # Connect the datasets together end to end
    combined.df = rbind(Alpha.df, Cm.df, Drift.df, Rb.df, RMSE.df)
    
    rm(Alpha.df, Cm.df, Drift.df, Rb.df, RMSE.df, alldataframes, alldata.df)
    
    # Fix up the data types
    combined.df$Time = as.numeric(combined.df$Time)
    combined.df$Value = as.numeric(combined.df$Value)
    combined.df$Unit = factor(combined.df$Unit)
    combined.df$Well = factor(combined.df$Well)
    
    # import the naming tags
    combined2.df = ecis_assign_samples(combined.df, sampledefine)
    
    combined2.df$Frequency = 0

    # Add constants and fix data types
    combined2.df$Experiment = rawdata
    combined2.df$Instrument = "ECIS"
    combined2.df$Time = as.numeric(combined2.df$Time)
    
    return(combined2.df)
}




# Import all the data as a single function -----------------------------------


#' Import all ECIS values, a child of ecis_import_raw and ecis_import_model
#'
#' @param rawdata A raw ABP file to import
#' @param modeled  A modeled APB file for import
#' @param key A CSV file containing each well and it's corresponding sample
#'
#' @return A dataframe containing all the data APB generated from an experiment 
#' @export
#'
#' @examples
#' 
#' rawdata = system.file('extdata/growth1_raw_TimeResample.abp', package = 'ecisr')
#' modeled = system.file('extdata/growth1_raw_TimeResample_RbA.csv', package = 'ecisr')
#' key = system.file('extdata/growth1_samples.csv', package = 'ecisr')
#' 
#' #Then run the import
#' 
#' data = ecis_import(rawdata,modeled,key)
#' head(data)
#' ecis_plot(data, unit = "Rb")
#' ecis_plot(data, unit = "R")
ecis_import = function(rawdata, modeled, key) {
    
    raw.df = ecis_import_raw(rawdata, key)
    combined.df = ecis_import_model(modeled, key)
    masterdata.df = ecis_combine(combined.df, raw.df, resample = TRUE)
    
    return(masterdata.df)
}
