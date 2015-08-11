library(lda)


data(cora.documents)
data(cora.vocab)
data(cora.cites)
data(cora.titles)

D = length(cora.vocab)
N = length(cora.documents)

X = matrix(0, N, D)
for(i in 1:N) {
  x = cora.documents[[i]]
  for(j in 1:ncol(x)) {
    k = x[1,j]
    v = x[2,j]
    X[i,k] = v
  }
}


# A function to compute TF-IDF weightings
my_tfidf = function(x) {
  term_freq = x/rowSums(x)
  doc_freq = log(colSums(x > 0) + 1) - log(nrow(x))
  out = scale(term_freq, center=FALSE, scale=doc_freq) # tf-idf
  out
}

Z = my_tfidf(X)

pc1 = prcomp(Z)
