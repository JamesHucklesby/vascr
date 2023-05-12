#' #' Export a prism-compatable data set
#' #' 
#' #' This function will automatically average the wells in each experiment, to give a prism-compatable dataset at the experiment level. This allows prism to generate appropriate error bars.
#' #'
#' #' @param data.df ECIS dataframe
#' #' @param filename
#' #' @param select_cols
#' #' @param remove_blank
#' #' @param fill_blank
#' #' @param include_wells
#' #'
#' #' @return A data frame that can be copied and pasted into prism
#' #' 
#' #' @importFrom tidyr spread
#' #' @importFrom tibble as_tibble
#' #' @importFrom dplyr summarise group_by
#' #' @importFrom utils write.csv
#' #' 
#' #' @export
#' #'
#' #' @examples
#' #'  #vascr_prism(data.df)
#' #' #prism = vascr_prism(growth.df, 'Rb', replication = "wells")
#' #' 
#' #' #data.df = vascr_subset(growth.df, unit = "Rb")
#' #' #prism1 = vascr_prism(data.df)
#' #' #data.df = vascr_summarise(data.df, level = "experiments")
#' #' #prism2 = vascr_prism(data.df, select_cols = c("Experiment", "cells"))
#' vascr_prism = function(data.df, filename = NULL, select_cols = NULL, remove_blank = TRUE, fill_blank = "Control", include_wells = FALSE){
#'     
#'     # Cut the data frame down to what can reasonably be represented on one prism table
#' 
#'     imploded = vascr_full_implode(data.df)
#'     imploded$ShortName = vascr_implode(fill_blank = fill_blank)
#'     
#'     imploded$Well = data.df$Well
#'     
#'     # Do the magic bit
#'     duplicate_check = pivot_wider(imploded, names_from = "ShortName", values_from = "Value", id_cols = "Time", values_fn = length)
#'     meanwells = mean(unlist(select(duplicate_check, -Time)))
#'     
#'     if(meanwells>1)
#'     {
#'         returndata = pivot_wider(imploded, names_from = c("Well","ShortName"), values_from = "Value", id_cols = "Time")
#'     }
#'     else
#'     {
#'         returndata = pivot_wider(imploded, names_from = c("ShortName"), values_from = "Value", id_cols = "Time")
#'     }
#' 
#'     if(!is.null(filename))
#'     {
#'         write.csv(returndata, paste(paste(filename,".csv", sep = "")))
#'     }
#'     
#'     return(returndata)
#' }
