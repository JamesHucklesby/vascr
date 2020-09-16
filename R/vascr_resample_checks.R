#' #' Test that the datset is correctly formatted for explosion
#' #'
#' #' @param data An ECIS data frame
#' #'
#' #' @importFrom stringr str_count str_replace
#' #'
#' #' @return A boolean value
#' #' @export
#' #'
#' #' @examples
#' #' #vascr_test_explosion_integrity(growth.df)
#' #'
#' vascr_test_explosion_integrity = function(data)
#' {
#'   data$items = str_count(data$Sample, "[+]") + 1 #Count the number of items = +es, +1
#'   data$underscore = str_count(data$Sample, "[_]") #Count the number of underscores
#' 
#'   allsamplescomplete = all(data$items == data$underscore) # Check all samples have one underscore per item
#'   allsamplesidentical = sd(data$items)==0 && sd(data$underscore)==0 # Check all samples have a SD of 0, IE all items are identical
#' 
#'   toreturn = allsamplescomplete && allsamplesidentical
#' 
#'   return(toreturn)
#' 
#' }
