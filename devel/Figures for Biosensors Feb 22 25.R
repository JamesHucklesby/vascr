# Get dataset

e1 = vascr_import("ECIS", "ECIS/ECIS_200722_MFT_1.abp", "ECIS/ECIS_200722_MFT_1_RbA.csv", "Exp1")
e1s = vascr_apply_map(e1, "ECIS/200722_key.csv")

e2 = ecis_import("ECIS/ECIS_200728_MFT_1.abp", "ECIS/ECIS_200728_MFT_1_RbA.csv", "Exp2")
e2s = vascr_apply_map(e2, "ECIS/200728_key.csv")

e3 = ecis_import("ECIS/ECIS_200907_MFT_1.abp", "ECIS/ECIS_200907_MFT_1_RbA.csv", "Exp3")
e3s = vascr_apply_map(e3, "ECIS/200907_key.csv")

combined = vascr_combine(e1s, e2s, e3s)

combined = combined %>% mutate(SampleID = as.numeric(Sample))


c1 = combined %>% vascr_subset(unit ="R", frequency = 4000)

grid_data = c1 %>% vascr_subset(experiment = 1) %>% vascr_resample_time(npoints = 300) %>%
            vascr_edit_name("Water Vehicle \\+ ") %>%
            vascr_replace_sample("Water Vehicle + 0 HCMVEC", "Cell-free Control") %>%
            vascr_replace_sample("NA", "Cell free") %>%
            vascr_replace_sample("0 HCMVEC", "Cell free") %>%
            vascr_edit_name("IL1b", "IL1β") %>%
            vascr_edit_name("TNFa", "TNFα") %>%
            vascr_edit_name("pg.ml", "pg/ml") %>%
            vascr_edit_name("\\.", " ") %>%
            vascr_edit_name("0000", "0,000") %>%
             vascr_edit_name("HCMVEC", "hCMEVEC") %>%
            mutate(Sample = factor(Sample, unique(Sample)))
            

vascr_plot_line(grid_data)

g1 = vascr_plot_grid(grid_data, threshold = 0.1)

g1

ggsave("devel/grid.svg", g1, width = 21.0, height =  29.7, units = "cm")

# e1s %>% vascr_subset(unit = "R", frequency = 4000) %>% vascr_plot_line()
# 
# # Plot grid
# vascr_plot_grid(c1 %>% vascr_subset(experiment = 2), threshold = 0.01)


# Resample_tim

e1c = c1 %>% filter(Well %in% c("E01", "E02")) %>% 
  filter(Experiment == "1 : Exp1")

e1c_short = e1c %>%
  filter(Time <2)


p1a = ggplot(e1c_short) +
  geom_point(aes(x = Time, y = Value, color = Well)) +
  geom_vline(aes(xintercept = Time, color = Well), alpha = 0.3) +
  labs(tag = "A")

p1a

p1b = e1c_short %>% vascr_resample_time() %>% ggplot() +
  geom_point(aes(x = Time, y = Value, color = Well)) +
  geom_vline(aes(xintercept = Time, color = Well), alpha = 0.3)+
  labs(tag = "B")

p1b

p1c = e1c %>% vascr_resample_time() %>% ggplot() +
  geom_point(aes(x = Time, y = Value, color = Well)) +
  geom_vline(aes(xintercept = Time, color = Well), alpha = 0.3)+
  labs(tag = "C")

p1c

e1c2 = e1c #%>% vascr_subset(time = c(45,55))

vascr_plot_resample_range(data.df = e1c2)



p1d = e1c2 %>% vascr_plot_resample(unit = "R", frequency = 4000, newn = vascr_find_count_timepoints(e1c2), rug = FALSE) +
  labs(tag = "C", colour = "Processing") + 
  scale_colour_manual(values = c("orange", "mediumvioletred"))


p1d

p1e = e1c2 %>% vascr_plot_resample(unit = "R", frequency = 4000, newn = 151, rug = FALSE) +
  labs(tag = "C", colour = "Processing") + 
  scale_colour_manual(values = c("orange", "mediumvioletred"))




map = "
ba
ca
da
cd"

layout = p1a / p1b / p1d /p1e + plot_layout(guides = "collect")
layout

ggsave("devel/resamplefig.svg", layout)

vascr_find_disc(e1c2)



average_data = c1 %>% vascr_resample_time(npoints = 300) %>%
  vascr_edit_name("Water Vehicle \\+ ") %>%
  vascr_replace_sample("Water Vehicle + 0 HCMVEC", "Cell-free Control") %>%
  vascr_replace_sample("0 HCMVEC", "Cell free") %>%
  vascr_edit_name("IL1b", "IL1β") %>%
  vascr_edit_name("TNFa", "TNFα") %>%
  vascr_edit_name("pg.ml", "pg/ml") %>%
  vascr_edit_name("\\.", " ") %>%
  vascr_edit_name("0000", "0,000") %>%
  vascr_edit_name("HCMVEC", "hCMEVEC") %>%
  mutate(Sample = factor(Sample, unique(Sample))) %>%
  filter(Sample != "NA") %>%
  vascr_exclude("H02", "2: Exp 2")


