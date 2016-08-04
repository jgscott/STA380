library(ggplot2)
library(flexclust)
library(foreach)
library(mosaic)

cars = read.csv('../data/cars.csv', header=TRUE)

summary(cars)

# Center and scale the data
X = cars[,-(1:9)]
X = scale(X, center=TRUE, scale=TRUE)

# Extract the centers and scales from the rescaled data (which are named attributes)
mu = attr(X,"scaled:center")
sigma = attr(X,"scaled:scale")

# Run k-means with 6 clusters and 25 re-starts
clust1 = kmeans(X, 6, nstart=25)

# What are the clusters?
clust1$center  # not super helpful
clust1$center[1,]*sigma + mu
clust1$center[2,]*sigma + mu

# Which cars are in which clusters?
which(clust1$cluster == 1)
which(clust1$cluster == 2)
which(clust1$cluster == 3)
which(clust1$cluster == 4)
which(clust1$cluster == 5)

# A few plots with cluster membership shown
qplot(Weight, Length, data=cars, color=factor(clust1$cluster))
qplot(Horsepower, CityMPG, data=cars, color=factor(clust1$cluster))





# Using kmeans++ initialization
clust2 = kcca(X, k=6, family=kccaFamily("kmeans"),
              control=list(initcent="kmeanspp"))

# This package has a different interface for accessing model output
parameters(clust2)
clust2@clusinfo

# Examine the centers
clust2@centers

clust2@centers[1,]*sigma + mu
clust2@centers[2,]*sigma + mu
clust2@centers[3,]*sigma + mu

which(clust2@cluster == 3)

# Compare versus within-cluster average distances from the first run
clust1$withinss

# Roll our own function to calculate this for cclust
kpp_residualss = foreach(i=1:nrow(X), .combine='c') %do% {
  x = X[i,]
  a = clust2@cluster[i]
  m = centroids[a,]
  sum((x-m)^2)
}

