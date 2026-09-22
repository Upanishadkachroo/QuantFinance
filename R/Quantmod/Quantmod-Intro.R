library(quantmod)
library(PerformanceAnalytics)

#mention the start date
dt <- "2017-2-1"
aapl <- getSymbols.yahoo("AAPL", from=dt, auto.assign=F)[,6]
aaplClose <- getSymbols.yahoo("AAPL", from=dt, auto.assign=FALSE)[,6]

#clean the data
aaplClose <- na.omit(aaplClose)

#aaplRets <- na.omit(dailyReturn(aaplClose, type="log"))

#calculate different types of returns
#1. log returns
aaplogets <- dailyReturn(aaplClose, type="log")

#simple return (% change)
aaplSimpleRets <- dailyReturn(aapl, type="arithmetic")

#remove na from above two
aaplogets <- na.omit(aaplogets)
aaplSimpleRets <- na.omit(aaplSimpleRets)



chartSeries(aapl)
