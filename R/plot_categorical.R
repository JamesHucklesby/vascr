# Continuous data plotting

# data = growth.df
# data = ecis_explode_continuous(data)
# ecis_plot(data)
# data = ecis_subset(data, unit = "R", frequency = 4000, time = 50)
# ecis_plot(data)
# 
# meanx = ecis_mode(data$Var1)
# 
# ggplot(data, aes(Val1, Value)) +
#  geom_point(aes(color = Experiment))



### Now make the summary graph




#' Find the mode of a categorical variable
#'
#' @param x vector to find mode of
#'
#' @return the most commonly occouring character 
#' @export
#'
#' @examples
#' categorical_mode(c("Cat", "Cat", "Monkey"))
#' 
categorical_mode = function(x){
  
  if(length(unique(x))==1)
  {
   return (unique(x)) 
  }
  
  ta = table(x)
  tam = max(ta)
  if (all(ta == tam))
    mod = NA
  else
    if(is.numeric(x))
      mod = as.numeric(names(ta)[ta == tam])
  else
    mod = names(ta)[ta == tam]
  return(mod)
}
