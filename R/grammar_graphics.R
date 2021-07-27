library(tidyverse)

# the grammar of graphics

# example 1
bikeshare = read.csv('data/bikeshare.csv')

bike_summary = bikeshare %>%
  group_by(hr, workingday) %>%
  summarize(median_rentals = median(total))
bike_summary %>% round(0) %>% head(6) 

# a basic plot
# variables: time, median rentals, working day
# objects: lines
# mappings: (time, rentals) -> (x,y); working day -> color
ggplot(bike_summary) + 
  geom_line(aes(x=hr, y=median_rentals,
                color=factor(workingday)))


# a plot with some modifications
ggplot(bike_summary) + 
  geom_line(aes(x=hr, y=median_rentals,
                color=factor(workingday))) + 
  labs(x="Hour of day (0 = midnight)", y="Median bike rentals",
       title="Bike-share rentals in Washington, DC (2011-12)") + 
  scale_x_continuous(breaks=seq(0,23,by=2)) + 
  scale_color_discrete(name = "Working day?", labels = c("No", "Yes"))


# an entirely different plot of the same data,
# with different aesthetic mappings

p0 = ggplot(bike_summary) + 
  geom_col(aes(x=hr, y=median_rentals)) +
  facet_wrap(~workingday, labeller = label_both) 
p0

p0 + labs(x="Hour of day (0 = midnight)", y="Median bike rentals",
     title="Bike-share rentals in Washington, DC (2011-12)") + 
  scale_x_continuous(breaks=0:23) + theme_bw(base_size=9)
