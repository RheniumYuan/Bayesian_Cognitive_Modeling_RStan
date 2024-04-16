# Chapter 5 Some examples of data analysis
# 5.5 Censored data
# About censored data see Stan User Guide 
# https://mc-stan.org/docs/stan-users-guide/truncation-censoring.html

rm(list = ls())

library(rstan)

data <- list(
  n = 50,
  z_obs = 30,
  nCensored = 949
)

model <- "
  data {
    int<lower=0> n;
    int<lower=0, upper=n> z_obs;
    int<lower=0> nCensored;
  }
  parameters {
    real<lower=0.25, upper=1> theta; 
  }
  model {
    //observed data
    z_obs ~ binomial(n, theta);
    
    //censored data
    target += nCensored * (binomial_lcdf(14| n, theta) 
    + binomial_lccdf(25| n, theta));  
  }
"

fit <- stan(model_code = model,
            data = data,
            chains = 4,
            warmup = 1000,
            iter = 2000, 
            cores = 12,
            refresh = 0
)

print(fit)
plot(fit)

