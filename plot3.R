#load tidyverse and lubridate
library(tidyverse)
library(lubridate)

#clear environment
rm(list = ls())

#create data folder
if(!dir.exists("data"))dir.create("data")


#download repository and unzip
if(!file.exists("./data/household_power_consumption.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "./data/household_power_consumption.zip",
                method = "curl")}

if(file.exists("./data/household_power_consumption.txt")){
  unzip("./data/household_power_consumption.zip", exdir = "./data")
}

#load archive
household_power <- read_delim("data/household_power_consumption.txt", 
                              delim = ";", escape_double = FALSE, 
                              trim_ws = TRUE, na = c("", "?"))

#convert dates (times were automatically detected)
household_power <- household_power %>% 
  mutate(Date = dmy(Date)
  )

#subset dates
household_power <- household_power %>% 
  filter(Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))

#convert strings to numbers
household_power <- household_power %>% 
  mutate(
    Date_time = ymd_hms(str_c(as.character(Date), as.character(Time), sep = " "))
  )


#set locale to English to get proper weekdays
#(This is neccesary only as I'm working in a computer that is set in Spanish)
curr_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "English")

#plot
png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")

with(household_power, plot(Date_time,Sub_metering_1, type = "n", 
                           ylab = "Energy sub metering", xlab = NA))

with(household_power, lines(Date_time,Sub_metering_1, col = "black"))
with(household_power, lines(Date_time,Sub_metering_2, col = "red"))
with(household_power, lines(Date_time,Sub_metering_3, col = "blue"))
with(household_power, legend("topright",
                             legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                             lty = 1,
                             col = c("black","red","blue")))  
  

dev.off()

#return locale to default
Sys.setlocale("LC_TIME",curr_locale)
