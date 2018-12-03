retitle = function(df){
  
  names(df) = as.character(unlist(df[1,]))
  df = df[-1,]
  df
}


# Summary function --------------------------------------------------------

ecis_summarise <- function(data.df){
  
  average.df = summarise(group_by(data.df, Sample, Time, Unit, Frequency, TimeID),                     
                         sd=sd(Value), n=n(), sem = sd/sqrt(n),Value=mean(Value))

  return (average.df)
  
}


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
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

ecis_normalise = function(data, normtime, divide = FALSE)
{
  
  x = data$Time
  row = which.min(abs(x - normtime)) 
  
  #Compress the other data points you wish to keep into a chain
  data$TimeID = NULL
  data = unite(data, DataCompress, Unit, Well, Frequency, Sample)
  norm2.df = spread(data, DataCompress, Value)
  
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
  norm3.df = gather(norm3.df, DataCompress, Value, -Time)
  norm4.df = separate(norm3.df, DataCompress, c("Unit", "Well", "Frequency", "Sample"), sep = "_")
}
