import yfinance as yf
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

# Define ticker
tickerSymbol = 'SPY'

# Fetch data
tickerData = yf.Ticker(tickerSymbol)
tickerDf = tickerData.history(period='1d', start='2015-01-01', end='2020-01-01')

# Keep only Close price
tickerDf = tickerDf[['Close']]

# Plot original series
plt.figure(figsize=(10,4))
plt.plot(tickerDf['Close'])
plt.title(f'Stock Price over Time ({tickerSymbol})')
plt.ylabel('Price')

for year in range(2015, 2021):
    plt.axvline(pd.to_datetime(f'{year}-01-01'), color='k', linestyle='--', alpha=0.2)

plt.show()

# First Difference (Stationarity)
tickerDf['FirstDifference'] = tickerDf['Close'].diff()

# Drop NaN
tickerDf = tickerDf.dropna()

# Plot differenced data
plt.figure(figsize=(10,4))
plt.plot(tickerDf['FirstDifference'])
plt.title(f'First Difference over Time ({tickerSymbol})')
plt.ylabel('Price Difference')

for year in range(2015, 2021):
    plt.axvline(pd.to_datetime(f'{year}-01-01'), color='k', linestyle='--', alpha=0.2)

plt.show()

# ACF Plot
plot_acf(tickerDf['FirstDifference'])
plt.show()

# PACF Plot
plot_pacf(tickerDf['FirstDifference'])
plt.show()