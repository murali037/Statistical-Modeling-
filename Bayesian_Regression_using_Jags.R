# Linear Regression In JAGs and then compare it with Least Squares Method


dat   <- read.csv("http://www4.stat.ncsu.edu/~reich/ST590/assignments/Obama2012.csv")
Y     <- 100*dat[,2]
Y     <- (Y-mean(Y))/sd(Y)
white <- dat[,7]
white <- (white-mean(white))/sd(white)
unemp <- dat[,18]
unemp <- (unemp-mean(unemp))/sd(unemp)
n     <- 100

#install.packages('rjags')
library(rjags)

# Let Yi - percent of voters that selected obama
#  Xi1 and Xi2 are the percent white and percent unemployed, respectively, for county i.

# Yi|β,σ2∼Normal(β1+X1iβ2+X2iβ3,σ2)

# priors
#βj∼Normal(0,1002)

#σ2∼InvGamma(0.01,0.01).

model_string <- "model{

# Likelihood
for(i in 1:n){
Y[i]   ~ dnorm(mu[i],inv.var)
mu[i] <- beta[1] + beta[2]*white[i] + beta[3]*unemp[i]
}

# Prior for beta
for(j in 1:3){
beta[j] ~ dnorm(0,0.0001)
}

# Prior for the inverse variance
inv.var   ~ dgamma(0.01, 0.01)
sigma     <- 1/sqrt(inv.var)

}"

# These lines send the model to JAGS so it can determine how to draw samples.

model <- jags.model(textConnection(model_string), 
                    data = list(Y=Y,n=n,white=white,unemp=unemp))

#The first line with the update function draws 10,000 warm up samples. 
#The final line produces the 20,000 samples we'll use to approximate the posterior. The object samp contains the samples.

update(model, 10000, progress.bar="none"); # Burnin for 10000 samples

samp <- coda.samples(model, 
                     variable.names=c("beta","sigma"), 
                     n.iter=20000, progress.bar="none")

summary(samp)

plot(samp)


# Comparison with Least Squares Method


fit <- lm(Y~white+unemp)
summary(fit)
