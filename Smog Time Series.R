library(readr)
library(imputeTS)
library(xts)
library(zoo)
library(timeSeries)
library(astsa)

# Read in the data
ts_df <- read_csv("C:/Users/cpelkey/Desktop/Data/Smog/Smog/Smog.csv")
# ts_df <- read_csv("~/shanghaismog/Beijing_2008_HourlyPM2.5_created20140325.csv")
ts_df <- as.data.frame(ts_df)

# Convert to date format and remove duplicative entries
ts_df$Date <- as.POSIXct(strptime(ts_df$Date, format = "%m/%d/%Y %H:%M"))
which(duplicated(ts_df$Date))

# 6675 15579 24315 41786 50523 59259 68163 76899
ts_df <- ts_df[-c(6675, 15579, 24315, 41786, 50523, 59259, 68163, 76899),]

# Add in missing times from the time series
temp.zoo <- zoo(x = ts_df[,2], order.by = ts_df[,1])
ts_df <- merge(temp.zoo, zoo(, seq(start(temp.zoo), end(temp.zoo), by = "min")), all = TRUE)

# Remove extraneous columns and convert NAs
ts_df[ts_df == -999] <- NA
ts_df <- subset(ts_df, select=c('Date', 'Value'))


# ts_df <- removeNA(ts_df)
ts_df <- as.xts(ts_df$Value, order.by = ts_df$Date)
periodicity(ts_df)

# Fix the missing points in time using exponential smoothing
na.locf(ts_df, na.rm = FALSE, fromLast = FALSE)

# Subset for two years of data
subset <- ts_df[53356:75098]

# Review graphs of the series to detemine stationarity, seasonality, differencing


plot(subset)
acf2(subset, max.lag = 60)