pwell = average_data %>% vascr_plot_line(facet = FALSE, text_labels = FALSE) + labs(tag = "A")
pwell

pexp = average_data %>% vascr_summarise("experiments") %>% vascr_plot_line() + labs(tag = "B")
pexp

psum = average_data %>% vascr_summarise("summary") %>% vascr_plot_line() + labs(tag = "C")
psum

((pwell + guides(colour = "none") ) + pexp + psum + guide_area()) + plot_layout(guides = "collect")



unique(c1$Sample)

c2 = c1 %>% vascr_subset(sample = c("500 pg.ml.TNFa + Water Vehicle + 80000 HCMVEC", "Water Vehicle + 80000 HCMVEC"),
                         time = c(40,100)) %>%
  mutate(SampleID = as.numeric(Sample)) %>%
  vascr_resample_time(npoints = 400)

norm1 = c2 %>% ungroup() %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  ungroup() %>%
  vascr_summarise(level = "experiments") %>%
  vascr_plot_line(facet = FALSE)

norm2 = c2 %>% ungroup() %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_resample_time(npoints = 500) %>%
  ungroup() %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line(facet = FALSE)

c2n = c2 %>% vascr_normalise(normtime = 47)

norm3 = c2n %>% ungroup() %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_resample_time(npoints = 500) %>%
  ungroup() %>%
  vascr_summarise(level = "experiments") %>%
  vascr_plot_line(facet = FALSE)


norm4 = c2n %>% ungroup() %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_resample_time(npoints = 500) %>%
  ungroup() %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line(facet = FALSE)

norm5 = c2 %>% vascr_normalise(normtime = 80) %>%
  vascr_subset(unit = "R", frequency = 4000) %>%
  vascr_resample_time(npoints = 500) %>%
  ungroup() %>%
  vascr_summarise(level = "summary") %>%
  vascr_plot_line(facet = FALSE)


norm1 + norm2 + norm3 + norm4 + norm5 + guide_area() + plot_layout(guides = "collect", ncol = 2)



cc.df = vascr_cc(c2) %>% vascr_summarise_cc("summary")

vascr_plot_cc(cc.df %>% mutate(Experiment = 1))

vascr_summarise_cc_stretch_shift_stats(c2, unit = "Rb", frequency = 0)

ct = vascr_plot_cc_stretch_shift_stats(c2, unit = "Rb", frequency = 0)
ct


data.df = c2 %>%
  vascr_subset(unit = "R") %>%
  vascr_resample_time(npoints = 50)

c2 = c1 %>% vascr_subset(sample = c("500 pg.ml.TNFa + Water Vehicle + 20000 HCMVEC", "500 pg.ml.IL1b + Water Vehicle + 20000 HCMVEC", "Water Vehicle + 20000 HCMVEC"),
                         time = c(40,100)) %>%
  mutate(SampleID = as.numeric(Sample)) %>%
  vascr_resample_time(npoints = 400)


 data.df = c2 %>% vascr_normalise(47) 
 data.df %>% vascr_plot_line_dunnett(frequency = 4000, unit = "R", time = list(70, 60), reference = "0_cells")



times = c(0:100)/100*pi

synthetic.df = data.frame(`Time` = times, 
                          `A) Reference` = sin(times),
                          `B) Reduced magnitude` = sin(times)/2,
                          `C) Inverse` = 1-sin(times)-1,
                          `D) Inverse2` = 1-sin(times*1.8)-1)

library(ggplot2)
library(gridExtra)
library(dplyr)
library(formattable)
library(signal)


# Omitted full code, same as in question
# full.data <- structure(...)
# summary.table <- structure(...)
# table <- tableGrob(...)

#table object to beincluded with ggplot
table <- tableGrob(summary.table %>%
                     rename(
                       `Prb FR` = prob.fr,
                       `Prb ED` = prob.ed.n,
                     ), 
                   rows = NULL)

# Simplified plot
plot <- ggplot(full.data, aes(x = error, y = prob.ed.n, group = N, colour = as.factor(N))) +
  geom_line(data = full.data %>%
              group_by(N) %>%
              do({
                tibble(error = seq(min(.$error), max(.$error),length.out=100),
                       prob.ed.n = pchip(.$error, .$prob.ed.n, error))
              }),
            size = 1) +
  guides(color = guide_legend(reverse=TRUE)) +
  theme(legend.key = element_rect(fill = "white", colour = "black"))

plot


library(grid)
library(gtable)

