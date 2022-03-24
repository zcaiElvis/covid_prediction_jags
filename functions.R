

# Define testing function
rmse <- function(y1,y2){
  return(sqrt(sum((y1-y2)^2)))
}


# Run Jags
run_jag <- function(jags.data, jags.params, model.loc){
  mod_lm <- R2jags::jags(jags.data, parameters.to.save= jags.params,
                         model.file = model.loc, n.chains = 3, n.burnin = 5000, n.thin = 1,
                         n.iter = 10000, DIC = TRUE)
  return(mod_lm$BUGSoutput)
}