# Chapter 5 Some examples of data analysis
# 5.4 Change detection in time series data
# The model is not very effective!

rm(list = ls())

library(rstan)

c <- scan("changepointdata.txt")

data <- list(
  c = c, 
  n = length(c),
  t = seq(1,length(c))
)

model <- "
  data {
    int<lower=0> n;
    vector[n] t;
    vector[n] c;
  }
  parameters {
    real<lower=0, upper=n> tau;
    real<lower=0> lambda;
    real mu1;
    real mu2;
  }
  transformed parameters {
    real<lower=0> sigma;
    sigma = 1/sqrt(lambda);
  }
  model {
    //prior
    mu1 ~ normal(0, 1/sqrt(0.001));
    mu2 ~ normal(0, 1/sqrt(0.001));
    lambda ~ gamma(0.001, 0.001);
    
    for (i in 1:n) {
      if (t[i] < tau) {
        c[i] ~ normal(mu1, sigma);
      }
      else {
        c[i] ~ normal(mu2, sigma);
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

