#################################################################
##  Basic mathematical helper functions
################################################################

# Non-standard framing of basic statistical functions for use in this package

#' Calculate mode of a dataset
#'
#' @param v Vector of numeric data to find the mode of
#'
#' @return The mode of the vector
#' 
#' @keywords internal
#'
#' @examples
#' #getmode(c(1,3,3,4,7))
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#' Find the mode of a categorical variable
#'
#' @param x vector to find mode of
#'
#' @return the most commonly occouring character 
#' 
#' @keywords internal
#'
#' @examples
#' #categorical_mode(c("Cat", "Cat", "Monkey"))
#' 
categorical_mode = function(x){
  
  if(length(unique(x))==1)
  {
    return (unique(x)) 
  }
  
  ta = table(x)
  tam = max(ta)
  if (all(ta == tam))
    mod = NA
  else
    if(is.numeric(x))
      mod = as.numeric(names(ta)[ta == tam])
  else
    mod = names(ta)[ta == tam]
  return(mod)
}


#' Calculate the median well in a set of wells
#' 
#' This function finds the well that is the median of a set. This will be the most spacially central well on a plate. Using median eliminates the risk of well locations clashing, as the returned well will always be one of the set input. This also eliminates the noise associated with single replicates that need to be moved to the edge of a plate for technical reasons, however it will also mask that this movement has happened.
#' 
#' Works for both vertical, horrosontal and diffuse well configurations
#'
#' @param wells A vector of wells to find the median of
#'
#' @return The name of the median well
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_median_well (c("A1", "B2", "C3"))
#' #vascr_median_well(c("A1", "NA", "NA", "NA"))
vascr_median_well = function(wells)
{
  
  # First we create a temporary data frame to hold the transformations. Each well entered is a row
  Well = vascr_standardise_wells(wells)
  Well = as.data.frame(Well)
  
  if(any("NA" %in% Well$Well))
  {
    warning("NA's in averaged wells, these will be removed")
    Well = subset(Well, Well != "NA")
  }
  
  # Explode out rows and columns
  explodedwells = vascr_explode_wells(Well)
  
  # Convert row letters on the plate into numbers for finding the median
  letternums <- letters[1:26]
  explodedwells$lowerrow = casefold(explodedwells$row, upper = FALSE)
  explodedwells$numberrow = match(explodedwells$lowerrow, letternums)
  
  # Check everything is numeric to avoid errors
  explodedwells$numberrow = as.numeric(explodedwells$numberrow)
  explodedwells$numbercol = as.numeric(explodedwells$col)
  
  medianrow = median(explodedwells$numberrow)
  mediancol = median(explodedwells$numbercol)
  
  medianrow = letternums[medianrow]
  
  finalwell = paste(medianrow, mediancol)
  finalwell = vascr_standardise_wells(finalwell)
  
  return(finalwell)
}