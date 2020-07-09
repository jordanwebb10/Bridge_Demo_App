#### Demo App for Milind Testing Purposes
## Written by: Dominic Angelotti

## Source modules
source("BodySidebarFunctions.R")
source("sampleGraphModule.R")
source("sampleModelModule.R")
source("sampleDataModule.R")

## Load packages
library(tidyverse) # library for data wrangling and manipulations
library(shiny) # library for dashboarding
library(shinyBS) # library for dashboarding (extra options)
library(shinydashboard) # advanced dashboarding
library(shinydashboardPlus) # advanced dashboarding
library(flexdashboard) # dashboarding
library(shinyjs) # customized dashboard options
library(shinyWidgets) # advanced dashboarding extras
library(plotly) # plotting package
library(DT) # table to render data tables
library(caret) # table for large amount of statistical modeling functions
library(ggthemes) # package for extra plotting themes
library(odbc) # package for database connection
library(DBI) # package for database connection
library(rmarkdown) # package for reporting out nicely
library(class) # package for modeling (knn)

## Load in the mtcars data set
data <- read.csv("iris.csv")

## Create dashboard UI
ui <- dashboardPage(header = dashboardHeader(title = "Sample Test App"),
                    sidebar = sampleSidebar(), 
                    body = sampleBody(), skin = "blue")

## Create dashboard server
server <- function(input, output, session) {
  # call server parts of modules
  callModule(graph_Server, "sampleGraph", df = data)
  callModule(model_server, "sampleModel", df = data)
  callModule(data_server, "sampleData", df = data)
}

## Run the app
shinyApp(ui = ui, server = server)
