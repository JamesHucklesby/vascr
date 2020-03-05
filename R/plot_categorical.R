
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
#' @return a ggplot 2 object
#' @export
#'
#' @examples
#'
#'ecis_plot_continuous(growth.df, "R", 4000, "wells", 50, Inf, continuous = "cells")
#'ecis_plot_continuous(growth.df, "R", 4000, "experiments", 50, continuous = "cells")
#'ecis_plot_continuous(growth.df, "R", 4000, "summary", 50, continuous = "cells", error = Inf)
#'
#' 
ecis_plot_continuous = function(data, unit = "R", frequency = 4000, replication = "summary", time, error = Inf, alphavalue = 0.5, xlab  = NULL, ylab = "Value", title = "", cols, continuous)
{
  
  if(is.null(xlab))
  {
    xlab = continuous
  }

# Plot replicates
  
data = ecis_subset(data, time = time, unit = unit, frequency = frequency)

data$Val1 = data[[continuous]]
data$Val1 = as.numeric(data$Val1)

# Plot out individual wells

if(replication == "wells")
{

plot = ggplot(data, aes(Val1, Value)) +
 geom_point(aes(color = Experiment)) + ggplot2::labs(title = title, x=xlab, y=ylab)

return(ecis_polish_plot(plot))
}


# Plot out experimetal wells

if (replication == "experiments")
{
experiment = ecis_summarise(data, "experiment")
experiment = ecis_explode(experiment)

experiment$Val1 = experiment[[continuous]]
experiment$Val1 = as.numeric(experiment$Val1)


if(error == 0)
{
    plot = ecis_subsample(summary, error)
    plot = ggplot(summary, aes(Val1, Value)) +
      geom_line(aes(color = Experiment)) + ggplot2::labs(title = title, x=xlab, y=ylab)
    
    return(ecis_polish_plot(plot))
}

if (error < Inf)
{
  ecis_subsample(experiment, error)
plot = ggplot(experiment, aes(Val1, Value)) +
  geom_line(aes(color = Experiment)) +
  geom_errorbar(aes(ymin = Value-sem, ymax = Value + sem, color = Experiment)) + ggplot2::labs(title = title, x=xlab, y=ylab)

return(ecis_polish_plot(plot))
}

if (error == Inf)
{
plot = ggplot(experiment, aes(Val1, Value)) +
  geom_line(aes(color = Experiment)) +
  geom_ribbon(aes(ymin = Value-sem, ymax = Value + sem, fill =Experiment), alpha =   alphavalue) + ggplot2::labs(title = title, x=xlab, y=ylab)
}

return(ecis_polish_plot(plot))
}


### Now make the summary graphs
if (replication == "summary")
{
summary = ecis_summarise(data, "summary")
summary = ecis_explode(summary)

summary$Val1 = summary[[continuous]]
summary$Val1 = as.numeric(summary$Val1)

if (error<Inf)
{
  summary = ecis_subsample(summary, error)
plot = ggplot(summary, aes(Val1, Value)) +
  geom_line() +
  geom_errorbar(aes(ymin = Value-sem, ymax = Value+sem)) + ggplot2::labs(title = title, x=xlab, y=ylab)
}

if (error ==0 )
{
  plot = ggplot(summary, aes(Val1, Value)) +
    geom_line() + ggplot2::labs(title = title, x=xlab, y=ylab)
}

if(error == Inf)
{
  plot = ggplot(summary, aes(Val1, Value)) +
    geom_line() +
  geom_ribbon(aes(ymin = Value-sem, ymax = Value + sem), alpha = alphavalue) + ggplot2::labs(title = title, x=xlab, y=ylab)
}

return(ecis_polish_plot(plot))
}

}


ecis_check_categorical = function(data)
{
  minidata = select(data.df, Sample)
  minidata = unique(minidata)
  minidata_exploded = ecis_explode(minidata)
  return(minidata_exploded)
}


