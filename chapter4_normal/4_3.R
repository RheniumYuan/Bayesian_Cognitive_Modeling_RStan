# Chapter 4 Inferences with Gaussians
# 4.3 Repeated measurement of IQ

rm(list = ls())

library(rstan)

data <- list(
  n = 3, # number of people
  m = 3, # number of measurements
  x = matrix(c(90, 95, 100, 105, 110, 115, 150, 155, 160), nrow = 3)
)

model <- "
  data {
    int<lower=0> n;
    int<lower=0> m;
    matrix[n,m] x;
  }
  parameters {
    vector<lower=0, upper=300>[n] mu;
    vector<lower=0, upper=100>[n] sigma;
  }
  model {
    for (i in 1:n) {
      for (j in 1:m) {
        x[i,j] ~ normal(mu[i], sigma[i]);
      }
    }
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
