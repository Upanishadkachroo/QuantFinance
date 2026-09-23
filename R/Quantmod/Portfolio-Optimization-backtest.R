library(quantmod)
library(PerformanceAnalytics)
library(PortfolioAnalytics)

# Ensure the ROI optimization solver plugins are loaded
library(ROI)
library(ROI.plugin.quadprog)

# Changed FB to META, as Yahoo Finance no longer supports the FB ticker
tickers <- c("META", "AAPL", "AMZN", "NFLX", "GOOGL", "MSFT", "NVDA")

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

# Fixed typo: 'port' changed to 'portf'
portf <- add.constraint(portf, type="transaction_cost", ptc=0.001)

# Fixed impossible constraint: 7 assets * 0.99 min weight = 6.93 (fails full_investment rule)
# Updated to realistic diversification limits (5% to 40% per asset)
portf <- add.constraint(portf, type="box", min=0.05, max=0.40)

portf <- add.objective(portf, type="return", name="mean")

# Removed strict target=0.005 to prevent solver from failing if the exact risk target is unachievable
portf <- add.objective(portf, type="risk", name="StdDev")

# 1. Static Portfolio Optimization
optPort <- optimize.portfolio(portfolioreturns, portf, optimize_method="ROI", trace=TRUE)

# 2. Rolling Rebalancing Optimization
# instead of holding same weights as we did earlier, it recalculates and readjusts the portfolio
# weights monthly using rolling historical window, and also uses random sampling of 1k to find the 
# optimial mix of weights
rp <- random_portfolios(portf, 1000, "sample")
opt_rebal <- optimize.portfolio.rebalancing(portfolioreturns, portf, search_size = 5000, 
                                            optimize_method = "random", rp = rp,
                                            rebalance_on = "months", training_period = 1, 
                                            rolling_window = 10) 

# 3. Benchmark (Equal Weight)
equal_weight <- rep(1/ncol(portfolioreturns), ncol(portfolioreturns))
benchmark <- Return.portfolio(portfolioreturns, weights=equal_weight)
colnames(benchmark) <- "EqualWeight"

# 4. S&P 500 Benchmark (SPY)
# Fixed typo: changed [0,4] to [, 4]
sp500prices <- getSymbols.yahoo("SPY", from='2016-01-03', periodicity = 'daily', auto.assign=FALSE)[, 4]
sp500Rets <- na.omit(ROC(sp500prices))
colnames(sp500Rets) <- "SPY"

# Align S&P 500 dates exactly with our portfolio returns
sp500Rets <- sp500Rets[index(portfolioreturns)]

# 5. Visualizations
# Fixed typo: changed opt_rebel to opt_rebal
chart.Weights(opt_rebal, main='Rebalanced Weights Over Time')

# Extract weights safely
rebal_weights <- extractWeights(opt_rebal)

# Fixed overwrite bug: assigned output to rebal_returns instead of overwriting rebal_weights
rebal_returns <- Return.portfolio(portfolioreturns, weights=rebal_weights)
colnames(rebal_returns) <- "OptimizedRebalanced"

# Combine the three strategies and clean any resulting NAs
rets_df <- cbind(rebal_returns, benchmark, sp500Rets)
rets_df <- na.omit(rets_df)

# Plot the comparative performance summary
charts.PerformanceSummary(rets_df, main="P/L Over Time: Optimized vs Equal Weight vs SPY")

