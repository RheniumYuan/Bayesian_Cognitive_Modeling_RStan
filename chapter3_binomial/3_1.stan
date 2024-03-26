data {
  int<lower=0> k;          
  int<lower=0> n;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  k ~ binomial(n, theta);
}