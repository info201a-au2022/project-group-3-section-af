server <- function(input, output) {
  
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