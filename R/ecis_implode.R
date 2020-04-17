#' Implode a continuous dataset
#'
#' This function implodes a coninuous dataset to re-create Sample names from only some (or all) of the exploded columns. Provides a better way to subset data for plotting (as it allows for exclusion of values that are always the same) and for the generation of continuous plots.
#'
#' @param data A standard ECIS data frame
#' @param select_columns The columns to plot. Default of null plots the whole lot.
#' @param stripidentical Strip out columns that are identical in all samples. Tidies up graphs significantly (at the cost of being less explicit). Default is FALSE as the user must manually specify what has been removed in the graph title, or data is implicity lost.
#'
#' @return the cleaned up data frame
#'
#' @importFrom dplyr select setdiff intersect
#' @importFrom tidyr unite
#'
#' @export
#'
#' @examples
#' # Check the function works
#' imploded = ecis_implode(growth.df)
#' imploded = ecis_implode(growth.df, stripidentical = TRUE)
#'
#' exploded = ecis_explode(ecis_remove_metadata(growth.df))
#' imploded = ecis_implode(exploded)
#' 
#' data = ecis_subset(growth.df, samplecontains = "35,000")
#' imploded = ecis_implode(data)

ecis_implode = function(data, select_columns = NULL, stripidentical = FALSE)
{
  if(length(unique(data$Sample))==1 & is.null(select_columns))
  {
    warning("Only one sample is present in the dataset, so no implosion was carried out. Specify columns if a particular subset are required")
    return(data)
  }
  
  if(is.null(select_columns))  # If cols is not specified, use the lot
  {
    select_columns = ecis_exploded_cols(data)
  }
  
  if(length(setdiff(select_columns, colnames(data)))>0) #If cols have been requested that are not in the dataset, remove them from cols and make a warning
  {
    warning(paste("Excluding columns requested that are not in the dataset:",setdiff(select_columns, colnames(data))))
    cols = intersect(select_columns, colnames(data))
    
  }
  
  if(stripidentical) #If we're removing identical columns, go through and remove them
  {
    for (col in select_columns)
    {
      if(length(unique(data[[col]]))==1)
      {
        select_columns <- select_columns[!select_columns %in% col]
      }
    }
  }
  
  
  miniexploded = select(data, c(all_of(ecis_cols()),select_columns))
  miniexploded$Sample = NULL # If present, Remove sample from what will become the output, as we're going to rebuild it.
  
  # Now we go through, format and copy out all the columns into the new data frame
  
  for(col in select_columns)
  {
    
    # Generate a column with only numeric data. Errors are suppressed as non-numeric things will be     converted to NA, which is what we want here
    
    numericcol = suppressWarnings(as.numeric(miniexploded[[col]]))
    
    # If everything is numeric, add the commas before converting to text
    if (!(all(is.na(numericcol))))
    {
      miniexploded[[col]] = format(miniexploded[[col]],big.mark=",",scientific=FALSE, trim = TRUE)
    }
    
    # Add the name of each column to the end of each cell, so they are labeled when pasted together
    miniexploded[[col]] = paste(miniexploded[[col]], col, sep ="_")
  }
  
  miniexploded$Sample = NULL # Check sample is gone so we can re-create it
  miniexploded = unite(miniexploded, Sample, select_columns, sep = " + ")
  
  return(miniexploded)
}
