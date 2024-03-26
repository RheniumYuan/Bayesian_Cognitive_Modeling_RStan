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
}