library(dplyr)
library(tidyverse)
library(ggplot2)
#estimate data densities and draws ridgelines
library(ggridges)

# Chart that calculates the fatal crimes from 01.01.00 to 08.18.20
# in the United States
fatal_encounters <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/0b7466c8bba5047c5903526111d3254c6b784fa7/data/Part%201%20data/fatal_encounters_dot_org.csv")
# change to date format
fatal_encounters$Date <- as.Date(fatal_encounters$Date.of.injury.resulting.in.death..month.day.year., "%m/%d/%Y")

dz_2 <- fatal_encounters %>%
  group_by(Date)
#remove the last row: the spacer row.
dz_1 <- head(dz_2, -1)
dz_1$race <- dz_1$Subject.s.race.with.imputations
unique(dz_1$Subject.s.gender)
#Chart for Fatal encounters by race
ggplot(data = dz_1, aes(x = Date, y = race, fill = race)) +
  geom_density_ridges(stat="binline", bins=10) +
  theme_ridges() +
  ggtitle("Fatal encounters") +
  theme(legend.position = "none")
dz_1$gender <- dz_1$Subject.s.gender
#Chart for Fatal encounters by gender
ggplot(data = dz_1, aes(x = Date, y = gender, fill=gender)) +
  geom_density_ridges() +
  theme_ridges() +
  theme(legend.position = "none")

#Description of the chart(s) for the .Rmd
#This graph illustrate the ratial statistics and statistics of gender
#for fatal encounters in the United States from 1/1/00 to 8/18/20. 
# The fatal encounters of Native American/Alaskan had been increasing while
# that of Middle Eastern had been decreasing in recent years.