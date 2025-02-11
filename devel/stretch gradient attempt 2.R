stretch = 1.5

stretch_series = (c(1:50)/10)




tic()
calc_stretch(8)
toc()

x_test = 1
alpha = 0.3
num_iters = 20

tic()
stretch_cc(t1, t2)
toc()

tic()
stretch_cc_2(t1, t2)
toc()


tic()
vascr:::vascr_summarise_cc_stretch_shift(growth.df)
toc()

tic()
vascr_summarise_cc_stretch_shift(growth.df)
toc()
