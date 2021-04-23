# blankfn = function()
# {
# 
# setwd("C:/Users/jhuc964/Desktop/ECIS R/vascr/compare/Instrument paper data")
# library(tidyverse)
# library(vascr)
# library(plotly)
# library(grid)
# library(gridExtra)
# library(ggpubr)
# devtools::load_all()
# 
# 
# # CellZScope
# cellzscope1 = cellzscope_import("CellZScope/200722_raw.txt", "CellZScope/200722_model.txt", "CellZScope/200722_key.csv", "Exp1")
# 
# cellzscope2 = cellzscope_import("CellZScope/200728_raw.txt", "CellZScope/200728_model.txt", "CellZScope/200728_key.csv", "Exp2")
# 
# cellzscope3 = cellzscope_import("CellZScope/200907_raw.txt", "CellZScope/200907_model.txt", "CellZScope/200907_key.csv", "Exp3")
# 
# 
# # Clean out the trash wells
# czs1m = subset(cellzscope1, !is.na(cellzscope1$Sample) & !is.na(cellzscope1$Value))
# czs2m = subset(cellzscope2, !is.na(cellzscope2$Sample) & !is.na(cellzscope2$Value))
# czs3m = subset(cellzscope3, !is.na(cellzscope3$Sample) & !is.na(cellzscope3$Value))
# 
# # Resample
# czs1r = vascr_resample(czs1m, 1)
# czs2r = vascr_resample(czs2m, 1)
# czs3r = vascr_resample(czs3m, 1)
# 
# # Data cleaning
# czs1 = vascr_exclude(czs1r, wells = c("B06", "C06", "A06", "C05", "D02"))
# temp = vascr_prep_graphdata(czs1, unit = "R", frequency = 4000, level = "wells")
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# czs2 = vascr_exclude(czs2r, wells = c("D02", "B06"))
# temp = vascr_prep_graphdata(czs2, unit = "TER", frequency = 0, level = "wells")
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# czs3 = vascr_exclude(czs3r, wells = c("D02"))
# temp = vascr_prep_graphdata(czs3, unit = "TER", frequency = 0, level = "wells")
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# # Combine datasets
# czs = vascr_combine(czs1, czs2, czs3)
# 
# temp = vascr_prep_graphdata(czs, unit = "R", frequency = 4000, level = "experiments", normtime = 44)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, linetype = Experiment)) + geom_line())
# 
# temp = vascr_prep_graphdata(czs, unit = "TER", frequency = 0, level = "summary", normtime = 44)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, ymax = ymax, ymin = ymin)) + geom_line() + geom_ribbon(alpha = 0.3))
# 
# # //////////////////////////////////////////////////////////////////////////
# 
# # xCELLigence
# xcell1 = import_xcelligence("xcelligence/200722.plt", 'xcelligence/200722_key.csv', "Exp1")
# xcell2 = import_xcelligence("xcelligence/200728.plt", 'xcelligence/200728_key.csv', "Exp2")
# xcell3 = import_xcelligence("xcelligence/200907.plt", 'xcelligence/200907_key.csv', "Exp3")
# 
# 
# # Data cleaning
# xcell1m = subset(xcell1, xcell1$Value>10^-5)
# xcell2m = subset(xcell2, xcell2$Value>10^-5)
# xcell3m = subset(xcell3, xcell3$Value>10^-5)
# 
# xcell1m = subset(xcell1m, !is.na(xcell1m$Sample))
# xcell2m = subset(xcell2m, !is.na(xcell2m$Sample))
# xcell3m = subset(xcell3m, !is.na(xcell3m$Sample))
# 
# xcell1m = vascr_subset(xcell1m, unit = "Z")
# xcell2m = vascr_subset(xcell2m, unit = "Z")
# xcell3m = vascr_subset(xcell3m, unit = "Z")
# 
# xcell1r = vascr_resample(xcell1m, 1)
# xcell2r = vascr_resample(xcell2m, 1)
# xcell3r = vascr_resample(xcell3m, 1)
# 
# xcell1r = vascr_exclude(xcell1r, wells = c("H01"))
# temp = vascr_prep_graphdata(xcell1r, unit = "Z", frequency = 5000, level = "wells", normtime = 46)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# xcell2r = vascr_exclude(xcell2r, wells = c())
# temp = vascr_prep_graphdata(xcell2r, unit = "Z", frequency = 5000, level = "experiments", normtime = 46)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# 
# xcell3r = vascr_exclude(xcell3r, wells = c("A10", "B10", "C10", "F12", "D10", "D11", "D12", "H12", "A11", "A12", "B12"))
# temp = vascr_prep_graphdata(xcell3r, unit = "Z", frequency = 5000, level = "wells", normtime=46)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# 
# xcell = vascr_combine(xcell1r, xcell2r)
# temp = vascr_prep_graphdata(xcell, unit = "Z", frequency = 0, level = "experiments", normtime = 44)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample)) + geom_line(aes(linetype = Experiment)))
# 
# temp = vascr_prep_graphdata(xcell, unit = "Z", frequency = 0, level = "summary", normtime = 44)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, ymax = ymax, ymin = ymin)) + geom_line() + geom_ribbon(alpha = 0.3))
# 
# #////////////////////////////////////////////////
# # ECIS
# 
# ecis1 = ecis_import("ECIS/ECIS_200722_MFT_1.abp", "ECIS/ECIS_200722_MFT_1_RbA.csv", "ECIS/200722_key.csv", "Exp1")
# ecis2 = ecis_import("ECIS/ECIS_200728_MFT_1.abp", "ECIS/ECIS_200728_MFT_1_RbA.csv", "ECIS/200728_key.csv", "Exp2")
# ecis3 = ecis_import("ECIS/ECIS_200907_MFT_1.abp", "ECIS/ECIS_200907_MFT_1_RbA.csv", "ECIS/200907_key.csv", "Exp3")
# 
# 
# ecis1r = vascr_resample(ecis1, 1)
# ecis2r = vascr_resample(ecis2, 1)
# ecis3r = vascr_resample(ecis3, 1)
# 
# 
# ecis1m = vascr_exclude(ecis1r, wells = c("H01", "H02", "D01"))
# temp = vascr_prep_graphdata(ecis1m, unit = "Z", frequency = 5000, level = "wells")
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# 
# ecis2m = vascr_exclude(ecis2r, wells = c("H01", "H02", "H06", "D02", "D03"))
# ecis2m = vascr_exclude(ecis2m, wells = c("F06", "G06", "H06", "F04", "G04", "H04", "F05", "G05", "H05", "E04", "E05", "E06", "C04", "C05", "C06", "B04", "B05", "B06", "D04", "D05", "D06", "A04", "A05", "A06"))
# temp = vascr_prep_graphdata(ecis2m, unit = "Z", frequency = 5000, level = "wells")
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# 
# ecis3m = vascr_exclude(ecis3r, wells = c())
# ecis3m = subset(ecis3m, ecis3m$Sample != "NA")
# temp = vascr_prep_graphdata(ecis3m, unit = "Z", frequency = 5000, level = "wells")
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line())
# 
# 
# # Combine experiments and check it works
# ecis = vascr_combine(ecis1m, ecis2m, ecis3m)
# 
# temp = vascr_prep_graphdata(ecis, unit = "Z", frequency = 5000, level = "experiments", normtime = 44)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample)) + geom_line(aes(linetype = Experiment)))
# 
# temp = vascr_prep_graphdata(ecis, unit = "R", frequency = 4000, level = "summary", normtime = 44)
# ggplotly(ggplot(temp, aes(x = Time, y = Value, color = Sample, fill = Sample, ymax = ymax, ymin = ymin)) + geom_line() + geom_ribbon(alpha = 0.3))
# 
# 
# 
# # ecis1m = subset(ecis1m, select = -c(`NA`) )
# # master = vascr_combine(xcell1r, ecis1m, czs1)
# # master$HCMVEC = gsub(",", "", master$HCMVEC)
# # master$HCMVEC = as.numeric(master$HCMVEC)
# # 
# # 
# # masterm = subset(master, master$HCMVEC == 80000)
# # masterm = vascr_subset(masterm, time = c(44,75))
# 
# 
# 
# master = vascr_combine(vascr_remove_metadata(czs), vascr_remove_metadata(xcell), vascr_remove_metadata(ecis))
# save(master, file = "masterdata.rda")
# 
# load("C:/Users/jhuc964/Desktop/ECIS R/vascr/compare/Instrument paper data/masterdata.rda")
# 
# #############################
# # Fig 2
# #############################
# 
# mini1 = vascr_subset(master, time = c(47), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
# mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")
# 
# mini1a = mini1
# mini1a$Sample = str_remove(mini1a$HCMVEC, ",")
# 
# 
# 
# mini1a = vascr_summarise(mini1a, level = "summary")
# mini1a$sem = mini1a$sd / sqrt(mini1a$n)
# 
# hour47 = ggplot(mini1a) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = Sample), size = 3) + geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Instrument)) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# mini1 = vascr_subset(master, time = c(5), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
# mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")
# 
# mini1a = mini1
# mini1a$Sample = str_remove(mini1a$HCMVEC, ",")
# 
# mini1a = vascr_summarise(mini1a, level = "summary")
# mini1a$sem = mini1a$sd / sqrt(mini1a$n)
# 
# hour5 = ggplot(mini1a) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = Sample), size = 3) + geom_errorbar(aes(x = Frequency, y = Value, ymin=Value - sem, ymax= Value + sem, color = Instrument)) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# 
# 
# 
# hour5 = hour5 + labs(title = "A) 5 Hours")
# hour47 = hour47 + labs(title = "B) 47 Hours")
# 
# # hour5 = hour5 + scale_shape_manual(values = c(16,3,1)) + scale_size_manual(values = c(3,3,3))
# # hour47 = hour47 + scale_shape_manual(values = c(16,3,1)) + scale_size_manual(values = c(3,3,3))
# 
# hour5 = hour5 + scale_shape_manual(values = c(16,3,1), name = "HCMVEC Seeding Density:  ",labels = c("Media Only",expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + scale_color_discrete(name = "Instrument:  ")
# 
# hour47 = hour47 + scale_shape_manual(values = c(16,3,1), name = "HCMVEC Seeding Density:  ", labels = c("Media Only",expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(Sample = "HCMVEC Seeding Density") + scale_color_discrete(name = "Instrument:  ")
# 
# 
# 
# 
# 
# #grid.arrange(hour5 + theme(legend.position = "none"), hour47 + theme(legend.position = "none"), get_legend(hour47), ncol = 2, layout_matrix = rbind(c(1,3), c(2,3)), widths = c(3, 1))
# 
# ledgend = get_legend(hour47+ theme(legend.position = "bottom", legend.box="vertical", legend.margin = margin()) )
# 
# grid.arrange(hour5 + theme(legend.position = "none"), hour47 + theme(legend.position = "none"), ledgend , ncol = 1, heights = c(1,1,0.4))
# 
# 
# 
# 
# #############################
# # Fig 3
# #############################
# 
# gmaster = vascr_subset(master, time = c(0,47))
# 
# mini1 = vascr_subset(gmaster, unit = "Z", frequency = c(8000, 10000))
# mini1 = vascr_explode(mini1)
# mini1 = subset(mini1, mini1$pg.ml.TNFa == "NA")
# mini1 = subset(mini1, mini1$pg.ml.IL1b == "NA")
# mini1$HCMVEC = str_remove(mini1$HCMVEC, ",")
# mini1 = subset(mini1, mini1$HCMVEC>1)
# mini1$Sample = mini1$HCMVEC
# 
# mini2 = vascr_subset(mini1, instrument = "ECIS")
# mini2 = vascr_summarise(mini2, level = "summary")
# p1 = ggplot(mini2, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p1
# 
# mini2 = vascr_subset(mini1, instrument = "cellZscope")
# mini2 = vascr_summarise(mini2, level = "summary")
# p2 = ggplot(mini2, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p2
# 
# mini2 = vascr_subset(mini1, instrument = "xCELLigence")
# mini2 = vascr_summarise(mini2, level = "summary")
# p3 = ggplot(mini2, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p3
# 
# 
# mini3 = vascr_subset(gmaster, unit = "Rb")
# mini3 = vascr_explode(mini3)
# mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
# mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
# mini4 = vascr_summarise(mini3, "summary")
# p4 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p4
# 
# mini3 = vascr_subset(gmaster, unit = "TER")
# mini3 = vascr_explode(mini3)
# mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
# mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
# mini4 = vascr_summarise(mini3, "summary")
# p5 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p5
# 
# mini3 = vascr_subset(gmaster, unit = "Cm")
# mini3 = vascr_explode(mini3)
# mini3 = subset(mini3, mini3$HCMVEC >0)
# mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
# mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
# mini4 = vascr_summarise(mini3, "summary")
# p6 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p6
# 
# mini3 = vascr_subset(gmaster, unit = "Ccl")
# mini3 = vascr_explode(mini3)
# mini3 = subset(mini3, mini3$HCMVEC >0)
# mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
# mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
# mini4 = vascr_summarise(mini3, "summary")
# p7 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p7
# 
# mini3 = vascr_subset(gmaster, unit = "Alpha")
# mini3 = vascr_explode(mini3)
# mini3 = subset(mini3, mini3$HCMVEC >0)
# mini3 = subset(mini3, mini3$pg.ml.TNFa == "NA")
# mini3 = subset(mini3, mini3$pg.ml.IL1b == "NA")
# mini4 = vascr_summarise(mini3, "summary")
# p8 = ggplot(mini4, aes(y = Value, x = Time, colour = Sample, ymax = Value + sd/sqrt(n), ymin = Value - sd/sqrt(n), fill = Sample)) + geom_line() + geom_ribbon(alpha = 0.3)
# p8
# 
# blank = vascr_plot_blank()
# 
# p1 = p1 + scale_color_discrete(labels = c(expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(color = "HCMVEC Seeding Density") + scale_fill_discrete(labels = c(expression(paste("62,500 cells/",cm^2)),expression(paste("250,000 cells/",cm^2))))+ theme(legend.text.align = 0) + labs(fill = "HCMVEC Seeding Density")
# p1
# 
# g <- ggplotGrob(p1 + theme(legend.position = "left"))$grobs
# legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
# 
# title1 = text_grob("ECIS")
# title2 = text_grob("cellZscope")
# title3 = text_grob("xCELLigence")
# title4 = text_grob("Electrical Impedance")
# title5 = text_grob("Cell-cell interaction")
# title6 = text_grob("Membrane capacatance")
# title7 = text_grob("Basolateral adhesion")
# 
# p1 = p1+theme(legend.position = "none") + ylab(vascr_titles("Z", "8,000")) + xlab("Time (hours)")
# p2 = p2+theme(legend.position = "none")+ ylab(vascr_titles("Z", "10,000")) + xlab("Time (hours)")
# p3 = p3+theme(legend.position = "none")+ ylab(vascr_titles("Z", "10,000")) + xlab("Time (hours)")
# p4 = p4+theme(legend.position = "none")+ ylab(vascr_titles("Rb")) + xlab("Time (hours)")
# p5 = p5+theme(legend.position = "none")+ ylab(vascr_titles("TER")) + xlab("Time (hours)")
# p6 = p6+theme(legend.position = "none")+ ylab(vascr_titles("Cm")) + xlab("Time (hours)")
# p7 = p7+theme(legend.position = "none")+ ylab(vascr_titles("Ccl")) + xlab("Time (hours)")
# p8 = p8 +theme(legend.position = "none")+ ylab(vascr_titles("Alpha")) + xlab("Time (hours)")
# 
# grid.arrange(blank, title1, title2, title3,
#              title4, p1, p2, p3,
#              title5, p4, p5, blank,
#              title6, p6, p7, blank,
#              title7, p8, blank, legend,
#              
#              widths = c(0.6, 1, 1,1),
#              heights = c(0.2, 1,1,1,1)
# )
# 
# 
# 
# 
# 
# # Figure showing sensitivity to TNF at different densities
# 
# make_multi_ccf = function(mini1, tomake)
# {
#   
#   mini1 = vascr_normalise(mini1, 47, TRUE)
#   
#   totalexperiments = unique(mini1$Experiment)
#   
#   rm(mergedminidf)
#   
#   for(experiment in totalexperiments)
#   {
#     minidf = subset(mini1, mini1$Experiment == experiment)
#     instrument = unique(minidf$Instrument)
#     minidf = vascr_summarise(minidf, level = "experiments")
#     minidf = vascr_explode(minidf)
#     minidf = vascr_summarise_cross_correlation(minidf)
#     minidf$Experiment = experiment
#     minidf$Instrument = instrument
#     mergedminidf = create_or_merge(mergedminidf, minidf)
#   }
#   
#   ggplot(mergedminidf, aes(y = coeffs, x = sample)) + geom_point()
#   
#   pcombinations = mergedminidf %>% group_by(sample) %>% summarise(mean = mean(coeffs), sd = sd(coeffs), n = n(), sem = sd/n, V1 = categorical_mode(V1), V2 = categorical_mode(V2))
#   
#  pcombinations$sample = str_replace_all(pcombinations$sample, "pg.ml", "pg/ml")
#  pcombinations$sample =   str_replace_all(pcombinations$sample, "[.]", " ")
#  
#  pcombinations$sample = str_replace_all(pcombinations$sample, "TNFa", "TNF\U03B1")
#  pcombinations$sample = str_replace_all(pcombinations$sample, "IL1b", "IL1\U03B2")
#  
#   # linedata = vascr_normalise(mini1, 48, TRUE)
#   
#   linedata = mini1
#   linedata = vascr_summarise(linedata, level = "summary")
#   
#   lineplot = ggplot(linedata, aes(x = Time, y = Value, ymax = Value + sd/n, ymin = Value - sd/n, fill = Sample, color = Sample)) + geom_line() + geom_ribbon(alpha = 0.3) + ylim(0.78, 1.1)
#   
#   pcombinations$sem = pcombinations$sd / sqrt(pcombinations$n)
#   
#   barplot = ggplot(pcombinations, aes(x = sample, y = mean, ymax = mean+sem, ymin = mean - sem)) + geom_errorbar(size = 0.8 , width  = 0.6, aes(colour = V1)) + geom_point(size = 5, aes(color = V2)) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation") + xlab ("Sample") + scale_color_manual(values = c(vascr_gg_color_hue(3)[2], vascr_gg_color_hue(3)[1], vascr_gg_color_hue(3)[3]))
#   
#   lineplot = lineplot + theme(legend.position = "none")
#   barplot = barplot + theme(legend.position = "none")
#   
#   
#   if(tomake == "line")
#   {
#     return(lineplot)
#   }
#   else
#   {
#     return(barplot)
#   }
#   
# }
# 
# mini1 = vascr_subset(master, instrument = "ECIS", frequency = 8000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==20000)
# p1 = make_multi_ccf(mini1, "line")
# p2 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "ECIS", frequency = 8000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==80000)
# p3 = make_multi_ccf(mini1, "line")
# p4 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 10000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC=="20,000")
# p5 = make_multi_ccf(mini1, "line")
# p6 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 10000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC=="80,000")
# p7 = make_multi_ccf(mini1, "line")
# p8 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "xCELLigence", frequency = 10000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==20000)
# p9 = make_multi_ccf(mini1, "line")
# p10 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "xCELLigence", frequency = 10000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==80000)
# p11 = make_multi_ccf(mini1, "line")
# p12 = make_multi_ccf(mini1, "bar")
# 
# 
# verticalline = geom_vline(aes(xintercept = c(47), linetype=""), color = "orange")
# 
#   
#   p1 + ylab("Normalised Impedance \n (Ohm, 8,000 Hz)") + xlab("Time (hours)") + verticalline + theme(legend.position = "bottom")  + scale_linetype(name = "Treatment Time:  ") 
# 
#   p1 = p3 + ylab("Normalised Impedance \n (Ohm, 8,000 Hz)") + xlab("Time (hours)") + verticalline
# p3 = p3 + ylab("Normalised Impedance \n (Ohm, 8,000 Hz)") + xlab("Time (hours)") + verticalline
# p5 = p5 + ylab("Normalised Impedance \n (Ohm, 10,000 Hz)") + xlab("Time (hours)") + verticalline
# p7 = p7 + ylab("Normalised Impedance \n (Ohm, 10,000 Hz)") + xlab("Time (hours)") + verticalline
# p9 = p9 + ylab("Normalised Impedance \n (Ohm, 10,000 Hz)") + xlab("Time (hours)") + verticalline
# p11 = p11 + ylab("Normalised Impedance \n (Ohm, 10,000 Hz)") + xlab("Time (hours)") + verticalline
# 
# 
# 
# keygraph = p1 + theme(legend.position = "bottom") + 
#   scale_colour_discrete(name = "Treatment:  ", labels = c(expression(paste(" 500 pg/ml TNF",alpha)),expression(paste(" 500 pg/ml IL1",beta)), "Control")) + 
#   scale_fill_discrete(name = "Treatment:  ", labels = c(expression(paste(" 500 pg/ml TNF",alpha)),expression(paste(" 500 pg/ml IL1",beta)),  "Control")) + scale_linetype(name = "Treatment Time:  ") 
# 
# 
# g <- ggplotGrob(keygraph)$grobs
# legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
# 
# 
# grid.arrange(blank, text_grob(expression(paste("62,500 cells/",cm^2))), text_grob(expression(paste("250,000 cells/",cm^2))),
#              text_grob("ECIS"), p1, p2, p3, p4,
#              text_grob("cellZscope"), p5, p6, p7,p8,
#              text_grob("xCELLigence"), p9, p10, p11, p12,
#              blank, legend,
#              
#              heights = c(0.1, 1, 1, 1, 0.1),
#              widths = c(0.5, 1,1,1,1),
#              layout_matrix = t(cbind(c(1,2,2,3,3), c(4,5,6,7,8), c(9,10,11,12,13), c(14,15,16,17,18),c(19, 20, 20, 20, 20)))
# )
# 
# 
# 
# 
# 
# 
# 
# 
# # Figuure showing power of modeling
# 
# overallylim = ylim(0.65, 1.45)
# 
# mini1 = vascr_subset(master, instrument = "ECIS", frequency = 8000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==20000)
# p1 = make_multi_ccf(mini1, "line") + overallylim
# p2 = make_multi_ccf(mini1, "bar")
# 
# 
# mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 10000, time = c(46, 96), unit = "Z")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC=="20,000")
# p3 = make_multi_ccf(mini1, "line") + overallylim
# p4 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "ECIS", frequency = 0 , time = c(46, 96), unit = "Rb")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==20000)
# p5 = make_multi_ccf(mini1, "line") + overallylim
# p6 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 0 , time = c(46, 96), unit = "TER")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC=="20,000")
# p7 = make_multi_ccf(mini1, "line") + overallylim
# p8 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "ECIS", frequency = 0 , time = c(46, 96), unit = "Cm")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC==20000)
# p9 = make_multi_ccf(mini1, "line") + overallylim
# p10 = make_multi_ccf(mini1, "bar")
# 
# mini1 = vascr_subset(master, instrument = "cellZscope", frequency = 0 , time = c(46, 96), unit = "Ccl")
# mini1 = vascr_explode(mini1)
# mini1$vehicle = NA
# mini1 = subset(mini1, mini1$HCMVEC=="20,000")
# p11 = make_multi_ccf(mini1, "line") + overallylim
# p12 = make_multi_ccf(mini1, "bar")
# 
# 
# 
# 
# 
# 
# # keygraph = p1 + theme(legend.position = "bottom") + scale_colour_discrete(name = "Treatment", labels = c("500 pg/ml IL1B","500 pg/ml TNFa",  "Control")) + scale_fill_discrete(name = "Treatment", labels = c("500 pg/ml IL1B","500 pg/ml TNFa",  "Control"))
# # 
# # verticalline = geom_vline(xintercept = 47, linetype="dashed", color = "orange")
# # 
# # g <- ggplotGrob(keygraph)$grobs
# # legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
# 
# p1 = p1 + ylab(vascr_titles("Z", frequency = "8,000", prefix = "Normalised")) + xlab("Time (hours)") + verticalline
# p3 = p3 + ylab(vascr_titles("Z", frequency = "10,000", prefix = "Normalised"))  + xlab("Time (hours)") + verticalline
# p5 = p5 + ylab(vascr_titles("Rb", prefix = "Normalised"))  + xlab("Time (hours)") + verticalline
# p7 = p7 + ylab(vascr_titles("TER", prefix = "Normalised"))  + xlab("Time (hours)") + verticalline
# p9 = p9 + ylab(vascr_titles("Cm", prefix = "Normalised"))  + xlab("Time (hours)") + verticalline
# p11 = p11 + ylab(vascr_titles("Ccl", prefix = "Normalised")) + xlab("Time (hours)") + verticalline
# 
# 
# 
# # Fix up the titles on this one
# 
# 
# grid.arrange(blank, text_grob("ECIS"), text_grob("cellZscope"),
#              text_grob("Overall Impedance"), p1, p2, p3, p4,
#              text_grob("Cell-cell interaction"), p5, p6, p7,p8,
#              text_grob("Membrane\ncapacatance"), p9, p10, p11, p12,
#              blank, legend,
#              
#              heights = c(0.1, 1, 1, 1, 0.1),
#              widths = c(0.5, 1,1,1,1),
#              layout_matrix = t(cbind(c(1,2,2,3,3), c(4,5,6,7,8), c(9,10,11,12,13), c(14,15,16,17,18),c(19, 20, 20, 20, 20)))
# )
# 
# 
# 
# 
# 
# 
# mini1a = vascr_subset(master, instrument = "ECIS", frequency = 0 , time = c(46, 96), unit = "Rb")
# mini1b = vascr_subset(master, instrument = "ECIS", frequency = 0 , time = c(46, 96), unit = "Alpha")
# mini1e = vascr_subset(master, instrument = "ECIS", frequency = 0 , time = c(46, 96), unit = "Cm")
# mini1c = vascr_subset(master, instrument = "ECIS", frequency = 8000 , time = c(46, 96), unit = "Z")
# mini1d = vascr_subset(master, instrument = "xCELLigence", frequency = 10000 , time = c(46, 96), unit = "Z")
# 
# mini1 = rbind(mini1a, mini1b, mini1c, mini1d, mini1e)
# 
# mini1$Experiment = as.character(mini1$Experiment)
# unique(mini1$Experiment)
# 
# mini1$Experiment = str_replace(mini1$Experiment, "3 : 1 : 1 : ECIS_200722_MFT_1_RbA.csv", "0722")
# mini1$Experiment = str_replace(mini1$Experiment,"3 : 2 : 1 : ECIS_200728_MFT_1_RbA.csv", "0728")
# mini1$Experiment = str_replace(mini1$Experiment,"3 : 3 : 1 : ECIS_200907_MFT_1_RbA.csv", "0907")
# mini1$Experiment = str_replace(mini1$Experiment,"3 : 1 : 2 : ECIS_200722_MFT_1.abp", "0722")
# mini1$Experiment = str_replace(mini1$Experiment,"3 : 2 : 2 : ECIS_200728_MFT_1.abp", "0728")
# mini1$Experiment = str_replace(mini1$Experiment,"3 : 3 : 2 : ECIS_200907_MFT_1.abp", "0907")
# mini1$Experiment = str_replace(mini1$Experiment,"2 : 1 : Exp1", "0722")
# mini1$Experiment = str_replace(mini1$Experiment,"2 : 2 : Exp2", "0728")
# 
# mini1 = subset(mini1, mini1$Experiment != "0907")
# 
# mini1master = mini1
# 
# 
# mini1 = vascr_explode(mini1master)
# mini1$vehicle = NA
# mini1 = subset(mini1, is.na(as.numeric(mini1$pg.ml.TNFa)))
# mini1 = subset(mini1, is.na(as.numeric(mini1$pg.ml.IL1b)))
# mini1 = subset(mini1, mini1$HCMVEC=="20,000" | mini1$HCMVEC == 20000)
# 
# p1 = make_multi_ccf_changeinstrument(mini1, "line")
# p2 = make_multi_ccf_changeinstrument(mini1, "bar")
# 
# 
# 
# mini1 = vascr_explode(mini1master)
# mini1$vehicle = NA
# mini1 = subset(mini1, (as.numeric(mini1$pg.ml.TNFa) == 500))
# mini1 = subset(mini1, is.na(as.numeric(mini1$pg.ml.IL1b)))
# mini1 = subset(mini1, mini1$HCMVEC=="20,000" | mini1$HCMVEC == 20000)
# 
# p3 = make_multi_ccf_changeinstrument(mini1, "line")
# p4 = make_multi_ccf_changeinstrument(mini1, "bar")
# 
# 
# 
# 
# mini1 = vascr_explode(mini1master)
# mini1$vehicle = NA
# mini1 = subset(mini1, (as.numeric(mini1$pg.ml.IL1b) == 500))
# mini1 = subset(mini1, is.na(as.numeric(mini1$pg.ml.TNFa)))
# mini1 = subset(mini1, mini1$HCMVEC=="20,000" | mini1$HCMVEC == 20000)
# 
# p5 = make_multi_ccf_changeinstrument(mini1, "line")
# p6 = make_multi_ccf_changeinstrument(mini1, "bar")
# 
# labellist = c("[ Alpha | ECIS ]", "[ Cm | ECIS ]", "[ Rb | ECIS ]", "[ Z | 10000 Hz | xCELLigence ]", "[ Z | 8000 Hz | ECIS ]")
# keygraph = p2 + theme(legend.position = "bottom") + scale_colour_discrete(name = "Treatment", labels = labellist) + scale_fill_discrete(name = "Treatment", labels = labellist)
# 
# g <- ggplotGrob(keygraph)$grobs
# legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
# 
# collist = c(vascr_gg_color_hue(5)[5], vascr_gg_color_hue(5)[1],vascr_gg_color_hue(5)[2],vascr_gg_color_hue(5)[3],vascr_gg_color_hue(5)[4])
# 
# p1 = p1+ labs(title = "A) Control") + scale_color_manual(values = collist) + scale_fill_manual(values = collist)
# p3 = p3+ labs(title = "B) 500 pg/ml TNF\U03B1") + scale_color_manual(values = collist) + scale_fill_manual(values = collist)
# p5 = p5+ labs(title = "C) 500 pg/ml IL1\U03B2") + scale_color_manual(values = collist) + scale_fill_manual(values = collist)
# 
# grid.arrange(p1, p2, p3, p4, p5, p6, legend, heights = c(1,1,1,0.2), layout_matrix = t(cbind(c(1,2), c(3,4), c(5,6), c(7,7))))
# 
# 
# 
# make_multi_ccf_changeinstrument = function(mini1, tomake)
# {
#   
#   mini1 = vascr_normalise(mini1, 47, TRUE)
#   
#   totalexperiments = unique(mini1$Experiment)
#   rm(mergedminidf)
#   
#   for(experiment in totalexperiments)
#   {
#     minidf = subset(mini1, mini1$Experiment == experiment)
#     minidf = vascr_summarise(minidf, level = "experiments")
#     minidf = vascr_explode(minidf)
#     minidf = vascr_summarise_cross_correlation(minidf)
#     minidf$Experiment = experiment
#     mergedminidf = create_or_merge(mergedminidf, minidf)
#   }
#   
#   ggplotly(ggplot(mergedminidf, aes(y = coeffs, x = sample)) + geom_point())
#   
#   unique(mergedminidf$sample)
#   
#   mergedminidf = subset(mergedminidf, mergedminidf$V1 == "[ Z Unit | 10000 Frequency | xCELLigence Instrument ]" | mergedminidf$V2 == "[ Z Unit | 10000 Frequency | xCELLigence Instrument ]")
#   
#   ggplotly(ggplot(mergedminidf, aes(y = coeffs, x = sample)) + geom_point())
#   
#   # mergedminidf$sample = str_replace(mergedminidf$sample, "\\[ Rb  \\]" , "[ Rb  | ECIS  ]" )
#   # mergedminidf$sample = str_replace(mergedminidf$sample, "\\[ Alpha  \\]" , "[ Alpha  | ECIS  ]" )
#   
#   pcombinations = mergedminidf %>% group_by(sample) %>% summarise(mean = mean(coeffs), sd = sd(coeffs), n = n(), sem = sd/n, V1 = categorical_mode(V1), V2 = categorical_mode(V2))
#   
#   # linedata = vascr_normalise(mini1, 48, TRUE)
#   
#   linedata = mini1
#   linedata$Sample = vascr_make_name(mini1, select_cols = c("Instrument", "Frequency", "Unit"))
#   linedata = vascr_summarise(linedata, level = "summary")
#   
#   
#   
#   lineplot = ggplot(linedata, aes(x = Time, y = Value, ymax = Value + sd/n, ymin = Value - sd/n, fill = Sample, color = Sample)) + geom_line() + geom_ribbon(alpha = 0.3) + ylab("Normalised Value")
#   lineplot
#   
#   pcombinations$sem = pcombinations$sd / sqrt(pcombinations$n)
#   
#   barplot = ggplot(pcombinations, aes(x = sample, y = mean, ymax = mean+sem, ymin = mean - sem)) + geom_errorbar(size = 2, width  = 0.6, aes(colour = V2)) + geom_point(size = 5, aes(color = V1)) + coord_flip() + ylim(-1,1) + ylab("Cross Correlation") + xlab ("Measurement")
#   
#   lineplot = lineplot + theme(legend.position = "none")
#   barplot = barplot + theme(legend.position = "none")
#   
#   
#   if(tomake == "line")
#   {
#     return(lineplot)
#   }
#   else
#   {
#     return(barplot)
#   }
#   
# }
# 
#  
# 
# }
# 
# 
# 
