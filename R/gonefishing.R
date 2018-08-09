library(mosaic)
library(foreach)

gonefishing = read.csv('../data/gonefishing.csv', header=TRUE)
summary(gonefishing)

# Histogram of weights
hist(gonefishing$weight, breaks=20)
mean_weight_pop = mean(gonefishing$weight)
abline(v=mean_weight_pop, lwd=4, col='blue')

mean_weight_pop

# Take a random sample from the population of fish in the lake
n_fish = 30
fishing_trip = mosaic::sample(gonefishing, n_fish)
# Look at the measurements of the first five fish we caught
head(fishing_trip, 5)

# Sample mean with a new sample
fishing_trip = mosaic::sample(gonefishing, n_fish)
mean_weight_sample = mean(fishing_trip$weight)
mean_weight_sample

# Repeat 25 times
do(25)*{
  fishing_trip = mosaic::sample(gonefishing, n_fish)
  mean_weight_sample = mean(fishing_trip$weight)
  mean_weight_sample
}

# Using the more flexible "foreach" construction
foreach(i = 1:25, .combine='c') %do% {
  fishing_trip = mosaic::sample(gonefishing, n_fish)
  mean_weight_sample = mean(fishing_trip$weight)
  mean_weight_sample
}


# Simulate a whole year of 30-fish days
n_fish = 30
my_fishing_year = foreach(i = 1:1000, .combine='c') %do% {
  fishing_trip = mosaic::sample(gonefishing, n_fish)
  mean_weight_sample = mean(fishing_trip$weight)
  mean_weight_sample
}

# The sampling distribution of the sample mean
hist(my_fishing_year, 25)
sd(my_fishing_year)

# the theoretical standard deviation:
sd(gonefishing$weight)/sqrt(30)

# Now try bootstrapping

# First take a single sample
fishing_trip = mosaic::sample(gonefishing, n_fish)
mean_weight_sample = mean(fishing_trip$weight)
mean_weight_sample

# Now bootstrap that sample
boot1 = foreach(i = 1:2500, .combine='c') %do% {
  fishing_trip_bootstrap = resample(fishing_trip, n_fish)
  mean_weight_bootstrap = mean(fishing_trip_bootstrap$weight)
  mean_weight_bootstrap
}

# Compare the true sampling distribution with the bootstrapped sampling distribution
par(mfrow=c(2,1))
hist(my_fishing_year, 25, xlim=c(350, 700))
hist(boot1, 25, xlim=c(350, 700))

# True versus bootstrapped standard error
sd(my_fishing_year)
sd(boot1)

# the theoretical standard deviation again:
sd(gonefishing$weight)/sqrt(30)

