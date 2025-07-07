import vectorbt as vbt
import datetime

end_date=datetime.datetime.now()
start_date=end_date - datetime.timedelta(days=3)

btc_price=vbt.YFData.download(
    ["AAPL","TSLA"],
    interval="1m",
    start=start_date,
    end=end_date,
    missing_index='drop').get("Close")

print(btc_price)
#print(type(btc_price))

rsi=vbt.RSI.run(btc_price, window=[14,21])
print(rsi.rsi) 

entries=rsi.rsi_crossed_below(40)
exits=rsi.rsi_crossed_above(60)
#print(entries.to_string())

pf=vbt.Portfolio.from_signals(btc_price, entries, exits)

#pf.plot().show()

print(pf.stats())
print(pf.total_return())
