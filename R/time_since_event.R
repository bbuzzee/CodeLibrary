# time-since-event

# The goal of this script is to create a new variable in our dataset
# that represents the time since the most recent "event" has occurred
# where an "event" can be anything represented by an indicator variable

library(lubridate)
library(data.table)
library(tidyverse)

#=====================
# Create dummy data
#=====================

# Each row is a patient ID, a date, and an event indicator variable
# Note: person 2 has two events
df <- data.frame(id = rep(1:2, each = 10),
                 date = 20200101:20200120,
                 event_indicator = rep(0, times = 20))

# add event occurrences
df$event_indicator[c(5, 15, 18)] <- 1

head(df)

#=============================================
# Step 1: Create a variable that is the date 
# when the event occurs and missing otherwise.
# Note: This only seems to work for integer dates
#=============================================

df <- df %>% mutate(event_date = ifelse(event_indicator == 1, date, NA_integer_))

#=========================================
# Step 2: use data.table's nafill function 
# to create a new variable that represents
# the last non-missing value, carried forward from the event on.
#========================================

dt <- setDT(df)[, last_event_date := (nafill(event_date, "locf")), by = id]


#========================================================
# Step 3: Convert integer dates to a date format using lubridate, then subtract
#========================================================

dt$date <- ymd(dt$date)
dt$last_event_date <- ymd(dt$last_event_date)

time_since_event_dt <- new_dt[, time_since_last_event := date - last_event_date,]

#=====================================================
# Now our final dataset time_since_event_dt, has a variable that tracks how
# long it's been since the last event, where NA values
# indicate that an event has not occurred yet.
#======================================================
