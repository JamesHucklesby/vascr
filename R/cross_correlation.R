#' Generate numeric CCF values from vectors
#'
#' @param v1 Vector 1
#' @param v2 Vector 2
#' @param plot Should a plot be generated, default FALSE
#' 
#' @importFrom stats ccf as.ts
#'
#' @return A numeric value representing the CCF at time 0
#' 
#' @examples
vascr_ccf_vectors = function(v1, v2, plot = FALSE)
{
  v1 = as.ts(v1)
  v2 = as.ts(v2)
  corrcoeff = ccf(v1, v2, plot = FALSE)[0]
  corrcoeff = unlist(corrcoeff)["acf"]
  corrcoeff = as.numeric(corrcoeff)
  return(corrcoeff)
}


#' Find which R columns change accross the dataset
#'
#' @param data.df The dataset to analyse
#'
#' @return A vector of the column names that change in the dataset
#'
#' @examples
#' 
#' vascr_find_changing_cols(data.df)
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



#' Create a data frame summarising the changing variables in a dataset
#'
#' @param data.df The dataset to summarise
#'
#' @return A full dataset
#' 
#' @importFrom dplyr select all_of
#' @importFrom tidyr unite
#' 
#'
#' @examples
#' 
vascr_summarise_change = function(data.df)
{

datalevel = vascr_detect_level(data.df)

data.df = vascr_remove_stats(data.df)
data.df = vascr_explode(data.df)
data.df = vascr_implode(data.df)

deltacols = vascr_find_changing_cols(data.df)
deltacols = vascr_remove_from_vector(c("Time", "Value"), deltacols)

if(datalevel != "wells")
{
  deltacols = vascr_remove_from_vector(c("Well"), deltacols)
}

deltadata = select(data.df, all_of(deltacols))

deltadata = unite(deltadata, deltacols, sep = " | ")
deltadata$deltacols = paste("[", deltadata$deltacols, "]")

deltadata$value = data.df$Value
deltadata$time = data.df$Time
deltadata$sample = deltadata$deltacols
deltadata$deltacols = NULL

return(deltadata)

}


#' Generate all cross-correlation pairs between sets of values
#'
#' @param data.df 
#'
#' @return
#' 
#' @importFrom utils combn
#'
#' @examples
#' growthrb = vascr_subset(growth.df, unit = "Rb", time = c(5,150))
#' vascr_plot(growthrb, unit ="Rb")
#' vascr_summarise_cross_correlation(growthrb)
#' 
vascr_summarise_cross_correlation = function(data.df)
{
  
deltadata = vascr_summarise_change(data.df)

uniquesamples = unique(deltadata$sample)
combinations = combn(uniquesamples, 2)
combinations = t(combinations)
combinations = as.data.frame(combinations)
combinations$id = c(1:nrow(combinations))

coeffs =c()

for(current in combinations$id)
{
  row = subset(combinations, combinations$id == current)
  
  s1 = row$V1
  s2 = row$V2
  
  
  t1 = subset(deltadata, deltadata$sample == s1)
  t2 = subset(deltadata, deltadata$sample == s2)
  
  if(!all.equal(t1$time, t2$time))
    {
      warning("Timebases are non identical, please resample or subset and retry")
    }
  
  v1 = t1$value
  v2 = t2$value
  
  if(any(is.na(v1), is.na(v2)))
  {
  warning("NA found in the dataset to generate CCF from, which have been replaced with 0. Please check this is appropriate.")
  v1 = replace_na(v1,0)
  v2 = replace_na(v2,0)
  }
  
 correlation = vascr_ccf_vectors(v1, v2)
 coeffs = c(coeffs, correlation)
}

combinations$coeffs = coeffs
combinations$sample = paste(combinations$V1, combinations$V2)

return(combinations)

}


#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#' 
#' @importFrom magrittr '%>%
#' @importFrom dplyr group_by mutate arrange left_join
#' @importFrom ggplot2 ggplot aes geom_line geom_col coord_flip scale_colour_manual scale_fill_manual
#'
#' @examples
#' 
vascr_plot_cross_correlation = function(data.df, level = NULL)
{
  
deltadata = vascr_summarise_change(data.df)
deltadata = deltadata %>% group_by(sample) %>% mutate(value = value/max(value))

combinations = vascr_summarise_cross_correlation(data.df)
pcombinations = arrange(combinations, coeffs)
pcombinations = mutate(pcombinations, sample=factor(sample, levels=sample)) 

uniquesamples = unique(c(pcombinations$V1, pcombinations$V2))

rainbow = vascr_gg_color_hue(length(uniquesamples))

colourtable = data.frame(samples = uniquesamples, colours  = rainbow)

linecol = data.frame(samples = unique(deltadata$sample))
linecol = left_join(linecol, colourtable, by =c("samples" = "samples"))

V1C = data.frame("sample" = unique(pcombinations$V1))
V1C = left_join(V1C, colourtable, by = c("sample" = "samples"))
V1C = arrange(V1C, sample)

V2C = data.frame("sample" = unique(pcombinations$V2))
V2C = left_join(V2C, colourtable, by = c("sample" = "samples"))
V2C = arrange(V2C, sample)


 lineplot = ggplot(deltadata, aes(x = time, y = value, group = sample)) + geom_line(aes(color = sample))
 barplot = ggplot(pcombinations, aes(x = sample, y = coeffs, color = V1, fill = V2)) + geom_col(size = 2) + coord_flip()

 
 p1 = lineplot + scale_color_manual(values = linecol$colours)
 p2 = barplot + scale_fill_manual(values = V2C$colours) + scale_color_manual(values = V1C$colours)

 
 return(vascr_make_panel(p1, p2))
 
}
 


#' Generate ggplot colour hues, for manually specifiying colours that match the default theme
#'
#' @param n Number of variables to access
#' 
#' @importFrom grDevices hcl
#'
#' @return A vector of ggplot colours
#' 
#' @examples
vascr_gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}


#' Rename a column - cleanup of the built in funciton
#'
#' @param data.df The datset to rename
#' @param old Old column name
#' @param new Replacement column name
#'
#' @return The updated dataset
#'
#' @examples
#' vascr_rename_columns(data.df, "Unit", "Measurement")
#' 
vascr_rename_columns = function(data.df, old, new)
{
  names(data.df)[names(data.df) == old] <- new
  return(data.df)
}


#' Remove an item from a vector
#' 
#' This function cleans up the default R syntax
#'
#' @param values The value(s) to remove
#' @param vector The vector to search and modify
#'
#' @return The modified vector
#'
#' @examples
#' 
#' vector = unique(growth.df$Unit)
#' vector = vascr_remove_from_vector("Rb", vector)
#' 
vascr_remove_from_vector = function(values, vector)
{
  for (value in values)
  {
    vector = vector[!(vector == value)]
  }
  
  return(vector)
}


