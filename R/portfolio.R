library(mosaic)
library(quantmod)
library(foreach)

# Import a few stocks
mystocks = c("MRK", "JNJ", "SPY")
getSymbols(mystocks)

# Adjust for splits and dividends
MRKa = adjustOHLC(MRK)
JNJa = adjustOHLC(JNJ)
SPYa = adjustOHLC(SPY)

# Look at close-to-close changes
plot(ClCl(MRKa))
plot(ClCl(SPYa))

# Combine close to close changes in a single matrix
all_returns = cbind(ClCl(MRKa),ClCl(JNJa),ClCl(SPYa))
head(all_returns)
# first row is NA because we didn't have a "before" in our data
all_returns = as.matrix(na.omit(all_returns))
N = nrow(all_returns)

# These returns can be viewed as draws from the joint distribution
# strong correlation, but certainly not Gaussian!  
pairs(all_returns)
plot(all_returns[,1], type='l')

# Look at the market returns over time
plot(all_returns[,3], type='l')

# are today's returns correlated with tomorrow's? 
# not really!   
plot(all_returns[1:(N-1),3], all_returns[2:N,3])

# An autocorrelation plot: nothing there
acf(all_returns[,3])

# conclusion: returns uncorrelated from one day to the next
# (makes sense, otherwise it'd be an easy inefficiency to exploit,
# and market inefficiencies that are exploited tend to disappear as a result)

#### Now use a bootstrap approach
#### With more stocks

mystocks = c("WMT", "TGT", "XOM", "MRK", "JNJ")
myprices = getSymbols(mystocks, from = "2007-01-01")


# A chunk of code for adjusting all stocks
# creates a new object adding 'a' to the end
# For example, WMT becomes WMTa, etc
for(ticker in mystocks) {
	expr = paste0(ticker, "a = adjustOHLC(", ticker, ")")
	eval(parse(text=expr))
}

head(WMTa)

# Combine all the returns in a matrix
all_returns = cbind(	ClCl(WMTa),
								ClCl(TGTa),
								ClCl(XOMa),
								ClCl(MRKa),
								ClCl(JNJa))
head(all_returns)
all_returns = as.matrix(na.omit(all_returns))

# Compute the returns from the closing prices
pairs(all_returns)

# Sample a random return from the empirical joint distribution
# This simulates a random day
return.today = resample(all_returns, 1, orig.ids=FALSE)

# Update the value of your holdings
# Assumes an equal allocation to each asset
total_wealth = 10000
my_weights = c(0.2,0.2,0.2, 0.2, 0.2)
holdings = total_wealth*my_weights
holdings = holdings*(1 + return.today)

# Compute your new total wealth
holdings
total_wealth = sum(holdings)
total_wealth

# Now loop over two trading weeks
# let's run the following block of code 5 or 6 times
# to eyeball the variability in performance trajectories

## begin block
total_wealth = 10000
weights = c(0.2, 0.2, 0.2, 0.2, 0.2)
holdings = weights * total_wealth
n_days = 10  # capital T in the notes
wealthtracker = rep(0, n_days) # Set up a placeholder to track total wealth
for(today in 1:n_days) {
	return.today = resample(all_returns, 1, orig.ids=FALSE)  # sampling from R matrix in notes
	holdings = holdings + holdings*return.today
	total_wealth = sum(holdings)
	wealthtracker[today] = total_wealth
}
total_wealth
plot(wealthtracker, type='l')
## end block

# Now simulate many different possible futures
# just repeating the above block thousands of times
initial_wealth = 10000
sim1 = foreach(i=1:5000, .combine='rbind') %do% {
	total_wealth = initial_wealth
	weights = c(0.2, 0.2, 0.2, 0.2, 0.2)
	holdings = weights * total_wealth
	n_days = 10
	wealthtracker = rep(0, n_days)
	for(today in 1:n_days) {
		return.today = resample(all_returns, 1, orig.ids=FALSE)
		holdings = holdings + holdings*return.today
		total_wealth = sum(holdings)
		wealthtracker[today] = total_wealth
	}
	wealthtracker
}

# each row is a simulated trajectory
# each column is a data
head(sim1)
hist(sim1[,n_days], 25)

# Profit/loss
mean(sim1[,n_days])
mean(sim1[,n_days] - initial_wealth)
hist(sim1[,n_days]- initial_wealth, breaks=30)

# 5% value at risk:
quantile(sim1[,n_days]- initial_wealth, prob=0.05)

# note: this is  a negative number (a loss, e.g. -500), but we conventionally
# express VaR as a positive number (e.g. 500)
