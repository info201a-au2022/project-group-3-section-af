library(shiny)

# Bar Chart Tab

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
      p("One of the main complaints regarding police violence is the biases against
        each individual's differing demographics. To highlight any concerns
        of the topic, we decided to visit the amount of criminal arrests throughout each
        year and illustrate the numbers through racial and sex identification. With
        the visualization, we can determine how the focus has changed over the past years.")
    )
  )
)

# ui, using tabPanel

ui <- navbarPage(header = tags$head(
  # Note the wrapping of the string in HTML()
  tags$style(HTML("
    @import url('https://fonts.googleapis.com/css2?family=Oswald&display=swap'); 
      body {
        background-color: black;
        color: white;
      }
      h2 {
        font-family: 'Oswald', sans-serif;
      }
      .shiny-input-container {
        color: #474747;
      }"))
  ),
  "INFO 201 AF- Group 3",
  barChart
)


