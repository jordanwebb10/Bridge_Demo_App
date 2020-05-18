#### BridgeAthletic Demo App Script
## Written by: Jordan Webb and Dominic Angelotti
# Last Updated: 5/17/2020

## Load the needed libraries
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(flexdashboard)
library(tidyverse)

## Load in the data
## Still working on this part to read right from Google Drive
#id <- "1CssDVrdWWM320brINIVT0gF9aUiWKpBtRwnjfU-Wa4Q"
#demoData <- read.csv(sprintf("https://drive.google.com/open?id=%s",id))

demoApp.UI <- dashboardPage(skin = "blue", dashboardHeader(title = "ProActive Sports Performance"),
                            # create sidebar with home page
                            dashboardSidebar(sidebarMenu(menuItem("Forms Analysis",tabName = "forms", icon = icon("home")))),
                            
                            dashboardBody(tabItems(tabItem("forms", 
                                                           tagList(
                                                             fluidPage(
                                                               chooseSliderSkin("Modern"), setSliderColor("LightSeaGreen",1),
                                                               fluidRow(
                                                                 box(width = 6, title = "Box1", status = "info", solidHeader = T,
                                                                     flexdashboard::gaugeOutput("gauge1",width = "100%", height = "auto")),
                                                                 box(width = 6, title = "Box2", status = "info", solidHeader = T,
                                                                     flexdashboard::gaugeOutput("gauge2",width = "100%", height = "auto"))
                                                               ),
                                                               fluidRow(
                                                                 box(width = 12, title = "Box3", status = "info", solidHeader = T,
                                                                     fluidRow(
                                                                       column(width = 3,
                                                                              selectInput("chooseName",label = "Choose a person's name", 
                                                                                choices = c(), multiple = FALSE),
                                                                              actionBttn("showPlot","Plot",style = "material-flat",color = "default",
                                                                                         size = "sm")
                                                                       ),
                                                                       column(width = 9, 
                                                                              plotOutput("plot1")
                                                                       ))
                                                                 )
                                                               )
                                                           ))
                            
                                          )
                                    )
                            )
)

demoApp.Server <- function(input, output, session) {
  
  output$gauge1 <- flexdashboard::renderGauge({
    flexdashboard::gauge(
      value = 10, # change this to be data we want
      label = "Result 1", min = 0, max = 10, symbol = "%",
      sectors = gaugeSectors(success = c(8,10), warning = c(4,7), danger = c(0,3))
    )
  })
  
  output$gauge2 <- flexdashboard::renderGauge({
    flexdashboard::gauge(
      value = 5, # change this to be data we want
      label = "Result 2", min = 0, max = 5, symbol = "%",
      sectors = gaugeSectors(success = c(0,3), warning = c(4,7), danger = c(8,10))
    )
  })
  
  observeEvent(input$showPlot, {
    
    varName <- input$chooseName
    
    output$plot1 <- renderPlot({
      ggplot()
    })
  })
  
}

shinyApp(ui = demoApp.UI, server = demoApp.Server)

