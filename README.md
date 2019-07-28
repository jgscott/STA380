# STA 380: Predictive Modeling

Welcome to part 2 of STA 380, a course on predictive modeling in the MS program in Business Analytics at UT-Austin.  All course materials can be found through this GitHub page.  Please see the [course syllabus](syllabus.md) for links and descriptions of the readings mentioned below.

Instructors:  
- Dr. James Scott (morning section).  Office hours on Mondays and Wednesdays, 3:20 to 4:20 PM, in GDC 7.516.  
- Dr. Jared Fisher (afternoon section).  Office hours on Tuesdays and Thursdays, 12:00 to 1:30 PM, CBA 2.542.   

Students in both sections are welcome to attend either set of office hours!  


## Outline of topics  

### (1) The data scientist's toolbox

Slides: [The data scientist's toolbox](http://rpubs.com/jgscott/data_science_toolbox)  
Good data-curation and data-analysis practices; R; Markdown and RMarkdown; the importance of replicable analyses; version control with Git and Github.

Readings:  
- [Introduction to RMarkdown](http://rmarkdown.rstudio.com)  
- [RMarkdown tutorial](https://rmarkdown.rstudio.com/lesson-1.html)  
- [Introduction to GitHub](https://guides.github.com/activities/hello-world/)   
- [Getting starting with GitHub Desktop](https://help.github.com/en/desktop/getting-started-with-github-desktop)  
- [Jeff Leek's guide to sharing data](https://github.com/jtleek/datasharing)  

Your assignment after the first class day:  
- Create a GitHub account.  
- Create your first GitHub repository.  
- Inside that repository (on your local machine), create a toy RMarkdown file that does something---e.g. simulates some normal random variables and plots a histogram.  
- Knit that RMarkdown file to a Markdown (.md) output.  
- Push the changes to GitHub and view the final (knitted) .md file.  

These instructions will make sense after you read the tutorials above!  


### (2) Probability basics: a refresher  

Slides: [Introduction to Probability](http://rpubs.com/jgscott/intro_probability_STA380)  

Two short pieces that illustrate the "fallacy of mistaken compounding":  
- [How likely is it that birth control could let you down?](https://www.nytimes.com/interactive/2014/09/14/sunday-review/unplanned-pregnancies.html) from the _New York Times_  
- An excerpt from Chapter 7 of [AIQ: How People and Machines are Smarter Together](./notes/AIQ_excerpt_contraceptive_effectiveness.pdf), by Nick Polson and James Scott.    


Optional references:
- [Chapter 1 of these course notes.](./notes/Bertsekas_Tsitsiklis_Introduction_to_probability.pdf)  There's a lot more technical stuff in here, but Chapter 1 really covers the basics.  
- [Bayes and the search for Air France 447](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.370.2913&rep=rep1&type=pdf).  
- [YouTube video](https://www.youtube.com/watch?v=U9-G-noZrwc) on Bayes and the USS Scorpion.   


### (3) Data exploration and visualization

Topics: data visualization and practice with R.  Bar plots; basic plots for numerical data (scatterplots, boxplots, histograms, line graphs); panel plots.  Introduction to ggplot2.  

Examples of [bad graphics](./notes/badgraphics.pdf).  

Slides: [Introduction to Data Exploration](http://rpubs.com/jgscott/data_exploration)  

R scripts and data:  
- [mpg.R](R/mpg.R)  
- [titanic.R](R/titanic.R) and [TitanicSurvival.csv](data/TitanicSurvival.csv)  
- [toyimports_linegraph.R](R/toyimports_linegraph.R) and [toyimports.csv](data/toyimports.csv)  


Inspiration and further reference:  
- [excerpts](notes/DataScience.pdf) from some course notes on data science.  You'll find some example figures in Chapter 1.  
- [50 ggplots](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html)  
- [A map of average ages in Swiss municipalities](https://github.com/grssnbchr/thematic-maps-ggplot2)  
- [Low-income students in college](https://www.nytimes.com/interactive/2017/01/18/upshot/some-colleges-have-more-students-from-the-top-1-percent-than-the-bottom-60.html)  
- [The French presidential election](https://www.nytimes.com/interactive/2017/04/23/world/europe/french-election-results-maps.html)  
- [LeBron James's playoff scoring record](https://www.nytimes.com/interactive/2017/05/25/sports/basketball/lebron-career-playoff-points-record.html)   



### (4) Resampling methods

The bootstrap; joint distributions; using the bootstrap to approximate value at risk (VaR).  

Slides: [Introduction to the bootstrap](http://rpubs.com/jgscott/bootstrap_STA380)  
  
For the class exercises, you will need to refer to any basic explanation of the concept of value at risk (VaR) for a financial portfolio, e.g. [here](https://en.wikipedia.org/wiki/Value_at_risk), [here](http://www.investopedia.com/articles/04/092904.asp), or [here](http://people.stern.nyu.edu/adamodar/pdfiles/papers/VAR.pdf). 


R scripts and data:    
- [creatinine_bootstrap.R](./R/creatinine_bootstrap.R) and [creatinine.csv](data/creatinine.csv)   
- [portfolio.R](R/portfolio.R)  


Supplemental R scripts:  
- [gonefishing.R](R/gonefishing.R) and [gonefishing.csv](data/gonefishing.csv)  
- [R walkthrough on Monte Carlo simulation](https://github.com/jgscott/learnR/blob/master/montecarlo/montecarlo_intro.md)  
- [greenbuildings.R](R/greenbuildings.R) and [greenbuildings.csv](data/greenbuildings.csv)  
- [gdpgrowth.R](R/gdpgrowth.R) and [gdpgrowth.csv](data/gdpgrowth.csv)  



Readings:  
- ISL Section 5.2 for a basic overview.  
- [These notes](notes/QuantifyingUncertainty.pdf) on bootstrapping and the permutation test.  
- [Section 2 of these notes](notes/decisions_supplement.pdf), on bootstrap resampling.  You can ignore the stuff about utility if you want.  
- [This R walkthrough](https://github.com/jgscott/learnR/blob/master/gonefishing/gonefishing.md) on using the bootstrap to estimate the variability of a sample mean.  


### (5) Clustering

Basics of clustering; K-means clustering; hierarchical clustering.  

Slides: [Introduction to clustering.](http://rpubs.com/jgscott/clustering)    

Scripts and data:  
- [cars.R](R/cars.R) and [cars.csv](data/cars.csv) 
- [hclust_examples.R](R/hclust_examples.R)   
- [linkage_minmax.R](R/linkage_minmax.R)   
<!-- - [we8there.R](R/we8there.R)   -->  


Readings:  
- ISL Section 10.1 and 10.3 or Elements Chapter 14.3 (more advanced)    
- K-means++ [original paper](http://ilpubs.stanford.edu:8090/778/1/2006-13.pdf) or [simple explanation on Wikipedia](https://en.wikipedia.org/wiki/K-means%2B%2B).  This is a better recipe for initializing cluster centers in k-means than the more typical random initialization.


### (6) Latent features and structure

Principal component analysis (PCA).  

Slides: [Introduction to PCA](http://rpubs.com/jgscott/PCA)    

Scripts and data:  
- [pca_intro.R](R/pca_intro.R)  
- [congress109.R](R/congress109.R), [congress109.csv](data/congress109.csv), and [congress109members.csv](data/congress109members.csv)  
- [FXmonthly.R](R/FXmonthly.R), [FXmonthly.csv](data/FXmonthly.csv), and [currency_codes.txt](data/currency_codes.txt)   

If time:  
- [gasoline.R](R/gasoline.R) and [gasoline.csv](data/gasoline.csv)   


Readings:  
- ISL Section 10.2 for the basics or Elements Chapter 14.5 (more advanced)  
- Shalizi Chapters 18 and 19 (more advanced).  In particular, Chapter 19 has a lot more advanced material on factor models, beyond what we covered in class.      



### (7) Networks and association rules  

Networks and association rule mining.  

[Intro slides on networks](notes/networks_intro.pdf).  

[Slides on association rules.](https://github.com/jgscott/ECO395M/blob/master/notes/association_rules.pdf)    

Scripts and data: 
- [medici.R](R/medici.R) and [medici.txt](data/medici.txt)  
- [playlists.R](R/playlists.R) and [playlists.csv](data/playlists.csv)  

Readings: 
- [In-depth explanation of the Apriori algorithm](http://www.rsrikant.com/papers/vldb94_rj.pdf)  


Miscellaneous:  
- [Gephi](https://gephi.org/), a great piece of software for exploring graphs  
- [The Gephi quick-start tutorial](https://gephi.org/tutorials/gephi-tutorial-quick_start.pdf)   



### (8) Text data

Co-occurrence statistics; naive Bayes; TF-IDF; topic models; vector-space models of text (if time allows).

[Slides on text](notes/text_intro.pdf).   

Scripts and data:  
<!-- - [textutils.R](R/textutils.R) 
- [nyt_stories.R](R/nyt_stories.R) and [selections from the New York Times](https://github.com/jgscott/STA380/tree/master/data/nyt_corpus). -->
- [tm_examples.R](R/tm_examples.R) and [selections from the Reuters newswire](https://github.com/jgscott/STA380/tree/master/data/ReutersC50).
- [congress109_classify.R](R/congress109_classify.R)  
- [art_examples.R](R/art_examples.R)

Readings: 
- [Stanford NLP notes](http://nlp.stanford.edu/IR-book/html/htmledition/scoring-term-weighting-and-the-vector-space-model-1.html) on vector-space models of text, TF-IDF weighting, and so forth.  
- [Great blog post about word vectors](https://blog.acolyer.org/2016/04/21/the-amazing-power-of-word-vectors/).  
- [Using the tm package](http://cran.r-project.org/web/packages/tm/vignettes/tm.pdf) for text mining in R.  
- [Dave Blei's survey of topic models](https://www.cs.princeton.edu/~blei/papers/Blei2012.pdf).  
- [A pretty long blog post on naive-Bayes classification](https://www.bionicspirit.com/blog/2012/02/09/howto-build-naive-bayes-classifier.html).  




