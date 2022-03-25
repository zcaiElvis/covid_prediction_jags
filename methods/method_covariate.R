library(rjags)
library(coda)
library(R2jags)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("data/retrieve_data.R")
source("functions.R")


model_covariates.loc <- ("jags_models/covariates.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   
   inv.r ~ dnorm(0.006, 10000);
   r <- 1/inv.r; 
   
   X0 ~ dnorm(0, 1000);
   
   a0 ~ dunif(0, 1);
   
   b0 ~ dnorm(0, 0.01);
   b1 ~ dunif(0, 1);
   b2 ~ dunif(-1, 1);
   b3 ~ dunif(-1, 1);
   b4 ~ dunif(-1, 1);
   b5 ~ dunif(-1, 1);
   b6 ~ dunif(-1, 1);
   b7 ~ dunif(-1, 1);
   
   # likelihood
   X[1] ~ dnorm(X0, inv.q);
   Y[1] ~ dnorm(X[1], inv.r)
   
   for(t in 2:N) {
      X[t] ~ dnorm(a0*X[t-1] , inv.q);
      Y[t] ~ dnorm(b0 + b1*X[t] + b2*M1[t] + b3*M2[t] + b4*M3[t] + b5*M4[t] + b6*M5[t] + b7*M6[t],  inv.r);
   }
}  
",  file = model_covariates.loc)

# Nowcast
covariate_nc.data <- list("Y" = dat_nc$reported, "X"=dat_nc$revised, "M1" = dat_nc$rr, "M2" = dat_nc$gp, "M3" = dat_nc$p, 
                          "M4" = dat_nc$ts, "M5" = dat_nc$w,
                          "M6" = dat_nc$r,
                          "N" = N)

covariate_nc.jags.params <- (c("b0", "b1", "a0", "X[739:758]"))
covariate_nc.output <- run_jag(covariate_nc.data, covariate_nc.jags.params, model_covariates.loc)

covariate_nc.output$mean$X


# Forecast
covariate_fc.data <- list("Y" = dat_fc$reported, "X"=dat_fc$revised, "M1" = dat_fc$rr, "M2" = dat_fc$gp, "M3" = dat_fc$p, 
                          "M4" = dat_fc$ts, "M5" = dat_fc$w,
                          "M6" = dat_fc$r,
                          "N" = N_fc)
covariate_fc.jags.params <- (c("b0", "b1", "a0", "X[754:758]", "Y[754:758]"))
covariate_fc.output <- run_jag(covariate_fc.data, covariate_fc.jags.params, model_covariates.loc)

covariate_fc.output$mean$X
covariate_fc.output$mean$Y




