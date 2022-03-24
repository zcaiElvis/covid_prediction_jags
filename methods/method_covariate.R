library(rjags)
library(coda)
library(R2jags)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")

## data modifications
split <- 20

mob <- read.table("data/mob_red.csv", header=TRUE, sep=",")
dat <- cbind(mob, tail(covid, nrow(mob)))

testset <- dat$revised[seq(nrow(dat)-split, nrow(dat))]
dat$revised[seq(nrow(dat)-split, nrow(dat))] <- NA



model.loc <- ("jags_models/covariates.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   
   inv.r ~ dgamma(0.001,0.001);
   r <- 1/inv.r; 
   
   X0 ~ dnorm(0, 0.001);
   
   a0 ~ dnorm(0, 0.01);
   
   b0 ~ dnorm(0, 0.01);
   b1 ~ dnorm(0, 0.01);
   b2 ~ dnorm(0, 0.01);
   b3 ~ dnorm(0, 0.01);
   b4 ~ dnorm(0, 0.01);
   b5 ~ dnorm(0, 0.01);
   b6 ~ dnorm(0, 0.01);
   b7 ~ dnorm(0, 0.01);
   
   # likelihood
   X[1] ~ dnorm(X0, inv.q);
   Y[1] ~ dnorm(X[1], inv.r)
   
   for(t in 2:N) {
      X[t] ~ dnorm(a0*X[t-1] , inv.q);
      Y[t] ~ dnorm(b0 + b1*X[t] + b2*M1[t] + b3*M2[t] + b4*M3[t] + b5*M4[t] + b6*M5[t] + b7*M6[t],  0.06);
   }
}  
",  file = model.loc)

jags.data <- list("Y" = dat$reported, "X"=dat$revised, "M1" = dat$rr, "M2" = dat$gp, "M3" = dat$p, "M4" = dat$ts, "M5" = dat$w,
                  "M6" = dat$r,
                  "N" = 758)

# mod_ss <- jags.model(file = model.loc, data=jags.data)
# run_jag <- coda.samples(mod_ss, variable.names = c("q", "b0", "b1", "X[758]", "X[757]", "X[756]", "X[755]", "X[754]"), n.iter=100000)
# summary(run_jag)


jags.params <- (c("b0", "b1", "b2", "X[738:758]"))
mod_lm <- R2jags::jags(jags.data, parameters.to.save= jags.params,
                       model.file = model.loc, n.chains = 3, n.burnin = 5000, n.thin = 1,
                       n.iter = 10000, DIC = TRUE)


pred<- mod_lm$BUGSoutput$mean$X

rmse <- function(y1,y2){
  return(sqrt(sum((y1-y2)^2)))
}

