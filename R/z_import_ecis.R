# Import Raw ECIS data ---------------------------------------------------------


#' Calculate electrical properties of ECIS data
#' 
#' ECIS instrments capure phase and impedance data. This needs to be converted in software into resistance and capacatance values that are more directly interpretable. This function does that using trigonemetric functions. Validated against data produced by Applied Biophysics' ECIS software.
#' 
#' Function used by default as part of ecis_import_raw
#'
#' @param data.df The dataset to calculate from
#' 
#' @noRd
#'
#' @return An ecis data frame, with calculated values included
ecis_calculate_quantaties = function(data.df)
{
  # Wrangle data so it is in columns
  child1.df = data.df
  child1.df$Value = abs(child1.df$Value)
  widedata.df = tidyr::spread(child1.df, Unit, Value) %>% mutate(Frequency = as.numeric(Frequency))
  
  # Calculate the new derivative values
  widedata.df$Z = sqrt(widedata.df$X^2 + widedata.df$R^2)
  widedata.df$C = 1/(2 * pi * widedata.df$Frequency * widedata.df$X) * 10^9
  widedata.df$P = 90 - (atan(widedata.df$X/widedata.df$R)/(2 * pi) * 360)
  
  # Change format back
  longdata.df = tidyr::gather(widedata.df, Unit, Value, -Well, -Time, -Frequency)
  
  # Fix data types
  longdata.df$Unit = factor(longdata.df$Unit)
  longdata.df$Well = as.character(longdata.df$Well)
  longdata.df = longdata.df %>% mutate(Time = as.numeric(Time))
  
  return(longdata.df)
}

#' Import a table of names
#'
#' @param sampledefine The CSV file to be imported
#'
#' @return A data frame containing the samples defined in the file
#' 
#' @export
#' 
#' @importFrom dplyr relocate mutate
#' @importFrom tidyr separate_rows unite
#' @importFrom stringr str_count
#' 
#'
#' @examples
#' sampledefine = system.file('extdata/growth/growth1_samples.csv', package = 'vascr')
#' vascr_import_map(sampledefine)
#' 
vascr_import_map = function(sampledefine)
{
  
  file_content = read.csv(sampledefine)
  file_content$SampleID = c(1:nrow(file_content))
  
  if(colnames(file_content) %>% str_count("Well") %>% sum() ==1)
  {
    colnames(file_content)[1] = "Well"
  }
  
  if("Well" %in% colnames(file_content))
  {
    file_map = file_content %>% mutate(Well = vascr_standardise_wells(Well))
  }else{
  
  file_map = file_content %>% mutate(Row = trimws(Row), Column = trimws(Column)) %>%
    separate_rows(Row, sep = " ") %>%
    separate_rows(Column, sep = " ") %>%
    mutate(Well = paste(Row, Column, sep = ""), Well = vascr_standardise_wells(Well)) %>%
    mutate(Row = NULL, Column = NULL) %>%
    relocate(Well)
  }
  
  # Copy down the col name into each cell, separated by _
  for (col in colnames(file_map)[2:length(colnames(file_map))])
  {
    file_map[[col]] = paste(file_map[[col]],col, sep ="_")
  }
  
  file_map = file_map %>% unite("Sample", -Well, sep =" + ")
  
  
  return(file_map)
  
}



