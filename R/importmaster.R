# Import Raw Data ---------------------------------------------------------

#' Raw data importer
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
#' #First determine the locatins of your files relative to your dataset. Here we use system.file to pull a default out of the filesystem, but you can use a path relative to the file you are working on. E.G "Experiment1/Raw.abp"
#' 
#' location_of_resampled_data = system.file("Resample.abp", package = "ECISR")
#' location_of_sample_defintions = system.file("Samples.csv", package = "ECISR")
#' 
#' #Then run the import
#' 
#' ecis_import_raw_long(location_of_resampled_data, location_of_sample_defintions)
#' 
ecis_import_raw_long = function(rawdata, sampledefine)
{

  
  #Generate a data frame containing the titles
  titles.df = read.table(rawdata, as.is = TRUE, skip = 19, nrows = 1, sep=",", strip.white = TRUE)
  titles.df = titles.df[1,1:length(titles.df)-1] #Remove the last one that overhangs
  
  #Import the whole dataset
  
  #Work out how long the data set is by looking for the comments line
  #fulldata.df = read.table(rawdata, as.is = TRUE, skip = 20, sep = "\n")
  #maxrows = which(fulldata.df == "[Comments]")
  #nrows = maxrows-1
  #not needed for a resampled file
  
  # Import the meaty part of the data and clean up the dat types
  fulldata.df = read.table(rawdata, as.is = TRUE, skip = 21, sep = ",", strip.white = TRUE)
  fulldata.df = fulldata.df %>% tidyr::separate(V1, c("T1", "T2"), " = ")
  fulldata.df$T2 = as.numeric(fulldata.df$T2)
  names(fulldata.df) = as.character(unlist(titles.df[1,]))
  
  # Clean out the row data from each well's ID
  fulldata.df = fulldata.df %>% tidyr::separate(Index, c("Replicate", "ID"), "W")
  fulldata.df$Replicate = NULL
  
  #Find the cell correlates
  id_to_well.df = read.csv("data/id_to_well.csv")
  fulldata.df$ID = as.integer(fulldata.df$ID)
  
  #Correlate the generated cell lookup table to ECIS's internal well id's
  fulldata.df = left_join(fulldata.df, id_to_well.df, by = "ID")
  
  #Make the wide dataset long
  fulldata_long.df = fulldata.df %>% tidyr::gather(Type, Value, -Well, -Time, -ID)
  fulldata_long.df$Value = as.numeric(fulldata_long.df$Value)
  
  # Split out frequency and R/C as needed
  fulldata_long.df = fulldata_long.df %>% tidyr::separate(Type, c("Unit", "Frequency"), " ")
  
  # Change well A01 to well A1 so it lines up with sample definition file (could be earlier)
  fulldata_long.df$Well = sub('(?<![0-9])0*(?=[0-9])', '', fulldata_long.df$Well, perl=TRUE)
  
  # Read in sample names and merge them with the long dataset
  names.df = read.csv(sampledefine, as.is = TRUE)
  ####fulldata_long.df$Well = as.character(fulldata_long.df$Well)
  ####names.df$Well = as.character(names.df$Well)
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
  
  ############################# End re-generation of phyisical measurements
  
  #Add the file name as the experiment ID
  longdata.df$Experiment = rawdata
  
  # Explicitly return
  return(longdata.df)
}


# Import modeled data -----------------------------------------------------


#' Title
#'
#' @param rawdata Raw modeled data in APB format
#' @param samples CSV file containing which wells correspond to which values
#'
#' @return Data frame containing modeled data
#' @export
#'
#' @examples
#' 
#' #' #First determine the locatins of your files relative to your dataset. Here we use system.file to pull a default out of the filesystem, but you can use a path relative to the file you are working on. E.G "Experiment1/Raw.abp"
#' 
#' location_of_modeled_data = system.file("Model.csv", package = "ECISR")
#' location_of_sample_defintions = system.file("Samples.csv", package = "ECISR")
#' 
#' #Then run the import
#' 
#' ecis_import_model_long(location_of_modeled_data, location_of_sample_defintions)
#' 
ecis_import_model_long = function(rawdata,samples)
{
  
  #Import the dataset in segments so that you can get rid of the ECIS crap
  cells.df = read.table(rawdata, header = FALSE, sep = ",", skip = 20, nrows = 1, stringsAsFactors = FALSE)
  unit.df = read.table(rawdata, header = FALSE, sep = ",", skip = 19, nrows = 1, stringsAsFactors = FALSE)
  data.df = read.table(rawdata, header = FALSE, sep = ",", skip = 23, stringsAsFactors = FALSE)
  
  #Rename the units something sensible
  unit.df = replace(unit.df, unit.df == " Rb (ohm.cm^2)", "Rb")
  unit.df = replace(unit.df, unit.df == " Alpha (cm.ohm^0.5)", "Alpha")
  unit.df = replace(unit.df, unit.df == " CellMCap(uF/cm^2)", "Cm")
  unit.df = replace(unit.df, unit.df == " Drift (%)", "Drift")
  unit.df = replace(unit.df, unit.df == " RMSE", "RMSE")
  cells.df = trimws(cells.df)
  
  # Generate unique names vector
  uniquenamesvector = paste(unit.df,cells.df, sep="_")
  cells.df = cells.df[1:length(cells.df)-1]
  
  # Merge well ID and unit variables together
  alldata.df = rbind(uniquenamesvector,cells.df,data.df)
  
  rm(uniquenamesvector, cells.df, data.df, unit.df)
  
  #Generate a funciton that changes the headers to the unique values
  
  retitle = function(df){
    
    names(df) = as.character(unlist(df[1,]))
    df = df[-1,]
    df
  }
  
  alldata.df = retitle(alldata.df)
  
  
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
  combined.df = left_join(combined.df, names.df, by = "Well")
  
  combined.df$Frequency = 0;
  
  # State that the experiment is not applicable at this point
  combined.df$Experiment = rawdata
  
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
#' ecis_import_long(location_of_resampled_data,location_of_modeled_data, location_of_sample_defintions)
#' 
ecis_import_long = function ( resample, modeled, key)
{

raw.df = ecis_import_raw_long(resample, key)
combined.df = ecis_import_model_long(modeled, key)

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
  time.df = data.frame(TimeID, Time)w
  
  withid.df = dplyr::left_join(data.df, time.df, by="Time")
  subset.df = subset(withid.df, (TimeID %% nth) == 1)
  
  data.df = subset.df
  subset.df$TimeID = NULL
  
  return(data.df)
  
}
