library(foreach)  # I typically use this for MC simulations

# First, a riskless asset
Horizon = 40
ReturnAvg = 0.05

Wealth = 10000
# Sweep through each year and update the value of wealth
for(year in 1:Horizon) {
	ThisReturn = ReturnAvg
	Wealth = Wealth * (1 + ThisReturn)
}
Wealth

# The usual compound-interest formula
10000 * (1+ReturnAvg)^40


# Same thing, except now we track wealth over time

Wealth = 10000  # Reset initial wealth
WealthOverTime = rep(0, Horizon)  # Allocate some space
# Sweep through each year and update the value of wealth
for(year in 1:Horizon) {
  ThisReturn = ReturnAvg
  Wealth = Wealth * (1 + ThisReturn)
  WealthOverTime[year] = Wealth
}
Wealth
plot(WealthOverTime)



# Now a risky asset with a positive expected return
ReturnAvg = 0.05
ReturnSD = 0.05
Horizon = 40

Wealth = 10000  # Reset initial wealth
WealthOverTime = rep(0, Horizon)  # Allocate some space
# Sweep through each year and update the value of wealth
for(year in 1:Horizon) {
  ThisReturn = rnorm(1, ReturnAvg, ReturnSD)
  Wealth = Wealth * (1 + ThisReturn)
  WealthOverTime[year] = Wealth
}
Wealth
plot(WealthOverTime)


# Now a Monte Carlo simulation
ReturnAvg = 0.05
ReturnSD = 0.05
Horizon = 40
sim1 = foreach(i=1:1000, .combine='c') %do% {
	Wealth = 10000  # Reset initial wealth
	# Sweep through each year and update the value of wealth
	for(year in 1:Horizon) {
		# Generate a random return
		ThisReturn = rnorm(1, ReturnAvg, ReturnSD)
		
		# Update wealth
		Wealth = Wealth * (1 + ThisReturn)
	}
	# Output the value of wealth for each simulated scenario
	Wealth
}
hist(sim1, 50)
abline(v=10000 * (1+ReturnAvg)^40, col='red', lwd=3)

# We can easily calculate expected value from the MC simulation.
# Just take a simple average of the simulated futures.
# Law of large numbers!
mean(sim1)
sd(sim1)

#  We can also save each year's result in each simulated scenario
ReturnAvg = 0.05
ReturnSD = 0.025
Horizon = 40
sim1 = foreach(i=1:500, .combine='rbind') %do% {
  Wealth = 10000  # Reset initial wealth
  WealthOverTime = rep(0, Horizon)  # Allocate some space
  # Sweep through each year and update the value of wealth
  for(year in 1:Horizon) {
    ThisReturn = rnorm(1, ReturnAvg, ReturnSD)
    Wealth = Wealth * (1 + ThisReturn)
    WealthOverTime[year] = Wealth
  }
  WealthOverTime
}
head(sim1)

# Plot a few simulated scenarios
plot(1:Horizon, sim1[1,], type='l')
lines(1:Horizon, sim1[2,], type='l')
lines(1:Horizon, sim1[3,], type='l')

# A spaghetti plot to show variability over time.
# type ?par into the console to see lots of graphical settings
plot(1:Horizon, colMeans(sim1), type='l', col='red',
	las=1, xlab='Year', ylab='Value',
	main='A 40-year portfolio: uncertainty over time', cex.axis=0.8)
for(sim in 1:200) {
  lines(1:Horizon, sim1[sim,], type='l', col=rgb(0,0,0.5,0.05))
}
lines(1:Horizon, colMeans(sim1), col='red', lwd=2)


# Now look at terminal wealth (the last column)
hist(sim1[,Horizon])
mean(sim1[, Horizon])
sd(sim1[, Horizon])
