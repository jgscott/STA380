# Protein first
protein <- read.csv("../data/protein.csv", row.names=1)

# Center/scale the data
protein_scaled <- scale(protein, center=TRUE, scale=TRUE) 

# Form a pairwise distance matrix using the dist function
protein_distance_matrix = dist(protein_scaled, method='euclidean')


# Now run hierarchical clustering
hier_protein = hclust(protein_distance_matrix, method='average')


# Plot the dendrogram
plot(hier_protein, cex=0.8)

# Cut the tree into 5 clusters
cluster1 = cutree(hier_protein, k=5)
summary(factor(cluster1))

# Examine the cluster members
which(cluster1 == 1)
which(cluster1 == 2)
which(cluster1 == 3)


# Using max ("complete") linkage instead
hier_protein2 = hclust(protein_distance_matrix, method='complete')

# Plot the dendrogram
plot(hier_protein2, cex=0.8)
cluster2 = cutree(hier_protein2, k=5)
summary(factor(cluster2))

# Examine the cluster members
which(cluster2 == 1)
which(cluster2 == 2)
which(cluster2 == 3)


## Now the cars data
cars = read.csv('../data/cars.csv', header=TRUE)

summary(cars)

# Center and scale the data
X = cars[,-(1:9)]
X = scale(X, center=TRUE, scale=TRUE)

# Extract the centers and scales from the rescaled data (which are named attributes)
mu = attr(X,"scaled:center")
sigma = attr(X,"scaled:scale")

# First form a pairwise distance matrix
distance_between_cars = dist(X)

# Now run hierarchical clustering
h1 = hclust(distance_between_cars, method='complete')

# Cut the tree into 10 clusters
cluster1 = cutree(h1, k=10)
summary(factor(cluster1))

# Examine the cluster members
which(cluster1 == 1)

# Plot the dendrogram
plot(h1, cex=0.3)

