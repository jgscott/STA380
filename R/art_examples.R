library(tm) 
library(magrittr)

		
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


file_list = dir('../data/nyt_corpus/art/', full.names=TRUE)

out1 = readNYT(file_list[1])
content(out1)

out2 = lapply(file_list, readNYT)
file_list

NYT_docs = Corpus(VectorSource(out2))

NYT_docs = tm_map(NYT_docs, content_transformer(tolower))
NYT_docs = tm_map(NYT_docs, content_transformer(removeNumbers))
NYT_docs = tm_map(NYT_docs, content_transformer(removePunctuation))
NYT_docs = tm_map(NYT_docs, content_transformer(stripWhitespace))
NYT_docs = tm_map(NYT_docs, content_transformer(removeWords), stopwords("en"))

DTM_NYT = DocumentTermMatrix(NYT_docs)
DTM_NYT # some basic summary statistics

## Work with the corpus
findFreqTerms(DTM_NYT, 20)
