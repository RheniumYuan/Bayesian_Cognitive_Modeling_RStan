# Chapter 3 Inferences with binomials
# 3.3 Inferring a common rate

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
    real<lower=0, upper=1> theta;
  }
  model {
    theta ~ beta(1, 1);
    k1 ~ binomial(n1, theta);
    k2 ~ binomial(n2, theta);
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

# Posterior Distribution of theta
ggplot(data.frame(theta = extract(fit)$theta), aes(x = theta)) +
  geom_density(fill = "blue", alpha = 0.5) +
  labs(title = "Posterior Distribution Density of theta",
       x = "theta", y = "Posterior Distribution Density")
