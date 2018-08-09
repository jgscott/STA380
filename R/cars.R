library(ggplot2)
library(LICORS)  # for kmeans++
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

# Run k-means with 6 clusters and 25 starts
clust1 = kmeans(X, 6, nstart=25)

# What are the clusters?
clust1$center  # not super helpful
clust1$center[1,]*sigma + mu
clust1$center[2,]*sigma + mu
clust1$center[4,]*sigma + mu


# Which cars are in which clusters?
which(clust1$cluster == 1)
which(clust1$cluster == 2)
which(clust1$cluster == 3)
which(clust1$cluster == 4)
which(clust1$cluster == 5)

# A few plots with cluster membership shown
# qplot is in the ggplot2 library
qplot(Weight, Length, data=cars, color=factor(clust1$cluster))
qplot(Horsepower, CityMPG, data=cars, color=factor(clust1$cluster))


# Using kmeans++ initialization
clust2 = kmeanspp(X, k=6, nstart=25)

clust2$center[1,]*sigma + mu
clust2$center[2,]*sigma + mu
clust2$center[4,]*sigma + mu

# Which cars are in which clusters?
which(clust2$cluster == 1)
which(clust2$cluster == 2)
which(clust2$cluster == 3)

# Compare versus within-cluster average distances from the first run
clust1$withinss
clust2$withinss
sum(clust1$withinss)
sum(clust2$withinss)
clust1$tot.withinss
clust2$tot.withinss
clust1$betweenss
clust2$betweenss

