library(rjags)
library(coda)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")

## data modifications
mob <- read.table("mob_red.csv", header=TRUE, sep=",")
dat <- cbind(mob, tail(covid, nrow(mob)))

# dat$revised <- log(1+dat$revised)
# dat$reported <- log(1+dat$reported)

dat$revised[nrow(dat)] <- NA
dat$reported[nrow(dat)] <- NA


model.loc <- ("jags_models/mob.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   
   inv.r ~ dgamma(0.001,0.001);
   
   r <- 1/inv.r; 
   
   X0 ~ dnorm(0, 0.001);
   
   b0 ~ dnorm(0, 0.01);
   b1 ~ dnorm(0, 0.01);
   b2 ~ dnorm(0, 0.01);
   b3 ~ dnorm(0, 0.01);
   b4 ~ dnorm(0, 0.01);
   b5 ~ dnorm(0, 0.01);
   b6 ~ dnorm(0, 0.01);
   
   c1 ~ dunif(0,1);
   c2 ~ dunif(0,1);
   
   # likelihood
   X[1] ~ dnorm(X0, inv.q);
   X[2] ~ dnorm(X0, inv.q);
   # log(EY[1]) <- X[1]
   # Y[1] ~ dpois(EY[1]);
   Y[1] ~ dnorm(X[1], inv.r)
   Y[2] ~ dnorm(X[2], inv.r)
   
   
   for(t in 3:N) {
      X[t] ~ dnorm(c1*X[t-1] + c2*X[t-2] + b0 + b1*M1[t-1] + b2*M2[t-1] + b3*M3[t-1] + b4*M4[t-1] + b5*M5[t-1] + b6*M6[t-1], inv.q);
      # log(EY[t]) <- X[t]
      # Y[t] ~ dpois(EY[t]);
      Y[t] ~ dnorm(X[t], inv.r)
   }
}  
",  file = model.loc)

jags.data <- list("Y" = dat$reported, "X"=dat$revised, "M1" = dat$rr, "M2" = dat$gp,
                  "M3" = dat$p, "M4" = dat$ts, "M5" = dat$w, "M6" = dat$r,
                  "N" = 758)
# jags.params <- c("q", "r", "u")
mod_ss <- jags.model(file = model.loc, data=jags.data)
run_jag <- coda.samples(mod_ss, variable.names = c("b0", "b1", "b2", "b3", "b4", "b5", "b6", "X[758]", "Y[758]"), n.iter=10000)

summary(run_jag)