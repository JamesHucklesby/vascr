choose.dir()

setwd("\\\\files.auckland.ac.nz\\myhome\\11) Impedance instruments compared\\Impedance instrument paper data")
library(tidyverse)
library(vascr)
library(plotly)
library(grid)
library(gridExtra)
devtools::load_all("E:\\\\vascr code\\vascr")


# CellZScope
cellzscope1 = cellzscope_import("CellZScope/200722_raw.txt", "CellZScope/200722_model.txt", "CellZScope/200722_key.csv", "Exp1")

cellzscope2 = cellzscope_import("CellZScope/200728_raw.txt", "CellZScope/200728_model.txt", "CellZScope/200728_key.csv", "Exp2")

cellzscope3 = cellzscope_import("CellZScope/200907_raw.txt", "CellZScope/200907_model.txt", "CellZScope/200907_key.csv", "Exp3")


# Clean out the trash wells
czs1m = subset(cellzscope1, !is.na(cellzscope1$Sample) & !is.na(cellzscope1$Value))
czs2m = subset(cellzscope2, !is.na(cellzscope2$Sample) & !is.na(cellzscope2$Value))
czs3m = subset(cellzscope3, !is.na(cellzscope3$Sample) & !is.na(cellzscope3$Value))

# Resample
czs1r = czs1m %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)
czs2r = czs2m %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)
czs3r = czs3m %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)


# Data cleaning
czs1 = vascr_exclude(czs1r, wells = c("B06", "C06", "A06", "C05", "D02"))
temp = vascr_prep_graphdata(czs1, unit = "R", frequency = 4000, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())

czs2 = vascr_exclude(czs2r, wells = c("D02", "B06"))
temp = vascr_prep_graphdata(czs2, unit = "TER", frequency = 0, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())

czs3 = vascr_exclude(czs3r, wells = c("D02"))
temp = vascr_prep_graphdata(czs3, unit = "TER", frequency = 0, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())

# Combine datasets
czs = vascr_combine(czs1, czs2, czs3)

temp = vascr_prep_graphdata(czs, unit = "R", frequency = 4000, level = "experiments", normtime = 44)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, linetype = Experiment)) + geom_line())

temp = vascr_prep_graphdata(czs, unit = "TER", frequency = 0, level = "summary", normtime = 44)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, ymax = ymax, ymin = ymin)) + geom_line() + geom_ribbon(alpha = 0.3))

# //////////////////////////////////////////////////////////////////////////
  
# xCELLigence
xcell1 = import_xcelligence("xcelligence/200722.plt", 'xcelligence/200722_key.csv', "Exp1")
xcell2 = import_xcelligence("xcelligence/200728.plt", 'xcelligence/200728_key.csv', "Exp2")
xcell3 = import_xcelligence("xcelligence/200907.plt", 'xcelligence/200907_key.csv', "Exp3")


# Data cleaning
xcell1m = subset(xcell1, xcell1$Value>10^-5)
xcell2m = subset(xcell2, xcell2$Value>10^-5)
xcell3m = subset(xcell3, xcell3$Value>10^-5)

xcell1m = subset(xcell1m, !is.na(xcell1m$Sample))
xcell2m = subset(xcell2m, !is.na(xcell2m$Sample))
xcell3m = subset(xcell3m, !is.na(xcell3m$Sample))

xcell1m = vascr_subset(xcell1m, unit = "Z")
xcell2m = vascr_subset(xcell2m, unit = "Z")
xcell3m = vascr_subset(xcell3m, unit = "Z")

xcell1r = vascr_resample(xcell1m, 1)
xcell2r = vascr_resample(xcell2m, 1)
xcell3r = vascr_resample(xcell3m, 1)

xcell1r = vascr_exclude(xcell1r, wells = c("H02", "H01"))
temp = vascr_prep_graphdata(xcell1r, unit = "Z", frequency = 5000, level = "wells", normtime = 46)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())

xcell2r = vascr_exclude(xcell2r, wells = c())
temp = vascr_prep_graphdata(xcell2r, unit = "Z", frequency = 5000, level = "experiments", normtime = 46)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


xcell3r = vascr_exclude(xcell3r, wells = c("A10", "B10", "C10", "F12", "D10", "D11", "D12", "H10", "H11", "H12", "A11", "A12", "B12"))
temp = vascr_prep_graphdata(xcell3r, unit = "Z", frequency = 5000, level = "wells", normtime=46)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


xcell = vascr_combine(xcell1r, xcell2r)
temp = vascr_prep_graphdata(xcell, unit = "Z", frequency = 0, level = "experiments", normtime = 44)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample)) + geom_line(aes(linetype = Experiment)))

temp = vascr_prep_graphdata(xcell, unit = "Z", frequency = 0, level = "summary", normtime = 44)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, ymax = ymax, ymin = ymin)) + geom_line() + geom_ribbon(alpha = 0.3))

#////////////////////////////////////////////////
# ECIS

ecis1 = ecis_import("ECIS/ECIS_200722_MFT_1.abp", "ECIS/ECIS_200722_MFT_1_RbA.csv", "ECIS/200722_key.csv", "Exp1")
ecis2 = ecis_import("ECIS/ECIS_200728_MFT_1.abp", "ECIS/ECIS_200728_MFT_1_RbA.csv", "ECIS/200728_key.csv", "Exp2")
ecis3 = ecis_import("ECIS/ECIS_200907_MFT_1.abp", "ECIS/ECIS_200907_MFT_1_RbA.csv", "ECIS/200907_key.csv", "Exp3")


ecis1r = ecis1 %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)
ecis2r = ecis2 %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)
ecis3r = ecis3 %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)


ecis1m = vascr_exclude(ecis1r, wells = c("H01", "H02", "D02", "D03"))
temp = vascr_prep_graphdata(ecis1m, unit = "Z", frequency = 5000, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


ecis2m = vascr_exclude(ecis2r, wells = c("H01", "H06", "D01", "D06"))
ecis2m = subset(ecis2m, ecis2m$Sample != "NA")
temp = vascr_prep_graphdata(ecis2m, unit = "Z", frequency = 5000, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


ecis3m = vascr_exclude(ecis3r, wells = c("H10", "H11"))
ecis3m = subset(ecis3m, ecis3m$Sample != "NA")
temp = vascr_prep_graphdata(ecis3m, unit = "Z", frequency = 5000, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


# Combine experiments and check it works
ecis = vascr_combine(ecis1m, ecis2m, ecis3m)

temp = vascr_prep_graphdata(ecis, unit = "Z", frequency = 5000, level = "experiments", normtime = 44)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample)) + geom_line(aes(linetype = Experiment)))

