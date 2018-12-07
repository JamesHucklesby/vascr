library(ECISR)

#Generate a test dataset

masterdata1.df = ecis_import_long("user/Growth1/Resample.abp", "user/Growth1/Model.csv", "user/Growth1/Samples.csv")
masterdata2.df = ecis_import_long("user/Growth2/Resample.abp", "user/Growth2/Modeled.csv", "user/Growth2/Samples.csv")
masterdata3.df = ecis_import_long("user/Growth3/Resample.abp", "user/Growth3/Modeled.csv", "user/Growth3/Samples.csv")

alldata.df = ecis_combine(masterdata1.df, masterdata2.df, masterdata3.df)

rm(masterdata1.df, masterdata2.df, masterdata3.df)

data.df = subset(alldata.df, (TimeID %% 100) == 1)

data.df$Time = data.df$Time/24
data.df = subset(data.df, Time<6)


normalised.df = ecis_normalise(data.df, 4, divide = FALSE)

ecis_plotvariable(normalised.df, "Rb" , 0)
ecis_plotvariable(alldata.df, "R" , 4000)

ecis_plotspectra(data.df, "R")
ecis_plotmodel(data.df)
ecis_animatefrequency(data.df, "R", 100)


prism.df = ecis_prism(normalised.df, "R", "4000")
write.csv(prism.df, file = "prismtest.csv", row.names = FALSE)


# Generate combined object ------------------------------------------------


fulldata.df = ecis_combine(child1.df, child2.df, child3.df)
fulldata.df = subset(fulldata.df, Time<200)

summarydata.df = ecis_summarise(fulldata.df)

ecis_plot_all(fulldata.df, "Rb", 0)
ecis_plot_experiments(fulldata.df, "R", 4000)
ecis_plot_summary(fulldata.df, "Rb", 0)

normaldata.df = ecis_normalise(fulldata.df, 0, divide = FALSE)
ecis_plot_experiments(normaldata.df, "Rb", 0)
