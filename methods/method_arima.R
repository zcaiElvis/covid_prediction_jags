library(forecast)


arima_nc.fit <- auto.arima(dat_arima_nc$revised, stepwise = FALSE, approximation=FALSE)
# summary(arima_fc.fit)
# ARIMA(2,1,3)

arima_nc<- predict(arima_nc.fit, n.ahead= 20)
arima_nc$pred




arima_fc_x.fit <- auto.arima(dat_arima_fc$revised, stepwise= FALSE, approximation=FALSE)
arima_fc_y.fit <- auto.arima(dat_arima_fc$reported, stepwise= FALSE, approximation=FALSE)

arima_fc_x <- predict(arima_fc_x.fit, n.ahead=5)
arima_fc_y <- predict(arima_fc_y.fit, n.ahead=5)
