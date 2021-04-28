# Script for calculating a few key summaries
# for Zetland article

library(platowork)
library(dplyr)

plato %>%
  group_by(subject, stimulus) %>%
  summarise(mean_wpm = mean(wpm))
