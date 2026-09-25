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