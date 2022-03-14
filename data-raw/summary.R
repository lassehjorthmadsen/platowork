# Script for calculating a few key summaries
# for Zetland article

library(platowork)
library(tidyverse)
library(lubridate)

# Overall means
plato %>%
  group_by(subject, stimulus) %>%
  summarise(mean_wpm = mean(wpm))

# Summary for chart
data_summary <- plato %>%
  group_by(subject, session, stimulus) %>%
  summarise(mean_wpm = mean(wpm),
            .groups = "drop")

data_summary %>%
  ggplot(aes(x = session, y = mean_wpm, shape = stimulus, color = subject, group = subject)) +
  geom_point(size = 3) +
  geom_line(color = "grey", size = 1) +
  labs(title = "Performance in speed typing tests with or without tDCS stimulus",
       subtitle = "Each dot represent average results of speed typing test for one session.",
       caption = "Two subjects, double blind experiment with unknown stimulus\nSpeed typing tests performed at 10fastfingers.com. Analysis by @lassehmadsen",
       x = "Session number",
       y = "wpm, words-per-minute")

data_summary2 <- plato %>%
  mutate(session_align = case_when(subject == "Lasse" & session == 1 ~ 1,
                                   subject == "Lasse" & session <= 7 ~ session - 1,
                                   subject == "Lasse" ~ session - 2,
                                   TRUE ~ session + 0)) %>%
  group_by(subject, session_align, stimulus) %>%
  summarise(mean_wpm = mean(wpm),
            .groups = "drop")

data_summary2 %>%
  ggplot(aes(x = session_align, y = mean_wpm, shape = stimulus, color = subject, group = subject)) +
  geom_point(size = 3) +
  geom_line(color = "grey", size = 1) +
  labs(title = "Performance in speed typing tests with or without tDCS stimulus",
       subtitle = "Each dot represent average results of speed typing test for one session.",
       caption = "Two subjects, double blind experiment with unknown stimulus\nSpeed typing tests performed at 10fastfingers.com. Analysis by @lassehmadsen",
       x = "Session number",
       y = "wpm, words-per-minute")

data_summary2 %>%
  pivot_wider(names_from = subject, values_from = mean_wpm) %>%
  write.csv2(file = "c:/Users/Lasse/Desktop/summary.csv", row.names = F)
