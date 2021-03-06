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

#create plot2 and save as png
png(file="plot2.png")
plot(dates$Datetime, dates$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()