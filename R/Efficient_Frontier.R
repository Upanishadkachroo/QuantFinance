#start efficient frointier

#bring dependencies
library("httr")
library("jsonlite")
library("keyring")
library("dplyr")
library("ggplot")
library("plotly")

#get and format price history data
tickers = c("META", "COIN", "AMZN", "NVDA")

for(i in 1:length(tickers)){
  #print(i)
  requrl <- paste0("https://api.stockdata.org/v1/data/eod?symbols=",
                   tickers[i],
                   "&sort=asc&api_token=",
                   keyring::key_set("STOCK_DATA_KEY")
  )
  pricehistoryres <- GET(requrl)
  
  tickerpricedata <- data.frame(fromJSON(rawToChar(pricehistoryres$content))$data)
  
  if(i==1){
    alldata <- tickerpricedata[ , c("date", "close")]
  }
  else{
    alldata <- cbind(alldata, tickerpricedata$close)
  }
}

colnames(alldata) <- c("Date", tickers)


#get daily returns and summary data
expectedreturns=NULL
standarddeviations=NULL
for(e in tickers){
  newcolumnname=paste0(e, "return")
  
  alldata <- alldata %>%
    mutate(!!newcolumnname := (get(e) - lag(get(e))) / lag(get(e)) )
  
  expectedreturns <- cbind(expectedreturns, mean(alldata[-1, newcolumnname]))
  standarddeviations <- cbind(standarddeviations, sd(alldata[-1, newcolumnname]))
}

colnames(expectedreturns) <- tickers
colnames(standarddeviations) <- tickers


variances <- standarddeviations**2
modifiedsharperatios <- expectedreturns/standarddeviations


#calculate x on variance-covariance matrix
xdf <- alldata[-1, -(1:(length(tikcers)+1))]

colnames(xdf) <- tickers

for(e in tickers){
  xdf <- sdf %>%
    mutate(!!e :=get(e) - expectedreturns[1,e])
}

xmatrix <- data.matrix(xdf)
xmatrixtranspose <- t(xmatrix)

varcovar <- (xmatrixtranspose %*% xmatrix) / (nrow(xdf)-1)

#expected return and volatility for equal weighted portfolio
equalportfolio <- xdf[1,]
for(e in tickers){
  equalportfolio <- equalportfolio %>%
    mutate(!!e := 1/length(tickers))
}

weights <- data.matrix(equalportfolio)

equalportfolio$expectedreturn <- sum(weights*expectedreturns)

equalportfolio$volatility <- sqrt((weights %*% varcovar) %*% t(weights))

equalportfolio$sharperatio <- equalportfolio$expectedreturn / equalportfolio$volatilty 
  
  
#simulate multiple portfolio weights
numofportfolios <- 5000

multipleweight <- xdf[(1:numofportfolios),]


for(e in tickers){
  multipleweight <- multipleweight %>%
    mutate(!!e := runif(numofportfolios))
}

multipleweight$totalofrandoms <- rowsums(multipleweight)

weightcolnames <- c()

for(e in tickers){
  newcolumnname <- paste0(e, "weight")
  weightcolnames <- c(weightcolnames, newcolumnname)
  
  multipleweight <- multipleweight %>%
    mutate(!!newcolumnname := get(e) / totalofrandoms)
}



# Expected Return and Volatility For Different Weighted portfolio

for(i in 1:nrow(multipleweight)){
  weights <- data.matrix(multipleweight[i, weightcolnames])
  
  multipleweight[i,("expectedReturn")] <- sum(weights * expectedreturns)
  
  multipleweight[i,("volatility")] <- sqrt((weights %*% varcovar) %*% t(weights))
}

multipleweight$sharperatio <- multipleweight$expectedreturn / multipleweight$volatility

multipleweight[, c(weightcolnames, "expectedReturn", "volatility")] <- round(multipleweight[, c(weightcolnames, "expectedReturn", "volatility")] * 100, 4)

# Generate Interactive Efficeint Frontier Chart


generalplot <- function(data,knownaes) {
  match_aes <- intersect(names(data), knownaes)
  my_aes_list <- purrr::set_names(purrr::map(match_aes, rlang::sym), match_aes)
  my_aes <- rlang::eval_tidy(quo(aes(!!!my_aes_list)))
  return(my_aes)
}

graph <- ggplot(multipleweight, aes(x=volatility, y=expectedReturn)) +
  geom_point(aes(color=sharpeRatio))+
  generalplot(multipleweight, weightcolnames)+
  scale_colour_gradient(low = "red", high = "blue") +
  theme_classic()+
  theme(axis.title = element_text(size = 14),
        plot.title = element_text(size = 16),
        axis.line=element_line(color="white"),
        text = element_text(color = "white"),
        panel.background = element_rect(fill = "black"),
        plot.background = element_rect(fill = "black"),
        legend.background = element_rect(fill = "black"),
  )+
  xlab("Volatility (%)")+
  ylab("Expected Daily Return (%)")+
  ggtitle("Efficient Frontier (Modern Portfolio Theory)")


ggplotly(graph)


# End Of Efficient Frontier 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
