#### Create a module for model samples
## Written by: Dominic Angelotti

## ui portion
model_UI <- function(id) {
  
  # create name space
  ns <- NS(id)
  
  # create outputs for body
  tagList(
    fluidPage(
      chooseSliderSkin("Modern"),
      setSliderColor("LightSeaGreen",c(1)),
      fluidRow(
        box(width = 12, title = "Inputs", status = "info", solidHeader = TRUE,
            pickerInput(ns("chooseModel"), "Choose Model Type:", choices = c("Logistic Regression", "KNN"), 
                        options = list(`actions-box` = F, size = 10), multiple = F), 
            actionBttn(ns("results"), "Show Results", style = "material-flat", color = "primary", size = "sm")
        )
      ), 
      fluidRow(
        # create box for plotting results in ggplot
        box(width = 12, title = "Model Results", status = "info", solidHeader = TRUE, plotOutput(ns("plotResults")))
      )
    )
  )
}

## server portion 
model_server <- function(input, output, session, df) {
  
  # get namespace
  ns <- session$ns
  
  # observe event of hitting results button
  observeEvent(input$results, {
    
    tryCatch({
      # create model based on user choice
      if (input$chooseModel == "Logistic Regression") {
        
        df2 <- df[sample(1:nrow(df)), ]
        df2$virginica <- df2$Species == "virginica"
        df$virginica <- df$Species == "virginica"
        model <- glm(virginica ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = df2, family = "binomial")
        pred <- predict(model, df, type = "response")
        pred <- round(pred, 2)
        
        # plot result prediction
        output$plotResults <- renderPlot({
          hist(pred, breaks = 20, main = "Histogram of Prediction vs Actual")
          hist(pred[df$virginica == TRUE], col = "red", breaks = 20, add = TRUE)
        })
      } else if (input$chooseModel == "KNN") {
        
        #df.train <- df[1:120, 1:4]
        df.train <- df[1:120,]
        df.test <- df[121:150, 1:4]
        targ.train <- df[1:120, 5]
        targ.test <- df[121:150,5]
        
        pred <- knn(train = df.train, test = df.test, cl = targ.train, k = 10, prob = T)
        rslt <- cbind(df.test, pred)
        combineTest <- cbind(df.test, targ.test)
        
        output$plotResults <- renderPlot({
          rslt %>% ggplot(., aes(x = Petal.Width, y = Petal.Length, color = pred)) + geom_point(size = 3)
        })
        
      }
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









