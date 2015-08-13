# Association rule mining
# Adapted from code by Matt Taddy
library(arules)  # has a big ecosystem of packages built around it

# Read in playlists from users
playlists <- read.csv("../data/playlists.csv")
playlists$user <- factor(playlists$user)

# First create a list of baskets: vectors of items by consumer
# Analagous to bags of words

# First split data into a list of artists for each user
playlists <- split(x=playlists$artist, f=playlists$user)

## Remove duplicates ("de-dupe")
playlists <- lapply(playlists, unique)

## Cast this variable as a special arules "transactions" class.
playtrans <- as(playlists, "transactions")

# Now run the 'apriori' algorithm
# Look at rules with support > .01 & confidence >.5 & length (# artists) <= 4
musicrules <- apriori(playtrans, 
	parameter=list(support=.01, confidence=.5, maxlen=4))
                         
# Look at the output
inspect(musicrules)

## Choose a subset
inspect(subset(musicrules, subset=lift > 5))
inspect(subset(musicrules, subset=confidence > 0.6))
inspect(subset(musicrules, subset=support > .02 & confidence > 0.6))


