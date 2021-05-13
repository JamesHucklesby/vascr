blank = function()
{
  
setwd("C:/Users/jhuc964/Desktop/ECIS R/vascr/compare/Instrument paper data")
library(tidyverse)
library(vascr)
library(plotly)
library(grid)
library(gridExtra)
library(ggpubr)
devtools::load_all()


# CellZScope
cellzscope1 = cellzscope_import("CellZScope/200722_raw.txt", "CellZScope/200722_model.txt", "CellZScope/200722_key.csv", "Exp1")

cellzscope2 = cellzscope_import("CellZScope/200728_raw.txt", "CellZScope/200728_model.txt", "CellZScope/200728_key.csv", "Exp2")

cellzscope3 = cellzscope_import("CellZScope/200907_raw.txt", "CellZScope/200907_model.txt", "CellZScope/200907_key.csv", "Exp3")


# Clean out the trash wells
czs1m = subset(cellzscope1, !is.na(cellzscope1$Sample) & !is.na(cellzscope1$Value))
czs2m = subset(cellzscope2, !is.na(cellzscope2$Sample) & !is.na(cellzscope2$Value))
czs3m = subset(cellzscope3, !is.na(cellzscope3$Sample) & !is.na(cellzscope3$Value))

# Resample
czs1r = vascr_resample(czs1m, 1)
czs2r = vascr_resample(czs2m, 1)
czs3r = vascr_resample(czs3m, 1)

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

xcell1r = vascr_exclude(xcell1r, wells = c("H01"))
temp = vascr_prep_graphdata(xcell1r, unit = "Z", frequency = 5000, level = "wells", normtime = 46)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())

xcell2r = vascr_exclude(xcell2r, wells = c())
temp = vascr_prep_graphdata(xcell2r, unit = "Z", frequency = 5000, level = "experiments", normtime = 46)
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


xcell3r = vascr_exclude(xcell3r, wells = c("A10", "B10", "C10", "F12", "D10", "D11", "D12", "H12", "A11", "A12", "B12"))
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


ecis1r = vascr_resample(ecis1, 1)
ecis2r = vascr_resample(ecis2, 1)
ecis3r = vascr_resample(ecis3, 1)


ecis1m = vascr_exclude(ecis1r, wells = c("H01", "H02", "D01"))
temp = vascr_prep_graphdata(ecis1m, unit = "Z", frequency = 5000, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


ecis2m = vascr_exclude(ecis2r, wells = c("H01", "H02", "H06", "D02", "D03"))
ecis2m = vascr_exclude(ecis2m, wells = c("F06", "G06", "H06", "F04", "G04", "H04", "F05", "G05", "H05", "E04", "E05", "E06", "C04", "C05", "C06", "B04", "B05", "B06", "D04", "D05", "D06", "A04", "A05", "A06"))
temp = vascr_prep_graphdata(ecis2m, unit = "Z", frequency = 5000, level = "wells")
ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())


ecis3m = vascr_exclude(ecis3r, wells = c())
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
# masterm = subset(master, master$HCMVEC == 80000)
# masterm = vascr_subset(masterm, time = c(44,75))



master = vascr_combine(vascr_remove_metadata(czs), vascr_remove_metadata(xcell), vascr_remove_metadata(ecis))
save(master, file = "masterdata.rda")

load("C:/Users/jhuc964/Desktop/ECIS R/vascr/compare/Instrument paper data/masterdata.rda")

#############################
# Fig 2
#############################

mini1 = vascr_subset(master, time = c(47), unit = "Z")
mini1 = vascr_explode(mini1)
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")

mini1a = mini1
mini1a$Sample = str_remove(mini1a$HCMVEC, ",")



mini1a = vascr_summarise(mini1a, level = "summary")
mini1a$sem = mini1a$sd / sqrt(mini1a$n)

hour47 = ggplot(mini1a) + geom_point(aes(x = Frequency, y = Value, color = Sample, shape = Instrument)) + geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Sample)) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")


mini1 = vascr_subset(master, time = c(5), unit = "Z")
mini1 = vascr_explode(mini1)
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")

mini1a = mini1
mini1a$Sample = str_remove(mini1a$HCMVEC, ",")

mini1a = vascr_summarise(mini1a, level = "summary")
mini1a$sem = mini1a$sd / sqrt(mini1a$n)

hour5 = ggplot(mini1a) + geom_point(aes(x = Frequency, y = Value, color = Sample, shape = Instrument)) + geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Sample)) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")

