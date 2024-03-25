# Chapter 3 Inferences with binomials
# 3.4 Prior and posterior prediction

rm(list = ls())

library(rstan)
library(ggplot2)

data <- list(
  n = 15,
  k = 1
)

model <- "
  data {
    int<lower=0> n;
    int<lower=0, upper=n> k;
  }
  parameters {
    real<lower=0, upper=1> theta;
  }
  model {
    theta ~ beta(1, 1);
    k ~ binomial(n, theta);
  }
  generated quantities {
    // Posterior Predictive
    int<lower=0, upper=n> postpredk;
    postpredk = binomial_rng(n, theta);
    
    // Prior Predictive
    int<lower=0, upper=n> priorpredk;
    real<lower=0, upper=1> thetaprior;
    thetaprior = beta_rng(1, 1);
    priorpredk = binomial_rng(n, thetaprior);
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

# Prior and posterior of theta
samples <- data.frame(posterior = extract(fit)$theta, 
                      prior = extract(fit)$thetaprior)
samples <- reshape2::melt(samples)
ggplot(samples, aes(x = value, fill = variable)) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c("#69b3a2", "#404080"))
