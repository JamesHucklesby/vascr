#' Explode out continuous data from Sample
#'
#' @param data Standard ECIS data frame to explode
#'
#' @return The data frame to return
#' 
#' 
#' @keywords internal
#' 
#' @importFrom tidyr separate_rows pivot_wider separate pivot_wider
#' @importFrom magrittr "%>%"
#' @importFrom dplyr all_equal
#'
#' @examples
#' # growth.df$Instrument ="ECIS"
#' 
# # Stip out all the non-core columns in the dataset
# # data.df = vascr_remove_metadata(growth.df)
# 
# # Run the explosion to re-generate the non-core columns
# # processed = vascr_explode(data.df)
# 
# # Show that the re-created data is identical to the original dataset
# # all.equal(growth.df, processed)
#' 
vascr_explode = function(data)
{
  # Clean out any existing explosion data to give a clean slate
  df1 = vascr_remove_metadata(data)
  #Separate each condition at each data point into it's own row
  df2 = df1 %>% separate_rows("Sample", sep = " \\+ ")
  # Separate out the numbers and conditions into separate columns
  df3 = separate(df2, "Sample", sep ="_", into = c("num", "col"))
  # # Pivot each individual row wider to make an exploded dataset
  # df3$num = as.numeric(gsub(",","",df3$num))
  df4 = pivot_wider(df3, c("num","col"), names_from = "col", values_from = "num",  id_cols = -c("col", "num"), names_prefix = "")
  
  # Warn if any data is lost in this transfer
  # Pull out the core datasets, then check they're identical
  originalcore = vascr_remove_metadata(data)
  originalcore$Sample = NULL
  newcore = df4
  newcore$Sample = "NA"
  newcore = vascr_remove_metadata(newcore)
  newcore$Sample = NULL
  
  if(!all_equal(originalcore, newcore, ignore_row_order = FALSE, ignore_col_order = FALSE))
     {
       errorCondition("Explosion match failed, check all rows are unique and repeat analyasis")
     }
  
  # Then patch the original samples that we destroyed back on
  df4$Sample = data$Sample
  
  return(df4)
  
}


#' Make a vector containing numbers with commas numeric
#'
#' @param vector The vector to process
#'
#' @return A numeric vector
#' @importFrom tidyr replace_na
#'
#' @keywords internal
#'
#' @examples
vascr_make_numeric = function(vector)
{
  vector = str_remove(vector, ",")
  vector = as.numeric(vector)
  vector = replace_na(vector, 0)
  return(vector)
}


#' Test that the datset is correctly formatted for explosion
#'
#' @param data An ECIS data frame
#' 
#' @importFrom stringr str_count str_replace
#'
#' @return A boolean value
#' 
#' @keywords internal
#'
#' @examples
#' #library(stringr)
#' 
#' #data.df = growth.df
#' #data.df$Sample = str_replace(data.df$Sample, " ", "_")
#' #data.df$Sample = paste(data.df$Sample, "+ 10_nm nothing important")
#' #data.df$Sample = paste(data.df$Sample, "+ 4_nm Carpet + ECV_line")
#' 
#' #vascr_test_explosion_integrity(growth.df)
#' 
vascr_test_explosion_integrity = function(data)
{
  data$items = str_count(data$Sample, "[+]") + 1 #Count the number of items = +es, +1
  data$underscore = str_count(data$Sample, "[_]") #Count the number of underscores
  
  allsamplescomplete = all(data$items == data$underscore) # Check all samples have one underscore per item
  allsamplesidentical = sd(data$items)==0 && sd(data$underscore)==0 # Check all samples have a SD of 0, IE all items are identical
  
  return(allsamplescomplete && allsamplesidentical)
  
}


#' Test if an ECIS data frame is exploded
#' 
#' This function tests to see if exploded columns are present in a dataset. Does not check that all are present, or that they are corrrectly exploded as this would be much slower.
#'
#' @param data the data frame to test
#'
#' @return True (exploded) or false (not exploded)
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_test_exploded(growth.df)
#' #imploded = vascr_implode(growth.df)
#' #vascr_test_exploded(imploded)
#' 
vascr_test_exploded = function(data)
{
 # If exploded cols exist, assume it's exploded
 length(vascr_exploded_cols(data))>1
}


