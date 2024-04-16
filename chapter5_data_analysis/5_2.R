# Chapter 5 Some examples of data analysis
# 5.2 Pearson correlation with uncertainty

rm(list = ls())

library(rstan)

# dataset
x <- matrix(c( .8, 102, 
               1.0,  98, 
               .5, 100,
               .9, 105, 
               .7, 103, 
               .4, 110,
               1.2,  99, 
               1.4,  87,
               .6, 113,
               1.1,  89,
               1.3,  93), nrow=11, ncol=2, byrow=T) 

data <- list(
  n = nrow(x),
  x = x,
  sigma_e = c(0.03, 1.0)
)

model <- "
  data {
    int<lower=0> n;
    vector[2] x[n];
    vector<lower=0>[2] sigma_e;
  }
  parameters {
    vector[2] mu;
    vector<lower=0>[2] lambda;
    real<lower=-1,upper=1> r;
    vector[2] y[n];
  }
  transformed parameters {
    vector<lower=0>[2] sigma;
    cov_matrix[2] T; //cov_matrix is a covariance matrix data type
    // Reparameterization
    sigma[1] <- 1/sqrt(lambda[1]);
    sigma[2] <- 1/sqrt(lambda[2]);
    T[1,1] <- sigma[1]^2;
    T[1,2] <- r*sigma[1]*sigma[2];
    T[2,1] <- r*sigma[1]*sigma[2];
    T[2,2] <- sigma[2]^2;
  }
  model {
    //prior
    mu ~ normal(0, 1/sqrt(.001));
    lambda ~ gamma(.001, .001);
    y ~ multi_normal(mu, T);
    for (i in 1:n) {
      x[i] ~ normal(y[i], sigma_e);
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
