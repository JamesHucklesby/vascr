library(ECISR)

#Generate a test dataset
masterdata1.df = ecis_import_long("user/Growth1/Resample.abp", "user/Growth1/Model.csv", "user/Growth1/Samples.csv")
masterdata2.df = ecis_import_long("user/Growth2/Resample.abp", "user/Growth2/Modeled.csv", "user/Growth2/Samples.csv")
masterdata3.df = ecis_import_long("user/Growth3/Resample.abp", "user/Growth3/Modeled.csv", "user/Growth3/Samples.csv")

#Time subsetting code

timetosubset = 100

child1.df = subset(masterdata1.df, (TimeID %% timetosubset) == 1)
child2.df = subset(masterdata2.df, (TimeID %% timetosubset) == 1)
child3.df = subset(masterdata3.df, (TimeID %% timetosubset) == 1)

alldata.df = ecis_combine_mean(child1.df, child2.df, child3.df)
alldata.df$Time = alldata.df$Time/24
alldata.df = subset(alldata.df, Time<6)

normalised1.df = ecis_normalise(child1.df, 150, divide = FALSE)
normalised2.df = ecis_normalise(child2.df, 150, divide = FALSE)
normalised3.df = ecis_normalise(child3.df, 150, divide = FALSE)

normalised.df = ecis_combine_mean(normalised1.df, normalised2.df, normalised3.df)

ecis_plotvariable(normalised.df, "Rb" , 0)
ecis_plotvariable(alldata.df, "R" , 4000)

ecis_plotspectra(alldata.df, "C")
ecis_plotmodel(alldata.df)
ecis_animatefrequency(alldata.df, "R", 100)


prism.df = ecis_prism(alldata.df, "R", "4000")
write.csv(prism.df, file = "prismtest.csv", row.names = FALSE)



# Maximal alignment function ----------------------------------------------

### This still throws out some strange crap, but it's mostly there

data.df = ecis_combine(child1.df, child2.df)

mergeddata.df = ecis_align_max(data.df)

mergeddatacut.df = subset(mergeddata.df, Time>-50)
mergeddatacut.df = subset(mergeddatacut.df, Time<100)

ecis_plot_all(mergeddatacut.df, "R" , 4000)
ecis_plot_summary(mergeddatacut.df, "R", 4000)

normaldata.df = ecis_normalise(mergeddatacut.df,0)
ecis_plot_summary(normaldata.df, "R", 4000)


# Generate combined object ------------------------------------------------


fulldata.df = ecis_combine(child1.df, child2.df, child3.df)
fulldata.df = subset(fulldata.df, Time<200)

summarydata.df = ecis_summarise(fulldata.df)

ecis_plot_all(fulldata.df, "Rb", 0)
ecis_plot_experiments(fulldata.df, "R", 4000)
ecis_plot_summary(fulldata.df, "Rb", 0)

normaldata.df = ecis_normalise(fulldata.df, 100, divide = FALSE)
ecis_plot_experiments(normaldata.df, "Rb", 0)
