#' zeroed = growth.df %>% vascr_subset(unit = "R", frequency = "4000") %>%
#'           vascr_zero_time(100)
#'           
#' zeroed %>% vascr_plot_line()