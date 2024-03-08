library(shiny)
library(plotly)


## OVERVIEW TAB INFO

overview_tab <- tabPanel("Project Overview", fluidPage(
  h1("Disparities in Funding between School Districts in 2016"),
  p("Our project is concerned with disparities in school funding across school districts as it relates to the demographic makeup of the states the schools are in."),
  p("Our datasets can be found here: ", a("US Educational Finances", href = "https://www.kaggle.com/datasets/noriuk/us-educational-finances", target = "_blank"), " & ", a("US County Population Data", href = "https://www.nber.org/research/data/us-intercensal-county-population-data-age-sex-race-and-hispanic-origin", target = "_blank"), 
    "."),
  p("Both of these datasets were sourced from the US Census Bureau, which brings with it some caveats. For one, while this data is far-reaching, it is not all-encompassing. Some people and areas are less likely to be counted in this dataset due to the fact that the Census is a time-sensitive operation that can't be overly thorough in its counting if they don't have enough people tallying a certain area. In addition, the Census is a government program, with a history of dealing poorly with minority status groups in the United States starting from its inception. Thus many of the people interviewed for the program may be skeptical of the process itself, and not give fully accurate testimony about themselves and their family.")
))

## VIZ 1 TAB INFO

viz_1_tab <- tabPanel("Funding vs. Enrollment",
  sidebarLayout(
    sidebarPanel(
      selectInput("stateSelect1", "Select State", choices = NULL, multiple = TRUE, selectize = TRUE),
      actionButton("update1", "Update")
    ),
    mainPanel(plotlyOutput("fundingEnrollmentPlot"))
  )
)


## VIZ 2 TAB INFO

viz_2_tab <- tabPanel("Funding by Demographics",
  sidebarLayout(
    sidebarPanel(
      selectInput("demographicSelect", "Select Demographic", choices = NULL, multiple = FALSE),
      actionButton("update2", "Update")
    ),
    mainPanel(plotlyOutput("demographicPlot"))
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  selectInput("raceSelect", "Select Racial Groups", choices = NULL, multiple = FALSE,
              selectize = TRUE),
  actionButton("update3", "Update")
)

viz_3_main_panel <- mainPanel(
  h2("Funding in States by Race"),
  plotlyOutput("revenueRacePlot")
)

viz_3_tab <- tabPanel("Funding by Race",
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel
                      )
)

## CONCLUSIONS TAB INFO
        
conclusion_tab <- tabPanel("Conclusions", 
  h1("Conclusions"),
  p("One thing illustrated by the data collected is that there certainly is some
    amount of correlation between different racial populations and school funding.
    If you look at our third vizualization, you can see that the white population
    of a state correlates almost directly with the funding received. However, looking
    at states with a higher black population, there's a much greater disparity.
    Georgia for instance receives only a quarter of the funding compared to California,
    despite having similar populations of black people. There primary disparity 
    is in the proportion of white people who live there compared to the black population.
    Hawaii is also illustrative for a different group. Hawaii is one the states
    with the highest Indigenous populations, but is in the bottom ten in terms
    of education investment. Lastly, on the state level, it's interesting to note
    that asian populations fall into a similar correlation of population to funding
    as white people do. This potentially suggests some amount of equity between
    those populations at this level of observation, in state-level aggregate."),
  p("Overall, our project has allowed us to look at some broader trends in how
    demographic groups relate to state-level funding. Compared to the broader
    body of work on this topic, our data seems to mainly agree that there is 
    disparity at play, in particular for black and indigenous populations in this
    country. If we are to take that everyone in this country deserves access to 
    decent educational resources regardless of the color of the skin, we need to
    work devise a system of more equitable distribution. If we do not, these 
    conditions are likely to exacerbate themselves for as long as they are allowed.")
)

ui <- navbarPage("US School Finding Analysis",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
