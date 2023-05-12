

#' Generate numeric CCF values from vectors
#'
#' @param v1 Vector 1
#' @param v2 Vector 2
#' @param plot Should a plot be generated, default FALSE
#' 
#' @importFrom stats ccf as.ts
#'
#' @noRd
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
#' 
#' @noRd
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
  
  
    combinations = combn(uniquesamples, 2) %>% t()
    combinations = data.frame(combinations[,1], combinations[,2])
    
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
  
  colnames(combinations) = c("c1", "c2")
  combinations$id = c(1:nrow(combinations))
  return(combinations)
}


#' Generate all cross-correlation pairs between sets of values
#'
#' @param data.df The vascr dataset to summarise
#'
#' @return A dataset contining values from each cross correlation pair
#' 
#' @noRd
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

deltadata = data.df %>%
  vascr_summarise(level = "experiments") %>%
  mutate(sample = Sample, value = Value, time = Time)

if(is.null(manualpairs))
{
combinations = vascr_ccf_pairs(deltadata, reference, comparator)
}else
{
  combinations = manualpairs
}

coeffs =c()
expts = c()
s1s = c()
s2s = c()
ids = c()

experiments  = unique(deltadata$Experiment)

for(expt in experiments)
{

for(current in combinations$id)
{
  row = subset(combinations, combinations$id == current)
  
  s1 = row[[1]]
  s2 = row[[2]]
  
  
  t1 = subset(deltadata, deltadata$sample == s1 & deltadata$Experiment == expt)
  t2 = subset(deltadata, deltadata$sample == s2 & deltadata$Experiment == expt)
  
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
 expts = c(expts, expt)
 s1s = c(s1s, as.character(s1))
 s2s = c(s2s, as.character(s2))
 ids = c(ids, current)
}
}

ret = data.frame(id = ids, s1 = s1s, s2 = s2s, expt = expts, coeff = coeffs)

return(ret)

}


#' Plot cross correlation data from a vascr dataset
#'
#' @param data.df The data set to plot
#' @param reference Reference line to compare against, if not specified all comparasons will be made
#' @param comparator A list of samples to be compared to the reference. If not specified, all will be compared.
#' @param manualpairs A manual list of pairs to be compared
#' 
#'
#' @return A plots of the cross correlation calculated
#' 
#' @importFrom magrittr '%>%'
#' @importFrom dplyr group_by mutate arrange left_join
#' @importFrom ggplot2 ggplot aes geom_line geom_col geom_errorbar coord_flip scale_colour_manual scale_color_manual scale_fill_manual lims
#' @importFrom mdthemes md_theme_gray
#' 
#' @export
#'
#' @examples
#' vascr_plot_cross_correlation(growth.df %>% vascr_subset(unit = "R", frequency = 4000))
#' 
vascr_plot_cross_correlation = function(data.df, reference = NULL, comparator = NULL, manualpairs = NULL)
{
  

combinations = vascr_summarise_cross_correlation(data.df, reference, comparator, manualpairs)


output = combinations %>% group_by(s1, s2) %>%
  summarise(mean = mean(coeff), sem = sd(coeff)/sqrt(n())) %>%
  mutate(s1 = factor(s1, unique(c(s1, s2)))) %>%
  mutate(s2 = factor(s2, unique(c(s1, s2)))) %>%
  mutate(joined = paste("[",s1,"]<br>[", s2,"]", sep = "")) %>%
  ggplot() +
  geom_errorbar(aes(xmin = mean-sem, xmax = mean+sem, y = joined, color = s2), size = 1) +
  geom_point(aes(x = mean, y = joined, color = s1), size = 3) +
  lims (x = c(-1,1)) +
  md_theme_gray()

output


return(output)

 
}


