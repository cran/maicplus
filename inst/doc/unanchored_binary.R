## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

## -----------------------------------------------------------------------------
# install.packages("maicplus")
library(maicplus)

## -----------------------------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
data(centered_ipd_sat)
data(adrs_sat)

centered_colnames <- c("AGE", "AGE_SQUARED", "SEX_MALE", "ECOG0", "SMOKE", "N_PR_THER_MEDIAN")
centered_colnames <- paste0(centered_colnames, "_CENTERED")

weighted_data <- estimate_weights(
  data = centered_ipd_sat,
  centered_colnames = centered_colnames
)

# get dummy binary pseudo IPD
pseudo_adrs <- get_pseudo_ipd_binary(
  binary_agd = data.frame(
    ARM = "B",
    RESPONSE = c("YES", "NO"),
    COUNT = c(280, 120)
  ),
  format = "stacked"
)

result <- maic_unanchored(
  weights_object = weighted_data,
  ipd = adrs_sat,
  pseudo_ipd = pseudo_adrs,
  trt_ipd = "A",
  trt_agd = "B",
  normalize_weight = FALSE,
  endpoint_type = "binary",
  endpoint_name = "Binary Endpoint",
  eff_measure = "OR",
  # binary specific args
  binary_robust_cov_type = "HC3"
)

## -----------------------------------------------------------------------------
result$descriptive

## -----------------------------------------------------------------------------
result$inferential$summary

## -----------------------------------------------------------------------------
result$inferential$fit$model_before
result$inferential$fit$res_AB_unadj

## -----------------------------------------------------------------------------
result$inferential$fit$model_after
result$inferential$fit$res_AB

## ----eval = FALSE, echo = FALSE-----------------------------------------------
#  # heuristic check
#  # merge in adrs with ipd_matched
#  ipd_matched <- weighted_data$data
#  combined_data_binary <- ipd_matched %>%
#    left_join(adrs_sat, by = c("USUBJID", "ARM"))
#  pseudo_adrs$weights <- 1
#  
#  combined_data_binary <- rbind(
#    combined_data_binary[, colnames(pseudo_adrs)],
#    pseudo_adrs
#  )
#  
#  # Change the reference treatment to B
#  combined_data_binary$ARM <- stats::relevel(as.factor(combined_data_binary$ARM), ref = "B")
#  
#  binobj_dat <- glm(RESPONSE ~ ARM, combined_data_binary, family = binomial(link = "logit"))
#  binobj_dat_adj <- suppressWarnings(
#    glm(RESPONSE ~ ARM, combined_data_binary,
#      weights = weights,
#      family = binomial(link = "logit")
#    )
#  )
#  
#  bin_robust_cov <- sandwich::vcovHC(binobj_dat_adj, type = "HC3")
#  bin_robust_coef <- lmtest::coeftest(binobj_dat_adj, vcov. = bin_robust_cov)
#  bin_robust_ci <- lmtest::coefci(binobj_dat_adj, vcov. = bin_robust_cov)
#  
#  bin_robust_ci
#  exp(bin_robust_ci)
#  
#  exp(summary(binobj_dat)$coef[2, "Estimate"])
#  exp(summary(binobj_dat_adj)$coef[2, "Estimate"])

## -----------------------------------------------------------------------------
weighted_data2 <- estimate_weights(
  data = centered_ipd_sat,
  centered_colnames = centered_colnames,
  n_boot_iteration = 100,
  set_seed_boot = 1234
)

result_boot <- maic_unanchored(
  weights_object = weighted_data2,
  ipd = adrs_sat,
  pseudo_ipd = pseudo_adrs,
  trt_ipd = "A",
  trt_agd = "B",
  normalize_weight = FALSE,
  endpoint_type = "binary",
  endpoint_name = "Binary Endpoint",
  eff_measure = "OR",
  boot_ci_type = "perc",
  # binary specific args
  binary_robust_cov_type = "HC3"
)

result_boot$inferential$fit$boot_res_AB

