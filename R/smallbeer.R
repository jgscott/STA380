library(Matrix)
library(slam)
library(gamlr)

## small beer dataset
beer = read.csv("../data/smallbeer.csv", 
	colClasses=c(rep("factor",3),rep("numeric",2)))

# we have an item code, a natural language description, a week,
# and the price/quantity sold in that week for each item
head(beer)
nrow(beer)

##
# Let's try to estimate a price elasticity of demand (PED) for beer.
# the elasticity is % change in quantity demanded for 1% change in price.
# we estimate it by running a regression for log(units) vs. log(price)...
# but we need to adjust for changing pricing strategies over time.
# e.g. prices and demand for beer might go up together because of exogenous
# shocks, e.g. Super Bowl week, July 4, etc.  So we need to adjust for 
# that as a potential confounder.
##

##
# First, a very naive model
##

# no pooling: independent elasticities for each beer
oneforall = lm(log(units) ~ log(price)*item, data=beer)

# tons of NAs, lots of noisy coefficients
coef(oneforall)
hist(coef(oneforall)) ## super noisy zeros

# getting the elasticities?
# add the main effect to each interaction term.
price_main = coef(oneforall)[2]
which_int = grep("log(price):item", names(coef(oneforall)), fixed=TRUE)
price_int = coef(oneforall)[which_int]

# a histogram of the item-level elasticities
hist(price_main + price_int)

## Clearly this won't work:
# 1) the elasticities are super noisy
# 2) some are even positive!  economically infeasible
# this is an extreme example of having WAY too much variance
# in the bias-variance tradeoff.  Just not enough data to estimate an
# independent elasticity for each beer.

##
# Let's be slightly less naive.
# build some regression designs and run a sparse regression
##
library(gamlr)

# This regression design adjusts for week by 
# including dummy variables for each week.
# designed to soak up some of the variation in sales due to
# seasonal changes in beer demand
x1 = sparse.model.matrix(~log(price)*item + factor(week)-1, data=beer)
head(x1)

# run a lasso penalized least squares model,
# but leave the log(price) coefficient unpenalized (free=1)
# I'm not standardizing here because I have dummy variables, as well as a var (price)
# whose coefficient I want to interpret on the original scale.
ml1 = cv.gamlr(x=x1, y=log(beer$units), free = 1, standardize=FALSE, verb=TRUE)

# notice lots of sparsity here -- the interpretation of sparse entry
# is that there's not enough data to estimate a separate interaction term for that item...
# and so the model defaults/shrinks to a "global" elasticity for that item.
coef(ml1)

# how can I get the elasticities?
price_main = coef(ml1)[2]
which_int = grep("log(price):item", rownames(coef(ml1)), fixed=TRUE)
price_int = coef(ml1)[which_int]

# these look much more reasonable, though not all negative.
# and the elephant in the room: of course price is not exogenous here!
# price is changing over time and in response to features that also predict demand.
hist(price_main + price_int)


####
# Lets orthogonalize instead.
# strategy: isolate "idiosyncratic" variation in price and quantity sold
# by first explicitly adjusting for item and week in both y and z (treatment)
####

# orthogonalization steps 1-2
xitem = sparse.model.matrix(~item-1, lmr=1e-5, data=beer)
xweek = sparse.model.matrix(~week-1, lmr=1e-5, data=beer)
xx = cbind(xweek, xitem)

# isolate variation in log(price) predicted by item and week
# interpretation: this model tells us what variation in pricing strategies
# seems to be predictable across items and weeks.
# The leftover, residual variation might plausibly be interpreted
# as "pseudo-experimental" variation -- i.e. random shocks to price.
# we'll use these random shocks to identify an elasticity.
pfit = gamlr(x=xx, y=log(beer$price), lmr=1e-5, standardize=FALSE)

# and now we isolate variation in quantity sold predicted by item and week.
# the residuals from this model are our "independent signal", i.e. variation in 
# sales that might be driven _uniquely_ by price.
qfit = gamlr(x=xx, y=log(beer$units), lmr=1e-5, standardize=FALSE)

# Calculate residuals: variation in price and units sold that
# cannot be predicted by item and week
lpr = drop(log(beer$price) - predict(pfit, xx))
lqr = drop(log(beer$units) - predict(qfit, xx))


# Run 3rd ML step to get elasticities

# Now here's where text-mining comes in!
# Let's parse the item description text 
# so that each individual word in the description becomes a predictor.
# so, e.g "IPA" changes the elasticity, "Lite" changes the elasticity, etc.
# and we can estimate these common effects by pooling information across all beers.

# let's create a doc-term matrix from the item descriptions
library(tm)
descr = Corpus(VectorSource(as.character(beer$description)))
xtext = DocumentTermMatrix(descr)

# convert to Matrix format
xtext = sparseMatrix(i=xtext$i,j=xtext$j, x=as.numeric(xtext$v>0),
	dims=dim(xtext), dimnames=dimnames(xtext))
colnames(xtext)

# fit a model including interactions between text features and log price residuals
xtreat = cbind(1,xtext)
ofit = gamlr(x=lpr*xtreat, y=lqr, standardize=FALSE, free=1)


# gams represents the changes in elasticity associated with each term
# remember: elasticity is a negative number!
# so positive changes to elasticity mean that consumers are less price sensitive.
# negative changes to elasticity mean that consumers are more price sensitive.
gams = coef(ofit)[-1,]

# these terms are associated with higher price sensitivity
gams %>% sort %>% head(10)

# these terms are associated with lower price sensitivty
gams %>% sort %>% tail(10)


# create a query matrix, matching each level to a row in X
test_ind = match(levels(beer$item),beer$item)
xtest = xtext[test_ind,]
rownames(xtest) = beer$description[test_ind]

# translate into elasticities and plot
# these look very reasonable! most between -1 and -4.
# no/few spuriously positive estimates.
el = drop(gams[1] + xtest%*%gams[(1:ncol(xtext))+1])
hist(el, xlab="OML elasticities", xlim=c(-6,1), col="lightblue", main="", breaks=seq(-11, 1, by=0.2))

# high price-sensitivity items
# notice lots of IPA 6packs have the same elasticity
# models estimates that customers have similar price
# sensitivities to this whole group.
# this is a result of having pooled information at the level
# of natural language terms like IPA and 6PK,
# rather than trying to estimate separate elasticities for each item
sort(el) %>% head(20)  # some major brands, and some "faux craft" beers made by big names

# low price-sensitivity items
sort(el) %>% tail(20)  # a lot of ciders and large-format (e.g. 24 pack) beers

# conclusion: you can probably overcharge for cider.
# but IPA customers will buy a different IPA if you overprice yours!
