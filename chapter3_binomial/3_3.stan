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