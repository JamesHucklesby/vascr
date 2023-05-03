#' Sub setting function for sample IDs
#'
#' @param data.df
#' @param samplelist
#'
#' @return A subset data frame
#' @noRd
#'
#' @examples
vascr_subset_sampleid = function (data.df, samplelist){
  
  # First subset the dataset
  subset.df = data.df %>% subset(SampleID %in% samplelist)
  
  id_list = subset.df %>% select(Sample, SampleID) %>% distinct()
  
  id_list$order = match(id_list$SampleID,samplelist)

  id_list = id_list %>% arrange(order)
  
  subset.df = subset.df %>% mutate(Sample = factor(Sample, id_list$Sample))
  
  return(subset.df)
  
}



#' Output a list of Sample ID and Sample pairs
#'
#' @param data.df Vascr dataset to handle
#'
#' @return A table of samples and thier corresponding pairs
#' @export
#'
#' @examples
#' # growth.df %>% vascr_samples()
vascr_samples = function(data.df)
{
  if(!("SampleID" %in% colnames(data.df)))
  {
    stop("SampleID not assigned")
  }
  
  data.df %>% select(SampleID, Sample) %>% distinct() %>%  arrange(Sample)%>%  return()
}

#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#' @examples
vascr_assign_sampleid  = function(data.df, replaceid = FALSE)
{
  
  samplelist = unique(data.df$Sample)
  
  sampleframe = data.frame(SampleID = c(1:length(samplelist)), Sample = samplelist)
  
  if("SampleID" %in% colnames(data.df))
  {
    data.df = data.df %>% select(-SampleID)
  }
  
  
  combineddata = data.df %>% left_join(sampleframe, by = "Sample")
  
  return(combineddata)
}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#' @examples
vascr_check_sampleid = function(data.df)
{
  
  if("SampleID" %notin% colnames(data.df))
  {
    data.df = vascr_assign_sampleid(data.df)
    warning("No SampleID in input data frame, adding it automatically")
  }
  
  return(data.df)
  
}


#' Title
#'
#' @param data.df 
#' @param target 
#' @param replacement 
#'
#' @return
#' @export
#'
#' @examples
vascr_sample_replace = function(data.df, target, replacement = "")
{
  
  data.df = vascr_check_sampleid(data.df)
  
  levels = data.df %>% ungroup() %>% select(Sample, SampleID) %>% distinct()
  
  newlevels = levels %>% mutate(Sample = as.character(Sample)) %>%
    mutate(Sample = str_replace_all(Sample, target, replacement)) %>%
    mutate(Sample = factor(Sample, unique(Sample)))
  
  output = data.df %>% select(-Sample) %>%
    left_join(newlevels, by = "SampleID")
  
  return(output)
  
}

#' Title
#'
#' @param data.df 
#' @param target 
#' @param replacement 
#' 
#' @importFrom dplyr if_else mutate left_join select ungroup distinct
#'
#' @return
#' @export
#'
#' @examples
vascr_sample_replace_match = function(data.df, target, replacement = "")
{
  
  data.df = vascr_check_sampleid(data.df)
  
  levels = data.df %>% ungroup() %>% select(Sample, SampleID) %>% distinct()
  
  newlevels = levels %>% mutate(Sample = as.character(Sample)) %>%
    mutate(Sample = if_else(Sample == target, replacement, Sample)) %>%
    mutate(Sample = factor(Sample, unique(Sample)))
  
  output = data.df %>% select(-Sample) %>%
    left_join(newlevels, by = "SampleID")
  
  return(output)
  
}



#' Title
#'
#' @param data.df 
#' 
#' @importFrom forcats fct_rev
#' @importFrom ggplot2 ggplot geom_tile geom_text theme scale_colour_brewer scale_fill_brewer
#'
#' @return
#' @export
#'
#' @examples
#' 
#' growth.df %>% vascr_plot_sampleid
#' 
vascr_plot_sampleid = function(data.df)
{
  sample_setup = data.df %>% select(Sample) %>% distinct() %>% vascr_explode() %>% mutate(SampleID = row_number()) %>% select(-Sample) %>% pivot_longer(cols = -SampleID, values_transform = as.character)
  
  ggplot(sample_setup) + geom_tile(aes(x = name, fill = value, y = fct_rev(as.factor(SampleID)))) + 
    geom_text(aes(x = name, label = value, y = fct_rev(as.factor(SampleID)))) + 
    scale_fill_brewer(palette = "Spectral") + xlab("Treatment") + ylab("Sample ID") + 
    theme(axis.text.y = element_text(size=14, face="bold"))
}




#' Title
#'
#' @param plot1 
#' @param ... 
#' 
#' @importFrom ggnewscale new_scale_color
#' @importFrom tidyr replace_na
#' @importFrom data.table as.data.table
#' @importFrom dplyr filter
#'
#' @return
#' @export
#'
#' @examples
vascr_vline = function(plot1, ..., list = NA)
{
  if(is.null(list))
  {
    return(plot1)
  }
  
  if(is.na(list))
  {
  to_plot = list(...)
  }
  else
  {
    to_plot = list
  }
  
  pad3 = function(vector)
  {
    vector = unlist(vector)
    length(vector) = 3
    return(vector)
  }
  
  time_table = data.frame(lapply(to_plot, pad3)) %>% t()
  colnames(time_table) = c("Time", "Name", "Colour")
  time_table = as.data.frame(time_table)
  time_table$Colour = replace_na(time_table$Colour,"black")
  
  maxtime =  max(plot1$data$Time)
  mintime =  min(plot1$data$Time)
  
  time_table = time_table %>% filter(as.numeric(Time)<maxtime) %>% filter(as.numeric(Time)>mintime)
  
  time_table$Event = factor(time_table$Name, unique(time_table$Name))
  
  plot2 = plot1 + ggnewscale::new_scale_color() + 
    geom_vline(data = time_table, aes(xintercept = as.numeric(Time), colour = Event), linetype = 2) 
  
  plot2
  
  return(plot2)
  
}



