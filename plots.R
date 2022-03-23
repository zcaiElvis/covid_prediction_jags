library("forecast")
library("dplyr")  
library("tidyverse")
library("cowplot")
library("gridExtra")

setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")


covid$date_report <- strptime(as.Date(covid$date_report, "%d-%m-%Y"), "%Y-%m-%d")

raw <- ggplot(data=covid, aes(x=as.Date(date_report), y=revised))+
  geom_line()+
  theme_bw()+
  xlab("date")+
  ylab("recent reported count")


covid_diff <- diff(covid$revised,7)
covid_diff <- data.frame(x=1:length(covid_diff), y=covid_diff)

diff7 <- ggplot(data=covid_diff, aes(x=x, y=y))+
  geom_line()+
  theme_bw()+
  xlab("time points")+
  ylab("recent reported count diff by 7")

compare_diff <- grid.arrange(raw, diff7, ncol=1)


acf(covid$revised, main="ACF of raw data")
acf(covid_diff$y, main="ACF of 7 difference")

fit_arima_raw <- auto.arima(covid$revised, stepwise = FALSE, approximation = FALSE)
fit_arima_diff <- auto.arima(covid_diff$y, stepwise = FALSE, approximation = FALSE)
summary(fit_arima_raw)
summary(fit_arima_diff)


covid_rev_dist <- covid[290:nrow(covid),]
covid_rev_dist$rev_dif<- covid_rev_dist$reported - covid_rev_dist$revised
covid_rev_dist <- na.omit(covid_rev_dist)

covid_rev_dist$my <- format(as.Date(covid_rev_dist$date_report), "%Y-%m")

summary(covid_rev_dist$rev_dif)

ggplot(data=covid_rev_dist, aes(rev_dif))+
  geom_histogram(fill="blue", alpha=0.5)+
  theme_bw()+
  labs(title="delay distribution")

ggplot(data=covid_rev_dist, aes(x=rev_dif, fill=my))+
  geom_histogram()+
  theme_bw()+
  xlim(c(-1000,1000))+
  labs(title="delay distribution")
  