temp = vascr_prep_graphdata(ecis, unit = "R", frequency = 4000, level = "summary", normtime = 44)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, ymax = ymax, ymin = ymin)) + geom_line() + geom_ribbon(alpha = 0.3))



# ecis1m = subset(ecis1m, select = -c(`NA`) )
# master = vascr_combine(xcell1r, ecis1m, czs1)
# master$HCMVEC = gsub(",", "", master$HCMVEC)
# master$HCMVEC = as.numeric(master$HCMVEC)
# 
# 


  vascr_plot_line() +
  lims(y = c(0,NA))
  
  vascr_remove_metadata(xcell)

master = vascr_combine(vascr_remove_metadata(czs), vascr_remove_metadata(ecis))
master = vascr_explode(master)

save(master, file = "masterdata.rda")

load("masterdata.rda")
load("Z:\\Impedance instrument paper data\\masterdata.rda")

file.choose()

(master %>% vascr_subset(unit = "Ccl", frequency = 10000, instrument = "cellzscope") %>%
    filter(pg.ml.IL1b == "NA" & pg.ml.IL1b == "NA" & (HCMVEC =="20,000")|HCMVEC=="20000") %>%
    # filter(!(Experiment == "1 : 3 : 1 : 200907_model.txt" & Well == "A04")) %>%
  vascr_resample_time() %>%
  vascr_summarise(level ="wells") %>%
  ggplot()+
    geom_line(aes(x = Time, y = Value, color = Sample, linetype = Experiment, group = paste(Well, Experiment)))) %>%
  ggplotly()

# Emergency backup in memory
#savedmaster = master


master = master %>% filter(!(Experiment == "1 : 3 : 1 : 200907_model.txt" & Well == "A04"))

#### Fig for media testing chapter, to sit in parity with the stem cell stuff ###

m2 = vascr_subset(master, instrument = "ECIS", unit = "Rb", frequency = "4000")


p1 = m2 %>% mutate(Experiment = factor(Experiment, labels = c("1", "2", "3"))) %>%
  vascr_summarise("experiments") %>%
  vascr_subset(time = c(0,72)) %>%
  subset(Sample == "NA_pg.ml.TNFa + NA_pg.ml.IL1b + Water_Vehicle + 20000_HCMVEC") %>%
  ggplot()+
  geom_line(aes(x = Time, y = Value, color = Experiment)) +
  geom_ribbon(aes(x = Time, ymin = Value - sem, ymax = Value + sem, fill = Experiment), color = NA, alpha = 0.3) +
  labs(color = "Repeat experiment", fill = "Repeat experiment") +
  ggnewscale::new_scale_color()+
  geom_vline(aes(xintercept = 47, color = "Media Exchanged")) + 
  scale_color_manual(values = "black")+
  lims(y = c(0,NA)) +
  labs(color = "", x = "Time (hours)", y = "**Cell-cell interactions**<br>Rb (&Omega; cm<sup>-1</sup>)") +
  mdthemes::md_theme_grey()

p1

m2 = vascr_subset(master, instrument = "cellZscope", unit = "TER", frequency = "4000")

unique(m2$Sample)

p2 = m2 %>% mutate(Experiment = factor(Experiment, labels = c("1", "2", "3"))) %>%
  vascr_summarise("experiments") %>%
  vascr_subset(time = c(0,72)) %>%
  subset(Sample == "NA_pg.ml.TNFa + NA_pg.ml.IL1b + Water_Vehicle + 20,000_HCMVEC") %>%
  ggplot()+
  geom_line(aes(x = Time, y = Value, color = Experiment)) +
  geom_ribbon(aes(x = Time, ymin = Value - sem, ymax = Value + sem, fill = Experiment), color = NA, alpha = 0.3) +
  labs(color = "Repeat experiment", fill = "Repeat experiment") +
  ggnewscale::new_scale_color()+
  geom_vline(aes(xintercept = 47, color = "Media Exchanged")) + 
  scale_color_manual(values = "black")+
  lims(y = c(0,NA)) +
  labs(color = "", x = "Time (hours)", y = "**TER**<br>(&Omega; cm<sup>-1</sup>)") +
  mdthemes::md_theme_grey()



## This bit comes from the barrier preservation plots file

p3 = d3_f %>% 
  mutate(Time = Time - 1.7) %>%
  vascr_subset(unit = 'Rb', frequency = 4000, time = c(0,72)) %>% 
  subset(F == 4) %>%
  mutate(Experiment = factor(Experiment, labels = c("1", "2", "3"))) %>%
  vascr_summarise("experiments") %>%
  ggplot()+
  geom_line(aes(x = Time, y = Value, color = Experiment)) +
  geom_ribbon(aes(x = Time, ymin = Value - sem, ymax = Value + sem, fill = Experiment), color = NA, alpha = 0.3) +
  labs(color = "Repeat experiment", fill = "Repeat experiment") +
  ggnewscale::new_scale_color()+
  geom_vline(aes(xintercept = 47, color = "Media Exchanged")) + 
  scale_color_manual(values = "black")+
  lims(y = c(0,NA)) +
  labs(color = "", x = "Time (hours)", y = "**Cell-cell interactions**<br>Rb (&Omega; cm<sup>-1</sup>)") +
  mdthemes::md_theme_grey()

p3


  (p2 + labs(title = "A) hCMVEC barrier measured using cellZscope")) / 
  (p1 + labs(title = "B) hCMVEC barrier measured using ECIS")) / 
  (p3 + labs(title = "C) hCMEC/D3 barrier measured using ECIS") ) + 
  plot_layout(guides = "collect") &
  theme(legend.position='bottom')


masterm = subset(master, master$HCMVEC == 80000)
masterm = vascr_subset(masterm, time = c(44,75))

#############################
# Fig 2
#############################

mini1 = vascr_subset(master, time = 47, unit = "Z")
mini1 = vascr_explode(mini1)
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")

mini1a = mini1
mini1a$Sample = str_remove(mini1a$HCMVEC, ",")

mini1a = vascr_summarise(mini1a, level = "summary")
mini1a$sem = mini1a$sd / sqrt(mini1a$n)
mini1a$Frequency = as.numeric(mini1a$Frequency)


p1 = ggplot(mini1a) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = Sample)) + 
  geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Instrument)) + 
  scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + 
  labs(x = "Frequency (Hz)", y = "Impedance (ohm)", shape = "**hCMVEC Seeding Density**", color = "**Instrument**") +
  scale_shape_manual(values = c(2, 3, 1), labels = c("Media only", "62,500 cells/cm^2^", "250,000 cells/cm^2^")) +
  md_theme_gray()+
  labs(title = "B) 47 Hours")

