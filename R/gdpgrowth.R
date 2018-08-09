library(mosaic)
library(foreach)

gdpgrowth = read.csv('../data/gdpgrowth.csv', header=TRUE)
head(gdpgrowth)

# Plot the relationship between GDP growth rate and defense spending
plot(gdpgrowth$DEF60, gdpgrowth$GR6096,
	pch=19, col='grey',
	xlab='Fraction GDP spent on national defense (1960)',
	ylab='GDP growth rate, 1960-1996')


# A boxplot
boxplot(GR6096 ~ EAST, data=gdpgrowth,
     xlab='East Asian?',
     ylab='GDP growth rate, 1960-1996')

# A lattice plot: stratify by a categorical variable
xyplot(GR6096 ~ DEF60 | EAST, data=gdpgrowth)
     

# Who's the outlier?
plot(gdpgrowth$DEF60, gdpgrowth$GR6096,
     pch=19, col='grey',
     xlab='Fraction GDP spent on national defense (1960)',
     ylab='GDP growth rate, 1960-1996')

outlier = identify(gdpgrowth$DEF60, gdpgrowth$GR6096, n=1)
gdpgrowth[outlier,]

# Compute correlation with and without Jordan
cor(gdpgrowth$DEF60, gdpgrowth$GR6096)
cor(gdpgrowth$DEF60[-outlier], gdpgrowth$GR6096[-outlier])

# Try a robust measure of correlation: Spearman's rho
# Just Pearson correlation between the _ranks_ (not the values) of the two variables
cor(gdpgrowth$DEF60, gdpgrowth$GR6096, method='spearman')
cor(gdpgrowth$DEF60[-outlier], gdpgrowth$GR6096[-outlier], method='spearman')

# Kendall's tau (a pair concordance measure)
cor(gdpgrowth$DEF60, gdpgrowth$GR6096, method='kendall')
cor(gdpgrowth$DEF60[-outlier], gdpgrowth$GR6096[-outlier], method='kendall')


# Bootstrap ordinary correlation
NMC = 1000
boot1 = foreach(i=1:NMC, .combine='c') %do% {
	gdp_boot = resample(gdpgrowth)
	rho = cor(gdp_boot$DEF60, gdp_boot$GR6096)
} 

hist(boot1)

# Bootstrap Spearman correlation
boot2 = foreach(i=1:NMC, .combine='c') %do% {
	gdp_boot = resample(gdpgrowth)
	rho = cor(gdp_boot$DEF60, gdp_boot$GR6096, method='spearman')
} 

hist(boot2)
confint(boot2)
