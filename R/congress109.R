library(ggplot2)

countdata = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
memberdata = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# First normalize phrase counts to phrase frequencies.
# (often a sensible first step for count data, before z-scoring)
Z = countdata/rowSums(countdata)

# PCA
pc2 = prcomp(Z, scale=TRUE)
loadings = pc2$rotation
scores = pc2$x

# Question 1: where do the observations land in PC space?
# a biplot shows the first two PCs
qplot(scores[,1], scores[,2], color=memberdata$party, xlab='Component 1', ylab='Component 2')

# Question 2: how are the individual PCs loaded on the original variables?
# The top words associated with each component
o1 = order(loadings[,1], decreasing=TRUE)
colnames(Z)[head(o1,25)]
colnames(Z)[tail(o1,25)]

o2 = order(loadings[,2], decreasing=TRUE)
colnames(Z)[head(o2,25)]
colnames(Z)[tail(o2,25)]

