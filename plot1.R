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


#plot
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")

hist(household_power$Global_active_power, col = "red", 
     main = "Global Active Power", bg = "transparent", xlab = "Global Active Power (kilowatts)")

dev.off()