#' Reconstitute incorrectly formed sample field
#' 
#' Uses string processing to guess what might be in an incorrectly formed string field to try and save things. It is generally better to go back and fix the import file than use this function. Legacy only.
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
#' ecis_reconstitute_sample("1nm cheese + 1nm cars")
#' ecis_reconstitute_sample("   5,000.939 nM Oranges")
#' ecis_reconstitute_sample("35,000 cells")
#' 
ecis_reconstitute_sample = function(string)
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
  string4 = ecis_collapse_hash(string3.5) # Remove duplicate #'s
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
  title5 = ecis_collapse_hash(title4.7) # Itterativley delete all the hashes
  title6 = substr(title5, 2, str_length(title5)-1) # Remove the protective #'s we added earlier
  title7 = gsub("#", ",", title6) # Switch out the # for a , to be standard
  
  samplestack = c(samplestack, (paste(string6, title7, sep = "_")))
  }
  
  return(paste(samplestack, collapse = " + "))
}

ecis_collapse_hash = function(string)
{
  tempstring = "" # setup a placeholer to keep track of if the optimisation is still doing something
  
  while(!identical(tempstring,string)) # Itterate, removing all duplicate #'s
  {
    tempstring = string
    string = gsub("##", "#", string)
  }
  
  return(string)
  
}


#' Implode a continuous dataset
#' 
#' This function implodes a coninuous dataset to re-create Sample names from only some (or all) of the exploded columns. Provides a better way to subset data for plotting (as it allows for exclusion of values that are always the same) and for the generation of continuous plots. 
#'
#' @param data A standard ECIS data frame
#' @param cols The columns to plot. Default of null plots the whole lot.
#' @param stripidentical Strip out columns that are identical in all samples. Tidies up graphs significantly (at the cost of being less explicit). Default is FALSE as the user must manually specify what has been removed in the graph title, or data is implicity lost. 
#'
#' @return the cleaned up data frame
#' 
#' @importFrom dplyr select
#' @importFrom tidyr unite
#' 
#' @export
#'
#' @examples
#' 
#' # Make a test dataset
#' library(stringr)
#' data.df = growth.df
#' data.df$Sample = str_replace(data.df$Sample, " ", "_")
#' data.df$Sample = paste(data.df$Sample, "+ 10_nm nothing important")
#' data.df$Sample = paste(data.df$Sample, "+ 4_nm Carpet + ECV_line")
#' #exploded = ecis_explode(data.df)
#' 
#' #Check the function
#' #imploded = ecis_implode(exploded, cols = c('cells', 'nm nothing important'))
#' #imploded = ecis_implode(exploded, cols = c('cells', "nm nothing important"), stripidentical = TRUE)
#' 
ecis_implode = function(data, cols = NULL, stripidentical = FALSE)
{
  
  if(is.null(cols))  # If cols is not specified, use the lot
  {
    cols = ecis_exploded_cols(data)
  }
  
  if(length(setdiff(cols, colnames(data)))>0) #If cols have been requested that are not in the dataset, remove them from cols and make a warning
  {
    warning(paste("Excluding columns requested that are not in the dataset:",setdiff(cols, colnames(data))))
    cols = intersect(cols, colnames(data))
    
  }
  
  if(stripidentical) #If we're removing identical columns
  {
    for (col in cols)
    {
      if(length(unique(data[[col]]))==1)
      {
        cols <- cols[!cols %in% col]
      }
    }
  }


miniexploded = select(data, c(ecis_cols(),cols))
miniexploded$Sample = NULL

for(col in cols)
{
  numericcol = NA
  oldw <- getOption("warn")
  options(warn = -1)
  
  numericcol = as.numeric(miniexploded[[col]])
  options(warn = oldw)
  
  if (!(all(is.na(numericcol))))
  {
  miniexploded[[col]] = numericcol
  miniexploded[[col]] = format(miniexploded[[col]],big.mark=",",scientific=FALSE, trim = TRUE)
  }
  
  miniexploded[[col]] = paste(miniexploded[[col]], col, sep ="_")
}

miniexploded$Sample = NULL
miniexploded = unite(miniexploded, Sample, cols, sep = " + ")

miniexploded$Sample = str_remove(miniexploded$Sample, "\\+ _Note")
miniexploded$Sample = str_remove(miniexploded$Sample, "_Note")

return(miniexploded)
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
#' ecis_explode(growth.df)
#' 
ecis_exploded_cols = function(data)
{
  setdiff(colnames(data), ecis_cols())
}

#' Return the ECIS cols used in this package
#'
#' @param set The set of columns to request. Default is core.
#'
#' @return A vector of the columns requested
#' @export
#'
#' @examples
#' 
#' ecis_cols()
#' 
ecis_cols  = function(set = "core")
{
  return(c("Time", "Unit", "Value", "Well", "Sample", "Frequency", "Experiment"))
}



