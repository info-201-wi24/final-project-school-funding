library(dplyr)

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

# check size before writing to file
if (nrow(result) < 20000) {
  write.csv(result, "joined_ny_data.csv", row.names = FALSE)
  print("join completed")
} else {
  print("Too large")
}
