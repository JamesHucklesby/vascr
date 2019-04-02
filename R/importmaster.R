# Import Raw Data ---------------------------------------------------------

#' ECIS raw data importer
#' 
#' Raw data importer, generates a r dataframe from a raw ABP file
#'
#' @param rawdata A resampled ABP file containing the un-modeled data
#' @param sampledefine A CSV file containing well numbers and their corresponding sample names
#'
#' @return Data frame containing all the raw data readings from the ECIS Z0 instrument
#' 
#' @export
#'
#' @examples
#' 
#' #First determine the locatins of your files relative to your dataset. 
#' #Here we use system.file to pull a default out of the filesystem, 
#' #but you can use a path relative to the file you are working on. 
#' #E.G "Experiment1/Raw.abp"
#' 
#' location_of_resampled_data = system.file("Resample.abp", package = "ECISR")
#' location_of_sample_defintions = system.file("Samples.csv", package = "ECISR")
#' 
#' #Then run the import
#' 
#' #ecis_import_raw(location_of_resampled_data, location_of_sample_defintions)
#' 
ecis_import_raw = function(rawdata, sampledefine)
{

  # Grab all the rows of the file and dump them into a data frame
  
  file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
  base::colnames(file.df) = "Data"
  
  #Generate a data frame containing the titles
  titles.df = subset(file.df, stringr::str_detect(file.df$Data,"Index, Time,")) 
  titlestring = titles.df[1,1]
  titles = unlist(strsplit(titlestring, split = ","))
  titles = trimws(titles)
  
  #Import the whole dataset
  
  # Import the meaty part of the data and clean up the dat types
  fulldata.df = subset(file.df, str_detect(file.df$Data,"^T[0-9]"))
  
  fulldata.df = fulldata.df %>% tidyr::separate(Data, titles, ",|=")
  
  # Clean out the row data from each well's ID
  fulldata.df = fulldata.df %>% tidyr::separate(Index, c("TimeID", "ID"), "W")
  fulldata.df$TimeID = NULL
  
  #Find the cell correlates
  format = subset(file.df, str_detect(file.df$Data,"WellNum"))
  
  if (format[1,1] == "WellNum = 16")
  {
    id_to_well.df = structure(list(ID = 1:16, Well = structure(1:16, .Label = c("A1", 
                                                                                "A2", "A3", "A4", "A5", "A6", "A7", "A8", "B1", "B2", 
                                                                                "B3", "B4", "B5", "B6", "B7", "B8"), class = "factor")), class = "data.frame", row.names = c(NA, -16L))
  }
  
  if (format[1,1] == "WellNum = 96")
  {
    id_to_well.df = structure(list(ID = 1:96, Well = structure(c(1L, 13L, 25L, 37L, 
                                                                 49L, 61L, 73L, 85L, 5L, 17L, 29L, 41L, 53L, 65L, 77L, 89L, 6L, 
                                                                 18L, 30L, 42L, 54L, 66L, 78L, 90L, 7L, 19L, 31L, 43L, 55L, 67L, 
                                                                 79L, 91L, 8L, 20L, 32L, 44L, 56L, 68L, 80L, 92L, 9L, 21L, 33L, 
                                                                 45L, 57L, 69L, 81L, 93L, 10L, 22L, 34L, 46L, 58L, 70L, 82L, 94L, 
                                                                 11L, 23L, 35L, 47L, 59L, 71L, 83L, 95L, 12L, 24L, 36L, 48L, 60L, 
                                                                 72L, 84L, 96L, 2L, 14L, 26L, 38L, 50L, 62L, 74L, 86L, 3L, 15L, 
                                                                 27L, 39L, 51L, 63L, 75L, 87L, 4L, 16L, 28L, 40L, 52L, 64L, 76L, 
                                                                 88L), .Label = c("A1", "A10", "A11", "A12", "A2", "A3", "A4", 
                                                                                  "A5", "A6", "A7", "A8", "A9", "B1", "B10", "B11", "B12", "B2", 
                                                                                  "B3", "B4", "B5", "B6", "B7", "B8", "B9", "C1", "C10", "C11", 
                                                                                  "C12", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "D1", 
                                                                                  "D10", "D11", "D12", "D2", "D3", "D4", "D5", "D6", "D7", "D8", 
                                                                                  "D9", "E1", "E10", "E11", "E12", "E2", "E3", "E4", "E5", "E6", 
                                                                                  "E7", "E8", "E9", "F1", "F10", "F11", "F12", "F2", "F3", "F4", 
                                                                                  "F5", "F6", "F7", "F8", "F9", "G1", "G10", "G11", "G12", "G2", 
                                                                                  "G3", "G4", "G5", "G6", "G7", "G8", "G9", "H1", "H10", "H11", 
                                                                                  "H12", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9"), class = "factor")), class = "data.frame", row.names = c(NA, 
                                                                                                                                                                                                  -96L))
  }
  
  fulldata.df$ID = as.integer(fulldata.df$ID)
  
  #Correlate the generated cell lookup table to ECIS's internal well id's
  fulldata.df = left_join(fulldata.df, id_to_well.df, by = "ID")
  
  #Make the wide dataset long
  fulldata_long.df = fulldata.df %>% tidyr::gather(Type, Value, -Well, -Time, -ID)
  fulldata_long.df$Value = as.numeric(fulldata_long.df$Value)
  
  # Split out frequency and R/C as needed
  fulldata_long.df = fulldata_long.df %>% tidyr::separate(Type, c("Unit", "Frequency"), " ")
  
  
  # Read in sample names and merge them with the long dataset
  names.df = read.csv(sampledefine, as.is = TRUE)
  fulldata_long.df$Well = as.character(fulldata_long.df$Well)
  names.df$Well = as.character(names.df$Well)
  
  fulldata_long.df$Well = ecis_standardise_wells(fulldata_long.df$Well)
  names.df$Well = ecis_standardise_wells(names.df$Well)
  
  combined.df = left_join(fulldata_long.df, names.df, by = "Well")
  
  # Strip the ID variable as it no longer has any use
  combined.df$ID = NULL
  
  ############################### Generate the other physical quantaties
  
  # Wrangle data so it is in columns
  child1.df = combined.df
  child1.df$Value = abs(child1.df$Value)
  widedata.df = tidyr::spread(child1.df, Unit, Value)
  widedata.df$Frequency = as.numeric(widedata.df$Frequency)
  
  # Calculate the new derrivative values
  widedata.df$Z = sqrt(widedata.df$X^2 + widedata.df$R^2)
  widedata.df$C = 1/(2*pi*widedata.df$Frequency*widedata.df$X)*10^9
  widedata.df$P = 90- (atan(widedata.df$X/widedata.df$R)/(2*pi)*360)
  
  #Change format back
  longdata.df = tidyr::gather(widedata.df, Unit, Value, -Well, -Time, -Frequency, -Sample)
  
  #Fix data types
  longdata.df$Unit = factor(longdata.df$Unit)
  longdata.df$Well = as.character(longdata.df$Well)
  longdata.df$Time = as.numeric(longdata.df$Time)
  
  ############################# End re-generation of phyisical measurements
  
  #Add the file name as the experiment ID
  longdata.df$Experiment = rawdata
  
  
  # Explicitly return
  return(longdata.df)
}


# Import modeled data -----------------------------------------------------

rawdata = "HCMVEC/ECIS_190218_MFT_1_TimeResample_RbA.csv"
samples = "HCMVEC/by_treatment.csv"


#' Import raw modeled data
#'
#' @param rawdata Raw modeled data in APB format
#' @param samples CSV file containing which wells correspond to which values
#'
#' @return Data frame containing modeled data
#' @export
#'
#' @examples
#' 
#' #First determine the locatins of your files relative to your dataset.
#'  #Here we use system.file to pull a default out of the filesystem, but you #'  #can use a path relative to the file you are working on. 
#'   #E.G "Experiment1/Raw.abp"
#' 
#' location_of_modeled_data = system.file("Model.csv", package = "ECISR")
#' location_of_sample_defintions = system.file("Samples.csv", package = "ECISR")
#' 
#' #Then run the import
#' 
#' ecis_import_model(location_of_modeled_data, location_of_sample_defintions)
#' 
ecis_import_model = function(rawdata,samples)
{
  
  file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
  base::colnames(file.df) = "Data"
  
  #Import the dataset in segments so that you can get rid of the ECIS crap
  cells.df = subset(file.df, str_detect(file.df$Data,"Well ID"))
  unit.df = subset(file.df, str_detect(file.df$Data,"Time "))
  data.df = subset(file.df, str_detect(file.df$Data,"^[0-9]"))
  
  cells = cells.df[1,1]
  cells = unlist(strsplit(cells, split = ","))
  cells = trimws(cells)
  cells.df = cells
  
  unit = unit.df[1,1]
  unit = unlist(strsplit(unit, split = ","))
  unit = trimws(unit)
  unit.df = unit
  
  #Rename the units something sensible
  unit.df = replace(unit.df, unit.df == "Rb (ohm.cm^2)", "Rb")
  unit.df = replace(unit.df, unit.df == "Alpha (cm.ohm^0.5)", "Alpha")
  unit.df = replace(unit.df, unit.df == "CellMCap(uF/cm^2)", "Cm")
  unit.df = replace(unit.df, unit.df == "Drift (%)", "Drift")
  unit.df = replace(unit.df, unit.df == "RMSE", "RMSE")
  
  # Generate unique names vector
  uniquenamesvector = paste(unit.df,cells.df, sep="_")
  
  # Merge well ID and unit variables together
  
  data.df = data.df %>% tidyr::separate(Data, uniquenamesvector, ",")
  alldata.df = rbind(cells.df,data.df)
  
  
  # Save the timestamps and rename the first one something sensible
  timestamps.df = alldata.df$`Time (hrs)_Well ID`
  timestamps.df[1] = "Time"
  
  # Split the dataframes
  alldataframes <- split.default(alldata.df, sub(x = as.character(names(alldata.df)), pattern = "\\_.*", ""))
  
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
  
  retitle = function(df){
    
    names(df) = as.character(unlist(df[1,]))
    df = df[-1,]
    df
  }
  
  #Re-adjust the headers
  Alpha.df = retitle (Alpha.df)
  Cm.df = retitle (Cm.df)
  Drift.df = retitle (Drift.df)
  Rb.df = retitle (Rb.df)
  RMSE.df = retitle (RMSE.df)
  
  #Set the title of each unit to that of it's dataframe
  Alpha.df$Unit = "Alpha"
  Cm.df$Unit = "Cm"
  Drift.df$Unit = "Drift"
  Rb.df$Unit = "Rb"
  RMSE.df$Unit = "RMSE"
  
  #Split each well into it's own line of a long format dataset
  
  Alpha.df = Alpha.df %>% tidyr::gather(Well, Value, -Time, -Unit)
  Cm.df = Cm.df %>% tidyr::gather(Well, Value, -Time, -Unit)
  Drift.df = Drift.df %>% tidyr::gather(Well, Value, -Time, -Unit)
  Rb.df = Rb.df %>% tidyr::gather(Well, Value, -Time, -Unit)
  RMSE.df = RMSE.df %>% tidyr::gather(Well, Value, -Time, -Unit)
  
  
  #Connect the datasets together end to end
  combined.df = rbind(Alpha.df, Cm.df, Drift.df, Rb.df, RMSE.df)
  
  rm(Alpha.df, Cm.df, Drift.df, Rb.df, RMSE.df, alldataframes, alldata.df)
  
  # Fix up the data types
  combined.df$Time = as.numeric(combined.df$Time)
  combined.df$Value = as.numeric(combined.df$Value)
  combined.df$Unit = factor(combined.df$Unit)
  combined.df$Well = factor(combined.df$Well)
  
  #import the naming tags
  names.df = read.csv(samples)
  names.df$Well  = as.character(names.df$Well)
  combined.df$Well = as.character(combined.df$Well)
  
  names.df$Well = ecis_standardise_wells(names.df$Well)
  combined.df$Well = ecis_standardise_wells(combined.df$Well)
  
  combined.df = left_join(combined.df, names.df, by = "Well")
  
  combined.df$Frequency = 0;
  
  combined.df$Experiment = rawdata
  combined.df$Time = as.numeric(combined.df$Time)
  
  return(combined.df)
}




# Merge the two import sources together -----------------------------------


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
#' location_of_resampled_data = system.file("Resample.abp", package = "ECISR")
#' location_of_modeled_data = system.file("Model.csv", package = "ECISR")
#' location_of_sample_defintions = system.file("Samples.csv", package = "ECISR")
#' 
#' #Then run the import
#' 
#' ecis_import(location_of_resampled_data,location_of_modeled_data, location_of_sample_defintions)
#' 
ecis_import = function ( resample, modeled, key)
{

raw.df = ecis_import_raw(resample, key)
combined.df = ecis_import_model(modeled, key)

masterdata.df = rbind(combined.df, raw.df)
rm(combined.df, raw.df)

return(masterdata.df)

}

#' Generate summary data from combining experiments
#'
#' @param ... A series of data frames to be combined
#'
#' @return A standard ECIS data frame with summary statistics for each row. One row per sample and time combination.
#' @export
#'
#' @examples
#' 
#' #Generate two pretend datasets
#' experiment1.df = data.df
#' experiment2.df = data.df
#' 
#' #ecis_combine_mean(experiment1.df, experiment2.df)
#' warning("This funciton is broken")
#' 
ecis_combine_mean = function (...)
{
  warning("This funciton is broken")
  
  dataframes = list(...)
  
  alldata = ecis_summarise(dataframes[[1]][0,])
  loops = 1
  
  for(i in dataframes){
    indata = ecis_summarise(i)
    indata$Experiment = loops
    loops = loops + 1
    alldata = rbind(alldata, indata)
  }
  
  return (alldata)
  
}

#' Export a prism-compatable data set
#'
#' @param data.df ECIS dataframe
#' @param unit Unit of data to export
#' @param frequency Frequency of data requored, modeled data defaults to 0
#'
#' @return A data frame that can be copied and pasted into prism
#' @export
#'
#' @examples
#' ecis_prism(data.df, "Rb", 0)
#' 

ecis_prism = function(data.df, unit, frequency){
  
  #Cut the data frame down to what can reasonably be represented on one prism table
  
  data.df = subset(data.df, Frequency == frequency)
  data.df = subset(data.df, Unit == unit)
  
  data.df = dplyr::summarise(group_by(data.df, Sample, Time, Experiment),
                                Value=mean(Value))
  
  #Get rid of all the variables that are not required in prism
  data.df$n = NULL
  data.df$sd = NULL
  data.df$sem = NULL
  data.df$Unit = NULL
  data.df$Frequency = NULL
  data.df$TimeID = NULL
  
  #Generate a row title
  data.df$ExpSam = paste(data.df$Sample, "(",data.df$Experiment,")")
  data.df$Experiment = NULL
  data.df$Sample = NULL
  
  #Do the magic bit
  data.df = tbl_df(data.df) #This row just makes tidyR work nicley
  data.df = tidyr::spread(data.df, ExpSam, Value)
  
  #Now delete all the bracketed bits
  base::colnames(data.df) = gsub("\\s*\\([^\\)]+\\)","",as.character(colnames(data.df)))
  
  return (data.df)
}



#' Combine data frames end to end
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
#' experiment1.df = data.df
#' experiment2.df = data.df
#' 
#' ecis_combine(experiment1.df, experiment2.df)
#' 
ecis_combine = function (...)
{
  
  dataframes = list(...)
  
  #Test filler variables
  #dataframes = list(child1.df, child2.df, child3.df)
  #i = 1
  
  #Generate an empty data frame with the correct columns to fill later
  alldata = dataframes[[1]][0,]
  loops = 1
  
  for(i in dataframes){
    indata = i
    indata$Experiment = paste (loops, ":", indata$Experiment)
    loops = loops + 1
    alldata = rbind(alldata, indata)
  }
  
  alldata$Experiment = as.factor(alldata$Experiment)
  
  return (alldata)
  
}

#' Downsample data
#' 
#' Returns a subset of the original data set that has only every nth value. Greatly increases computational preformance for a minimal loss in resolution during time course experiments.
#'
#' @param data.df An ECIS dataset
#' @param nth  An integer. Every nth value will be preserved in the subsetting
#'
#' @return Downsampled ECIS data set
#' @export
#'
#' @examples
#' 
#' ecis_subset(data.df, 50)
#' 
ecis_subset = function(data.df, nth)
{
  
  Time = unique(data.df$Time)
  TimeID = c(1:length(Time))
  time.df = data.frame(TimeID, Time)
  
  withid.df = dplyr::left_join(data.df, time.df, by="Time")
  subset.df = subset(withid.df, (TimeID %% nth) == 1)
  
  data.df = subset.df
  subset.df$TimeID = NULL
  
  return(data.df)
  
}





#' Standardise wells
#' 
#' Replaces A01 in strings with A0. Important for importing ABP files which may use either notation.
#'
#' @param well The well to be standardised 
#'
#' @return Standardised well names
#' 
#' @export
#'
#' @examples 
#' ecis_standardise_wells("A01")
#' 
ecis_standardise_wells = function(well)
{
  sub('(?<![0-9])0*(?=[0-9])', '', well, perl=TRUE)
}
