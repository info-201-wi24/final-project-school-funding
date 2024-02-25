library("dplyr")
library("stringr")

state_funding_df <- read.csv("C:/Users/ellie/Downloads/Info 201/US_Educational_Finances/states.csv")

district_demo_df <- read.csv("C:/Users/ellie/Downloads/Info 201/countypopmonthasrh.csv")

district_funding_df <- read.csv("C:/Users/ellie/Downloads/Info 201/US_Educational_Finances/districts.csv")

district_funding_df <- district_funding_df %>%
  filter(YRDATA > 2009)

district_funding_df <- district_funding_df %>%
  select(c(-"TCAPOUT", -"TCURONON", -"TCURSSVC", -"TCURINST"))

district_demo_df <- district_demo_df %>%
  filter(yearref == "1")

district_demo_df <- district_demo_df %>%
  select(c(-"sumlev", -"sumlevstr", -"state"))

county_demo_df <- district_demo_df %>%
  filter(agegrp == "0")

district_funding_df <- district_funding_df %>%
  filter(ENROLL > 0)

district_funding_2016_df <- district_funding_df %>%
  filter(YRDATA == 2016)

district_demo_df <- district_demo_df %>%
  select(-"year")

state_demo_df <- state_demo_df %>%
  group_by(stname) %>%
  mutate(hnac_male = sum(hnac_male))

state_demo_test_df <- state_demo_df %>%
  select(-"ctyname")

state_demo_test_df <- state_demo_test_df %>%
  select(-"county")

state_demo_test_df <- state_demo_test_df %>%
  distinct()

state_demo_test_df <- state_demo_test_df %>%
  mutate(STATE = stname)

state_demo_test_df <- state_demo_test_df %>%
select(-"stname")

state_demo_district_funding_df <- district_funding_2016_df %>%
  left_join(state_demo_test_df)


write.csv(district_demo_df, file = "DistrictDemographics2016.csv")
write.csv(state_demo_test_df, file = "StateDistrictDemographics2016.csv")
write.csv(district_funding_2016_df, file = "DistrictFunding2016.csv")
write.csv(state_demo_district_funding_df, file = "StateDemoandDistrictFunding2016.csv")
