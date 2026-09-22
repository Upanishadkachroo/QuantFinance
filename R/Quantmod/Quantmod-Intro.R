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

#statistical cal.
#mean 
meanreturn <- mean(aaplogets)

#median
medianreturn <- median(aaplogets)

#std. deviation (volatility/risk)
volatility <- sd(aaplogets)

#skewness
retskewness <- skewness(aaplogets)

#kurtosis 
retkurtosis <- kurtosis(aaplogets)

# Print metrics to console
cat("--- AAPL Statistical Summary ---\n")
cat("Mean Daily Return:", round(meanreturn * 100, 4), "%\n")
cat("Median Daily Return:", round(medianreturn * 100, 4), "%\n")
cat("Daily Volatility (SD):", round(volatility * 100, 4), "%\n")
cat("Skewness:", round(retskewness, 4), "\n")
cat("Kurtosis:", round(retkurtosis, 4), "\n")

#financial modelling
# Clear any previous graphical device errors/settings
dev.off()

#layout for mutli-panel plot
par(mfrow=c(2,1))

#plot 1: cumulative return 
chart.CumReturns(aaplogets, wealth.index = TRUE, 
                 main="Growth of $1 Invested in AAPL (2017-Present)",
                 ylab = "Portfolio Value ($)", col = "blue")

#plot 2; rolling 30-day volatility (risl over time)
chart.RollingPerformance(R=aaplogets, width=30,
                         FUN="stdev",
                         main = "30-Day Rolling Volatility", 
                         ylab = "Volatility", col = "darkred")
# Reset plot layout
par(mfrow = c(1, 1))

chartSeries(aapl)
