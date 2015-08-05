countdata = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
memberdata = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# Normalize phrase counts to phrase frequencies
Z = countdata/rowSums(countdata)

# PCA
pc2 = prcomp(Z, scale=TRUE)
loadings = pc2$rotation
scores = pc2$x

qplot(scores[,1], scores[,2], color=memberdata$party, xlab='Component 1', ylab='Component 2')

# The top words associated with each component
o1 = order(loadings[,1])
colnames(Z)[head(o1,25)]
colnames(Z)[tail(o1,25)]

o2 = order(loadings[,2])
colnames(Z)[head(o2,25)]
colnames(Z)[tail(o2,25)]

