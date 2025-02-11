
ecis_1 = vascr_import("ECIS", 
                      raw = "C:\\Users\\James Hucklesby\\Documents\\vascr\\raw_data\\growth\\growth1_raw.abp",
                      experiment = "1") %>%
  filter(Time<200)

e1s = ecis_1 %>% filter(Well %in% c("A01", "A02")) %>%
            filter(Time <5) %>%
            filter(Frequency  == 4000) %>%
            filter(Unit == "R")


p1a = ggplot(e1s) +
  geom_point(aes(x = Time, y = Value, color = Well)) +
  geom_vline(aes(xintercept = Time, color = Well), alpha = 0.3) +
  labs(tag = "A")

p1a

p1b = e1s %>% vascr_resample_time() %>% ggplot() +
  geom_point(aes(x = Time, y = Value, color = Well)) +
  geom_vline(aes(xintercept = Time, color = Well), alpha = 0.3)+
  labs(tag = "B")

p1b

p1c = e1s %>% vascr_resample_time(40) %>% ggplot() +
  geom_point(aes(x = Time, y = Value, color = Well)) +
  geom_vline(aes(xintercept = Time, color = Well), alpha = 0.3)+
  labs(tag = "C")

p1c

p1d = ecis_1 %>% vascr_plot_resample(151, rug = FALSE) +
  labs(tag = "D") +
  scale_color_manual(values = c("darkgreen", "darkblue"))

p1d

      # e1s %>% vascr_plot_resample(151, plot = FALSE)


# p1d = ecis_1 %>% vascr_plot_resample_range()
#      ecis_1 %>% vascr_plot_resample_range(plot = FALSE)
# 
# p1d

map = "
ba
ca
da
cd"

p1a / p1b / p1c /p1d + plot_layout(ncol = 1, guides = "collect")





growth.df %>% 

