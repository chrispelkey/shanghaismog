library(readr)
library(imputeTS)
library(xts)

# Read in the data
ts_df <- Beijing_2008_HourlyPM2_5_created20140325 <- read_csv("C:/Users/cpelkey/Desktop/Data/Beijing_2008_HourlyPM2.5_created20140325.csv")

# Convert to xts data
Date <- xts(ts_df, order.by = as.Date(as.character('Date (LST)')),
                  format="%m/%d/%Y %H:%M")

cbind(ts_df, Date)
ts_df <- subset(ts_df, select=c('Date', 'Value'))
ts_df <- as.xts(x = ts_df)
indexClass(convertIndex(ts_df$Date, 'POSIXct'))

# Fix the missing points in time using exponential smoothing
lappply(ts_df, function(x){ts_df[x] == -999 <- NA; x})

ts_df[ts_df == -999] <- NA

na.ma(ts_df$Value, k = 4, weighting = "exponential")

# Review graphs of the series to detemine stationarity, seasonality, differencing
plot(ts_df)