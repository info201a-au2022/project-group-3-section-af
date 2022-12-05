library(tidyverse)
library(shiny)
library(scales)
library(plotly)

# Interactive Chart (Justin)

server <- function(input, output) {

      # Chart that calculates the total amount of crimes from the U.S. 1994-2016
      national_adult_crime <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%202%20data/crime_data/arrests_national_adults.csv")
      
      df_2 <- national_adult_crime %>% 
        group_by(year) %>% 
        summarise(year = year, 
                  total_male_crimes = sum(total_male, na.rm = T),
                  total_female_crimes = sum(total_female, na.rm = T), 
                  total_white = sum(white, na.rm = T),
                  total_black = sum(black, na.rm = T),
                  total_asian_pacific_islander = sum(asian_pacific_islander, na.rm = T),
                  total_american_native = sum(american_indian, na.rm = T)
        ) %>% 
        distinct(year, .keep_all = T)
      
      # gather minimum year for slider range
      min_year <- min(df_2$year)
      
      # gather maximum year for slider range 
      max_year <- max(df_2$year)

# Summary Page calculations (Justin)
      # Code to create data table for summary page
      source("../summary_info.R")
      source("../table.R")

# server

#server <- function(input, output) {
  
  # Interactive Chart (Justin)
          
          # select data based on reactive input
          req_data <- reactive({
            
            if (req(input$demographic) == "Sex") {
              req_data = df_2 %>% select(year, total_male_crimes, total_female_crimes) %>% 
                rename("Male" = total_male_crimes, "Female" = total_female_crimes,)
            } else if (req(input$demographic) == "Race") {
              req_data = df_2 %>% select(year, total_white, total_black, total_asian_pacific_islander,
                                         total_american_native) %>% 
                rename("White" = total_white, "Black" = total_black, "Asian/Pacific Islander" = total_asian_pacific_islander,
                       "Native" = total_american_native)
            }
          })
          
          # Create plotly bar chart
          
          output$bar <- renderPlotly({
            df_3 <- req_data() %>% 
              gather(key = demo, value = reports, -year)
            
            ggplotly(
              ggplot(df_3) +
                geom_bar(mapping = aes(x = year, y = reports, fill = demo),
                         position = "dodge", stat = "identity") +
                scale_x_continuous(limits = c(input$year[1]- .5, input$year[2] + .5),
                                   breaks = seq(min_year, max_year, 1)) +
                scale_y_continuous(labels = comma) +
                labs(title = "Total Criminal Arrests by Demographics in the U.S.",
                     fill = "Demographic Information") +
                xlab("Year Range") +
                ylab("Reports") +
                theme(plot.title = element_text(hjust = 0.5), 
                      legend.title = element_text(hjust = 0.5),
                      axis.text.x = element_text(angle = 90, size = 5))
            )
          })
  
  # Summary Page (Justin)        
        
        # Create data table for summary page
        
        output$data_table <- renderDataTable(summary_values)
    
  
  SHOOTINGS <- reactive({
    SHOOTINGS <- data_aggregate %>% filter(Year %in% input$Year)# %>%
    # filter(Race %in% input$Race)# %>%
    #  filter(month >= input$month[1] & Year <= input$month[2])
    # if(is.null(input$Year))
    #  return()
    #SHOOTINGS
  })
  
  output$distPie <- renderPlot({
    # plot <- ggplot(data=SHOOTINGS(),aes(x=Race,y=Year))
    if (input$UseStatistic == "Race") {
      Plot <- ggplot(data=SHOOTINGS(), aes(x="", y=Count_Race, fill=Race)) +
        geom_bar(stat="identity", width=1) +
        coord_polar("y", start=0)+ theme(axis.text = element_blank(),
                                         axis.ticks = element_blank(),
                                         panel.grid  = element_blank(),
                                         panel.border = element_blank(),
                                         panel.background = element_blank(),
                                         axis.title=element_blank())
      Plot}
    else if (input$UseStatistic == "Gender"){
      Plot <- ggplot(data=SHOOTINGS(), aes(x="", y=Count_Gender, fill=Gender)) +
        geom_bar(stat="identity", width=1)  +
        coord_polar("y", start=0) + theme_bw() + theme(axis.text = element_blank(),
                                                       axis.ticks = element_blank(),
                                                       panel.border = element_blank(),
                                                       panel.grid  = element_blank(),
                                                       panel.background = element_blank(),
                                                       axis.title=element_blank())
      Plot}})
  output$table <- renderTable(sum_tab)
  
}
shootings <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-3-section-af/main/data/Part%201%20data/shootings_wash_post.csv")

#reformatting missing variables
shootings$race[shootings$race==""] <- "NA"
summary(factor(shootings$race))
shootings$gender[shootings$gender==""] <- "NA"

#extracting year from date
shootings$year <- as.numeric(substr(shootings$date,1,4))

#creating simplified data frames
shooting_by_race <-
  shootings %>%
  group_by(race, year) %>%
  summarise(name_count=n())

shooting_by_gender <-
  shootings %>%
  group_by(gender, year) %>%
  summarise(name_count=n())

#merge datasets to get repeating values from grouping to allow plotting
data_aggregate <- merge(shooting_by_race,shooting_by_gender,by="year")

data_aggregate$gender <- ifelse(data_aggregate$gender=="M","Male",
                                ifelse(data_aggregate$gender=="F","Female","Unknown"))

data_aggregate$race <- ifelse(data_aggregate$race=="A","Asian",
                              ifelse(data_aggregate$race=="B","Black",
                                     ifelse(data_aggregate$race=="H","Hispanic",
                                            ifelse(data_aggregate$race=="N","NA/AI",
                                                   ifelse(data_aggregate$race=="O","Other",
                                                          ifelse(data_aggregate$race=="W","White","Missing"))))))
colnames(data_aggregate) <- c("Year","Race","Count_Race","Gender","Count_Gender")


#create dataset for table

sum_tab <-
  shootings %>%
  group_by(year,race,gender) %>%
  summarise(name_count=n())

#clean variables for table

#calculate rate
sum_tab$RatePer100k <- round((sum_tab$name_count/3251000)*100000,2)

sum_tab$year <- as.integer(sum_tab$year)
sum_tab$gender <- ifelse(sum_tab$gender=="M","Male",
                         ifelse(sum_tab$gender=="F","Female","Unknown"))
sum_tab$gender <- factor(sum_tab$gender,levels=c("Male","Female","Unknown"))

sum_tab$race <- ifelse(sum_tab$race=="A","Asian",
                       ifelse(sum_tab$race=="B","Black",
                              ifelse(sum_tab$race=="H","Hispanic",
                                     ifelse(sum_tab$race=="N","NA/AI",
                                            ifelse(sum_tab$race=="O","Other",
                                                   ifelse(sum_tab$race=="W","White","Missing"))))))

sum_tab$race <- factor(sum_tab$race,levels=c("Asian","Black","Hispanic","NA/AI","Other","White","Missing"))

colnames(sum_tab) <- c("Year","Race","Gender","Count","RatePer100k")




