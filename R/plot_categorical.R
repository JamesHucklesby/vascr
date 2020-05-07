#' Plot a categorical ECIS variable
#'
#' @param data A standard ECIS dataset
#' @param unit The unit to plot
#' @param frequency The frequency to plot
#' @param replication The replication level to plot at
#' @param time The time to run this analyasis at
#' @param error How much error to display
#' @param alphavalue The alpha of the error bars (how clear they are so you can see the overlap)
#' @param xlab Label on the X axis
#' @param ylab  Label on the Y axis
#' @param title The title
#' @param cols The column names to display
#' @param continuous The nominated continuous variable
#' 
#' @importFrom ggplot2 aes labs geom_point geom_line geom_errorbar geom_ribbon
#'
#' @return a ggplot 2 object
#' @export
#'
#' @examples
#' 
#' growth.df$Instrument = "ECIS"
#'
#'vascr_plot_line(growth.df, unit = "R", frequency = 4000, level = "summary")
#'
#'vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "wells", time = 50, error = Inf, priority = c("cells", "Experiment"))
#' vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "experiments", time = 50, priority = c("cells", "Experiment"), error = 1)
#' vascr_plot_continuous(growth.df, unit = "R", frequency = 4000, level = "summary", time = 100, continuous = "cells", error = Inf, priority = c("cells", "Experiment"))
#'
#'
#'data = growth.df
#'
#' 
vascr_plot_continuous = function(data, cols, priority, level, error, ...)
{
  
  # Gather graph data based on the ...
  dots = list(...)
  
  dots[["priority"]] = priority
  dots[["level"]] = level
  dots[["error"]] = error
  
  data = do.call_relevant("vascr_prep_graphdata", data, dots)
  
  if(is.null(xlab))
  {
    xlab = continuous
  }

# Fix that the first variable must be numeric

data[,priority[[1]]] = as.numeric(unlist(data[,priority[[1]]]))

# Plot out individual wells

if(level == "wells")
{
  
plot = ggplot(data, aes_string(priority[[1]], "Value")) +
 geom_point(aes_string(color = priority[[2]]))

plot = do.call_relevant("vascr_polish_plot", plot, dots)

return(plot)

}


# Plot out experimetal wells

if (level == "experiments")
{

plot = ggplot(data, aes_string(x = priority[[1]], y = "Value", ymax = "ymax", ymin = "ymin", fill = priority[[2]], color = priority[[2]])) +
    geom_line()

}

### Now make the summary graphs
if (level == "summary")
{
  plot = ggplot(data, aes_string(x = priority[[1]], y = "Value", ymax = "ymax", ymin = "ymin")) +
    geom_line()
}
 
if (is.infinite(error))
{
plot = plot + geom_ribbon(alpha = 0.1) 
} else if (error>0)
{
  plot = plot+ geom_errorbar()
}

return(plot)

}


#' Title
#'
#' @param data 
#'
#' @return
#' @export
#'
#' @examples
vascr_check_categorical = function(data)
{
  minidata = select(data.df, Sample)
  minidata = unique(minidata)
  minidata_exploded = vascr_explode(minidata)
  return(minidata_exploded)
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
#' @export 
#'
#' @examples
#' 
#' vascr_reconstitute_sample("1nm cheese + 1nm cars")
#' vascr_reconstitute_sample("   5,000.939 nM Oranges")
#' vascr_reconstitute_sample("35,000 cells")
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

#' Title
#'
#' @param string 
#'
#' @return
#' @export
#'
#' @examples
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
#' @export
#'
#' @examples
#' 
#' growth.df$Instrument = "ECIS"
#' vascr_explode(growth.df)
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
#' @export
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
  return(c("Time", "Unit", "Value", "Well", "Sample", "Frequency", "Experiment", "Instrument"))
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



