library(XML)

# Some helper functions
source('textutils.R')

# Read in the raw stories
art_stories = read.directory('../data/nyt_corpus/art/')
str(art_stories)

# The last story
tail(art_stories, 1)

# Turn these stories in vectors of counts of words
# also called a "bag of words"
art_stories_vec = LoW_to_countvector(art_stories)

# Pad out each vector to include NA's for words not seen in that story
# but part of the corpus vocabulary
art_stories_vec_std = standardize.ragged(art_stories_vec)
art_stories_vec_std = remove.singletons.ragged(art_stories_vec_std)

# Peek at the first one
art_stories_vec_std[[1]]

# Turn these lists into a document-term matrix
art_stories_DTM = make.BoW.frame(art_stories_vec_std)

# First 10 stories x 100 words
# Think about stemming?
art_stories_DTM[1:10,1:100]

# Construct term-frequency matrix
art_stories_DTM_TF = art_stories_DTM / rowSums(art_stories_DTM)

# TF-IDF weights
art_stories_DTM_TFIDF = idf.weight(art_stories_DTM_TF)

# Construct a hypothetical query vector
D = ncol(art_stories_DTM_TFIDF)
which(colnames(art_stories_DTM_TFIDF) == 'museum')
which(colnames(art_stories_DTM_TFIDF) == 'opening')

query_vec = rep(0, D)
query_vec[c(4937, 5224)] = 1

# Cosine of angle between two vectors:
# Inner product of query vector with all documents, standardized by lengths
my_cosine = function(v1, v2) {
  sum(v1*v2) / {sqrt(sum(v1)^2) * sqrt(sum(v2^2))}
}

my_cosine(query_vec, art_stories_DTM_TFIDF[1,])
my_cosine(query_vec, art_stories_DTM_TFIDF[2,])

# calculate for all documents
query_angles = apply(art_stories_DTM_TFIDF, 1, function(x) my_cosine(x, query_vec))
which.max(query_angles)

art_stories[[16]]


# Now a different vector-space representation: LSI/LSA
lsi_art = prcomp(art_stories_DTM_TFIDF, scale.=FALSE)

head(sort(lsi_art$rotation[,1], decreasing=FALSE), 20)

# Scores on the first two PCs
plot(lsi_art$x[,1:2])
identify(lsi_art$x[,1:2], n=2)

art_stories[[16]]
art_stories[[39]]

# Two nearby stories?
plot(lsi_art$x[,1:2], xlim=c(-0.02, 0.02), ylim=c(-0.01, 0.01))
identify(lsi_art$x[,1:2], n=2)

art_stories[[12]]
art_stories[[17]]


