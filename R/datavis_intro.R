library(tidyverse)

### Olympics data

# How do heights compare across summer vs. winter olympics?
ggplot(olympics_top20) + 
  geom_boxplot(aes(x=season, y=height))

# what about a faceted histogram?


# Which sports have the oldest athletes?  Which have the youngest?
ggplot(olympics_top20) +
  geom_boxplot(aes(x=sport, y=age)) +
  coord_flip()

# Has the distribution of ages for Olympic medalists changed over time?
# does that differ for men and women?
