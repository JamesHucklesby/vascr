

#' Generate numeric CCF values from vectors
#'
#' @param v1 Vector 1
#' @param v2 Vector 2
#' @param plot Should a plot be generated, default FALSE
#' 
#' @importFrom stats ccf as.ts
#'
#' @keywords internal
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


#' Title
#'
#' @param data.df 
#' @param type 
#'
#' @return
#' @export
#'
#' @examples
# growthrb = vascr_subset(growth.df, unit = "Rb", time = c(5,150))
# deltadata = vascr_summarise_change(growthrb)
# ret = vascr_ccf_pairs(deltadata)
# ret = vascr_ccf_pairs(deltadata, reference = "internal")
# ret = vascr_ccf_pairs(deltadata, reference = "[ 1 : Experiment 1 | 35000 ]")
# ret = vascr_ccf_pairs(deltadata, reference = "[ 1 : Experiment 1 | 25000 ]", comparator = "[ 1 : Experiment 1 | 30000 ]")
vascr_ccf_pairs = function(data.df, reference = NULL, comparator = NULL)
{
    deltadata = data.df
  
    uniquesamples = unique(deltadata$sample)
  
  
    combinations = combn(uniquesamples, 2)
    combinations = t(combinations)
    combinations = as.data.frame(combinations)
    
  if(!is.null(reference))
  {
    
     if(!is.null(comparator))
    {
       ret = separate(combinations, V1 ,into = c("W1", "S1"), sep = " \\+ ", remove = FALSE)
       ret = separate(ret, V2, into = c("W2", "S2"), sep = " \\+ ", remove = FALSE)
       
       uniquesam = unique(c(ret$S1, ret$S2))
       
       foundref = vascr_match(reference, uniquesam)
       foundcom = vascr_match(comparator, uniquesam)
       
       keepvector = ret$S1 == foundref & ret$S2 %in% foundcom | ret$S1 %in% foundcom & ret$S2 == foundref
       
       combinations = subset(combinations, keepvector)
       
     
      } else if(reference == "internal")
      {
        ret = separate(combinations, V1 ,into = c("W1", "S1"), sep = "\\+")
        ret = separate(ret, V2, into = c("W2", "S2"), sep = "\\+")

        combinations = subset(combinations, ret$S1 == ret$S2)
      }else
      {
        foundref = vascr_match(reference, uniquesamples)
        otherref = vascr_remove_from_vector(foundref, uniquesamples)
        
        combinations = data.frame(V1 = otherref)
        combinations$V2 = foundref
      }
    
  }
  
  combinations$id = c(1:nrow(combinations))
  return(combinations)
}

#' Title
#'
#' @param data.df 
#'
#' @return
#' @export
#'
#' @examples
vascr_summarise_available_samples = function(data.df)
{
  dat = vascr_summarise_change(data.df)
  return(unique(dat$sample))
}

