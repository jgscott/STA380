library(maptpx)
library(wordcloud)

countdata = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
memberdata = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# Now a topic model
tm1 = topics(countdata, 10)
summary(tm1)

plot(tm1)


wordcloud(colnames(countdata), tm1$theta[,1], min.freq=0, max.words=100)
wordcloud(colnames(countdata), tm1$theta[,2], min.freq=0, max.words=100)
wordcloud(colnames(countdata), tm1$theta[,3], min.freq=0, max.words=100)

# Selecting K
tm_select = topics(countdata, K=c(5:15))
summary(tm_select)
