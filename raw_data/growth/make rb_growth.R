

rbgrowth.df = growth.df %>% vascr_subset(unit = "Rb")
save(rbgrowth.df, file = "C:\\Users\\jhuc964\\OneDrive - The University of Auckland\\Desktop\\vascr2\\data\\rbgrowth.df.rda")


raw1 = ecis_import("C:\\Users\\jhuc964\\OneDrive - The University of Auckland\\Desktop\\vascr2\\raw_data\\growth\\growth1_raw.abp")
raw2 = ecis_import("C:\\Users\\jhuc964\\OneDrive - The University of Auckland\\Desktop\\vascr2\\raw_data\\growth\\growth2_raw.abp")
raw3 = ecis_import("C:\\Users\\jhuc964\\OneDrive - The University of Auckland\\Desktop\\vascr2\\raw_data\\growth\\growth3_raw.abp")

rawall = vascr_combine(raw1, raw2, raw3)

growth_unresampled.df = rawall %>% vascr_subset(time = c(1,100)) %>%
  vascr_subset(unit = c("R","C"), frequency = c(1000, 4000, 8000), well = c("A1", "A2", "A3", "A4", "A5", "A6")) %>%
  mutate(Sample = Well) %>%
  mutate(SampleID = as.numeric(as.factor(Well)))

vascr_subset(growth_unresampled.df, unit = "R", frequency = 4000) %>%
  vascr_plot_line()

save(growth_unresampled.df, file = "C:\\Users\\jhuc964\\OneDrive - The University of Auckland\\Desktop\\vascr2\\data\\growth_unresampled.df.rda")
