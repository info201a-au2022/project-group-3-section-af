library(shiny)
library(tidyverse)
library(scales)
library(knitr)
library(markdown)
#source
source("app_server.R")
source("app_ui.R")


shinyApp(ui = ui, server = server)
