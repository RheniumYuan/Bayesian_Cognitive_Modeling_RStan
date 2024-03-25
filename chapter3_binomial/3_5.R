# Chapter 3 Inferences with binomials
# 3.5 Posterior prediction
# Inferring a Common Rate (3.3), With Posterior Predictive

rm(list = ls())

library(rstan)
library(ggplot2)

data <- list(
  n1 = 10,
  n2 = 10,
  k1 = 5,
  k2 = 7
)

model <- "
  data {
    int<lower=0> n1;          
    int<lower=0> n2;
    int<lower=0, upper=n1> k1;          
    int<lower=0, upper=n2> k2;
  }
  parameters {
    real<lower=0, upper=1> theta;
  }
  model {
    theta ~ beta(1, 1);
    k1 ~ binomial(n1, theta);
    k2 ~ binomial(n2, theta);
  }
  generated quantities {
    // Posterior Predictive
    int<lower=0, upper=n1> postpredk1;
    int<lower=0, upper=n2> postpredk2;
    postpredk1 = binomial_rng(n1, theta);
    postpredk2 = binomial_rng(n2, theta);
  }"

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
