# ###Statistics proofs###
# 
# 
# # Prove that AOV works the same way if based on a linear model or not
# 
# 
# data = ecisr::growth.df
# data = ecis_subset(data, time = 50, unit = "R", frequency = 4000)
# 
# model=lm(data$Value ~ data$Experiment + data$Sample)
# ANOVA=aov(model)
# 
# ANOVA1=aov(data$Value ~ data$Experiment + data$Sample)
# 
# summary(ANOVA)
# summary(ANOVA1)
# 
# 
