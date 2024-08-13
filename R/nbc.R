library(tidyverse)
library(ggplot2)

### data on tv shows from NBC market research

## show details; ratings and engagement
# https://digiday.com/marketing/what-is-a-grp-gross-ratings-point/
shows = read.csv("../data/nbc_showdetails.csv", row.names=1) 

# predicted engagement versus gross ratings points
ggplot(shows) + 
	geom_point(aes(x=PE, y=GRP, color=Genre))

## Now read the pilot focus group survey results
## for each question, 1=strongly disagree, 5=strongly agree.
## 1: 'The show makes me feel ____', 2: 'I found the show ____'
survey = read.csv("../data/nbc_pilotsurvey.csv") 
head(survey)

# there are lots of survey respondents
# let's calculate an average response for each show, for each question,
# across all respondents
pilot_results = survey %>%
	group_by(Show) %>% 
	select(-Viewer) %>%
	summarize_all(mean) %>%
	column_to_rownames(var="Show")

# now we have a tidy matrix of shows by questions
# each entry is an average survey response
head(pilot_results)

# a few quick plots
ggplot(rownames_to_column(pilot_results, "Show")) + 
  geom_col(aes(x=reorder(Show, -Q2_Relatable), y = Q2_Relatable)) + 
  coord_flip()

ggplot(rownames_to_column(pilot_results, "Show")) + 
  geom_col(aes(x=reorder(Show, -Q2_Confusing), y = Q2_Confusing)) + 
  coord_flip()
	
# a look at the correlation matrix
cor(pilot_results)

# a quick heatmap visualization
ggcorrplot::ggcorrplot(cor(pilot_results))

# looks a mess -- reorder the variables by hierarchical clustering
ggcorrplot::ggcorrplot(cor(pilot_results), hc.order = TRUE)


# Now look at PCA of the (average) survey responses.  
# This is a common way to treat survey data
PCApilot = prcomp(pilot_results, rank=6, scale=TRUE)

## variance plot
plot(PCApilot)
summary(PCApilot)

# first few pcs
# try interpreting the loadings
# the question to ask is: "which variables does this load heavily on (positive and negatively)?"
round(PCApilot$rotation[,1:3],2) 

# create a tidy summary of the loadings
loadings_summary = PCApilot$rotation %>%
  as.data.frame() %>%
  rownames_to_column('Question')

# This seems to pick out characteristics of
# well-received dramas with positive loadings?
loadings_summary %>%
  select(Question, PC1) %>%
  arrange(desc(PC1))

# this just seems to load negatively on most things
# honestly not sure!
loadings_summary %>%
  select(Question, PC2) %>%
  arrange(desc(PC2))

# this looks clearly like a drama vs comedy axis
loadings_summary %>%
  select(Question, PC3) %>%
  arrange(desc(PC3))

# Let's make some plots of the shows themselves in 
# PC space, i.e. the space of summary variables we've created
shows = merge(shows, PCApilot$x[,1:3], by="row.names")
shows = rename(shows, Show = Row.names)

# let's plot in PC1 space
# We might feel good calling PC1 the "quality drama" PC
ggplot(shows) + 
	geom_col(aes(x=reorder(Show, PC1), y=PC1)) + 
  coord_flip()

# looks like a "lighthearted vs serious" PC
ggplot(shows) + 
  geom_col(aes(x=reorder(Show, PC3), y=PC3)) + 
  coord_flip()

# principal component regression: predicted engagement
lm1 = lm(PE ~ PC1 + PC2 + PC3, data=shows)
summary(lm1)

# gross ratings points
lm2 = lm(GRP ~ PC1 + PC2 + PC3, data=shows)
summary(lm2)

# Conclusion: we can predict engagement and ratings
# with PCA summaries of the pilot survey.
# probably too much variance to regress on all survey questions!
# since the sample size isn't too large here.
plot(PE ~ fitted(lm1), data=shows)
plot(GRP ~ fitted(lm2), data=shows)

