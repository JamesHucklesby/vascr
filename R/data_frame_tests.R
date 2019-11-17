

ecis_test = function ()
{
  
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
#' 
#' @export
#'
#' @examples
#' # Prep a known good compliment of data
#' data = ecis_subset(growth.df, time = 100, unit = "R", frequency = 4000)
#' 
#' # Test a full compliment of data passes
#' ecis_test_design(data)
#' 
#' ecis_test_design(growth.df)

#' # Test function picks up unbalanced replicate #'s
#' data2 = ecis_exclude(data, well = c("A1", "B1", "C1"))
#' ecis_test_design(data2)

#' # Test function picks up missing pairs (in this case due to Rb not being established)
#' data3 = ecis_subset(growth.df, time = 100, unit = "Rb")
#' ecis_test_design(data3)
#' 
ecis_test_design = function(data.df, verbose = FALSE)
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


#' Test the summary level of an ECIS dataframe
#'
#' @param data.df A standard ECIS dataframe
#'
#' @return A summarised standard ECIS dataframe
#'
#' @export
#'
#' @examples
#' experiment.df = ecis_summarise(growth.df, "experiment")
#' summary.df = ecis_summarise(growth.df, "summary")
#' 
#' ecis_test_summary_level(growth.df)
#' ecis_test_summary_level(experiment.df)
#' ecis_test_summary_level(summary.df)
#' 
ecis_test_summary_level = function(data.df)
{
  if(identical(unique(data.df$Experiment),"Summary"))
  {
    return ("summary")
  }
  
  else if(identical(unique(data.df$Well),"Z00"))
  {
    return ("experiment")
  }
  else
  {
  return("replicate")
  }
  
  
}


