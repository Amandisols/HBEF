
#Author: Amanda Pennino
#Date: December 2, 2024

library(tidyverse)


#inputs
# * Latwag pedons
# * HBEF pedons
# * Well metadata
# * GW chemistry

#outputs
# * New datasheet with: Well Name, Pedon Name, HPU, O-depth, # chem samples


# Extract relevant pedon data
latwag_ped <- read_csv("pedons/latwag_pedons.csv")
latwag_ped <- latwag_ped %>% select(pedon, hpu)
latwag_ped$hpu[latwag_ped$hpu == "Lithic Histosol"] <- "O"
latwag_ped$hpu[latwag_ped$hpu == "E podzol"] <- "E"
latwag_ped$hpu[latwag_ped$hpu == "Bhs podzol"] <- "Bhs"
latwag_ped$hpu[latwag_ped$hpu == "Bimodal podzol"] <- "Bi"
latwag_ped$hpu[latwag_ped$hpu == "Typical podzol"] <- "T"
latwag_ped$hpu[latwag_ped$hpu == "Bh podzol"] <- "Bh"

hbef_ped <- read_csv("pedons/hbef_pedons.csv")
hbef_ped <- subset(hbef_ped, grepl('WS3', pedon))
hbef_ped <- hbef_ped %>% select(pedon, hpu)

pedons <- rbind(latwag_ped, hbef_ped)


latwag_hor <- read_csv("pedons/latwag_horizons.csv")

latwag_hor <- latwag_hor %>%
  select(pedon, genetic_horizon, base_cm) %>%
  rename(horizon = genetic_horizon)

hbef_hor <- read_csv("pedons/hbef_horizons.csv")
hbef_hor <- hbef_hor %>% select(pedon, horizon, base_cm) 
hbef_hor <- subset(hbef_hor, grepl('WS3', pedon))

horizons <- rbind(latwag_hor, hbef_hor)
horizons <- subset(horizons, grepl('O', horizon))

horizons <- horizons %>%
  group_by(pedon) %>%
  slice(which.max(base_cm))

soil_data <- left_join(pedons, horizons, by = "pedon")
soil_data$pedon <- gsub("WS3_", "", as.character(soil_data$pedon))

  
# Well metadata
wells <- read_csv("timeseries/edi_waterlevels/W3_Well_Information.csv")
wells <- wells %>% select(Well_ID, Pedon)


  # Add pedons that associatem within 5m of well



rm(latwag_ped, hbef_ped, latwag_hor, hbef_hor)
