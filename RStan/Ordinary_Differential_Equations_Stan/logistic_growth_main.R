#install.packages("growthcurver")
#install.packages("tidyr")

library(rstan)
library(dplyr)
library(tidyr)
library(ggplot2)
library(growthcurver) #contains the growthdata dataset
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

long_growthdata <- growthdata %>% gather(well,absorbance,-time)
glimpse(long_growthdata)

ggplot(long_growthdata,aes(time,absorbance,group=well)) +
  geom_line() + 
  theme_bw()


# fitting the model via MCMC

nSamples = nrow(growthdata) - 1 #use time=0 as initial condition, take this as fixed
y0 = filter(growthdata,time==0) %>% select(-time) %>% unlist #initial condition
t0 = 0.0
ts = filter(growthdata,time>0) %>% select(time) %>% unlist
z = filter(growthdata,time>0) %>% select(-time)
n_wells = 9 #running on all wells can be slow
estimates <- stan(file = 'log_growth_stan.stan',
                      data = list (
                        T  = nSamples,
                        n_wells = n_wells,
                        y0 = y0[1:n_wells],
                        z  = z[,1:n_wells],
                        t0 = t0,
                        ts = ts
                      ),
                      seed = 123,
                      chains = 4,
                      iter = 1000,
                      warmup = 500
)

parametersToPlot = c("theta","sigma","lp__")
print(estimates, pars = parametersToPlot)


#Diagnosis

library(bayesplot)

draws <- as.array(estimates, pars=parametersToPlot)
mcmc_trace(draws)


color_scheme_set("brightblue")
mcmc_scatter(draws,pars=c('theta[1]','theta[2]'))


xdata <- data.frame(absorbance = unlist(z[,1:n_wells]),well = as.vector(matrix(rep(1:n_wells,nSamples),nrow=nSamples,byrow=TRUE)),time = rep(ts,n_wells))
pred <- as.data.frame(estimates, pars = "z_pred") %>%
  gather(factor_key = TRUE) %>%
  group_by(key) %>%
  summarize(lb = quantile(value, probs = 0.05),
            median = quantile(value, probs = 0.5),
            ub = quantile(value, probs = 0.95)) %>%
  bind_cols(xdata)

p1 <- ggplot(pred, aes(x = time, y = absorbance))
p1 <- p1 + geom_point() +
  labs(x = "time (h)", y = "absorbance") +
  theme(text = element_text(size = 12), axis.text = element_text(size = 12),
        legend.position = "none", strip.text = element_text(size = 8))
p1 + geom_line(aes(x = time, y = median)) +
  geom_ribbon(aes(ymin = lb, ymax = ub), alpha = 0.25) +
  facet_wrap(~factor(well))

