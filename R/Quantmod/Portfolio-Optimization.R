library(quantmod)
library(PerformanceAnalytics)
library(PortfolioAnalytics)

#install.packages("CVXR")
#library(CVXR)
#install.packages(c("ROI", "ROI.plugin.quadprog", "ROI.plugin.glpk"))
optimize_method = "ROI"

# Ensure the ROI optimization solver plugin is loaded
library(ROI)
library(ROI.plugin.quadprog)

tickers <- c("FB", "AAPL", "AMZN", "NFLX", "GOOGL", "MSFT", "NVDA")

portfolioprices <- NULL
for(ticker in tickers){
  portfolioprices <- cbind(
    portfolioprices,
    getSymbols.yahoo(ticker, from="2016-01-03", periodicity = 'daily', auto.assign=FALSE)[, 4]
  )
}
colnames(portfolioprices) <- tickers

# Clean missing values from prices before calculating returns to prevent gaps
portfolioprices <- na.omit(portfolioprices)

portfolioreturns <- na.omit(ROC(portfolioprices))

portf <- portfolio.spec(assets = colnames(portfolioreturns))

portf <- add.constraint(portf, type="full_investment")
portf <- add.constraint(portf, type="box", min=0.05, max=0.40)

portf <- add.objective(portf, type="return", name="mean")
portf <- add.objective(portf, type="risk", name="StdDev")

optPort <- optimize.portfolio(portfolioreturns, portf, optimize_method="ROI", trace=TRUE)

chart.Weights(optPort)

ef <- extractEfficientFrontier(optPort, match.col="StdDev", n.portfolios=25, risk_aversion=NULL)

chart.EfficientFrontier(ef, match.col="StdDev", n.portfolios=25, type="mean-StdDev")
