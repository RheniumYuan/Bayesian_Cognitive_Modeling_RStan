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
}