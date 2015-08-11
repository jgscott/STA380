# Functions for document retrieval and simple similarity searching
# Adapted from code written by Tom Minka and Cosma Shalizi

# Read in an XML news story and extract its full text
# Assumes, but does not test, that the XML is formated the same way as the
# New York Times Annotated Corpus
# Input: filename
# Calls: XML package (available from CRAN)
#        strip.text()
# Output: vector of character strings, giving the words in order
read.doc <- function(filename) {
  require(XML)
  doc <- xmlRoot(xmlTreeParse(filename))
  # ASSUMES: filename specifies a single file
  # ASSUMES: document follows nitf format
  node.set <- getNodeSet(doc,path="//block[@class='full_text']")
  # Find the parts of the file which say they contain the full text of the
  # news story; there should be only one
  fulltext <- sapply(node.set,xmlValue) # get the text
  # ASSUMES: this should be a SINGLE character string
  text <- strip.text(fulltext) # Turn into a vector of strings
  return(text)
}

# Feel free to use this IF you comment it
read.directory <- function(dirname,verbose=FALSE) {
  stories = list()
  filenames = dir(dirname,full.names=TRUE)
  for (i in 1:length(filenames)) {
    if(verbose) {
      print(filenames[i])
    }
    stories[[i]] = read.doc(filenames[i])
  }
  return(stories)
}


# Turn a string into a vector of words
# for comparability across bags of words, also strip out punctuation and
# numbers, and shift all letters into lower case
# Input: character string
# Output: vector of words (character strings)
strip.text <- function(txt) {
  # remove apostrophes (so "don't" -> "dont", "Jane's" -> "Janes", etc.)
  txt <- gsub("'","",txt)
  # convert to lowercase
  txt <- tolower(txt)
  # change other non-alphanumeric characters to spaces
  txt <- gsub("[^a-z0-9]"," ",txt)
  # change digits to #
  txt <- gsub("[0-9]+","#",txt)
  # split and make one vector
  txt <- unlist(strsplit(txt," "))
  # remove empty words
  txt <- txt[txt != ""]
  return(txt)
}

LoW_to_countvector = function(LoW) {
	y = list()
	for(i in seq_along(LoW)) {
		mytab = xtabs(~ LoW[[i]])
		vals = as.numeric(mytab)
		words = names(mytab)
		names(vals) = words
		y[[i]] = vals
	}
	y
}


# Rescale the columns of a data frame or array by a given weight vector
# Input: arrray, weight vector
# Output: scaled array
scale.cols <- function(x,s) {
  return(t(apply(x,1,function(x){x*s})))
}

# Rescale rows of an array or data frame by a given weight vector
# Input: array, weight vector
# Output: scaled array
scale.rows <- function(x,s) {
  return(apply(x,2,function(x){x*s}))
}

# Compute inverse document frequency weights and rescale a data frame
# Input: data frame
# Calls: scale.cols
# Output: scaled data-frame
idf.weight <- function(x) {
  # IDF weighting
  doc.freq <- colSums(x>0)
  doc.freq[doc.freq == 0] <- 1
  w <- log(nrow(x)/doc.freq)
  return(scale.cols(x,w))
}

# Normalize vectors by the sum of their entries
# Input assumed to be a set of vectors in array form, one vector per row
# Input: matrix/data frame/array
# Calls: scale.rows()
# Output: matrix/data frame/array
div.by.sum <- function(x) {
  scale.rows(x,1/(rowSums(x)+1e-16))
}

# Normalize vectors by their Euclidean length
# Input assumed to be a set of vectors in array form, one vector per row
# Input: array
# Calls: scale.rows()
# Output: array
div.by.euc.length <- function(x) {
  scale.rows(x,1/sqrt(rowSums(x^2)+1e-16))
}


# Remove columns from a ragged array which only appear in one row
# Input: Ragged array (vectors with named columns)
# Output: Ragged array, with columns appearing in only one vector deleted
remove.singletons.ragged <- function(x) {
  # Collect all the column names, WITH repetition
  col.names <- c()
  for(i in 1:length(x)) {
    col.names <- c(col.names, names(x[[i]]))
  }
  # See how often each name appears
  count <- table(col.names)
  # Loop over vectors and keep only the columns which show up more than once
  for(i in 1:length(x)) {
    not.single <- (count[names(x[[i]])] > 1)
    x[[i]] <- x[[i]][not.single]
  }
  return(x)
}


