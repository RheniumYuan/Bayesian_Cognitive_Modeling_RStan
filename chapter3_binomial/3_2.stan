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