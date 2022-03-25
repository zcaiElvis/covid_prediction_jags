library(tidyr)
### Import data ###

covid <- read.table("data/changes.csv", sep=",", header=TRUE)
# covid$revised <- log(covid$revised + 1)
# covid$reported <- log(covid$reported + 1)

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

# dat_fc <- head(dat_fc, n = nrow(dat_fc)-10)
N_fc <- nrow(dat_fc)

test_fc_x <- dat_fc$revised[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))]
test_fc_y <- dat_fc$reported[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))]

dat_fc$revised[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))] <- NA
dat_fc$reported[seq(nrow(dat_fc)-split_fc+1, nrow(dat_fc))] <- NA


# Construction for ARIMA

# nowcast

dat_arima_nc <- cbind(mob, tail(covid, nrow(mob)))
dat_arima_nc <- head(dat_arima_nc, n=739)

dat_arima_fc <- cbind(mob, tail(covid, nrow(mob)))
dat_arima_fc <- head(dat_arima_fc, n=754)








