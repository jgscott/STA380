The data scientist's toolbox
========================================================
author: STA 380: Predictive Modeling
date: James Scott (UT-Austin)
autosize: true
font-family: 'Gill Sans'

<style>
.small-code pre code {
  font-size: 1em;
}
</style>




What is this course about?
========================================================

This class is about gaining knowledge from raw data.  You'll learn to use large and complicated data sets to make better decisions.

A mix of practice and principles:
- Solid understanding of essential statistical ideas
- Concrete data-crunching skills
- Best-practice guidelines.

We’ll learn what to trust, how to use it, and how to learn more.


First half: supervised learning
========================================================

- Given past data on outcomes $y$ paired with features $x$, can we
find patterns that allow us to predict $y$ using $x$?
- Key characteristic: there is a single privileged outcome $y$.
- Example: a house has 3 bedrooms ($x_1$), 2 bathrooms ($x_2$), 2100 square feet ($x_2$), and is located in Hyde Park ($x_4$).  What price $(y)$ should it sell for?

You've done this in the first half already; we'll do a bit more in the second half.  


Second half: unsupervised learning.
========================================================

- We still have multivariate data and want to find patterns.
- But there is no single privileged outcome. ("Everything is y.")
- Example: "Here’s data on the shopping basket of every Whole Foods customer at 6th and Lamar last month. Find some patterns that we can use to improve product placement."


An alphabet soup of labels...
========================================================
Statistical learning, data mining, data science, ML, AI... there are many labels for what we’re doing!
- Econometrics, statistics: focused on understanding the underlying phenomena and formally quantifying uncertainty.
- Business analytics, data science, data mining: traditionally focused on pragmatic data-analysis tools for applied prediction problems.
- Machine learning, pattern recognition, artificial intelligence: focused on algorithms with engineering-style performance guarantees.  


An alphabet soup of labels...
========================================================
How our goals fit into all this: we keep an eye on what is both _useful_ and _true_:
- Learn actionable patterns from noisy, complex data (data mining).
- If at all possible, do so using simple, scalable algorithms (machine learning, AI).
- If necessary, provide error bars (statistics).
- Always be aware of the problem context or decision at hand (econometrics).


About "data mining"...
========================================================

Among economists, "data mining" is a dirty word.  Example: the "Lucas critique":
- Fort Knox has never been robbed.
- Thus historically, there's a zero correlation between security spending at Fort Knox ($x$) and the likelihood of being robbed ($y$).  
- Naive "data mining" conclusion: leave Fort Knox unguarded!  

This is an absurd caricature.  We'll strive to give data mining a better reputation :-)


What does it mean for data to be "big"?
========================================================

Big in either or both:
- the number of observations (size $n$)
- and in the number of features or predcitor variables (dimension $p$).

In these settings, you cannot:
- Look at each individual variable and make a decision (t-tests).
- Choose amongst a small set of candidate models (specification tests from stats or econometrics).
- Plot every variable to look for interactions or transformations.



Good data mining = inference at scale
========================================================

Some data-mining tools are straight out of previous statistics classes, e.g.:
- linear regression  
- p-values

Some are familiar with a twist, e.g.
- automatically select a set of relevant feature variables, then fit a linear model
- compress or summarize many features into few, _then_ use basic stats tools (plots, t tests)

Some are new, e.g. trees or PCA.  All require a different approach when $n$ and $p$ get really big.


We'll see a lot of real data
========================================================

- Mining client information: Who buys your stuff, what do they pay, what do they think of your new product?
- Online behavior: Who is on what websites, what do they buy, how do/can we predict or nudge behavior?
- Collaborative filtering: predict preferences from people who do what you do; recommender engines.
- Text mining: Connect blogs/emails/news to sentiment, beliefs, or intent. Parsing unstructured data, e.g. EMR.
- Big regression: mining data to predict asset prices; using unstructured data as controls in observational studies.
- And more.


The four pillars of data science
========================================================

1. Data collection
2. Data cleaning (pre-processing/hacking/"munging")
3. Analysis
4. Summary (figures + prose)

This course focuses a little on 2, heavily on 3-4, and not at all on 1.


Data collection and cleaning: principles
========================================================

On collection, management, and storage: a full subject unto itself. (I’m happy to provide references, but this isn’t the part of data science we cover in this course.)

