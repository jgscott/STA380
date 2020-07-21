library(tidyverse)
library(glmnet)

# read in data
countdata = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
memberdata = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# corpus statistics
N = nrow(countdata)
D = ncol(countdata)

# Here someone's already done all the hard preprocessing/tokenization/etc for us
# We are handed a document-term matrix.
# Let's construct TF-IDF weights by hand.

# TF weights
TF_mat = countdata/rowSums(countdata)

# IDF weights
IDF_vec = log(1 + N/colSums(countdata > 0))

# TF-IDF weights:
# use sweep to multiply the columns (margin = 2) by the IDF weights
TFIDF_mat = sweep(TF_mat, MARGIN=2, STATS=IDF_vec, FUN="*")  

# spot check an entry
# (I like to sanity-check the results of a function whose syntax is a bit opaque)
TF_mat[5, 224]
IDF_vec[224]
TFIDF_mat[5,224] == TF_mat[5, 224] * IDF_vec[224]

# PCA on the TF-IDF weights
pc_congress = prcomp(TFIDF_mat, scale=TRUE)
pve = summary(pc_congress)$importance[3,]
plot(pve)  # not much of an elbow

######
# Principal component regression using PCs
######

# Construct the feature matrix and response vector.
# We'll take as candidate variables the leading PCs.
# Here TFIDF + PCA + truncating the lower-order (noisier) PCs
# is our "feature engineering" pipeline.
X = pc_congress$x[,1:100]
y = {memberdata$party == 'R'}

# Lasso cross validation
out1 = cv.glmnet(X, y, family='binomial', type.measure="class")

# Choose lambda to minimize CV error
plot(out1$lambda, out1$cvm, log='x')
lambda_hat = out1$lambda.min

# refit to the full data set with the "optimal" lambda
glm1 = glmnet(X, y, family='binomial', lambda = lambda_hat)

# The fit
glm1$beta
plot(glm1$beta)

# degrees of freedom and cross-validated misclassification rate
glm1$df
min(out1$cvm)  


######
# Compare with a fit using the phrase counts
######

X_phrases = as.matrix(countdata)
out2 = cv.glmnet(X_phrases, y, family='binomial', type.measure='class')
plot(out2$lambda, out2$cvm, log='x')
lambda_hat2 = out2$lambda.min

# refit to the full data set
glm2 = glmnet(X_phrases, y, family='binomial', lambda = lambda_hat2)
plot(glm2$beta)

# degrees of freedom and CV error
glm2$df
min(out2$cvm)  # cross-validated error at chosen lambda

# Conclusion from using PCA on TF-IDF weights:
# Large relative reduction in out-of-sample error AND a simpler model.
# Win-win!


####
# Let's compare this to a Naive Bayes classifier
####

# First split into a training and set set
X_NB = countdata
y_NB = 0+{memberdata$party == 'R'}

train_frac = 0.8
train_set = sort(sample.int(N, floor(train_frac*N)))
test_set = setdiff(1:N, train_set)

# training and testing matrices
# Notice the smoothing (pseudo-count) to the training matrix
# this ensures we don't have zero-probability events
X_train = X_NB[train_set,] + 1/D
y_train = y_NB[train_set]
X_test = X_NB[test_set,]
y_test = y_NB[test_set]

# First construct our vectors of probabilities under D (0) and R (1) classes
# smoothing the training matrix of counts was important so that we get no zeros here
pvec_0 = colSums(X_train[y_train==0,])
pvec_0 = pvec_0/sum(pvec_0)
pvec_1 = colSums(X_train[y_train==1,])
pvec_1 = pvec_1/sum(pvec_1)

# now try a query doc in the test set
i = 100
test_doc = X_test[i,]
sum(test_doc * log(pvec_0))
sum(test_doc * log(pvec_1))
y_test[i]


# classify all the docs in the test set
yhat_test = foreach(i = seq_along(test_set), .combine='c') %do% {
  test_doc = X_test[i,]
  logp0 = sum(test_doc * log(pvec_0))
  logp1 = sum(test_doc * log(pvec_1))
  0 + {logp1 > logp0}
}

confusion_matrix = xtabs(~y_test + yhat_test)
confusion_matrix

# overall error rate: comparable to logit model with PCA on TF-IDF weights
1-sum(diag(confusion_matrix))/length(test_set)
