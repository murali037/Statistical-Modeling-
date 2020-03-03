
library("StanHeaders")
library("rstan")
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

schools_dat <- list(J = 8, 
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

fit <- stan(file = '8schools.stan', data = schools_dat)


print(fit)
plot(fit)

pairs(fit, pars = c("mu", "tau", "lp__"))

la <- extract(fit, permuted = TRUE) # return a list of arrays 
mu <- la$mu 

### return an array of three dimensions: iterations, chains, parameters 
a <- extract(fit, permuted = FALSE) 

### use S3 functions on stanfit objects
a2 <- as.array(fit)
m <- as.matrix(fit)
d <- as.data.frame(fit)




# 
# The object fit, returned from function stan is an S4 object of class stanfit. 
# Methods such as print, plot, and pairs are associated with the fitted result 
# so we can use the following code to check out the results in fit. print provides 
# a summary for the parameter of the model as well as the log-posterior with name lp__ 
# (see the following example output). For more methods and details of class stanfit, see the help of class stanfit.

# In particular, we can use the extract function on stanfit objects to obtain the samples. 
# extract extracts samples from the stanfit object as a list of arrays for parameters of interest,
# or just an array. In addition, S3 functions as.array, as.matrix, and as.data.frame are defined
# for stanfit objects (using help("as.array.stanfit")


#####################################################################################################################################
#file.rename("~/.R/old_Makevars", "~/.R/Makevars")   #-- did not work


# 
# library(rstan)
# example(stan_model, run.dontrun = TRUE)
# 
# file.rename("~/.R/Makevars", "~/.R/old_Makevars")


