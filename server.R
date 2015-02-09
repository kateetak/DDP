# commands used during app developing
# library(shiny)
# shiny::runApp('.', display.mode="showcase")

# load required libraries
suppressPackageStartupMessages(library(googleVis))
library(plyr)


shinyServer(function(input, output, session) {

  # barChart (only displayed if the checkBox is selected)
  output$gBarChart <- renderGvis({
    if (input$barChart) {
      gvisColumnChart(selectedDataOneDim(), 
                      xvar = "data", yvar = "count")
    }
  })
  
  # pieChart (only displayed if the checkBox is selected)
  output$gPieChart <- renderGvis({
    if (input$pieChart){
      gvisPieChart(selectedDataOneDim(),
                   options = list(width=500, height=400,                                  
                                  is3D = "true",
                                  #legend= "none",
                                  pieSliceText= "label"))
    }
    
  })
  
  # bubbleChart (only displayed if the checkBox is selected)
  output$gBubbleChart <- renderGvis({
    if (input$bubbleChart){
      gvisBubbleChart(selectedDataTwoDim(),
                      idvar="id", xvar="x", yvar="y", colorvar="freq", sizevar="freq",
                      options=list(width=600, height=600,
                                  hAxis="{title:'x', minValue:-1}",
                                  vAxis="{title:'y', minValue:-1}",
                                  title = paste(input$twoDimX, " - ",  input$twoDimY, " Bubble Chart")))
    }    
  })
  
  # data subsetting for one dimensional charts
  selectedDataOneDim <- reactive({
    
    # column selection based on ui input
    d1 <- as.data.frame(data[, input$oneDimX])
    
    # removal on NA values
    d1 <- d1[!is.na(d1[1]),]
    
    # data summarization using table function
    d1 <- as.data.frame(table(d1))
    
    # standard column name are applied
    names(d1) <- c("data","count")
    
    # sorting on the data
    d1 <- d1[order(-d1$count),]
    
    # number of rows selection based on the slider
    minnum <- min(input$num, dim(d1)[1])
    
    # subset of the data based on the slider input
    d1 <- d1[c(1:minnum),]

    # return the dataset to be used for the chart
    d1
  })
  
 
  
  # data subsetting for two dimensional charts
  selectedDataTwoDim <- reactive({

    # column selection based on ui input
    d1 <- as.data.frame(data[, c(input$twoDimX, input$twoDimY)])
    
    # removal on NA values
    d1 <- d1[!is.na(d1[1]),]
    d1 <- d1[!is.na(d1[2]),]
    
    # standard column names are applied (required for ddply)
    names(d1) <- c("x","y")
    
    # data summarization using ddply function
    d1 <- ddply(d1, .(x, y), summarize, freq=length(x))
    
    # sorting on the data
    d1 <- d1[order(-d1$freq),]
    
    # subset of the data, only the 30 tuples with the highest frequency are kept
    d1 <- d1[c(1:30),]
    
    # standard column names are applied (required for chart generation)
    d1$id <- paste("x:", d1$x, " y:", d1$y, sep=" ")
    
    # return the dataset to be used for the chart
    d1
  })
  
  output$text1 <- renderText({
    # display a message to the user in the main area
    if (!(input$barChart | input$pieChart | input$bubbleChart)){
      "Quick hint: Select at least one chart!"
    }
  })
  
  output$doc1 <- renderText({
    "The scope of this shiny app is to summarize the data from a csv file using different charts."
  })
  
  output$doc2 <- renderText({
      "The user can select which chart to display by selecting the corresponding check box.
      As soon as one check box is selected the corresponding chart is displayed, the feature in the chart is a preselected default. 
      The user can change the feature by selecting a value from the drop down."
      
  })
  
  output$doc3 <- renderText({
    "For the Bar and Pie chart also a slider is available, by decreasing the value of the slider the number of represented unique values will decrease."
  })
  
  output$doc4 <- renderText({
    "The bubble chart is based on two dimensional data, to display it the user has to select the check box and adjust the features to be displayed 
    or just display the preselected features."
  })
  
  output$titleBarChart <- renderText({
    # display the column name for the Bar Chart
    if (input$barChart ){
      paste(input$oneDimX, " Bar Chart")
    }
  })
  
  output$textBarChart <- renderText({
    # display the number of unique values for the Bar Chart
    if (input$barChart ){
      paste("Unique values: ", dim(selectedDataOneDim())[1])
    }
  })
  
  
  output$titlePieChart <- renderText({
    # display the column name for the Pie Chart
    if (input$pieChart ){
      paste(input$oneDimX, " Pie Chart")
    }
  })
  
  output$textPieChart <- renderText({
    # display the number of unique values for the Pie Chart
    if (input$pieChart ){
      paste("Unique values: ", dim(selectedDataOneDim())[1])
    }
  })
  
  
  
})