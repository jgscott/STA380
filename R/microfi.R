## microfinance network 
## data from BANERJEE, CHANDRASEKHAR, DUFLO, JACKSON 2012
## https://web.stanford.edu/~jacksonm/Banerjee-Chandrasekhar-Duflo-Jackson-DiffusionOfMicrofinance-Science-2013.pdf
library(igraph)
library(tidyverse)

## data on 8622 households
hh = read.csv("../data/microfi_households.csv", row.names="hh")

# each row is a household
head(hh, 10)

# Let's make sure village is coded as a factor here
hh$village = factor(hh$village)


## household networks: based on survey data about household interactions
## commerce/friend/family/etc
edges = read.table("../data/microfi_edges.txt", colClasses="character")

# each row is a connection between households
# the first row is a connection between households 2 and 1 in village 1
# and so on
head(edges, 10)


# pass into igraph for plotting, etc
hhnet = graph.edgelist(as.matrix(edges), directed=FALSE)

V(hhnet) ## our 8000+ household vertices

## Each vertex (node) has some attributes, and we can add more fron the hh data
# Here we'll associate a "village" attribution with each vertex
V(hhnet)$village = as.character(hh[V(hhnet),'village'])

## we'll color vertices by village membership
vilcol = rainbow(nlevels(hh$village))
names(vilcol) = levels(hh$village)
V(hhnet)$color = vilcol[V(hhnet)$village]

## drop HH labels from plot
V(hhnet)$label=NA

# plots of large graphs can take awhile
# I've found edge.curved=FALSE speeds plots up a lot.  Not sure why.

## we'll use induced.subgraph to select subsets of nodes and plot a couple villages 
village1 = induced.subgraph(hhnet, v=which(V(hhnet)$village=="1"))
village33 = induced.subgraph(hhnet, v=which(V(hhnet)$village=="33"))

# vertex.size=3 is small.  default is 15
plot(village1, vertex.size=3, edge.curved=FALSE)
plot(village33, vertex.size=3, edge.curved=FALSE)


# Key scientific question: does centrality in the network
# predict receiving a microfinance loan?

## First have to match id's between the two data frames!
# I call these 'zebras' here because they are like
# "crosswalks" between the two data frames
# Each row in zebra corresponds to the same entry in hh.
# the entry tells us where to look in the graph to find that household.
zebra = match(rownames(hh), V(hhnet)$name)
head(zebra, 10)

## Let's use degree as a measure of connectedness
## calculate the degree of each household: 
##  (number of commerce/friend/family connections)
## and order these degrees by the same order in hh dataframe
degree = degree(hhnet)[zebra]
names(degree) = rownames(hh)
degree[is.na(degree)] = 0 # unconnected houses, not in our graph

# Now let's scale degree so that degree_z is
# std devs above/below average connectivity
degree_z = scale(degree)

# now use regression to isolate the effect of "degree"
# main effects only
full = glm(loan ~ degree_z + ., data=hh, family="binomial")
summary(full)

# Note the odds ratio for degree_z is about 1.1
exp(coef(full)) %>% head

# Interpretation: a one-standard deviation change in connectedness increases
# odds of applying for a loan by 10%, holding other vars constant.

# all coefficients -- notice a lot of heterogeneity across villages.
# remember all these village coefficients are measured as odds ratios relative to
# the baseline case of village = 1
exp(coef(full))

## note: if you run a full glm with interactions between the variables,
## it takes forever and is an overfit mess.
## what we've done here is attempt to identify a "causal" effect of connectedness
## by including potential confounders in a regression model.  This is pretty simple!
## No doubt there better ways to do causal inference here.
