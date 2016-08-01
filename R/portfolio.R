library(mosaic)
library(fImport)
library(foreach)

# Import a few stocks
mystocks = c("MRK", "JNJ", "SPY")
myprices = yahooSeries(mystocks, from='2012-01-01', to='2016-07-30')
# The first few rows
head(myprices)


# A helper function for calculating percent returns from a Yahoo Series
# Source this to the console first, and then it will be available to use
# (Like importing a library)
YahooPricesToReturns = function(series) {
	mycols = grep('Adj.Close', colnames(series))
	closingprice = series[,mycols]
	N = nrow(closingprice)
	percentreturn = as.data.frame(closingprice[2:N,]) / as.data.frame(closingprice[1:(N-1),]) - 1
	mynames = strsplit(colnames(percentreturn), '.', fixed=TRUE)
	mynames = lapply(mynames, function(x) return(paste0(x[1], ".PctReturn")))
	colnames(percentreturn) = mynames
	as.matrix(na.omit(percentreturn))
}


# Compute the returns from the closing prices
myreturns = YahooPricesToReturns(myprices)

# These returns can be viewed as draws from the joint distribution
pairs(myreturns)
plot(myreturns[,1], type='l')

# Look at the market returns over time
plot(myreturns[,3], type='l')

# An autocorrelation plot: nothing there
acf(myreturns[,3])

# The sample correlation matrix
cor(myreturns)

#######
# A classical way to estimate portfolio variability: use the CAPM
#######

# First fit the market model to each stock
lm_MRK = lm(myreturns[,1] ~ myreturns[,4])
lm_JNJ = lm(myreturns[,2] ~ myreturns[,4])

# The estimated beta for each stock based on daily returns
coef(lm_MRK); coef(lm_JNJ)


# A problem...
# What about the residuals?
myresiduals = cbind(resid(lm_ORCL), resid(lm_MRK), resid(lm_JNJ))

# Sample correlation matrix
cor(myresiduals)

# Compute the moments of a one-day change in your portfolio
totalwealth = 10000
weights = c(0.5, 0.25, 0.25) 	# What percentage of your wealth will you put in each stock?

mu_SPY = mean(myreturns[,4])
sigma_SPY = sd(myreturns[,4])



# How much money do we have in each stock?
holdings = weights * totalwealth


#### Now use a bootstrap approach
#### With more stocks

mystocks = c("WMT", "TGT", "XOM", "MRK", "JNJ")
myprices = yahooSeries(mystocks, from='2012-01-01', to='2016-07-30')

# Compute the returns from the closing prices
myreturns = YahooPricesToReturns(myprices)
pairs(myreturns)

# Sample a random return from the empirical joint distribution
# This simulates a random day
return.today = resample(myreturns, 1, orig.ids=FALSE)

# Update the value of your holdings
total_wealth = 10000
holdings = total_wealth*c(0.2,0.2,0.2, 0.2, 0.2)
holdings = holdings + holdings*return.today

# Compute your new total wealth
totalwealth = sum(holdings)


# Now loop over two trading weeks
totalwealth = 10000
weights = c(0.2, 0.2, 0.2, 0.2, 0.2)
holdings = weights * totalwealth
n_days = 10
wealthtracker = rep(0, n_days) # Set up a placeholder to track total wealth
for(today in 1:n_days) {
	return.today = resample(myreturns, 1, orig.ids=FALSE)
	holdings = holdings + holdings*return.today
	totalwealth = sum(holdings)
	wealthtracker[today] = totalwealth
}
totalwealth
plot(wealthtracker, type='l')


# Now simulate many different possible trading years!
sim1 = foreach(i=1:5000, .combine='rbind') %do% {
	totalwealth = 10000
	weights = c(0.2, 0.2, 0.2, 0.2, 0.2)
	holdings = weights * totalwealth
	wealthtracker = rep(0, n_days) # Set up a placeholder to track total wealth
	for(today in 1:n_days) {
		return.today = resample(myreturns, 1, orig.ids=FALSE)
		holdings = holdings + holdings*return.today
		totalwealth = sum(holdings)
		wealthtracker[today] = totalwealth
	}
	wealthtracker
}

head(sim1)
hist(sim1[,n_days], 25)

# Profit/loss
hist(sim1[,n_days]- 10000)

# Calculate 5% value at risk
quantile(sim1[,n_days], 0.05) - 10000