On cleaning: I defer to Jeff Leek’s description of “How to Share Data with a Statistician.” (See course website.) Always provide:  

 1. The raw data.  
 2. Tidy data.  
 3. A variable “code book” written in easily understood language.  
 4. A complete, fully reproducible recipe of how the clean data was produced from the raw.  


Data analysis and summary: principles
========================================================

You will analyze a lot of data in this course.  Our watchwords are _transparency_ and _reproducibility_.
- The end product: you will write a report with beautiful
figures, and someone else will marvel at it.
- Data science is hard enough already: there is zero room for ambiguity or confusion about data or methods.
- Any competent person should be able to read your description and reproduce exactly what you did.

The ideal: “hit-enter” reproducibility.
- Someone hits enter; your analyses and figures are reproduced from scratch and merged with prose, before their eyes.
- We will rely on a handful of easily mastered software tools to put this ideal into practice.


Data analysis and summary: principles
========================================================

All reports involve three main things:   

  1. A question: what are we doing here?  
  2. Evidence: a set of figures, tables, and numerical summaries based on the analyses performed.  
  3. Conclusions: what did we learn?   


The basic recipe for writing a statistical report:   
  1. Make the key figures and tables first.  
  2. Write detailed captions for each one.  
  3. Put these figures and tables in order (question, then answer).  
  4. Write the story around these main pieces of evidence.  


Our software toolkit
========================================================
- R: for data analysis
- Markdown and RMarkdown: for writing reports
- GitHub: for collaboration and dissemination


R
========================================================

R is the real deal: an immensely capable, industrial-strength platform for data analysis.

It's used everywhere:
- Academic research (stats, marketing/finance, genetics, engineering)
- Industry (Google, Microsoft, EBay, Boeing, Citadel, IBM, NY Times)
- Governments/NGOs (Rand, DOE, National Labs, Navy)

R is free and looks the same on all platforms, so you'll always be able to use it.

R
========================================================

A huge strength of R is that it is open-source.

R has a _core_, to which anyone can add contributed _packages_.
- $\approx$ 10,000 packages c. Jan 2017.
- These packages are as varied as the people who write them.
- Some are specific, others general.
- Some are great, some decent and unpolished, some terrible.

R has flaws, but so do all options (e.g. Python is great, but the community of stats developers is smaller, interactive data analysis is less slick, and you need to be a more careful and sophisticated programmer.)

Most students prefer to use R via an IDE.  We'll use _RStudio._  It's  awesome.

Markdown/RMarkdown
========================================================

- A simple markup language for generating a wide variety of output formats (HTML, PDF, etc) from plain text documents.
- Two pillars: (1) a formatting language; (2) a conversion tool.  
- Much simpler than, for example, HTML.

RMarkdown: generate Markdown reports with R integration.  

This presentation was written in RMarkdown.

Markdown
========================================================


```
## Markdown

- A simple markup language for generating a wide variety of output formats (HTML, PDF, etc) from plain text documents.
- Two pillars: (1) a formatting language; (2) a conversion tool.  
- Much simpler than, for example, HTML.

This presentation was written in Markdown.
```

This is what the raw text looked like for the last slide; it got rendered as a bulleted list under a title.


Git and GitHub
====

git:
- software for version control.
- ideal for collaborative work.
- the basic unit in the git universe is a _repository_, aka "repo": a collection of files/directories all related to a single task, project, or piece of software.
- Example: the class website is a git repo.

Github:
- a git repository hosting service.
- a location to store your code in the cloud and easily sync it across multiple machines and multiple collaborators  
- the coolest place on the Internet :-)

  
Check-in for tomorrow: Git and RMarkdown
====

  1. If you don't already have one, set up a GitHub account.  (It's free.)  
  2. Create your first Git repo on GitHub.  Call it whatever you want (`hello_world` is a classic choice.)  
  3. Clone that repo onto your own computer.  
  4. In your local `hello_world` repo, create a new RMarkdown file called `hello_world.Rmd` that makes any simple plot (e.g. simulates 100 normal draws and plots a histogram).  
  5. Knit `hello_world.Rmd` to a Markdown (.md) output.  
  6. Commit both the source (.Rmd) and knitted (.md) files and push them to GitHub.  
  7. Surf to GitHub in your browser and view your knitted file, `hello_world.md`.  

To accomplish all these steps, you'll have to spend some time with the online documentation and tutorials for Github and RMarkdown.   

