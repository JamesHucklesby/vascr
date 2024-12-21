choose.dir()

setwd("\\\\files.auckland.ac.nz\\myhome\\11) Impedance instruments compared\\Impedance instrument paper data")
library(tidyverse)
library(vascr)
library(plotly)
library(grid)
library(gridExtra)
devtools::load_all("C:/Vascr 2025/vascr")

#////////////////////////////////////////////////
# ECIS

ecis1 = ecis_import("ECIS/ECIS_200722_MFT_1.abp", "ECIS/ECIS_200722_MFT_1_RbA.csv", "Exp1")
ecis2 = ecis_import("ECIS/ECIS_200728_MFT_1.abp", "ECIS/ECIS_200728_MFT_1_RbA.csv", "Exp2")
ecis3 = ecis_import("ECIS/ECIS_200907_MFT_1.abp", "ECIS/ECIS_200907_MFT_1_RbA.csv", "Exp3")

ecis1n = vascr_apply_map(data.df = ecis1, map = "ECIS/200722_key.csv")
ecis2n = vascr_apply_map(ecis2, "ECIS/200728_key.csv")
ecis3n = vascr_apply_map(ecis3, "ECIS/200907_key.csv")

vascr_find_metadata(ecis1n)

ecis1r = ecis1n %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)
ecis2r = ecis2n %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)
ecis3r = ecis3n %>% vascr_subset(unit = "R", frequency =  4000) %>% vascr_interpolate_time(100)



ecis1r %>% select(Sample, SampleID) %>% distinct() %>% arrange(SampleID)


ecis1m = vascr_exclude(ecis1r, well = c("H01", "H02", "D02", "D03"))
vascr_plot_line(ecis1m)


ecis2m = vascr_exclude(ecis2r, well = c("H01", "H06", "D01", "D06"))
ecis2m = subset(ecis2m, ecis2m$Sample != "NA")
ggplot(ecis2m, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line()


ecis3m = vascr_exclude(ecis3r, well = c("H10", "H11"))
ecis3m = subset(ecis3m, ecis3m$Sample != "NA")
ggplot(ecis3m, aes(x = Time, y = Value, color = Sample, group = Well)) + geom_line()


# Combine experiments and check it works
ecis = vascr_combine(ecis1m, ecis2m, ecis3m)

