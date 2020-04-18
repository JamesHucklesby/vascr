#' Detect vehicles in an vascr dataset
#'
#' @param data An vascr dataset
#' @param force_replace Should vehicles be replaced, if they already exist. True replaces the column, false does not. Default FALSE.
#'
#' @return An vascr dataset with an extra IsVehicleControl column
#' 
#' @importFrom stats var
#' 
#' @export
#'
#' @examples
#' # data = xcell
#' # vascr_detect_vehicle(data)
#' 
vascr_detect_vehicle = function (data, force_replace = FALSE)
{
  # Check if vehicle well exists, and we don't have to replace, and if so skip over this function
  if (isFALSE(force_replace) & col_exists(data, "IsVehicleControl"))
  {
    return(data)
  }
  
  # Make sure the data is exploded, if not fix it. Otherwise subsequent functions can't access approprate data
  if(isFALSE(vascr_test_exploded(data)))
     {
       data = vascr_explode(data)
     }
  
  
  # Check if a vehicle has been specified
  if(!col_exists(data, "Vehicle"))
  {
    warning("No well titled 'Vehicle' found in dataset, therefore assuming that all are treatments are in the same vehicle")
    data$Vehicle = "Not Specified"
  }
  
  subsetcols = select(data, vascr_exploded_cols(data))
  subsetcols = select(subsetcols, vascr_cols(subsetcols, "continuous"))
  data$count_na = apply(subsetcols, 1, function(x) sum(x=="NA"))
  
  summary = data %>% group_by(Vehicle) %>% summarise(max = max(count_na))
  
  datasummary = left_join(data, summary, by = "Vehicle")
  datasummary$IsVehicleControl = as.vector(datasummary$count_na == datasummary$max)
  
  if(var(datasummary$count_na)==0)
  {
    warning("No veichle wells detected. Please manually select wells, or ignore this error if a vehicle is not appropriate")
    datasummary$IsVehicleControl = FALSE
  }
  
  datasummary$max = NULL
  datasummary$count_na = NULL
  
  return(datasummary)
  
}

#' Detect the wells R thinks contains vehicles
#' 
#' Convenience function. This first runs vascr_detect_vehicle on the dataset, then provides a summary table of which wells are associated with which vehicle. Provides a usefull check that vehicle detection has been preformed correctly.
#'
#' @param data The datset to search
#' @param force_replace Should existing IsVehicleControl wells be replaced (if present)?
#' 
#' @importFrom dplyr select
#'
#' @return
#' @export
#'
#' @examples
#' #vascr_detect_vehicle_control_wells(data)
#' 
vascr_detect_vehicle_control_wells = function(data, force_replace = FALSE)
{
  # Find vehicle control wells. Function will automatically return the same data if re-generation is not required.
  
    data = vascr_detect_vehicle(data, force_replace)
  
  # Grab only the wells that are vehicle controls
  datasummary = subset(data, IsVehicleControl)
  # Remove wells with no vehicle specified (unused wells, as if all were unspecified they would all have been converted to "Not Specified" during the vehicle detection process)
  datasummary = subset(datasummary, !(Vehicle ==""))
  # Grab the two wells we care about
  datasummary = select(datasummary, c("Well", "Vehicle"))
  # Return unique values
  unique(datasummary)
}


#' Check if a column exists in a dataset
#'
#' @param data The dataset to check
#' @param col The column to check. Should be a character string
#'
#' @return A boolean, true if the column is found, false if not
#'
#' @export
#'
#' @examples
#' col_exists(growth.df, "Vector")
#' col_exists(growth.df, "Unit")
col_exists = function (data, col)
{
  if(col %in% colnames(data))
  {
    return (TRUE)
  }
  else
  {
    return (FALSE)
  }
}
