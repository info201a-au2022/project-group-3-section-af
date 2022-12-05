library(shiny)

# source server and ui
source("app_server.R")
source("app_ui.R")

shinyApp(ui = ui, server = server)
