import vectorbt as vbt
import pandas as pd
import numpy as np
import datetime

end_time=datetime.datetime.now()
start_time=end_time - datetime.timedelta(days=4)

btc_price=vbt.YFData.download(
    "NVDA",
    missing_index='drop',
    start=start_time,
    end=end_time,
    interval='1m').get("Close")

def custom_indicator(close, rsi_window=14, ma_window=50):
    rsi=vbt.RSI.run(close, window=rsi_window).rsi
    ma=vbt.MA.run(close, ma_window).ma
    print(rsi)
    return rsi.rsi

ind=vbt.IndicatorFactory(
    class_name="Combination",
    short_name="comb",
    input_names=["close"],
    param_names=["rsi_window", "ma_window"],
    output_names=["value"]).from_apply_func(
        custom_indicator,
        rsi_window=21,
        ma_window=50
    )

res=ind.run(
    btc_price,
    rsi_window=21,
    ma_window=50
)

print(res.value)

#print(btc_price)
