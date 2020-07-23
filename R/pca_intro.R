library(ggplot2)

# Load a toy data and peak at the numbers
data(iris)
head(iris)

# Pick out two columns and mean-center
Z = iris[,c(1,4)]

Z = scale(Z, center=TRUE, scale=FALSE)

# Clearly a lot of correlation structure in the measurements 
plot(Z)

# Pick a random unit-norm vector and show the implied subspace
v_try = rnorm(2)
v_try = v_try/sqrt(sum(v_try^2))  # normalize to unit length

# show the points and the vector v
plot(Z, pch=19, col=rgb(0.3,0.3,0.3,0.3))
segments(0, 0, v_try[1], v_try[2], col='red', lwd=4)

# show the implied subspace spanned by this vector
slope = v_try[2]/v_try[1]
abline(0, slope)


# Now show the subspace, side by side with the projected points as a histogram
# Let's run the following code block a dozen or so times and see if we can
# get a good candidate for the first PC just by guess and check
# What to look for: the "better" random candidates for PC1 are the ones 
# leading to higher variance of the projected (blue) points.
# the "worse" candidates point in the clearly wrong direction
# and have lower variance projections.

#### begin block
v_try = rnorm(2)
v_try = v_try/sqrt(sum(v_try^2))  # normalize to unit length

par(mfrow=c(1,2))
plot(Z, pch=19, col=rgb(0.3,0.3,0.3,0.3),
     xlim=c(-2.5,2.5), ylim=c(-2.5,2.5))
slope = v_try[2]/v_try[1]
abline(0, slope)  # plot the subspace as a line

# Project the points onto that subspace
alpha = Z %*% v_try  # inner product of each row with v_try
z_hat = alpha %*% v_try  # locations in R^2
points(z_hat, col='blue', pch=4)
segments(0, 0, v_try[1], v_try[2], col='red', lwd=4)

# the number at the top is the variance of the projected points
hist(alpha, 25, xlim=c(-3,3), main=round(var(alpha), 2))
#### end block



# Compare these random projections to the first PC
pc_Z = prcomp(Z, rank=1)

# the principal components themselves are in the "rotation" component
# synonym: loadings
pc_Z$rotation
v_try #compare with our "guess and check" PC
# Note: the principal components are not identified up to sign
# so we can negate the whole vector and get the same subspace

# How much of the variation does this first principal component predict?
summary(pc_Z)

# what about the 1D summaries themselves?
# I usually call these "scores"
# each entry here is v dot x,
# where v is PC1 and x is the original 2D data point
pc_Z$x

