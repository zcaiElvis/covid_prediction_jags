library(rjags)
library(coda)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("retrieve_data.R")


model.loc <- ("nowcast.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   u ~ dnorm(0, 0.0001); 
   
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   
   inv.r ~ dgamma(0.001,0.001);
   
   r <- 1/inv.r; 
   
   X0 ~ dnorm(0, 0.001);
   
   # likelihood
   X[1] ~ dnorm(X0 + u, inv.q);
   Y[1] ~ dnorm(X[1], inv.r);
   
   for(t in 2:N) {
      X[t] ~ dnorm(X[t-1] + u, inv.q);
      Y[t] ~ dnorm(X[t], inv.r); 
   }
}  
",  file = model.loc)

jags.data <- list("Y" = covid_sub$before, "X"=covid_sub$after_nowcast, "N" = N_sub)

jags.params <- c("q", "r", "u")
mod_ss <- jags.model(file = model.loc, data=jags.data)

run_jag <- coda.samples(mod_ss, variable.names = c("u", "q", "r", "X[30]"), n.iter=100000)

summary(run_jag)

