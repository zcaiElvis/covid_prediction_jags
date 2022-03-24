library(rjags)
library(coda)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")

model.loc <- ("jags_models/simple_ssm.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   inv.r ~ dgamma(0.001,0.001);
   r <- 1/inv.r; 
   X0 ~ dnorm(0, 0.001);
   
   # likelihood
   X[1] ~ dnorm(X0, inv.q);
   Y[1] ~ dnorm(X[1], inv.r);
   for(t in 2:N) {
      X[t] ~ dnorm(X[t-1], inv.q);
      Y[t] ~ dnorm(X[t], inv.r); 
   }
}  
",  file = model.loc)

jags.data <- list("Y" = covid_pred$reported,  "N" = N)
jags.params <- c("q", "r", "u")

mod_ss <- jags.model(file = model.loc, data=jags.data)


run_jag <- coda.samples(mod_ss, c("q", "X[779]", "Y[779]"), n.iter=100000)

summary(run_jag)
