
#' Carry down names in selected columns
#'
#' @param data.df The data frame to carry down columns in
#' @param cols_to_carry The columns to carry down, default is the whole lot
#' @param remove_blank Should blank names (starting with _, 0_ or NA_) be removed
#'
#' @return A data frame with columns carried down
#' @keywords internal
#'
#' @examples
#' # Used as part of various import functions
#' 
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




#' Implode multiple columns from a data frame into a single title
#'
#' @param data.df The dataset to implode
#' @param cols_to_implode The columns to implode
#'
#' @returnn A data frame
#' @export
#'
#' @examples
#' vascr_full_implode(growth.df)
#' vascr_full_implode(growth.df, c("cells", "Experiment"))
#' 
vascr_full_implode = function(data.df, cols_to_implode = NULL)
{
  
  if("Sample" %in% colnames(data.df))
  {
  data.df = data.df %>% ungroup() %>% select(-Sample)
  }
  

  if(is.null(cols_to_implode))
  {
    cols_to_implode = colnames(select(data.df, -Time, -Value))
  }
  
  gdata = data.df %>% group_by(all_of(across(cols_to_implode)))
  gdata$ID = group_indices(gdata)
  
  smalldata = gdata %>% select(cols_to_implode, "ID") %>% distinct()

  carrydown = vascr_carry_down_names(data.df = smalldata, cols_to_carry = cols_to_implode)

  full_implode = carrydown %>% unite("Sample", all_of(cols_to_implode), sep = " + ", na.rm = TRUE) 
  
  recombined = gdata %>% left_join(full_implode, by = "ID")%>% mutate(ID = NULL)

  return(recombined)
}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#' @examples
vascr_implode = function(data.df, stripidentical = TRUE)
{
  data.df = ungroup(data.df)
  
  exploded_cols = vascr_exploded_cols(data.df)
  
  data_names = data.df %>% select(all_of(exploded_cols)) %>% mutate(Time = 0, Value = 0) %>% vascr_full_implode()
  
  data.df$Sample = data_names$Sample
  
  return(data.df)
}



#' #' Title
#' #'
#' #' @param data.df 
#' #' @param select_cols 
#' #' @param remove_blank 
#' #' @param fill_blank 
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' vascr_make_name = function(data.df, select_cols = NULL, remove_blank = TRUE, fill_blank = "Control")
#' {
#'   imploded = vascr_full_implode(data.df, cols_to_implode = NULL)
#'   return(imploded)
#' }
vascr_make_name = function(data.df, clean_output = TRUE, fill_blank = "Control")
{
  exploded = vascr_explode(data.df)
  deltacols = exploded %>% select(vascr_exploded_cols(exploded)) %>% vascr_find_changing_cols()
  imploded = vascr_full_implode(exploded, cols_to_implode = deltacols)
  
  imploded = imploded %>% mutate(Sample = ifelse(Sample == "", fill_blank, Sample))
  
  
  if(isTRUE(clean_output))
  {
   imploded = imploded %>% mutate(Sample = str_replace_all(Sample, "\\.", " ")) %>%
      mutate(Sample = str_replace_all(Sample, "_", " "))
  }
  
  # Sort the samples into a sensible numerical order
  samplelist = unique(imploded$Sample)
  sampleorder = str_sort(samplelist, numeric = TRUE)
  imploded$Sample = fct_relevel(imploded$Sample, sampleorder)
  
  return(imploded)
}


#' Find which R columns change accross the dataset
#'
#' @param data.df The dataset to analyse
#' 
#' @keywords internal
#'
#' @return A vector of the column names that change in the dataset
#'
#' @examples
#' # vascr_find_changing_cols(data.df)
vascr_find_changing_cols = function(data.df)
{
  
  # Find column names and create an empty vector to dump sorted cols into
  columns = colnames(data.df)
  uniquecols = c()
  
  # Itterate through each col, and check if it is unique
  for(currentcol in columns)
  {
    uniques = unique(data.df[currentcol])
    
    if(nrow(uniques)>1)
    {
      uniquecols = c(uniquecols, currentcol)
    }
  }
  
  return(uniquecols)
}


