# Chapter 3 Inferences with binomials
# 3.2 Difference between two rates

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
    int<lower=0> k1;          
    int<lower=0> k2;
  }
  parameters {
    real<lower=0, upper=1> theta1;
    real<lower=0, upper=1> theta2;
  }
  model {
    theta1 ~ beta(1, 1);
    theta2 ~ beta(1, 1);
    k1 ~ binomial(n1, theta1);
    k2 ~ binomial(n2, theta2);
  }
  generated quantities {
    real delta;
    delta = theta1 - theta2;
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

# Posterior Distribution of Delta
ggplot(data.frame(delta = extract(fit)$delta), aes(x = delta)) +
  geom_density(fill = "blue", alpha = 0.5) +
  labs(title = "Posterior Distribution Density of delta",
       x = "delta", y = "Posterior Distribution Density")
