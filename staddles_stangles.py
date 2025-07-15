import matplotlib.pyplot as plt
import numpy as np

# Stock price range
stock_prices = np.arange(70, 131, 1)

# Straddle setup
straddle_strike = 100
straddle_call_cost = 5
straddle_put_cost = 5

# Strangle setup
strangle_call_strike = 105
strangle_put_strike = 95
strangle_call_cost = 3
strangle_put_cost = 3

# Payoffs for Straddle
straddle_call_payoff = np.maximum(stock_prices - straddle_strike, 0) - straddle_call_cost
straddle_put_payoff = np.maximum(straddle_strike - stock_prices, 0) - straddle_put_cost
straddle_total = straddle_call_payoff + straddle_put_payoff

# Payoffs for Strangle
strangle_call_payoff = np.maximum(stock_prices - strangle_call_strike, 0) - strangle_call_cost
strangle_put_payoff = np.maximum(strangle_put_strike - stock_prices, 0) - strangle_put_cost
strangle_total = strangle_call_payoff + strangle_put_payoff

# Plotting
plt.figure(figsize=(14, 8))

# Straddle Payoffs
plt.plot(stock_prices, straddle_call_payoff, '--', color='blue', label='Straddle Call')
plt.plot(stock_prices, straddle_put_payoff, '--', color='orange', label='Straddle Put')
plt.plot(stock_prices, straddle_total, '-', color='black', label='Straddle Total')

# Strangle Payoffs
plt.plot(stock_prices, strangle_call_payoff, '--', color='green', label='Strangle Call')
plt.plot(stock_prices, strangle_put_payoff, '--', color='red', label='Strangle Put')
plt.plot(stock_prices, strangle_total, '-', color='purple', label='Strangle Total')

# Reference lines
plt.axhline(0, color='gray', linewidth=1, linestyle='--')
plt.axvline(100, color='gray', linestyle='--', label='Current Price ($100)')

# Labels and legend
plt.title('Straddle vs. Strangle - Call & Put Payoffs')
plt.xlabel('Stock Price at Expiration')
plt.ylabel('Profit / Loss')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
