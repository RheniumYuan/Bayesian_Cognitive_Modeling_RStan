# Chapter 4 Inferences with Gaussians
# 4.1 Inferring a mean and standard deviation

rm(list = ls())

library(rstan)
library(ggplot2)

data <- list(
  n = 4,
  x = c(1.1, 1.9, 2.3, 1.8)
)

model <- "
  data {
    int<lower=0> n;          
    vector[n] x;
  }
  parameters {
    real mu;
    real<lower=0, upper=10> sigma;
  }
  model {
    x ~ normal(mu, sigma);
  }
  generated quantities {
    real lambda;
    lambda = 1/(sigma^2);
  }"

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