# Standardize a ragged array so all vectors have the same length and ordering
# Supplies NAs for missing values
# Input: a list of vectors with named columns
# Output: a standardized list of vectors with named columns
standardize.ragged <- function(x) {
  # Keep track of all the column names from all the vectors in a single vector
  col.names <- c()
  # Get the union of column names by iterating over the vectors - using
  # setdiff() is faster than taking unique of the concatenation, the more
  # obvious approach
  for(i in 1:length(x)) {
    col.names <- c(col.names, setdiff(names(x[[i]]),col.names))
  }
  # put the column names in alphabetical order, for greater comprehensibility
  col.names <- sort(col.names)
  # Now loop over the vectors again, putting them in order and filling them out
  # Note: x[[y]] returns NA if y is not the name of a column in x
  for (i in 1:length(x)) {
    x[[i]] <- x[[i]][col.names]
    # Make sure the names are right
    names(x[[i]]) <- col.names
  }
  return(x)
}

# Turn a list of bag-of-words vectors into a data frame, one row per bag
# Input: list of BoW vectors (x),
#   list of row names (row.names, optional),
#   flag for whether singletons should be removed,
#   flag for whether words missing in a document should be coded 0
# Output: data frame, columns named by the words and rows matching documents
make.BoW.frame <- function(x,row.names,remove.singletons=TRUE,
                           absent.is.zero=TRUE) {
  # Should we remove one-time-only words?
  if (remove.singletons) {
    y <- remove.singletons.ragged(x)
  } else {
    y <- x
  }
  # Standardize the column names
  y <- standardize.ragged(y)
  # Transform the list into an array
  # There are probably slicker ways to do this
  z = y[[1]] # Start with the first row
  if (length(y) > 1) { # More than one row?
    for (i in 2:length(y)) {
      z = rbind(z,y[[i]],deparse.level=0) # then stack them
    }
  }
  # Make the data frame
  # use row names if provided
  if(missing(row.names)) {
    BoW.frame <- data.frame(z)
  } else {
    BoW.frame <- data.frame(z,row.names=row.names)
  }
  if (absent.is.zero) {
    # The standardize.ragged function maps missing words to "NA"; replace
    # those with zeroes to simplify calculation
    BoW.frame <- apply(BoW.frame,2,function(q){ifelse(is.na(q),0,q)})
  }
  colnames(BoW.frame) = attr(x[[1]], 'names')
  return(BoW.frame)
}

# Produce a distance matrix from a data frame
# Assumes rows in the data frame (or other array) are vectors
# By default uses Euclidean distance but could use other functions as well
# cf. the built-in function dist()
# Input: array, optional distance function
# Calls: sq.Euc.dist()
# Output: matrix of distances
distances <- function(x,fun) {
  # Use Euclidean distance by default
  if (missing(fun)) {
    return(sqrt(sq.Euc.dist(x)))
  }
  # otherwise, run the function fun over all combinations of rows
  else {
    # make a new array
    n <- nrow(x)
    d <- array(NA,c(n,n),list(rownames(x),rownames(x))) #preserve row-names,
    # but also make them column names
    # iterate over row-pair combinations
    for(i in 1:n) {
      for(j in 1:n) {
        # fill the entries of the array
        d[i,j] <- fun(x[i,],x[j,])
      }
    }
    # we're done
    return(d)
  }
}

# calculate the squared Euclidean distances between two sets of vectors
# specifically, d[i,j] is the squared distance from x[i,] to y[j,]
# Input: vectors in matrix form (one per row),
#        second set of vectors ditto (if missing assumed equal to first)
# Output: matrix of distances
sq.Euc.dist <- function(x,y=x) {
  x <- as.matrix(x)
  y <- as.matrix(y)
  nr=nrow(x)
  nc=nrow(y)
  x2 <- rowSums(x^2)
  xsq = matrix(x2,nrow=nr,ncol=nc)
  y2 <- rowSums(y^2)
  ysq = matrix(y2,nrow=nr,ncol=nc,byrow=TRUE)
  xy = x %*% t(y)
  d = xsq + ysq - 2*xy
  if(identical(x,y)) diag(d) = 0
  d[which(d < 0)] = 0
  return(d)
}

# For each vector (row) in matrix A, return the index of and the distance to
# the index of the closest point to the matrix B
# If the matrix B is omitted, then it's assumed to be A, but no point is
# allowed to be its own own closest match
# A pre-computed distance matrix is an optional argument, otherwise it's
# computed in the squared Euclidean metric
# Input: matrix A, matrix B (optional),
# matrix of distances between them (optional)
# Output: list of vectors, one giving the
# indices, the other giving the distances
nearest.points <- function(a,b=a,d=sqrt(sq.Euc.dist(a,b))) {
  # "allocate" a vector, giving the distances to the best matches
  b.dist = numeric(nrow(a))
  
  if (identical(a,b)) {
    diag(d) = Inf
  }
  b.which = apply(d,1,which.min)
  for (i in 1:nrow(a)) {
    b.dist[i] = d[i,b.which[i]]
  }
  return(list(which=b.which,dist=b.dist))
}