mini1 = vascr_subset(master, time = 5, unit = "Z")
mini1 = vascr_explode(mini1)
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")

mini1a = mini1
mini1a$Sample = str_remove(mini1a$HCMVEC, ",")

mini1a = vascr_summarise(mini1a, level = "summary")
mini1a$sem = mini1a$sd / sqrt(mini1a$n)
mini1a$Frequency = as.numeric(mini1a$Frequency)


p2 = ggplot(mini1a) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = Sample)) + 
  geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Instrument)) + 
  scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + 
  labs(x = "Frequency (Hz)", y = "Impedance (ohm)", shape = "**hCMVEC Seeding Density**", color = "**Instrument**") +
  scale_shape_manual(values = c(2, 3, 1), labels = c("Media only", "62,500 cells/cm^2^", "250,000 cells/cm^2^")) +
  md_theme_gray()+
  labs(title = "A) 5 Hours")


p2 / p1 +
  plot_layout(guides = "collect") &
  theme(legend.position = 'bottom', 
        legend.box = "vertical")

#############################
# Fig 3
#############################

mini1 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")

mini2 = vascr_summarise(mini1, level = "experiments")
mini2$Experiment = "NA"
p1a = vascr_plot_cross_correlation(mini2, plot = "bar")

mini3 = vascr_remove_metadata(mini1)
mini3 = vascr_normalise(mini3, 47, divide = TRUE)
mini3 = vascr_prep_graphdata(mini3, unit = "Z", frequency = c(8000, 10000), level = "experiments")
p1b = ggplot(mini3, aes(x = Time, y = Value, colour = Instrument)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Instrument), alpha = 0.3) + ylab("Impedance (Ohm)") + xlab("Time (hours)")

mini1 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
mini1 = subset(mini1, mini1$pg.ml.TNFa == "500")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")

mini2 = vascr_summarise(mini1, level = "experiments")
mini2$Experiment = "NA"
p2a = vascr_plot_cross_correlation(mini2, plot = "bar")

mini3 = vascr_remove_metadata(mini1)
mini3 = vascr_normalise(mini3, 47, divide = TRUE)
mini3 = vascr_prep_graphdata(mini3, unit = "Z", frequency = c(8000, 10000), level = "experiments")
p2b = ggplot(mini3, aes(x = Time, y = Value, colour = Instrument)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Instrument), alpha = 0.3) + ylab("Impedance (Ohm)") + xlab("Time (hours)")


mini1 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "500")

mini2 = vascr_summarise(mini1, level = "experiments")
mini2$Experiment = "NA"
p3a = vascr_plot_cross_correlation(mini2, plot = "bar", order = FALSE)

mini3 = vascr_remove_metadata(mini1)
mini3 = vascr_normalise(mini3, 47, divide = TRUE)
mini3 = vascr_prep_graphdata(mini3, unit = "Z", frequency = c(8000, 10000), level = "experiments")
p3b = ggplot(mini3, aes(x = Time, y = Value, colour = Instrument)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Instrument), alpha = 0.3) + ylab("Impedance (Ohm)") + xlab("Time (hours)")

p1b = p1b + labs(title = "Control")
p2b = p2b + labs(title = "500 pg/ml TNFa")
p3b = p3b + labs(title = "500 pg/ml IL1b")

rainbow = vascr_gg_color_hue(3)


p1a = p1a + scale_colour_manual(values = rainbow, aesthetics = "Treatment") + labs(title = "") + ylab("Cross Correlation Coefficent")
p2a = p2a + scale_colour_manual(values = c(rainbow[1], rainbow[3], rainbow[2]), aesthetics = c("colour","fill"))+ labs(title = "") + ylab("Cross Correlation Coefficent")
p3a = p3a + scale_colour_manual(values = c(rainbow[1], rainbow[3], rainbow[2]), aesthetics = c("colour","fill"))+ labs(title = "") + ylab("Cross Correlation Coefficent")

vascr_make_panel(p1b, p1a, p2b,p2a, p3b, p3a)

### Regenerated new fig 3-2 in thesis

localdat = master %>% filter(`pg.ml.TNFa`== "NA" & `pg.ml.IL1b`== "NA" & `HCMVEC` >0) %>%
  vascr_subset(time = c(0, 47)) %>%
  mutate(Frequency = as.numeric(Frequency))

 p1 = localdat %>% vascr_subset(instrument = "ECIS", unit = "Z", frequency = "8000") %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line() + md_theme_gray() +
  labs(y = "Impedance<br>(ohm, 8,000 Hz)", tag = "A")


 p2 = localdat %>% vascr_subset(instrument = "cellZscope", frequency = 10000, unit = "Z") %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line() + md_theme_gray() +
  labs(y = "Impedance<br>(ohm, 10,000 Hz)", tag = "B")
 
 p3 = localdat %>% vascr_subset(instrument = "xCELLigence", frequency = 10000, unit = "Z") %>%
   vascr_summarise(level = "summary") %>%
   vascr_plot_line() + md_theme_gray() +
   labs(y = "Impedance<br>(ohm, 10,000 Hz)", tag = "C")

 p4 = localdat %>% vascr_subset(instrument = "ECIS", unit = "Rb") %>%
   vascr_summarise(level = "summary") %>%
   vascr_plot_line() + md_theme_gray() +
   labs(y = "Rb (&#8486; cm&#178;)", tag = "D")

 p5 = localdat %>% vascr_subset(instrument = "cellZscope", unit = "TER") %>%
   vascr_summarise(level = "summary") %>%
   vascr_plot_line() + md_theme_gray() +
   labs(y = "TER (&#8486; cm&#178;)", tag = "E")
 
 p6 = localdat %>% vascr_subset(instrument = "ECIS", unit = "Cm") %>%
   vascr_summarise(level = "summary") %>%
   vascr_plot_line() + md_theme_gray() +
   labs(y = "Cm (&#181;F/cm&#178;)", tag = "F")
 
 p7 = localdat %>% vascr_subset(instrument = "cellZscope", unit = "Ccl") %>%
   vascr_summarise(level = "summary") %>%
   vascr_plot_line() + md_theme_gray() +
   labs(y = "C~CL~(	&#181;F/cm&#178;)", tag = "G")
 
 p8 = localdat %>% vascr_subset(instrument = "ECIS", unit = "Alpha") %>%
   vascr_summarise(level = "summary") %>%
   vascr_plot_line() + md_theme_gray() +
   labs(y = "Alpha (&#8486; cm&#178;)", tag = "H")
 
 
 title1 = richtext_grob("**ECIS**")
 title2 = richtext_grob("**cellZscope**")
 title3 = richtext_grob("**xCELLigence**")
 title4 = richtext_grob("**Electrical Impedance**")
 title5 = richtext_grob("**Cell-cell interaction**")
 title6 = richtext_grob("**Membrane capacatance**")
 title7 = richtext_grob("**Basolateral adhesion**")
 titleblank = ggplot() + theme_void()

 titleblank + title1 + title2 + title3 +
 title4 + p1+ p2 + p3 +
 title5 + p4 + p5 + titleblank +
 title6 + p6 + p7 + titleblank +
 title7 + p8 + titleblank + get_legend(p1 + scale_color_discrete(labels = c("62,500 cells/cm^2^", "250,000 cells/cm^2^"))
                                       + scale_fill_discrete( labels = c("62,500 cells/cm^2^", "250,000 cells/cm^2^")) +
                                         labs(color = "**hCMVEC Seeding Density**", fill = "**hCMVEC Seeding Density**")) +
 plot_layout(ncol=4, heights = c(0.2, 1,1,1,1), widths = c(0.8,1,1,1))&
 theme(legend.position = "none")
 
 
 
