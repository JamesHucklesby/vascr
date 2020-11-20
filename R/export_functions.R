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
#' @export
#'
#' @examples
#' #vascr_prism(data.df = growth.df, unit = 'Rb', replication = "summary")
#' #prism = vascr_prism(growth.df, 'Rb', replication = "wells")
#' 
#' data.df = vascr_subset(growth.df, unit = "Rb")
#' prism1 = vascr_prism(data.df)
#' data.df = vascr_summarise(data.df, level = "experiments")
#' prism2 = vascr_prism(data.df, select_cols = c("Experiment", "cells"))
#' prism3 = vascr_prism(data.df)
vascr_prism = function(data.df, filename = NULL, select_cols = NULL, remove_blank = TRUE, fill_blank = "Control", include_wells = FALSE){
    
    # Cut the data frame down to what can reasonably be represented on one prism table

    imploded = vascr_full_implode(data.df)
    imploded$ShortName = vascr_clean_name(name_vector = imploded$Title, select_cols = select_cols, remove_blank = remove_blank, fill_blank = fill_blank, include_wells = include_wells)
    
    imploded$Well = data.df$Well
    
    # Do the magic bit
    duplicate_check = pivot_wider(imploded, names_from = "ShortName", values_from = "Value", id_cols = "Time", values_fn = length)
    meanwells = mean(unlist(select(duplicate_check, -Time)))
    
    if(meanwells>1)
    {
        returndata = pivot_wider(imploded, names_from = c("Well","ShortName"), values_from = "Value", id_cols = "Time")
    }
    else
    {
        returndata = pivot_wider(imploded, names_from = c("ShortName"), values_from = "Value", id_cols = "Time")
    }

    if(!is.null(filename))
    {
        write.csv(returndata, paste(paste(filename,".csv", sep = "")))
    }
    
    return(returndata)
}

#' Title
#'
#' @param graph 
#' 
#' @importFrom plotly ggplotly
#'
#' @return
#' @export
#'
#' @examples
vascr_ggplotly = function(graph)
{
    ggplotly(graph)
}


#' #' Export files to prism en-masse, and save them in a folder
#' #' 
#' #' This will generate a folder full of CSV files that can be imported to prism, should you want to plot the data there.
#' #'
#' #' @param data The data frame to export from
#' #' @param filename The file to export to. If multiple units are selected, this will also be the name of the folder that a file for each unit is saved into.
#' #' @param units The unit(s) to export. Will accept a string or vector. Stating "all" will export every frequency and unit combination in the dataset.
#' #' @param frequency The frequency, if needed and exporting a single unit.
#' #' 
#' #' @importFrom utils write.csv
#' #'
#' #' @return Multiple CSV files, in the best format for GraphPad Prism
#' #' @export 
#' #'
#' #' @examples
#' #' # Export a massive dataset. Not run as an example because it makes a mess.
#' #' 
#' #' # vascr_export_prism(growth.df, "PRISMTEST5", "all")
#' #' 
#' vascr_export_prism = function (data, filename, units, frequency = 0)
#' {
#'     
#'     if(units == "all") # Populate the units and frequencies correctly if all is selected
#'     {
#'         units = unique(data$Unit)
#'         frequencies = unique(data$Frequency)
#'     }
#'     
#'     if (length(units)>1) # Setup the folder if we are doing multiple exports
#'     {
#'         oldwd = getwd()
#'         dir.create(filename)
#'         setwd(paste(oldwd, filename, sep = "/"))
#'     }
#'         
#'     
#'     for (unit in units) # Export each unit, frequency pair
#'     {
#'         for(frequency in frequencies)
#'         {
#'           unitdata = subset(data, Frequency == frequency)
#'           unitdata = vascr_prism(unitdata, unit = unit, frequency = frequency)
#'           if (length(unitdata)>2) # skip saving it if no data (modeled units have only one frequency)
#'           {
#'           write.csv(unitdata, paste(paste(filename,unit, frequency, sep = "_"),".csv", sep = ""))
#'           }
#'         }
#'     }
#'     
#'     setwd(oldwd) # Fix the working directory
#' }
