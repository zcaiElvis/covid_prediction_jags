
### Import data ###

covid <- read.table("changes.csv", sep=",", header=TRUE)
N <- nrow(covid)


covid_nc <- covid
covid_nc$revised[nrow(covid)]<-NA
N_nc <- N



covid_pred <- covid
covid_pred$revised[nrow(covid)]<-NA
covid_pred$reported[nrow(covid)]<-NA
N_pred <- N


mob <- read.table("mob_red.csv", header=TRUE, sep=",")





### importing data
# covid <- read.table("processed.csv", sep=" ")
# N <- nrow(covid)


### df setup for nowcast ###
# covid_nc <- covid
# for(i in 1:nrow(covid_nc)){
#   if(covid_nc$before[i] == covid_nc$after[i]){
#     covid_nc$after_nowcast[i] <- NA
#   }else{
#     covid_nc$after_nowcast[i] <- covid_nc$after[i]
#   }
# }

### df setup for prediction ###
# N_sub <- 30
# covid_sub <- covid_nc[1:N_sub,]
# test_val <- covid_sub$after_nowcast[N_sub]
# covid_sub$after_nowcast[N_sub] <- NA