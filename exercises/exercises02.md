# STA 380, Part 2: Exercises 2

Turn these in by 12 PM on Wednesday, August 19th.  As before, prepare your reports using RMarkdown so that they are fully reproducible, carefully integrating visual and quantitative evidence with prose.  You should submit your work by sending me a link to a GitHub page where the final report has been stored -- preferably in Markdown/HTML format but PDF is OK too.  Also include a link to the raw .Rmd file that can be used to reproduce your report from scratch.  _Do not send a PDF or Rmd file as an attachment._

Important: Use the subject line "STA 380 Homework 2: Lastname, Firstname" so that I can sort my inbox easily.  (Obviously use your own first and last names in the subject.)

## Flights at ABIA

Consider the data in [ABIA.csv](../data/ABIA.csv), which contains information on every commercial flight in 2008 that either departed from or landed at Austin-Bergstrom Interational Airport.  The variable codebook is as follows: 

1   Year    all 2008
2   Month   1-12
3   DayofMonth  1-31
4   DayOfWeek   1 (Monday) - 7 (Sunday)
5   DepTime actual departure time (local, hhmm)
6   CRSDepTime  scheduled departure time (local, hhmm)
7   ArrTime actual arrival time (local, hhmm)
8   CRSArrTime  scheduled arrival time (local, hhmm)
9   UniqueCarrier   unique carrier code
10  FlightNum   flight number
11  TailNum plane tail number
12  ActualElapsedTime   in minutes
13  CRSElapsedTime  in minutes
14  AirTime in minutes
15  ArrDelay    arrival delay, in minutes
16  DepDelay    departure delay, in minutes
17  Origin  origin IATA airport code
18  Dest    destination IATA airport code
19  Distance    in miles
20  TaxiIn  taxi in time, in minutes
21  TaxiOut taxi out time in minutes
22  Cancelled   was the flight cancelled?
23  CancellationCode    reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
24  Diverted    1 = yes, 0 = no
25  CarrierDelay    in minutes
26  WeatherDelay    in minutes
27  NASDelay    in minutes
28  SecurityDelay   in minutes
29  LateAircraftDelay   in minutes

Your task is to create a figure, or set of related figures, that tell an interesting story about flights into and out of Austin.  You can annotate the figure and briefly describe it, but strive to make it as stand-alone as possible.  It shouldn't need many, many paragraphs to convey its meaning.  Rather, the figure should speak for itself as far as possible.  For example, you might consider one of the following questions: 

- What is the best time of day to fly to minimize delays?  
- What is the best time of year to fly to minimize delays?  
- How do patterns of flights to different destinations or parts of the country change over the course of the year?  
- What are the bad airports to fly to?  

But anything interesting will fly.

