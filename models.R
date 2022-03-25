library(rjags)
library(coda)
library(R2jags)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("data/retrieve_data.R")
source("methods/method_covariate.R")
source("methods/method_simple_state_space.R")
source("methods/method_arima.R")



### Nowcasting rmse ###

# Baseline error, predicting observed == revision + median
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
rmse(test_nc, arima_nc$pred[1:20])
# 4891.121


### Forecasting rmse ###

# arima
rmse(test_fc_x, arima_fc_x$pred[1:5])
rmse(test_fc_y, arima_fc_y$pred[1:5])
# 6150.675, 7738.553

#covariate model error
cov2_m_x <- rmse(test_fc_x, covariate_fc.output$mean$X)
cov2_m_y <- rmse(test_fc_y, covariate_fc.output$mean$Y)
# 6240.829, 5914.749

# sss model 
ss_m_x <- rmse(test_fc_x, sss_fc.output$mean$X)
ss_m_y <- rmse(test_fc_y, sss_fc.output$mean$Y)
# 6432.523, 6029.997