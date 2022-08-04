library(mosaic)

creatinine = read.csv("../data/creatinine.csv", header=TRUE)
head(creatinine)

### Bootstrapping the sample mean

# Look at the mean creatinine clearance rate
mean(creatinine$creatclear)

# OK, 125.25 +/- what?
# Bootstrap to get a standard error
boot1 = do(1000)*{
  mean(mosaic::resample(creatinine)$creatclear)
}

hist(boot1$result, 30)
sd(boot1$result)

# Interpetation: our sample mean is probably off from the true population mean by about 0.95 units

# confidence interval: a range of plausible values for the population parameter, in light of the sample estimate
confint(boot1, level=0.95)


#### Bootstrapping the OLS estimator

plot(creatclear~age, data=creatinine,
	pch=19, col='grey', bty='n',
	ylab="creatinine score", xlab="Age")

lm1 = lm(creatclear~age, data=creatinine)
abline(lm1, lwd=2, col='blue')
coef(lm1)

# Bootstrap
boot1 = do(1000)*lm(creatclear~age, data=resample(creatinine))
head(boot1)

hist(boot1$Intercept)
hist(boot1$age)

# bootstrapped standard errors
sd(boot1$Intercept)
sd(boot1$age)

# confidence intervals
confint(boot1)
