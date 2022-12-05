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
