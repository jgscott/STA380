library(gamlr)
library(tidyverse)

# see https://arxiv.org/pdf/1209.5026.pdf for a lot more!

# read in data: all goals in NHL hockey from 2002-2014
goal = read.csv("../data/hockey/goal.csv", row.names=1)
head(goal, 10)

# data on situation, teams, and players on the ice
# these are stored in a sparse matrix format called "Matrix market" (MM)
config = readMM("../data/hockey/config.mtx")
team = readMM("../data/hockey/team.mtx")
player = readMM("../data/hockey/player.mtx")

# read in the column names
colnames(config) = scan('../data/hockey/config_names.txt', what='char', sep="\n")
colnames(team) = scan('../data/hockey/team_names.txt', what='char', sep="\n")
colnames(player) = scan('../data/hockey/player_names.txt', what='char', sep="\n")

# +1 for home team, -1 for visiting team
team[1:30, 1:50]
player[1:7, 1:40]

image(player[1:7, 1:40], asp=0.6)

# set up x and y: we'll first fit a model with player effects only,
# focusing on full-strength, normal game situation goals
# but we'll put a lasso penalty on the player coefficients

head(config,10)
full_strength_goals = which(rowSums(config) == 0)
length(full_strength_goals)

# set up x and y inputs
x0 = player[full_strength_goals,]
y0 = goal$homegoal[full_strength_goals]

fit0 = cv.gamlr(x0, y0, nfold=10, verb=TRUE,
                standardize=FALSE, family="binomial")
plot(fit0)
beta_hat = coef(fit0)
head(beta_hat)

# Look at the players
player_pm_logit = coef(fit0)[colnames(player),]  %>%
  sort(., decreasing=TRUE)
head(player_pm_logit, 25)
sum(player_pm_logit != 0)

# Now a model where we include "game configuration" effects,
# i.e. whether the home or away team has a power-play advantage
# this will allow us to use all goals, not just full-strength goals
x = cbind(config,player)
y = goal$homegoal

## fit the plus-minus regression model
## note: non-player effects are unpenalized.
## very important if we view these as confounders!
## use the `free` flag to encode this
fit = cv.gamlr(x, y, nfold=10, verb=TRUE, 
               free=1:ncol(config), standardize=FALSE, family="binomial")

# the CV error plot vs lambda
plot(fit)

# the game-configuration effects
beta_hat[colnames(config),]

# the player effects
beta_hat = coef(fit)
head(beta_hat, 50)

# now the player-only effects
player_pm_logit = coef(fit, select='1se')[colnames(player),] %>%
  sort(., decreasing=TRUE)
head(player_pm_logit, 25) %>% exp()
sum(player_pm_logit != 0)  # a lot more are detectably non-zero (more goals!)
