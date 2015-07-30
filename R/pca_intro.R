library(ggplot2)

# Load a toy data and peak at the numbers
data(iris)
head(iris)

# Pick out the numerical columns from the data set (run ?iris for further info)
Z = iris[,1:4]

# Clearly a lot of correlation structure in the measurements 
pairs(Z)

# Run PCA
pc1 = prcomp(Z, scale.=TRUE)

# Look at the basic plotting and summary methods
pc1
summary(pc1)
plot(pc1)
biplot(pc1)

# A more informative biplot
loadings = pc1$rotation
scores = pc1$x
qplot(scores[,1], scores[,2], color=iris$Species, xlab='Component 1', ylab='Component 2')
