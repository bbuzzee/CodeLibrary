# Useful tricks and examples from the purrr packages
library(tidyverse)

# 1. Creating a cumulative sum that resets at a certain points

df <- data.frame(id = rep(1:5, each = 5),
                 date = 1:25)

df <- df %>% group_by(id) %>% mutate(time_diff = date - lag(date))
df$time_diff <- ifelse(is.na(df$time_diff), 0, df$time_diff)


df %>% mutate(cumsum_2 = accumulate(time_diff, ~ifelse(.x + .y <= 2, .x + .y, .y)))
