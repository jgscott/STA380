gasoline = read.csv('../data/gasoline.csv', header=TRUE)
head(gasoline)

X = as.matrix(gasoline[,-1])
y = gasoline[,1]


# Ordinary least squares
lm1 = lm(y ~ X)

# Yikes!
summary(lm1)
dim(X)

# Plot a random sample of the NIR spectra
mu_x = colMeans(X)
nir_wavelength = seq(900, 1700, by=2)
par(mfrow=c(2,2))
for(i in sample.int(nrow(X), 4)) {
	plot(nir_wavelength, X[i,] - mu_x, main=i, ylim=c(-0.1,0.1))
}

# They all differ from the mean in very structured ways
# Extremely strong collinearity among the predictor variables
sigma_X = cor(X)
sigma_X[1:10,1:10]


# Let's try dimensionality reduction via PCA first
pc_gasoline = prcomp(X, scale=TRUE)

# Visualize the first few principal components
plot(nir_wavelength, pc_gasoline$rotation[,1], ylim=c(-0.15,0.15))
plot(nir_wavelength, pc_gasoline$rotation[,2], ylim=c(-0.15,0.15))
plot(nir_wavelength, pc_gasoline$rotation[,3], ylim=c(-0.15,0.15))

# Regress on the first K
K = 5
V = pc_gasoline$rotation[,1:K]
scores = X %*% V
pcr1 = lm(y ~ scores)

summary(pcr1)

# Show the model fit
plot(fitted(pcr1), y)

# Express the coefficients in terms of the original variables
beta_pcr = coef(pcr1)[-1]
beta_nir = rowSums(V %*% diag(beta_pcr))

plot(beta_nir)

# This coefficient vector implies the same fitted values
plot(X %*% beta_nir, scores %*% beta_pcr)
abline(0,1)
