library(shiny)
library(shinythemes)
library(knitr)


Home <- tabPanel(
  "About",
  fluidPage(
  includeMarkdown("home.Rmd"))
  )

About <- tabPanel(
  "More about...",
  mainPanel(
  includeMarkdown("Mabout.Rmd"))
  )


barChart <- tabPanel(
  "Criminal Arrests",
  titlePanel(
    "How Might Criminal Activity Vary Between Different Races and Sex?"
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("demographic", "Select Racial/Sex Data",
                  choices = c("Sex", "Race"),
                  selected = "Sex",
                  ),
      sliderInput("year", "Year Range",
                  min = min_year, max = max_year,
                  value = c(min_year, max_year),
                  step = 1)
    ),
    mainPanel(
      plotlyOutput("bar"),
      h4(p("One of the main complaints regarding police violence is the biases against
        each individual's differing demographics. To highlight any concerns
        of the topic, we decided to visit the amount of criminal arrests throughout each
        year and illustrate the numbers through racial and sex identification. With
        the visualization, we can determine how the focus has changed over the past years."))
    )
  )
)

# Summary Takeaway Page

summary <- tabPanel(
  "Summary",
  titlePanel(
    "Key Takeaways for Our Community's Future"
  ),
  sidebarLayout(
    sidebarPanel(
      h4(p("When observing who is primarily identified as criminal subjects,
        there is a heavy emphasis on the",
        strong("Black and White communities"),
        "worldwide with the White community being arrested",
        strong("over double"),
        "the amount of black people.
        The large pool of arrested criminals were mainly identified as males opposed
        to females.")),
      h4(p("When analyzing the amount of casualities from police violence, we found that
        there was a", strong("nearly equal proportion of deaths"),
        "between the White community
        and the Black/Hispanic community. While these communities have shown stable
        porportions thoughout the past decades, some smaller communities have been
        increasing overtime, specifically Native Americans and Middle Eastern 
        communities. 
        The patterns in arrests remains relevant
        to the amount of deaths caused by police forces, where males are more
        likely to die in comparion to females.")),
      h4(p("Furthermore, we found that the most common sources of casualities for both
        the citizens and the police forces all result from gunfire. This trend has continued
        since the year", strong("2000"), "and continues to be the major cause of death
        with the amount of victims steadily increasing yearly."))
    ),
    mainPanel(
      dataTableOutput("data_table")
    )
  )
)

pie_chart <- tabPanel(
  "Police Shootings",
  titlePanel("police shootings (fatal) across race and gender"),
  sidebarLayout(
    sidebarPanel(
      selectInput("UseStatistic", "Use Statistic:", choices = c("Race","Gender")),
      checkboxGroupInput("Year", label = h3("Year"),
                         choices = list(2015,2016,2017,2018,2019,2020),
                         selected = 2015),
      hr(),
      
      hr(),
      fluidRow(
        
        
        column(4, verbatimTextOutput("value")),
        column(4, verbatimTextOutput("Years")))
      
    ),
    mainPanel(
      tableOutput("Year"),
      #plotOutput(outputId = "distPlot"),
      plotOutput("distPie"), #pie in server needs this call
      tableOutput("table"),
      h4( p("All three of the pie charts represent reported cases of police killings (by shooting) across three metrics: race, gender and age.
            These charts cover the years 2015-2020. As shown by the pies, white people have been killed the most by police. However, white people
            make up 75% of the U.S. population, while Black people make up only 13%. Because of this, it's clear to see that Black victims are 
            killed at a disproportionate rate compared to white victims. When looking at the age graph, it's clear that younger people are killed 
            much more by the police. Similarly, the gender pie chart shows men are much more likely to die at the hands of the police."))
    )
  )
)

wave_chart <- tabPanel(
  "Fatal Encounters",
  titlePanel(
    "racial and gender statistics
      of fatal encounters in the United States"
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("raceorsex", "select racial/sex data",
                     choices = c("Sex","Race"),
                    selected = "Race"),
      #selectInput("dateRange", 
                     #label = "select start year",
                     #choices = 2000:2018
                    #)
      ),
    mainPanel(
      plotOutput("wave"),
      h4(p("This graph illustrate the racial and gender statistics
            for fatal encounters in the United States from 1/1/00 to 8/18/20. 
            The fatal encounters of Native American/Alaskan had been increasing while
            that of Middle Eastern had been decreasing in recent years."))
    )
  )
)

# ui, using tabPanel

ui <- fluidPage(
  navbarPage(title = "Police Violence and Racial Inequity in the United States",
  theme = shinytheme("cosmo"),
  tabPanel(title = "Introduction",
           mainPanel(Home)),
  barChart,
  pie_chart,
  wave_chart,
  summary,
  About
  )
)


