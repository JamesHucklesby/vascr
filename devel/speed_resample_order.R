



ad = vascr_import("ECIS", raw = "C:\\Users\\James Hucklesby\\Downloads\\ECIS_250106_MFT_1_96w20idf_250107_Anmol (1).abp", experiment = "E1")

tic()
ad %>% vascr_subset(unit = "R", frequency = "4000") %>% vascr_resample_time(100) %>% vascr_summarise("summary") %>% vascr_plot_line()
toc()

tic()
ad2 = ad %>% vascr_resample_time(100)
toc()

tic()
ad2 %>% vascr_subset(unit = "R", frequency = "4000") %>% vascr_summarise("summary") %>% vascr_plot_line()
toc()