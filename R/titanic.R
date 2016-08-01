library(mosaic)
library(foreach)
TitanicSurvival = read.csv('../data/TitanicSurvival.csv')

# A 2x2 contingency table
t1 = xtabs(~sex + survived, data=TitanicSurvival)
t1
p1 = prop.table(t1, margin=1)
p1

# Calculate the relative risk of dying for both men and women
# in terms of the individual cells of the table
risk_female = p1[1,1]
risk_male = p1[2,1]
relative_risk = risk_male/risk_female
relative_risk

# Or with mosaic's function
relrisk(t1)

# Is this association significant?  Let's check with a permutation test

# The basic idea: break any association that might be present
sesame_street = c('A', 'B', 'C', 'D', 'E')
army = c('alpha', 'bravo', 'charlie', 'delta', 'echo')
data.frame(sesame_street, army)

# Now shuffle one set of letters
data.frame(shuffle(sesame_street), army)

# Try this with the Titanic data
titanic_shuffle = data.frame(shuffle(TitanicSurvival$sex), TitanicSurvival$survived)
head(TitanicSurvival)
head(titanic_shuffle)

# Make a table and check the relative risk
t1_shuffle = xtabs(~shuffle(sex) + survived, data=TitanicSurvival)
relrisk(t1_shuffle)

# Repeat many times
permtest1 = foreach(i = 1:1000, .combine='c') %do% {
  t1_shuffle = xtabs(~shuffle(sex) + survived, data=TitanicSurvival)
  relrisk(t1_shuffle)
}

# Compare with the observed relative risk
hist(permtest1)
