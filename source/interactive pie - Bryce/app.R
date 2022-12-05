library(shiny)
library(ggplot2)
library(tidyverse)
library(shinyBS)

#sources
source("app_server.R")
source("app_ui.R")

shinyApp(ui = ui, server = server)
