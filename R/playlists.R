# Association rule mining
# Adapted from code by Matt Taddy
library(arules)  # has a big ecosystem of packages built around it

# Read in playlists from users
playlists_raw <- read.csv("../data/playlists.csv")

str(playlists_raw)
summary(playlists_raw)

# Turn user into a factor
playlists_raw$user <- factor(playlists_raw$user)

# First create a list of baskets: vectors of items by consumer
# Analagous to bags of words

# apriori algorithm expects a list of baskets in a special format
# In this case, one "basket" of songs per user
# First split data into a list of artists for each user
playlists <- split(x=playlists_raw$artist, f=playlists_raw$user)

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


