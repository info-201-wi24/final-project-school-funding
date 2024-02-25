library(dplyr)

df_funding <- read.csv("DistrictFunding2016.csv")
df_demo <- read.csv("DistrictDemographics2016.csv")
# head(df_funding)
# head(df_demo)

df_funding_summarized <- df_funding %>%
  select(-NAME, -YRDATA) %>%
  group_by(STATE) %>%
  summarise(across(c(ENROLL:TOTALEXP), sum, na.rm = TRUE))

df_demo_summarized <- df_demo %>%
  group_by(stname) %>%
  summarise(across(c(tot_pop:hnac_male, hnac_female), sum, na.rm = TRUE))

# joined <- df_funding %>%
#   left_join(df_demo, by = c("STATE" = "stname"))

# aggregate before joining
# sum up the total revenue and total expenditure for each state and year
# df_funding <- df_funding %>%
#   group_by(STATE, YRDATA) %>%
#   summarise(TOTALREV = sum(TOTALREV, na.rm = TRUE), TOTALEXP = sum(TOTALEXP, na.rm = TRUE), .groups = "drop")

# sum total pop
# df_demo <- df_demo %>%
#   group_by(stname) %>%
#   summarise(tot_pop = sum(tot_pop, na.rm = TRUE), .groups = "drop")

# summarized <- joined %>%
#   group_by(STATE) %>%
#   summarise(
#     tot_pop = sum(tot_pop, na.rm = TRUE),
#     tot_male = sum(tot_male, na.rm = TRUE),
#     tot_female = sum(tot_female, na.rm = TRUE),
#     total_wa = sum(wa_male + wa_female, na.rm = TRUE),
#     total_ba = sum(ba_male + ba_female, na.rm = TRUE),
#     total_ia = sum(ia_male + ia_female, na.rm = TRUE),
#     total_aa = sum(aa_male + aa_female, na.rm = TRUE),
#     total_na = sum(na_male + na_female, na.rm = TRUE),
#     total_tom = sum(tom_male + tom_female, na.rm = TRUE),
#     total_wac = sum(wac_male + wac_female, na.rm = TRUE),
#     total_bac = sum(bac_male + bac_female, na.rm = TRUE),
#     total_iac = sum(iac_male + iac_female, na.rm = TRUE),
#     total_aac = sum(aac_male + aac_female, na.rm = TRUE),
#     total_nac = sum(nac_male + nac_female, na.rm = TRUE),
#     total_nh = sum(nh_male + nh_female, na.rm = TRUE),
#     total_nhwa = sum(nhwa_male + nhwa_female, na.rm = TRUE),
#     total_nhba = sum(nhba_male + nhba_female, na.rm = TRUE),
#     total_nhia = sum(nhia_male + nhia_female, na.rm = TRUE),
#     total_nhaa = sum(nhaa_male + nhaa_female, na.rm = TRUE),
#     total_nhna = sum(nhna_male + nhna_female, na.rm = TRUE),
#     total_nhtom = sum(nhtom_male + nhtom_female, na.rm = TRUE),
#     # more non-Hispanic sum
#     total_nhwac = sum(nhwac_male + nhwac_female, na.rm = TRUE),
#     total_nhbac = sum(nhbac_male + nhbac_female, na.rm = TRUE),
#     total_nhiac = sum(nhiac_male + nhiac_female, na.rm = TRUE),
#     total_nhaac = sum(nhaac_male + nhaac_female, na.rm = TRUE),
#     total_nhnac = sum(nhnac_male + nhnac_female, na.rm = TRUE),
#     # Hispanic demographics
#     total_h = sum(h_male + h_female, na.rm = TRUE),
#     total_hwa = sum(hwa_male + hwa_female, na.rm = TRUE),
#     total_hba = sum(hba_male + hba_female, na.rm = TRUE),
#     total_hia = sum(hia_male + hia_female, na.rm = TRUE),
#     total_haa = sum(haa_male + haa_female, na.rm = TRUE),
#     total_hna = sum(hna_male + hna_female, na.rm = TRUE),
#     total_htom = sum(htom_male + htom_female, na.rm = TRUE),
#     # Hispanic combinations
#     total_hwac = sum(hwac_male + hwac_female, na.rm = TRUE),
#     total_hbac = sum(hbac_male + hbac_female, na.rm = TRUE),
#     total_hiac = sum(hiac_male + hiac_female, na.rm = TRUE),
#     total_haac = sum(haac_male + haac_female, na.rm = TRUE),
#     total_hnac = sum(hnac_male + hnac_female, na.rm = TRUE),
#     .groups = "drop"
#   )

# result <- df_funding %>%
#   left_join(summarized, by = c("STATE")) %>%
#   group_by(STATE)

result <- df_funding_summarized %>%
  inner_join(df_demo_summarized, by = c("STATE" = "stname"))

# check size before writing to file
if (nrow(result) < 20000) {
  write.csv(result, "joined_ny_data.csv", row.names = FALSE)
  print("join completed")
} else {
  print("Too large")
}
