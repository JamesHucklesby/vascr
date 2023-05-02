#' Test if an ECIS data frame is exploded
#'
#' This function tests to see if exploded columns are present in a dataset. Does not check that all are present, or that they are corrrectly exploded as this would be much slower.
#'
#' @param data the data frame to test
#'
#'@keywords internal
#'
#' @return True (exploded) or false (not exploded)
#' 
#' @examples
#' #vascr_test_exploded(growth.df)
#' #imploded = vascr_implode(growth.df)
#' #vascr_test_exploded(imploded)
#'
vascr_test_exploded = function(data.df)
{
  # If exploded cols exist, assume it's exploded
  return(length(vascr_exploded_cols(data.df))>1)
}




#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#' 
#' @importFrom dplyr group_by
#' @importFrom tidyr replace_na
#'
#' @examples
#' vascr_test_normalised(growth.df)
#' 
#' normdata  = vascr_normalise(growth.df, 100)
#' 
#' vascr_test_normalised(normdata)
#' 
vascr_test_normalised = function(data.df)
{
  
  timesplit = data.df %>% group_by(Time) %>%
    summarise(sd = sd(Value, na.rm = TRUE)) %>%
    mutate(sd = signif(sd, 4)) %>%
    mutate(normtime = (sd ==0)) %>%
    mutate(normtime = replace_na(normtime, FALSE))
  
  
  return(any(timesplit$normtime))
  
}




#' Test the integrity of an ECIS dataframe
#' 
#' This function will run a whole suite of tests on an ECIS dataframe, to check that it is both well designed for statistical analysis as well as technically intact
#'
#' @param data.df An ECIS dataframe, subset if needed
#' @param verbose How verbose to be. FALSE returns a dataset, TRUE returns a full verbose output of each test
#'
#' @return A whole slew of tests
#' @importFrom dplyr group_by summarise
#' @importFrom magrittr "%>%"
#' 
#' @keywords internal
#' 
#' @export
#'
#' @examples
#' # Prep a known good compliment of data
#' #data = vascr_subset(growth.df, time = 100, unit = "R", frequency = 4000)
#' 
#' # Test a full compliment of data passes
#' #vascr_test_design(data)
#' 
#' #vascr_test_design(growth.df)

#' # Test function picks up unbalanced replicate #'s
#' #data2 = vascr_exclude(data, well = c("A1", "B1", "C1"))
#' #vascr_test_design(data2)

#' # Test function picks up missing pairs (in this case due to Rb not being established)
#' #data3 = vascr_subset(growth.df, time = 100, unit = "Rb")
#' #vascr_test_design(data3)
#' 
vascr_test_design = function(data.df, verbose = FALSE)
{
  
  data = data.df  #Copy out the data so we can muck with if needed
  tests = list()  #Setup an empty tests variable for us to use later
  
  tests$data_length = nrow(data)
  tests$wells_used = unique(paste(data$Experiment, " : ", data$Well))
  tests$units_included = unique(data$Unit)
  
  
  # Check --- Is experimental design balanced? -----------------------------------------------------
  
  theoretical_pairs = expand.grid(Sample = unique(data$Sample), Experiment = unique(data$Experiment))
  theoretical_pairs = paste(theoretical_pairs$Sample, theoretical_pairs$Experiment) ## Up to here with proofing
  experimental_pairs = paste(data$Sample, data$Experiment, sep = "#")
  
  missing_data = setdiff(theoretical_pairs, experimental_pairs)
  
  if(length(missing_data)>0)
  {
    tests$balanced_samples = FALSE
    tests$missing_samples = missing_data
  }
  else
  {
    tests$balanced_samples = TRUE
  }
  
  
  # Check --- is replicate number balanced ----------------------------------------------------------------------
  
  pairs = as.data.frame(experimental_pairs)
  pairs = pairs %>%
    group_by(experimental_pairs)  %>%
    summarise(n = n())
  
  tests$median_sample_size = median(pairs$n)
  
  if(sd(pairs$n)>0) # All sample sizes are not the same
  {
    tests$balanced_replicates = FALSE
    tests$unbalanced_replicates = subset(pairs, n !=median(pairs$n))
    tests$unbalanced_replicates = tests$unbalanced_replicates %>% separate(experimental_pairs, c("Sample", "Experiment"), sep = "[#]")
    
  }
  else
  {
    tests$balanced_replicates = TRUE
  }
  
  return(tests)
  
}



#' Check if there are any standard 96 well plate wells missing from a 96 well plate
#'
#' @param wells A vector of wells to test, or a vascr dataset that will be truncated
#'
#' @return A vector of the well names that are missing from the dataset
#' 
#' @keywords internal
#'
#' @examples
vascr_missing_wells = function(wells)
{
  
  if(is.data.frame(wells))
  {
    wells = wells$Well
  }
  
  uwells = unique(wells)
  awells = vascr_96_well_names()
  mwells = subset(awells, !(awells %in% uwells))
  return(mwells)
}


#' Title
#'
#' @param dataset 
#'
#' @return
#' @export
#'
#' @examples
vascr_test_resampled = function(dataset)
{
  timebases = dataset %>% group_by(across(c(-Value, -Time))) %>% summarise(times = sum(Time^2), .groups = "keep") %>% ungroup() %>% select(times) %>% distinct() %>% nrow()
  
  if(timebases>1)
  {
    return(FALSE)
  }
  else
  {
    return(TRUE)
  }
  
}



