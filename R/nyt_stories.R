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

# Run PCA on Term-frequency matrix
art_stories_DTM_TF = art_stories_DTM / rowSums(art_stories_DTM)
art_stories_DTM_TFIDF = idf.weight(art_stories_DTM_TF)

lsi_art = prcomp(art_stories_DTM_TFIDF, scale.=FALSE)

sort(lsi_art$rotation[,1], decreasing=FALSE)

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

