###############################################################
# This file is excluded from the package, so can be used as a sandbox
###############################################################


playarea = function ()
{
  
  # Maximal response frequency selection  
  data.df = ecisr::growth.df
  time = 100
  
  small.df = ecis_subset(data.df, frequency = "raw", time = time)
  
  r.df = ecis_subset (small.df, unit = "R")
  hist (r.df$Value)
  
  r.df$Frequency = as.factor(r.df$Frequency)
  fit <- lm(Value ~ Frequency + Sample, data = r.df)
  print(anova(fit))
  
  fit <- aov(Value ~ Frequency + Sample, data = r.df)
  tukey = TukeyHSD(fit)
  
  # Is it stable?
  
  
  stablebit = ecis_subset()
  
  
}