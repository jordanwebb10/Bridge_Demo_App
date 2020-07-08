#### Create a model for data example
## Written by: Dominic Angelotti

## ui portion
data_UI <- function(id) {
  
  # create name space
  ns <- NS(id)
  
  # create outputs
  tagList(
    fluidPage(
      fluidRow(
        box(width = 12, title = "Raw Data", status = "info", solidHeader = T, DTOutput(ns("dTable")))
      )
    )
  )
}

## server portion
data_server <- function(input, output, session, df) {
  
  # get name space
  ns <- session$ns
  
  # render data table 
  output$dTable <- renderDT(
    df, options = list(lengthChange = FALSE)
  )
}