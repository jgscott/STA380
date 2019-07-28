library(wordcloud)
library(textir) # for data set
library(LICORS)  # for kmeans++

data(we8there)

# a sparsematrix of phrase counts
str(we8thereCounts)

# Scaled per-document phrase frequencies
X_freq = we8thereCounts/rowSums(we8thereCounts)
Z = scale(X_freq)

# Run k means
kmeans_we8there <- kmeans(Z, 10, nstart = 10)  

# The first centroid, sorted by word frequency
head(sort(kmeans_we8there$centers[1,], decreasing=TRUE), 10)

# All centroids
print(apply(kmeans_we8there$centers,1,function(x) colnames(Z)[order(x, decreasing=TRUE)[1:10]]))

# A word cloud
wordcloud(colnames(Z), kmeans_we8there$centers[1,], min.freq=0, max.words=25)
wordcloud(colnames(Z), kmeans_we8there$centers[7,], min.freq=0, max.words=25)

# The different sums of squares: not great
kmeans_we8there$totss   # total sums of squares
kmeans_we8there$withinss  # sums of squares within each cluster
kmeans_we8there$tot.withinss # sum of sums of squares of all clusters
kmeans_we8there$betweenss  # sum of square distances of the cluster centers

# Sums of squares obey the "variance decomposition"
# aka Pythagorean theorem of statistics
kmeans_we8there$betweenss + kmeans_we8there$tot.withinss
kmeans_we8there$totss


# Now using kmeans++ initialization
kmeansPP_we8there = kmeanspp(Z, k=4)
kmeansPP_we8there$betweenss
kmeansPP_we8there$tot.withinss

wordcloud(colnames(Z), kmeansPP_we8there$centers[2,], min.freq=0, max.words=100)
