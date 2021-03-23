# # D3 media testing
# 
# test5 = function()
# {
# 
# library(vascr)
# 
# # Import data
# d3_data_1 = vascr_import(instrument = "ECIS", 
#                          raw = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210203_media_test_1.abp",
#                          model = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210203_media_test_1_RbA.csv",
#                          key = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210203_media_test_1.csv")
# 
# 
# d3_data_1 %>% vascr_subset(unit = "R", frequency = 4000) %>% vascr_plot_matrix()
# 
# d3_data_2 = vascr_import(instrument = "ECIS", 
#                          raw = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210218_media_test_2.abp",
#                          model = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210218_media_test_2_RbA.csv",
#                          key = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210218_media_test_2.csv")
# 
# d3_data_2 = vascr_exclude(d3_data_2, wells = c("F08"))
# 
# d3_data_2 %>% vascr_subset(unit = "R", frequency = 4000) %>% vascr_plot_matrix()
# 
# 
# d3_data_3 = vascr_import(instrument = "ECIS", 
#                          raw = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210223_media_test_3.abp",
#                          model = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210223_media_test_3_RbA.csv",
#                          key = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210223_media_test_3.csv")
# 
# d3_data_3 = vascr_exclude(d3_data_3, wells = c("B04"))
# d3_data_3 = vascr_subset(d3_data_3, time = c(0,120))
# 
# d3_data_3 %>% vascr_subset(unit = "R", frequency = 4000) %>% vascr_plot_matrix()
# 
#   
# d3_master_data = vascr_combine(d3_data_1, d3_data_2, d3_data_3)
# # Exclude experiment 3, cells misbehaving , d3_data_3
# 
# 
# 
# dat1.df = vascr_subset(d3_master_data, unit = "Rb", frequency = "4000",time = c(0,100))
# dat3 = vascr_resample(dat1.df, 1)
# 
# dat3 = vascr_subset(dat3, time = c(0,100))
# 
# 
# datb = vascr_summarise(dat2, "experiments")
# ggplotly(vascr_plot_line(data.df = datb))
# 
# dat3 %>% filter(`F` %in% c(3,4,5)) %>% vascr_summarise("wells") %>% vascr_shorten_name() %>% vascr_plot_line() + ggtitle("Replicates differ") + geom_vline(xintercept = 48)
# 
# 
# dat2 %>% filter(`F` %in% c(1,2,3,4,5)) %>% vascr_summarise("summary") %>% vascr_shorten_name() %>% vascr_plot_line() + ggtitle("EBM formulations") + geom_vline(xintercept = 48)
# 
# dat2 %>% filter(`F` %in% c(6,7)) %>% vascr_summarise("summary") %>% contract_names() %>% vascr_plot_line() + ggtitle("AIM-V formulations")
# 
# dat2 %>% filter(`F` %in% c(8,9,10,11)) %>% vascr_summarise("summary") %>% contract_names() %>% vascr_plot_line() + ggtitle("DMEM formulations")
# 
# dat2 %>% filter(`F` %in% c(11:15)) %>% vascr_summarise("summary") %>% contract_names() %>% vascr_plot_line() + ggtitle("Variations in endothelial supplimentation")
# 
# dat2 %>% filter(`F` %in% c(3,10,7,12)) %>% vascr_summarise("summary") %>% contract_names() %>% vascr_plot_line() + ggtitle("Different basal medias, fully supplimented")
# 
# dat2 %>% filter(`F` %in% c(5,6,11,13)) %>% vascr_summarise("summary") %>% contract_names() %>% vascr_plot_line() + ggtitle("Best unsupplimented formulations")
# 
# dat2 %>% filter(`F` %in% c(5,3,7,11)) %>% vascr_summarise("summary") %>% contract_names() %>% vascr_plot_line() + ggtitle("Different basal medias, fully supplimented")
# 
# 
# 
# vascr_plot_anova(dat2, "R", "4000", 100)
# 
# unique()
# 
# 
# 
# str_sort(vascr_clean_name(unique(dat2$Sample)), numeric = TRUE)
# 
# 
# dat2$Frequency = as.double(dat2$Frequency)
# dat3 = vascr_normalise(dat2, 48, divide = TRUE)
# dat3 = vascr_summarise(dat3, level = "experiments")
# 
# ggplot(dat3, aes(x = Time, y = Value, color = Sample)) + geom_line()
# 
# dat4 = dat3
# dat4$Sample = vascr_clean_name(dat3$Sample)
# 
# ggplot(dat4, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)
# 
# dat5 = subset(dat4, str_count(dat4$Sample, "EBM")>0)
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3) + geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)
# 
# dat5 = subset(dat4, (str_count(dat4$Sample, "AIM-V") + str_count(dat4$Sample,"Serum"))>0)
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)
# 
# dat5 = subset(dat4, (str_count(dat4$Sample, "DMEM") + str_count(dat4$Sample,"Serum"))>0)
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)
# 
# dat5 = subset(dat4, (str_detect(dat4$Sample, c("8_F", "9_F", "10_F", "11_F", "12_F"))))
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)
# 
# dat5 = subset(dat4, (str_count(dat4$Sample, c("4_F", "12_F", "13_F", "14_F", "15_F"))>0))
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)
# 
# dat5 = subset(dat4, str_detect(dat4$Sample, c("12_F|13_F|ITS|11_F|Serum")))
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)
# 
# dat5 = subset(dat4, str_detect(dat4$Sample, c("8_F|9_F|10_F|11_F|12_F|Serum")))
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)
# 
# dat5 = subset(dat4, str_detect(dat4$Sample, c("15_F|2_F|11_F|Serum")))
# ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)
# 
# }
