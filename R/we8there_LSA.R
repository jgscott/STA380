library(textir)

# Load data and calculate TF-IDF weights
data(we8there)
Z = tfidf(we8thereCounts)
my_dictionary = colnames(Z)

# A function to calculate a reduced number of principal components
smallpca = function(X, ncomps, scale=TRUE) {
  Xs = scale(X, scale=scale)
  myd = svd(Xs, nu = ncomps, nv = ncomps)
  list(rotation = myd$v, x = myd$u %*% diag(myd$d))
}


lsa1 = smallpca(Z, 3)


plot(lsa1$rotation[,1:2])
identify(lsa1$rotation[,1:2], n=2)



