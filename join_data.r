library(dplyr)

df_funding <- read.csv("New_York_District_Funding.csv")
df_demo <- read.csv("New_York_District_Demographics.csv")
# head(df_funding)
# head(df_demo)

# aggregate before joining
# sum up the total revenue and total expenditure for each state and year
df_funding <- df_funding %>%
  filter(YRDATA >= 2010) %>%
  group_by(STATE, YRDATA) %>%
  summarise(TOTALREV = sum(TOTALREV, na.rm = TRUE), TOTALEXP = sum(TOTALEXP, na.rm = TRUE), .groups = "drop")

result <- df_funding %>%
  inner_join(df_demo, by = c("STATE" = "stname", "YRDATA" = "year"))

# check res before writing to file
if (nrow(result) < 20000) {
  write.csv(result, "joined_ny_data.csv", row.names = FALSE)
} else {
  print("Too large")
}

print("join completed")