library(tidyr)
### Import data ###

covid <- read.table("data/changes.csv", sep=",", header=TRUE)

### Constructing data ###



# Construction for nowcast #

split_nc <- 20
mob <- read.table("data/mob_red.csv", header=TRUE, sep=",")
dat_nc <- cbind(mob, tail(covid, nrow(mob)))
N <- nrow(dat_nc)

test_nc <- dat_nc$revised[seq(nrow(dat_nc)-split_nc+1, nrow(dat_nc))]
dat_nc$revised[seq(nrow(dat_nc)-split_nc+1, nrow(dat_nc))] <- NA

# Construction for prediction #

split_fc <- 5
dat_fc <- cbind(mob, tail(covid, nrow(mob)))

test_fc_x <- dat_fc$revised[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))]
test_fc_y <- dat_fc$reported[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))]

dat_fc$revised[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))] <- NA
dat_fc$reported[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))] <- NA


# Construction for poisson

# nc
dat_pois_nc <- cbind(mob, tail(covid, nrow(mob)))
test_pois_nc <- dat_pois_nc$revised[seq(nrow(dat_pois_nc)-split_nc+1, nrow(dat_pois_nc))]
dat_pois_nc <- dat_pois_nc[-seq(nrow(dat_pois_nc)-split_nc+1, nrow(dat_pois_nc))]

dat_pois_nc<-dat_pois_nc %>% 
  fill(revised) %>%
  fill(reported)

# fc






