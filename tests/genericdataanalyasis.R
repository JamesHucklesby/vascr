library(ECISR)

#Generate a test dataset
masterdata1.df = ecis_import_long("tests/Growth1/Resample.abp", "tests/Growth1/Model.csv", "tests/Growth1/Samples.csv")
masterdata2.df = ecis_import_long("tests/Growth2/Resample.abp", "tests/Growth2/Modeled.csv", "tests/Growth2/Samples.csv")
masterdata3.df = ecis_import_long("tests/Growth3/Resample.abp", "tests/Growth3/Modeled.csv", "tests/Growth3/Samples.csv")

child1.df = subset(masterdata1.df, (TimeID %% 100) == 1)
child2.df = subset(masterdata2.df, (TimeID %% 100) == 1)
child3.df = subset(masterdata3.df, (TimeID %% 100) == 1)

alldata.df = ecis_combine_mean(child1.df, child2.df, child3.df)
alldata.df$Time = alldata.df$Time/24
alldata.df = subset(alldata.df, Time<6)

normalised.df = ecis_normalise(child1.df, 5, divide = TRUE)
ecis_plotvariable(normalised.df, "Rb" , 0)

ecis_plotvariable(child1.df, "Rb" , 0)

ecis_plotvariable(alldata.df, "Rb" , 0)
ecis_plotspectra(alldata.df, "C")
ecis_plotmodel(alldata.df)
ecis_animatefrequency(norm4.df, "R", 100)


prism.df = ecis_prism(alldata.df, "R", "4000")
write.csv(prism.df, file = "prismtest.csv", row.names = FALSE)
