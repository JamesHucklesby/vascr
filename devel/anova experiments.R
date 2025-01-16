# 
# anova_dat_unsum = growth.df %>% vascr_subset(unit= "R", frequency = 4000, time = 190)
# 
# res.aov <- anova_test(data = anova_dat_unsum, Value ~ Sample/Experiment)
# get_anova_table(res.aov)
# 
# 
# 
# res.aov <- anova_test (data = anova_dat_unsum, dv = Value,
#                        between = c(Sample, Experiment))
# res.aov
# 
# 
# 
# 
# 
# 
# 
# anova_dat_unsum$id = paste(anova_dat_unsum$Experiment)
# 
# res.aov <- anova_test(dv = Value, between = Sample, wid = Experiment, data = anova_dat_unsum)
# get_anova_table(res.aov)
# 
# res.aov <- anova_test( Value ~ Sample*Experiment, data = anova_dat_unsum)
# get_anova_table(res.aov)
# 
# lmd_all = lm(Value ~ Sample/Experiment, data = anova_dat_unsum)
# tukeyout = tukey_hsd(lmd)
# tukeyout
# 
# AIC(lmd)
# 
# 
# 
# anova_dat %>% group_by(Experiment) %>%
#   anova_test(between = Sample, dv = Value)
# 
# 
# 
# fit1.aov <- aov(Value~Sample/Experiment,anova_dat_unsum)
# summary(fit1.aov)
# 
# anova_dat = as.data.frame(anova_dat)
# anova_dat$bind = paste(anova_dat$Sample, anova_dat$Experiment)
# 
# anova_dat_unsum$Well = as.factor(anova_dat_unsum$Well)
# 
# anova_test(data = anova_dat_unsum, Value ~ Sample*Experiment)
# 
# anova_test(data = anova_dat, Value ~ Sample + Experiment)
# 
# 
# 
# aovmod = anova_test(anova_dat_unsum,
#            dv = Value,
#            between = Sample,
#            wid = Experiment
#            ) 
# 
# anova_table()
# 
# AIC(lmd)
# 
# tukey_hsd(aovmod)
# 
# 
# lm(Value ~ Sample + Error(Experiment), data = anova_dat_unsum)
# 
# 
# anova_dat = growth.df %>% vascr_subset(unit= "R", frequency = 4000, time = 190) %>% vascr_summarise(level = "Experiment") %>% ungroup()
# 
# at = anova_test(Value ~ Sample * Experiment, data = anova_dat_unsum)
# get_anova_table(at)
# 
# anova_test(data = anova_dat_unsum, dv = Value, between = c(Sample, Experiment))
# 
# get_anova_table(res.aov)
# 
# res.aov <- anova_test( Value ~ Experiment*Sample, data = anova_dat)
# get_anova_table(res.aov)
# 
# lmd_exp = lm(Value ~ Sample + Experiment, data = anova_dat)
# tukeyout = tukey_hsd(lmd)
# tukeyout
# 
# 
# AIC(lmd)
# 
# anova_dat_unsum$rand = anova_dat_unsum$Well %>% as.factor() %>% as.numeric()
# 
# 
# # lmd_all = lm(Value ~ Sample * Experiment, data = anova_dat_unsum)
# 
# lmd_all = lmer(Value ~ Sample + (1 | Experiment), data = anova_dat_unsum)
# lmd_simple = lm(Value ~ Sample*Experiment, data = anova_dat_unsum)
# lmd_exp = lm(Value ~ Sample + Experiment, data = anova_dat)
# 
# anova(lmd_exp)
# 
# library(emmeans)
# emmeans(lmd_all, list(pairwise ~ Sample), adjust = "tukey")
# emmeans(lmd_simple, list(pairwise ~ Sample), adjust = "tukey")
# emmeans(lmd_exp, list(pairwise ~ Sample), adjust = "tukey")
# # AIC(lmd_all)
# # AIC(lmd_exp)
# 
# lmd_all
# 
# Anova(lmd_all)
# Anova(lmd_exp)
# 
# TukeyHSD(lmd_exp)
# 
# 
# mvmod <- lm(cbind(Experiment, Value) ~ Sample, data= anova_dat_unsum)
# mvmod
# 
# Anova(mvmod)
# 
# 
# idata <- data.frame(Presentation = factor(c(Sample)))
# idata
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
