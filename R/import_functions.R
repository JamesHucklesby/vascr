# Import Raw Data ---------------------------------------------------------


#' Retitle
#' 
#' Recapitulation of the funciton in tidyR, allows the re-titling of a data frame from the top row of a dataset. Used in import funcitons to set titles from the content of ABP files. For internal use only.
#'
#' @param df A data frame containing the desired values in the top row
#'
#' @return A dataframe where the top row has been converted to titles.
# 
retitle = function(df) {
  
  names(df) = as.character(unlist(df[1, ]))
  df = df[-1, ]
  df
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
  if(is.null(sampledefine)) # If samples are not defined, bypass this and just spit out well numbers as names
  {
    data$Well = ecis_standardise_wells(data$Well)
    data$Sample = paste(data$Well, "Well", sep = "_")
    return(data)
  }
  
  # Read in the data table created by the user
  names.df = read.csv(sampledefine, as.is = TRUE)
  
  # Standardise all wells
  names.df$Well = ecis_standardise_wells(names.df$Well)
  data$Well = ecis_standardise_wells(data$Well)
  
  #Take a copy of the original exploded dataset for later
  names2.df = names.df
  
  
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
  #Stick this onto the exploded dataset
  names.df = left_join(names.df, names2.df, by = "Well")
  #Stick the whole thing onto the data
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
#' @importFrom stringr str_detect
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
#' rawdata = system.file('Resample.abp', package = 'ecisr')
#' sampledefine = system.file('Samples.csv', package = 'ecisr')
#' 
#' #Then run the import
#' 
#' data2 = ecis_import_raw(rawdata, sampledefine, .1, 1, 1.4)
#' head(data)
#' 
#' data2 = ecis_import_raw(rawdata, NULL, 1, 0, 70)
#' data3 = subset(data2, Value<20000)
#' ecis_plot(data3, replication = "plate")
#' 
ecis_import_raw = function(rawdata, sampledefine, by, from = Inf, to = Inf, zero_time = 0, verbose = TRUE, no_process = FALSE) {
    
    # Grab all the rows of the file and dump them into a data frame
    print("Importing raw data")  
  
    file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
    colnames(file.df) = "Data"
    
    # Generate a data frame containing the titles
    titles.df = subset(file.df, stringr::str_detect(file.df$Data, "Index, Time,"))
    titlestring = titles.df[1, 1]
    titles = unlist(strsplit(titlestring, split = ","))
    titles = base::trimws(titles)
  
    
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
    
    #Cut out un-needed data for performance reasons
    fulldata.df$Time = as.numeric(fulldata.df$Time)
    fulldata.df = subset(fulldata.df, Time>from)
    fulldata.df = subset(fulldata.df, Time<to)
    
    # Correlate the generated cell lookup table to ECIS's internal well id's
    fulldata.df = left_join(fulldata.df, id_to_well.df, by = "ID")
    
    # Make the wide dataset long
    fulldata_long.df = fulldata.df %>% tidyr::gather("Type", Value, -Well, -Time, -"ID")
    fulldata_long.df$Value = as.numeric(fulldata_long.df$Value)
    
    # Split out frequency and R/C as needed
    fulldata_long.df = fulldata_long.df %>% tidyr::separate("Type", c("Unit", "Frequency"), 
        " ")
    
    fulldata_long.df$ID = NULL
    
    ############################### Generate the other physical quantaties
    print("Generating physical quantaties from ABP data")
    
    # Wrangle data so it is in columns
    child1.df = fulldata_long.df
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
    
    ############################# End re-generation of phyisical measurements
    
    # Add the file name as the experiment ID
    longdata.df$Experiment = rawdata
    
    longdata.df$Well = ecis_standardise_wells(longdata.df$Well)
    combined.df = ecis_assign_samples(longdata.df, sampledefine)
    
    # Resample the data
    print("resampling raw data")
    combined.df = ecis_resample(combined.df, by = by, from = from, to = to, zero_time = zero_time)
    
    
    # Explicitly return
    return(combined.df)
}


# Import modeled data -----------------------------------------------------


#' Import raw modeled data
#'
#' @param modeled.csv Raw modeled data in APB format
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
#' modeled.csv = system.file('Model.csv', package = 'ecisr')
#' sampledefine = system.file('Samples.csv', package = 'ecisr')
#' 
#' #Then run the import
#' 
#' data = ecis_import_model(modeled.csv, sampledefine, 0.1, 0.1, 0.9)
#' head(data)
#' 
ecis_import_model = function(modeled.csv, sampledefine, by, from = Inf, to = Inf, zero_time = 0, verbose = TRUE) {
    
    print("Importing modelled data")
    rawdata = modeled.csv
  
    file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
    base::colnames(file.df) = "Data"
    
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
    
    # Remove unneeded data
    data.df$Time = as.numeric(data.df$Time)
    data2.df = subset(data.df, Time>from)
    data2.df = subset(data.df, Time<to)
    
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
    
    combined2.df$Experiment = rawdata
    combined2.df$Time = as.numeric(combined2.df$Time)
    
    print("Resampling modelled data")
    combined2.df = ecis_resample(combined2.df, by, from, to, zero_time)
    
    return(combined2.df)
}




# Import all the data as a single function -----------------------------------


#' Import all ECIS values, a child of ecis_import_raw and ecis_import_model
#'
#' @param resample A resampled APB file for import
#' @param modeled  A modeled APB file for import
#' @param key A CSV file containing each well and it's corresponding sample
#'
#' @return A dataframe containing all the data APB generated from an experiment 
#' @export
#'
#' @examples
#' 
#' location_of_resampled_data = system.file('Resample.abp', package = 'ecisr')
#' location_of_modeled_data = system.file('Model.csv', package = 'ecisr')
#' location_of_sample_defintions = system.file('Samples.csv', package = 'ecisr')
#' 
#' #Then run the import
#' 
#' data = ecis_import(location_of_resampled_data,location_of_modeled_data,location_of_sample_defintions, 5, 0, 200)
#' head(data)
#' 
ecis_import = function(resample, modeled, key, by, from = Inf, to = Inf, zero_time = 0, verbose = TRUE, experiment = NULL) {
    
    raw.df = ecis_import_raw(resample, key, by, from = from, to = to, zero_time = zero_time, verbose = verbose)
    combined.df = ecis_import_model(modeled, key, by, from = from, to = to, zero_time = zero_time, verbose = verbose)
    
    masterdata.df = rbind(combined.df, raw.df)
    
    if(!is.null(experiment))
    {
      masterdata.df$Experiment = experiment
    }
    
    return(masterdata.df)
    
}


#' Exclude erronious data from an ECIS dataframe
#'
#' @param data.df The source dataset
#' @param samples The sample(s) to exclude
#' @param wells The well(s) to exclude
#' @param experiments The experiment(s) to exclude
#' @param times The time(s) to exclude
#' @param values The value(s) to exclude
#' @param vs The isolated variables-unit pairs to exclude
#' @param vars The isolated variables to exclude
#' @param vals The isolated values to exclude
#'
#' @return The altered dataset
#' @export
#' 
#' @importFrom dplyr filter
#' @importFrom magrittr "%>%"
#'
#' @examples
#' 
#' unique(growth.df$Sample)
#' excludedgrowth.df = ecis_exclude(growth.df, samples = c("35,000 cells", "0 cells"))
#' unique(excludedgrowth.df$Sample)
#' 
#' unique(growth.df$Well)
#' excludedgrowth.df = ecis_exclude(growth.df, wells = c("A1", "B1", "C1"))
#' unique(excludedgrowth.df$Well)
#' 
#' unique(growth.df$Experiment)
#' excludedgrowth.df = ecis_exclude(growth.df, experiment = c(1,2))
#' unique(excludedgrowth.df$Experiment)
#' 


ecis_exclude = function(data.df, samples = FALSE, wells = FALSE, experiments = FALSE, times = FALSE, values = FALSE, vars = FALSE, vals = FALSE, vs = FALSE)
{
  
  for (sample in samples)
  {
    data.df = data.df %>% filter(Sample != sample)
  }
  
  for (well in wells)
  {
    data.df = data.df %>% filter(Well != well)
  }
  
  for (experiment in experiments)
  {
    data.df = data.df %>% filter(Experiment != experiment)
  }
  
  for (time in times)
  {
    data.df = data.df %>% filter(Time != time)
  }
  
  for (value in values)
  {
    data.df = data.df %>% filter(Value != value)
  }
  
  
  return (data.df)
}




# Worker functions for importing files ------------------------------------


#' Combine ECIS data frames end to end
#' 
#' This funciton will combine ECIS datasets end to end. Preferential to use over a simple rbind command as it runs additional checks to ensure that datapoints are correctly generated
#'
#' @param ... List of data frames to be combined
#'
#' @return A single data frame containing all the data imported, automaticaly incremented by experiment
#' 
#' @export
#'
#' @examples
#' 
#' #Make two fake experiments worth of data
#' 
#' experiment1.df = ecis_subset(growth.df, experiment = "1")
#' experiment2.df = ecis_subset(growth.df, experiment = "2")
#' experiment3.df = ecis_subset(growth.df, experiment = "3")
#' 
#' data = ecis_combine(experiment1.df, experiment2.df, experiment3.df)
#' head(data)
#' 
ecis_combine = function(...) {
    
    dataframes = list(...)
    
    # Test filler variables dataframes = list(child1.df, child2.df, child3.df) i = 1
    
    # Generate an empty data frame with the correct columns to fill later
    alldata = dataframes[[1]][0, ]
    loops = 1
    
    # Check that both dataframes have the same timebase
    for (i in dataframes)
    {
      if (!(exists("timepointstomerge")))
      {
        timepointstomerge = unique(i$Time)
      }
        
        if (!identical(timepointstomerge,unique(i$Time)))
      {
        warning("Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.")
      }
    }
    
    # Mash all the dataframes together
    
    for (i in dataframes) {
        indata = i
        indata$Experiment = paste(loops, ":", indata$Experiment)
        loops = loops + 1
        alldata = rbind(alldata, indata)
    }
    
    alldata$Experiment = as.factor(alldata$Experiment)
    
    
    return(alldata)
    
}


