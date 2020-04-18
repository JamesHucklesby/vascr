

# data = vascr_exclude(data, samples = "10,000 cells")
# 
# my_anova <- aov(Value ~ Sample * Experiment, data = data)
# threeANOVA = Anova(my_anova, type = "III")
# 
# HSD.test(threeANOVA, trt = "Sample")
# 
# plot(res.threeANOVA, 2)
# 
# 
# ## Mucking with different ANOVAS
# 
# data = vascr::growth.df
# data = vascr_subset(data, time = 50, unit = "R", frequency = 4000)
# 
# replicateaverage = data %>%
#   group_by(Sample, Time, Unit, Frequency, Experiment) %>%
#   summarise(sd = sd(Value), n = n(), sem = sd/sqrt(n), Value = mean(Value))
# 
# 
# experimentaverage=
#   replicateaverage %>%
#   group_by(Sample, Time, Unit, Frequency) %>%
#   summarise (sd = sd(Value), n = n(), sem = sd/sqrt(n), Value = mean(Value))
# 
# experimentaverage$Experiment = "Derrivative"
# 
# 
# ANOVAall =aov(data$Value ~ data$Sample * data$Experiment)
# summary(ANOVAall)
# tukeyall = TukeyHSD(ANOVAall)
# anovadataall = as.data.frame(res1.5$'summarydata$Sample')
# 
# 
# ANOVA1.5=aov(Value ~ Sample + Experiment, data = replicateaverage)
# summary(ANOVA1.5)
# res1.5 = TukeyHSD(ANOVA1.5)
# anovadata1.5 = as.data.frame(res1.5$'summarydata$Sample')
# 
# ANOVA2=aov(Value ~ Sample, data = experimentaverage)
# res2 = TukeyHSD(ANOVA2)
# anovadata2 = as.data.frame(res2$'experimentsummary$Sample')
# 
# anovadata1 = setDT(anovadata1, keep.rownames = TRUE)[]
# anovadata1.5 = setDT(anovadata1.5, keep.rownames = TRUE)[]
# anovadata2 =setDT(anovadata2, keep.rownames = TRUE)[]
# 
# allanova = left_join(anovadata1,anovadata1.5, by  = "rn")
# allanova$'p adj.x'- allanova$'p adj.y'
# allanova = left_join(anovadata1.5,anovadata2, by  = "rn")
# allanova$'p adj.x'- allanova$'p adj.y'
# allanova = left_join(anovadata1,anovadata2, by  = "rn")
# allanova$'p adj.x'- allanova$'p adj.y'
# 
# summary(ANOVAall)
# summary(ANOVA1.5)
# summary(ANOVA2)




# library(vascr)
# library(data.table)
# 
# data.df = vascr::growth.df
# vascr_plot(growth.df, unit = "Rb")
# time = 50
# unit = "R"
# frequency = 4000
# confidence = 0.95
# 
# 
# #/// 2nd attempt
# 
# library(ggplot2)
# library(ggpubr)
# 
# averages = data %>% 
#   dplyr::group_by(Experiment, Time, Frequency, Unit, Sample) %>%
#   summarize(Value = mean(Value))
# 
# 
# # Box plots with jittered points
# # :::::::::::::::::::::::::::::::::::::::::::::::::::
# # Change outline colors by groups: dose
# # Use custom color palette
# # Add jitter points and change the shape by groups
# p <- ggboxplot(averages, x = "Sample", y = "Value",
#                color = "Sample", palette =(brewer.pal(8, "Set1")),
#                add = "jitter")
# 
# # Add p-values comparing groups
# # Specify the comparisons you want
# my_comparisons <- list( c("0 cells", "35,000 cells"))
# p + stat_compare_means(comparisons = my_comparisons , label = "p.format", method = "kruskal.test")+ # Add pairwise comparisons p-value
#   stat_compare_means(label.y = 50)                   # Add global p-value
# 
