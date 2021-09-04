#' Title
#'
#' @param data.df 
#' @param samplelist 
#'
#' @return
#' @export
#'
#' @examples
vascr_subset_sampleid = function(data.df, samplelist)
{
  
  ided = data.df %>% select(Sample) %>% distinct() %>% mutate(SampleID = row_number()) %>% right_join(data.df, by = "Sample")
  
  toreturn = ided %>% subset(SampleID %in% samplelist)
  
  return(toreturn)
  
}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#' @examples
vascr_plot_sampleid = function(data.df)
{
  sample_setup = data.df %>% select(Sample) %>% distinct() %>% vascr_explode() %>% mutate(SampleID = row_number()) %>% select(-Sample) %>% pivot_longer(cols = -SampleID, values_transform = as.character)
  
  ggplot(sample_setup) + geom_tile(aes(x = name, fill = value, y = fct_rev(as.factor(SampleID)))) + geom_text(aes(x = name, label = value, y = fct_rev(as.factor(SampleID)))) + scale_fill_brewer(palette = "Spectral") + xlab("Treatment") + ylab("Sample ID") + 
    theme(axis.text.y = element_text(size=14, face="bold"))
}




#' Title
#'
#' @param plot1 
#' @param ... 
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
  
  time_table$Event = time_table$Name
  
  plot2 = plot1 + ggnewscale::new_scale_color() + geom_vline(data = time_table, aes(xintercept = as.numeric(Time), colour = Event), linetype = 2) 
  
  # scale_colour_manual(values = c("blue", "green"))
  # 
  # 
  # find_separate_point(c(1,20))
  # 
  # find_separate_point = function(vector)
  # {
  # alldeg = c(1:360)
  # 
  # min_deg_distance = function(val1, val2)
  # {
  #   dist1 = min(abs(val1 - val2), abs(val2 - val1))
  #   dist2 = 360-dist1
  #   return(min(dist1, dist2))
  # }
  # 
  # 
  # distances = function(val) {unlist(lapply(alldeg,min_deg_distance, val))}
  # 
  # alldist = lapply(vector, distances)
  # 
  # alldist = data.frame(alldist)
  # 
  # rownames(alldist) = NULL
  # 
  # calcn = alldist %>% rowwise() %>% mutate(sum = sum(c_across(1:ncol(alldist))))
  # 
  # degree = which.max(calcn$sum)
  # 
  # return(degree)
  # 
  # }
  
  
  return(plot2)
  
}






