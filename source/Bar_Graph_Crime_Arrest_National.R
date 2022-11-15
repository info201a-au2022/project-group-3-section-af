library(tidyverse)
library(ggplot2)
#Allows for x & y plots to display with commas in values instead of "e"
library(scales)

# Chart that calculates the total amount of crimes from the U.S. 1994-2016
national_adult_crime <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%202%20data/crime_data/arrests_national_adults.csv")

df_2 <- national_adult_crime %>% 
  group_by(year) %>% 
  summarise(year = year, total_male_crimes = sum(total_male, na.rm = T),
            total_female_crimes = sum(total_female, na.rm = T), 
            total_white = sum(white, na.rm = T),
            total_black = sum(black, na.rm = T),
            total_asian_pacific_islander = sum(asian_pacific_islander, na.rm = T),
            total_american_indian = sum(american_indian, na.rm = T)
            ) %>% 
  distinct(year, .keep_all = T)

# Chart for representing data by sex  
sex_data <- df_2 %>% 
  select(year, total_male_crimes, total_female_crimes) %>% 
  gather(key = sex, value = reports, -year)

ggplot(sex_data) +
  geom_col(mapping = aes(x = year, y = reports, fill = sex), position = "dodge") +
  coord_cartesian(xlim = range(sex_data$year), ylim = range(sex_data$reports)) +
  scale_y_continuous(labels = comma,
                     breaks = seq(0,  max(sex_data$reports), 1000000)) +
  scale_x_continuous(breaks = seq(min(sex_data$year), max(sex_data$year), 1)) +
  labs(title = "Total Number of Adult Arrests by\nSex in the U.S.", x = "Year",
       y = "Reports",
       fill = "Sex") +
  scale_fill_manual(labels = c("Female", "Male"), 
                    values = c("#CC79A7", "#56B4E9")) +
  theme(plot.title = element_text(hjust = 0.5), 
        legend.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 90, size = 5))

# Chart for representing data by race
race_data <- df_2 %>% 
  select(year, total_white, total_black, total_asian_pacific_islander,
         total_american_indian) %>% 
  gather(key = race, value = reports, -year)

ggplot(race_data) + 
  geom_col(mapping = aes(x = year, y = reports, fill = race),
           position = "dodge") +
  coord_cartesian(xlim = range(race_data$year), 
                  ylim = range(race_data$reports)) +
  scale_y_continuous(labels = comma, 
                     breaks = seq(0, max(race_data$reports), 1000000)) +
  scale_x_continuous(breaks = seq(min(race_data$year), max(race_data$year), 1)) +
  labs(title = "Total Number of Adult Arrests by\nRace in the U.S.", x = "Year",
       y = "Reports", fill = "Race") +
  scale_fill_discrete(labels = c("American Indians", "Asian & Pacific Islander",
                                 "Black", "White")) +
  theme(plot.title = element_text(hjust = 0.5),
        legend.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 90, size = 5))  

# Description of the chart(s) for the .Rmd

# Both of these graphs illustrate the total number of adult arrests reported in
# the U.S. by the agencies from 1994-2016, with one graph representing the proportions of arrests
# by gender and the other graph showing the proportions by race. From these bar graphs,
# there is a hugely noticeable gap between the division of arrests against males versus females,
# and a stronger association of arrests being targeted towards the White & Black community as opposed
# to the Asian, Pacific Islander, and American Indians.

  

