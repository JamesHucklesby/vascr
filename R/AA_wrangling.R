norun = function()
{

install.packages("devtools")
library(devtools)
install_github("JamesHucklesby/vascr")
library(vascr)


data1 = vascr_import("ECIS", raw = "200225_raw.abp", model ="200225_raw_RbA.csv",  key = "200225_samples.csv", experimentname = "200225")
data1 = subset(data1, data1$Sample != "NA_ng.ml.TGFB.1 + _Vehicle + _Note" )
data1 = vascr_resample(data1,1, 0 ,200)
vascr_plot(data1, unit = "R", frequency = 4000, normtime = 46, level = "wells")

data2 = vascr_import("ECIS", raw = "200120_raw.abp", model ="200120_raw_RbA.csv",  key = "200120_samples.csv", experimentname = "200120")
data2 = subset(data2, data2$Sample != "NA_ng.ml.TGFB.1 + _Vehicle + _Note" )
data2 = vascr_resample(data2,1, 0 ,200)
vascr_plot(data2, unit = "R", frequency = 4000, normtime = 46, level = "wells")


data3 = vascr_import("ECIS", raw = "200114_raw.abp", model ="200114_raw_RbA.csv",  key = "200114_samples.csv", experimentname = "200114")
data3 = subset(data3, data3$Sample != "NA_ng.ml.TGFB.1 + _Vehicle + _Note" )
data3 = vascr_resample(data3,1, 0 ,200)
data3 = vascr_exclude(data3, wells = "E06")
dev = vascr_detect_deviation(data3)
vascr_plot(data3, unit = "R", frequency = 4000, normtime = 46, level = "wells")

# Extra data, not included in this analyasis
data4 = vascr_import("ECIS", raw = "200317_raw.abp", model ="200317_raw_RbA.csv",  key = "200317_samples.csv", experimentname = "200317")
data4 = subset(data4, data4$Sample != "NA_ng.ml.TGFB.1 + _Vehicle + _Note" )
data4 = vascr_resample(data4,1, 0 ,200)
vascr_plot(data3, unit = "R", frequency = 4000, normtime = 46, level = "wells")


save.image()
load(".RData")


mdata = vascr_combine(data1, data2, data3)


mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "R", frequency = 4000, level = "wells")
vascr_plot_line(mini)

mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "Rb", frequency = 0, level = "experiments", normtime = 45)
vascr_plot_line(mini, error = 0)

mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "R", frequency = 4000, level = "summary", normtime = 45)
vascr_plot_line(mini)

ggplotly(vascr_plot_line(mini))

mdata = subset(mdata, mdata$Vehicle == "0.1% BSA")


# ANOVA bit

mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "Rb", frequency = 0, level = "wells")
vascr_plot_line(mini)

ggplotly(vascr_plot_time_vline(data.df = mini, unit = "Rb", frequency = 0, time = 80))


mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "Alpha", frequency = 0, level = "wells")
vascr_plot_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 60)
vascr_plot_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 100)

vascr_summarise_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 60)
vascr_summarise_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 100)

mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "R", frequency = 4000, level = "wells")
vascr_plot_anova(data.df = mini, unit = "R", frequency = 4000, time = 60)
vascr_plot_anova(data.df = mini, unit = "R", frequency = 4000, time = 100)

vascr_summarise_anova(data.df = mini, unit = "R", frequency = 4000, time = 60)
vascr_summarise_anova(data.df = mini, unit = "R", frequency = 4000, time = 100)


mini = vascr_prep_graphdata(mdata, time = c(0,120), unit = "Rb", frequency = 0, level = "wells")
vascr_plot_anova(data.df = mini, unit = "Rb", frequency = 0, time = 60)
vascr_plot_anova(data.df = mini, unit = "Rb", frequency = 0, time = 100)

vascr_summarise_anova(data.df = mini, unit = "Rb", frequency = 0, time = 60)
vascr_summarise_anova(data.df = mini, unit = "Rb", frequency = 0, time = 100)


ang1 = vascr_import("ECIS", raw = "ANG/180604_raw.abp", model = "ANG/180604_modeled.csv", "ANG/180604_samples.csv")
ang1 = subset(ang1, ang1$Sample != "_Treatment + _Concentration" )
ang1 = vascr_resample(ang1, 1)

ang2 = vascr_import("ECIS", raw = "ANG/200225_raw.abp", model = "ANG/200225_modeled.csv", "ANG/200225_samples.csv")
ang2 = subset(ang2, ang2$Sample != "_Treatment + _Concentration" )
ang2 = vascr_resample(ang2, 1)
ang2 = vascr_remove_metadata(ang2)

angcombo = vascr_combine(ang1, ang2)
angcombo = vascr_subset(angcombo, time = c(1,99))
angcombo = vascr_explode(angcombo)

mini = subset(angcombo, angcombo$Treatment %in% c("ANGPTL-4","Vehicle Control"))
mini = vascr_prep_graphdata(mini, unit = "Rb", frequency = 0, time = c(1,100))
ggplotly(vascr_plot_line(mini))


# ANOVA checks
mini = subset(angcombo, angcombo$Treatment %in% c("ANGPTL-4","Vehicle Control"))
mini = vascr_subset(mini, unit = "R", frequency = 4000)
vascr_plot_line(mini)
vascr_plot_anova(data.df = mini, unit = "R", frequency = 4000, time = 60)
vascr_plot_anova(data.df = mini, unit = "R", frequency = 4000, time = 100)

vascr_summarise_anova(data.df = mini, unit = "R", frequency = 4000, time = 60)
vascr_summarise_anova(data.df = mini, unit = "R", frequency = 4000, time = 99)

