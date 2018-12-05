library(shiny)
library(DT)
library(shinyjs)
library(tidyverse)
library(rhandsontable)
library(RefManageR)
library(formatR)
library(tools)
library(dplR)

options(shiny.launch.browser = T)
#tidy_dir(width = 70)

# get any changes
# system("git pull")

source("make_df.R")
update_library()

source("functions.R")

source("server.r")
source("ui.r")

a <- shinyApp(ui = ui, server = server)

runApp(a, launch.browser = T, quiet = F)
