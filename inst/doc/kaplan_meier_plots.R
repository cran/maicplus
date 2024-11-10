## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  fig.dim = c(8, 6),
  warning = FALSE,
  message = FALSE
)

## -----------------------------------------------------------------------------
# install.packages("maicplus")
library(maicplus)

## -----------------------------------------------------------------------------
library(survminer) # this is used for ggplot version of KM plots

## -----------------------------------------------------------------------------
data(weighted_sat)
data(adtte_sat)
data(pseudo_ipd_sat)

## -----------------------------------------------------------------------------
kmplot(
  weights_object = weighted_sat,
  tte_ipd = adtte_sat,
  tte_pseudo_ipd = pseudo_ipd_sat,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = NULL,
  normalize_weights = FALSE,
  endpoint_name = "Overall Survival",
  km_conf_type = "log-log",
  time_scale = "month",
  time_grid = seq(0, 20, by = 2),
  use_colors = NULL,
  use_line_types = NULL,
  use_pch_cex = 0.65,
  use_pch_alpha = 100
)

## -----------------------------------------------------------------------------
kmplot2(
  weights_object = weighted_sat,
  tte_ipd = adtte_sat,
  tte_pseudo_ipd = pseudo_ipd_sat,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = NULL,
  normalize_weights = FALSE,
  endpoint_name = "Overall Survival",
  km_conf_type = "log-log",
  time_scale = "month",
  break_x_by = 2,
  xlim = c(0, 20),
  censor = FALSE
)

## -----------------------------------------------------------------------------
data(weighted_twt)
data(adtte_twt)
data(pseudo_ipd_twt)

# plot by trial
kmplot(
  weights_object = weighted_twt,
  tte_ipd = adtte_twt,
  tte_pseudo_ipd = pseudo_ipd_twt,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = "C",
  normalize_weights = FALSE,
  endpoint_name = "Overall Survival",
  km_conf_type = "log-log",
  km_layout = "by_trial",
  time_scale = "month",
  time_grid = seq(0, 20, by = 2),
  use_colors = NULL,
  use_line_types = NULL,
  use_pch_cex = 0.65,
  use_pch_alpha = 100
)

# plot by arm
kmplot(
  weights_object = weighted_twt,
  tte_ipd = adtte_twt,
  tte_pseudo_ipd = pseudo_ipd_twt,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = "C",
  normalize_weights = FALSE,
  endpoint_name = "Overall Survival",
  km_conf_type = "log-log",
  km_layout = "by_arm",
  time_scale = "month",
  time_grid = seq(0, 20, by = 2),
  use_colors = NULL,
  use_line_types = NULL,
  use_pch_cex = 0.65,
  use_pch_alpha = 100
)

# plot all
kmplot(
  weights_object = weighted_twt,
  tte_ipd = adtte_twt,
  tte_pseudo_ipd = pseudo_ipd_twt,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = "C",
  normalize_weights = FALSE,
  endpoint_name = "Overall Survival",
  km_conf_type = "log-log",
  km_layout = "all",
  time_scale = "month",
  time_grid = seq(0, 20, by = 2),
  use_colors = NULL,
  use_line_types = NULL,
  use_pch_cex = 0.65,
  use_pch_alpha = 100
)

## -----------------------------------------------------------------------------
data(weighted_twt)
data(adtte_twt)
data(pseudo_ipd_twt)

# plot all
kmplot2(
  weights_object = weighted_twt,
  tte_ipd = adtte_twt,
  tte_pseudo_ipd = pseudo_ipd_twt,
  trt_ipd = "A",
  trt_agd = "B",
  trt_common = "C",
  normalize_weights = FALSE,
  endpoint_name = "Overall Survival",
  km_conf_type = "log-log",
  km_layout = "all",
  time_scale = "month",
  break_x_by = 2,
  xlim = c(0, 20),
  show_risk_set = FALSE
)

