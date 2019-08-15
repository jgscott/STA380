library(tidyverse)
library(knitr)

TitanicSurvival = read.csv('../data/TitanicSurvival.csv')
summary(TitanicSurvival)

# Our basic contingency table of proportions
xtabs(~survived + passengerClass, data=TitanicSurvival) %>%
  prop.table(margin=2)

# prettier formatting
t1 = xtabs(~survived + passengerClass, data=TitanicSurvival)

t1 %>%
  prop.table(margin=2) %>%
  round(3) %>%
  kable 




# Same basic pipeline can create a new table of survival percentages
# We'll group by sex and summarize by percentage
d1 = TitanicSurvival %>%
  group_by(sex) %>%
  summarize(surv_pct = sum(survived=='yes')/n())
d1

# now make a barplot of survival percentage by sex
ggplot(data = d1) + 
  geom_bar(mapping = aes(x=sex, y=surv_pct), stat='identity')


###
# tables of summary statistics
###

# mean age by class
TitanicSurvival %>%
  group_by(passengerClass) %>%
  summarize(mean_age = mean(age,na.rm=TRUE))


# grouping by two variables and spreading one across the columns
TitanicSurvival %>%
  group_by(passengerClass, survived) %>%
  summarize(mean_age = mean(age,na.rm=TRUE)) %>%
  spread(survived, mean_age)



###
# visualizing distributions
###

# histogram
ggplot(data=TitanicSurvival) + 
  geom_histogram(aes(x=age))

# density histogram with specified bin width
ggplot(data=TitanicSurvival) + 
  geom_histogram(aes(x=age, stat(density)), binwidth=2)


# faceting by passenger class
ggplot(data=TitanicSurvival) + 
  geom_histogram(aes(x=age, stat(density)), binwidth=2) + 
  facet_grid(passengerClass~.) +
  theme_bw(base_size=18) 


# boxplot
ggplot(data=TitanicSurvival) + 
  geom_boxplot(aes(x=passengerClass:survived, y=age)) + 
  theme_bw(base_size=18) 

# violin plot
ggplot(data=TitanicSurvival) + 
  geom_violin(aes(x=passengerClass:survived, y=age)) + 
  theme_bw(base_size=18) 





###
# multivariate plots
###

# aggregate the data set by more than one factor
d2 = TitanicSurvival %>%
  group_by(sex, passengerClass) %>%
  summarize(surv_pct = sum(survived=='yes')/n())
d2

# now plot survival vs passenger class, stratified by sex
# note: position = "dodge" places overlapping objects directly beside one another.
# This makes it easier to compare individual values.
ggplot(data = d2) + 
  geom_bar(mapping = aes(x=passengerClass, y=surv_pct, fill=sex),
           position="dodge", stat='identity') 

# could also facet on sex
ggplot(data = d2) + 
  geom_bar(mapping = aes(x=passengerClass, y=surv_pct), stat='identity') + 
  facet_wrap(~sex)


# Let's do one with three grouping variables

# first create a grouping variable for age
TitanicSurvival = TitanicSurvival %>%
  mutate(agecat = cut(age, c(0, 18, 100)))
summary(TitanicSurvival)

# for now, just remove the NAs (these correspond to missing ages)
TitanicSurvival = na.omit(TitanicSurvival)
TitanicSurvival = subset(TitanicSurvival, !is.na(age))


d3 = TitanicSurvival %>%
  group_by(sex, passengerClass, agecat) %>%
  summarize(surv_pct = sum(survived=='yes')/n(), n=n())
d3

# Now make a pretty plot
# four variables on a 2-D screen and yet still readable!
ggplot(data = d3) + 
  geom_bar(mapping = aes(x=passengerClass, y=surv_pct, fill=agecat),
           stat='identity', position ='dodge') + 
  facet_wrap(~sex) + 
  labs(title="Survival on the Titanic", 
       y="Fraction surviving",
       x = "Passenger Class",
       fill="Age")


# An entirely different organization of the same information
ggplot(data = d3) + 
  geom_bar(mapping = aes(x=agecat, y=surv_pct, fill=sex),
           stat='identity', position ='dodge') + 
  facet_wrap(~passengerClass) + 
  labs(title="Survival on the Titanic", 
       y="Fraction surviving",
       x = "Age",
       fill="Sex")


