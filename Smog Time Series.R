library(readr)
library(imputeTS)
library(xts)
library(zoo)
library(timeSeries)
library(astsa)

# Read in the data
ts_df <- read_csv("C:/Users/cpelkey/Desktop/Data/Smog/Smog/Smog.csv")

# Convert to date format
DateTS <- as.POSIXct(strptime(ts_df$Date,
                  "%m/%d/%Y %H:%M"))

ts_df$Date <- DateTS

# Remove extraneous columns and convert NAs
ts_df[ts_df == -999] <- NA
ts_df <- subset(ts_df, select=c('Date', 'Value'))
ts_df <- removeNA(ts_df)
ts_df <- as.xts(ts_df$Value, order.by = ts_df$Date)

# Fix the missing points in time using exponential smoothing
na.locf(ts_df, na.rm = FALSE, fromLast = FALSE)

# Subset for two years of data
subset <- ts_df[53356:75098]

# Review graphs of the series to detemine stationarity, seasonality, differencing


plot(subset)
acf2(subset, max.lag = 60)
