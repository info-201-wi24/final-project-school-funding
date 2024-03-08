library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

server <- function(input, output, session) {
  combined_data <- read.csv("joined_ny_data.csv")
  
  observe({
    updateSelectInput(session, "stateSelect1", choices = sort(unique(combined_data$STATE)))
    updateSelectInput(session, "demographicSelect", choices = colnames(combined_data))
    updateSelectInput(session, "raceSelect", choices = colnames(combined_data %>%
                                                      select(c(wa_male:na_female))))
  })
  
  output$fundingEnrollmentPlot <- renderPlotly({
    input$update1
    isolate({
      selectedStates <- input$stateSelect1
      if (length(selectedStates) == 0) return(NULL)
      
      filteredData <- combined_data %>%
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
  
  output$revenueRacePlot <- renderPlotly({
    input$update3
    
    selectedRace <- input$raceSelect
    if(is.null(selectedRace)) return(NULL)
    
    plot_ly(data = combined_data, x = as.formula(paste0("~`", selectedRace, "`")), y = ~TOTALREV, type = 'scatter',
            color = ~STATE) %>%
      layout(title = "Total Revenue vs. Racial Population",
             xaxis = list(title = "Racial Pop"),
             yaxis = list(title = "Total Revenue"))
  })
}
