library(tseries)
#start_date <- "2022-06-02"
#end_date <- "2022-12-03"

start_date <- Sys.Date() - 90
end_date <- Sys.Date()

rel <- get.hist.quote(instrument = "RELIANCE.NS",
                      start=start_date, end=end_date,
                      quote = "AdjClose", provider = "yahoo")
nifty <- get.hist.quote(instrument = "^NSEI",
                        start = start_date, end=end_date,
                        quote = 'AdjClose', provider = "yahoo")

data <- merge(rel, nifty)
rt <- diff(log(data))
head(rt*100)

risk_free_rate <- 0.06/365

# risk premium
rt <- rt - risk_free_rate

plot(rt$Adjusted.nifty, rt$Adjusted.rel, pch=20, col='purple',
     xlab='Nifty 50 risk premium',
     ylab='Relaince risk premium')
grid(col='grey', lty=2)
abline(h=0, col='skyblue', lwd=2)
abline(v=0, col='skyblue', lwd=2)
abline(lm(Adjusted.rel~Adjusted.nifty, data=rt), col='blue', lwd=2. lty=2)

CAPM <- lm(Adjusted.rel~Adjusted.nifty, data=rt)
summary(CAPM)
plot(CAPM)
#reliance price are fairly priced

#check linearity

resid <- CAPM$residuals
y_hat <- CAPM$fitted.values

plot(resid, y_hat, xlab='Residual'. ylab='Predicted Return', pch=2)
abline(h=0, col='skyblue', lwd=2)
abline(v=0, col='skyblue', lwd=2)

#rank test for randomness
library(randtests)
randtests::bartels.rank.test(resid)

#look like, randomness is okay

library(lmtest)
lmtest::bptest(CAPM)







