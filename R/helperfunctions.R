#' Retitle
#' 
#' Recapitulation of the funciton in tidyR, allows the re-titling of a data frame from the top row of a dataset. Used in import funcitons to set titles from the content of ABP files. For internal use only.
#'
#' @param df A data frame containing the desired values in the top row
#'
#' @return A dataframe where the top row has been converted to titles.
#
retitle = function(df){
  
  names(df) = as.character(unlist(df[1,]))
  df = df[-1,]
  df
}


# Summary function --------------------------------------------------------

#' Summarise ECIS datasets from a single experiment
#' 
#' Creates and ECIS dataset that has had all samples of the same type averaged together. Assumes that each sample is independent, IE that this function has already been run on individual experiments
#'
#' @param data.df An ECIS dataset in standard format
#'
#' @return An ECIS dataset supplimented with summary statistics
#' 
#' @export
#'
#' @examples
#' 
#' ecis_summarise(data.df)
#' 
ecis_summarise <- function(data.df){
  
  average.df = summarise(group_by(data.df, Sample, Time, Unit, Frequency),                     
                         sd=sd(Value), n=n(), sem = sd/sqrt(n),Value=mean(Value))

  average.df$Experiment = "Derrivative";
  return (average.df)
  
}



#' Generate matrix containing multiple plots
#' 
#' ECIS often lends itself to generating multi-faceted graphs. This function allows for the tiling of multiple ggplot2 graphs into a single figure. Used extensivley by internal graphics operations.
#' 
#' Imported as a whole from StackOverflow response
#'
#' @param ... A list of ggplot2 objects to plot
#' @param plotlist 
#' @param file 
#' @param cols The number of columns to plot graphs in
#' @param layout 
#'
#' @return
#' @export
#'
#' @examples
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  requireNamespace("grid")
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


# Normalisation function --------------------------------------------------

#' Normalise ECIS data to a single time point
#' 
#' This function normalises each unique experiment/well combination to it's value at the specified time. Contains options to do this either by division or normalisation. Can be run twice if both operations are desired.
#'
#' @param data Standard ECIS Dataframe
#' @param normtime Time to normalise the data to
#' @param divide  If set to true, data will be normalsed via a division. If set to false (default) data will be normalsed by subtraction.
#'
#' @return A standard ECIS dataset with each value normalised
#' 
#' @export
#'
#' @examples
#' 
#' 
ecis_normalise = function(data, normtime, divide = FALSE)
{
  
  x = data$Time
  row = which.min(abs(x - normtime)) 
  
  #Compress the other data points you wish to keep into a chain
  data$TimeID = NULL
  data = tidyr::unite(data, DataCompress, Unit, Well, Frequency, Sample, Experiment)
  norm2.df = tidyr::spread(data, DataCompress, Value)
  
  # Generate a reference data frame, with all rows equal to the reference value (inefficent but easy)
  reference  = norm2.df[row,]
  reference$Time = 1 #Reference time must be set equal to 1 so that the divisions come out equal
  reference = reference[rep(seq_len(nrow(reference)), each=nrow(norm2.df)),]
  
  # run the math
  
  if (divide)
  {
    norm3.df = norm2.df/reference
  } else
  {
    norm3.df = norm2.df -  reference 
  }
  
  #Now reverse the process back to a long data set
  norm3.df = tidyr::gather(norm3.df, DataCompress, Value, -Time)
  norm4.df = tidyr::separate(norm3.df, DataCompress, c("Unit", "Well", "Frequency", "Sample", "Experiment"), sep = "_")

  if(isFALSE(all(is.finite(norm4.df$Value)))){
    warning("NaN values or infinities generated in normalisation. Proceed with caution")
  }
  
  return(norm4.df)
  
  }
