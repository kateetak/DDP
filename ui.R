
shinyUI(pageWithSidebar(
  headerPanel('Data distribution Charts'),
  sidebarPanel(
    div(
      #Bar Chart and its options
      h3("Bar/Pie Chart options"),
      checkboxInput("barChart", "Show BarChart", value = FALSE),
      checkboxInput("pieChart", "Show PieChart", value = FALSE),
    
      #column to be displayed
      selectInput('oneDimX', 'X-Var', sel, selected=sel[12]),
    
      sliderInput("num", "Number of values", value = 200, min = 0, max = 200, step = 10)
    ),
    div(
      #Bubble Chart and its options
      h3("Bubble Chart options"),
      checkboxInput("bubbleChart", "Show BubbleChart", value = FALSE),

      #columnx to be displayed (x and y)
      selectInput('twoDimX', 'X-Var', sel, selected=sel[15]),
      selectInput('twoDimY', 'Y-Var', sel, selected=sel[16])
    )
  ),
  mainPanel(
    div(
        # main text, to be displayed only when no chart is selected
        h3(textOutput("text1")),
        div(textOutput("doc1")),
        
        div(textOutput("doc2")),
        div(textOutput("doc3")),
        div(textOutput("doc4")),
        
        # title of the Bar chart
        h3(textOutput("titleBarChart")),
        # description of the Bar chart
        h4(textOutput("textBarChart")),
        # Bar chart
        div(htmlOutput('gBarChart')),
        
        # title of the Pie chart
        h3(textOutput("titlePieChart")),
        # description of the Pie chart
        h4(textOutput("textPieChart")),
        # Pie chart
        div(htmlOutput('gPieChart')),
        
        # Bubble chart
        div(htmlOutput('gBubbleChart'))
    )
  )
))
