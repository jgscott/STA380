library(wordcloud)
library(textir)

data(we8there)

# Scaled per-document phrase frequencies
X_freq = we8thereCounts/rowSums(we8thereCounts)
Z = scale(X_freq)

# Run k means
kmeans_we8there <- kmeans(Z, 4)  

# The first centroid
head(sort(kmeans_we8there$centers[1,], decreasing=TRUE), 10)

# All 10 centroids
print(apply(kmeans_we8there$centers,1,function(x) colnames(Z)[order(x, decreasing=TRUE)[1:10]]))

# A word cloud
wordcloud(colnames(Z), kmeans_we8there$centers[2,], min.freq=0, max.words=100)
