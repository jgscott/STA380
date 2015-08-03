# Old-school european protein consumption,
# in grams/person-day from various sources
protein <- read.csv("../data/protein.csv", row.names=1)
head(protein)

# Center/scale the data
protein_scaled <- scale(protein, center=TRUE, scale=TRUE) 

## first, consider just Red and White meat clusters
cluster_redwhite <- kmeans(protein_scaled[,c("WhiteMeat","RedMeat")], centers=3)


# Plot with labels
# type = 'n' just sets up the axes
plot(protein_scaled[,"RedMeat"], protein_scaled[,"WhiteMeat"], xlim=c(-2,2.75), 
    type="n", xlab="Red Meat", ylab="White Meat")  
text(protein_scaled[,"RedMeat"], protein_scaled[,"WhiteMeat"], labels=rownames(protein), 
    col=rainbow(3)[cluster_redwhite$cluster])

## same plot, but now with clustering on all protein groups
## change the number of centers to see what happens.
cluster_all <- kmeans(protein_scaled, centers=7, nstart=50)
names(cluster_all)

cluster_all$centers
cluster_all$cluster

plot(protein_scaled[,"RedMeat"], protein_scaled[,"WhiteMeat"], xlim=c(-2,2.75), 
    type="n", xlab="Red Meat", ylab="White Meat")
text(protein_scaled[,"RedMeat"], protein_scaled[,"WhiteMeat"], labels=rownames(protein), 
    col=rainbow(7)[cluster_all$cluster]) ## col is all that differs from first plot
