library(tm) 
library(magrittr)

# A wrapper around a tm reader function
# Read in an XML news story and extract its full text
# Assumes, but does not test, that the XML is formated the same way as the
# New York Times Annotated Corpus
# Input: filename
# Calls: XML package (available from CRAN)
#        strip.text()
# Output: vector of character strings, giving the words in order
readNYT = function(filename) {
  require(XML)
  doc = xmlRoot(xmlTreeParse(filename))
  # ASSUMES: filename specifies a single file
  # ASSUMES: document follows nitf format
  node.set = getNodeSet(doc, path="//block[@class='full_text']")
  # Find the parts of the file which say they contain the full text of the
  # news story; there should be only one
  fulltext = sapply(node.set, xmlValue) # get the text
  
  readPlain(elem=list(content=fulltext), 
							id= filename, language='en')
}

# two lists of files
files_art = dir('../data/nyt_corpus/art', full.names=TRUE)
files_music = dir('../data/nyt_corpus/music', full.names=TRUE)

example_doc = readNYT(files_art[1])
content(example_doc)

# let's create a list of all files, together with a vector of class labels
files_all = c(files_art, files_music)
class_labels = c(rep('art', length(files_art)), rep('music', length(files_art)))

# split into training and testing sets
N = length(files_all)
train_set = sort(sample.int(N, floor(0.8*N)))
test_set = setdiff(1:N, train_set)
y_train = class_labels[train_set]
y_test = class_labels[test_set]

# List of training documents
docs_train = lapply(files_all[train_set], readNYT)
docs_train

# Create the training corpus, tokenize, preprocess, etc
corpus_train = Corpus(VectorSource(docs_train))
corpus_train = tm_map(corpus_train, content_transformer(tolower))
corpus_train = tm_map(corpus_train, content_transformer(removeNumbers))
corpus_train = tm_map(corpus_train, content_transformer(removePunctuation))
corpus_train = tm_map(corpus_train, content_transformer(stripWhitespace))
corpus_train = tm_map(corpus_train, content_transformer(removeWords), stopwords("en"))

DTM_train = DocumentTermMatrix(corpus_train)
DTM_train # some basic summary statistics

## Work with the corpus
findFreqTerms(DTM_train, 20)


# List of testing documents
docs_test = lapply(files_all[test_set], readNYT)
docs_test

# Create the testing corpus, tokenize, preprocess, etc
corpus_test = Corpus(VectorSource(docs_test))
corpus_test = tm_map(corpus_test, content_transformer(tolower))
corpus_test = tm_map(corpus_test, content_transformer(removeNumbers))
corpus_test = tm_map(corpus_test, content_transformer(removePunctuation))
corpus_test = tm_map(corpus_test, content_transformer(stripWhitespace))
corpus_test = tm_map(corpus_test, content_transformer(removeWords), stopwords("en"))

# DTM for testing corpus
DTM_test = DocumentTermMatrix(corpus_test)
DTM_test

# uh-oh...
Terms(DTM_train)
Terms(DTM_test)
summary(Terms(DTM_test) %in% Terms(DTM_train))

# A suboptimal but practical solution: ignore words you haven't seen before
# can do this by pre-specifying a dictionary in the construction of a DTM
DTM_test2 = DocumentTermMatrix(corpus_test,
                               control = list(dictionary=Terms(DTM_train)))
DTM_train
DTM_test2

summary(Terms(DTM_test2) %in% Terms(DTM_train))

