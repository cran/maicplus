## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

## -----------------------------------------------------------------------------
# install.packages("maicplus")
library(maicplus)

## -----------------------------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
data(centered_ipd_sat)
data(adtte_sat)
data(pseudo_ipd_sat)

centered_colnames <- c("AGE", "AGE_SQUARED", "SEX_MALE", "ECOG0", "SMOKE", "N_PR_THER_MEDIAN")
centered_colnames <- paste0(centered_colnames, "_CENTERED")

weighted_data <- estimate_weights(
  data = centered_ipd_sat,
  centered_colnames = centered_colnames
)

result <- maic_unanchored(
  weights_object = weighted_data,
  ipd = adtte_sat,
  pseudo_ipd = pseudo_ipd_sat,
  trt_ipd = "A",
  trt_agd = "B",
  normalize_weight = FALSE,
  endpoint_name = "Overall Survival",
  endpoint_type = "tte",
  eff_measure = "HR",
  time_scale = "month",
  km_conf_type = "log-log"
)

## -----------------------------------------------------------------------------
result$descriptive$summary

# Not shown due to long output
# result$descriptive$survfit_before
# result$descriptive$survfit_after

## -----------------------------------------------------------------------------
result$inferential$summary

## -----------------------------------------------------------------------------
result$inferential$fit$km_before
result$inferential$fit$model_before
result$inferential$fit$res_AB_unadj

## -----------------------------------------------------------------------------
result$inferential$fit$km_after
result$inferential$fit$model_after
result$inferential$fit$res_AB

## ----eval = FALSE, echo = FALSE-----------------------------------------------
# # heuristic check
# # merge in adtte with ipd_matched
# ipd_matched <- weighted_data$data
# combined_data_tte <- ipd_matched %>%
#   left_join(adtte_sat, by = c("USUBJID", "ARM"))
# pseudo_ipd <- pseudo_ipd_sat
# pseudo_ipd$weights <- 1
# 
# combined_data_tte <- rbind(
#   combined_data_tte[, colnames(pseudo_ipd)],
#   pseudo_ipd
# )
# 
# # Change the reference treatment to B
# combined_data_tte$ARM <- stats::relevel(as.factor(combined_data_tte$ARM), ref = "B")
# 
# # Fit a Cox model with/without weights to estimate the HR
# unweighted_cox <- coxph(Surv(TIME, EVENT == 1) ~ ARM, data = combined_data_tte)
# weighted_cox <- coxph(Surv(TIME, EVENT == 1) ~ ARM,
#   data = combined_data_tte, weights = combined_data_tte$weights, robust = TRUE
# )
# 
# unweighted_cox
# weighted_cox
# 
# kmobj <- survfit(Surv(TIME, EVENT) ~ ARM, combined_data_tte, conf.type = "log-log")
# kmobj_adj <- survfit(Surv(TIME, EVENT) ~ ARM,
#   combined_data_tte,
#   weights = combined_data_tte$weights, conf.type = "log-log"
# )
# 
# # Derive median survival time
# medSurv <- medSurv_makeup(kmobj, legend = "before matching", time_scale = "day")
# medSurv_adj <- medSurv_makeup(kmobj_adj, legend = "after matching", time_scale = "day")
# medSurv_out <- rbind(medSurv, medSurv_adj)
# medSurv_out

## -----------------------------------------------------------------------------
weighted_data2 <- estimate_weights(
  data = centered_ipd_sat,
  centered_colnames = centered_colnames,
  n_boot_iteration = 100,
  set_seed_boot = 1234
)

result_boot <- maic_unanchored(
  weights_object = weighted_data2,
  ipd = adtte_sat,
  pseudo_ipd = pseudo_ipd_sat,
  trt_ipd = "A",
  trt_agd = "B",
  normalize_weight = FALSE,
  endpoint_name = "Overall Survival",
  endpoint_type = "tte",
  eff_measure = "HR",
  boot_ci_type = "perc",
  time_scale = "month",
  km_conf_type = "log-log"
)

result_boot$inferential$fit$boot_res_AB

