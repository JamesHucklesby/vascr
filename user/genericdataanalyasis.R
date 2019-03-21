library(ECISR)

#Import three replicate experiments, with thier plate maps

masterdata1.df = ecis_import_long("user/Growth1/Resample.abp", "user/Growth1/Model.csv", "user/Growth1/Samples.csv")
masterdata2.df = ecis_import_long("user/Growth2/Resample.abp", "user/Growth2/Modeled.csv", "user/Growth2/Samples.csv")
masterdata3.df = ecis_import_long("user/Growth3/Resample.abp", "user/Growth3/Modeled.csv", "user/Growth3/Samples.csv")

#Combine the three experiments and clear the imported files to save RAM

alldata.df = ecis_combine(masterdata1.df, masterdata2.df, masterdata3.df)
rm(masterdata1.df, masterdata2.df, masterdata3.df)

# Subset the data to a sensible frequency
data.df = ecis_subset(alldata.df,100)

# Convert hours to days
data.df$Time = data.df$Time/24
alldata.df$Time = alldata.df$Time/24

# Reduce dataset down to the region of interest
data.df = subset(data.df, Time<7)
alldata.df = subset(alldata.df, Time<7)

# Start plotting out the datasets
ecis_plot_all(alldata.df, "R", 4000)
ecis_plot_experiments(alldata.df, "R", 4000)
ecis_plot_experiments(alldata.df, "Rb", 0)

ecis_plot_summary(data.df, "Rb", 0)

# Run the mathematics to generate a normalised dataset
normalised.df = ecis_normalise(data.df, 4, divide = FALSE)


ecis_plot_summary(normalised.df, "R" , 4000)
ecis_plot_summary(data.df, "R" , 4000)

ecis_plotmodel(normalised.df)

ecis_plotspectra(data.df, "R")
ecis_plotmodel(data.df)
ecis_animatefrequency(data.df, "R", 100)

# Export the R4000 data for Prism so it can be plotted as a derrivative
prism.df = ecis_prism(data.df, "R", "4000")
write.csv(prism.df, file = "prismtest.csv", row.names = FALSE)

#Align maxima to have a look at max and relative maximal Rb's
aligned.df = ecis_align_key(data.df, "max", 5)

ecis_plot_all(aligned.df, "Rb", 0)
ecis_plot_experiments(aligned.df, "Rb", 0)
ecis_plot_summary(aligned.df, "Rb", 0)


saveRDS(alldata.df, file = "sampledata.rds")

ecis_plot_summary_timeslice(aligned.df, "Rb", 0)
ecis_plot_experiments_timeslice(aligned.df, "Rb", 0)
ecis_plot_experiments_timeslice(aligned.df, "Rb", 0)


graphlet = ecis_plot_all(data.df, "Rb", 0)
graphlet + geom_vline(xintercept=2)





