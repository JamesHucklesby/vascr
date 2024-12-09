#' Subset a vascr data set based on a number of factors
#'
#' @param data.df Vascr data set to subset
#' @param time Specified times. Individual values in a list will be subset out. If vectors are present in the list, values between the two most extreme values will be returned.
#' @param unit Units to subset. These are checked for integrity against possible units and the dataset itself
#' @param well Wells to select
#' @param frequency Frequencies to include in the data set.
#' @param experiment Experiments to include in the data set. Can be addressed either by name, or by the numerical order that they were loaded into vascr_combine in
#' @param instrument Which instruments to include values from
#' @param subsample Frequency values shoud be subsampled to
#' @param sampleid List of ID's to be used. Sample names will be re-ordered accordingly for display.
#'
#' @return The subset dataset, based on the values selected
#' 
#' @importFrom dplyr as_tibble
#' @importFrom stringr str_count
#' 
#' @export
#'
#' @examples
#' # vascr_subset(growth.df)
#' # vascr_subset(growth.df, time = 40)
#' # vascr_subset(growth.df, time = NULL)
#'  
#' # vascr_subset(growth.df, unit = "Rb")
#' # vascr_subset(growth.df, unit = "R")
#' # vascr_subset(growth.df, well = "A1")
#' # vascr_subset(growth.df, value_less_than = 100)
#' # 
#' 
#' # vascr_subset(growth.df, time = c(5,20))
#' 
#' 
vascr_subset = function(data.df, 
                        time = NULL, 
                        unit = NULL, 
                        well = NULL, 
                        frequency = NULL,
                        experiment = NULL,
                        instrument = NULL,
                        sampleid = NULL,
                        subsample = NULL)
{
  
  
  subset.df = data.df
  
  # Subsample (this is the cheapest so let's do it first)
  if(!is.null(subsample))
  {
    subset.df = vascr_subsample(subset.df, subsample)
  }
  
  
  # Unit
  if(!is.null(unit))
  {
    units = vascr_find_unit(subset.df, unit)
    subset.df = subset(subset.df, subset.df$Unit %in% unique(units))
    subset.df$Unit = factor(subset.df$Unit, unique(units))
  }
  
  
  # Frequency
  if(!is.null(frequency))
  {
    if(typeof(subset.df$Frequency) != "double")
    {
      subset.df = subset.df %>% mutate(Frequency = as.double(.data$Frequency))
    }
    
    frequencies = vascr_find_frequency(subset.df, frequency)
    subset.df = subset(subset.df, subset.df$Frequency %in% frequencies)
  }
  
  
  # Well
  if(!is.null(well))
  {
    include = vector()
    exclude = vector()
    
    for(w in 1:length(well))
    {
      if(str_count(well[w], "\\-") == 1)
      {
        exclude = append(exclude, well[w])
      } else
      {
        include = append(include, well[w])
      }
    }
    
    include = vascr_find_well(subset.df, include)
    exclude = vascr_find_well(subset.df, exclude)
    
    if(length(include>0))
    {
    subset.df = subset(subset.df, subset.df$Well %in% include)
    } else
    {
    subset.df = subset(subset.df, !(subset.df$Well %in% exclude))
    }
    
  }
  
  
  
  # Time
  if(!is.null(time))
  {
    times = vascr_find_time(subset.df, time)
    subset.df = subset(subset.df, subset.df$Time %in% times)
  }
  
  # Experiment
  if(!is.null(experiment))
  {
    experiments = vascr_find_experiment(subset.df, experiment)
    subset.df = subset(subset.df, subset.df$Experiment %in% experiments)
  }
  
  # Instrument
  if(!is.null(instrument))
  {
    instruments = vascr_find_instrument(subset.df, instrument)
    subset.df = subset(subset.df, subset.df$Instrument %in% instruments)
  }
  
  # Sample (s) (this is second to last as it is highly CPU intensive, and therefore should be imposed on the smallest data set)
  
  if(!is.null(sampleid))
  {
    subset.df = vascr_subset_sampleid(subset.df, sampleid)
  }
  
  
  # Check if there is still some data here, and if not sound a warning
  if(nrow(subset.df)==0)
  {
    warning("No data returned from dataset subset. Check your frequencies, times and units are present in the dataset")
  }
  
  
  subset.df = as_tibble(subset.df)
  
  return(subset.df)
}

#' Sub setting function for sample IDs
#'
#' @param data.df the vascr dataset to subsample
#' @param samplelist the list of ids to test against
#'
#' @return A subset data frame
#' @noRd
#'
#' @examples
#' vascr_subset_sampleid(growth.df, c(3,4))
vascr_subset_sampleid = function (data.df, samplelist){
  
  # First subset the dataset
  subset.df = data.df %>% filter(.data$SampleID %in% samplelist)
  
  id_list = subset.df %>% select("Sample", "SampleID") %>% distinct()
  
  id_list$order = match(id_list$SampleID,samplelist)
  
  id_list = id_list %>% arrange(.data$order)
  
  subset.df = subset.df %>% mutate(Sample = factor(.data$Sample, id_list$Sample))
  
  return(subset.df)
  
}



