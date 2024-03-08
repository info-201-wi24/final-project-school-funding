library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

server <- function(input, output, session) {
  combined_data <- read.csv("joined_ny_data.csv")
  
  observe({
    updateSelectInput(session, "stateSelect1", choices = sort(unique(result$STATE)))
    updateSelectInput(session, "demographicSelect", choices = colnames(result))
    #updateSelectInput(session,)
  })
  
  output$fundingEnrollmentPlot <- renderPlotly({
    input$update1
    isolate({
      selectedStates <- input$stateSelect1
      if (length(selectedStates) == 0) return(NULL)
      
      # Filter the data based on selected states
      filteredData <- result %>%
        filter(STATE %in% selectedStates)
      
      plot_ly(data = filteredData, x = ~ENROLL, y = ~TOTALREV, type = 'scatter', mode = 'markers',
              marker = list(size = 10), color = ~STATE) %>%
        layout(title = "Total Revenue vs. Enrollment by State",
               xaxis = list(title = "Enrollment"),
               yaxis = list(title = "Total Revenue"))
    })
  })

  output$demographicPlot <- renderPlotly({
    req(input$update2)
    
    selectedColumn <- input$demographicSelect
    if(is.null(selectedColumn)) return(NULL)
    
    plot_ly(data = combined_data, x = ~STATE, y = as.formula(paste0("~`", selectedColumn, "`")),
            type = 'bar', color = ~STATE, text = ~paste(selectedColumn, ":", .data[[selectedColumn]])) %>%
      layout(title = paste("State-wise", selectedColumn))
  })
  
  output$stateSummary <- renderText({
    req(input$stateSelect1)
    selectedState <- input$stateSelect1[1]
    
    summaryInfo <- combined_data %>%
      filter(STATE == selectedState) %>%
      summarise(
        AvgMaleFemaleRatio = mean(male_female_ratio, na.rm = TRUE),
        MedianTotalRev = median(TOTALREV, na.rm = TRUE),
        AvgFederalFunding = mean(TFEDREV, na.rm = TRUE)
      )
    
    paste("Summary for", selectedState, ":",
          "\nAverage Male-Female Ratio:", summaryInfo$AvgMaleFemaleRatio,
          "\nMedian Total Revenue:", summaryInfo$MedianTotalRev,
          "\nAverage Federal Funding:", summaryInfo$AvgFederalFunding)
  })
  
  #output$schoolDistrictPlot <- renderPlotly({
    
    
   # selectedRace <- input$
 # })
}
