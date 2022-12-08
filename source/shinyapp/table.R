library(knitr)
library(tidyverse)

# Creates data frame of summary information
# *Data collected previously was already grouped by years for ease
# Don't forget to run summary_info.R to get data!

summary_values <- data.frame(year = summary_info$sex_arrests$year) %>%
  left_join(summary_info$sex_arrests, by = "year") %>% 
  left_join(summary_info$race_arrests, by = "year") %>% 
  left_join(summary_info$common_fatality_type, by = "year") %>% 
  left_join(summary_info$common_police_fatality, by = "year") %>% 
  distinct(year, .keep_all = T) %>% 
  filter(year >= 2000)
colnames(summary_values) <- c("Year",
                              "Total Arrests",
                              "Male Arrests Percentage",
                              "Female Arrests Percentage",
                              "White Arrests",
                              "Black Arrests",
                              "Asian & Pacific Islander Arrests",
                              "American Indian Arrests",
                              "Common Victim Death Cause",
                              "Number of Victim Deaths by Cause",
                              "Percentage of Deaths by Cause",
                              "Common Police Death Cause",
                              "Number of Police Deaths by Cause",
                              "Percentage of Deaths by Cause"
                              )

# turn data frame into table
# kable(summary_values)



  