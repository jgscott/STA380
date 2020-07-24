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
## (probably not THE Simon Cowell: https://twitter.com/simoncowell)
## "globbing" = expanding wild cards in filename paths
file_list = Sys.glob('../data/ReutersC50/C50train/SimonCowell/*.txt')
simon = lapply(file_list, readerPlain) 

# The file names are ugly...
file_list

# Clean up the file names
# no doubt the stringr library would be nicer here.
# this is just what I hacked together
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
my_documents = documents_raw %>%
  tm_map(content_transformer(tolower))  %>%             # make everything lowercase
  tm_map(content_transformer(removeNumbers)) %>%        # remove numbers
  tm_map(content_transformer(removePunctuation)) %>%    # remove punctuation
  tm_map(content_transformer(stripWhitespace))          # remove excess white-space

## Remove stopwords.  Always be careful with this: one person's trash is another one's treasure.
# 2 example built-in sets of stop words
stopwords("en")
stopwords("SMART")
?stopwords
# let's just use the "basic English" stop words
my_documents = tm_map(my_documents, content_transformer(removeWords), stopwords("en"))


## create a doc-term-matrix from the corpus
DTM_simon = DocumentTermMatrix(my_documents)
DTM_simon # some basic summary statistics

## You can inspect its entries...
inspect(DTM_simon[1:10,1:20])

## ...find words with greater than a min count...
findFreqTerms(DTM_simon, 50)

## ...or find words whose count correlates with a specified word.
# the top entries here look like they go with "genetic"
findAssocs(DTM_simon, "genetic", .5)

## Finally, let's drop those terms that only occur in one or two documents
## This is a common step: the noise of the "long tail" (rare terms)
## can be huge, and there is nothing to learn if a term occured once.
## Below removes those terms that have count 0 in >95% of docs.  
## Probably a bit stringent here... but only 50 docs!
DTM_simon = removeSparseTerms(DTM_simon, 0.95)
DTM_simon # now ~ 1000 terms (versus ~3000 before)

# construct TF IDF weights -- might be useful if we wanted to use these
# as features in a predictive model
tfidf_simon = weightTfIdf(DTM_simon)

####
# Compare /cluster documents
####

# cosine similarity
# first by hand -- this is the formula we saw in the slides
i = 15
j = 16
sum(tfidf_simon[i,] * (tfidf_simon[j,]))/(sqrt(sum(tfidf_simon[i,]^2)) * sqrt(sum(tfidf_simon[j,]^2)))

# the proxy library has a built-in function to calculate cosine distance
# define the cosine distance matrix for our DTM using this function
cosine_dist_mat = proxy::dist(as.matrix(tfidf_simon), method='cosine')
tree_simon = hclust(cosine_dist_mat)
plot(tree_simon)
clust5 = cutree(tree_simon, k=5)

# inspect the clusters
which(clust5 == 3)

# These all look to be about Scottish Amicable
content(simon[[12]])
content(simon[[13]])
content(simon[[21]])



####
# Dimensionality reduction
####

# Now PCA on term frequencies
X = as.matrix(tfidf_simon)
summary(colSums(X))
scrub_cols = which(colSums(X) == 0)
X = X[,-scrub_cols]

pca_simon = prcomp(X, scale=TRUE)

# looks like 15 or so summaries get us ~50% of the variation in over 1000 features
summary(pca_simon) 

# Look at the loadings
pca_simon$rotation[order(abs(pca_simon$rotation[,1]),decreasing=TRUE),1][1:25]
pca_simon$rotation[order(abs(pca_simon$rotation[,2]),decreasing=TRUE),2][1:25]


## Look at the first two PCs..
# We've now turned each document into a single pair of numbers -- massive dimensionality reduction
pca_simon$x[,1:2]

plot(pca_simon$x[,1:2], xlab="PCA 1 direction", ylab="PCA 2 direction", bty="n",
     type='n')
text(pca_simon$x[,1:2], labels = 1:length(simon), cex=0.7)

# 46 and 48 are pretty close
# Both about Scottish Amicable
content(simon[[46]])
content(simon[[48]])

# 25 and 26 are pretty close
# Both about genetic testing
content(simon[[25]])
content(simon[[26]])

# 10 and 11 pretty close
# Both about Ladbroke's merger
content(simon[[10]])
content(simon[[11]])

# Conclusion: even just these two-number summaries still preserve a lot of information
