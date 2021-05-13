# 
# 
# sensitivity_check(tmini)
# 
# sensitivity_check = function(minidf)
# {
#   
# tmini = vascr_summarise_cross_correlation(minidf)
# 
# tmini2 = tmini %>% 
#   mutate(tnf1 = str_count(V1, "TNFa")>1, tnf2 = (str_count(V2, "TNFa")>1), il11 = (str_count(V1, "IL1b")>1), il12 = str_count(V2, "IL1b")>1, tnf = tnf1+tnf2, il1 = il11 + il12, negative = as.numeric(tnf+il1 ==0)) %>%
# filter(tnf<2, il1<2, tnf+il1<2)
# 
# tmini3 = tmini2 %>% group_by(interaction(tnf, il1)) %>% summarise(max(coeffs), min(coeffs))
# 
# tmini4 = tmini2 %>% filter(coeffs>=tmini3[[1,3]])
# 
# #print(sum(tmini4$tnf, tmini4$il1))
# 
# plot(plot(ggplot(tmini2) + geom_point(aes(x = interaction(tnf, il1), y = coeffs))))
# 
# true_positive = sum(tmini2$tnf)
# true_negative = sum(tmini2$negative)
# 
# false_negative = sum(tmini4$tnf)
# false_positive = 0
# 
# # sensitivity
# sensitivity = true_positive / (true_positive + false_negative)
# 
# # specificity
# specificity = true_negative / (true_negative + false_positive)
# 
# print(sensitivity)
# 
# }
# 
# 
# sensitivity_check(tmini)
# 
# sensitivity_check = function(minidf)
# {
#   minidf = mini1 %>% vascr_summarise(level = "experiments")
#   
#   tmini = vascr_summarise_cross_correlation(vascr_explode(minidf))
#   
#   tmini2 = tmini %>% 
#     mutate(tnf1 = str_count(tmini$V1, "TNFa")>=1, tnf2 = (str_count(V2, "TNFa")>=1), il11 = (str_count(V1, "IL1b")>=1), il12 = str_count(V2, "IL1b")>=1, tnf = tnf1+tnf2, il1 = il11 + il12, negative = as.numeric(tnf+il1 ==0)) %>%
#     filter(tnf<2, il1<2, tnf+il1<2)
#   
#   tmini3 = tmini2 %>% group_by(interaction(tnf, il1)) %>% summarise(max(coeffs), min(coeffs))
#   
#   tmini4 = tmini2 %>% filter(coeffs>=tmini3[[1,3]])
#   
#   #print(sum(tmini4$tnf, tmini4$il1))
#   
#   plot(plot(ggplot(tmini2) + geom_point(aes(x = interaction(tnf, il1), y = coeffs))))
#   
#   true_positive = sum(tmini2$tnf)
#   true_negative = sum(tmini2$negative)
#   
#   false_negative = sum(tmini4$tnf)
#   false_positive = 0
#   
#   # sensitivity
#   sensitivity = true_positive / (true_positive + false_negative)
#   
#   # specificity
#   specificity = true_negative / (true_negative + false_positive)
#   
#   print(sensitivity)
#   
# }
# 
