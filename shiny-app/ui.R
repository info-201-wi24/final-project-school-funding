

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Project Introduction",
   h1("Disparities in Funding between School Districts in 2016"),
   p("Our project is concerned with disparities in school funding across school districts as it relates to the demographic makeup of the states the schools are in. Our datasets can be found here:
https://www.kaggle.com/datasets/noriuk/us-educational-finances
https://www.nber.org/research/data/us-intercensal-county-population-data-age-sex-race-and-hispanic-origin
Both of these datasets were sourced from the US Census Bureau, which brings with it some caveats. For one, while this data is far-reaching, it is not all-encompassing. Some people and areas are less likely to be counted in this dataset due to the fact that the Census is a time-sensitive operation that can't be overly thorough in its counting if they don't have enough people tallying a certain area. In addition, the Census is a government program, with a history of dealing poorly with minority status groups in the United States starting from its inception. Thus many of the people interviewed for the program may be skeptical of the process itself, and not give fully accurate testimony about themselves and their family.
")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_1_main_panel <- mainPanel(
  h2("Vizualization 1 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_1_tab <- tabPanel("Viz 1 tab title",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_2_main_panel <- mainPanel(
  h2("Vizualization 2 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_2_tab <- tabPanel("Viz 2 tab title",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_3_tab <- tabPanel("Viz 3 tab title",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion Tab Title",
 h1("Challenges"),
 p("The hardest piece has been mixing the data in a way that’s manageable but still conveys something meaningful about the information being presented. Since both codesets are so large, trimming and combining them has been a big pain.")
)



ui <- navbarPage("US School Finding",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