#' Create a data frame summarising the changing variables in a dataset in a single column
#'
#' @param data.df The dataset to summarise
#'
#' @return A full dataset
#' 
#' @importFrom dplyr select all_of
#' @importFrom tidyr unite separate
#' 
#' @export
#'
#' @examples
#' data.df = vascr_subset(growth.df, unit = "Rb")
#' data.df = vascr_summarise(data.df, level = "experiments")
#' 
#' dat = vascr_summarise_change(data.df)
vascr_summarise_change = function(data.df, showblank = FALSE)
{
  
  data.df$sample = NULL
  
  datalevel = vascr_detect_level(data.df)
  
  data.df = vascr_remove_stats(data.df)
  
  deltacols = vascr_find_changing_cols(data.df)
  deltacols = vascr_remove_from_vector(c("Time", "Value", "Sample"), deltacols)
  #deltacols = vascr_remove_from_vector(c("Well"), deltacols)
  
  deltadata = select(data.df, all_of(deltacols))
  
  deltadata2 = deltadata
  
  for(col in deltacols)
  {
    deltadata2[[col]] = ifelse(deltadata[[col]]==0 | is.na(deltadata[[col]]) | deltadata[[col]]=="NA","", paste(deltadata[[col]], col, sep ="_"))
  }
  
  deltadata = deltadata2
  
  deltadata = unite(deltadata, deltacols, sep = " | ")
  
  for(cols in deltacols)
  {
    deltadata$deltacols = str_replace(deltadata$deltacols, "^ \\| ", "")
    deltadata$deltacols = str_replace(deltadata$deltacols, " \\| $", "")
    deltadata$deltacols = str_replace(deltadata$deltacols, " \\|  \\| ", " | ")
    
  }
  
  deltadata$deltacols = str_replace_all(deltadata$deltacols, "_", " ")
  deltadata$deltacols = paste("[", deltadata$deltacols, "]")
  deltadata$deltacols = str_replace(deltadata$deltacols, "\\[  \\]", "[ Control ]")
  
  
  if(datalevel == "wells")
  {
    deltadata$well = data.df$Well
  }
  deltadata$value = data.df$Value
  deltadata$time = data.df$Time
  deltadata$sample = deltadata$deltacols
  deltadata$deltacols = NULL
  
  if(col_exists(deltadata, "well"))
  {
    #deltadata$sample = paste (deltadata$well,"+", deltadata$sample)
    deltadata$well = NULL
  }
  
  return(deltadata)
  
}




#' Reconstitute incorrectly formed sample field
#' 
#' Uses string processing to guess what might be in an incorrectly formed string field to try and save things. It is generally better to go back and fix the import file than use this function. Legacy only as this is a very heavy function as it does tonnes of string maniuplations.
#'
#' @param string The string to be converted to a continuous vector
#'
#' @return A CSV separated list of continuous variables
#' 
#' @importFrom stringr str_length str_split
#' @importFrom purrr as_vector
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_reconstitute_sample("1nm cheese + 1nm cars")
#' #vascr_reconstitute_sample("   5,000.939 nM Oranges")
#' #vascr_reconstitute_sample("35,000 cells")
#' 
vascr_reconstitute_sample = function(string)
{
  
  samples = str_split(string, "[+]")
  samples = as_vector(samples)
  
  samplestack = c()
  
  for(sample in samples)
  {
    
    sample = trimws(sample)
    
    string2 = gsub(",", "", sample)     #Remove commas from numbers
    string3 = paste( "#", string2, "#") #Add protective filler so we can strip off end characters later
    string3.5 = gsub("[^0-9.-]", "#", string3) # Replace everything non-numeric with #'s 
    string4 = vascr_collapse_hash(string3.5) # Remove duplicate #'s
    string5 = substr(string4, 2, str_length(string4)-1) # Remove the protective #'s we added earlier
    string6 = gsub("#", ",", string5) # Switch out the # for a , to be standard
    
    title1 = sample # Make a copy of the string
    title1.5 = trimws(title1) # Trim off any leading or trailing white spaces. We can't just strip the lot as some will be in titles and we want to conserve these
    title2 = gsub("[,:_*-]","#",title1.5) # Hash out any deliniators that might be used
    title2.5 = paste( "#", title2, "#", sep = "") # Add protective endplates
    title4 = gsub("[0-9.]", "#", title2.5) # Hash out all numbers, as these are effectivley deliniators
    title4.6 = gsub("# ", "#", title4) # Remove any spaces between hashes, as they delineate nothing
    title4.6 = gsub("# ", "#", title4) # Repeat a few times for completeness
    title4.6 = gsub("# ", "#", title4) # Finish the job hash space job
    title4.7 = gsub(" #", "#", title4.6) # Finish the job hash space job
    title4.7 = gsub(" #", "#", title4.7) # Finish the job hash space job
    title4.7 = gsub(" #", "#", title4.7) # Finish the job hash space job
    title5 = vascr_collapse_hash(title4.7) # Itterativley delete all the hashes
    title6 = substr(title5, 2, str_length(title5)-1) # Remove the protective #'s we added earlier
    title7 = gsub("#", ",", title6) # Switch out the # for a , to be standard
    
    samplestack = c(samplestack, (paste(string6, title7, sep = "_")))
  }
  
  return(paste(samplestack, collapse = " + "))
}