hour5 = hour5 + labs(title = "A) 5 Hours")
hour47 = hour47 + labs(title = "B) 47 Hours")

hour5 = hour5 + scale_color_discrete(labels = c("Media Only",expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(color = "HCMVEC Seeding Density")

hour47 = hour47 + scale_color_discrete(labels = c("Media Only",expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(color = "HCMVEC Seeding Density")

vascr_make_panel(hour5, hour47)

##########################
# Fig 3
##########################


#############################
# Fig 3
#############################

gmaster = vascr_subset(master, time = c(0,47))

mini1 = vascr_subset(gmaster, unit = "Z", frequency = c(8000, 10000))
mini1 = vascr_explode(mini1)
mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")
mini1$HCMVEC = str_remove(mini1$HCMVEC, ",")
mini1 = subset(mini1, mini1$HCMVEC>1)
mini1$Sample = mini1$HCMVEC

mini2 = vascr_subset(mini1, instrument = "ECIS")
mini2 = vascr_summarise(mini2, level = "summary")
p1 = ggplot(mini2, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p1

mini2 = vascr_subset(mini1, instrument = "cellZscope")
mini2 = vascr_summarise(mini2, level = "summary")
p2 = ggplot(mini2, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p2

mini2 = vascr_subset(mini1, instrument = "xCELLigence")
mini2 = vascr_summarise(mini2, level = "summary")
p3 = ggplot(mini2, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p3


mini3 = vascr_subset(gmaster, unit = "Rb")
mini3 = vascr_explode(mini3)
mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
mini4 = vascr_summarise(mini3, "summary")
p4 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p4

mini3 = vascr_subset(gmaster, unit = "TER")
mini3 = vascr_explode(mini3)
mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
mini4 = vascr_summarise(mini3, "summary")
p5 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p5

mini3 = vascr_subset(gmaster, unit = "Cm")
mini3 = vascr_explode(mini3)
mini3 = subset(mini3, mini3$HCMVEC >0)
mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
mini4 = vascr_summarise(mini3, "summary")
p6 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p6

mini3 = vascr_subset(gmaster, unit = "Ccl")
mini3 = vascr_explode(mini3)
mini3 = subset(mini3, mini3$HCMVEC >0)
mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
mini4 = vascr_summarise(mini3, "summary")
p7 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p7

mini3 = vascr_subset(gmaster, unit = "Alpha")
mini3 = vascr_explode(mini3)
mini3 = subset(mini3, mini3$HCMVEC >0)
mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
mini4 = vascr_summarise(mini3, "summary")
p8 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
p8

blank = vascr_plot_blank()

p1 = p1 + scale_color_discrete(labels = c(expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(color = "HCMVEC Seeding Density") + scale_fill_discrete(labels = c(expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(fill = "HCMVEC Seeding Density")
p1

g <- ggplotGrob(p1 + theme(legend.position = "left"))$grobs
legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]

title1 = text_grob("ECIS")
title2 = text_grob("cellZscope")
title3 = text_grob("xCELLigence")
title4 = text_grob("Electrical Impedance")
title5 = text_grob("Cell-cell interaction")
title6 = text_grob("Membrane capacatance")
title7 = text_grob("Basolateral adhesion")

p1 = p1+theme(legend.position = "none")
p2 = p2+theme(legend.position = "none")
p3 = p3+theme(legend.position = "none")
p4 = p4+theme(legend.position = "none")
p5 = p5+theme(legend.position = "none")
p6 = p6+theme(legend.position = "none")
p7 = p7+theme(legend.position = "none")
p8 =p8 +theme(legend.position = "none")

grid.arrange(blank, title1, title2, title3,
             title4, p1, p2, p3,
             title5, p4, p5, blank,
             title6, p6, p7, blank,
             title7, p8, blank, legend,

             widths = c(0.6, 1, 1,1),
             heights = c(0.2, 1,1,1,1)
)








# mini2 = vascr_summarise(mini1, level = "summary")
# mini2$Experiment = "NA"
# p1a = vascr_plot_cross_correlation(mini2, plot = "bar")
# 
# mini3 = vascr_remove_metadata(mini1)
# mini3 = vascr_normalise(mini3, 47, divide = TRUE)
# mini3 = vascr_prep_graphdata(mini3, unit = "Z", frequency = c(8000, 10000), level = "experiments")
# p1b = ggplot(mini3, aes(x = Time, y = Value, colour = Instrument)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Instrument), alpha = 0.3) + ylab("Impedance (Ohm)") + xlab("Time (hours)")
# 
# mini1 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
# mini1 = subset(mini1, mini1$pg.ml.TNFa == "500")
# mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")
# 
# mini2 = vascr_summarise(mini1, level = "experiments")
# mini2$Experiment = "NA"
# p2a = vascr_plot_cross_correlation(mini2, plot = "bar")
# 
# mini3 = vascr_remove_metadata(mini1)
# mini3 = vascr_normalise(mini3, 47, divide = TRUE)
# mini3 = vascr_prep_graphdata(mini3, unit = "Z", frequency = c(8000, 10000), level = "experiments")
# p2b = ggplot(mini3, aes(x = Time, y = Value, colour = Instrument)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Instrument), alpha = 0.3) + ylab("Impedance (Ohm)") + xlab("Time (hours)")
# 
# 
# mini1 = vascr_subset(masterm, unit = "Z", frequency = c(8000, 10000))
# mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
# mini1 = subset(mini1, mini1$pg.ml.IL1b == "500")
# 
# mini2 = vascr_summarise(mini1, level = "experiments")
# mini2$Experiment = "NA"
# p3a = vascr_plot_cross_correlation(mini2, plot = "bar", order = FALSE)
# 
# mini3 = vascr_remove_metadata(mini1)
# mini3 = vascr_normalise(mini3, 47, divide = TRUE)
# mini3 = vascr_prep_graphdata(mini3, unit = "Z", frequency = c(8000, 10000), level = "experiments")
# p3b = ggplot(mini3, aes(x = Time, y = Value, colour = Instrument)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Instrument), alpha = 0.3) + ylab("Impedance (Ohm)") + xlab("Time (hours)")
# 
# p1b = p1b + labs(title = "Control")
# p2b = p2b + labs(title = "500 pg/ml TNFa")
# p3b = p3b + labs(title = "500 pg/ml IL1b")
# 
# rainbow = vascr_gg_color_hue(3)
# 
# 
# p1a = p1a + scale_colour_manual(values = rainbow, aesthetics = "Treatment") + labs(title = "") + ylab("Cross Correlation Coefficent")
# p2a = p2a + scale_colour_manual(values = c(rainbow[1], rainbow[3], rainbow[2]), aesthetics = c("colour","fill"))+ labs(title = "") + ylab("Cross Correlation Coefficent")
# p3a = p3a + scale_colour_manual(values = c(rainbow[1], rainbow[3], rainbow[2]), aesthetics = c("colour","fill"))+ labs(title = "") + ylab("Cross Correlation Coefficent")
# 
# vascr_make_panel(p1b, p1a, p2b,p2a, p3b, p3a)


# CCF multiple experiments code


mini1 = vascr_subset(master, instrument = "ECIS", frequency = 8000, time = c(46, 96), unit = "Z")
mini1 = vascr_explode(mini1)
mini1$vehicle = NA
mini1 = subset(mini1, mini1$HCMVEC==20000)
p1 = make_multi_ccf(mini1, "line")
p2 = make_multi_ccf(mini1, "bar")

mini1 = vascr_subset(master, instrument = "ECIS", frequency = 8000, time = c(46, 96), unit = "Z")
mini1 = vascr_explode(mini1)
mini1$vehicle = NA
mini1 = subset(mini1, mini1$HCMVEC==80000)
p3 = make_multi_ccf(mini1, "line")
p4 = make_multi_ccf(mini1, "bar")

mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 10000, time = c(46, 96), unit = "Z")
mini1 = vascr_explode(mini1)
mini1$vehicle = NA
mini1 = subset(mini1, mini1$HCMVEC=="20,000")
p5 = make_multi_ccf(mini1, "line")
p6 = make_multi_ccf(mini1, "bar")

mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 10000, time = c(46, 96), unit = "Z")
mini1 = vascr_explode(mini1)
mini1$vehicle = NA
mini1 = subset(mini1, mini1$HCMVEC=="80,000")
p7 = make_multi_ccf(mini1, "line")
p8 = make_multi_ccf(mini1, "bar")

mini1 = vascr_subset(master, instrument = "xCELLigence", frequency = 10000, time = c(46, 96), unit = "Z")
mini1 = vascr_explode(mini1)
mini1$vehicle = NA
mini1 = subset(mini1, mini1$HCMVEC==20000)
p9 = make_multi_ccf(mini1, "line")
p10 = make_multi_ccf(mini1, "bar")

mini1 = vascr_subset(master, instrument = "xCELLigence", frequency = 10000, time = c(46, 96), unit = "Z")
mini1 = vascr_explode(mini1)
mini1$vehicle = NA
mini1 = subset(mini1, mini1$HCMVEC==80000)
p11 = make_multi_ccf(mini1, "line")
p12 = make_multi_ccf(mini1, "bar")

keygraph = p1 + theme(legend.position = "bottom") + scale_colour_discrete(name = "Treatment", labels = c("500 pg/ml IL1B","500 pg/ml TNFa",  "Control")) + scale_fill_discrete(name = "Treatment", labels = c("500 pg/ml IL1B","500 pg/ml TNFa",  "Control"))

g <- ggplotGrob(keygraph)$grobs
legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]



grid.arrange(blank, text_grob(expression(paste("62,500 cells/",cm^2))), text_grob(expression(paste("250,000 cells/",cm^2))),
             text_grob("ECIS"), p1, p2, p3, p4,
             text_grob("cellZscope"), p5, p6, p7,p8,
             text_grob("xCELLigence"), p9, p10, p11, p12,
             blank, legend,
             
             heights = c(0.1, 1, 1, 1, 0.1),
             widths = c(0.5, 1,1,1,1),
             layout_matrix = t(cbind(c(1,2,2,3,3), c(4,5,6,7,8), c(9,10,11,12,13), c(14,15,16,17,18),c(19, 20, 20, 20, 20)))
)




make_multi_ccf = function(mini1, tomake)
{
  
  mini1 = vascr_normalise(mini1, 47, TRUE)

totalexperiments = unique(mini1$Experiment)

for(experiment in totalexperiments)
{
  minidf = subset(mini1, mini1$Experiment == experiment)
  instrument = unique(minidf$Instrument)
  minidf = vascr_summarise(minidf, level = "experiments")
  minidf = vascr_explode(minidf)
  minidf = vascr_summarise_cross_correlation(minidf)
  minidf$Experiment = experiment
  minidf$Instrument = instrument
  mergedminidf = create_or_merge(mergedminidf, minidf)
}

ggplot(mergedminidf, aes(y = coeffs, x = sample)) + geom_point()

pcombinations = mergedminidf %>% group_by(sample) %>% summarise(mean = mean(coeffs), sd = sd(coeffs), n = n(), sem = sd/n, V1 = categorical_mode(V1), V2 = categorical_mode(V2))

# linedata = vascr_normalise(mini1, 48, TRUE)

linedata = mini1
linedata = vascr_summarise(linedata, level = "summary")

lineplot = ggplot(linedata, aes(x = Time, y = Value, ymax = Value + sd/n, ymin = Value - sd/n, fill = Sample, color = Sample)) + geom_line() + geom_ribbon(alpha = 0.3) + ylim(0.78, 1.1)

pcombinations$sem = pcombinations$sd / sqrt(pcombinations$n)

barplot = ggplot(pcombinations, aes(x = sample, y = mean, ymax = mean+sem, ymin = mean - sem)) + geom_errorbar(size = 2, width  = 0.6, aes(colour = V2)) + geom_point(size = 5, aes(color = V1)) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation") + xlab ("Sample")

lineplot = lineplot + theme(legend.position = "none")
barplot = barplot + theme(legend.position = "none")


if(tomake == "line")
{
  return(lineplot)
}
else
{
  return(barplot)
}

}


# #############################
# # Fig 4
# #############################
# 
# fig4 = function(data.df, instrument, unit, frequency, subfig)
# {
#   mini1 = vascr_subset(data.df, instrument = instrument)
#   mini1 = vascr_remove_metadata(mini1)
#   mini1 = vascr_normalise(mini1, 47, divide = TRUE)
#   mini1 = vascr_explode(mini1)
#   mini2 = vascr_prep_graphdata(mini1, unit = unit, frequency = frequency, level = "experiments")
#   mini2$Sample = trimws(gsub("\\+", "", mini2$Sample))
#   mini2$Sample[mini2$Sample==""] = "Control"
#   a = ggplot(mini2, aes(x = Time, y = Value, colour = Sample)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Sample), alpha = 0.3) + theme(legend.position = "none") + ylab("Impedance (Ohm)") + xlab("Time (hours)") + ylim(0.9, 1.1)
#   
#   mini3 = vascr_subset(mini1, unit = unit, frequency = 4000)
#   mini3 = vascr_summarise_experiments(mini3)
#   mini3 = vascr_explode(mini3)
#   mini3$Well = "NA"
#   
#   b = vascr_plot_cross_correlation(mini3, plot = "bar") + labs(y = "Cross Correlation Coefficent") + theme(legend.position = "none")
#   
#   if(subfig == "a")
#   {
#     return(a)
#   }
#   else
#   {
#     return(b)
#   }
# }
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
# #############################
# # Fig
# ############################


data10 = vascr_subset(masterm, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), instrument = c("ECIS", "xCELLigence"))
data10 = subset(data10, data10$pg.ml.TNFa == "NA")
data10 = subset(data10, data10$pg.ml.IL1b == "NA")

data10$Experiment = "NA"
data12 = vascr_summarise(data10, level = "experiments")

data13 = vascr_summarise_cross_correlation(data12, reference = "[ Z Unit | 10000 Hz | xCELLigence Instrument ]")
hue = vascr_gg_color_hue(5)
p9a = ggplot(data13, aes(x = sample, y = coeffs, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation Coefficent") + xlab("")  + scale_fill_manual(values = c(hue[1], hue[2], hue[3], hue[4]))

data11 = vascr_normalise(data10, 45, divide = TRUE)
data11 = vascr_prep_graphdata(data11, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), level = "experiments")

data11$Measurement = paste(data11$Unit, data11$Instrument)

p9b = ggplot(data11, aes(x = Time, y = Value, colour = Measurement)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = Measurement), alpha = 0.3) + ylab("Unit Value") + xlab("Time (hours)")



data10 = vascr_subset(masterm, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), instrument = c("ECIS", "xCELLigence"))
data10 = subset(data10, data10$pg.ml.TNFa == "500")
data10 = subset(data10, data10$pg.ml.IL1b == "NA")

data10$Experiment = "NA"
data12 = vascr_summarise(data10, level = "experiments")

data13 = vascr_summarise_cross_correlation(data12, reference = "[ Z Unit | 10000 Hz | xCELLigence Instrument ]")
hue = vascr_gg_color_hue(5)
p10a = ggplot(data13, aes(x = sample, y = coeffs, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation Coefficent")+ xlab("")  + scale_fill_manual(values = c(hue[1], hue[2], hue[3], hue[4]))

data11 = vascr_normalise(data10, 45, divide = TRUE)
data11 = vascr_prep_graphdata(data11, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), level = "experiments")

data11$pairity = paste(data11$Unit, data11$Instrument)

p10b = ggplot(data11, aes(x = Time, y = Value, colour = pairity)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = pairity), alpha = 0.3) + ylab("Unit Value") + xlab("Time (hours)")




data10 = vascr_subset(masterm, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), instrument = c("ECIS", "xCELLigence"))
data10 = subset(data10, data10$pg.ml.TNFa == "NA")
data10 = subset(data10, data10$pg.ml.IL1b == "500")

data10$Experiment = "NA"
data12 = vascr_summarise(data10, level = "experiments")

vascr_summarise_cross_correlation(data12)

data13 = vascr_summarise_cross_correlation(data12, reference = "[ Z Unit | 10000 Hz | xCELLigence Instrument ]")
hue = vascr_gg_color_hue(5)
p11a = ggplot(data13, aes(x = sample, y = coeffs, fill = V1)) + geom_col(size = 2, width = 0.8) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation Coefficent")+ xlab("")  + scale_fill_manual(values = c(hue[1], hue[2], hue[3], hue[4]))

data11 = vascr_normalise(data10, 45, divide = TRUE)
data11 = vascr_prep_graphdata(data11, unit = c("Rb", "Alpha", "Cm", "Z"), frequency = c(0,8000,10000), level = "experiments")

data11$pairity = paste(data11$Unit, data11$Instrument)

p11b = ggplot(data11, aes(x = Time, y = Value, colour = pairity)) + geom_line() + geom_ribbon(aes(ymax = Value + sd, ymin = Value-sd, fill = pairity), alpha = 0.3)+ ylab("Unit Value") + xlab("Time (hours)")


p9b = p9b + labs(title = "Control")
p10b = p10b + labs(title = "500 pg/ml TNFa")
p11b = p11b + labs(title = "500 pg/ml IL1B")

vascr_make_panel(p9b, p9a, p10b, p10a, p11b, p11a)


play = vascr_subset(masterm, instrument = "CellZScope")
unique(play$Frequency)
play = vascr_subset(masterm, instrument = "ECIS")
unique(play$Frequency)


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


}


