library(tidyverse)

greenbuildings = read.csv('../data/greenbuildings.csv')

# Step 1: identify possible confounders
# let's focus on age

# Step 2: check whether age is a plausible confounder: are the ages different b/t green and non-green?

ggplot(greenbuildings) + 
  geom_histogram(aes(x=age, y=stat(density)), binwidth=2) + 
  facet_grid(green_rating~.)
# Notice here we can see the whole distribution of ages
# important for recognizing the second group of older buildings
# that is largely missing among the green-rated buildings

ggplot(greenbuildings) + 
  geom_point(aes(x=age, y=Rent))
 
lm(Rent ~ age, data= greenbuildings)

# step 3: try to hold age roughly constant

# define some age groupings
greenbuildings = mutate(greenbuildings, 
                        agecat= cut(age, c(-1, 10, 25, 50, 75, 200)))

# now compare rent within age groupings
summ1 = greenbuildings %>%
  group_by(agecat, green_rating) %>%
  summarize(mean_rent = mean(Rent), n = n())

ggplot(summ1) + 
  geom_bar(stat='identity', aes(x=agecat, y=mean_rent, fill=factor(green_rating)), position='dodge')