#' Internal function to assign sample names to a data frame
#'
#' @param data an ECIS data frame
#' @param sampledefine  path to the file containing the sample definitions
#'
#' @return A standard ECIS data frame, annotated
#' 
#' @noRd
#'
#' @examples
#' # This function is baked into ecis_import and it's parts
#' 
vascr_assign_samples = function (data, sampledefine)
{
  
  data$Well = vascr_standardise_wells(data$Well)
  
  if(is.null(sampledefine)) # If samples are not defined, bypass this and just spit out well id's as names
  {
    data$Sample = paste(data$Well, "Well", sep = "_")
    warning("The argument 'sampledefine' is not set. Defaulting to using well ID's as sample names")
    return(data)
  }
  
  vascr_validate_file(sampledefine, c("csv"))
  
  # Read in the data table created by the user
  names.df = vascr_import_map(sampledefine)
  
  # Standardize all wells
  names.df$Well = vascr_standardise_wells(names.df$Well)
  
  
  #Sanity check that the user has fed the right file
  if(!"Well" %in% colnames(names.df))
  {
    warning("The first column is not entitled 'Well'. Please check this and try to import again")
  }


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
#' @param experimentname Name of the experiment to be built into the dataset
#'
#' @return Data frame containing all the raw data readings from the ECIS Z0 instrument
#' 
#' @importFrom utils read.delim
#' @importFrom tidyr separate spread gather
#' @importFrom stringr str_detect str_replace
#' @importFrom dplyr left_join
#' 
#' 
#' @noRd
#'
#' @examples
#' 
#' #First determine the locatins of your files relative to your dataset. 
#' #Here we use system.file to pull a default out of the filesystem, 
#' #but you can use a path relative to the file you are working on. 
#' #E.G 'Experiment1/Raw.abp'
#' 
#' #rawdata = system.file('extdata/growth1_raw_TimeResample.abp', package = 'vascr')
#' #sampledefine = system.file('extdata/growth1_samples.csv', package = 'vascr')
#' 
#' #Then run the import
#' 
#' #data1 = ecis_import_raw(rawdata, sampledefine, "TEST")
#' #data1$Experiment = "Growth_1"
#' #head(data1)
#' #vascr_plot(data1, unit = "X")
#'
#' 
ecis_import_raw = function(rawdata, sampledefine, experimentname = "NA") {
  
  # check the files to be imported exist and are of the correct format
  vascr_validate_file(rawdata, "abp")
  vascr_validate_file(sampledefine, c("csv", "xlsx"))
    
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
    
    id_to_well.df$Well = vascr_standardise_wells(id_to_well.df$Well)
    
    
    # Correlate the generated cell lookup table to ECIS's internal well id's
    fulldata.df = left_join(fulldata.df, id_to_well.df, by = "ID")
    
    
    # Make the wide dataset long
    fulldata_long.df = fulldata.df %>% tidyr::gather("Type", Value, -Well, -Time, -"ID")
    fulldata_long.df = fulldata_long.df %>% mutate(Value = as.numeric(Value))
    
    separate = fulldata_long.df %>% select(Type) %>% distinct() %>% tidyr::separate("Type", c("Unit", "Frequency"), remove = FALSE)
    
    # Split out frequency and R/C as needed
    fulldata_long.df = fulldata_long.df %>% left_join(separate, by = "Type")
    
    fulldata_long.df$ID = NULL
    fulldata_long.df$Type = NULL
    
    # Generate the other physical quantaties
    
    longdata.df = ecis_calculate_quantaties(fulldata_long.df)
    
    # Add constants, standardise well format and assign samples
    
    if(!missing(experimentname))
    {
    longdata.df$Experiment = basename(rawdata)
    }
    else
    {
     longdata.df$Experiment = experimentname
    }
    
    
    longdata.df$Instrument = "ECIS"

    combined.df = vascr_assign_samples(data = longdata.df, sampledefine)
    
    gc(verbose = FALSE)
    
    # Explicitly return
    return(combined.df)
}


# Import modeled data -----------------------------------------------------


#' Import raw modeled data
#'
#' @param modeleddata Raw modeled data in APB format
#' @param sampledefine CSV file containing which wells correspond to which values
#' @param experimentname Name of the experiment to be built into the dataset
#'
#' @return Data frame containing modeled data
#' 
#' @noRd
#' 
#' @importFrom stringr str_detect
#' @importFrom tidyr separate gather pivot_longer
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
#' #modeleddata = system.file('extdata/growth1_raw_TimeResample_RbA.csv', package = 'vascr')
#' #sampledefine = system.file('extdata/growth1_samples.csv', package = 'vascr')
#' 
#' #Then run the import
#' 
#' #data = ecis_import_model(modeleddata, sampledefine)
#' #head(data)
#' #vascr_plot(data, unit = "Rb", level = "wells")
#' 
#' modeleddata = "E:\\Vascr demo\\growth1_model_50.csv"
#'sampledefine = "E:\\Vascr demo\\growth1_samples.csv"
#' 
#' # ecis_import_model(modeleddata, sampledefine)
ecis_import_model = function(modeleddata, sampledefine, experimentname = "NA") {
  
   # Validate that the files are readable
   vascr_validate_file(modeleddata, "csv")
   vascr_validate_file(sampledefine, c("csv", "xlsx"))
    
    rawdata = modeleddata
  
    file.df = read.delim(rawdata, as.is = TRUE, sep = "\n", strip.white = TRUE)
    colnames(file.df) = "Data"
    
    # Import the dataset in segments so that you can get rid of the ECIS crap
    cells.df = subset(file.df, str_detect(file.df$Data, "Well ID"))
    unit.df = subset(file.df, str_detect(file.df$Data, "Time "))
    data.df = subset(file.df, str_detect(file.df$Data, "^[0-9]"))
    
    if(nrow(unit.df)==0)
    {
      warning("No data imported, check the modeled data you are trying to import is correctly specified and an intact file")
    }
    
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
    
    alldata.df = alldata.df[-1,]
    colnames(alldata.df)[1] = "Time"
    
    
    combined.df = alldata.df %>% pivot_longer(cols = -Time, values_to = "Value") %>%
      separate(name, into = c("Unit", "Well"))
    
    
    # Fix up the data types
    combined.df$Time = as.numeric(combined.df$Time)
    combined.df$Value = as.numeric(combined.df$Value)
    combined.df$Unit = factor(combined.df$Unit)
    combined.df$Well = factor(combined.df$Well)
    
    combined.df$Well = vascr_standardise_wells(combined.df$Well)
    
    
    
    # import the naming tags
    combined2.df = vascr_assign_samples(combined.df, sampledefine)
    
    combined2.df$Frequency = 0

    # Add constants and fix data types
    if(!missing(experimentname))
    {
      combined2.df$Experiment = basename(modeleddata)
    }
    else
    {
      combined2.df$Experiment = experimentname
    }
    
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
#' @param experimentname Name of the experiment to be built into the dataset
#'
#' @return A dataframe containing all the data APB generated from an experiment 
#' 
#' @export
#'
#' @examples
#' 
#' #rawdata = system.file('extdata/growth1_raw_TimeResample.abp', package = 'vascr')
#' #modeled = system.file('extdata/growth1_raw_TimeResample_RbA.csv', package = 'vascr')
#' #key = system.file('extdata/growth1_samples.csv', package = 'vascr')
#' 
#' #Then run the import
#' 
#' #data = ecis_import(rawdata,modeled,key, experimentname = "TEST")
#' #head(data)
ecis_import = function(rawdata = NULL, modeled = NULL, key = NULL, experimentname = "NA") {
  
  # Validate files exist and are correct. Will be done in the internal functions, but doing it here saves time on failure
  vascr_validate_file(rawdata, "abp")
  vascr_validate_file(modeled, "csv")
  vascr_validate_file(key, "csv")
  
  
    combined.df = ecis_import_model(modeled, key, experimentname)
    raw.df = ecis_import_raw(rawdata, key, experimentname)
    masterdata.df = vascr_combine(combined.df, raw.df)
    
    masterdata.df$Experiment = experimentname
    
    return(masterdata.df)
}

