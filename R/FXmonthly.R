library(ggplot2)

FXmonthly = read.csv('../data/FXmonthly.csv', header=TRUE)
summary(FXmonthly)

# Refer to the actual currency/country names
currency_codes = read.table('../data/currency_codes.txt')
currency_codes

colnames(FXmonthly) = currency_codes$V2


# USD-GBP
plot(FXmonthly$'norway')
plot(FXmonthly$'brazil')


# Convert everything to returns
FXmonthly_ret = (FXmonthly[2:120,]-FXmonthly[1:119,])/(FXmonthly[1:119,]) # proportion change

plot(FXmonthly_ret$norway)

# A pairs plot for a few sets of currencies
pairs(FXmonthly_ret[,1:5])

Z = scale(FXmonthly_ret, center=TRUE, scale=FALSE)

## PCA 
fxpca = prcomp(Z, rank=5)
summary(fxpca)
plot(fxpca)
mtext(side=1, "Currency Returns: Principal Components",  line=1, font=2)

# A different method for extracting the principal component scores
fx_scores = predict(fxpca)  # same as fxpca$x

# Color each point so that they get darker over time
plot(fx_scores[,1:2], pch=21, bg=cm.colors(120)[120:1], main="Currency PC scores")
legend("topright", fill=cm.colors(3),
       legend=c("2010","2005","2001"), bty="n", cex=0.75)
outlier = identify(fx_scores[,1:2], n=1)

# This illustrates a nice application of PCA: multivariate outlier detection
# Huge outlier (Oct 2008 = month of the Lehman Brothers collapse)
FXmonthly_ret[outlier,]

# Re-run without the outlier
fxpca = prcomp(Z[-outlier,], scale=TRUE, rank=5)
summary(fxpca)
fx_scores = predict(fxpca)  # same as fxpca$x

plot(fxpca)

# Question 1: where do the original observations end up in PC space?
plot(fx_scores[,1:2], pch=21, bg=terrain.colors(119)[119:1], main="Currency PC scores")
legend("bottomleft", fill=terrain.colors(3),
       legend=c("2010","2005","2001"), cex=0.75)

# Question 2: how are the loadings related to the original variables?
barplot(fxpca$rotation[,1], las=2)
barplot(fxpca$rotation[,2], las=2)
barplot(fxpca$rotation[,3], las=2)

