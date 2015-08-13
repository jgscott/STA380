# Parameters for three normal distributions
mu1 = 40
sigma1 = 10

mu2 = 65
sigma2 = 20

mu3 = 90
sigma3 = 3


# The three mixture components
curve(dnorm(x, mu3, sigma3), from=0, to=100, n=1001, col='red', xlab='Basketball Skill', ylab='Probability')
curve(dnorm(x, mu2, sigma2), from=0, to=100, n=1001, col='blue', add=TRUE)
curve(dnorm(x, mu1, sigma1), from=0, to=100, n=1001, col='grey', add=TRUE)

# Now a mixture
weights = c(0.9, 0.05, 0.05)

curve(weights[1]*dnorm(x, mu1, sigma1) + weights[2]*dnorm(x, mu2, sigma2)  + weights[3]*dnorm(x, mu3, sigma3),
	from=0, to=100, ylab='Probability', n=1001)
	
# With the original components
curve(weights[3]*dnorm(x, mu3, sigma3), col='red', n=1001, add=TRUE)
curve(weights[2]*dnorm(x, mu2, sigma2), from=0, to=100, n=1001, col='blue', add=TRUE)
curve(weights[1]*dnorm(x, mu1, sigma1), from=0, to=100, n=1001, col='grey', add=TRUE)
