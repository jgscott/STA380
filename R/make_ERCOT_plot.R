example_set = filter(load_combined,
                     year(Time) == 2016 & hour(Time) == 15)
        
example_set = mutate(example_set, Type = "Observed")      
example_set$Type[143:182] = "Predicted"

ggplot(example_set) + 
  geom_line(aes(x=as.Date(Time), y=COAST, color=Type)) + 
  scale_x_date(date_breaks = "1 week", date_labels = "%W",
               limit=c(as.Date("2016-01-07"),as.Date("2016-07-01"))) + 
  labs(x = 'Week of year (2016)', 
       y = "Power consumption in ERCOT Coast region",
       title="Predicting power demand in Texas")
