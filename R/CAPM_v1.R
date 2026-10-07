data <- data.frame(
  stock_excess=c(0.04, -0.02, 0.05, -0.03, 0.02),
  market_excess=c(0.03, -0.01, 0.04, -0.02, 0.01)
)
data

capm <- lm(stock_excess ~ market_excess, data=data)
summary(capm)

coef(capm)

ff3 <- lm(stock_excess ~ market_excess + SMB + HML, data = data)

summary(ff3)