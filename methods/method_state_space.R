library(rjags)
library(coda)

covid <- read.table("processed.csv", sep=" ")

N <- nrow(covid)


model.loc <- ("ss_model.txt")
jagsscript <- cat("
model {  
   # priors on parameters
   u ~ dnorm(0, 0.01); 
   inv.q ~ dgamma(0.001,0.001); 
   q <- 1/inv.q;
   inv.r ~ dgamma(0.001,0.001);
   r <- 1/inv.r; 
   X0 ~ dnorm(Y1, 0.001);
   
   # likelihood
   X[1] ~ dnorm(X0 + u, inv.q);
   EY[1] <- X[1];
   Y[1] ~ dnorm(EY[1], inv.r);
   for(t in 2:N) {
      X[t] ~ dnorm(X[t-1] + u, inv.q);
      EY[t] <- X[t];
      Y[t] ~ dnorm(EY[t], inv.r); 
   }
}  
",  file = model.loc)

jags.data <- list("Y" = covid$before/1000, "N" = N, "Y1" = covid$before[1]/1000)
jags.params <- c("q", "r", "EY", "u")

mod_ss <- jags.model(file = model.loc, data=jags.data)

update(mod_ss, n.iter = 5000)

run_jag <- coda.samples(mod_ss, c("q"), n.iter=100000)

summary(run_jag)
