library(shiny)
library(shinyWidgets)
library(DT)
library(shinyjs)
library(tidyverse)
library(rhandsontable)
library(RefManageR)
library(formatR)
library(tools)
library(dplR)

# tidy_dir(width = 60) get any changes system('git pull')

source("src/make_df.R")
update_library()

source("src/functions.R")

source("src/server.r")
source("src/ui.r")

a <- shinyApp(ui = ui, server = server)

runApp(a, launch.browser = T, quiet = F)
