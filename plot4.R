library(dplyr)


#download the file if it doesn't already exist
if (!file.exists('household_power_consumption.txt')){
  
  url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  file <-'household_power_consumption.zip'
  download.file(url, file)
  unzip('./household_power_consumption.zip')
  
}

#read in the data into R
initial <- read.table('household_power_consumption.txt', header=TRUE
                      ,sep=';', na.strings='?', nrows=100)
classes <-sapply(initial, class)
dates <-read.table(text = grep("^[1,2]/2/2007", readLines('household_power_consumption.txt')
                      ,value=TRUE), header=TRUE
                   ,sep=';', na.strings='?', colClasses = classes, col.names =  names(initial)
                   ,stringsAsFactors = FALSE)
rm(initial)

#format date & time
dates <- mutate(dates, Datetime = as.POSIXct(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S")))

#create plot4 and save as png
png(file="plot4.png")
par(mfrow = c(2, 2))

#topleft graph
plot(dates$Datetime, dates$Global_active_power, type = "l", ylab = "Global Active Power", 
     xlab = "")

#topright graph
plot(dates$Datetime, dates$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

#bottomleft graph
plot(dates$Datetime, dates$Sub_metering_1, type = "l", ylab = "Energy sub metering", 
     xlab = "", col = "black")
points(dates$Datetime, dates$Sub_metering_2, type = "l", xlab = "", ylab = "Sub_metering_2", 
       col = "red")
points(dates$Datetime, dates$Sub_metering_3, type = "l", xlab = "", ylab = "Sub_metering_3", 
       col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

#bottomright graph
plot(dates$Datetime
     , dates$Global_reactive_power
     , type = "l"
     , xlab = "datetime"
     , ylab = "Global_reactive_power"
     , ylim = c(0, 0.5)
     )  
dev.off()