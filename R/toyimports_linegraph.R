library(tidyverse)

toyimports = read.csv('../data/toyimports.csv')

head(toyimports)

# filter by parter name
uk_toys = toyimports %>%
  filter(partner_name == 'United Kingdom')

head(uk_toys, 10)

#  sum up imports across all different categories
uk_toys_total = toyimports %>%
  filter(partner_name == 'United Kingdom') %>%
  group_by(year) %>%
  summarize(toys = sum(US_report_import))


# Plot the resut over time
ggplot(uk_toys_total) + 
  geom_line(aes(x=year, y=toys), color='blue') + 
  theme_bw(base_size=18) +
  scale_x_continuous(breaks = 1996:2005)


# Could also go back to the original (un-summed) data
# but this is a bit messy!
ggplot(uk_toys) + 
  geom_line(aes(x=year, y=US_report_import, color=product_name)) +
  scale_x_continuous(breaks = 1996:2005)


# Let's look at three countries
country_list = c('China', 'Korea, Rep.', 'United Kingdom')

combined_toys = toyimports %>%
  filter(partner_name %in% country_list) %>%
  group_by(year, partner_name) %>%
  summarize(toys = sum(US_report_import))

combined_toys


# Plot all three as line graphs
ggplot(combined_toys) + 
  geom_line(aes(x=year, y=toys, color=partner_name)) +
  theme_bw(base_size=18) +
  scale_x_continuous(breaks = 1996:2005)


# on a log scale for the y axis
ggplot(combined_toys) + 
  geom_line(aes(x=year, y=toys, color=partner_name)) +
  theme_bw(base_size=18) +
  scale_x_continuous(breaks = 1996:2005) + scale_y_log10()

