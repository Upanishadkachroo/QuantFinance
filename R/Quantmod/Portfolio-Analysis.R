# 1. LOAD REQUIRED LIBRARIES
library(quantmod)
library(PerformanceAnalytics)

# 2. DEFINE PORTFOLIO PARAMETERS & ASSETS
tickers <- c("FB", "AAPL", "AMZN", "NFLX") # Note: FB is now Meta (META), but Yahoo handles redirects or historical lookups.
weights <- c(0.25, 0.25, 0.25, 0.25)       # Equal weighting scheme (25% each)

# 3. FETCH HISTORICAL PRICE DATA
portfolioprices <- NULL

# Loop through each ticker to download daily data starting from Jan 3, 2016
for (ticker in tickers) {
  # [,4] extracts the 4th column, which is the 'Close' price
  portfolioprices <- cbind(
    portfolioprices,
    getSymbols.yahoo(ticker, from = '2016-01-03', periodicity = "daily", auto.assign = FALSE)[, 4]
  )
}

# Assign proper column names to the merged price matrix
colnames(portfolioprices) <- tickers

# Check for any missing (NA) values across the asset columns
colSums(is.na(portfolioprices))


# 4. FETCH BENCHMARK DATA & CALCULATE RETURNS
# Download S&P 500 (^GSPC) Close prices as the market benchmark
benchmarkprices <- getSymbols.yahoo('^GSPC', from = '2016-01-03', periodicity = "daily", auto.assign = FALSE)[, 4]

# Calculate daily Rate of Change (returns) for the benchmark and remove NAs
benchmarkreturns <- na.omit(ROC(benchmarkprices))

# Check for missing values in benchmark prices
colSums(is.na(benchmarkprices))

# 5. CONSTRUCT PORTFOLIO RETURNS
# Convert asset prices into periodic percentage returns
portfolioreturns <- Return.calculate(portfolioprices, method = "discrete")
portfolioreturns <- na.omit(portfolioreturns)

# Aggregate individual asset returns into a single multi-asset portfolio return series using weights
portfolioreturn <- Return.portfolio(portfolioreturns, weights = weights)

# 6. FINANCIAL MODELING & PERFORMANCE METRICS
# Risk-Free Rate assumption: 3.5% annual converted to a daily rate (assuming 252 trading days)
rf_daily <- 0.035 / 252

# --- CAPM & Risk Metrics ---
# Note: CAPM functions require return series, not raw prices. We use benchmarkreturns.
CAPM.beta(portfolioreturn, benchmarkreturns, rf_daily)
CAPM.jensenAlpha(portfolioreturn, benchmarkreturns, rf_daily)

# Note: Fixed spelling to 'SharpeRatio' (capital R)
SharpeRatio(portfolioreturn, Rf = rf_daily, annualize = TRUE)

table.AnnualizedReturns(portfolioreturn, Rf = rf_daily, scale = 252)
table.CalendarReturns(portfolioreturn)
