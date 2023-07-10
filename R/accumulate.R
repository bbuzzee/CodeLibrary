# Useful tricks and examples from the purrr packages
library(tidyverse)


# Purpose:  Creating a cumulative sum that resets at after a certain amount
# is accumulated. Note: The below accumulates time between all observations,
# not particular events.

#===================
# Set Up dummy data
#===================

df <- data.frame(id = rep(1:5, each = 5),
                 date = 1:25)

#=============================================
# Create a variable that is the amount of time
# that has passed since the last observation
#=============================================

df <- df %>% group_by(id) %>% mutate(time_diff = date - lag(date))

# all first observations are NA, so we can recode them as 0 time-since-last obs
df$time_diff <- ifelse(is.na(df$time_diff), 0, df$time_diff)

# apply the accumulate function
# Note: We can change the constant 2 to any value we want
df %>% mutate(cumsum_2 = accumulate(time_diff, ~ifelse(.x + .y <= 2, .x + .y, .y)))
