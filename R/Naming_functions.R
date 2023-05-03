
#' Carry down names in selected columns
#'
#' @param data.df The data frame to carry down columns in
#' @param cols_to_carry The columns to carry down, default is the whole lot
#' @param remove_blank Should blank names (starting with _, 0_ or NA_) be removed
#'
#' @return A data frame with columns carried down
#' @keywords internal
#' 
#' @noRd
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
#' @param remove_blank Should blank ID's be removed
#'
#' @return A data frame
#' @export
#'
#' @examples
#' vascr_full_implode(growth.df)
#' vascr_full_implode(growth.df, c("cells", "Experiment"))
#' 
vascr_full_implode = function(data.df, cols_to_implode = NULL, remove_blank = TRUE)
{
  
  workingdata =  vascr_check_sampleid(data.df)
  
  # workingdata = data.df %>% vascr_sample_subset(c(3:1)) %>%
  #   vascr_subset(unit = "Rb")
  

  if(is.null(cols_to_implode))
  {
    cols_to_implode = colnames(select(workingdata, -Time, -Value, -Sample, -SampleID))
    warning("No cols selected, guessing all")
  }

  
  
  smalldata = workingdata %>% 
    select(all_of(c(cols_to_implode, "Sample", "SampleID"))) %>% 
    distinct() %>%
    arrange(Sample) %>%
    mutate(Sample = NULL)

  carrydown = vascr_carry_down_names(data.df = smalldata, 
                                     cols_to_carry = cols_to_implode,
                                     remove_blank = remove_blank)

  full_implode = carrydown %>% unite("Sample", all_of(cols_to_implode), sep = " + ", na.rm = TRUE) 

  workingdata = workingdata %>% mutate(Sample = NULL)
  
  recombined = workingdata %>% left_join(full_implode, by = "SampleID") %>% 
    mutate(Sample = factor(Sample, unique(Sample)))

  return(recombined)
}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#'@importFrom dplyr summarise_all select distinct all_of everything filter n_distinct
#'@importFrom tidyr pivot_longer
#'
#' @examples
vascr_implode = function(data.df, stripidentical = TRUE, colnames = NULL, 
                         addcols = NULL, dropcols = NULL, fill_blank = "Control",
                         cleanup_sample = FALSE)
{
  
  data.df = data.df %>% arrange(Sample)
  
  colnames = vascr_find_cols(colnames)
  addcols = vascr_find_cols(addcols)
  dropcols = vascr_find_cols(dropcols)
  
  
  data.df = ungroup(data.df)
  
  exploded_cols = vascr_exploded_cols(data.df) 
  
  if(length(exploded_cols)==0)
  {
    data.df = vascr_explode(data.df)
    exploded_cols = vascr_exploded_cols(data.df)
    exploded_cols = subset(exploded_cols, exploded_cols != "NA")
  }
  
  if(is.null(colnames))
  {
  summary = data.df %>% select(all_of(exploded_cols)) %>% distinct() %>% 
       summarise_all(n_distinct) %>% 
       pivot_longer(cols = everything()) %>%
        filter(value>1)
  
  colnames = summary$name
  }
  
  colnames = c(colnames, addcols) %>% unique()
  
  colnames = subset(colnames, !colnames %in% c(dropcols, "NA"))
  
  toreturn = vascr_full_implode(data.df, cols_to_implode = colnames)
  
  toreturn = vascr_sample_replace_match(data.df = toreturn, "", fill_blank)
  
  if(cleanup_sample)
  {
    toreturn = vascr_cleanup_sample(toreturn)
  }
  
  
  toreturn = toreturn %>% mutate(Sample = factor(Sample, unique(Sample)))
  
  return(toreturn)
}



#' Title
#'
#' @param cols 
#'
#' @return
#' @export
#' 
#' @noRd
#'
#' @examples
vascr_find_cols = function(cols)
{
  
  if(is.null(cols))
  {
    return(NULL)
  }
  
  coltable = vascr_col_id(data.df)
  
  output = foreach(currcol = cols) %do%
    {
      if(is.numeric(currcol))
      {
        output = (coltable %>% filter(ColID == currcol))$Variable
      } else
      {
        output = vascr_match(currcol, coltable$Variable)
      }
      
      return (output)
    }
  
  return(unlist(output))
}



#' Title
#'
#' @param data.df 
#'
#' @return
#' 
#' @noRd
#'
#' @examples
vascr_col_id = function(data.df)
{
  expcols = data.df %>% vascr_exploded_cols() %>% data.frame()
  colnames(expcols)[1] = "Variable"
  expcols$ColID = c(1:nrow(expcols))
  
  return(expcols)
}



#' Find which R columns change across the dataset
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
#' @param data.df The data frame to use
#' @param time The time to set to zero
#'
#' @return
#' @export
#'
#' @examples
#' zeroed = growth.df %>% vascr_subset(unit = "R", frequency = "4000") %>%
#'           vascr_zero_time(100)
#'           
#' zeroed %>% vascr_plot_line()
#' 
vascr_zero_time = function(data.df, time = 0)
{
  if(vascr_is_resampled(data.df))
  {
    warning("Data may not be resampled, this may cause issues downstream")
  }
  
  data.df = data.df %>% mutate(Time = Time - time)
  return(data.df)
}





#' Title
#'
#' @param raw_name 
#'
#' @return
#' 
#' @noRd
#'
#' @examples
cleanup_samplename = function(raw_name)
{
  
  raw_name %>%
    str_replace_all("_", " ") %>%
    str_replace_all("\\.", " ")
  
  # raw_sample = "50_nM.tPA + 100_percent.serum + Y_washed"
}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#' @examples
vascr_cleanup_sample = function(data.df)
{
  
  data.df = vascr_check_sampleid(data.df)
  
  small = data.df %>% select(Sample, SampleID) %>%
    distinct () %>%
    arrange(Sample)
    
  small2 = vascr_explode(small)
  small2$SampleID = small$SampleID
  
  small3 = small2 %>% vascr_implode() %>%
  mutate(Sample = cleanup_samplename(Sample)) %>%
  mutate(Sample = factor(Sample, unique(Sample)))
  
  toreturn = data.df %>% select(-Sample) %>%
    left_join(small3, by = "SampleID")
  
  return(toreturn)
}












