#' Implode a continuous dataset
#'
#' This function implodes a coninuous dataset to re-create Sample names from only some (or all) of the exploded columns. Provides a better way to subset data for plotting (as it allows for exclusion of values that are always the same) and for the generation of continuous plots.
#'
#' @param data.df A standard ECIS data frame
#' @param select_columns The columns to plot. Default of null plots the whole lot.
#' @param stripidentical Strip out columns that are identical in all samples. Tidies up graphs significantly (at the cost of being less explicit). Default is FALSE as the user must manually specify what has been removed in the graph title, or data is implicity lost.
#'
#' @return the cleaned up data frame
#'
#' @importFrom dplyr select setdiff intersect na_if
#' @importFrom tidyr unite
#' @importFrom tidyselect all_of
#' @importFrom stringr str_replace_all str_replace
#'
#' @export
#'
#' @examples
#' # Check the function works
#' #imploded = vascr_implode(growth.df)
#' #imploded = vascr_implode(growth.df, stripidentical = TRUE)
#'
#' #exploded = vascr_explode(vascr_remove_metadata(growth.df))
#' #imploded = vascr_implode(exploded)
#' 
#' #data.df = vascr_subset(growth.df, samplecontains = "35,000")
#' #imploded = vascr_implode(data.df)
#' 
#' mindat = vascr_subset(unifiedr, unit = "Rb")
#' 
#' miniexploded = vascr_implode(mindat)
#' miniexploded = mutate(miniexploded, Sample = str_replace_all(Sample, "\\|$", ""))
#' 
#' data.df = rb
#' 
vascr_implode = function(data.df, select_columns = NULL, stripidentical = TRUE, stripzero = TRUE)
{
  if(length(unique(data.df$Sample))==1 & is.null(select_columns))
  {
    warning("Only one sample is present in the dataset, so no implosion was carried out. Specify columns if a particular subset are required")
    return(data.df)
  }
  
  if(is.null(select_columns))  # If cols is not specified, use the lot
  {
    select_columns = vascr_exploded_cols(vascr_remove_stats(data.df))
  }
  
  if(length(setdiff(select_columns, colnames(data.df)))>0) #If cols have been requested that are not in the dataset, remove them from cols and make a warning
  {
    warning(paste("Excluding columns requested that are not in the dataset:",setdiff(select_columns, colnames(data.df))))
    cols = intersect(select_columns, colnames(data.df))
    
  }
  
  if(stripidentical) #If we're removing identical columns, go through and remove them
  {
    for (col in select_columns)
    {
      if(length(unique(data.df[[col]]))==1)
      {
        select_columns <- select_columns[!select_columns %in% col]
      }
    }
  }
  
  
  if(length(select_columns)==0)
  {
    warning("Implosion aborted as no exploded columns change in the dataset")
    return(data.df)
  }
  
  miniexploded = select(data.df, c(all_of(vascr_cols()),all_of(select_columns)))
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
    
    if(stripzero)
    {
      miniexploded[col] = na_if(miniexploded[col], 0)
      miniexploded[col] = na_if(miniexploded[col], "NA")
      miniexploded[[col]] = paste(miniexploded[[col]], col, sep ="_")
      treat= str_count(miniexploded[[col]], "NA")==0
      miniexploded[[col]] = ifelse(treat, miniexploded[[col]], "")
    }else
    {
    miniexploded[[col]] = paste(miniexploded[[col]], col, sep ="_")
    }
  }
  
  miniexploded$Sample = NULL # Check sample is gone so we can re-create it
  miniexploded = unite(miniexploded, Sample, select_columns, sep = "|")
  
  miniexploded = mutate(miniexploded, Sample = str_replace_all(Sample, "\\|\\|", "|"))
  miniexploded = mutate(miniexploded, Sample = str_replace_all(Sample, "\\|$", ""))
  miniexploded = mutate(miniexploded, Sample = str_replace_all(Sample, "$\\|", ""))
  miniexploded = mutate(miniexploded, Sample = str_replace_all(Sample, "\\|", " + "))
  
  
  
  return(miniexploded)
}







