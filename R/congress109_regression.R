library(ggplot2)
library(glmnet)

countdata = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
memberdata = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# Normalize phrase counts to phrase frequencies
Z = countdata/rowSums(countdata)

# PCA
pc2 = prcomp(Z, scale=TRUE)
pve = summary(pc2)$importance[3,]
plot(pve)  # not much of an elbow

######
# Principal component regression using PCs
######

# Construct the feature matrix and response vector
X = pc2$x
y = {memberdata$party == 'R'}

# Lasso cross validation
out1 = cv.glmnet(X, y, family='binomial', type.measure="class")

# Choose lambda
plot(out1$lambda, out1$cvm)
lambda_hat = out1$lambda.min

# refit to the full data set with the "optimal" lambda
glm1 = glmnet(X, y, family='binomial', lambda = lambda_hat)

# The fit
glm1$beta
plot(glm1$beta)

# degrees of freedom and pseudo R^2
glm1$df
min(out1$cvm)  # cross-validated misclassification rate


######
# Compare with a fit using the phrase counts
######

X_phrases = as.matrix(countdata)
out2 = cv.glmnet(X_phrases, y, family='binomial', type.measure='class')
plot(out2$lambda, out2$cvm)
lambda_hat2 = out2$lambda.min

# refit to the full data set
glm2 = glmnet(X_phrases, y, family='binomial', lambda = lambda_hat2)

# degrees of freedom and CV error
glm2$df
min(out2$cvm)  # cross-validated error at chosen lambda
