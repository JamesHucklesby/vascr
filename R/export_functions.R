
#' Export a prism-compatable data set
#' 
#' This function will automatically average the wells in each experiment, to give a prism-compatable dataset at the experiment level. This allows prism to generate appropriate error bars.
#'
#' @param data.df ECIS dataframe
#' @param unit Unit of data to export
#' @param frequency Frequency of data requored, modeled data defaults to 0
#' @param replication The level of replicaiton to output. Default is summary of all experiments
#' @param experiment The experiment to export. Default is all experiments
#'
#' @return A data frame that can be copied and pasted into prism
#' 
#' @keywords internal
#' 
#' @importFrom tidyr spread
#' @importFrom tibble as_tibble
#' @importFrom dplyr summarise group_by
#'
#' @examples
#' #vascr_prism(growth.df, 'Rb', replication = "summary")
#' #prism = vascr_prism(growth.df, 'Rb', replication = "wells")
#' 
vascr_prism = function(data.df, unit, frequency = 0, replication = "summary", experiment = "") {
    
    # Cut the data frame down to what can reasonably be represented on one prism table
    
    data.df = vascr_subset(data.df, unit = unit, frequency = frequency, experiment = experiment)
    
    if (replication == "wells")
    {
        warning("Well export is not yet fully supported, use with care")
        data.df = vascr_remove_metadata(data.df)
        data.df$Experiment = data.df$Well
        data.df$Well = NULL
        data.df$Frequency = NULL
        data.df$Unit = NULL
        
    } else {
    data.df = dplyr::summarise(group_by(data.df, Sample, Time, Experiment), Value = mean(Value))
    }

    
    # Get rid of all the variables that are not required in prism
    data.df$n = NULL
    data.df$sd = NULL
    data.df$sem = NULL
    data.df$Unit = NULL
    data.df$Frequency = NULL
    data.df$TimeID = NULL
    
    data.df$Experiment = as.factor(data.df$Experiment)
    data.df$Experiment = as.numeric(data.df$Experiment)
    
    # Generate a vector of expected columns
    
    allcols = expand.grid(unique(data.df$Sample), unique(data.df$Experiment))
    allcols$cols = paste(allcols$Var1, allcols$Var2, sep = "_")
    
    # Generate a row title
    data.df$ExpSam = paste(data.df$Sample, "_", data.df$Experiment, sep = "")
    data.df$Experiment = NULL
    data.df$Sample = NULL
    
    # Do the magic bit
    data.df = tibble::as_tibble(data.df)  #This row just makes tidyR work nicley
    data.df = tidyr::spread(data.df, "ExpSam", "Value")
    
    fncols <- function(data, cname) {
        add <-cname[!cname%in%names(data)]
        
        if(length(add)!=0) data[add] <- NA
        data
    }
    
    data.df = fncols(data.df, allcols$cols)
    
    data.df = data.df %>% 
        select(Time, sort(names(.)))
    
    # Now delete all the bracketed bits
    base::colnames(data.df) = gsub("\\s*\\([^\\)]+\\)", "", as.character(colnames(data.df)))
    
    return(data.df)
}


#' Export files to prism en-masse, and save them in a folder
#' 
#' This will generate a folder full of CSV files that can be imported to prism, should you want to plot the data there.
#'
#' @param data The data frame to export from
#' @param filename The file to export to. If multiple units are selected, this will also be the name of the folder that a file for each unit is saved into.
#' @param units The unit(s) to export. Will accept a string or vector. Stating "all" will export every frequency and unit combination in the dataset.
#' @param frequency The frequency, if needed and exporting a single unit.
#' 
#' @importFrom utils write.csv
#'
#' @return Multiple CSV files, in the best format for GraphPad Prism
#' @export 
#'
#' @examples
#' # Export a massive dataset. Not run as an example because it makes a mess.
#' 
#' # vascr_export_prism(growth.df, "PRISMTEST5", "all")
#' 
vascr_export_prism = function (data, filename, units, frequency = 0)
{
    if(units == "all") # Populate the units and frequencies correctly if all is selected
    {
        units = unique(data$Unit)
        frequencies = unique(data$Frequency)
    }
    
    if (length(units)>1) # Setup the folder if we are doing multiple exports
    {
        oldwd = getwd()
        dir.create(filename)
        setwd(paste(oldwd, filename, sep = "/"))
    }
        
    
    for (unit in units) # Export each unit, frequency pair
    {
        for(frequency in frequencies)
        {
          unitdata = subset(data, Frequency == frequency)
          unitdata = vascr_prism(unitdata, unit = unit, frequency = frequency)
          if (length(unitdata)>2) # skip saving it if no data (modeled units have only one frequency)
          {
          write.csv(unitdata, paste(paste(filename,unit, frequency, sep = "_"),".csv", sep = ""))
          }
        }
    }
    
    setwd(oldwd) # Fix the working directory
}
