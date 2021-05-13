# # Comparason paper code
# setwd("C:/Users/jhuc964/Desktop/ECIS R/vascr/compare")
# library(vascr)
# 
# # CellZScope
# cellzscope = cellzscope_import("zscoperaw.txt", "zscopemodel.txt", "zscopekey.csv", "ZScope")
# 
# czs = vascr_exclude(cellzscope, well = c("A06", "B03", "B06", "C05", "C06", "D02"))
# 
# vascr_plot(czs, unit = "TER", level = "wells", frequency = 0)
# vascr_plot(czs, unit = "TER", level = "experiments", normtime = 45)
# 
# czsr = vascr_resample(czs, 1, 0, 90)
# czsr = vascr_explode(czsr)
# 
# vascr_plot(czsr, unit = "TER", level = "wells")
# 
# 
# 
# 
# 
# # ECIS
# ecis = ecis_import("ecis.abp", "ecis.csv", "eciskey.csv", "ECIS")
# 
# ecisr = vascr_resample(ecis, 1, 0, 90)
# 
# ecisr = subset(ecisr, ecisr$Vehicle == "Water")
# 
# vascr_plot(ecisr, level = "experiments")
# vascr_plot(ecisr, level = "wells")
# 
# 
# 
# # Xcelligence
# xcell = import_xcelligence("xcell.plt", 'xcellkey.csv', "xcell")
# xcellr = vascr_resample(xcell, 1, 1, 90)
# 
# vascr_plot(xcellr, unit = "CI", level = 'wells')
# 
# 
# 
# # Prepare to plot out the graphs
# 
# unified = vascr_combine(vascr_remove_metadata(czsr), vascr_remove_metadata(ecisr), vascr_remove_metadata(xcellr))
# unifiedr = vascr_explode(unified)
# unifiedr$HCMVEC = vascr_make_numeric(unifiedr$HCMVEC)
# unifiedr$pg.ml.IL1b = vascr_make_numeric(unifiedr$pg.ml.IL1b)
# unifiedr$pg.ml.TNFa = vascr_make_numeric(unifiedr$pg.ml.TNFa)
# 
# # Figure 2 ##################################################################################
# #
# 
# mini = unifiedr
# mini = vascr_subset(mini, unit = "Z")
# mini = vascr_subset(mini, time = 48)
# mini = vascr_summarise(mini, level = "summary")
# mini = vascr_explode(mini)
# mini = subset(mini, mini$pg.ml.TNFa == "NA" & mini$pg.ml.IL1b == "NA")
# mini$HCMVEC = str_remove(mini$HCMVEC, ",")
# 
# mini$HCMVEC = str_replace(mini$HCMVEC, "80000", "cm^2")
# mini = subset(mini, mini$HCMVEC != "20000")
# 
# 
# ggplot(mini) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)", shape = "Seeding Type") + scale_shape_discrete(labels = c("Media Only",expression(paste("250,000 HCMVEC cells/",cm^2))))+ theme(legend.text.align = 0)
# 
# 
# 
# lowtime = 5
# hightime = 48
# 
# lowtitle = paste("A)", lowtime, "hours")
# hightitle = paste("B)", hightime, "hours")
# 
# mini1 = vascr_subset(mini, time = lowtime)
# H2X = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(lowtitle) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# mini1 = vascr_subset(mini, time = hightime)
# H48X = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(hightitle) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10')+ labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0)
# mini = vascr_subset(mini, unit = "R")
# mini = vascr_summarise(mini, level = "experiments")
# mini$Frequency = as.numeric(mini$Frequency)
# mini$HCMVEC = as.character(mini$HCMVEC)
# 
# mini1 = vascr_subset(mini, time = lowtime)
# H2R = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(lowtitle) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Resistance (ohm)")
# 
# mini1 = vascr_subset(mini, time = hightime)
# H48R = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(hightitle) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10')+ labs(x = "Frequency (Hz)", y = "Resistance (ohm)")
# 
# mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0)
# mini = vascr_subset(mini, unit = "C")
# mini = vascr_summarise(mini, level = "experiments")
# mini$Frequency = as.numeric(mini$Frequency)
# mini$HCMVEC = as.character(mini$HCMVEC)
# 
# mini1 = vascr_subset(mini, time = lowtime)
# H2C = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(lowtitle) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Capacatance (microfarad)")
# 
# mini1 = vascr_subset(mini, time = hightime)
# H48C = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(hightitle) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10')+ labs(x = "Frequency (Hz)", y = "Capacatance (microfarad)")
# 
# 
# mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0)
# mini = vascr_subset(mini, unit = "P")
# mini = vascr_summarise(mini, level = "experiments")
# mini$Frequency = as.numeric(mini$Frequency)
# mini$HCMVEC = as.character(mini$HCMVEC)
# 
# mini1 = vascr_subset(mini, time = lowtime)
# H2P = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(lowtitle) + scale_x_continuous(trans='log10')  + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# mini1 = vascr_subset(mini, time = hightime)
# H48P = ggplot(mini1) + geom_point(aes(x = Frequency, y = Value, color = Instrument, shape = HCMVEC), size = 2) + ggtitle(hightitle) + scale_x_continuous(trans='log10') + labs(x = "Frequency (Hz)", y = "Impedance (ohm)")
# 
# rainbow = vascr_gg_color_hue(3)
# rainbow2 = c(c(rainbow[1], rainbow[2]))
# 
# rb = scale_color_manual(values = rainbow)
# 
# # vascr_make_panel(H2X+ rb, H48X+ rb, H2R+ rb, H48R+ rb, H2C+ rb, H48C+ rb)
# # vascr_make_panel(H2P+ rb, H48P + rb)
# 
# # I think I prefer just raw impedance for simplicity
# vascr_make_panel(H2X+ rb, H48X)
# 
# 
# # Figure 3 #######################################################################
# 
# mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0 & HCMVEC >0)
# mini1 = vascr_subset(mini, frequency = c(8000, 10000), unit = "Z")
# mini1 = vascr_subset(mini1, time = c(2,47))
# mini1 = vascr_summarise(mini1, level = "experiments")
# Kall = ggplot(mini1) + geom_line(aes(x = Time, y = Value, color = interaction(HCMVEC, Instrument))) + ggtitle("A) Raw data combined")
# 
# mini5 = vascr_subset(mini1, instrument = "cellZscope")
# vascr_plot(mini5, unit = "Z")
# 
# mini2 = mini1
# mini2$Experiment = "NA"
# 
# mini3 = subset(mini2, mini2$HCMVEC == 20000)
# K20 = vascr_plot_cross_correlation(mini3, plot = "line") + theme(legend.position = "none")
# K21 = vascr_plot_cross_correlation(mini3, plot = "bar") + theme(legend.position = "none")
# K20 = arrangeGrob(K20, K21, top = "B) 20,000 HCMVEC per well")
# 
# mini3 = subset(mini2, mini2$HCMVEC == 80000)
# K80 = vascr_plot_cross_correlation(mini3, plot = "line") + theme(legend.position = "none")
# K81 = vascr_plot_cross_correlation(mini3, plot = "bar") + theme(legend.position = "none")
# K80 = arrangeGrob(K80, K81, top = "C) 80,000 HCMVEC per well")
# 
# Kcombo = arrangeGrob(K20, K80, ncol = 2)
# 
# layout = arrangeGrob(Kall, Kcombo)
# 
# ledgend = vascr_grab_legend(K81, position = "top")
# 
# grid.arrange(layout, ledgend, heights = c(1,0.05))
# 
# 
# # Figure 4 ##############################################################################################################
# 
# # Compare growth curves accross all units
# mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0 & HCMVEC >0)
# mini = vascr_subset(mini, time = c(0,47))
# mini1 = subset(mini, mini$Instrument == "ECIS")
# p1 = vascr_plot(mini1, unit = "Z", level = "experiments", frequency = 8000, title = "Impedance (8,000 Hz)")
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope")
# p2 = vascr_plot(mini1, unit = "Z", frequency = 10000, level = "experiments", title = "Impedance (10,000 Hz)")
# 
# mini1 = vascr_subset(mini, instrument = "xCELLigence")
# p3 = vascr_plot(mini1, unit = "Z", level = "experiments", frequency = 10000, title = "Impedance (10,000 Hz)")
# 
# 
# mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0 & HCMVEC >0)
# mini = vascr_subset(mini, time = c(0,47))
# 
# Rb = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb")
# Cm = vascr_plot(mini, unit = "Cm", level = "experiments", title = "Cm")
# Alpha = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha")
# 
# TER = vascr_plot(mini, unit = "TER", level = "experiments", title = "TER")
# Ccl = vascr_plot(mini, unit = "Ccl", level = "experiments", title = "Ccl")
# 
# CI = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI")
# 
# blank = vascr_plot_blank()
# 
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
# p1 = p1+theme(legend.position = "none")
# p2 = p2+theme(legend.position = "none")
# p3 = p3+theme(legend.position = "none")
# p4 = Rb+theme(legend.position = "none")
# p5 = TER+theme(legend.position = "none")
# p6 = Cm+theme(legend.position = "none")
# p7 = Ccl+theme(legend.position = "none")
# p8 = Alpha +theme(legend.position = "none")
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
# # Figure 5
# 
# rdata = vascr_subset(unifiedr, unit = c("Rb", "Alpha", "Z"), variable_equal_to = c("TNFa", "0", "IL1b", "0"), variable_greater_than = c("HCMVEC", "0"), time = c(0,80), frequency = c(0,10000, 8000), instrument = c("ECIS", "xCELLigence"))
# rdata = vascr_summarise(rdata, level = "experiments")
# rdata$Experiment = "NA"
# 
# r1 = vascr_gg_color_hue(4)
# r2 = c(r1[2], r1[1], r1[3], r1[4])
# 
# rdata2 = subset(rdata, HCMVEC == 80000)
# p1 = vascr_plot_cross_correlation(rdata2, plot = "line") + labs(title = "80,000 cells")
# p2 = vascr_plot_cross_correlation(rdata2, plot = "bar") + labs(title = " ")
# 
# rdata2 = subset(rdata, HCMVEC == 20000)
# p3 = vascr_plot_cross_correlation(rdata2, plot = "line") +
#   scale_color_manual(values = c(r1[1], r1[2], r1[3], r1[4]))  + labs(title = "20,000 cells")
# 
# p4 = vascr_plot_cross_correlation(rdata2, plot = "bar") +
#   scale_color_manual(values = c(r1[1], r1[2], r1[3])) +
#   scale_fill_manual(values = c(r1[2], r1[3], r1[4])) + labs(title = " ")
# 
# # alpha = red
# # Rb = green
# # ECIS = blue
# # Zscope = purple
# 
# vascr_make_panel(p1, p2, p3, p4, legend_from_index = 2)
# 
# # Figure 6 ######################################################################################################
# 
# 
# # Compare treatment curves in exact parity
# mini = subset(unifiedr, HCMVEC >0)
# mini = vascr_subset(mini, time = c(40,75))
# nt = 45
# range = ylim(0.85, 1.18)
# 
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Z", frequency = 8000)
# mini2 = subset(mini1, HCMVEC==80000)
# p1 = vascr_plot(mini2, unit = "Z", level = "experiments", frequency = 8000, normtime = nt, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "experiments")
# p1.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# mini2 = subset(mini1, HCMVEC==20000)
# p11 = vascr_plot(mini2, unit = "Z", level = "experiments", frequency = 8000, normtime = nt, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "experiments")
# p11.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# 
# # vascr_make_panel(p1, p1.5, p11, p11.5)
# 
# # mini3 = vascr_summarise(mini1, level = "experiments")
# # vascr_plot_cross_correlation(mini3, show_index = c(2,4,7,9,11,14)) + scale_fill_brewer(palette="Set1")
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope", unit = "Z", frequency = 10000)
# mini2 = subset(mini1, HCMVEC==80000)
# p2 = vascr_plot(mini2, unit = "Z", frequency = 10000, level = "experiments", normtime = nt, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "experiments")
# p2.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# 
# mini2 = subset(mini1, HCMVEC==20000)
# p21 = vascr_plot(mini2, unit = "Z", frequency = 10000, level = "experiments", normtime = nt, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "experiments")
# p21.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# 
# 
# mini1 = vascr_subset(mini, instrument = "xCELLigence", unit = "Z", frequency = 10000)
# mini2 = subset(mini1, HCMVEC==80000)
# p3 = vascr_plot(mini2, unit = "Z", level = "experiments", frequency = 10000, normtime = nt, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "experiments")
# p3.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# 
# 
# mini2 = subset(mini1, HCMVEC==20000)
# p31 = vascr_plot(mini2, unit = "Z", level = "experiments", frequency = 10000, normtime = nt, divide = TRUE)
# mini3 = vascr_summarise(mini2, level = "experiments")
# p31.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# 
# 
# # vascr_make_panel(p1+range, p11+range, p2+range, p21+range, p3+range, p31+range)
# 
# nol = theme(legend.position = "none", plot.title = element_blank())
# lim =  ylim(0.91, 1.18)
# 
# 
# title1 = text_grob("ECIS")
# title2 = text_grob("cellZscope")
# title3 = text_grob("xCELLigence")
# 
# title4 = text_grob("80,000 cells", rot = 90)
# title5 = text_grob("20,000 cells", rot = 90)
# 
# 
# # grid.arrange(p1+ nol + lim, p1.5+ nol, p11 + nol+lim, p11.5 + nol,
# #              p2+nol+lim, p2.5+nol, p21 + nol+lim, p21.5 + nol,
# #              p3+nol+lim, p3.5+nol, p31 + nol+lim, p31.5 + nol,
# #
# #              ncol = 4)
# 
# blank = vascr_plot_blank()
# 
# charts = arrangeGrob(blank, title1, title2, title3,
#                      title4, p1 + nol + lim, p2+nol+lim, p3+nol+lim,
#                      p1.5 + nol, p2.5+nol, p3.5 + nol,
#                      title5, p11 + nol + lim, p21+nol+lim, p31+nol+lim,
#                      p11.5 + nol, p21.5+nol, p31.5 + nol,
# 
#                      heights = c(0.3,1,1,1,1),
#                      widths = c(0.3, 1,1,1),
#                      layout_matrix = rbind(c(1, 2, 3, 4),
#                                            c(5, 6, 7, 8),
#                                            c(5, 9, 10, 11),
#                                            c(12, 13, 14, 15),
#                                            c(12, 16, 17, 18)))
# 
# ledgend = vascr_grab_legend(p1.5, position = "bottom")
# 
# grid.arrange(charts, ledgend, heights = c(1, 0.1))
# 
# 
# 
# 
# # Figure 7 #################################
# 
# nol = theme(legend.position = "none")
# 
# mini = subset(unifiedr, HCMVEC >0)
# mini = vascr_subset(mini, time = c(40,75))
# mini = vascr_remove_metadata(mini)
# mini = vascr_explode(mini)
# nt = 45
# range = ylim(0.85, 1.18)
# 
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Z", frequency = 8000)
# mini2 = subset(mini1, HCMVEC==80000)
# p1 = vascr_plot(mini2, unit = "Z",level = "experiments", normtime = nt, divide = TRUE, title = "Z")
# 
# mini3 = vascr_summarise(mini2, level = "experiments")
# p1.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# sd(vascr_summarise_cross_correlation(mini3)$coeffs)
# 
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Rb")
# mini2 = subset(mini1, HCMVEC==80000)
# p11 = vascr_plot(mini2, unit = "Rb", level = "experiments", normtime = nt, divide = TRUE, title = "Rb")
# mini3 = vascr_summarise(mini2, level = "experiments")
# p11.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# sd(vascr_summarise_cross_correlation(mini3)$coeffs)
# 
# 
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Cm")
# mini2 = subset(mini1, HCMVEC==80000)
# p111 = vascr_plot(mini2, unit = "Cm", level = "experiments", normtime = nt, divide = TRUE, title = "Cm")
# mini3 = vascr_summarise(mini2, level = "experiments")
# p111.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# sd(vascr_summarise_cross_correlation(mini3)$coeffs)
# 
# ecispanel = arrangeGrob(p1 + nol, p1.5 + nol, p11 + nol, p11.5 + nol,p111 + nol, p111.5 + nol)
# 
# # Repeat
# 
# mini = subset(unifiedr, HCMVEC >0)
# mini = vascr_subset(mini, time = c(40,75))
# mini = vascr_remove_metadata(mini)
# mini = vascr_explode(mini)
# nt = 45
# range = ylim(0.85, 1.18)
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope", unit = "Z", frequency = 10000)
# mini2 = subset(mini1, HCMVEC=="80,000")
# p21 = vascr_plot(mini2, unit = "Z", level = "experiments", normtime = nt, divide = TRUE, title = "Z")
# mini3 = vascr_summarise(mini2, level = "experiments")
# p21.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# sd(vascr_summarise_cross_correlation(mini3)$coeffs)
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope", unit = c("TER"))
# mini2 = subset(mini1, HCMVEC=="80,000")
# p2 = vascr_plot(mini2, unit = "TER", level = "experiments", normtime = nt, divide = TRUE, title = "TER")
# mini3 = vascr_summarise(mini2, level = "experiments")
# p2.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# sd(vascr_summarise_cross_correlation(mini3)$coeffs)
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope", unit = c("Ccl"))
# mini2 = subset(mini1, HCMVEC=="80,000")
# p3 = vascr_plot(mini2, unit = "Ccl", level = "experiments", normtime = nt, divide = TRUE, title = "Ccl")
# mini3 = vascr_summarise(mini2, level = "experiments")
# p3.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# sd(vascr_summarise_cross_correlation(mini3)$coeffs)
# 
# 
# 
# cZspanel = arrangeGrob(p21 + nol, p21.5 + nol, p2 + nol, p2.5 + nol, p3 + nol, p3.5 + nol)
# 
# title1 = text_grob("ECIS")
# title2 = text_grob("cellZscope")
# 
# ledgend = vascr_grab_legend(p21.5, position = "top")
# 
# maxpanel = arrangeGrob(title1, title2, ecispanel, cZspanel, ncol = 2, heights = c(0.05, 1))
# 
# grid.arrange(maxpanel, ledgend, heights = c(1,0.05))
# 
# 
# 
# 
# 
# 
# 
# 
# 
# # # Make a table of all frequencies to have a look at
# # frequencycompare = data.frame(Frequency = as.numeric(mini$Frequency), Unit = mini$Unit, Instrument = mini$Instrument)
# # frequencycompare = subset(frequencycompare, frequencycompare$Unit == "Z")
# # frequencycompare = unique(frequencycompare)
# #
# #
# # # Compare growth curves between experiments, split by unit
# # mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0 & HCMVEC >0)
# #
# # p1 = vascr_plot(mini, unit = "Rb", level = "experiments", title = "ECIS, Rb")
# # p2 = vascr_plot(mini, unit = "TER", level = "experiments", title = "cellZscope, TER")
# # p3 = vascr_plot(mini, unit = "CI", level = "experiments", title = "xCELLigence, CI")
# # vascr_make_panel(p1, p2, p3)
# #
# # mini = subset(unifiedr, unifiedr$pg.ml.TNFa ==0 & unifiedr$pg.ml.IL1b ==0 & HCMVEC >0)
# # mini = vascr_subset(mini, unit = c("Rb", "CI", "TER"), time = c(1,90), frequency = c(0,10000))
# # mini = vascr_summarise(mini, level = "experiments")
# #
# # vascr_summarise_cross_correlation(mini)
# #
# # vascr_plot_cross_correlation(mini)
# #
# #
# #
# #
# #
# # #Original offset
# # mini = subset(unifiedr, HCMVEC==80000)
# # mini1 = vascr_normalise(mini, normtime = 0)
# # mini1 =vascr_explode(mini1)
# # p2 = vascr_plot(mini, unit = "TER", level = "wells")
# # p3 = vascr_plot(mini, unit = "Z", level = "wells")
# # vascr_make_panel(p2, p3)
# #
# # # Compare equivelent modeled units
# # mini = subset(unifiedr, HCMVEC==80000)
# # p1 = vascr_plot(mini, unit = "Rb", level = "experiments")
# # p2 = vascr_plot(mini, unit = "TER", level = "experiments")
# # p3 = vascr_plot(mini, unit = "CI", level = "experiments")
# # vascr_make_panel(p1, p2, p3)
# #
# # mini1 = vascr_subset(unifiedr, time = c(30,75))
# #
# # mini = subset(mini1, HCMVEC==80000)
# # p1a = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 80,000 cells")
# # p2a = vascr_plot(mini, unit = "TER", level = "experiments", title = "TER, 80,000 cells")
# # p3a = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 80,000 cells")
# #
# #
# #
# # mini = subset(mini1, HCMVEC==20000)
# # p1b = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 20,000 cells")
# # p2b = vascr_plot(mini, unit = "TER", level = "experiments", title = "TER, 20,000 cells")
# # p3b = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 20,000 cells")
# #
# #
# # vascr_make_panel(p1a, p1b,p2a, p2b, p3a, p3b)
# #
# #
# # # Do it again with normalisation
# # mini1 = vascr_subset(unifiedr, time = c(30,75))
# # mini1 = vascr_normalise(mini1, normtime = 40)
# # mini1 = vascr_explode(mini1)
# # mini1$HCMVEC = vascr_make_numeric(mini1$HCMVEC)
# #
# # mini = subset(mini1, HCMVEC==80000)
# # p1a = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 80,000 cells")
# # p1b = vascr_plot(mini, unit = "Cm", level = "experiments", title = "Cm, 80,000 cells")
# # p1c = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 80,000 cells")
# #
# # p2a = vascr_plot(mini, unit = "TER", level = "experiments", title = "TER, 80,000 cells")
# # p2b = vascr_plot(mini, unit = "Ccl", level = "experiments", title = "Ccl, 80,000 cells")
# # p2c = ggplot()
# #
# # p3a = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 80,000 cells")
# # p3b = ggplot()
# # p3c = ggplot()
# #
# # vascr_make_panel(p1a, p1b, p1c, p2a, p2b, p2c, p3a, p3b, p3c)
# #
# # mini = subset(mini1, HCMVEC==20000)
# # p1a = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 20,000 cells")
# # p1b = vascr_plot(mini, unit = "Cm", level = "experiments", title = "Cm, 20,000 cells")
# # p1c = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 20,000 cells")
# #
# # p2a = vascr_plot(mini, unit = "TER", level = "experiments", title = "TER, 20,000 cells")
# # p2b = vascr_plot(mini, unit = "Ccl", level = "experiments", title = "Ccl, 20,000 cells")
# # p2c = ggplot()
# #
# # p3a = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 20,000 cells")
# # p3b = vascr_plot_blank()
# # p3c = vascr_plot_blank()
# #
# # vascr_make_panel(p1a, p1b, p1c, p2a, p2b, p2c, p3a, p3b, p3c)
# #
# #
# # mini = subset(mini1, HCMVEC==20000)
# # p1b = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 20,000 cells")
# # p2b = vascr_plot(mini, unit = "TER", level = "experiments", title = "TER, 20,000 cells")
# # p3b = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 20,000 cells")
# #
# #
# # vascr_make_panel(p1a, p1b,p2a, p2b, p3a, p3b)
# #
# #
# # ## Plots to compare with Scott
# # mini = subset(unifiedr, HCMVEC==20000)
# # p1b = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 20,000 cells")
# # p2b = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 20,000 cells")
# # p3b = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 20,000 cells")
# # mini = subset(unifiedr, HCMVEC==80000)
# # p1c = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 80,000 cells")
# # p2c = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 80,000 cells")
# # p3c = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 80,000 cells")
# # vascr_make_panel(p1b, p1c, p2b, p2c, p3b, p3c)
# #
# # mini1 = vascr_subset(unifiedr, time = c(30,75))
# # mini = subset(mini1, HCMVEC==20000)
# # p1b = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 20,000 cells")
# # p2b = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 20,000 cells")
# # p3b = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 20,000 cells")
# # mini = subset(mini1, HCMVEC==80000)
# # p1c = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 80,000 cells")
# # p2c = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 80,000 cells")
# # p3c = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 80,000 cells")
# # vascr_make_panel(p1b, p1c, p2b, p2c, p3b, p3c)
# #
# #
# # mini1 = vascr_subset(unifiedr, time = c(30,75))
# # mini2 = vascr_normalise(mini1, normtime = 40)
# # mini2 = vascr_explode(mini2)
# # mini = subset(mini2, HCMVEC==20000)
# # p1b = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 20,000 cells")
# # p2b = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 20,000 cells")
# # p3b = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 20,000 cells")
# # mini = subset(mini2, HCMVEC==80000)
# # p1c = vascr_plot(mini, unit = "Rb", level = "experiments", title = "Rb, 80,000 cells")
# # p2c = vascr_plot(mini, unit = "Alpha", level = "experiments", title = "Alpha, 80,000 cells")
# # p3c = vascr_plot(mini, unit = "CI", level = "experiments", title = "CI, 80,000 cells")
# # vascr_make_panel(p1b, p1c, p2b, p2c, p3b, p3c)
# #
# # vascr_plot(mini2)
# #
# #
# # ## Prototypical work
# #
# # ignore = function()
# # {
# #
# #   toplot = vascr_subset(unifiedr, variable_equal_to = c("HCMVEC",20000))
# #   p1 = vascr_plot(toplot, unit = "Rb", title = "Rb")
# #   p2 = vascr_plot(toplot, unit = "Alpha", title = "Alpha")
# #   p3 = vascr_plot(toplot, unit = "CI", title = "CI")
# #   p4 = vascr_plot(toplot, unit = "TER", title = "TER")
# #   vascr_make_panel(p1, p2, p3, p4)
# #
# #   # Cross correlation code
# #   rb = vascr_subset(unifiedr, unit = c("Rb"), variable_equal_to = c("TNFa", "0", "IL1b", "0", "HCMVEC", 20000), time = c(0,80))
# #   rb = vascr_summarise(rb, level = "experiments")
# #
# #   vascr_summarise_cross_correlation(rb)
# #   vascr_plot_cross_correlation(rb)
# #
# #   data.df = rb
# #
# #   alpha = vascr_subset(unifiedr, unit = "Alpha", variable_equal_to = c("HCMVEC", 20000, "TNFa", "0", "IL1b", "0"), time = c(0,80))
# #   alpha = vascr_summarise(alpha, level = "experiments")
# #
# #   CI = vascr_subset(unifiedr, unit = "CI", variable_equal_to = c("HCMVEC", 20000, "TNFa", "0", "IL1b", "0"), time = c(0,80), frequency = 10000)
# #   CI = vascr_summarise(CI, level = "experiments")
# #
# #   TER = vascr_subset(unifiedr, unit = c("TER"), variable_equal_to = c("HCMVEC", 20000, "TNFa", "0", "IL1b", "0"), time = c(0,80))
# #   TER = vascr_summarise(TER, level = "experiments")
# #
# #   # vascr_summarise_change(TER)
# #   # vascr_summarise_cross_correlation(TER)
# #   # vascr_plot_cross_correlation(TER)
# #   #
# #   # combo = vascr_combine(TER, CI)
# #   #
# #   # vascr_plot_cross_correlation(combo)
# #
# #   r4000 = vascr_subset(unifiedr, unit = "R", variable_equal_to = c("HCMVEC", 20000, "TNFa", "0", "IL1b", "0"), time = c(0,80), frequency = 4000)
# #   r4000 = vascr_summarise(r4000, level = "experiments")
# #
# #   unified = vascr_combine(rb,CI,alpha, r4000)
# #   unified$Experiment = "TEST"
# #   unified$Sample = "TEST"
# #
# #   unified = unique(unified)
# #
# #   vascr_summarise_change(unified)
# #   vascr_plot_cross_correlation(unified)
# #
# #   rbts = as.ts(rb$Value)
# #   alphats = as.ts(alpha$Value)
# #   cits = as.ts(CI$Value)
# #   r4000ts = as.ts(r4000$Value)
# #
# #   nrbts = as.ts(rb$Value/max(rb$Value))
# #   nr4000ts = as.ts(r4000$Value/max(r4000$Value[2:80]))
# #
# #   plot(rbts)
# #   plot(cits)
# #   plot(alphats)
# #   plot(r4000ts)
# #
# #
# #   ccf(rbts, alphats, plot = FALSE)[0]
# #   ccf(cits, alphats, plot = FALSE)[0]
# #   ccf(rbts, cits, plot = FALSE)[0]
# #
# #   ccf(rbts[2:80], r4000ts[2:80], plot = FALSE)[0]
# #   ccf(nrbts[2:80], nr4000ts[2:80], plot = FALSE)[0]
# #
# #
# #   vascr_summarise_change(rdata)
# #   vascr_summarise_cross_correlation(rdata)
# #
# #
# #   growth.df = rdata
# #
# #   data.df = vascr_summarise(growthrb, level = "summary")
# #
# #   vascr_plot_cross_correlation(growthrb)
# #
# #   vascr_plot_cross_correlation(rb)
# #
# #
# #
# #
# # }
# #
# #
# #
# #
# #
# #
# # numbers = c(0.8, 0.9, 0.7, 1, 1)
# # numbers2 = c(0.8, 0.9, 0.7, 1, 1)
# # debug(t.test)
# # t.test(numbers, mu = 1, alternative = "less")
# #
# # 2 * (1 - pnorm(abs(max.cor), mean = 0, sd = 1/sqrt(ccf1$n.used)))
# #
# # debug(ccf)
# # ccf(numbers, numbers2)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