#' Generate all cross-correlation pairs between sets of values
#'
#' @param data.df The vascr dataset to summarise
#'
#' @return A dataset contining values from each cross correlation pair
#' 
#' @keywords internal
#' 
#' @importFrom utils combn
#'
#' @examples
# growthrb = vascr_subset(growth.df, unit = "Rb", time = c(5,150))
# corr = vascr_summarise_cross_correlation(growthrb)
# corr = vascr_summarise_cross_correlation(growthrb, reference = "internal")
# corr = vascr_summarise_cross_correlation(vascr_summarise(growthrb, level = "summary"))
# 
# corr = vascr_summarise_cross_correlation(growthrb, reference = "[ 1 : Experiment 1 | 25000 ]", comparator = "[ 1 : Experiment 1 | 30000 ]")
# 
# 
# vascr_summarise_cross_correlation(mini2)
vascr_summarise_cross_correlation = function(data.df, reference = NULL, comparator = NULL, manualpairs = NULL)
{
  
deltadata = vascr_summarise_change(data.df)

if(is.null(manualpairs))
{
combinations = vascr_ccf_pairs(deltadata, reference, comparator)
}else
{
  combinations = manualpairs
}

coeffs =c()

for(current in combinations$id)
{
  row = subset(combinations, combinations$id == current)
  
  s1 = row$V1
  s2 = row$V2
  
  
  t1 = subset(deltadata, deltadata$sample == s1)
  t2 = subset(deltadata, deltadata$sample == s2)
  
  t1 = arrange(t1, time)
  t2 = arrange(t2, time)
  
  if(!isTRUE(all.equal(t1$time, t2$time)))
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
combinations$sample = paste(combinations$V1, combinations$V2, sep = "\n")

combinations$sample = str_replace_all(combinations$sample, "Frequency", "Hz")
combinations$sample = str_replace_all(combinations$sample, "Instrument", "")
combinations$sample = str_replace_all(combinations$sample, "Unit", "")

ret = separate(combinations, V1 ,into = c("W1", "S1"), sep = " \\+ ", remove = FALSE)
ret = separate(ret, V2, into = c("W2", "S2"), sep =  "\\+ ", remove = FALSE)

return(ret)

}

# T Test Code

# reference = "[ 1 : Experiment 1 | 25000 ]"
# comparator = c("[ 1 : Experiment 1 | 30000 ]", "[ 1 : Experiment 1 | 35000 ]")
# 
# corr = vascr_summarise_cross_correlation(growthrb, reference, comparator)
# 
# allvars = c(corr$S1, corr$S2)
# totalvartable = table(allvars)
# totalvars = unique(allvars)
# 
# ttestdata = tibble(pvalue = numeric(), mean= numeric())
# 
# for(comp in comparator)
# {
#    ldata = subset(corr, corr$S1 == comp | corr$S2 == comp)
#    corrvector = ldata$coeffs
#    ttest = t.test(corrvector, mu = 1, alternative = "less")
#    
# }


#' Plot cross correlation data from a vascr dataset
#'
#' @param data.df The dataset to plot
#'
#' @return A plots of the cross correlation calculated
#' 
#' @importFrom magrittr '%>%'
#' @importFrom dplyr group_by mutate arrange left_join
#' @importFrom ggplot2 ggplot aes geom_line geom_col coord_flip scale_colour_manual scale_color_manual scale_fill_manual
#' 
#' @keywords internal
#'
#' @examples
#' # vascr_plot_cross_correlation(growth.df)
#' 
vascr_plot_cross_correlation = function(data.df, reference = NULL, comparator = NULL, manualpairs = NULL, show_index = NULL, plot = "all", order = TRUE)
{
  
deltadata = vascr_summarise_change(data.df)
deltadata$value = replace_na(deltadata$value, 0)
deltadata = deltadata %>% group_by(sample) %>% mutate(value = value/max(value))

combinations = vascr_summarise_cross_correlation(data.df, reference, comparator, manualpairs)

if(isTRUE(order))
{
pcombinations = arrange(combinations, coeffs)
} else
{
  pcombinations = combinations
}


pcombinations = mutate(pcombinations, sample=factor(sample, levels=sample)) 

if(!is.null(show_index))
{
  indexes = data.frame(pcombinations$id, pcombinations$sample, pcombinations$id %in% show_index, pcombinations$coeffs)
  indexes = arrange(indexes, pcombinations.id)
  print(indexes)
  
  pcombinations = subset(pcombinations, pcombinations$id %in% show_index)
}

pcombinations$W1 = NULL
pcombinations$S1 = NULL
pcombinations$W2 = NULL
pcombinations$S2 = NULL

uniquesamples = unique(c(pcombinations$V1, pcombinations$V2))

rainbow = vascr_gg_color_hue(length(uniquesamples))

colourtable = data.frame(sample = uniquesamples, colours  = rainbow)

deltadata$sample = factor(deltadata$sample, levels = colourtable$sample)
pcombinations$V1 = factor(pcombinations$V1, levels = colourtable$sample)
pcombinations$V2 = factor(pcombinations$V2, levels = colourtable$sample)


 lineplot = ggplot(deltadata, aes(x = time, y = value, group = sample)) + geom_line(aes(color = sample))
 barplot = ggplot(pcombinations, aes(x = sample, y = coeffs, color = V1, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + xlab("CCF")

 
 p1 = lineplot + scale_color_manual(values = colourtable$colours)

 p2 = barplot+ scale_fill_manual(values = colourtable$colours,
                                 limits = colourtable$sample,
                                 labels = colourtable$sample, name = "Treatment")+
   scale_colour_manual(values = colourtable$colours,
                       limits = colourtable$sample,
                       labels = colourtable$sample , guide = "none")
 
 p2 = p2 + theme(axis.title.y=element_blank())
 
 if(plot == "all")
 {
 return(vascr_make_panel(p1, p2))
 }
 if(plot == "line")
 {
   return(p1)
 }
 if(plot == "bar")
 {
   return(p2)
 }
 
}


