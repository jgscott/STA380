# STA 380: Predictive Modeling

Welcome to part 2 of STA 380, a course on predictive modeling in the MS program in Business Analytics at UT-Austin.  All course materials can be found through this GitHub page.  Please see the [course syllabus](syllabus.md) for links and descriptions of the readings mentioned below.

Instructors:  
- Dr. James Scott.  Office hours on Fridays, 6:40am to 7:30am, and 2:00 PM to 3:00 PM, via Zoom.  (All times are US central time.)  
- Dr. Jennifer Starling.  Office hours TBA.

Students in both sections are welcome to attend either set of office hours!  


## Exercises

The exercises are [available here](exercises/).  These are due Monday, August 17th at 5 PM, U.S central time.  Pace yourself over the next few weeks, and start early on the first couple of problems!  
 

## Outline of topics  

### (1) The data scientist's toolbox

Slides: [The data scientist's toolbox](slides/01_datascience_toolbox/01_datascience_toolbox.pdf)  
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


### (2) Probability: a refresher  

Slides: [Some fun topics in probability](slides/02_probability_refresher/probability_fun_topics.pdf)  

Two short pieces that illustrate the "fallacy of mistaken compounding":  
- [How likely is it that birth control could let you down?](https://www.nytimes.com/interactive/2014/09/14/sunday-review/unplanned-pregnancies.html) from the _New York Times_  
- An excerpt from Chapter 7 of [AIQ: How People and Machines are Smarter Together](./notes/AIQ_excerpt_contraceptive_effectiveness.pdf), by Nick Polson and James Scott.    


Optional reference: [Chapter 1 of these course notes.](./notes/Bertsekas_Tsitsiklis_Introduction_to_probability.pdf)  There's a lot more technical stuff in here, but Chapter 1 really covers the basics of what every data scientist should know about probability. 



### (3) Data exploration and visualization

Topics: data visualization and practice with R.  

Slides: [Introduction to Data Exploration](slides/03_data_exploration/intro_dataviz_examples.pdf)  

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

Slides: [Introduction to the bootstrap](slides/04_resampling/bootstrap_STA380.pdf)  
  
Reference: ISL Section 5.2 for a basic overview of the bootstrap.    

For the class exercises, you will need to refer to any basic explanation of the concept of value at risk (VaR) for a financial portfolio, e.g. [here](https://en.wikipedia.org/wiki/Value_at_risk), [here](http://www.investopedia.com/articles/04/092904.asp), or [here](http://people.stern.nyu.edu/adamodar/pdfiles/papers/VAR.pdf). 


R scripts and data:    
- [creatinine_bootstrap.R](./R/creatinine_bootstrap.R) and [creatinine.csv](data/creatinine.csv)   
- [portfolio.R](R/portfolio.R)  


Supplemental resources:  
- [R walkthrough on Monte Carlo simulation](https://github.com/jgscott/learnR/blob/master/montecarlo/montecarlo_intro.md)  
- [These notes](notes/QuantifyingUncertainty.pdf) on bootstrapping and the permutation test.  
- [Section 2 of these notes](notes/decisions_supplement.pdf), on bootstrap resampling.  You can ignore the stuff about utility if you want.  
- [This R walkthrough](https://github.com/jgscott/learnR/blob/master/gonefishing/gonefishing.md) on using the bootstrap to estimate the variability of a sample mean.  


### (5) Clustering

Basics of clustering; K-means clustering; hierarchical clustering.  

Slides: [Introduction to clustering.](slides/05_clustering/05_clustering.pdf)      

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

Slides: [Introduction to PCA](slides/06_PCA/06_PCA.pdf)      

Scripts and data for class:  
- [pca_intro.R](R/pca_intro.R)  
- [nbc.R](R/nbc.R), [nbc_showdetails.csv](data/nbc_showdetails.csv), [nbc_pilotsurvey.csv](data/nbc_pilotsurvey.csv)  
- [congress109.R](R/congress109.R), [congress109.csv](data/congress109.csv), and [congress109members.csv](data/congress109members.csv)  
- [ercot_PCA.R](R/ercot_PCA.R), [ercot.zip](data/ercot.zip)  


A few other examples we likely won't cover in class:  
- [FXmonthly.R](R/FXmonthly.R), [FXmonthly.csv](data/FXmonthly.csv), and [currency_codes.txt](data/currency_codes.txt)    
- [NCI60.R](R/NCI60.R)   
- [gasoline.R](R/gasoline.R) and [gasoline.csv](data/gasoline.csv)   


Readings:  
- ISL Section 10.2 for the basics or Elements Chapter 14.5 (more advanced)  
- Shalizi Chapters 18 and 19 (more advanced).  In particular, Chapter 19 has a lot more advanced material on factor models, beyond what we covered in class.      



### (7) Networks and association rules  

Networks and association rule mining.  

Slides: [Intro to networks](slides/Networks.pdf).  Note: these slides refer to "lastfm.R" but this is the same thing as "playlists.R" below.  

Some supplemental [slides on association rule mining.](slides/association_rules.pdf) These contain the details of the apriori algorithm.  If there's time we might cover some of this in class, but mainly we'll focus on the shorter intro slides above, together with the example R scripts below.     

Software you'll need:   
- [Gephi](https://gephi.org/), a great piece of software for exploring graphs  
- [The Gephi quick-start tutorial](https://gephi.org/tutorials/gephi-tutorial-quick_start.pdf)  

Scripts and data: 
- [medici.R](R/medici.R) and [medici.txt](data/medici.txt)  
- [playlists.R](R/playlists.R) and [playlists.csv](data/playlists.csv)  
- [microfi.R](R/microfi.R), [microfi_households.csv](data/microfi_households.csv), and [microfi_edges.txt](data/microfi_edges.txt).  

Supplemental resource: [In-depth explanation of the Apriori algorithm](http://www.rsrikant.com/papers/vldb94_rj.pdf)  



### (8) Text data

Co-occurrence statistics; naive Bayes; TF-IDF; topic models; vector-space models of text (if time allows).

[Slides on text](notes/text_intro.pdf).   

Scripts and data:  
- [tm_examples.R](R/tm_examples.R) and [selections from the Reuters newswire](https://github.com/jgscott/STA380/tree/master/data/ReutersC50)  
- [smallbeer.R](R/smallbeer.R) and [smallbeer.csv](data/smallbeer.csv)  

If time in class, we'll cover this script below.  But if not, it's a useful starting point for your homework anyway:  
- [congress109_classify.R](R/congress109_classify.R)    

Supplemental material:   
- [Great blog post about word vectors](https://blog.acolyer.org/2016/04/21/the-amazing-power-of-word-vectors/).  
- [Stanford NLP notes](http://nlp.stanford.edu/IR-book/html/htmledition/scoring-term-weighting-and-the-vector-space-model-1.html) on vector-space models of text, TF-IDF weighting, and so forth.  
- [Using the tm package](http://cran.r-project.org/web/packages/tm/vignettes/tm.pdf) for text mining in R.  
- [Some slides on Naive Bayes text classification](https://web.stanford.edu/class/cs124/lec/naivebayes.pdf).  




