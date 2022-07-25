## The tm library and related plugins comprise R's most popular text-mining stack.
## See http://cran.r-project.org/web/packages/tm/vignettes/tm.pdf
library(tm) 
library(tidyverse)
library(slam)
library(proxy)

## tm has many "reader" functions.  Each one has
## arguments elem, language, id
## (see ?readPlain, ?readPDF, ?readXML, etc)
## This wraps another function around readPlain to read
## plain text documents in English.
# I've stored this function as a Github "gist" at:
# https://gist.github.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff
readerPlain = function(fname){
				readPlain(elem=list(content=readLines(fname)), 
							id=fname, language='en') }
							
## Test it on Adam Smith
adam = readerPlain("../data/division_of_labor.txt")
adam
meta(adam)
content(adam)

## apply to all of Simon Cowell's articles
## (probably not THE Simon Cowell)
## "globbing" = expanding wild cards in filename paths
file_list = Sys.glob('../data/ReutersC50/C50train/SimonCowell/*.txt')
simon = lapply(file_list, readerPlain) 

# The file names are ugly...
file_list

# Clean up the file names
mynames = file_list %>%
	{ strsplit(., '/', fixed=TRUE) } %>%
	{ lapply(., tail, n=2) } %>%
	{ lapply(., paste0, collapse = '') } %>%
	unlist
	
# Rename the articles
mynames
names(simon) = mynames

## once you have documents in a vector, you 
## create a text mining 'corpus' with: 
documents_raw = Corpus(VectorSource(simon))

## Some pre-processing/tokenization steps.
## tm_map just maps some function to every document in the corpus
my_documents = documents_raw
my_documents = tm_map(my_documents, content_transformer(tolower)) # make everything lowercase
my_documents = tm_map(my_documents, content_transformer(removeNumbers)) # remove numbers
my_documents = tm_map(my_documents, content_transformer(removePunctuation)) # remove punctuation
my_documents = tm_map(my_documents, content_transformer(stripWhitespace)) ## remove excess white-space

## Remove stopwords.  Always be careful with this!
stopwords("en")
stopwords("SMART")
?stopwords
my_documents = tm_map(my_documents, content_transformer(removeWords), stopwords("en"))


## create a doc-term-matrix
DTM_simon = DocumentTermMatrix(my_documents)
DTM_simon # some basic summary statistics

class(DTM_simon)  # a special kind of sparse matrix format

## You can inspect its entries...
inspect(DTM_simon[1:10,1:20])

## ...find words with greater than a min count...
findFreqTerms(DTM_simon, 50)

## ...or find words whose count correlates with a specified word.
findAssocs(DTM_simon, "genetic", .5) 

## Drop those terms that only occur in one or two documents
## This is a common step: the noise of the "long tail" (rare terms)
##	can be huge, and there is nothing to learn if a term occurred once.
## Below removes those terms that have count 0 in >95% of docs.  
## Probably a bit extreme in most cases... but here only 50 docs!
DTM_simon = removeSparseTerms(DTM_simon, 0.95)
DTM_simon # now ~ 1000 terms (versus ~3000 before)

# construct TF IDF weights
tfidf_simon = weightTfIdf(DTM_simon)

####
# Compare documents
####
inspect(tfidf_simon[1,])

# could go back to the raw corpus
content(simon[[1]])


####
# Dimensionality reduction
####

# Now PCA on term frequencies
X = as.matrix(tfidf_simon)
summary(colSums(X))
scrub_cols = which(colSums(X) == 0)
X = X[,-scrub_cols]

pca_simon = prcomp(X, rank=2, scale=TRUE)
plot(pca_simon) 

# Look at the loadings
pca_simon$rotation[order(abs(pca_simon$rotation[,1]),decreasing=TRUE),1][1:25]
pca_simon$rotation[order(abs(pca_simon$rotation[,2]),decreasing=TRUE),2][1:25]


## Look at the first two PCs..
# We've now turned each document into a single pair of numbers -- massive dimensionality reduction
pca_simon$x[,1:2]

plot(pca_simon$x[,1:2], xlab="PCA 1 direction", ylab="PCA 2 direction", bty="n",
     type='n')
text(pca_simon$x[,1:2], labels = 1:length(simon), cex=0.7)

# Both about "Scottish Amicable"
content(simon[[46]])
content(simon[[48]])

# Both about genetic testing
content(simon[[25]])
content(simon[[26]])

# Both about Ladbroke's merger
content(simon[[10]])
content(simon[[11]])

# Conclusion: even just these two-number summaries still preserve a lot of information


#####
# Cluster documents
#####

# define the distance matrix
# using the PCA scores
dist_mat = dist(pca_simon$x)
tree_simon = hclust(dist_mat)
plot(tree_simon)
clust5 = cutree(tree_simon, k=5)

# inspect the clusters
which(clust5 == 3)
content(simon[[18]])
content(simon[[19]])
