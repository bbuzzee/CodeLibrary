# A demonstration of the accumulate function
# from the purrr package

library(tidyverse)

# Purpose: Creating a cumulative sum variable that resets 
# after a certain threshold is met. 
# Note: The below accumulates time between all (potentially grouped)
# observations, not particular events.


#==============================================================
# Set Up Dummy Data
# Note: We are not using real dates/date formats in this example
#==============================================================

# 'id' represents a unique identification code assigned
#  to each individual, with multiple observations per person
df <- data.frame(id = rep(1:5, each = 5),
                 date = 1:25)


#=============================================
# Create a variable that represents the amount of time
# that has passed since the last *observation*
#=============================================

df <- df %>% group_by(id) %>% mutate(time_diff = date - lag(date))

# all lags of first observations are NA, so we can recode them as 0
df$time_diff <- ifelse(test = is.na(df$time_diff),
                       yes  = 0, 
                       no   = df$time_diff)


#======================================
# Apply resetting accumulation function
#======================================

# apply the accumulate function
# Note: We can change the constant "2" to any value we want
df %>% mutate(cumsum_2 = accumulate(time_diff, ~ifelse(test = .x + .y <= 2,
                                                       yes  = .x + .y,
                                                       no   = .y)))
