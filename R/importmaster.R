

# Import Raw Data ---------------------------------------------------------

#' Title
#'
#' @param rawdata 
#' @param sampledefine 
#'
#' @return
#' @export
#'
#' @examples
#' 
ecis_import_raw_long = function(rawdata, sampledefine)
{
  
  library(tidyr)
  
  #rawdata = "Growth1/Resample.abp"
  #sampledefine = "Growth1/Samples.csv"
  
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
  fulldata.df = fulldata.df %>% separate(V1, c("T1", "T2"), " = ")
  fulldata.df$T2 = as.numeric(fulldata.df$T2)
  names(fulldata.df) = as.character(unlist(titles.df[1,]))
  
  # Clean out the row data from each well's ID
  fulldata.df = fulldata.df %>% separate(Index, c("Replicate", "ID"), "W")
  fulldata.df$Replicate = NULL
  
  #Find the cell correlates
  id_to_well.df = readRDS("data/id_to_well.rds")
  fulldata.df$ID = as.integer(fulldata.df$ID)
  
  #Correlate the generated cell lookup table to ECIS's internal well id's
  fulldata.df = left_join(fulldata.df, id_to_well.df, by = "ID")
  
  #Make the wide dataset long
  fulldata_long.df = fulldata.df %>% gather(Type, Value, -Well, -Time, -ID)
  fulldata_long.df$Value = as.numeric(fulldata_long.df$Value)
  
  # Split out frequency and R/C as needed
  fulldata_long.df = fulldata_long.df %>% separate(Type, c("Unit", "Frequency"), " ")
  
  # Change well A01 to well A1 so it lines up with sample definition file (could be earlier)
  fulldata_long.df$Well = sub('(?<![0-9])0*(?=[0-9])', '', fulldata_long.df$Well, perl=TRUE)
  
  # Read in sample names and merge them with the long dataset
  names.df = read.csv(sampledefine, as.is = TRUE)
  fulldata_long.df$Well = as.character(fulldata_long.df$Well)
  names.df$Well = as.character(names.df$Well)
  combined.df = left_join(fulldata_long.df, names.df, by = "Well")
  
  # Strip the ID variable as it no longer has any use
  combined.df$ID = NULL
  
  ############################### Generate the other internal values
  
  # Wrangle data so it is in columns
  child1.df = combined.df
  child1.df$Value = abs(child1.df$Value)
  widedata.df = spread(child1.df, Unit, Value)
  widedata.df$Frequency = as.numeric(widedata.df$Frequency)
  
  # Calculate the new derrivative values
  widedata.df$Z = sqrt(widedata.df$X^2 + widedata.df$R^2)
  widedata.df$C = 1/(2*pi*widedata.df$Frequency*widedata.df$X)*10^9
  widedata.df$P = 90- (atan(widedata.df$X/widedata.df$R)/(2*pi)*360)
  
  #Change format back
  longdata.df = gather(widedata.df, Unit, Value, -Well, -Time, -Frequency, -Sample)
  
  #Fix data types
  longdata.df$Unit = factor(longdata.df$Unit)
  longdata.df$Well = factor(longdata.df$Well)
  
  ############################# End new section
  
  
  # Explicitly return
  return(longdata.df)
}


# Import modeled data -----------------------------------------------------

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
  
  library(tidyr)
  library(dplyr)
  
  
  #Split each well into it's own line of a long format dataset
  
  Alpha.df = Alpha.df %>% gather(Well, Value, -Time, -Unit)
  Cm.df = Cm.df %>% gather(Well, Value, -Time, -Unit)
  Drift.df = Drift.df %>% gather(Well, Value, -Time, -Unit)
  Rb.df = Rb.df %>% gather(Well, Value, -Time, -Unit)
  RMSE.df = RMSE.df %>% gather(Well, Value, -Time, -Unit)
  
  
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
  combined.df = left_join(combined.df, names.df, by = "Well")
  
  combined.df$Frequency = 0;
  
  return(combined.df)
}




# Merge the two import sources together -----------------------------------


ecis_import_long = function ( resample, modeled, key)
{

raw.df = ecis_import_raw_long(resample, key)
combined.df = ecis_import_model_long(modeled, key)

# Pre-compute statistics, but don't because it takes ages
#combinedsummary.df = summarySE(combined.df, measurevar="Value", groupvars=c("Sample","Time", "Unit", "Frequency"))
#rawsummary.df = summarySE(raw.df, measurevar="Value", groupvars=c("Sample","Time", "Unit", "Frequency"))

masterdata.df = rbind(combined.df, raw.df)
rm(combined.df, raw.df)

alltimepoints = masterdata.df$Time

Time = unique(alltimepoints)
TimeID = c(0:(length(Time)-1)) #Generate a vector containing all the ID;s
time_integer.df = data.frame(TimeID, Time) #Convert both lists into a dataframe

masterdata.df = left_join(masterdata.df, time_integer.df, by = 'Time')

return(masterdata.df)

}


ecis_combine_mean = function (...)
{
  
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

ecis_prism = function(prism.df, unit, frequency){
  
  #Cut the data frame down to what can reasonably be represented on one prism table
  prism.df = subset(prism.df, Frequency == frequency)
  prism.df = subset(prism.df, Unit == unit)
  
  #Get rid of all the variables that are not required in prism
  prism.df$n = NULL
  prism.df$sd = NULL
  prism.df$sem = NULL
  prism.df$Unit = NULL
  prism.df$Frequency = NULL
  prism.df$TimeID = NULL
  
  #Generate a row title
  prism.df$ExpSam = paste(prism.df$Sample, "(",prism.df$Experiment,")")
  prism.df$Experiment = NULL
  prism.df$Sample = NULL
  
  #Do the magic bit
  prism.df = tbl_df(prism.df) #This row just makes tidyR work nicley
  prism.df = spread(prism.df, ExpSam, Value)
  
  #Now delete all the bracketed bits
  colnames(prism.df) = gsub("\\s*\\([^\\)]+\\)","",as.character(colnames(prism.df)))
  
  return (prism.df)
}
