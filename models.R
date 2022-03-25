library(rjags)
library(coda)
library(R2jags)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("data/retrieve_data.R")
source("methods/method_covariate.R")
source("methods/method_simple_state_space.R")



### Nowcasting rmse ###

# Baseline error, predicting observed == revision
bl1 <- rmse(test_nc, tail(covid, 20)$reported)
#2256.07

# covariate model error
cov_m <- rmse(test_nc, covariate_nc.output$mean$X)
#2040.343

# ss model error
ss_m <- rmse(test_nc, sss_nc.output$mean$X)
#2182.978

# pois ss model error
rmse(test_nc, pois_nc.output$mean$X)
#177022.4

# arima error
rmse(test_nc, arima_x$pred[1:5])
# 16804.52