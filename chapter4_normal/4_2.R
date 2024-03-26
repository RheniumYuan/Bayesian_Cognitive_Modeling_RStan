# Chapter 4 Inferences with Gaussians
# 4.2 The seven scientists

rm(list = ls())

library(rstan)
library(ggplot2)

data <- list(
  N = 7,
  x = c(-27.020, 3.570, 8.191, 9.898, 9.603, 9.945, 10.056)
)

model <- "
  data {
    int<lower=0> N;
    vector[N] x;
  }
  parameters {
    real mu;
    vector<lower=0>[N] lambda;
  }
  model {
    mu ~ gamma(2, 0.1);
    lambda ~ gamma(2, 0.1);
    for (n in 1:N) {
      x[n] ~ normal(mu, 1 ./ sqrt(lambda[n]));
    }
  }
  generated quantities {
    vector[N] sigma = 1 ./ sqrt(lambda);
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
