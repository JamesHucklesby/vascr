#' Explode out continuous data from Sample
#'
#' @param data Standard ECIS data frame to explode
#'
#' @return The data frame to return
#' @export 
#' 
#' @importFrom stringr str_count str_replace
#' @importFrom tidyr separate pivot_wider
#' @importFrom magrittr "%>%"
#'
#' @examples
#' library(stringr) # Needed to generate the dummy data
#' 
#' data.df = growth.df
#' data.df$Sample = str_replace(data.df$Sample, " ", "_")
#' data.df$Sample = paste(data.df$Sample, "+ 10_nm nothing important")
#' data.df$Sample = paste(data.df$Sample, "+ 4_nm Carpet + ECV_line")
#' processed = ecis_explode(data.df)
ecis_explode = function(data)
{
  
  data$plus = str_count(string = data$Sample, pattern = "[+]")
  maxplus = max(data$plus) + 1
  data$plus = NULL
  maxlist =  c(1:maxplus)
  dumpcols = paste("V",maxlist, sep = "")
  
  data2.df  = separate(data, Sample,into = dumpcols, sep = "[+]", remove = FALSE, fill = "right")
  
  data3.df = data2.df
  
  for(dump in dumpcols)
  {
    data3.df[[dump]] = str_trim(data3.df[[dump]])
    data3.df = separate(data3.df, dump, sep = "[_]", into = c("Val", "Var"), extra = "merge")
    data3.df$Var = trimws(data3.df$Var)
    data3.df$Val = trimws(data3.df$Val)
    
    data3.df$Val = gsub(",","",data3.df$Val)
    
    data3.df = data3.df %>% spread(key = Var, value = Val)
  }
  
  return(data3.df)
  
}



#' Test that the datset is correctly formatted for explosion
#'
#' @param data An ECIS data frame
#' 
#' @importFrom stringr str_count
#'
#' @return A boolean value
#' @export
#'
#' @examples
#' data.df = growth.df
#' data.df$Sample = str_replace(data.df$Sample, " ", "_")
#' data.df$Sample = paste(data.df$Sample, "+ 10_nm nothing important")
#' data.df$Sample = paste(data.df$Sample, "+ 4_nm Carpet + ECV_line")
#' 
#' ecis_test_explosion_integrity(growth.df)
#' 
ecis_test_explosion_integrity = function(data)
{
  data$items = str_count(data$Sample, "[+]") + 1 #Count the number of items = +es, +1
  data$underscore = str_count(data$Sample, "[_]") #Count the number of underscores
  
  allsamplescomplete = all(data$items == data$underscore) # Check all samples have one underscore per item
  allsamplesidentical = sd(data$items)==0 && sd(data$underscore)==0 # Check all samples have a SD of 0, IE all items are identical
  
  return(allsamplescomplete && allsamplesidentical)
  
}


#' Test if an ECIS data frame is exploded
#'
#' @param data the data frame to test
#'
#' @return True (exploded) or false (not exploded)
#' @export
#'
#' @examples
#' ecis_test_exploded(growth.df)
#' imploded = ecis_implode(growth.df)
#' ecis_test_exploded(imploded)
#' 
ecis_test_exploded = function(data)
{
  minidata = data[1,]
  minidataexploded = ecis_explode(minidata)
  return(identical(minidata, minidataexploded))
}


