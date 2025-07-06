import os, sys, argparse
import pandas as pd
import backtrader as bt
from backtrader import cerebro
from strategies.Goldencross import Goldencross

cerebro=bt.Cerebro()
cerebro.broker.setcash(10000)

spy_price=pd.read_csv('data/spy.csv', index_col='date', parse_dates=True)

feed=bt.feeds.PandasData(dataname=spy_price)
cerebro.adddata(feed)

cerebro.addstrategy(Goldencross)
cerebro.run()
cerebro.plot()

