# Read CSV, could improve by reading only relevant dates (e.g. through SQL select)
# Only tested on Mac OS X, given assignment focus
source_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest <- "power_data.zip"
if(!file.exists(dest)) {
  download.file(source_url, dest, method = "curl")
}
source_filename <- "household_power_consumption.txt"
power_data <- read.csv2(unz(dest,source_filename), colClasses = c("factor", "factor", rep("numeric",7)), dec = ".", na.strings = c("?"))

# Subset data set on Date
power_data <- subset(power_data, Date == "1/2/2007" | Date == "2/2/2007")

# Default conversion does not deal with Dates and Times well so manually convert
power_data[[2]] = with(power_data, as.POSIXct(paste(Date, Time), format="%d/%m/%Y %T"))
power_data[[1]] = as.Date(power_data[[1]], "%d/%m/%Y")

# Plot 4
png(file = "plot4.png", width=480, height = 480)
par(mfrow=c(2,2))

#Global active power
plot(power_data$Time, power_data$Global_active_power, type = "l", main = "", xlab = "", ylab = "Global Active Power") 

#Voltage
plot(power_data$Time, power_data$Voltage, type = "l", main = "", xlab = "datetime", ylab = "Voltage") 
colors = c("black", "red", "blue")

#Energy sub metering
plot(power_data$Time, power_data$Sub_metering_1, type = "l", col = colors[1], main = "", xlab = "", ylab = "Energy sub metering") 
lines(power_data$Time, power_data$Sub_metering_2, type = "l", col = colors[2])
lines(power_data$Time, power_data$Sub_metering_3, type = "l", col = colors[3])
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = colors, bty = "n", lty = c(1,1,1))

#Reactive power
plot(power_data$Time, power_data$Global_reactive_power, type = "l", main = "", xlab = "datetime",  ylab = "Global_reactive_power") 
dev.off()
