# Chapter 3 Inferences with binomials
# 3.6 Joint distributions
# Based on codes from https://github.com/stan-dev/example-models/tree/master/Bayesian_Cognitive_Modeling

rm(list = ls())

library(rstan)
library(ggplot2)

data <- list(
  m = 5,
  nmax = 500,
  k = c(16, 18, 22, 25, 27)
)

model <- "
  data {
    int<lower=0> m;          
    int<lower=0> nmax;
    array[m] int<lower=0, upper=nmax> k;
  }
  transformed data {
    int<lower=0> nmin; // Minimal possible n
    nmin = max(k);
  }
  parameters {
    real<lower=0, upper=1> theta;
  }
  transformed parameters {
    vector[nmax] log_p_n; // log probability for each n
    for (n in 1 : nmax) {
      if (n < nmin) {
        log_p_n[n] = negative_infinity(); // impossible n
      }
      else {
        log_p_n[n] = binomial_lpmf(k | n, theta); 
      }
    }
  }
  model {
    target += log_sum_exp(log_p_n);
  }
  generated quantities {
    int<lower=1, upper=nmax> n;
    simplex[nmax] p_n; // the values of simplex sum up to 1
    p_n = softmax(log_p_n);
    n = categorical_rng(p_n);

  }"

fit <- stan(model_code = model,
            data = data,
            chains = 4,
            warmup = 1000,
            iter = 2000, 
            cores = 8,
            refresh = 0
)

print(fit, pars = c('theta','p_n'))

