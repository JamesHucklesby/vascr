# D3 media testing

test5 = function()
{

library(vascr)

d3_raw = choose.files()
d3_model = choose.files()
d3_plate = choose.files()

# Import data
d3_data_1 = vascr_import(instrument = "ECIS", 
                         raw = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210203_media_test_1.abp",
                         model = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210203_media_test_1_RbA.csv",
                         key = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210203_media_test_1.csv")


mini = vascr_subset(d3_data_1, unit = "R", frequency = 4000)
vascr_plot_structure(data = mini)
vascr_plot_matrix(data = mini)

d3_data_2 = vascr_import(instrument = "ECIS", 
                         raw = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210218_media_test_2.abp",
                         model = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210218_media_test_2_RbA.csv",
                         key = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210218_media_test_2.csv")

d3_data_3 = vascr_import(instrument = "ECIS", 
                         raw = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210223_media_test_3.abp",
                         model = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210223_media_test_3_RbA.csv",
                         key = "C:\\Users\\jhuc964\\Desktop\\D3 media screening\\210223_media_test_3.csv")

d3_master_data = vascr_combine(d3_data_1, d3_data_2, d3_data_3)




dat1.df = vascr_subset(d3_master_data, unit = "R", frequency = "4000")
dat2 = vascr_resample(dat1.df, 1)

datb = vascr_summarise(dat2, "summary")
vascr_plot_line(data.df = datb)
vascr_plot_anova(dat2, "R", "4000", 100)


dat2$Frequency = as.double(dat2$Frequency)
dat3 = vascr_normalise(dat2, 48, divide = TRUE)
dat3 = vascr_summarise(dat3, level = "experiments")

ggplot(dat3, aes(x = Time, y = Value, color = Sample)) + geom_line()

dat4 = dat3
dat4$Sample = vascr_clean_name(dat3$Sample)

ggplot(dat4, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)

dat5 = subset(dat4, str_count(dat4$Sample, "EBM")>0)
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3) + geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)

dat5 = subset(dat4, (str_count(dat4$Sample, "AIM-V") + str_count(dat4$Sample,"Serum"))>0)
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)

dat5 = subset(dat4, (str_count(dat4$Sample, "DMEM") + str_count(dat4$Sample,"Serum"))>0)
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)

dat5 = subset(dat4, (str_detect(dat4$Sample, c("8_F", "9_F", "10_F", "11_F", "12_F"))))
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)

dat5 = subset(dat4, (str_count(dat4$Sample, c("4_F", "12_F", "13_F", "14_F", "15_F"))>0))
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)

dat5 = subset(dat4, str_detect(dat4$Sample, c("12_F|13_F|ITS|11_F|Serum")))
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)

dat5 = subset(dat4, str_detect(dat4$Sample, c("8_F|9_F|10_F|11_F|12_F|Serum")))
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)

dat5 = subset(dat4, str_detect(dat4$Sample, c("15_F|2_F|11_F|Serum")))
ggplot(dat5, aes(x = Time, y = Value, color = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3)+ geom_hline(yintercept = 0.8, color = "blue", linetype = 3, size = 1) + geom_vline(xintercept = 96, color = "blue", linetype = 3, size = 1)

}
