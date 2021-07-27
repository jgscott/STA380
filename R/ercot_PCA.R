library(tidyverse)
library(ggplot2)
library(usmap)
library(lubridate)
library(randomForest)
library(splines)
library(pdp)

# Note: before loading the data,
# you'll first need to unzip the ercot folder
# (too big for GitHub if not compressed)

# Power grid load every hour for 6 1/2 years
# throughout the 8 ERCOT regions of Texas
# units of grid load are megawatts.
# This represents peak instantaneous demand for power in that hour.
# source: scraped from the ERCOT website
load_data = read.csv("../data/ercot/load_data.csv")
head(load_data)

# Now weather data at hundreds of weather stations
# throughout Texas and the surrounding region
# Note: I've imputed a handful of sporadic missing values
# Source: National Weather Service
temperature_impute = read.csv("../data/ercot/temperature_impute.csv", row.names=1)
station_data = read.csv("../data/ercot/station_data.csv", row.names=1)

# take a peak at the weather station data
head(temperature_impute)
head(station_data)

####
# Data cleaning
####

# some dates have completely missing weather data
# Keep the load data for dates when we have weather data
mysub = which(ymd_hms(load_data$Time) %in% ymd_hms(rownames(temperature_impute)))
load_data = load_data[mysub,]

# De-duplicate the weather data by merging on first match of date in the load data
temp_ind = match(ymd_hms(load_data$Time), ymd_hms(rownames(temperature_impute)))
temperature_impute = temperature_impute[temp_ind,]

# Take the time stamps from the load data
time_stamp = ymd_hms(load_data$Time)

# Verify that the time stamps match row by row across the two data frames
all(time_stamp ==  ymd_hms(rownames(temperature_impute)))

# a lot of these station names are in Mexico or the Gulf
# and we don't have temperature data on them
station_data = subset(station_data, state != 'MX')

# Make a map.
# First, project project the lon, lat coordinates
# to the same coordinate system used by usmap
station_map = station_data %>%
  select(lon, lat) %>%
  usmap_transform 

head(station_map)

# now merge these coordinates station name
station_data = station_data %>% rownames_to_column('station')
station_data = merge(station_data, station_map, by=c('lat', 'lon'))
head(station_data)

# plot the coordinates of the weather stations
plot_usmap(include = c("TX", "LA", "OK", "NM", "AR")) + 
  geom_point(data=station_data, aes(x=lon.1, y=lat.1))


#### 
# PCA
####

# Now run PCA on the weather data
pc_weather = prcomp(temperature_impute, rank=5, scale=TRUE)

# these are the linear combinations of station-level data that define the PCs
# each column is a different PC, i.e. a different linear summary of the stations
head(pc_weather$rotation)

# notice 5 summary features gets us 95% of the overall variation in 256 original features
# pretty nice compression ratio!
summary(pc_weather)

# extract the loadings and make the station names a variable
# this will help us with merging
loadings = pc_weather$rotation %>%
  as.data.frame %>%
  rownames_to_column('station')

# now merge the station location data with the PC loadings
station_data = merge(station_data, loadings, by = 'station')
head(station_data)

####
# Visualization
####

# there are two ways to visualize these principal components
# First we can look at the loadings, i.e. go PC by PC and ask:
# which stations have large positive loadings
# and which have large negative loadings?
# Remember, often principal components are _contrasts_ between features.

# set up the map and the color scale
p0 = plot_usmap(include = c("TX", "LA", "OK", "NM", "AR")) +
  scale_color_gradient(low = 'blue', high='red')

# this looks like it contrasts north tx vs elsewhere
# but it is really almost an average temp across texas
# (look at the numbers on the scale)
# the corresponding score is positive when temp is above average across texas
# and negative when temp is below average
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC1))

# clearly contrasting temperature along the coast versus everywhere else
# probably useful for predicting power load in Houston.
# the corresponding score is positive whenever the coast is warmer than
# the rest of texas, relatively speaking (i.e "hot for houston" and "cool for Amarillo")
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC2))

