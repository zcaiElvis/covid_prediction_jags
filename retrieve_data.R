
### importing data
covid <- read.table("processed.csv", sep=" ")
N <- nrow(covid)

### df setup for nowcast ###
covid_nc <- covid
for(i in 1:nrow(covid_nc)){
  if(covid_nc$before[i] == covid_nc$after[i]){
    covid_nc$after_nowcast[i] <- NA
  }else{
    covid_nc$after_nowcast[i] <- covid_nc$after[i]
  }
}

### df setup for prediction ###
N_sub <- 30
covid_sub <- covid_nc[1:N_sub,]
test_val <- covid_sub$after_nowcast[N_sub]
covid_sub$after_nowcast[N_sub] <- NA
