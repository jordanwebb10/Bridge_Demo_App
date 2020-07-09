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
  tryCatch({
    # render data table 
    output$dTable <- renderDT(
      df, options = list(lengthChange = FALSE)
    )
  }, error = function(e) {
    print("There was an error that caused the app to malfunction.")
    print("Here is the original error message: ")
    print(e)
    
    return(NA)
    
  }, warning = function(w) {
    print("There was a warning message present.")
    print("Here's the originial warning message: ")
    print(w)
    
    return(NA)
    
  })
  
}