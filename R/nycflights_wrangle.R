##### needed packages:
library(tidyverse)
library(mosaic)

##### summarize variables  #####
nycflights13 %>%
  summarize(mean_dep_delay = mean(dep_delay))

# Why NA? because 8255 flights have missing (NA) values
nycflights13 %>% 
  summarize(mosaic::favstats(dep_delay))

# we can add na.rm=TRUE to summaries to ignore these missing values
nycflights13 %>%
  summarize(mean_dep_delay = mean(dep_delay, na.rm=TRUE))


##### Grouping by more than one variable #####

by_origin_monthly = nycflights13 %>% 
  group_by(origin, month) %>% 
  summarize(count = n(),
            mean_dep_delay = mean(dep_delay, na.rm=TRUE))
by_origin_monthly

# now let's make a bar plot
# factor tells R to treat month as a categorical variable,
# even though it's labeled with numbers
ggplot(by_origin_monthly) + 
  geom_col(aes(x=factor(month), y=mean_dep_delay)) + 
  facet_wrap(~origin)

# all three airports worst in summer and winter holidays,
# best in the fall

#####  mutate existing variables  #####

# create 'gain' variable from two existing variables
nycflights13 = nycflights13 %>% 
  mutate(gain = dep_delay - arr_delay)

# Histogram of gain variable
ggplot(nycflights13) +
  geom_histogram(aes(x = gain), binwidth=5)

# which routes from NYC gained the most time in the air, on average?
# need na.rm=TRUE because of missing values
nycflights13 %>%
  group_by(dest) %>%
  summarize(mean_gain = mean(gain, na.rm=TRUE)) %>%
  arrange(desc(mean_gain))

# create multiple new variables at once in the same mutate() 
# within same mutate() code we can refer to new variables just created
nycflights13 = nycflights13 %>% 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours
  )

# now which routes gained the most per hour?
nycflights13 %>%
  group_by(dest) %>%
  summarize(mean_gain_per_hour = mean(gain_per_hour, na.rm=TRUE)) %>%
  arrange(desc(mean_gain_per_hour))
