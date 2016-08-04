library(wordcloud)
library(textir)
library(flexclust)


data(we8there)

# Scaled per-document phrase frequencies
X_freq = we8thereCounts/rowSums(we8thereCounts)
Z = scale(X_freq)

# Run k means
kmeans_we8there <- kmeans(Z, 4, nstart = 10)  

# The first centroid
head(sort(kmeans_we8there$centers[1,], decreasing=TRUE), 10)

# All centroids
print(apply(kmeans_we8there$centers,1,function(x) colnames(Z)[order(x, decreasing=TRUE)[1:10]]))

# A word cloud
wordcloud(colnames(Z), kmeans_we8there$centers[2,], min.freq=0, max.words=100)

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
kmeansPP_we8there = cclust(Z, k=4, control=list(initcent="kmeanspp"))

# This package has a different interface for accessing model output
parameters(kmeansPP_we8there)
kmeansPP_we8there@clusinfo

print(apply(parameters(kmeansPP_we8there),1,function(x) colnames(Z)[order(x, decreasing=TRUE)[1:10]]))

# Roll our own function
centers = parameters(kmeansPP_we8there)
kpp_residualss = foreach(i=1:nrow(Z), .combine='c') %do% {
	x = Z[i,]
	a = kmeansPP_we8there@cluster[i]
	m = centers[a,]
	sum((x-m)^2)
}

sum(kpp_residualss)
sum(kmeans_we8there$withinss)


