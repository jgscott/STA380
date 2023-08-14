library(tidyverse)

ads = read.csv('../data/Ads_CTR_Optimisation.csv')
View(ads)

## Randomly showing ads

N = nrow(ads)
num_ads = ncol(ads)
total_reward = 0
clicks = rep(0, num_ads)
views = rep(0, num_ads)
for(i in 1:N) {
  # randomly sample an ad to show
  ad_to_show = sample(1:10, 1)
  views[ad_to_show] = views[ad_to_show] + 1
  
  # update reward statistics
  reward = ads[i, ad_to_show]  # either 1 or 0 depending on whether they click
  clicks[ad_to_show] = clicks[ad_to_show] + reward
  total_reward = total_reward + reward
}

views
clicks/views
total_reward



eps = 0.05
# epsilon-greedy Sampling
# placeholder to track the number of time we showed each ad
clicks = rep(0, num_ads)
views = rep(0, num_ads)
total_reward = 0
for (i in 1:N) {
  
  # Click probabilities from Bayesian posterior distribution (beta)
  # mean of each beta = prior_clicks / prior_views
  explore = rbinom(1,1,prob=eps)
  
  click_probs = clicks/(views + 1)
  if(explore) {
    ad_to_show = sample(1:10, 1)
  } else {
    ad_to_show = which.max(click_probs)
  }
  
  views[ad_to_show] = views[ad_to_show] + 1
  
  # Check for reward and update reward statistics
  reward = ads[i, ad_to_show]
  clicks[ad_to_show] = clicks[ad_to_show] + reward
  total_reward = total_reward + reward
}

views
clicks/views
total_reward



## Thompson sampling

N = nrow(ads)
num_ads = ncol(ads)

# placeholder to track the number of time we showed each ad
clicks = rep(0, num_ads)
views = rep(0, num_ads)

# Thompson Sampling
total_reward = 0
for (i in 1:N) {
  
  # Click probabilities from Bayesian posterior distribution (beta)
  # mean of each beta = prior_clicks / prior_views
  click_probs = rbeta(num_ads, clicks + 1, views - clicks + 1)
  
  # Choose an ad to show based on highest sampled click probability
  ad_to_show = which.max(click_probs)
  views[ad_to_show] = views[ad_to_show] + 1
  
  # Check for reward and update reward statistics
  reward = ads[i, ad_to_show]
  clicks[ad_to_show] = clicks[ad_to_show] + reward
  total_reward = total_reward + reward
}

views
clicks/views
total_reward

