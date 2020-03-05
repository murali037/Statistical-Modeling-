
library("StanHeaders")
library("rstan")
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

dat = read.csv("golf_putting_data.csv")

golf_data <- list(x=dat$x, y=dat$y, n=dat$n, J=length(dat$x))
fit_logistic <- stan("golf_putting.stan", data=golf_data)
a_sim <- extract(fit_logistic)$a
b_sim <- extract(fit_logistic)$b