# contrasting the Rio Grande Valley and desert-like parts
# of Texas and New Mexico with everywhere else
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC3))

# contrasting central texas with elsewhere
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC4))

# far south texas vs everywhere else
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC5))


# Second we can look at the scores, i.e. go hour by hour and ask:
# what the first summary of these 256 variables?
# What the second summary?  etc

scores = pc_weather$x

p1 = pc_weather$x %>%
  as.data.frame %>%
  rownames_to_column('time') %>%
  mutate(time = ymd_hms(time)) %>%
  ggplot

# PC score 1 over time
p1 + geom_line(aes(x=time, y=PC1))
# remember that PC1 was kind of like an average temp across Texas
# units here are not interpretable -- just remember that 0 is average

# Looking year by year of PC1 versus day of year (1 - 366)
p1 + geom_line(aes(x=yday(time), y=PC1)) + facet_wrap(~year(time))

# PC2 score over time
# Not nearly so periodic
p1 + geom_line(aes(x=time, y=PC2))
p1 + geom_line(aes(x=yday(time), y=PC2)) + facet_wrap(~year(time))

# remember what PC2 represented!
# it's high when the Gulf Coast is hotter than other areas,
# relative to average temps
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC2)) 

# PC3 score over time
# maybe a little periodic?
p1 + geom_line(aes(x=time, y=PC3))
p1 + geom_line(aes(x=yday(time), y=PC3)) + facet_wrap(~year(time))

# as with PC2, remember what PC3 represented:
# it's high/positive when the Rio Grande Valley and west Texas are hotter
# than the rest of Texas, relative to average temperatures in those regions
p0 + geom_point(data=station_data, aes(x=lon.1, y=lat.1, color=PC3)) 

# so if you had to guess, you might expect that:
# - PC1 + PC2 will be useful for predicting load in the Coast region
# - PC1 + PC3 will be useful for predicting load in South Texas
# let's try it!


####
# Use PC features to predict power load
####


# create a new data frame
# hour of day, day of week, month as predictors
# also use the pc_weather scores
load_combined = data.frame(load_data, 
                        hour = hour(time_stamp),
                        day = wday(time_stamp),
                        month = month(time_stamp),
                        pc_weather$x)


# split into a training and testing set
train_frac = 0.8
N = nrow(load_combined)
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
load_train = load_combined[train_ind,]
load_test = load_combined[-train_ind,]



# try random forests -- nice "go-to" as a first attempt at block-box predictive modeling
# note: this takes awhile!
forest_coast = randomForest(COAST ~ hour + day + month + PC1 + PC2 + PC3 + PC4 + PC5,
                            data = load_train, ntree=500)

# form predictions and calculate the RMSE on the testing set
yhat_forest_coast = predict(forest_coast, load_test)
mean((yhat_forest_coast - load_test$COAST)^2) %>% sqrt

# useful to compare to a linear model with each PC expanded in a spline basis
lm_coast = lm(COAST ~ factor(day) + factor(month) + bs(hour, 7) + 
           bs(PC1, 7) +  bs(PC2, 7) + bs(PC3, 7) + bs(PC4, 7) + bs(PC5, 7),
         data=load_train)
yhat_coast_lm2 = predict(lm_coast, load_test)

# massive improvement, even when throwing in nonlinearities in the PCs
mean((yhat_coast_lm2 - load_test$COAST)^2) %>% sqrt

# Let's visualize the fit of the random forest

# performance as a function of iteration number
# seems to have leveled off
plot(forest_coast)

# a variable importance plot: how much SSE decreases from including each var
varImpPlot(forest_coast)

# partial dependence functions using the pdp package

# time of day
partial1 = pdp::partial(forest_coast, pred.var = 'hour')
plot(partial1)

# PC1
partial2 = pdp::partial(forest_coast, pred.var = 'PC1')
plot(partial2)

# PC2
partial3 = pdp::partial(forest_coast, pred.var = 'PC2')
plot(partial3)
