# nol = theme(legend.position = "none")
# 
# mini = subset(masterm, HCMVEC >0)
# mini = vascr_subset(mini, time = c(40,75))
# mini = vascr_remove_metadata(mini)
# mini = vascr_explode(mini)
# nt = 47
# range = ylim(0.85, 1.18)
# 
# rb = vascr_gg_color_hue(3)
# 
# # Change unit
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Z", frequency = 8000)
# mini2 = subset(mini1, HCMVEC==80000)
# p1data = vascr_prep_graphdata(mini2, unit = "Z",level = "experiments", normtime = nt, divide = TRUE, frequency = 8000)
# # Change this
# p1 = vascr_plot_line(p1data) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + labs(title = "Impedance") +ylab("Ohm (8,000 Hz)") + xlab("Time (hours)")
# mini3 = vascr_summarise(mini2, level = "experiments")
# mini3 = vascr_explode(mini3)
# # Change this
# p1.5 = vascr_plot_cross_correlation(mini3, plot = "bar") + xlab("Cross Correlation Coefficent")+ labs(title = "")
# 
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Rb", frequency = 8000)
# mini2 = subset(mini1, HCMVEC==80000)
# p1data = vascr_prep_graphdata(mini2, unit = "Rb",level = "experiments", normtime = nt, divide = TRUE, frequency = 8000)
# # Change this
# p11 = vascr_plot_line(p1data)+ scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + labs(title = "Rb") +ylab("Ohm") + xlab("Time (hours)")
# mini3 = vascr_summarise(mini2, level = "experiments")
# mini3 = vascr_explode(mini3)
# # Change this
# p11.5 = vascr_plot_cross_correlation(mini3, plot = "bar") + xlab("Cross Correlation Coefficent")+ labs(title = "")
# 
# mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Cm", frequency = 8000)
# mini2 = subset(mini1, HCMVEC==80000)
# p1data = vascr_prep_graphdata(mini2, unit = "Cm",level = "experiments", normtime = nt, divide = TRUE, frequency = 8000)
# # Change this
# p111 = vascr_plot_line(p1data) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + labs(title = "Cm") +ylab("Ohm") + xlab("Time (hours)")
# mini3 = vascr_summarise(mini2, level = "experiments")
# mini3 = vascr_explode(mini3)
# # Change this
# p111.5 = vascr_plot_cross_correlation(mini3, plot = "bar") + xlab("Cross Correlation Coefficent")+ labs(title = "")
# 
# # Alpha graph, out of interest
# # mini1 = vascr_subset(mini, instrument = "ECIS", unit = "Alpha", frequency = 8000)
# # mini2 = subset(mini1, HCMVEC==80000)
# # p1data = vascr_prep_graphdata(mini2, unit = "Alpha",level = "experiments", normtime = nt, divide = TRUE, frequency = 8000)
# # # Change this
# # p1111 = vascr_plot_line(p1data) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2]))
# # mini3 = vascr_summarise(mini2, level = "experiments")
# # mini3 = vascr_explode(mini3)
# # # Change this
# # p1111.5 = vascr_plot_cross_correlation(mini3, plot = "bar")
# #
# # vascr_make_panel(p1111, p1111.5)
# 
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
# p1data = vascr_prep_graphdata(mini2, unit = "Z",level = "experiments", normtime = nt, divide = TRUE, frequency = 10000)
# # Change this
# p21 = vascr_plot_line(p1data) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + labs(title = "Impedance") +ylab("Ohm (10,000 Hz)") + xlab("Time (hours)")
# mini3 = vascr_summarise(mini2, level = "experiments")
# mini3 = vascr_explode(mini3)
# # Change this
# p21.5 = vascr_plot_cross_correlation(mini3, plot = "bar") + xlab("Cross Correlation Coefficent")+ labs(title = "")
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope", unit = "TER", frequency = 0)
# mini2 = subset(mini1, HCMVEC=="80,000")
# p1data = vascr_prep_graphdata(mini2, unit = "TER",level = "experiments", normtime = nt, divide = TRUE, frequency = 10000)
# # Change this
# p2 = vascr_plot_line(p1data) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + labs(title = "TER") +ylab("Ohm") + xlab("Time (hours)")
# mini3 = vascr_summarise(mini2, level = "experiments")
# mini3 = vascr_explode(mini3)
# # Change this
# p2.5 = vascr_plot_cross_correlation(mini3, plot = "bar") + xlab("Cross Correlation Coefficent")+ labs(title = "")
# 
# 
# mini1 = vascr_subset(mini, instrument = "cellZscope", unit = "Ccl", frequency = 0)
# mini2 = subset(mini1, HCMVEC=="80,000")
# p1data = vascr_prep_graphdata(mini2, unit = "Ccl",level = "experiments", normtime = nt, divide = TRUE, frequency = 10000)
# # Change this
# p3 = vascr_plot_line(p1data) + scale_colour_manual(values = c(rb[3], rb[1], rb[2])) + scale_fill_manual(values = c(rb[3], rb[1], rb[2])) + labs(title = "Ccl") +ylab("Ohm") + xlab("Time (hours)")
# mini3 = vascr_summarise(mini2, level = "experiments")
# mini3 = vascr_explode(mini3)
# # Change this
# p3.5 = vascr_plot_cross_correlation(mini3, plot = "bar")  + xlab("Cross Correlation Coefficent") + labs(title = "")
# 
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
