library(gridExtra)
library(ggplot2)
library(tidyverse)
library(dplyr)
shootings <- read.csv('https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/shootings_wash_post.csv')

#Shootings by race, gender, and age

shooting_by_race <-
  shootings %>%
  group_by(race, na.rm = TRUE) %>%
  summarise(name_count=n())

shooting_by_gender <- 
  shootings %>%
  group_by(gender, na.rm = TRUE)%>%
  summarise(name_count=n())

shooting_by_age <-
  shootings %>%
  group_by(age, na.rm = TRUE)%>%
  summarise(name_count=n())

Police_Shootings_By_Race_2015_to_2020 <- shooting_by_race$name_count
Police_Shootings_By_Age_2015_to_2020 <- shooting_by_age$name_count
Police_Shootings_By_Gender_2015_to_2020 <- shooting_by_gender$name_count
par(mfrow=c(1,3))   

race_pie<-ggplot(shooting_by_race, aes(x="", y=Police_Shootings_By_Race_2015_to_2020, fill=race)) +
  geom_bar(stat="identity", width=1) + 
  coord_polar("y", start=0)

age_pie<-ggplot(shooting_by_age, aes(x="", y=Police_Shootings_By_Age_2015_to_2020, fill=age)) + 
  geom_bar(stat="identity", width=1) + 
  coord_polar("y", start=0)

gender_pie<-ggplot(shooting_by_gender, aes(x="", y=Police_Shootings_By_Gender_2015_to_2020, fill=gender)) +
  geom_bar(stat="identity", width=1) + 
  coord_polar("y", start=0)

grid.arrange(race_pie, age_pie, gender_pie, ncol=3)

#Description on the pie charts

#All three of the pie charts represent reported cases of police killings (by shooting) across three metrics: race, gender and age.
#These charts cover the years 2015-2020. As shown by the pies, white people have been killed the most by police. However, white people
#make up 75% of the U.S. population, while Black people make up only 13%. Because of this, it's clear to see that Black victims are 
#killed at a disproportionate rate compared to white victims. When looking at the age graph, it's clear that younger people are killed 
#much more by the police. Similarly, the gender pie chart shows men are much more likely to die at the hands of the police.
