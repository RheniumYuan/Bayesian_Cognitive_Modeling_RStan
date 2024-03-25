# Chapter 3 Inferences with binomials
# 3.1 Inferring a rate

rm(list = ls())

library(rstan)

data <- list(
  k = 5,
  n = 10
)

model <- "
  data {
    int<lower=0> k;          
    int<lower=0> n;
  }
  parameters {
    real<lower=0, upper=1> theta;
  }
  model {
    theta ~ beta(1, 1);
    k ~ binomial(n, theta);
  }
"

fit <- stan(model_code = model,
            data = data,
            chains = 4,
            warmup = 1000,
            iter = 2000, 
            cores = 8,
            refresh = 0
)

print(fit)
plot(fit)
