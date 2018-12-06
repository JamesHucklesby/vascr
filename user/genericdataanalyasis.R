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

data.df = fulldata.df

#Find the maximal values for each unit
average.df = dplyr::summarise(dplyr::group_by(data.df, Sample, Unit, Frequency, Experiment),                     
                       max = dplyr::max(Value))
#Push these back down every stack, so that each value now has a maximum value next to it
average2.df = dplyr::left_join(x = average.df, y = data.df, by = c("max" = "Value", "Sample", "Unit", "Frequency", "Experiment"))

#Clean up
average3.df = average2.df

average3.df$sd = NULL
average3.df$n = NULL
average3.df$sem = NULL
average3.df = rename(average3.df, Max_Time = Time)

#Reassemble time

mergeddata.df = left_join(data.df, average3.df, by = c("Sample", "Experiment", "Frequency", "Unit"))


mergeddata.df$Time = mergeddata.df$Time  - mergeddata.df$Max_Time


mergeddatacut.df = subset(mergeddata.df, Time<100)
mergeddatacut.df = subset(mergeddatacut.df, Time>-50)

ecis_plot_experiments(mergeddatacut.df, "Rb" , 0)


# Generate combined object ------------------------------------------------


fulldata.df = ecis_combine(child1.df, child2.df, child3.df)
fulldata.df = subset(fulldata.df, Time<200)


ecis_plot_all(fulldata.df, "Rb", 0)
ecis_plot_experiments(fulldata.df, "R", 4000)
ecis_plot_summary(fulldata.df, "Rb", 0)

