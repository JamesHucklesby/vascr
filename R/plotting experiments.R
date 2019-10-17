# library(ecisr)
# library(data.table)
# 
# data.df = ecisr::growth.df
# ecis_plot(growth.df, unit = "Rb")
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
