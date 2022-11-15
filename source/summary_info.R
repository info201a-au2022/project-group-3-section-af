library(tidyverse)

# Creates a list of summarized information from the data sets used for the
# project proposal

# Importing relevant crime data sets

fatal_encounters <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/fatal_encounters_dot_org.csv")
police_deaths <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/police_deaths_538.csv")

police_killings <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/police_killings_MPV.csv")
police_killings$Date.of.Incident..month.day.year. <- format(as.Date(police_killings$Date.of.Incident..month.day.year., format = "%d/%m/%Y"), "%Y")

washington_post_shootings <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/shootings_wash_post.csv")
washington_post_shootings$date <- format(as.Date(washington_post_shootings$date, format = "%Y-%m-%d"), "%Y")

adult_arrests <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%202%20data/crime_data/arrests_national_adults.csv")

# All information summarized in the list is organized by year
summary_info <- list()

# Counts the total amount of arrests for each race per year
summary_info$race_arrests <- adult_arrests %>% 
  group_by(year) %>% 
  summarise(total_white = sum(white),
            total_black = sum(black),
            total_asian_pacific_islander = sum(asian_pacific_islander),
            total_american_indian = sum(american_indian))

# Gives the total amount of adult arrests, split by sexes in percentage 
# from 1994-2014 (accumulative)
summary_info$sex_arrests <- adult_arrests %>% 
  group_by(year) %>% 
  summarise(total_arrests = sum(total_male, total_female), 
            total_male_arrests_percent = 
              ceiling(sum(total_male) / sum(total_male, total_female)* 100), 
            total_female_arrests_percent = 
              floor(sum(total_female) / sum(total_male, total_female) * 100))

# Gathers the most common type of fatality per year, counting occurrences &
# percentage of deaths that year from 2000-2020

summary_info$common_fatality_type <- fatal_encounters %>% 
  group_by(Date..Year.) %>% 
  filter(Cause.of.death != "") %>% 
  filter(Date..Year. != 2100) %>% 
  count(Cause.of.death) %>% 
  mutate(percent = round(n / sum(n) * 100, 2)) %>% 
  filter(percent == max(percent)) %>% 
  rename(year = Date..Year.)

# Gathers the most common cause of police deaths, taking count of deaths and
# percentage of total deaths of the year 2000-2016

summary_info$common_police_fatality <- police_deaths %>% 
  group_by(year) %>% 
  filter(between(year, 2000, 2016)) %>% 
  count(cause_short) %>% 
  mutate(percent = round(n / sum(n) * 100, 2)) %>% 
  filter(percent == max(percent))

# Gathers the number of police killings by race in percentages from 2013-2020

summary_info$victims_police_killed_race <- police_killings %>% 
  group_by(Date.of.Incident..month.day.year.) %>% 
  filter(Victim.s.race != "Unknown race") %>% 
  count(Victim.s.race) %>% 
  mutate(percent = round(n / sum(n) * 100, 2)) %>% 
  rename(year = Date.of.Incident..month.day.year.)
  
# Counts up the number of casualties of each state via shootings from
# 2015-2020 from the Washington Post data

summary_info$state_casualties <- washington_post_shootings %>% 
  group_by(date) %>% 
  count(state) %>% 
  mutate(percent = round(n / sum(n) * 100, 2)) %>% 
  rename(year = date)

  
  
  
  

  