#############################
# Fig 3 of the thesis
#############################

fig4 = function(mini1, ylabel, l1, l2)
{
mini1 = vascr_remove_metadata(mini1) %>% vascr_resample_time()
mini1 = vascr_normalise(mini1, 47, divide = TRUE)
mini1 = vascr_explode(mini1)
mini1 = vascr_implode(mini1)
mini2 = mini1
mini2$Sample = trimws(gsub("\\+", "", mini1$Sample))
mini2$Sample = trimws(gsub("500_pg.ml.TNFa", "500 pg/ml TNF&alpha;", mini2$Sample))
mini2$Sample = trimws(gsub("500_pg.ml.IL1b", "500 pg/ml IL1&beta;", mini2$Sample))
mini2$Sample %>% unique()
mini2$Sample[mini2$Sample==""] = "Control"
a = vascr_plot_line(mini2 %>% vascr_summarise(level = "summary")) + 
  labs(color = "**Sample**", fill = "**Sample**")+
  ggnewscale::new_scale_color() +
  geom_vline( size = 1, aes(xintercept = 48, color = "")) +
  scale_color_manual(values = "orange") +
  labs(colour = "**Treatment time**")+
  theme(legend.position = "none") + ylab(ylabel)+
  lims(y = c(0.75,1.1)) + labs(tag = l1)

a

b = vascr_plot_cross_correlation(mini2, plot = "bar") + labs(y = "Cross Correlation Coefficent") + theme(legend.position = "none") +
  labs(x = "Cross Correlation", y = "Sample", tag = l2)

b

return(a+b)

}
 
 title1 = richtext_grob("**ECIS**")
 title2 = richtext_grob("**cellZscope**")
 title3 = richtext_grob("**xCELLigence**")
 title4 = richtext_grob("**62,500 cells/cm^2^**")
 title5 = richtext_grob("**250,000 cells/cm^2^**")
 titleblank = ggplot() + theme_void()

