

#' Title
#'
#' @param data.df 
#' @param cols_to_carry 
#' @param remove_blank 
#'
#' @return
#' @export
#'
#' @examples
vascr_carry_down_names = function(data.df, cols_to_carry = NULL, remove_blank = TRUE)
{
  uniquedata = data.df

  if(is.null(cols_to_carry))
  {
    cols_to_carry = colnames(data.df)
  }

  for(currentcol in cols_to_carry)
  {
    uniquedata[currentcol] = paste(uniquedata[[currentcol]], currentcol, sep = "_", collapse = NULL)
    
    if(remove_blank)
    {
    uniquedata[currentcol] = ifelse(startsWith(as.character(uniquedata[[currentcol]]), "_"), NA, uniquedata[[currentcol]])
    uniquedata[currentcol] = ifelse(startsWith(as.character(uniquedata[[currentcol]]), "0_"), NA, uniquedata[[currentcol]])
    uniquedata[currentcol] = ifelse(startsWith(as.character(uniquedata[[currentcol]]), "NA_"), NA, uniquedata[[currentcol]])
    }
  }

  return(uniquedata)
}




#' Title
#'
#' @param data.df 
#' @param cols_to_implode 
#'
#' @return
#' @export
#'
#' @examples
vascr_full_implode = function(data.df, cols_to_implode = NULL)
{

  stripped = vascr_remove_metadata(data.df)

  if(is.null(cols_to_implode))
  {
    cols_to_implode = colnames(select(data.df, -Time, -Value))
  }
  

  carrydown = vascr_carry_down_names(data.df = stripped, cols_to_carry = cols_to_implode)

  full_implode = carrydown %>% unite("Title", all_of(cols_to_implode), sep = " + ")

  return(full_implode)
}


#' Title
#'
#' @param data.df 
#' @param select_cols 
#' @param remove_blank 
#' @param fill_blank 
#'
#' @return
#' @export
#'
#' @examples
vascr_make_name = function(data.df, select_cols = NULL, remove_blank = TRUE, fill_blank = "Control")
{
  imploded = vascr_full_implode(data.df, cols_to_implode = NULL)
  names = vascr_clean_name(imploded$Title, select_cols = select_cols, remove_blank = remove_blank, fill_blank = fill_blank)
  return(names)
}





#' Title
#'
#' @param name_vector 
#' @param select_cols 
#' @param remove_blank 
#' @param fill_blank 
#' 
#' @importFrom dplyr summarise_all n_distinct
#'
#' @return
#' @export
#'
#' @examples
vascr_clean_name = function(name_vector, select_cols = NULL, remove_blank = TRUE, fill_blank = "Control", include_wells = FALSE)
{

  data_vector = name_vector

  df1 = data.frame(Sample = data_vector, row_number = c(1:length(data_vector)))

  df2 = df1 %>% separate_rows("Sample", sep = " \\+ ")
  # Separate out the numbers and conditions into separate columns
  df3 = separate(df2, "Sample", sep ="_", into = c("num", "col"))

  df3 = subset(df3, !is.na(df3$col))
  # # Pivot each individual row wider to make an exploded dataset
  # df3$num = as.numeric(gsub(",","",df3$num))
  df4 = pivot_wider(df3, names_from = col, values_from = num, id_cols = row_number)

  if(is.null(select_cols))
  {
    uniques = df4 %>% dplyr::summarise_all(n_distinct)
    uniques$row_number = NULL

    uniques = t(uniques)
    colnames(uniques)[1] = "Count"
    uniques = as.data.frame(uniques)
    uniques$Row = rownames(uniques)

    uniques = subset(uniques, uniques$Count != 1)
    select_cols = uniques$Row
  }

  uniquedata = select(df4, all_of(select_cols))
  
  if(isFALSE(include_wells))
  {
    uniquedata = select(uniquedata, -Well)
  }

  uniquedata = vascr_carry_down_names(uniquedata, colnames(uniquedata), remove_blank = remove_blank)

  uniquedata = unite(uniquedata, "Combined", sep = " + ", na.rm = TRUE)
  
  uniquedata$Combined = ifelse(uniquedata$Combined == "", fill_blank, uniquedata$Combined)

  return(uniquedata$Combined)

}
