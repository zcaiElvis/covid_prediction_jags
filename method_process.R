
## import data ##

covid_rev <- read.table("changes.csv", sep=" ", header=TRUE)


for(i in 1:nrow(covid_rev)){
  hist_date <- covid_rev$val[i]
  rev_val <- as.numeric(unlist(strsplit(hist_date, split= " ")))
  rev_val[-is.na(rev_val)]
  print(rev_val)
  
  covid_rev$before[i] <- rev_val[2]
  covid_rev$after[i] <- rev_val[length(rev_val)]
}

df_processed <- data.frame(date= covid_rev$date, before = covid_rev$before, after= covid_rev$after)

write.table(df_processed, "processed.csv", sep= " ")