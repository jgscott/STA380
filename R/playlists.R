library(tidyverse)
library(arules)  # has a big ecosystem of packages built around it
library(arulesViz)

# Association rule mining
# Adapted from code by Matt Taddy

# Read in playlists from users
# This is in "long" format -- every row is a single artist-listener pair
playlists_raw = read.csv("../data/playlists.csv")

str(playlists_raw)
summary(playlists_raw)

# Barplot of top 20 artists
# Cool use of magrittr pipes in plotting/summary workflow
# the dot (.) means "plug in the argument coming from the left"
playlists_raw$artist %>%
	summary(., maxsum=Inf) %>%
	sort(., decreasing=TRUE) %>%
	head(., 20) %>%
	barplot(., las=2, cex.names=0.6)

# Turn user into a factor
playlists_raw$user = factor(playlists_raw$user)

# First create a list of baskets: vectors of items by consumer
# Analagous to bags of words

# apriori algorithm expects a list of baskets in a special format
# In this case, one "basket" of songs per user
# First split data into a list of artists for each user
playlists = split(x=playlists_raw$artist, f=playlists_raw$user)

## Remove duplicates ("de-dupe")
playlists = lapply(playlists, unique)

## Cast this variable as a special arules "transactions" class.
playtrans = as(playlists, "transactions")
summary(playtrans)

# Now run the 'apriori' algorithm
# Look at rules with support > .005 & confidence >.1 & length (# artists) <= 5
musicrules = apriori(playtrans, 
	parameter=list(support=.005, confidence=.1, maxlen=5))
                         
# Look at the output... so many rules!
inspect(musicrules)

## Choose a subset
inspect(subset(musicrules, subset=lift > 5))
inspect(subset(musicrules, subset=confidence > 0.6))
inspect(subset(musicrules, subset=lift > 10 & confidence > 0.5))

# plot all the rules in (support, confidence) space
# notice that high lift rules tend to have low support
plot(musicrules)

# can swap the axes and color scales
plot(musicrules, measure = c("support", "lift"), shading = "confidence")

# "two key" plot: coloring is by size (order) of item set
plot(musicrules, method='two-key plot')

# can now look at subsets driven by the plot
inspect(subset(musicrules, support > 0.035))
inspect(subset(musicrules, confidence > 0.7))


# graph-based visualization
sub1 = subset(musicrules, subset=confidence > 0.01 & support > 0.005)
summary(sub1)
plot(sub1, method='graph')
?plot.rules

plot(head(sub1, 100, by='lift'), method='graph')

# export
saveAsGraph(head(musicrules, n = 1000, by = "lift"), file = "musicrules.graphml")
