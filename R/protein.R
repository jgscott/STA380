# Old-school european protein consumption,
# in grams/person-day from various sources
protein <- read.csv("../data/protein.csv", row.names=1)
head(protein, 10)

# Center/scale the data
protein_scaled <- scale(protein, center=TRUE, scale=TRUE) 

## first, consider just red and white meat
red_white = protein_scaled[,c("WhiteMeat","RedMeat")]
head(red_white)
plot(red_white)

# Use k-means to get 3 clusters
cluster_redwhite <- kmeans(red_white, centers=3)


# Plot with labels
# type = 'n' just sets up the axes
plot(red_white, xlim=c(-2,2.75), 
    type="n", xlab="Red Meat", ylab="White Meat")  
text(red_white, labels=rownames(red_white), 
    col=rainbow(3)[cluster_redwhite$cluster])

## same plot, but now with clustering on all protein groups
## change the number of centers to see what happens.
cluster_all <- kmeans(protein_scaled, centers=7, nstart=50)
names(cluster_all)

# Extract some of the information from the fitted model
cluster_all$centers
cluster_all$cluster

# Plot the clustering on the red-white meat axes
plot(protein_scaled[,"WhiteMeat"], protein_scaled[,"RedMeat"], xlim=c(-2,2.75), 
    type="n", ylab="Red Meat", xlab="White Meat")
text(protein_scaled[,"WhiteMeat"], protein_scaled[,"RedMeat"], labels=rownames(protein), 
    col=rainbow(7)[cluster_all$cluster]) ## col is all that differs from first plot


# Different variables
plot(protein_scaled[,"Cereals"], protein_scaled[,"Fr.Veg"], xlim=c(-2,2.75), 
     type="n", xlab="Cereals", ylab="Fr.Veg")
text(protein_scaled[,"Cereals"], protein_scaled[,"Fr.Veg"], labels=rownames(protein), 
     col=rainbow(7)[cluster_all$cluster]) ## col is all that differs from first plot
