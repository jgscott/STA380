library(tidyverse)
library(gamlr)
####### donohue and levitt 2001/2008: abortion and crime:
###  https://www.nber.org/papers/w8004

## example reading non csv data: this is a dump from a STATA file
## skip says skip the first line of the file, sep="/t" says 'tab separated'
data = read.table("../data/abortion.dat", skip=1, sep="\t")
names(data) = c("state","year","pop","y_viol","y_prop","y_murd",
	"a_murd","a_viol","a_prop",'prison','police',
	'ur','inc','pov','afdc','gun','beer')

## the control variables that D & L use are:
## prison: log of lagged prisoners per capita
## police: the log of lagged police per capita
## ur: the unemployment rate
## inc: per-capita income
## pov: the poverty rate
## AFDC: state welfare generosity at year t-15
## gun: dummy for concealed weapons law
## beer: beer consumption per capita (capturing alcohol-related violence)

data = data[!(data$state%in%c(2,9,12)),] # AK, DC, HA are strange places, per D & L
data = data[data$year>84 & data$year<98,] # incomplete data outside these years
data$pop = log(data$pop)
t = data$year-85  # a notional t=0 year
t2 = t^2  # adding a quadratic term
s = factor(data$state) ## the states are numbered alphabetically

controls = data.frame(data[,c(3,10:17)])
## y is de-trended log crime rate, a is as described below
## note we also have violent and property crime versions
y = data$y_murd  # response variable
d = data$a_murd  # "treatment" variable

## The abortion 'a_' variables are weighted average of abortion rates where
## weights are determined by the fraction of the type of crime committed by
## various age groups. For example, if 60% of violent crime were committed by 18
## year olds and 40% were committed by 19 year olds in state i, the abortion rate
## for violent crime at time t in state i would be constructed as .6 times the
## abortion rate in state i at time t − 18 plus .4 times the abortion rate in
## state i at time t − 19. See Donohue and Levitt (2001) for further detail.

## we'll just look at murder
## note for convenience here I've made y,d,t, global vars: they are not in controls.
orig = glm(y ~ d+t+s+., data=controls) 
summary(orig)$coef  # tons of controls
summary(orig)$coef['d',] %>% round(3)
## this is the levitt analysis: higher abortion leads to lower crime

## Now the same analysis, but for cellphones rather than abortion
cell = read.csv("../data/us_cellphone.csv")
# center on 1985 and scale by 1997-1985
cellrate = (cell[,2]-cell[1,2])/(cell[13,2]-cell[1,2]) 

## what if we're just fitting a quadratic trend?
## there are many things that increased with similar shapes over time
## (cellphone usage, yoga revenues, home prices, ...)
plot(1985:1997, tapply(d, t, mean), xlab="year", ylab="adjusted rate", pch=21, bg=2)
points(1985:1997, cellrate, bg=4, pch=21)
legend("topleft", fill=c(2,4), legend=c("abortions","cellphones"), bty="n")
phone = cellrate[t+1]

## Hey, cellphones fight crime!
tech = glm(y ~ phone+t+s+., data=controls)
summary(tech)$coef['phone',] %>% round(3)

## what is happening here is that murder changed quadratically over the study period.
## and we have no other controls that do so.  To correctly control for the secular trend, you need
## to allow quadratic trends that could be caused by other confounding variables (e.g. technology)

## each state should also have a different baseline linear and quadratic trend
## and, at very least, controls should interact with each other.
## we also allow the control effects to change in time (interact with t+t2)
# (no intercept, since we've removed the reference level from state)
interact = glm(y ~ d + (s + .^2)*(t+t2), data=controls)

summary(interact)$coef['d',] 
## Abortion is no longer significant.
dim(model.matrix(y ~ d + (s + .^2)*(t+t2), data=controls))
## but notice we have very few observations relative to number of parameters.

## so we need a way to select only important controls
## try using a naive lasso 

## refactor state to have NA reference level
s = factor(s, levels=c(NA,levels(s)), exclude=NULL)
x = sparse.model.matrix(~ (s + .^2)*(t+t2), data=controls)[,-1]
dim(x)

## naive lasso regression
naive = gamlr(cbind(d,x),y)
coef(naive)["d",] # effect is AICc selected <0

## problem here is that the lasso regularizes away the confounders!
## it can explain variation in y using one variable (d) or multiple variables correlated with d.
## it picks the most parsimonious solution!
## see e.g. https://projecteuclid.org/euclid.ba/1484103680
## Not a valid causal identification strategy

# SO let's try the double lasso
lm_d = cv.gamlr(x,d)
lm_y = cv.gamlr(x,y)
include_from_d = which(coef(lm_d) != 0) - 1
include_from_y = which(coef(lm_y) != 0) - 1
include = union(include_from_d, include_from_y)
combined = as.matrix(cbind(d, x[,include]))
lm_double = lm(y ~ combined)

# no significance
summary(lm_double)$coef['combinedd',] %>% round(3)

## not much signal in d left after controlling via x, even with regularization...
dhat = predict(lm_d, newdata=x)
plot(dhat,d,bty="n",pch=21,bg=8) 

## this is basically the ugliest plot you can imagine if you're D&L...
## we have little to resemble quasi-experimental variation here...
