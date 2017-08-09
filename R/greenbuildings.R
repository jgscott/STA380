library(mosaic)

green = read.csv('../data/greenbuildings.csv')
summary(green)

# Extract the buildings with green ratings
green_only = subset(green, green_rating==1)
dim(green_only)

# Not a normal distribution at all
hist(green_only$Rent, 25)
mean(green_only$Rent)

# Normal-based confidence interval for the sample mean
xbar = mean(green_only$Rent)
sig_hat = sd(green_only$Rent)
se_hat = sig_hat/sqrt(nrow(green_only))
xbar + c(-1.96,1.96)*se_hat

# Using R's lm function
model1 = lm(Rent ~ 1, data=green_only)
confint(model1, level=0.95)


### Compare with bootstrapping

# a single bootstrapped sample (repeat a few times)
green_only_boot = resample(green_only)
mean(green_only_boot$Rent)

# Get a feel for what it is in the green_only_boot object
head(green_only_boot)

# Now repeat 2500 times
boot1 = do(2500)*{
	mean(resample(green_only)$Rent)
}
head(boot1)
hist(boot1$result, 30)
sd(boot1$result)

# Extract the confidence interval from the bootstrapped samples
confint(boot1, level=0.95)
xbar + c(-1.96,1.96)*se_hat


####
# Bootstrap the median
####

median(green_only$Rent)
# Now repeat 2500 times
boot2 = do(2500)*{
	median(resample(green_only)$Rent)
}
head(boot2)

# Ugly!
hist(boot2$result, 30)

# But we still get a confidence interval
confint(boot2)
