#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#install.packages("shinythemes")
library(shinythemes)

# Define UI for application that draws a histogram
page_one <- tabPanel(
  "First Page", # label for the tab in the navbar
  titlePanel("Page 1"), # show with a displayed title
  # This content uses a sidebar layout
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "username", label = "What is your name?")
    ),
    mainPanel(
      h3("Primary Content"),
      p("Plots, data tables, etc. would go here")
    )
  )
)
# Define content for the second page
page_two <- tabPanel("Our analysis",
                     includeHTML("index.html")
                
)
# Define content for the third page
page_three <- tabPanel(
  "Third Page" # label for the tab in the navbar
  # ...more content would go here...
)
# Pass each page to a multi-page layout (`navbarPage`)

ui <- navbarPage(theme = shinytheme("cosmo"),
  "My Application", # application title
  page_one, # include the first page content
  page_two, # include the second page content
  page_three # include the third page content
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
}

# Run the application 
shinyApp(ui = ui, server = server)

