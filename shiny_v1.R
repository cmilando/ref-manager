library(shiny)
library(DT)
library(shinyjs)
library(tidyverse)
library(RefManageR)

options(shiny.launch.browser = T)

source('make_df.R')
update_library()

source('functions.R')

source('server.r')
source('ui.r')

a <- shinyApp(ui = ui, server = server)

runApp(a, launch.browser = T, quiet = F)
