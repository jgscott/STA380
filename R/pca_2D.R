# Load a toy data and peak at the numbers
data(iris)

# Pick out the first two columns
Z = iris[,c(1,4)]

# Clearly a lot of correlation structure in the measurements 
plot(Z)

Z_centered = scale(Z, center=TRUE, scale=FALSE)
plot(Z_centered)

# Pick some random unit-norm vectors and show the implied subspace
v_try = rnorm(2)
v_try = v_try/sqrt(sum(v_try^2))
slope = v_try[2]/v_try[1]

plot(Z_centered)
abline(0, slope)
segments(0, 0, v_try[1], v_try[2], col='red', lwd=4)


# Pick some random unit-norm vectors to define subspace
# and project the points onto that subspace
v_try = rnorm(2)
v_try = v_try/sqrt(sum(v_try^2))
slope = v_try[2]/v_try[1]  # intercept = 0, slope = rise/run

# Show the subspace
par(mfrow=c(1,2))
plot(Z_centered, xlim=c(-2.5,2.5), ylim=c(-2.5,2.5))
abline(0, slope)  # plot the subspace as a line

# Project the points onto that subspace
alpha = Z_centered %*% v_try  # inner product of each row with v_try
z_hat = alpha %*% v_try  # locations in R^2
points(z_hat, col='blue', pch=4)
segments(0, 0, v_try[1], v_try[2], col='red', lwd=4)

hist(alpha, 25, xlim=c(-3,3), main=round(var(alpha), 2))


# Compare these random projections to the first PC
pc1 = prcomp(Z_centered)
v_best = pc1$rotation[,1]
v_best
slope_best = v_best[2]/v_best[1]  # intercept = 0, slope = rise/run

par(mfrow=c(1,2))
plot(Z_centered, xlim=c(-2.5,2.5), ylim=c(-2.5,2.5))
abline(0, slope_best)  # plot the subspace as a line

alpha_best = Z_centered %*% v_best  # inner product of each row with v_best
z_hat = alpha_best %*% v_best  # locations in R^2
points(z_hat, col='blue', pch=4)
segments(0, 0, v_best[1], v_best[2], col='red', lwd=4)

hist(alpha_best, 25, xlim=c(-3,3), main=round(var(alpha_best), 2))


# How much of the variation does this first principal component predict?
var(Z_centered[,1])
var(Z_centered[,2])
var(Z_centered[,1]) + var(Z_centered[,2])

# Shorthand for this
var_bycomponent = apply(Z_centered, 2, var)
sum(var_bycomponent)

# Compare with variance of the projected points
var(alpha_best)
var(alpha_best)/sum(var_bycomponent)  # as a ratio

# Compare with the answer from prcomp's plot method
par(mfrow=c(1,1))
plot(pc1)
pc1$sdev^2  # the standard deviation, rather than the variance
