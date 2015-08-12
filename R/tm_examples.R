## The tm library and related plugins comprise R's most popular text-mining stack.
## See http://cran.r-project.org/web/packages/tm/vignettes/tm.pdf
library(tm) 

## tm has many "reader" functions.  Each one has
## arguments elem, language, id (see ?readPlain,?readPDF,etc)
## This wraps another function around readPlan to read
## plain text documents in English.
readerPlain = function(fname){
				readPlain(elem=list(content=readLines(fname)), 
							id=fname, language='en') }
							
## Test it on Adam Smith
adam = readerPlain("../data/division_of_labor.txt")
adam # this is the tm 'PlainTextDocument'
content(adam)



## apply to all of Simon Cowell's articles
## (probably not THE Simon Cowell: https://twitter.com/simoncowell)
file_list = Sys.glob('../data/ReutersC50/C50train/SimonCowell/*.txt')
simon = lapply(file_list, readerPlain) 

# Some more concise document names via basic string manipulation
names(simon) = file_list
names(simon) = substring(names(simon),first=41)
names(simon) = sub('.txt', '', names(simon))




## once you have documents in a vector, you 
## create a text mining 'corpus' with: 
my_documents = Corpus(VectorSource(simon))
names(my_documents) = names(simon) # come on, tm! this should just happen.


## Some pre-processing/tokenization steps.
## tm_map just maps some function to every document in the corpus
my_documents = tm_map(my_documents, content_transformer(tolower)) # make everything lowercase
my_documents = tm_map(my_documents, content_transformer(removeNumbers)) # remove numbers
my_documents = tm_map(my_documents, content_transformer(removePunctuation)) # remove punctuation
my_documents = tm_map(my_documents, content_transformer(stripWhitespace)) ## remove excess white-space

## Remove stopwords.  Always be careful with this: one man's trash is another one's treasure.
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
findAssocs(DTM_simon, "market", .5) 

## Finally, drop those terms that only occur in one or two documents
## This is a common step: the noise of the "long tail" (rare terms)
##	can be huge, and there is nothing to learn if a term occured once.
## Below removes those terms that have count 0 in >95% of docs.  
## Probably a bit stringent here... but only 50 docs!
DTM_simon = removeSparseTerms(DTM_simon, 0.95)
DTM_simon # now ~ 1000 terms (versus ~3000 before)

# Now PCA on term frequencies
X = as.matrix(DTM_simon)
X = X/rowSums(X)  # term-frequency weighting

pca_simon = prcomp(X, scale=TRUE)
plot(pca_simon) 

# Look at the loadings
pca_simon$rotation[order(abs(pca_simon$rotation[,1]),decreasing=TRUE),1][1:25]
pca_simon$rotation[order(abs(pca_simon$rotation[,2]),decreasing=TRUE),2][1:25]


## Plot the first two PCs..
plot(pca_simon$x[,1:2], col='grey', pch=19, xlab="PCA 1 direction", ylab="PCA 2 direction", bty="n")
identify(pca_simon$x[,1:2], n=4)

# Both about "Scottish Amicable"
simon[[46]]
simon[[48]]

simon[[25]]
simon[[26]]

