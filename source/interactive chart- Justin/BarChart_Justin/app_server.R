library(tidyverse)
library(shiny)
library(scales)
library(plotly)

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

# server

server <- function(input, output) {

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
  
}
