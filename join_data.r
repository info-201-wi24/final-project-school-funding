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

# categorical var
quantiles <- quantile(result$TFEDREV / result$TOTALREV, probs = c(0.33, 0.66))
lower <- quantiles[1]
upper <- quantiles[2]

result <- result %>%
  mutate(funding_level = case_when(
    TFEDREV / TOTALREV < lower ~ "Low",
    TFEDREV / TOTALREV >= lower & TFEDREV / TOTALREV <= upper ~ "Medium",
    TFEDREV / TOTALREV > upper ~ "High"
  ))

# numerical
result <- result %>%
  mutate(male_female_ratio = tot_male / tot_female)

# summary
summary_df <- result %>%
  group_by(funding_level) %>%
  summarise(
    avg_male_female_ratio = mean(male_female_ratio, na.rm = TRUE),
    median_total_rev = median(TOTALREV, na.rm = TRUE),
    avg_federal_funding = mean(TFEDREV, na.rm = TRUE)
  )

# check size before writing to file
if (nrow(result) < 20000) {
  write.csv(result, "joined_ny_data.csv", row.names = FALSE)
  print("join completed")
} else {
  print("Too large")
}
