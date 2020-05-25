#### BridgeAthletic Demo App Script
## Written by: Jordan Webb and Dominic Angelotti
# Last Updated: 5/17/2020

## Load the needed libraries
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(rmarkdown)
library(flexdashboard)
library(tidyverse)
library(shinipsum)
library(plotly)

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
                                                                       column(width = 2,
                                                                              selectInput("chooseName",label = "Choose a person's name", 
                                                                                choices = c("Dom","Jordan"), multiple = FALSE, width = '100%'),
                                                                              actionBttn("showPlot","Plot",style = "material-flat",color = "success",
                                                                                         size = "sm", block = T),br(),
                                                                              downloadBttn("report", "Download Report", style = "material-flat",
                                                                                           color = "default", size = "sm", block = T)
                                                                       ),
                                                                       column(width = 10, 
                                                                              plotlyOutput("plot1")
                                                                       ))
                                                                 )
                                                               )
                                                           ))
                            
                                          )
                                    )
                            )
)

demoApp.Server <- function(input, output, session) {
  
  # creat reactive values
  rvs <- reactiveValues(plot = NULL)
  
  # gauge1 output
  output$gauge1 <- flexdashboard::renderGauge({
    flexdashboard::gauge(
      value = 10, # change this to be data we want
      label = "Result 1", min = 0, max = 10, symbol = "%",
      sectors = gaugeSectors(success = c(8,10), warning = c(4,7), danger = c(0,3))
    )
  })
  
  # gauge2 output
  output$gauge2 <- flexdashboard::renderGauge({
    flexdashboard::gauge(
      value = 5, # change this to be data we want
      label = "Result 2", min = 0, max = 5, symbol = "%",
      sectors = gaugeSectors(success = c(0,3), warning = c(4,7), danger = c(8,10))
    )
  })
  
  # show plot action button
  observeEvent(input$showPlot, {
    
    varName <- input$chooseName
    
    # create rvs version of plot for reporting
    rvs$plot <<- random_ggplotly("bar")
    
    # render plot
    output$plot1 <- renderPlotly({
      random_ggplotly("bar")
    })
  
  })
  
  # download action button 
  output$report <- downloadHandler(
    filename = function() {
      paste0("Athlete_Forms_Analysis.html", sep = "")
    },
    content = function(file) {
      rmarkdown::render(paste0(getwd(),"/sampleReport.Rmd",sep=""),
                        html_document(), output_file = file, 
                        params = list(plot = rvs$plot, name = input$chooseName))
    }
  )
  
}

shinyApp(ui = demoApp.UI, server = demoApp.Server)

