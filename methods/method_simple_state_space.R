library(rjags)
library(coda)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("data/retrieve_data.R")
source("functions.R")

model_sss.loc <- ("jags_models/simple_ssm.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   inv.r ~ dgamma(0.001,0.001);
   r <- 1/inv.r; 
   X0 ~ dnorm(0, 0.001);
   
   b0 ~ dnorm(0, 0.1);
   b1 ~ dnorm(0, 0.1);
   
   # likelihood
   X[1] ~ dnorm(X0, inv.q);
   Y[1] ~ dnorm(X[1], inv.r);
   for(t in 2:N) {
      X[t] ~ dnorm(b0 + b1*X[t-1], inv.q);
      Y[t] ~ dnorm(X[t], inv.r); 
   }
}  
",  file = model_sss.loc)


# Nowcast

sss_nc.jags.data <- list("Y" = dat_nc$reported, "X" = dat_nc$revised,  "N" = N)

sss_nc.jags.params <- (c("b0", "b1", "X[739:758]"))

sss_nc.output <- run_jag(sss_nc.jags.data, sss_nc.jags.params, model_sss.loc)

# Forecast
sss_fc.jags.data <- list("Y" = dat_fc$reported, "X" = dat_fc$revised,  "N" = N)

sss_fc.jags.params <- (c("b0", "b1", "X[754:758]", "Y[754:758]"))

sss_fc.output <- run_jag(sss_fc.jags.data, sss_fc.jags.params, model_sss.loc)





