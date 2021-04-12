# Script for reading and cleaning the original data

library(readxl)
library(dplyr)
library(tidyr)
library(magick)

# Read data from the riginal Excel used for recording
plato <- read_excel("data-raw/speed-type-data.xlsx")

# Add a session id; for each subject we group typing tests
# not separated by more than 60 mins into same sessions.
plato <- plato %>%
  arrange(subject, date) %>%
  group_by(subject) %>%
  mutate(
    time_diff = difftime(date, lag(date), units = "mins"),
    session = ifelse(time_diff > 60 | is.na(time_diff), row_number(), NA)
  ) %>%
  fill(session) %>%
  mutate(session = dense_rank(session)) %>%
  select(-time_diff) %>%
  ungroup()

# Add data file to the package
usethis::use_data(plato, overwrite = TRUE)

# Fix logo
image_read("tools/headset.png") %>%
  image_scale("150") %>%
  image_write(path = "tools/logo.png", format = "png")