#' Collapse multiple hashes in a string down to a single hash
#'
#' @param string The string to collapse the hashes in
#'
#' @return A string with hashes collapsed
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_collapse_hash("###cat###andthe##hat####")
#' 
#' 
vascr_collapse_hash = function(string)
{
  tempstring = "" # setup a placeholer to keep track of if the optimisation is still doing something
  
  while(!identical(tempstring,string)) # Itterate, removing all duplicate #'s
  {
    tempstring = string
    string = gsub("##", "#", string)
  }
  
  return(string)
  
}

#' Return the exploded cols in a dataset
#'
#' @param data The ECIS dataset with exploded columns
#'
#' @return A vector of the returned columns
#' 
#' @keywords internal
#'
#' @examples
#' #vascr_exploded_cols(growth.df)
#' 
vascr_exploded_cols = function(data)
{
  setdiff(colnames(data), vascr_cols())
}

#' Return the ECIS cols used in this package
#' 
#' Can return either the core set of columns required for an ECIS package, the continous or categorical variables, or the exploded variables. Set will return the lot as a list.
#'
#' @param data The dataset to work off. Only required if non-standard cols are requested
#' @param set The set of columns to request. Default is core.
#'
#' @return A vector of the columns requested
#' 
#' @keywords internal
#'
#' @examples
#' 
#' #vascr_cols()
#' #vascr_cols(growth.df, set = "exploded")
#' #vascr_cols(growth.df, set = "continuous")
#' #vascr_cols(growth.df, set = "categorical")
#' #vascr_cols(growth.df, set = "set")
#' #vascr_cols(growth.df, set = "is_continuous")
#' 
#' 
vascr_cols  = function(data, set = "core")
{
  if(set == "core")
  {
    return(c("Time", "Unit", "Value", "Well", "Sample", "Frequency", "Experiment", "Instrument", "SampleID"))
  }
  
  else if(set == "is_continuous")
  {
    # Apply a check function to all colums
    is.numeric = lapply(data, function(cols) {
      
      #Check if all are numeric or the text "NA". Check numeric by converting everything to a character, stripping comma then trying to turn it into a numeric variable.
      if (isTRUE(suppressWarnings(all(!is.na(as.numeric(gsub(",","",as.character(cols)))) || cols=="NA")))) {
        # Return true or false for each column based on this data
        return(TRUE)
      } else {
        return(FALSE)
      }
    })
    
    # Turn the previously generated vector, and the original names into a data frame
    numeric2= data.frame(colnames(data), unlist(is.numeric))
    names(numeric2) = c("Column", "IsNumeric")
    rownames(numeric2) <- c()
    return(numeric2)
  }
  
  else if(set == "continuous")
  {
    numeric2 = vascr_cols(data, set = "is_continuous")
    
    # Delete everything that is not numeric from the list
    numeric2 = subset(numeric2, numeric2$IsNumeric)
    
    # Then convert the list of remaining names to a vector, which is then returned
    return(as.vector(numeric2$Column))
  }
  
  else if(set == "categorical")
  {
    # Return all the cols that are in the dataset and not continuous
    return(setdiff(colnames(data),vascr_cols(data, set = "continuous")))
  }
  
  else if (set == "exploded")
  {
    # Return the non-core cols
    return(setdiff(colnames(data), vascr_cols()))
  }
  else if (set == "set")
  {
    # Recursivley generate all the required cols. Some will then further use recursion to generate themselves.
    returndata = list(
      core = vascr_cols(data),
      exploded = vascr_cols(data, "exploded"),
      categorical = vascr_cols(data, "categorical"),
      continuous = vascr_cols(data, "continuous")
    )
    return(returndata)
  }
  
  else
  {
    warning("Inappropriate set selected, please use another")
    return(NULL)
  }
  
}



#' Title
#'
#' @param data.df 
#' @param time 
#'
#' @return
#' @export
#'
#' @examples
vascr_zero_time = function(data.df, time = 0)
{
  data.df = data.df %>% mutate(Time = Time - time)
  return(data.df)
}




