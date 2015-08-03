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



######
## Will revisit for PCA
######

pcprotein <- prcomp(protein, scale=TRUE)

# Project on the PC axes
zprotein <- predict(pcprotein) 
z <- scale(protein)%*%pcprotein$rotation
all(z==zprotein)

## implies rotations are on scale of standard deviations if scale=TRUE
## looks like PC1 is an 'average diet', PC2 is iberian
t( round(pcprotein$rotation[,1:2],2) )

## do some k-means, for comparison
cluster_all <- kmeans(scale(protein), centers=7, nstart=20)

## how do the PCs look?
par(mfrow=c(1,2))
plot(zprotein[,1:2], type="n", xlim=c(-4,5))
text(x=zprotein[,1], y=zprotein[,2], labels=rownames(protein), col=rainbow(7)[cluster_all$cluster])
plot(zprotein[,3:4], type="n", xlim=c(-3,3))
text(x=zprotein[,3], y=zprotein[,4], labels=rownames(protein), col=rainbow(7)[cluster_all$cluster])

## how many do we need? tough to tell
plot(pcprotein, main="")
mtext(side=1, "European Protein Principle Components",  line=1, font=2)

## summary puts these scree plots on a more intuitive scale: 
	## proportion of variation explained.
summary(pcprotein)
