library(flexclust)
library(foreach)

# Load, center and scale the data
cars = read.csv('../data/cars.csv', header=TRUE)
X = cars[,-(1:9)]
X = scale(X, center=TRUE, scale=TRUE)

# Extract the centers and scales from the rescaled data (which are named attributes)
mu = attr(X,"scaled:center")
sigma = attr(X,"scaled:scale")

# Run k-means with 6 clusters and 25 re-starts
clust1 = kmeans(X, 6, nstart=1)
clust1$totss
clust1$betweenss
clust1$withinss
clust1$size

# Using kmeans++ initialization
clust2 = kcca(X, k=6, family=kccaFamily("kmeans"),
               control=list(initcent="kmeanspp"))

# This package has a different interface for accessing model output
parameters(clust2)
clust2@clusinfo

# Compare versus within-cluster average distances from the first run
clust1$withinss

# Uh-oh, where is this for kmeans++?
str(clust2)

# Roll our own function
centroids = parameters(clust2)
kpp_residualss = foreach(i=1:nrow(X), .combine='c') %do% {
	x = X[i,]
	a = clust2@cluster[i]
	m = centroids[a,]
	sum((x-m)^2)
}

sum(kpp_residualss)
clust1$tot.withinss


print(apply(parameters(kmeansPP_we8there),1,function(x) colnames(Z)[order(x, decreasing=TRUE)[1:10]]))
distEuclidean(Z, parameters(kmeansPP_we8there))   

