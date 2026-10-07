# =====================================================
# CAPM AND FAMA-FRENCH 3-FACTOR REGRESSION
# Stock: Apple (AAPL)
# Frequency: Monthly
# =====================================================


# -----------------------------------------------------
# STEP 1: Load package
# -----------------------------------------------------

library(quantmod)


# -----------------------------------------------------
# STEP 2: Download AAPL data
# -----------------------------------------------------

AAPL <- getSymbols(
  "AAPL",
  src = "yahoo",
  from = "2015-01-01",
  to = "2026-01-01",
  auto.assign = FALSE
)


# Look at AAPL data
head(AAPL)


# -----------------------------------------------------
# STEP 3: Calculate monthly AAPL returns
# -----------------------------------------------------

AAPL_returns <- monthlyReturn(AAPL)

head(AAPL_returns)


# -----------------------------------------------------
# STEP 4: Convert AAPL returns into a normal dataframe
# -----------------------------------------------------

stock_data <- data.frame(
  date = index(AAPL_returns),
  stock_return = as.numeric(AAPL_returns)
)

head(stock_data)


# -----------------------------------------------------
# STEP 5: Download Fama-French 3-factor data
# -----------------------------------------------------

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


# -----------------------------------------------------
# STEP 6: Read Fama-French data
# -----------------------------------------------------

zip_files <- unzip(
  ff_zip,
  list = TRUE
)$Name

csv_file <- zip_files[
  grepl("\\.csv$", zip_files, ignore.case = TRUE)
][1]

ff_lines <- readLines(
  unz(ff_zip, csv_file),
  warn = FALSE
)


# Keep only monthly observations
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


# -----------------------------------------------------
# STEP 7: Clean Fama-French dates
# -----------------------------------------------------

ff_data$Date <- trimws(
  as.character(ff_data$Date)
)

ff_data$date <- as.Date(
  paste0(
    substr(ff_data$Date, 1, 4),
    "-",
    substr(ff_data$Date, 5, 6),
    "-01"
  )
)


# -----------------------------------------------------
# STEP 8: Convert percentages to decimals
# -----------------------------------------------------

ff_data$Mkt.RF <- ff_data$Mkt.RF / 100
ff_data$SMB <- ff_data$SMB / 100
ff_data$HML <- ff_data$HML / 100
ff_data$RF <- ff_data$RF / 100


ff_data <- ff_data[
  ,
  c("date", "Mkt.RF", "SMB", "HML", "RF")
]


# Look at Fama-French data
head(ff_data)


# -----------------------------------------------------
# STEP 9: Merge AAPL and Fama-French data
# -----------------------------------------------------

data <- merge(
  stock_data,
  ff_data,
  by = "date"
)


# -----------------------------------------------------
# STEP 10: Calculate AAPL excess return
# -----------------------------------------------------

data$stock_excess <- (
  data$stock_return - data$RF
)


# Remove missing values
data <- na.omit(data)


# Look at final dataset
head(data)

str(data)


# -----------------------------------------------------
# STEP 11: CAPM REGRESSION
# -----------------------------------------------------

capm <- lm(
  stock_excess ~ Mkt.RF,
  data = data
)

summary(capm)


# -----------------------------------------------------
# STEP 12: FAMA-FRENCH 3-FACTOR REGRESSION
# -----------------------------------------------------

ff3 <- lm(
  stock_excess ~ Mkt.RF + SMB + HML,
  data = data
)

summary(ff3)


# -----------------------------------------------------
# STEP 13: Compare R-squared
# -----------------------------------------------------

cat(
  "CAPM R-squared:",
  summary(capm)$r.squared,
  "\n"
)

cat(
  "FF3 R-squared:",
  summary(ff3)$r.squared,
  "\n"
)


# Adjusted R-squared

cat(
  "CAPM Adjusted R-squared:",
  summary(capm)$adj.r.squared,
  "\n"
)

cat(
  "FF3 Adjusted R-squared:",
  summary(ff3)$adj.r.squared,
  "\n"
)


# -----------------------------------------------------
# STEP 14: View coefficients
# -----------------------------------------------------

coef(capm)

coef(ff3)


# -----------------------------------------------------
# STEP 15: Compare models
# -----------------------------------------------------

anova(capm, ff3)


# -----------------------------------------------------
# STEP 16: Save final dataset
# -----------------------------------------------------

write.csv(
  data,
  "AAPL_CAPM_FF3_data.csv",
  row.names = FALSE
)