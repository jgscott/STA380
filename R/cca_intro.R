# Canonical correlation analysis
mmreg = read.csv('../data/mmreg.csv')
head(mmreg)

# Focus on two sets of variables
X = scale(mmreg[,c(1,2)], center=TRUE, scale=TRUE)
Y = scale(mmreg[,c(4,6)], center=TRUE, scale=TRUE)

par(mfrow=c(1,2))
plot(X)
plot(Y)


# Let's try some random canonical vectors
v_x = rnorm(2); v_x = v_x / sqrt(sum(v_x^2))
slope_x = v_x[2]/v_x[1]

v_y = rnorm(2); v_y = v_y / sqrt(sum(v_y^2))
slope_y = v_y[2]/v_y[1]

par(mfrow=c(1,2))

plot(X, pch=19, cex=0.6, col=rgb(0,0,0,0.2))
abline(0, slope_x)
segments(0, 0, v_x[1], v_x[2], col='red', lwd=4)

plot(Y, pch=19, cex=0.6, col=rgb(0,0,0,0.2))
abline(0, slope_y)
segments(0, 0, v_y[1], v_y[2], col='red', lwd=4)



# Now look at the projected points
par(mfrow=c(1,3))

# Random canonical vectors
v_x = rnorm(2); v_x = v_x / sqrt(sum(v_x^2))
slope_x = v_x[2]/v_x[1]

v_y = rnorm(2); v_y = v_y / sqrt(sum(v_y^2))
slope_y = v_y[2]/v_y[1]

plot(X, pch=19, cex=0.6, col=rgb(0,0,0,0.2))
a_x = X %*% v_x
points(a_x %*% v_x, pch=4, col='blue')
abline(0, slope_x)
segments(0, 0, v_x[1], v_x[2], col='red', lwd=4)

plot(Y, pch=19, cex=0.6, col=rgb(0,0,0,0.2))
a_y = Y %*% v_y
points(a_y %*% v_y, pch=4, col='blue')
abline(0, slope_y)
segments(0, 0, v_y[1], v_y[2], col='red', lwd=4)

# Compare the two sets of scores
plot(a_x, a_y, main=round(cor(a_x, a_y), 2))

# Run CCA
cc1 = cancor(X, Y)
cc1$xcoef
cc1$ycoef
cc1$cor


#  CCA on mouse nutrition
mouse_nutrition = read.csv('../data/mouse_nutrition.csv', row.names=1)
head(mouse_nutrition)

# Extract the relevant variables
lipid_varID = grep('lipid', colnames(mouse_nutrition))

# Set the two matrices on which we will run CCA
gene_data = as.matrix(mouse_nutrition[,1:5])
lipid_data = as.matrix(mouse_nutrition[,121:125])

# Pairwise correlations
cor(gene_data, lipid_data)

# Run CCA
cca_mouse = cancor(gene_data, lipid_data)
x_scores = gene_data %*% cca_mouse$xcoef
y_scores = lipid_data %*% cca_mouse$ycoef

# Examine the CCA scores
plot(x_scores[,1], y_scores[,1])
cor(x_scores[,1], y_scores[,1])
cca_mouse$cor
