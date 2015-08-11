FXmonthly = read.csv('../data/FXmonthly.csv', header=TRUE)

summary(FXmonthly)

# USD-GBP
plot(FXmonthly$exukus)

# Convert everything to returns
FXmonthly <- (FXmonthly[2:120,]-FXmonthly[1:119,])/(FXmonthly[1:119,]) # proportion change

# A pairs plot for a few sets of currencies
pairs(FXmonthly[,1:5])

cor(FXmonthly[,c('exeuus','exhkus','excaus','exmxus','exukus')])

## PCA 
fxpca = prcomp(FXmonthly, scale=TRUE)

plot(fxpca)
mtext(side=1, "Currency Difference Principle Components",  line=1, font=2)

# Get the principal component scores
fx_scores = predict(fxpca)  # same as fxpca$x

# Color each point so that they get darker over time
plot(fx_scores[,1:2], pch=21, bg=terrain.colors(120)[120:1], main="Currency PC scores")
legend("topleft", fill=terrain.colors(3),
       legend=c("2010","2005","2001"), bty="n", cex=0.75)
outlier = identify(fx_scores[,1:2], n=1)

# Huge outlier (Oct 2008 = month of the Lehman Brothers collapse)
FXmonthly[outlier,]

# Re-run without the outlier
fxpca = prcomp(FXmonthly[-outlier,], scale=TRUE)
fx_scores = predict(fxpca)  # same as fxpca$x

plot(fxpca)

plot(fx_scores[,1:2], pch=21, bg=terrain.colors(119)[119:1], main="Currency PC scores")
legend("bottomleft", fill=terrain.colors(3),
       legend=c("2010","2005","2001"), cex=0.75)

# Look at the loadings
barplot(fxpca$rotation[,1], las=2)

# Refer to the actual currency/country names
currency_codes = read.table('../data/currency_codes.txt')

barplot(fxpca$rotation[,1], las=2)  # USD strength overall
barplot(fxpca$rotation[,2], las=2)
barplot(fxpca$rotation[,3], las=2)

currency_codes
View(currency_codes)

# Compare with factor analysis
Y = scale(FXmonthly[-outlier,], center=TRUE, scale=FALSE)
fa_fx = factanal(Y, 3, scores='regression')
print(fa_fx)

# The loadings
barplot(fa_fx$loadings[,1], las=2, cex.names=0.8)
barplot(fa_fx$loadings[,2], las=2, cex.names=0.8)
barplot(fa_fx$loadings[,3], las=2, cex.names=0.8)

# The variances of the idiosyncratic noise terms
barplot(fa_fx$uniquenesses, las=2, cex.names=0.8)

# Scatter plot of first two factor scores
plot(fa_fx$scores[,1:2], pch=21,
     bg=terrain.colors(119)[119:1],
     main="Currency factor scores")
legend("bottomright", fill=terrain.colors(3),
       legend=c("2010","2005","2001"), cex=0.6)
