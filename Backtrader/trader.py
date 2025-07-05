import backtrader
import datetime
from strategies import TestStrategy 

#brain -> connects data feed and strategy
cerebro=backtrader.Cerebro() 

cerebro.broker.set_cash(10000000)

data=backtrader.feeds.YahooFinanceCSVData(
    dataname='orcale.csv',

    #do not pass values before this date
    fromdate=datetime.datetime(2000, 1, 1),

    #do not pass values after this date
    todate=datetime.datetime(2000, 12, 31),
    reverse=False)

cerebro.adddata(data)

cerebro.addstrategy(TestStrategy)

cerebro.addsizer(backtrader.sizers.FixedSize, stake=1000)

print('Starting portfolio value: %.2f' % cerebro.broker.getvalue())

cerebro.run()

print('Final portfolio value: %.2f' %cerebro.broker.getvalue())


cerebro.plot()