library(rjags)
library(coda)
library(forecast)
library(tidyverse)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")

covid_arima <- covid

covid_arima_diff <- diff(covid_arima$revised,7)
covid_arima_diff <- data.frame(x=1:length(covid_arima_diff), y=covid_arima_diff)

test_size <- 10

train_idx <- seq(from=1, to= nrow(covid_arima_diff)-10)
test_idx <- seq(from=nrow(covid_arima_diff)-10+1, to= nrow(covid_arima_diff))

train <- covid_arima_diff[train_idx,]$y
test <- covid_arima_diff[test_idx,]$y


fit_arima <- auto.arima(train, stepwise = FALSE, approximation = FALSE)

pred <- predict(fit_arima, n.ahead = 10)






