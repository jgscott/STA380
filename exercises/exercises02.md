# STA 380, Part 2: Exercises 2 

Due: by 5 PM on Monday, August 19.   

Prepare your reports using RMarkdown so that they are fully reproducible, carefully integrating visual and numerical evidence with prose.  You may work solo, or in groups of 4 or fewer people.  If you're working in a group, please turn in a single submission with all of your names attached.

To submit, please e-mail a link to <statdropbox@gmail.com> with the subject line "STA 380 Exercises: name here."  (Obviously use your own name in the subject, or the names of all your group members if applicable.)  This link should be to a GitHub page where the final report has been knitted and stored _in Markdown (.md) format_.  (Do not knit to .html, which won't render properly on GitHub.) Also include a link to the raw .Rmd file that can be used to reproduce your report from scratch.  If you need to include mathematical expressions in your report, you can go down the Googling rabbit hole of "math expressions in Github markdown".  Alternatively, you can just handwrite the math, snap a photo, and include the image in the final report.  This is a simple, low-overhead option.

Note 1: LaTeX is an acceptable alternative to Markdown.  If you wish to typeset your reports in Latex, either use Sweave or something similar.  

Note 2: I want your report to be fully reproducible.  Of course, it would seem that, by its very nature, one thing that cannot be reproduced exactly is a Monte Carlo simulation.  That's OK --- you can try figuring out how to set a seed for your simulation so that it is fully reproducible, or you can just accept that it will be a little bit different next time the script is compiled.  



## Market segmentation

Consider the data in [social_marketing.csv](../data/social_marketing.csv).  This was data collected in the course of a market-research study using followers of the Twitter account of a large consumer brand that shall remain nameless---let's call it "NutrientH20" just to have a label.  The goal here was for NutrientH20 to understand its social-media audience a little bit better, so that it could hone its messaging a little more sharply.

A bit of background on the data collection: the advertising firm who runs NutrientH20's online-advertising campaigns took a sample of the brand's Twitter followers.  They collected every Twitter post ("tweet") by each of those followers over a seven-day period in June 2014.  Every post was examined by a human annotator contracted through [Amazon's Mechanical Turk](https://www.mturk.com/mturk/welcome) service.  Each tweet was categorized based on its content using a pre-specified scheme of 36 different categories, each representing a broad area of interest (e.g. politics, sports, family, etc.)  Annotators were allowed to classify a post as belonging to more than one category.  For example, a hypothetical post such as "I'm really excited to see grandpa go wreck shop in his geriatic soccer league this Sunday!" might be categorized as both "family" and "sports."  You get the picture.

Each row of [social_marketing.csv](../data/social_marketing.csv) represents one user, labeled by a random (anonymous, unique) 9-digit alphanumeric code.  Each column represents an interest, which are labeled along the top of the data file.  The entries are the number of posts by a given user that fell into the given category.  Two interests of note here are "spam" (i.e. unsolicited advertising) and "adult" (posts that are pornographic, salacious, or explicitly sexual).  There are a lot of spam and pornography ["bots" on Twitter](http://mashable.com/2013/11/08/twitter-spambots/); while these have been filtered out of the data set to some extent, there will certainly be some that slip through.  There's also an "uncategorized" label.  Annotators were told to use this sparingly, but it's there to capture posts that don't fit at all into any of the listed interest categories.  (A lot of annotators may used the "chatter" category for this as well.)  Keep in mind as you examine the data that you cannot expect perfect annotations of all posts.  Some annotators might have simply been asleep at the wheel some, or even all, of the time!  Thus there is some inevitable error and noisiness in the annotation process.

Your task to is analyze this data as you see fit, and to prepare a concise report for NutrientH20 that identifies any interesting market segments that appear to stand out in their social-media audience.  You have complete freedom in deciding how to pre-process the data and how to define "market segment." (Is it a group of correlated interests?  A cluster?  A latent factor?  Etc.)  Just use the data to come up with some interesting, well-supported insights about the audience, and be clear about what you did.



## Author attribution

Revisit the Reuters C50 corpus that we explored in class.  Your task is to build the best model you can, using any combination of tools you see fit, for predicting the author of an article on the basis of that article's textual content.  Describe clearly what models you are using, how you constructed features, and so forth.  Yes, this is a supervised learning task, but it potentially draws on a lot of what you know about unsupervised learning, since constructing features for a document might involve dimensionality reduction.

In the C50train directory, you have ~50 articles from each of 50 different authors (one author per directory).  Use this training data (and this data alone) to build the model.  Then apply your model to predict the authorship of the articles in the C50test directory, which is about the same size as the training set.  _Describe your data pre-processing and analysis pipeline in detail._  

Note: you will need to figure out a way to deal with words in the test set that you never saw in the training set.  This is a nontrivial aspect of the modeling exercise.  You might, for example, consider adding a pseudo-word to the training set vocabulary, corresponding to "word not seen before," and add a pseudo-count to it so it doesn't look like these out-of-vocabulary words have zero probability on the testing set.  Or you might simply ignore those new words, at a possible cost in performance.

This question will be graded according to two criteria:    
  1. the clarity of your description.  We will be asking ourselves: could your analysis be reproduced by a competent data scientist based on what you've said?  (That's good.)  Or would that person have to wade into the code in order to understand what, precisely, you've done?  (That's bad.)  
  2. the test-set performance of your best model, versus the best model that James and Jared can build using tools we have learned in class.   


## Association rule mining

Use the data on grocery purchases in [groceries.txt](../data/groceries.txt) and find some interesting association rules for these shopping baskets.  Pick your own thresholds for lift and confidence; just be clear what these thresholds are and how you picked them.  Do your discovered item sets make sense?  Present your discoveries in an interesting and concise way.  

Notes: 
- Like with the first set of exercises: this is an exercise in visual and numerical story-telling.  Do be clear in your description of what you've done, but keep the focus on the data, the figures, and the insights your analysis has drawn from the data.  
- The data file is a list of baskets: one row per basket, with multiple items per row separated by commas.  You'll have to cobble together a few utilities for processing this into the format expected by the "arules" package.  (This is not intrinsically all that hard, but it is the kind of wrinkle you'll encounter frequently on real problems, where your software package expects data in one format and the data comes in a different format.  Figuring out how to bridge that gap is part of the assignment, and so we won't be giving tips on this front.)   

