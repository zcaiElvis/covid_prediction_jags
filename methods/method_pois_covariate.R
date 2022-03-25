library(rjags)
library(coda)
library(R2jags)
library(mice)
library(tidyr)
setwd("~/Desktop/School/2022/stat_520/stat520_project/")
source("data/retrieve_data.R")
source("functions.R")




model_pois.loc <- ("jags_models/pois.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   
   inv.r ~ dnorm(0.006,1000);
   r <- 1/inv.r; 
   
   X0 ~ dnorm(0, 1000);

   
   # b0 ~ dnorm(0, 0.1);
   b1 ~ dunif(0, 1);
   b2 ~ dnorm(0, 1);

   # likelihood
   X[1] ~ dnorm(X0, inv.q);
   log(EY[1]) <- X[1];
   Y[1] ~ dpois(EY[1]);
   
   for(t in 2:N) {
      X[t] ~ dnorm(b1*X[t-1] , inv.q);
      log(EY[t]) <- b2*X[t];
      Y[t] ~ dpois(EY[t]);
   }
}  
",  file = model_pois.loc)


# Nowcast
pois_nc.data <- list("Y" = dat_nc$reported, "X"=dat_nc$revised,
                          "N" = N)

pois_nc.jags.params <- (c("b0", "b1", "X[739:758]"))

pois_nc.output <- run_jag(pois_nc.data, pois_nc.jags.params, model_pois.loc)

pois_nc.output$mean$X


# Forecast
# covariate_pois_fc.data <- list("Y" = dat_nc$reported, "X"=dat_fc$revised, "M1" = dat_fc$rr, "M2" = dat_fc$gp, "M3" = dat_fc$p, 
#                           "M4" = dat_fc$ts, "M5" = dat_fc$w,
#                           "M6" = dat_fc$r,
#                           "N" = N)
# covariate_pois_fc.jags.params <- (c("b0", "b1", "a0", "X[754:758]", "Y[754:758]"))
# covariate_pois_fc.output <- run_jag(covariate_pois_fc.data, covariate_pois_fc.jags.params, model_pois_covariates.loc)
# 
# covariate_pois_fc.output$mean$X
# covariate_pois_fc.output$mean$Y




