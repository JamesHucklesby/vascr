#' Explode out continuous data from Sample
#'
#' @param data Standard ECIS data frame to explode
#'
#' @return The data frame to return
#' 
#' 
#' @importFrom tidyr separate_rows pivot_wider separate pivot_wider
#' @importFrom magrittr "%>%"
#' @importFrom dplyr all_equal row_number
#' 
#' @export
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
vascr_explode = function(data)
{
  # Clean out any existing explosion data to give a clean slate
  df1 = data %>% select(-vascr_exploded_cols(data))
  
  df1$SampleID = NULL
  
  samples = data.frame(Sample = df1$Sample) %>% distinct() %>% mutate(ID = row_number())
  
  #Separate each condition at each data point into it's own row
  df2 = samples %>% separate_rows("Sample", sep = " \\+ ")
  # Separate out the numbers and conditions into separate columns
  df3 = separate(df2, "Sample", sep ="_", into = c("num", "col"))
  # # Pivot each individual row wider to make an exploded dataset
  # df3$num = as.numeric(gsub(",","",df3$num))
  df4 = pivot_wider(df3, names_from = "col", values_from = "num",  id_cols = ID, names_prefix = "")
  df4$SampleID = NULL
  df4$Sample = NULL
  
  df5 = left_join(df4, samples, by = "ID") %>% mutate(ID = NULL)
  
  df6 = left_join(df1, df5, by = "Sample")
  
  return(df6)
  
}


#' Make a vector containing numbers with commas numeric
#'
#' @param vector The vector to process
#'
#' @return A numeric vector
#' @importFrom tidyr replace_na
#'
#' @noRd
#'
#' @examples
vascr_make_numeric = function(vector)
{
  vector = str_remove(vector, ",")
  vector = as.numeric(vector)
  vector = replace_na(vector, 0)
  return(vector)
}


#' Test if an ECIS data frame is exploded
#' 
#' This function tests to see if exploded columns are present in a dataset. Does not check that all are present, or that they are corrrectly exploded as this would be much slower.
#'
#' @param data the data frame to test
#'
#' @return True (exploded) or false (not exploded)
#' 
#' @noRd
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


