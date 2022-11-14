library(tidyverse)

# Creates a list of summarized information from the data sets used for the
# project proposal

# Importing relevant crime data sets
deaths_arrest <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/deaths_arrests.csv")
deaths_arrest <- filter(deaths_arrest, State != "")

fatal_encounters <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/fatal_encounters_dot_org.csv")
police_deaths <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/police_deaths_538.csv")
police_killings <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/police_killings_MPV.csv")
washington_post_shootings <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/shootings_wash_post.csv")
adult_arrests <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%202%20data/crime_data/arrests_national_adults.csv")

summary_info <- list()

# Counts the total amount of observations from all the relevant crime data sets
summary_info$total_observations <- sum(nrow(deaths_arrest), nrow(fatal_encounters),
  nrow(police_deaths), nrow(police_killings), nrow(washington_post_shootings),
  nrow(adult_arrests))

# Gives the total amount of adult arrests, split by sexes in percentage 
# from 1994-2014 (accumulative)
summary_info$"1994_2014_adult_arrests" <- adult_arrests %>% 
  summarise(total_arrests = sum(total_male, total_female), 
            total_male_arrests_percent = 
              ceiling(sum(total_male) / sum(total_male, total_female)* 100), 
            total_female_arrests_percent = 
              floor(sum(total_female) / sum(total_male, total_female) * 100))

# Average annual police homicide rate from 2013-2019 in percentage
summary_info$ave_ann_police_homicide <- deaths_arrest %>% 
  filter(City == "Nationwide Average") %>% 
  pull(Avg.Annual.Police.Homicide.Rate)

# Gathers the total occurrences of the types of fatal encounters from
# 2010-2020

summary_info$fatality_type <- fatal_encounters %>% 
  filter(Cause.of.death != "") %>% 
  count(Cause.of.death, sort = T) %>% 
  mutate(percent = round(n / sum(n) * 100, 2))

# Gathers the total occurrences of police deaths from 2010-2016 nationally

summary_info$police_fatality <- police_deaths %>% 
  filter(between(year, 2010, 2016)) %>% 
  count(cause_short, sort = T) %>% 
  mutate(percent = round(n / sum(n) * 100, 2))

# Gathers the number of police killings by race in percentages from 2013-2020

summary_info$victims_police_killed_race <- police_killings %>% 
  filter(Victim.s.race != "Unknown race") %>% 
  count(Victim.s.race, sort = T) %>% 
  mutate(percent = round(n / sum(n) * 100, 2))

# Counts up the number of casualties of each state via shootings from
# 2015-2020 from the Washington Post data

summary_info$state_casualties <- washington_post_shootings %>% 
  count(state, sort = T) %>% 
  mutate(percent = round(n / sum(n) * 100, 2))

  
  
  
  

  

