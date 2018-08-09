# Load a toy data and peak at the numbers
data(iris)
head(iris)

# Pick out two columns
Z = iris[,c(1,4)]

# Clearly a lot of correlation structure in the measurements 
plot(Z)

# Standardize (center/scale) the data
Z_std = scale(Z)
plot(Z_std)

# Pick a random unit-norm vector and show the implied subspace
v_try = rnorm(2)
v_try = v_try/sqrt(sum(v_try^2))  # normalize to unit length

# show the points and the vector v
plot(Z_std, pch=19, col=rgb(0.3,0.3,0.3,0.3))
segments(0, 0, v_try[1], v_try[2], col='red', lwd=4)

# show the implied subspace spanned by this vector
slope = v_try[2]/v_try[1]
abline(0, slope)

# Now show the subspace, side by side with the project points as a histogram

v_try = rnorm(2)
v_try = v_try/sqrt(sum(v_try^2))  # normalize to unit length

par(mfrow=c(1,2))
plot(Z_std, pch=19, col=rgb(0.3,0.3,0.3,0.3),
     xlim=c(-2.5,2.5), ylim=c(-2.5,2.5))
slope = v_try[2]/v_try[1]
abline(0, slope)  # plot the subspace as a line

# Project the points onto that subspace
alpha = Z_std %*% v_try  # inner product of each row with v_try
z_hat = alpha %*% v_try  # locations in R^2
points(z_hat, col='blue', pch=4)
segments(0, 0, v_try[1], v_try[2], col='red', lwd=4)

# the number at the top is the variance of the projected points
hist(alpha, 25, xlim=c(-3,3), main=round(var(alpha), 2))


# Compare these random projections to the first PC
pc1 = prcomp(Z_std)
v_best = pc1$rotation[,1]
v_best
slope_best = v_best[2]/v_best[1]  # intercept = 0, slope = rise/run

par(mfrow=c(1,2))
plot(Z_std, xlim=c(-2.5,2.5), ylim=c(-2.5,2.5))
abline(0, slope_best)  # plot the subspace as a line

alpha_best = Z_std %*% v_best  # inner product of each row with v_best
z_hat = alpha_best %*% v_best  # locations in R^2
points(z_hat, col='blue', pch=4)
segments(0, 0, v_best[1], v_best[2], col='red', lwd=4)

hist(alpha_best, 25, xlim=c(-3,3), main=round(var(alpha_best), 2))


# How much of the variation does this first principal component predict?
var(Z_std[,1])
var(Z_std[,2])
var(Z_std[,1]) + var(Z_std[,2])

# Shorthand for this
var_bycomponent = apply(Z_std, 2, var)
sum(var_bycomponent)

# Compare with variance of the projected points
var(alpha_best)
var(alpha_best)/sum(var_bycomponent)  # as a ratio

# Compare with the answer from prcomp's plot method
par(mfrow=c(1,1))
plot(pc1)
pc1$sdev^2  # the standard deviation, rather than the variance


v_best2 = pc1$rotation[,2]

# The two PCs
v_best
v_best2


# Now look at the four numerical variables
Z = iris[,1:4]

# Clearly a lot of correlation structure in the measurements 
pairs(Z)

# Run PCA on all four dimensions
# scaling inside the prcomp function now
pc1 = prcomp(Z, scale.=TRUE)

# Look at the basic plotting and summary methods
summary(pc1)
plot(pc1)

# Question 1: where do the individual points end up in PC space?
biplot(pc1)

# A biplot I like a bit better
loadings = pc1$rotation
scores = pc1$x
qplot(scores[,1], scores[,2], color=iris$Species, xlab='Component 1', ylab='Component 2')

# Question 2: how are the principal components related to the original variables?
pc1$rotation
