## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

## -----------------------------------------------------------------------------
# install.packages("maicplus")
library(maicplus)

## -----------------------------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
data(centered_ipd_twt)
data(adtte_twt)
data(pseudo_ipd_twt)

centered_colnames <- c("AGE", "AGE_SQUARED", "SEX_MALE", "ECOG0", "SMOKE", "N_PR_THER_MEDIAN")
centered_colnames <- paste0(centered_colnames, "_CENTERED")

#### derive weights
weighted_data <- estimate_weights(
  data = centered_ipd_twt,
  centered_colnames = centered_colnames
)

# inferential result
result <- maic_anchored(
  weights_object = weighted_data,
  ipd = adtte_twt,
  pseudo_ipd = pseudo_ipd_twt,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = "C",
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
# result$descriptive$survfit_ipd_before
# result$descriptive$survfit_ipd_after
# result$descriptive$survfit_pseudo

## -----------------------------------------------------------------------------
result$inferential$summary

## -----------------------------------------------------------------------------
result$inferential$fit$km_before
result$inferential$fit$model_before
result$inferential$fit$res_AC_unadj
result$inferential$fit$res_AB_unadj

## -----------------------------------------------------------------------------
result$inferential$fit$km_after
result$inferential$fit$model_after
result$inferential$fit$res_AC
result$inferential$fit$res_AB

## ----echo = FALSE, eval = FALSE-----------------------------------------------
#  # heuristic check
#  # merge in adtte with ipd_matched
#  
#  ipd <- adtte_twt
#  ipd$weights <- weighted_data$data$weights[match(weighted_data$data$USUBJID, ipd$USUBJID)]
#  
#  pseudo_ipd <- pseudo_ipd_twt
#  pseudo_ipd$weights <- 1
#  
#  # Change the reference treatment to C
#  ipd$ARM <- stats::relevel(as.factor(ipd$ARM), ref = "C")
#  pseudo_ipd$ARM <- stats::relevel(as.factor(pseudo_ipd$ARM), ref = "C")
#  
#  # Fit a Cox model with/without weights to estimate the HR
#  unweighted_cox <- coxph(Surv(TIME, EVENT == 1) ~ ARM, data = ipd)
#  weighted_cox <- coxph(Surv(TIME, EVENT == 1) ~ ARM,
#    data = ipd, weights = weights, robust = TRUE
#  )
#  coxobj_agd <- coxph(Surv(TIME, EVENT) ~ ARM, pseudo_ipd)
#  
#  unweighted_cox
#  weighted_cox
#  coxobj_agd
#  
#  res_AC_unadj <- as.list(summary(unweighted_cox)$coef)[c(1, 3)] # est, se
#  res_AC <- as.list(summary(weighted_cox)$coef)[c(1, 4)] # est, robust se
#  res_BC <- as.list(summary(coxobj_agd)$coef)[c(1, 3)] # est, se
#  
#  names(res_AC_unadj) <- names(res_AC) <- names(res_BC) <- c("est", "se")
#  
#  res_AB_unadj <- bucher(res_AC_unadj, res_BC, conf_lv = 0.95)
#  res_AB <- bucher(res_AC, res_BC, conf_lv = 0.95)
#  
#  res_AB_unadj
#  res_AB
#  
#  kmobj <- survfit(Surv(TIME, EVENT) ~ ARM, ipd, conf.type = "log-log")
#  kmobj_adj <- survfit(Surv(TIME, EVENT) ~ ARM,
#    ipd,
#    weights = ipd$weights, conf.type = "log-log"
#  )
#  
#  # Derive median survival time
#  medSurv <- medSurv_makeup(kmobj, legend = "before matching", time_scale = "day")
#  medSurv_adj <- medSurv_makeup(kmobj_adj, legend = "after matching", time_scale = "day")
#  medSurv_out <- rbind(medSurv, medSurv_adj)
#  medSurv_out

## -----------------------------------------------------------------------------
weighted_data2 <- estimate_weights(
  data = centered_ipd_twt,
  centered_colnames = centered_colnames,
  n_boot_iteration = 100,
  set_seed_boot = 1234
)

result_boot <- maic_anchored(
  weights_object = weighted_data2,
  ipd = adtte_twt,
  pseudo_ipd = pseudo_ipd_twt,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = "C",
  normalize_weight = FALSE,
  endpoint_name = "Overall Survival",
  endpoint_type = "tte",
  eff_measure = "HR",
  boot_ci_type = "perc",
  time_scale = "month",
  km_conf_type = "log-log"
)

result_boot$inferential$fit$boot_res_AB

