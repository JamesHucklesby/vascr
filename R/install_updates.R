# 
# # Count how many lines are in this package, cos
# 
# library(dplyr)
# library(stringr)
# # Count your lines of R code
# list.files(path = "/Users/jhuc964/Desktop/ECIS R/ECISR/R", recursive = T, full.names = T) %>%
#   str_subset("[.][R]$") %>%
#   sapply(function(x) x %>% readLines() %>% length()) %>%
#   sum()
