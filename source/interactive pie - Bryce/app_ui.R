
#create ui
ui <- fluidPage(
  titlePanel("Data Analysis"),
  sidebarLayout(
    sidebarPanel(
      selectInput("UseStatistic", "Use Statistic:", choices = c("Race","Gender")),
      checkboxGroupInput("Year", label = h3("Year"),
                         choices = list(2015,2016,2017,2018,2019,2020)),
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
      tableOutput("table")
    )
  )
)