vascr_plot_line(mini)

mini = subset(angcombo, angcombo$Treatment %in% c("ANGPTL-4","Vehicle Control"))
mini = vascr_subset(mini, unit = "Rb", frequency = 0)
vascr_plot_anova(data.df = mini, unit = "Rb", frequency = 0, time = 60)
vascr_plot_anova(data.df = mini, unit = "Rb", frequency = 0, time = 100)

vascr_summarise_anova(data.df = mini, unit = "Rb", frequency = 0, time = 60)
vascr_summarise_anova(data.df = mini, unit = "Rb", frequency = 0, time = 99)

mini = subset(angcombo, angcombo$Treatment %in% c("ANGPTL-4","Vehicle Control"))
mini = vascr_subset(mini, unit = "Alpha", frequency = 0)
vascr_plot_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 60)
vascr_plot_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 100)

vascr_summarise_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 60)
vascr_summarise_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 99)


# Check the second set

mini = subset(angcombo, angcombo$Treatment %in% c("cANGPTL-4","Vehicle Control"))
mini = vascr_subset(mini, unit = "R", frequency = 4000)
vascr_plot_anova(data.df = mini, unit = "R", frequency = 4000, time = 60)
vascr_plot_anova(data.df = mini, unit = "R", frequency = 4000, time = 100)

vascr_summarise_anova(data.df = mini, unit = "R", frequency = 4000, time = 60)
vascr_summarise_anova(data.df = mini, unit = "R", frequency = 4000, time = 99)

mini = subset(angcombo, angcombo$Treatment %in% c("cANGPTL-4","Vehicle Control"))
mini = vascr_subset(mini, unit = "Rb", frequency = 0)
vascr_plot_anova(data.df = mini, unit = "Rb", frequency = 0, time = 60)
vascr_plot_anova(data.df = mini, unit = "Rb", frequency = 0, time = 100)

vascr_summarise_anova(data.df = mini, unit = "Rb", frequency = 0, time = 60)
vascr_summarise_anova(data.df = mini, unit = "Rb", frequency = 0, time = 99)

mini = subset(angcombo, angcombo$Treatment %in% c("cANGPTL-4","Vehicle Control"))
mini = vascr_subset(mini, unit = "Alpha", frequency = 0)
vascr_plot_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 60)
vascr_plot_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 100)

vascr_summarise_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 60)
vascr_summarise_anova(data.df = mini, unit = "Alpha", frequency = 0, time = 99)

# Cross Correlation Data

mini = vascr_prep_graphdata(mdata, time = c(48,120), unit = "R", frequency = 4000, level = "summary")
vascr_plot_line(mini)

mini = vascr_prep_graphdata(mdata, time = c(48,120), unit = "R", frequency = 4000, level = "wells")
vascr_plot_line(mini)



crosscorr = vascr_subset(mini, unit = "R", frequency = 4000)
corrtable = vascr_summarise_cross_correlation(mini)
vascr_plot_cross_correlation(crosscorr)

vascr_plot_cross_correlation(exp1, reference = "A1")


vascr_find_refwells = function(data.df, sample)
{

referencesampledata = data.df
referencesampledata$sample = vascr_summarise_change(data.df)$sample
referencesampledata = subset(referencesampledata, referencesampledata$Sample ==  " + 0.1% BSA Vehicle + Vehicle Control Note")

return(unique(referencesampledata$sample))
}


vascr_ref_per_exp = function(data.df, sample)
{

refwells = vascr_find_refwells(data.df = data.df, sample = sample)

reflist = data.frame(V1 = c(), V2 = c(), id = c())

for(ref in refwells)
{
  crosscorrchange = vascr_summarise_change(data.df)
  point = vascr_ccf_pairs(crosscorrchange, reference = c(ref))
  reflist = rbind(reflist, point)
}

reflist$id = c(1:nrow(reflist))

data1c = vascr_summarise_cross_correlation(data.df = data.df, manualpairs = reflist)

return(data1c)
}


unique(crosscorr$Experiment)
exp1 = subset(crosscorr, crosscorr$Experiment == "1 : 2 : 200225_raw.abp")
exp2 = subset(crosscorr, crosscorr$Experiment == "2 : 2 : 200120_raw.abp")
exp3 = subset(crosscorr, crosscorr$Experiment == "3 : 2 : 200114_raw.abp")


data1c = vascr_ref_per_exp(data.df = exp1, sample = " + 0.1% BSA Vehicle + Vehicle Control Note")
data2c = vascr_ref_per_exp(exp2, " + 0.1% BSA Vehicle + Vehicle Control Note")
data3c = vascr_ref_per_exp(exp3, " + 0.1% BSA Vehicle + Vehicle Control Note")

data1c$Experiment = 1
data2c$Experiment = 2
data3c$Experiment = 3

datac = rbind(data1c, data2c, data3c)
datac$Experiment = as.character(datac$Experiment)

ggplotly(ggplot(datac, aes(x=coeffs, fill = Experiment)) + geom_histogram() + facet_grid(cols = vars(S1), rows = vars(Experiment)))

ggplotly(ggplot(datac, aes(x=coeffs, fill = S1)) + geom_histogram())
  
# How and where to generate stats from this

t.test(datac)


summary = datac %>% group_by(S1, Experiment) %>% summarise(mean = mean(coeffs))

summary2 = subset(summary, summary$S1 %in% c("[ 0.1% BSA Vehicle | Vehicle Control Note ]", "[ 5 ng.ml.TGFB.1 | 0.1% BSA Vehicle |  Note ]"))

t.test(mean~S1, data = summary2)

p.adjust()



  
}

