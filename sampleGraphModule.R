#### Create a module for graphing results
## Written by: Dominic Angelotti

## ui portion
graph_UI <- function(id) {
  
  # create namespace
  ns <- NS(id)
  
  # create outputs for body
  tagList(
    fluidPage(
      chooseSliderSkin("Modern"),
      setSliderColor("LightSeaGreen",c(1)),
      fluidRow(
        box(width = 12, title = "Inputs", status = "info", solidHeader = T,
            pickerInput(ns("chooseX"), "Choose X Variable:", choices = c(), options = list(`actions-box` = F, size = 10), multiple = F),
            pickerInput(ns("chooseY"), "Choose Y Variable:", choices = c(), options = list(`actions-box` = F, size = 10), multiple = F), 
            sliderInput(ns("numPoints"), "Choose how many points to see:", min = 1, max = 1, value = 1), 
            actionBttn(ns("plot"), "Plot Graphs", style = "material-flat", color = "primary", size = "sm")
        )
      ),
      
      fluidRow(
        # create box for ggplot graph
        box(width = 12, title = "ggplot2 Graph", status = "info", solidHeader = T, plotOutput(ns("ggplotGraph")))
      ),
      fluidRow(
        box(width = 12, title = "plotly Graph", status = "info", solidHeader = T, plotlyOutput(ns("plotlyGraph")))
      )
    )
  )
}

## server portion
graph_Server <- function(input, output, session, df) {
  
  # grab namespace
  ns <- session$ns
  
  # update input values
  updatePickerInput(session, "chooseX", choices = colnames(df))
  updatePickerInput(session, "chooseY", choices = colnames(df))
  updateSliderInput(session, "numPoints", min = 1, max = nrow(df), value = 1, step = 1)
  
  # observe hitting of plot button and then produce plots
  observeEvent(input$plot, {
    tryCatch({
      x <- isolate(input$chooseX)
      y <- isolate(input$chooseY)
      pts <- isolate(input$numPoints)
      
      output$ggplotGraph <- renderPlot({
        df %>% sample_n(pts, replace = FALSE) %>% ggplot2::ggplot(aes_string(x,y)) + geom_point() + theme_minimal()
      })
      
      x.ptly <- reactive({ df[, input$chooseX] })
      y.ptly <- reactive({ df[, input$chooseY] })
      output$plotlyGraph <- renderPlotly({
        plot_ly(df %>% sample_n(pts, replace = FALSE), x = x.ptly(), y = y.ptly(), type = "scatter", mode = "markers")
      })
      
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
    
  })
  
}








