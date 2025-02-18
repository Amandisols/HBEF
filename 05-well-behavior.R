library(tidyverse)
library(lubridate)
library(data.table)

## NOTES

# 1. Pull dates of chem sampling
# 2. Loop through WT dfs and pull max water depth (min?) for that day
# 3. Does max cross O-horizon threshold? Approach?
# 4. Plot by well, HPU. Add n = 

chem <- read.csv("chemistry/WS3-water-chem_CLEAN.csv")
wells <- read.csv("chemistry/wellinfo.csv")

wells_O <- wells[!is.na(wells$base_cm),]
wells_O <- wells_O[!is.na(wells_O$chem_count),]

names <- wells_O$Well_ID
chem_O <- subset(chem, Well_ID %in% names)

chem_O <- chem_O %>%
  select(Well_ID, date, pH, DOC)


#Create start/end date column
chem_O$date2 <- paste(chem_O$date, "12:00:00", sep = " ")
chem_O$DateTime_End <- as.POSIXct(chem_O$date2, format="%Y-%m-%d %H:%M:%OS")
chem_O$DateTime_Start <- chem_O$DateTime_End - 432000 #seconds to 48 hours
chem_O <- chem_O %>% select(-date2)

#Pull out for each unique datetime
dates <- chem_O %>% select(DateTime_Start, DateTime_End)

dates <- unique(as.data.table(dates)[, c("DateTime_Start", "DateTime_End") := list(pmin(DateTime_Start, DateTime_End),
                                                 pmax(DateTime_Start, DateTime_End))], by = c("DateTime_Start", "DateTime_End"))



### This takes a while to run (~20 min) 

folder_path <- "timeseries/edi_waterlevels/HBEF_W3_GroundwaterLevels"

results <- data.frame(Well_ID = character(), Max_Depth = numeric(), stringsAsFactors = FALSE)

for(i in 1:nrow(chem_O)){
  
  #Extract the ID, Start Date, End Date
  id = chem_O$Well_ID[i]
  start_date = chem_O$DateTime_Start[i]
  end_date = chem_O$DateTime_End[i]
  
  #Construct the file path
  file_path <- file.path(folder_path, paste0(id, ".csv"))
  
  #Check if the file exists
  if(file.exists(file_path)){
    
    #Read file
    time_series <- read.csv(file_path)
    time_series$DateTime <- as.POSIXct(time_series$DateTime, format="%Y-%m-%d %H:%M:%OS")
    
    #Filter between time periods
    filtered <- time_series %>%
      filter(DateTime >= start_date & DateTime <= end_date)
    
    #Get max depth
    max_depth <- min(filtered$Depth_cm, na.rm = TRUE)
    
    #Append the result
    results <- rbind(results, data.frame(Well_ID = id, Max_Depth = max_depth, DateTime_Start = start_date))
  } else {
    
    #if the file does not exist
    results <- rbind(results,  data.frame(Well_ID = id, Max_Depth = NA))
                     
  }
}


# Test a few out
test <- read_csv("timeseries/edi_waterlevels/HBEF_W3_GroundwaterLevels/N4.csv")
test$DateTime <- as.POSIXct(test$DateTime, format="%Y-%m-%d %H:%M:%OS")
test <- test %>%
  filter(DateTime >= "2014-06-12 12:00:00" & DateTime <= "2014-06-13 12:00:00")

max = min(test$Depth_cm)


#### Continue

chem_O2 <- left_join(chem_O, results, by = c("Well_ID", "DateTime_Start"))
chem_O2 <- chem_O2 %>% distinct()

# Why are there more observations after the join? 554 vs. 453
# Now I'm missing 2?!

chem_O2 <- left_join(chem_O2, wells_O)
chem_O2[sapply(chem_O2, is.infinite)] <- NA

#Does the water table max height pass the O threshold?
chem_O2$Pass <- ifelse(chem_O2$Max_Depth <= chem_O2$base_cm, "Yes", "No")


#Not enough passed.. consider changing the start/end date threshold.
#Right now 23 yes and 361 no (24 hours)
#After switching to 48 hours it's 25 yes
#5 days = 33 yes
#5 days and within 5 cm of O horizon = 70
chem_O2 %>% group_by(Pass) %>% summarise(n=n())


#chem_5days <- chem_O2


chem_O2 %>%
  filter(!is.na(Pass)) %>%
  ggplot(aes(x=hpu, y=DOC, fill=Pass))+
  geom_boxplot()





