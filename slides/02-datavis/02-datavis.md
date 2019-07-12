Data visualization
========================================================
author: James Scott 
date: UT-Austin
autosize: false
font-family: 'Gill Sans'

<style>
.small-code pre code {
  font-size: 1em;
}
</style>



Types of features in a data set
========================================================

Categorical: the answer to a multiple choice question:
- Chevy/Honday/Tesla
- ice cream/cake/pie

Ordinal: the answers have an ordering but not a magnitude
- Poor, Moderate, Good, Great
- Private, Corporal, Lieutenant, Colonel, General

Numerical: numbers, whether integer or real-valued
- Beware the "faux numerical" ordinal scale  (CIS!)  


Eight building blocks of good data vis
========================================================

- Tables  
- Bar graphs  
- Histograms and density plots
- Boxplots/dotplots

***

- Scatter plots
- Line graphs  
- Maps  
- Panel plots  


Good principles in action: histograms
========================================================
class: small-code

Let's load some data on temperatures in Rapid City and San Diego:

```r
# Use the correct path name
citytemps = read.csv('data/citytemps.csv')
summary(citytemps)
```

```
      Year          Month             Day        Temp.SanDiego  
 Min.   :1995   Min.   : 1.000   Min.   : 1.00   Min.   :45.10  
 1st Qu.:1999   1st Qu.: 4.000   1st Qu.: 8.00   1st Qu.:58.70  
 Median :2003   Median : 7.000   Median :16.00   Median :63.00  
 Mean   :2003   Mean   : 6.492   Mean   :15.71   Mean   :63.08  
 3rd Qu.:2007   3rd Qu.: 9.000   3rd Qu.:23.00   3rd Qu.:67.30  
 Max.   :2011   Max.   :12.000   Max.   :31.00   Max.   :81.30  
 Temp.RapidCity  
 Min.   :-19.00  
 1st Qu.: 33.30  
 Median : 47.60  
 Mean   : 47.28  
 3rd Qu.: 63.95  
 Max.   : 91.90  
```


Histograms
========================================================
class: small-code

A simple histogram:

```r
hist(citytemps$Temp.SanDiego)
```

<img src="02-datavis-figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />

The `breaks` flag
========================================================
class: small-code


```r
hist(citytemps$Temp.SanDiego, breaks=30)
```

<img src="02-datavis-figure/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />


Adding bells and whistles
========================================================
class: small-code


```r
muSanDiego = mean(citytemps$Temp.SanDiego)
hist(citytemps$Temp.SanDiego, breaks=30)
abline(v=muSanDiego, col='red', lwd=5)
```

<img src="02-datavis-figure/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

Comparing two histograms
========================================================

We can make a multi-frame plot.
```
par(mfrow=c(2,1))
hist(citytemps$Temp.SanDiego)
hist(citytemps$Temp.RapidCity)
```

R's syntax here is somewhat hacky.  We'll see something better when we learn ggplot!


Comparing two histograms
========================================================
class: small-code

<img src="02-datavis-figure/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" style="display: block; margin: auto;" />


What's wrong with this picture?
========================================================
class: small-code

Core principle: plots are truthful about magnitude!  Here we have:
- unequal bin size
- noncomparable y axes
- noncomparable x axes

Let's fix these:
```
# custom breakpoints
mybreaks = seq(-20, 92, by=2) 
par(mfrow=c(2,1))
hist(citytemps$Temp.SanDiego, breaks=mybreaks,
  xlim=c(-20,100), ylim=c(0, 760))
hist(citytemps$Temp.RapidCity, breaks=mybreaks,
  xlim=c(-20,100), ylim=c(0, 760))
```



Comparing two histograms
========================================================

<img src="02-datavis-figure/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />

