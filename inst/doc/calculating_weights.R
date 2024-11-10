## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

## -----------------------------------------------------------------------------
# install.packages("maicplus")
library(maicplus)

## -----------------------------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
data("adsl_sat")

# Data containing the matching variables
adsl_sat <- adsl_sat %>%
  mutate(SEX_MALE = ifelse(SEX == "Male", 1, 0)) %>%
  mutate(AGE_SQUARED = AGE^2)

# Could use built-in function for dummizing variables
# adsl_sat <- dummize_ipd(adsl_sat, dummize_cols = "SEX", dummize_ref_level = c("Female"))

# Rename adsl as ipd
ipd <- adsl_sat
head(ipd)

## -----------------------------------------------------------------------------
# Through an excel spreadsheet
# target_pop <- data(agd)
# agd <- process_agd(agd)

# Second approach by defining a data frame in R
agd <- data.frame(
  AGE_MEAN = 51,
  AGE_SD = 3.25,
  SEX_MALE_PROP = 147 / 300,
  ECOG0_PROP = 0.40,
  SMOKE_PROP = 58 / (300 - 5),
  N_PR_THER_MEDIAN = 2
)

## -----------------------------------------------------------------------------
ipd_centered <- center_ipd(ipd = ipd, agd = agd)
head(ipd_centered)

## -----------------------------------------------------------------------------
# list variables that are going to be used to match
centered_colnames <- c("AGE", "AGE_SQUARED", "SEX_MALE", "ECOG0", "SMOKE", "N_PR_THER_MEDIAN")
centered_colnames <- paste0(centered_colnames, "_CENTERED")

weighted_sat <- estimate_weights(
  data = ipd_centered,
  centered_colnames = centered_colnames
)

# Alternatively, you can specify the numeric column locations for centered_colnames
# match_res <- estimate_weights(ipd_centered, centered_colnames = c(14, 16:20))

## -----------------------------------------------------------------------------
weighted_sat$ess

## -----------------------------------------------------------------------------
plot(weighted_sat)

# ggplot option is also available
# plot(weighted_sat, ggplot = TRUE, bin_col = "black", vline_col = "red")

## -----------------------------------------------------------------------------
check_weights(weighted_sat, agd)