#' @param tableGrob The output of the `gridExtra::tableGrob()` function.
#' @param plot A ggplot2 object with a single, vertical legend
#' @param replace_col An `integer(1)` with the column number in the 
#'   table to replace with keys. Defaults to the last one.
#' @param key_padding The amount of extra space to surround keys with,
#'   as a `grid::unit()` object.
#'
#' @return A modified version of the `tableGrob` argument
add_legend_column <- function(
    table, 
    plot,
    replace_col = ncol(tableGrob),
    key_padding = unit(5.5, "pt")
) {
  
  # Getting legend keys
  keys <- cowplot::get_legend(plot)
  keys <- keys$grobs[[which(keys$layout$name == "guides")[1]]]
  keys <- gtable_filter(keys, 'label|key')
  idx  <- unique(keys$layout$t)
  keys <- lapply(idx, function(i) {
    x <- keys[i, ]
    # Set justification of keys
    x$vp$x <- unit(0.5, "npc")
    x$vp$justification <- x$vp$valid.just <- c(0.5, 1)
    # Set key padding
    x <- gtable_add_padding(x, key_padding)
    x
  }) 
  
  # Measure keys
  width  <- max(do.call(unit.c, lapply(keys, grobWidth)))
  width  <- max(width, table$widths[replace_col])
  height <- do.call(unit.c, lapply(keys, grobHeight))
  
  # Delete foreground content of the column to replace
  drop <- table$layout$l == replace_col & table$layout$t != 1
  drop <- drop & endsWith(table$layout$name, "-fg")
  table$grobs  <- table$grobs[!drop]
  table$layout <- table$layout[!drop, ]
  
  # Add keys to table
  table <- gtable_add_grob(
    table, keys, name = "key",
    t = seq_along(keys) + 1, 
    l = replace_col
  )
  
  # Set dimensions
  table$widths[replace_col] <- width
  table$heights[-1] <- unit.pmax(table$heights[-1], height)
  
  return(table)
}

base = synthetic.df %>%
  pivot_longer(-Time) %>%
  mutate(name = str_replace(name, "\\.\\.", ") ")) %>%
  ggplot() +
  geom_line(aes(x = Time, y = value, colour = name)) +
  scale_color_manual(labels = list("<span style = 'color:#0072B2; width:500px;'>A) Reference cc</span> T2", "2", "3", "4"), values = c(1:4)) +
  labs(colour = "Line  Cross Correlation") +
  theme(legend.text = element_markdown())

ccf(synthetic.df$A..Reference, synthetic.df$D..Inverse2, plot = FALSE)

titles = data.frame("Sample"= c(0,0,0,0), 
                    `Cross_Correlation` = c("Reference","1","-1", "-0.277"))

table <- tableGrob(titles,
                   cols = c("Sample", "Cross Correlation"),
                   rows = NULL)


madetable = add_legend_column(table, base, 1)

row1 = ((base + theme(legend.position = "none")) + madetable)

pl2 =vascr_plot_line(c2 %>% vascr_summarise("summary"))

row2 = (pl2 + cowplot::get_legend(pl2))


c1 = combined %>% vascr_subset(unit ="Rb", frequency = 0)

unique(c1$Sample)

c2 = c1 %>% vascr_subset(sample = c("500 pg.ml.TNFa + Water Vehicle + 80000 HCMVEC",
                                    "500 pg.ml.IL1b + Water Vehicle + 80000 HCMVEC",
                                    "Water Vehicle + 80000 HCMVEC"),
                         time = c(47,47+24)) %>%
  mutate(SampleID = as.numeric(Sample)) %>%
  vascr_resample_time(npoints = 50)


c2 = c2 # %>% vascr_subset(experiment = c(1,2)) %>% ungroup()

vascr_plot_cc_stats(c2, unit = "Rb", frequency = 0, points = TRUE)

vascr_plot_line(c2 %>% vascr_summarise("experiments"))


vascr_plot_line(c2)

vascr_summarise_cc_stretch_shift_stats(c2, unit = "Rb", frequency = 0)
vascr_plot_cc_stretch_shift_stats(c2, unit = "Rb", frequency = 0)


cc_df = vascr_cc(c2, cc_only = FALSE)

cc_exp = cc_df  %>% vascr_summarise_cc("experiments") %>% mutate(Experiment.x = Experiment, Experiment.y = Experiment)

xcor = vascr_plot_cc_stats(cc_exp, points = TRUE)


cc_exp2 = cc_df  %>% 
  mutate(cc = stretch_shift_cc) %>%
  vascr_summarise_cc("experiments") %>% 
  mutate(Experiment.x = Experiment, Experiment.y = Experiment)

xcor2 = vascr_plot_cc_stats(cc_exp2, points = TRUE)





base + theme(legend.position = "none") + madetable +
  pl2 + theme(legend.position = "none") + cowplot::get_legend(pl2) +
  xcor + theme(legend.position = "none") + cowplot::get_legend(xcor) +
  plot_layout(ncol = 2)
  






