# STA 380, Part 2: Exercises 1

Turn these in by 5 PM on Friday, August 7th.  Prepare your reports using RMarkdown so that they are fully reproducible, carefully integrating visual and quantitative evidence with prose.  You should submit your work by sending me a link to a GitHub page where the final report has been stored -- preferably in Markdown format but PDF is OK too, especially if you want to include mathematical expressions in the manner [described here](http://rmarkdown.rstudio.com/authoring_basics.html), since GitHub doesn't do math very well.  Also include a link to the raw .Rmd file that can be used to reproduce your report from scratch.

You can either e-mail me the link to send a message through Canvas, but please use the subject line "STA 380 Homework 1: Lastname, Firstname" so that I can sort my inbox easily.  (Obviously use your own first and last names in the subject.)

Note: I want your report to be fully reproducible.  Of course, it would seem that, by its very nature, one thing that cannot be reproduced exactly is a Monte Carlo simulation.  But in fact you _can_ reproduce such a simulation, if you specify a "seed" to the underlying random number generator.  Thus these two sets of 10 normal random numbers are different (try copying and pasting to an R console):
```
rnorm(10)
rnorm(10)
```

But these two are the same, because in each case we reset the random-number seed to be the same thing:
```
my_favorite_seed = 1234567
set.seed(my_favorite_seed)
rnorm(10)
set.seed(my_favorite_seed)
rnorm(10)
```

You can use this fact to your advantage to create fully reproducible Monte Carlo simulations in RMarkdown, by setting the seed at the very beginning of the file.


## 1) Bootstrapping

Consider the following five asset classes, together with the ticker symbol for an exchange-traded fund that represents each class:
- US domestic equities (SPY: the S&P 500 stock index)
- US Treasury bonds (TLT)  
- Investment-grade corporate bonds (LQD)  
- Emerging-market equities (EEM)  
- Real estate (VNQ)  

If you're unfamiliar with exchange-traded funds, you can read a bit about them [here](http://www.investopedia.com/terms/e/etf.asp).

Download five years or so of daily data on these ETFs, using the functions in the `fFimport` package.  Explore the data and come to an understanding of the risk/return properties of these assets.  Then consider three portfolios: 
- the 20% split: 20% of your assets in each of the five classes.    
- something that seems safer than the 20% split, comprising investments in at least three classes.  You choose the allocation, and you can certainly invest in more than three assets if you want.  
- something more aggressive (again, you choose the allocation) comprising investments in at least two classes.  By more aggressive, I mean a portfolio that looks like it has a chance at higher returns, but also involves more risk of loss.  

Suppose there is a notional $100,000 to invest in one of these portfolios.  Write a brief report that:
- summarizes the risk/return properties of the five major asset classes.  
- outlines your choice of the "safe" and "aggressive" portfolios.  
- uses bootstrap resampling to estimate the 4-week (20 trading day) value at risk of each portfolio at the 5% level.  
- compares the results for each portfolio in a way that would allow the reader to make an intelligent decision among the three options.  

You should assume that your portfolio is rebalanced each day at zero transaction cost.  That is, if you're aiming for 50% SPY and 50% TLT, you always redistribute your wealth at the end of each day so that the 50/50 split is retained, regardless of that day's appreciation/depreciation.