p1 =  master %>% vascr_subset(instrument = "ECIS", unit = "Z", frequency = 8000, time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20000", "20,000")) %>%
   fig4("Normalised Impedance<br>(Ohm, 8,000 Hz)", "A", "B") 

p2 =  master %>% vascr_subset(instrument = "ECIS", unit = "Z", frequency = 8000, time = c(45, 96)) %>% 
  filter(HCMVEC %in% c("80000", "80000")) %>%
  fig4("Normalised Impedance<br>(Ohm, 8,000 Hz)", "C", "D")

p3 =  master %>% vascr_subset(instrument = "cellZscope", unit = "Z", frequency = 10000, time = c(45, 96)) %>% 
  filter(HCMVEC %in% c("20000", "20,000")) %>%
  fig4("Normalised Impedance<br>(Ohm, 10,000 Hz)", "E", "F")
p4 =  master %>% vascr_subset(instrument = "cellZscope", unit = "Z", frequency = 10000, time = c(45, 96)) %>% 
  filter(HCMVEC %in% c("80,000", "80000")) %>%
  fig4("Normalised Impedance<br>(Ohm, 10,000 Hz)", "G", "H")

p5 =  master %>% vascr_subset(instrument = "xCELLigence", unit = "Z", frequency = 10000, time = c(45, 96)) %>% 
  filter(HCMVEC %in% c("20000", "20,000")) %>%
  fig4("Normalised Impedance<br>(Ohm, 10,000 Hz)", "I", "J")

p6 =  master %>% vascr_subset(instrument = "xCELLigence", unit = "Z", frequency = 10000, time = c(45, 96)) %>% 
  filter(HCMVEC %in% c("80,000", "80000")) %>%
  fig4("Normalised Impedance<br>(Ohm, 10,000 Hz)", "K", "L")
 
legend1 = get_legend(a + theme(legend.position = "bottom"))

 titleblank+title4+title5+
 title1 + p1 + p2 +
 title2 + p3 + p4 +
 title3 + p5 + p6 +
 legend1+
  plot_layout(ncol = 3, heights = c(0.2, 1,1,1), widths = c(0.5, 1,1), 
              design = "ABC
                        DEF
                        GHI
                        JKL
                        MMM")


 
#  
# p1a = fig4(masterm, "ECIS", "Z", "8000", "a") + labs(title = "ECIS") + ylab("Impedance (Ohm, 8,000 Hz)")
# p1b = fig4(masterm, "ECIS", "Z", "8000", "b") + labs(title = "")
# 
# 
# p2a = fig4(masterm, "cellZscope", "Z", "10000", "a") + labs(title = "cellZscope") + ylab("Impedance (Ohm, 10,000 Hz)")
# p2b = fig4(masterm, "cellZscope", "Z", "10000", "b") + labs(title = "")
# 
# p3a = fig4(masterm, "xCELLigence", "Z", "10000", "a") + labs(title = "xCELLigence") + ylab("Impedance (Ohm, 10,000 Hz)")
# p3b = fig4(masterm, "xCELLigence", "Z", "10000", "b") + labs(title = "")
# 
# vascr_make_panel(p1a, p1b, p2a, p2b, p3a, p3b)
# 
# 
# 
# p4a = fig4(masterm, "ECIS", "Rb", "0", "a") + labs(title = "Rb")
# p4b = fig4(masterm, "ECIS", "Rb", "0", "b") + labs(title = "")
# 
# 
# p5a = fig4(masterm, "cellZscope", "TER", "0", "a") + labs(title = "TER")
# p5b = fig4(masterm, "cellZscope", "TER", "0", "b") + labs(title = "")
# 
# grid.arrange(p1a, p1b, p4a, p4b)
# 
# 
 
 #############################
 # Fig 4 of the thesis
 #############################
 
 fig4 = function(mini1, ylabel, l1, l2)
 {
   mini1 = vascr_remove_metadata(mini1) %>% vascr_resample_time()
   mini1 = vascr_normalise(mini1, 47, divide = TRUE)
   mini1 = vascr_explode(mini1)
   mini1 = vascr_implode(mini1)
   mini2 = mini1
   mini2$Sample = trimws(gsub("\\+", "", mini1$Sample))
   mini2$Sample = trimws(gsub("500_pg.ml.TNFa", "500 pg/ml TNF&alpha;", mini2$Sample))
   mini2$Sample = trimws(gsub("500_pg.ml.IL1b", "500 pg/ml IL1&beta;", mini2$Sample))
   mini2$Sample %>% unique()
   mini2$Sample[mini2$Sample==""] = "Control"
   a = vascr_plot_line(mini2 %>% vascr_summarise(level = "summary")) + 
     labs(color = "**Sample**", fill = "**Sample**")+
     ggnewscale::new_scale_color() +
     geom_vline( size = 1, aes(xintercept = 48, color = "")) +
     scale_color_manual(values = "orange") +
     labs(colour = "**Treatment time**")+
     theme(legend.position = "none") + ylab(ylabel)+
     lims(y = c(0.6, 1.45)) + labs(tag = l1)
   
   a
   
   b = vascr_plot_cross_correlation(mini2, plot = "bar") + labs(y = "Cross Correlation Coefficent") + theme(legend.position = "none") +
     labs(x = "Cross Correlation", y = "Sample", tag = l2)
   
   b
   
   return(a+b)
   
 }
 
 title1 = richtext_grob("**Overall Impedance**")
 title2 = richtext_grob("**Cell-cell Interaction**")
 title3 = richtext_grob("**Membrane<br>capacatance**")
 title4 = richtext_grob("**ECIS**")
 title5 = richtext_grob("**cellZscope**")
 titleblank = ggplot() + theme_void()
 
 p1 =  master %>% vascr_subset(instrument = "ECIS", unit = "Z", frequency = 8000, time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20000", "20,000")) %>%
   fig4("Normalised Impedance<br>(Ohm, 8,000 Hz)", "A", "B") 
 
 p2 =  master %>% vascr_subset(instrument = "cellZscope", unit = "Z", frequency = 10000, time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20,000", "20000")) %>%
   fig4("Normalised Impedance<br>(Ohm, 10,000 Hz)", "C", "D")
 
 
 
 p3 =  master %>% vascr_subset(instrument = "ECIS", unit = "Rb", time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20000", "20000")) %>%
   fig4("Normalised Rb (&#8486; cm&#178;)", "E", "F")
 
 
 
 p4 =  master %>% vascr_subset(instrument = "cellZscope", unit = "TER", frequency = 10000, time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20000", "20,000")) %>%
   fig4("Normalised TER (&#8486; cm&#178;)", "G", "H")
 
 
 
 p5 =  master %>% vascr_subset(instrument = "ECIS", unit = "Cm", frequency = 10000, time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20000", "20,000")) %>%
   fig4("Normalised Cm (&#181;F/cm&#178;)", "I", "J")
 
 p6 =  master %>% vascr_subset(instrument = "cellZscope", unit = "Ccl", frequency = 10000, time = c(45, 96)) %>% 
   filter(HCMVEC %in% c("20,000", "20000")) %>%
   fig4("Normalised C~CL~(	&#181;F/cm&#178;)", "K", "L")
 
 legend1 = get_legend(a + theme(legend.position = "bottom"))
 
 titleblank+title4+title5+
   title1 + p1 + p2 +
   title2 + p3 + p4 +
   title3 + p5 + p6 +
   legend1+
   plot_layout(ncol = 3, heights = c(0.2, 1,1,1), widths = c(0.5, 1,1), 
               design = "ABC
                        DEF
                        GHI
                        JKL
                        MMM")
 
 
#  
# 
# 
# 
# #############################
# # Fig
# ############################
# 
# 
# data10 = vascr_subset(masterm, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), instrument = c("ECIS", "xCELLigence"))
# data10 = subset(data10, data10$pg.ml.TNFa == "NA")
# data10 = subset(data10, data10$pg.ml.IL1b == "NA")
# 
# data10$Experiment = "NA"
# data12 = vascr_summarise(data10, level = "experiments")
# 
# data13 = vascr_summarise_cross_correlation(data12, reference = "[ Z Unit | 10000 Hz | xCELLigence Instrument ]")
# hue = vascr_gg_color_hue(5)
# p9a = ggplot(data13, aes(x = sample, y = coeffs, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation Coefficent") + xlab("")  + scale_fill_manual(values = c(hue[1], hue[2], hue[3], hue[4]))
# 
# data11 = vascr_normalise(data10, 45, divide = TRUE)
# data11 = vascr_prep_graphdata(data11, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), level = "experiments")
# 
# data11$Measurement = paste(data11$Unit, data11$Instrument)
# 
# p9b = ggplot(data11, aes(x = Time, y = Value, colour = Measurement)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Measurement), alpha = 0.3) + ylab("Unit Value") + xlab("Time (hours)")
# 
# 
# 
# data10 = vascr_subset(masterm, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), instrument = c("ECIS", "xCELLigence"))
# data10 = subset(data10, data10$pg.ml.TNFa == "500")
# data10 = subset(data10, data10$pg.ml.IL1b == "NA")
# 
# data10$Experiment = "NA"
# data12 = vascr_summarise(data10, level = "experiments")
# 
# data13 = vascr_summarise_cross_correlation(data12, reference = "[ Z Unit | 10000 Hz | xCELLigence Instrument ]")
# hue = vascr_gg_color_hue(5)
# p10a = ggplot(data13, aes(x = sample, y = coeffs, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation Coefficent")+ xlab("")  + scale_fill_manual(values = c(hue[1], hue[2], hue[3], hue[4]))
# 
# data11 = vascr_normalise(data10, 45, divide = TRUE)
# data11 = vascr_prep_graphdata(data11, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), level = "experiments")
# 
# data11$pairity = paste(data11$Unit, data11$Instrument)
# 
# p10b = ggplot(data11, aes(x = Time, y = Value, colour = pairity)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = pairity), alpha = 0.3) + ylab("Unit Value") + xlab("Time (hours)")
# 
# 
# 
# 
# data10 = vascr_subset(masterm, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), instrument = c("ECIS", "xCELLigence"))
# data10 = subset(data10, data10$pg.ml.TNFa == "NA")
# data10 = subset(data10, data10$pg.ml.IL1b == "500")
# 
# data10$Experiment = "NA"
# data12 = vascr_summarise(data10, level = "experiments")
# 
# vascr_summarise_cross_correlation(data12)
# 
# data13 = vascr_summarise_cross_correlation(data12, reference = "[ Z Unit | 10000 Hz | xCELLigence Instrument ]")
# hue = vascr_gg_color_hue(5)
# p11a = ggplot(data13, aes(x = sample, y = coeffs, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation Coefficent")+ xlab("")  + scale_fill_manual(values = c(hue[1], hue[2], hue[3], hue[4]))
# 
# data11 = vascr_normalise(data10, 45, divide = TRUE)
# data11 = vascr_prep_graphdata(data11, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), level = "experiments")
# 
# data11$pairity = paste(data11$Unit, data11$Instrument)
# 
# p11b = ggplot(data11, aes(x = Time, y = Value, colour = pairity)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = pairity), alpha = 0.3)+ ylab("Unit Value") + xlab("Time (hours)")
# 
# 
# p9b = p9b + labs(title = "Control")
# p10b = p10b + labs(title = "500 pg/ml TNFa")
# p11b = p11b + labs(title = "500 pg/ml IL1B")
# 
# vascr_make_panel(p9b, p9a, p10b, p10a, p11b, p11a)
# 
# 
# play = vascr_subset(masterm, instrument = "CellZScope")
# unique(play$Frequency)
# play = vascr_subset(masterm, instrument = "ECIS")
# unique(play$Frequency)
# 

# #////////////////////////////////////
# # Master combiner
# 
# ecis = subset(ecis, select = -c(`NA`) )
# master = vascr_combine(ecis, xcell, czs)
# master$HCMVEC = gsub(",", "", master$HCMVEC)
# master$HCMVEC = as.numeric(master$HCMVEC)
# 
# masterm = subset(master, master$HCMVEC == 80000)
# masterm = vascr_subset(masterm, time = c(44,75))
# 
# # ////////////////////////////////////////////////
# # Figure 2
# 
# mini1 = vascr_subset(masterm, time = 47, unit = "Z")
# mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
# mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")
# 
# mini1 = vascr_summarise(mini1, level = "summary")
# mini1$sem = mini1$sd / sqrt(mini1$n)
# 
# ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument)) + geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Instrument)) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# 
# # Figure 3
# 
# #No trtmt
# mini2 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
# mini2 = subset(mini2, mini2$pg.ml.TNFa == "NA")
# mini2 = subset(mini2, mini2$pg.ml.IL1b == "NA")
# mini2 = vascr_normalise(mini2, 47, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "summary")
# 
# ggplot(mini3) + geom_line(aes(x = Time, y = Value, color = Instrument)) + geom_ribbon(aes(x = Time, y = Value, ymax = Value + sd, ymin = Value-sd, color = Instrument, fill = Instrument), alpha = 0.5)
# 
# mini4 = vascr_summarise(mini2, level = "summary")
# vascr_plot_cross_correlation(mini4)
# 
# 
# 
# # TNF
# mini2 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
# mini2 = subset(mini2, mini2$pg.ml.TNFa == "500")
# mini2 = subset(mini2, mini2$pg.ml.IL1b == "NA")
# mini2 = vascr_normalise(mini2, 47, divide = TRUE)
# mini2 = vascr_summarise(mini2, level = "summary")
# 
# ggplot(mini2) + geom_line(aes(x = Time, y = Value, color = Instrument)) + geom_ribbon(aes(x = Time, y = Value, ymax = Value + sd, ymin = Value-sd, color = Instrument, fill = Instrument), alpha = 0.5)
# 
# mini4 = vascr_summarise(mini2, level = "summary")
# vascr_plot_cross_correlation(mini4)
# 
# # IL1
# mini2 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
# mini2 = subset(mini2, mini2$pg.ml.TNFa == "500")
# mini2 = subset(mini2, mini2$pg.ml.IL1b == "NA")
# mini2 = vascr_normalise(mini2, 47, divide = TRUE)
# mini2 = vascr_summarise(mini2, level = "summary")
# 
# ggplot(mini2) + geom_line(aes(x = Time, y = Value, color = Instrument)) + geom_ribbon(aes(x = Time, y = Value, ymax = Value + sd, ymin = Value-sd, color = Instrument, fill = Instrument), alpha = 0.5)
# 
# mini4 = vascr_summarise(mini2, level = "summary")
# vascr_plot_cross_correlation(mini4)
# 
# 
# 
# 
# # Discrimination potential
# mini2 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000), instrument = "ECIS")
# mini2 = vascr_summarise(mini2, level = "summary")
# vascr_summarise_cross_correlation(mini2)





# Thesis data

gl = list()

ecis2 = master %>% vascr_subset(instrument = "ECIS", unit = "R", frequency = 4000) %>% vascr_subset(time = c(40, 96)) %>%
  vascr_interpolate_time(200) %>% 
  vascr_explode() %>% 
  vascr_assign_sampleid() %>%
  filter(pg.ml.IL1b == "NA", HCMVEC < 30000, HCMVEC > 0)

  
  gl[[1]] = ecis2 %>%
  vascr_implode() %>%
  mutate(Sample = str_replace(Sample, "500 pg ml TNFa", "Cytokine 1")) %>%
    mutate(Sample = str_replace(Sample, "Control", "Vehicle")) %>%
    mutate(Sample = factor(Sample, unique(Sample))) %>%
  vascr_summarise("experiments") %>% 
  vascr_plot_line() +
  scale_linetype_manual(values = c("solid", "longdash", "dotted"), labels = c("Experiment 1", "Experiment 2", "Experiment 3")) +
    labs(color = "Treatment", fill = "Treatment", linetype = "Experimental replicate") +
  new_scale_color() +
    geom_vline(aes(xintercept = 47.5, color = "Cytokine 1 addition")) + labs(color = "") +
    scale_color_manual(values = "orange")
  
  gl[[1]]
  
  gl[[2]] = ecis2 %>%
    filter(pg.ml.IL1b == "NA", HCMVEC < 30000, HCMVEC > 0) %>% 
    vascr_implode() %>%
    vascr_summarise("summary") %>% 
    vascr_plot_line() +
    scale_linetype_manual(values = c("solid", "longdash", "dotted"), labels = c("Experiment 1", "Experiment 2", "Experiment 3")) +
    labs(color = "Treatment") +
    new_scale_color() +
    geom_vline(aes(xintercept = 47.5, color = "TNF&alpha; addition")) + labs(color = "") +
    scale_color_manual(values = "orange")
  
  gl[[3]] = ecis2 %>%
    filter(pg.ml.IL1b == "NA", HCMVEC < 30000, HCMVEC > 0) %>% 
    vascr_implode() %>%
    vascr_normalise(45) %>%
    vascr_summarise("experiments") %>% 
    vascr_plot_line() +
    ylab("Fold change in overall resistance  
         (ohm, 4000 Hz)")+
    scale_linetype_manual(values = c("solid", "longdash", "dotted"), labels = c("Experiment 1", "Experiment 2", "Experiment 3")) +
    labs(color = "Treatment") +
    new_scale_color() +
    geom_vline(aes(xintercept = 47.5, color = "TNF&alpha; addition")) + labs(color = "") +
    scale_color_manual(values = "orange")
  
  gl[[4]] = ecis2 %>%
    filter(pg.ml.IL1b == "NA", HCMVEC < 30000, HCMVEC > 0) %>% 
    vascr_implode() %>%
    vascr_normalise(45) %>%
    vascr_summarise("summary") %>% 
    vascr_plot_line() +
    ylab("Fold change in overall resistance  
         (ohm, 4000 Hz)")+
    scale_linetype_manual(values = c("solid", "longdash", "dotted"), labels = c("Experiment 1", "Experiment 2", "Experiment 3")) +
    labs(color = "Treatment") +
    new_scale_color() +
    geom_vline(aes(xintercept = 47.5, color = "Cytokine 1 addition")) + labs(color = "") +
    scale_color_manual(values = "orange")

  
  ggarrange(plotlist = gl, nrow = 2, ncol = 2, common.legend = TRUE, 
            legend= "right", labels = LETTERS)
  
  
  
  
  
  

  ecis3 = ecis2 %>% vascr_subset(time = c(40, 96)) %>%
    vascr_interpolate_time(200) %>% 
    vascr_explode() %>% 
    vascr_assign_sampleid() %>%
    filter(HCMVEC < 30000, HCMVEC > 0)
  
  ecis3 = vascr_make_name(ecis3)
  unique(ecis3$Sample)
  colnames(ecis3)
  
  ecis3 %>% vascr_plot_cross_correlation()
 
  parts = list()
   
 parts[[1]] =  ecis3 %>% vascr_subset(experiment =  1) %>% ungroup() %>% mutate(Well = Sample, Experiment = NULL, Sample = NULL, 
                                                                   pg.ml.IL1b = NULL, pg.ml.TNFa = NULL) %>% 
    vascr_summarise_cross_correlation() %>% select(coeffs, sample)
 
 parts[[2]] =  ecis3 %>% vascr_subset(experiment =  2) %>% ungroup() %>% mutate(Well = Sample, Experiment = NULL, Sample = NULL, 
                                                                                pg.ml.IL1b = NULL, pg.ml.TNFa = NULL) %>% 
   vascr_summarise_cross_correlation() %>% select(coeffs, sample)
 
 parts[[3]] =  ecis3 %>% vascr_subset(experiment =  3) %>% ungroup() %>% mutate(Well = Sample, Experiment = NULL, Sample = NULL, 
                                                                                pg.ml.IL1b = NULL, pg.ml.TNFa = NULL) %>% 
   vascr_summarise_cross_correlation() %>% select(coeffs, sample)

 
wholeccf = data.table::rbindlist(parts)

wholesummary = wholeccf %>% group_by(sample) %>% summarise(sem = sd(coeffs)/sqrt(n()),coeffs = mean(coeffs))

wholedata = wholesummary %>% separate(sample, into = c("V1", "V2"), sep = "\\n", remove = FALSE) %>%
  mutate(sample = str_replace(sample, "\\n", "  
  ")) %>%
  mutate(sample = str_remove_all(sample, " Well")) %>%
  mutate(sample = str_replace_all(sample, "500 pg ml TNFa", "Cytokine 1"))%>%
  mutate(sample = str_replace_all(sample, "500 pg ml IL1b", "Cytokine 2"))%>%
  mutate(sample = str_replace_all(sample, "Control", "Vehicle"))

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}


rainbow = gg_color_hue(3)

p1 = ggplot(wholedata) +
  geom_errorbar(aes(x = sample, ymin = coeffs - sem, ymax = coeffs + sem, color = V2), size = 2) +
  geom_point(aes(x = sample, y = coeffs, color = V1), size = 8) + 
  coord_flip() + ylim(-1,1) + 
  ylab("Cross Correlation Coefficent")+ xlab("**Treatment pair compared**  
                                             ") +
  scale_color_manual(values = c(rainbow[[2]], rainbow[[1]], rainbow[[3]])) +
  mdthemes::md_theme_grey()

p1
  
p2 = ecis3 %>% vascr_summarise("experiments") %>%
  mutate(Time = Time - 48) %>%
  mutate(sample = str_replace_all(Sample, "500 pg ml TNFa", "Cytokine 1"))%>%
  mutate(sample = str_replace_all(Sample, "500 pg ml IL1b", "Cytokine 2"))%>%
  mutate(sample = str_replace_all(Sample, "Control", "Vehicle")) %>%
  group_by(Sample, Experiment) %>%
  mutate(Value = (Value-min(Value))/(max(Value, na.rm = TRUE)-min(Value))) %>%
  ungroup() %>%
  group_by(Time, Sample) %>%
  mutate(mean = mean(Value, na.rm = TRUE), sem = sd(Value)/n()) %>%
  ungroup() %>%
  mutate(Sample = factor(Sample, rev(unique(Sample)))) %>%
  ggplot() +
  geom_line(aes(x = Time, y = mean, color = Sample)) + 
  geom_ribbon(aes(x = Time, ymax = mean + sem, ymin = mean-sem, fill = Sample), alpha = 0.3) +
  labs(color = "Treatment: ", fill = "Treatment: ", y = "**Fold change in overall resistance**  
       (4000Hz)", y = "Treatment")+
  geom_point(y = -100, x = 100, aes(color = Sample), size = 3) +
  ggnewscale::new_scale_color() +
  geom_vline(aes(xintercept = 0, color = "")) +
  scale_color_manual(values = c("orange")) +
  labs(color = "Treatment time: ", x = "Time (hours)") +
  mdthemes::md_theme_grey() +
  lims(x = c(-5, 48))

p2

p3 = ecis3 %>% 
  vascr_interpolate_time(200) %>%
  vascr_normalise(normtime = 46) %>%
  vascr_summarise("experiments") %>%
  mutate(Time = Time - 46) %>%
  mutate(Sample = str_replace_all(Sample, "500 pg ml TNFa", "Cytokine 1"))%>%
  mutate(Sample = str_replace_all(Sample, "500 pg ml IL1b", "Cytokine 2"))%>%
  mutate(Sample = str_replace_all(Sample, "Control", "Vehicle")) %>%
  group_by(Time, Sample) %>%
  mutate(mean = mean(Value, na.rm = TRUE), sem = sd(Value)/n()) %>%
  ungroup() %>%
  mutate(Sample = factor(Sample, (unique(Sample)))) %>%
  ggplot() +
  geom_line(aes(x = Time, y = mean, color = Sample)) + 
  geom_ribbon(aes(x = Time, ymax = mean + sem, ymin = mean-sem, fill = Sample), alpha = 0.3) +
  labs(color = "Treatment: ", fill = "Treatment: ", y = "**Normalized shape of response**  
       (Overall resistance, 4000Hz)", y = "Treatment")+
  geom_point(y = -100, x = 100, aes(color = Sample), size = 3) +
  ggnewscale::new_scale_color() +
  geom_vline(aes(xintercept = 0, color = "Cytokine addition")) +
  scale_color_manual(values = c("orange")) +
  labs(color = "", x = "Time (hours)") +
  mdthemes::md_theme_grey()+
  lims(x = c(-5, 48))

p3




ggarrange(p3, p1, common.legend = TRUE, nrow = 2, legend = "bottom", align = "hv", labels = LETTERS)


ecis4 = master %>% 
  vascr_subset(unit = "R", instrument ="ECIS", frequency = 4000, time = c(40,48+48)) %>%
  filter(HCMVEC>0, HCMVEC<30000) %>%
  vascr_interpolate_time(200) %>%
  vascr_implode(cleanup_sample = "TRUE")%>%
  mutate(Sample = str_replace_all(Sample, "500 pg ml TNFa", "Cytokine 1"))%>%
  mutate(Sample = str_replace_all(Sample, "500 pg ml IL1b", "Cytokine 2"))%>%
  mutate(Sample = str_replace_all(Sample, "Control", "Vehicle")) %>%
  mutate(Sample = factor(Sample, unique(Sample))) %>%
  arrange(Sample) %>%
  mutate(Experiment = str_replace_all(Experiment, "3 : 1 : 2 : ECIS_200722_MFT_1.abp", "Repeat 1"))%>%
  mutate(Experiment = str_replace_all(Experiment, "3 : 2 : 2 : ECIS_200728_MFT_1.abp", "Repeat 2"))%>%
  mutate(Experiment = str_replace_all(Experiment, "3 : 3 : 2 : ECIS_200907_MFT_1.abp", "Repeat 3"))

unique(ecis4$Sample)
unique(ecis4$Experiment)


vascr_plot_anova(ecis4, time = 48 + 40, unit = "R", frequency = 4000)


p1 = ecis4 %>% vascr_normalise(normtime = 44) %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line() +
  labs(colour = "Treatment")+
  ggnewscale::new_scale_color()+
  geom_vline(aes(xintercept = 47, color = "Cytokine addition"), size = 1) +
  scale_colour_manual(values = "orange") +
  labs(colour = "", y = "Fold change in overall resistance<br>(ohm, 4000 Hz)", colour = "Treatment", fill = "Treatment")

p2 = ecis4 %>% vascr_plot_cross_correlation() +
  theme(legend.position = "none") +
  labs(x = "Cross correlation coefficent", y = "Treatment pair compared")

p1 + p2 +
  plot_layout(ncol = 1, guides = "collect")

# Hypothetial sine based dataset


sin_data = data.frame(time = c(0:100)/100*2*pi) %>%
  mutate(`**Response 1** (Baseline)` = sin(time)) %>%
  mutate(`**Response 2** (Larger in magnitude)` = sin(time)*2) %>%
  mutate(`**Response 3** (Inverse)` = sin(-time)) %>%
  mutate(`**Response 4** (Change in shape)` = sin(-time*2)*2) %>%
  filter(time<2) %>% 
  mutate(time = time/2)

sin_data_2 = sin_data %>%
  pivot_longer(-time, names_to = "Sample", values_to = "value") %>%
  mutate(Sample = factor(Sample, unique(Sample)))


fig1 = sin_data_2 %>% 
  ggplot() +
  geom_line(aes(x = time, y = value, color = Sample), size = 2) +
  labs(y = "Value (AU)", x = "Time (AU)", color = "Response type: ") +
  mdthemes::md_theme_gray()


comb = combn(unique(sin_data_2$Sample),2, simplify = FALSE)

res = foreach(com = comb) %do% {
  
    com = as.vector(com) %>% as.character()
    dat1 = sin_data[com[1]]
    dat2 = sin_data[com[2]]
    corr = ccf(dat1, dat2)[0] %>% as.numeric()
    
    result = list()
    result["V1"] = com[1]
    result["V2"] = com[2]
    result['corr'] = corr
    
    return(result)
}

order = unique(res$V1, res$V2)

resdat = data.table::rbindlist(res) %>%
  as_tibble() %>%
  mutate(Sample = paste("[", V1, "]  
                        [", V2, "]", sep = "")) %>%
  mutate(V1 = factor(V1, unique(c(V1, V2)))) %>%
  mutate(V2 = factor(V2, unique(c(V1, V2))))


fig2 = ggplot(resdat) +
  geom_point(aes(x = Sample, y = corr, color = V1), size = 8) + 
  geom_errorbar(aes(x = Sample, ymin = corr, ymax = corr, color = V2), size = 2)+
  coord_flip() + ylim(-1,1) + 
  ylab("Cross Correlation Coefficent")+ 
  xlab("**Responses compared**  
                                             ") +
  mdthemes::md_theme_gray() + 
  scale_x_discrete(limits = rev)
  


ggarrange(fig1, fig2, common.legend = TRUE, nrow = 2, legend = "bottom", align = "hv", labels = LETTERS)





