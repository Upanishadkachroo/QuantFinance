closing_price=0

with open('data/spy.csv') as f:
    content=f.readlines()[-50:]
    for line in content:
        print(line)
        tokens=line.split(",")
        close=tokens[4]

        closing_price+=float(close)

print(closing_price/200)
