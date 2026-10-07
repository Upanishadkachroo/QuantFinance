```r
# =====================================================
# CAPM AND FAMA-FRENCH 3-FACTOR REGRESSION
# Stock: Apple (AAPL)
# Frequency: Monthly
# =====================================================

# STEP 1: Install and load packages
# Run install.packages() only once on your computer.

install.packages("quantmod")

library(quantmod)

# STEP 2: Download monthly stock prices from Yahoo Finance

prices <- getSymbols(
  "AAPL",
  src = "yahoo",
  from = "2015-01-01",
  periodicity = "monthly",
  auto.assign = FALSE
)

# Extract adjusted closing prices
monthly_prices <- Ad(prices)

stock_data <- data.frame(
  date = as.Date(index(monthly_prices)),
  adjusted_price = as.numeric(monthly_prices)
)

# Convert dates to the first day of each month
stock_data$date <- as.Date(
  format(stock_data$date, "%Y-%m-01")
)

# STEP 3: Calculate monthly stock returns
# Return = (Current price / Previous price) - 1

n <- nrow(stock_data)

stock_data$stock_return <- c(
  NA,
  stock_data$adjusted_price[2:n] /
    stock_data$adjusted_price[1:(n-1)] - 1
)

stock_data <- stock_data[
  !is.na(stock_data$stock_return),
]

# STEP 4: Download Fama-French monthly factor data

ff_url <- paste0(
  "https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/",
  "F-F_Research_Data_Factors_CSV.zip"
)

ff_zip <- tempfile(fileext = ".zip")

download.file(
  ff_url,
  destfile = ff_zip,
  mode = "wb"
)

# Find the CSV file inside the ZIP archive
zip_files <- unzip(ff_zip, list = TRUE)$Name

csv_file <- zip_files[
  grepl("\\.csv$", zip_files, ignore.case = TRUE)
][1]

ff_lines <- readLines(
  unz(ff_zip, csv_file),
  warn = FALSE
)

# Keep only monthly observations in YYYYMM format.
# This excludes explanatory text and annual summaries.

monthly_lines <- ff_lines[
  grepl("^\\s*[0-9]{6},", ff_lines)
]

ff_data <- read.csv(
  text = paste(
    c("Date,Mkt.RF,SMB,HML,RF", monthly_lines),
    collapse = "\n"
  ),
  strip.white = TRUE
)

# STEP 5: Clean factor data

ff_data$Date <- trimws(as.character(ff_data$Date))

ff_data$date <- as.Date(
  paste0(
    substr(ff_data$Date, 1, 4), "-",
    substr(ff_data$Date, 5, 6), "-01"
  )
)

# Fama-French factors are in percentage points.
# Convert them to decimals to match stock returns.

ff_data$Mkt.RF <- ff_data$Mkt.RF / 100
ff_data$SMB    <- ff_data$SMB / 100
ff_data$HML    <- ff_data$HML / 100
ff_data$RF     <- ff_data$RF / 100

ff_data <- ff_data[
  , c("date", "Mkt.RF", "SMB", "HML", "RF")
]

# STEP 6: Merge stock returns and factor data by month

data <- merge(
  stock_data[, c("date", "stock_return")],
  ff_data,
  by = "date"
)

# Calculate excess stock returns
data$stock_excess <- data$stock_return - data$RF

# Remove incomplete observations
data <- na.omit(data)

# Inspect the final dataset
head(data)
str(data)
summary(data)

# STEP 7: Run CAPM regression

capm <- lm(
  stock_excess ~ Mkt.RF,
  data = data
)

summary(capm)

# STEP 8: Run Fama-French 3-factor regression

ff3 <- lm(
  stock_excess ~ Mkt.RF + SMB + HML,
  data = data
)

summary(ff3)

# STEP 9: Compare the models

cat("CAPM R-squared:", summary(capm)$r.squared, "\n")
cat("FF3 R-squared:", summary(ff3)$r.squared, "\n")

cat(
  "CAPM Adjusted R-squared:",
  summary(capm)$adj.r.squared, "\n"
)

cat(
  "FF3 Adjusted R-squared:",
  summary(ff3)$adj.r.squared, "\n"
)

# Compare estimated coefficients
coef(capm)
coef(ff3)

# Compare the nested models
anova(capm, ff3)

# STEP 10: Save the merged dataset for future use
write.csv(
  data,
  "AAPL_CAPM_FF3_data.csv",
  row.names = FALSE
)
```
