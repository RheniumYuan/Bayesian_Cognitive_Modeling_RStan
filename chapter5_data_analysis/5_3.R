# Chapter 5 Some examples of data analysis
# 5.3 The kappa coefficient of agreement

rm(list = ls())

library(rstan)


data <- list(
  y = c(14, 4, 5, 210)
)

model <- "
  data {
    int<lower=0> y[4];
  }
  parameters {
    real<lower=0,upper=1> alpha;
    real<lower=0,upper=1> beta;
    real<lower=0,upper=1> gamma;
  }
  transformed parameters {
    simplex[4] pi;
    pi[1] = alpha * beta;
    pi[2] = alpha * (1 - beta);
    pi[3] = (1 - alpha) * (1 - gamma);
    pi[4] = (1 - alpha) * gamma;
    
    real xi;
    xi = alpha * beta + (1 - alpha) * gamma;
    
    real psi;
    psi = (pi[1] + pi[2]) * (pi[1] + pi[3]) + (pi[2] + pi[4]) * (pi[3] + pi[4]);
    
    real kappa;
    kappa = (xi - psi) / (1 - psi);
  }
  model {
    alpha ~ beta(1,1);
    beta ~ beta(1,1);
    gamma ~ beta(1,1);
    
    y ~ multinomial(pi);
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
