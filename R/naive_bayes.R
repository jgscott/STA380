library(tm)

# Remember to source in the "reader" wrapper function
# it's stored as a Github gist at:
# https://gist.github.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff

## Rolling two directories together into a single corpus
author_dirs = Sys.glob('../data/ReutersC50/C50train/*')
author_dirs = author_dirs[1:2]
file_list = NULL
labels = NULL
for(author in author_dirs) {
	author_name = substring(author, first=29)
	files_to_add = Sys.glob(paste0(author, '/*.txt'))
	file_list = append(file_list, files_to_add)
	labels = append(labels, rep(author_name, length(files_to_add)))
}

# Need a more clever regex to get better names here
all_docs = lapply(file_list, readerPlain) 
names(all_docs) = file_list
names(all_docs) = sub('.txt', '', names(all_docs))

# create the corpus
my_corpus = Corpus(VectorSource(all_docs))


# Preprocessing
my_corpus = tm_map(my_corpus, content_transformer(tolower)) # make everything lowercase
my_corpus = tm_map(my_corpus, content_transformer(removeNumbers)) # remove numbers
my_corpus = tm_map(my_corpus, content_transformer(removePunctuation)) # remove punctuation
my_corpus = tm_map(my_corpus, content_transformer(stripWhitespace)) ## remove excess white-space
my_corpus = tm_map(my_corpus, content_transformer(removeWords), stopwords("SMART"))

DTM = DocumentTermMatrix(my_corpus)
DTM # some basic summary statistics

class(DTM)  # a special kind of sparse matrix format

## You can inspect its entries...
inspect(DTM[1:10,1:20])
DTM = removeSparseTerms(DTM, 0.975)
DTM

# Now a dense matrix
X = as.matrix(DTM)

# Naive Bayes: the training sets for the two authors
AP_train = X[1:45,]
AC_train = X[51:95,]

# AP's multinomial probability vector
# Notice the smoothing factor
# Why?
smooth_count = 1/nrow(X)
w_AP = colSums(AP_train + smooth_count)
w_AP = w_AP/sum(w_AP)

# AC's multinomial probability vector
w_AC = colSums(AC_train + smooth_count)
w_AC = w_AC/sum(w_AC)

# Let's take a specific test document
x_test = X[49,]
head(sort(x_test, decreasing=TRUE), 25)

# Compare log probabilities under the Naive Bayes model
sum(x_test*log(w_AP))
sum(x_test*log(w_AC))

# Another test document
x_test2 = X[99,]
head(sort(x_test2, decreasing=TRUE), 25)
sum(x_test2*log(w_AP))
sum(x_test2*log(w_AC))

