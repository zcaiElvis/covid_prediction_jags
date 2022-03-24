library(rjags)
library(coda)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")

model.loc <- ("jags_models/negbin.txt")

jagsscript <- cat("
model {  
   # priors on parameters
   u ~ dnorm(0, 0.01); 
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   inv.r ~ dgamma(0.001,0.001);
   X0 ~ dnorm(0, 0.001);
   
   # likelihood
   X[1] ~ dnorm(X0 + u, inv.q);
   Y[1] ~ dpois(exp(X[1]));
   for(t in 2:N) {
      X[t] ~ dnorm(X[t-1], inv.q);
      Y[t] ~ dpois(exp(X[t]));
   }
}  
",  file = model.loc)

jags.data <- list("Y" = covid_pred$reported, "X" = covid_pred$revised,  "N" = N)
jags.params <- c("q", "r", "u")
mod_ss <- jags.model(file = model.loc, data=jags.data)


run_jag <- coda.samples(mod_ss, c("q", "X[779]", "u"), n.iter=100000)

summary(run_jag)