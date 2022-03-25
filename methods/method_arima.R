library(forecast)

arima.fit <- auto.arima(dat_arima_nc$revised, stepwise = FALSE, approximation=FALSE)
summary(arima.fit)
# ARIMA(2,1,3)

arima_x<- predict(arima.fit, n.ahead= 5)
arima_x$pred
