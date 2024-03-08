library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

server <- function(input, output, session) {
  df_funding <- read.csv("DistrictFunding2016.csv")
  df_demo <- read.csv("DistrictDemographics2016.csv")
  
  df_funding_summarized <- df_funding %>%
    select(-NAME, -YRDATA) %>%
    group_by(STATE) %>%
    summarise(across(c(ENROLL:TOTALEXP), sum, na.rm = TRUE))
  
  df_demo_summarized <- df_demo %>%
    group_by(stname) %>%
    summarise(across(c(tot_pop:hnac_male, hnac_female), sum, na.rm = TRUE))
  
  result <- df_funding_summarized %>%
    inner_join(df_demo_summarized, by = c("STATE" = "stname"))
  
  quantiles <- quantile(result$TFEDREV / result$TOTALREV, probs = c(0.33, 0.66))
  lower <- quantiles[1]
  upper <- quantiles[2]
  
  result <- result %>%
    mutate(funding_level = case_when(
      TFEDREV / TOTALREV < lower ~ "Low",
      TFEDREV / TOTALREV >= lower & TFEDREV / TOTALREV <= upper ~ "Medium",
      TFEDREV / TOTALREV > upper ~ "High"
    ),
    male_female_ratio = tot_male / tot_female)
  
  observe({
    updateSelectInput(session, "stateSelect1", choices = sort(unique(result$STATE)))
    updateSelectInput(session, "demographicSelect", choices = colnames(result))
    #updateSelectInput(session,)
  })
  
  output$fundingEnrollmentPlot <- renderPlotly({
    input$update1
    isolate({
      selectedStates <- input$stateSelect1
      if (length(selectedStates) == 0) return(NULL) # No selection made
      
      # Filter the data based on selected states
      filteredData <- result %>%
        filter(STATE %in% selectedStates)
      
      # Create the Plotly plot
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
    
    plot_ly(data = result, x = ~STATE, y = as.formula(paste0("~`", selectedColumn, "`")),
            type = 'bar', color = ~STATE, text = ~paste(selectedColumn, ":", .data[[selectedColumn]])) %>%
      layout(title = paste("State-wise", selectedColumn))
  })
  
  output$stateSummary <- renderText({
    req(input$stateSelect1)
    selectedState <- input$stateSelect1[1]
    
    summaryInfo <- result %>%
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
