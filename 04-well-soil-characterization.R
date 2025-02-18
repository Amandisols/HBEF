
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

rm(latwag_ped, hbef_ped, latwag_hor, hbef_hor)
  
# Well metadata
wells <- read_csv("timeseries/edi_waterlevels/W3_Well_Information.csv")
wells <- wells %>% select(Well_ID, Pedon_QGIS, Distance)
colnames(wells)[2] <- "pedon"

unique(wells$Pedon)


# NEED TO DO: classify HPUs
#Auger investigation
augers <- read_csv("pedons/auger_horizons.csv")
colnames(augers)[2] <- "pedon"
augers$hpu <- NA

augers <- augers %>%
  filter(pedon %in% c("R9C4", "R13C7", "R12C5", "R13C6", "R488M50", "R484M50", 
                      "R478M20", "R476M10", "R476M0", "R464C12",
                      "R460C10", "R470M10", "R472M9.3", "R474M0"))


augers$hpu <- ifelse(augers$pedon == "R464C12", "T", augers$hpu)
augers$hpu <- ifelse(augers$pedon == "R460C10", "T", augers$hpu)
augers$hpu <- ifelse(augers$pedon == "R488M50", "Bhs", augers$hpu) 
augers$hpu <- ifelse(augers$pedon == "R484M50", "Bhs", augers$hpu) # There is 2 profiles.. very different Oa depths 
augers$hpu <- ifelse(augers$pedon == "R478M20", "Bhs", augers$hpu)
augers$hpu <- ifelse(augers$pedon == "R476M0", "Bh", augers$hpu) 
augers$hpu <- ifelse(augers$pedon == "R476M10", "Bhs", augers$hpu) 
augers$hpu <- ifelse(augers$pedon == "R472M9.3", "Bhs", augers$hpu) 
augers$hpu <- ifelse(augers$pedon == "R470M10", "Bhs", augers$hpu) 
augers$hpu <- ifelse(augers$pedon == "R9C4", "E", augers$hpu)
augers$hpu <- ifelse(augers$pedon == "R13C7", "Bhs", augers$hpu) 
augers$hpu <- ifelse(augers$pedon == "R12C5", "Bhs", augers$hpu)
augers$hpu <- ifelse(augers$pedon == "R13C6", "Bhs", augers$hpu)
augers$hpu <- ifelse(augers$pedon == "R474M0", "Bh", augers$hpu)

augers <- augers %>% select(pedon, hpu, Horizon, `Bottom (cm)`)
colnames(augers)[3] <- "horizon"
colnames(augers)[4] <- "base_cm"
augers <- subset(augers, grepl('O', horizon))

augers <- augers %>%
  group_by(pedon) %>%
  slice(which.max(base_cm))

soil_data <- rbind(soil_data, augers)

# Combine
#fix some names for the join

soil_data$pedon <- ifelse(soil_data$pedon  == "K04", "K4S", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "K01", "K1S", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "K08", "K8", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "K09", "K9", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "K05", "K5", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "H01", "H1", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "H02", "H2", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "H03", "H3", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "H04", "H4", soil_data$pedon)
soil_data$pedon <- ifelse(soil_data$pedon  == "D01", "D1", soil_data$pedon)


wells <- left_join(wells, soil_data, by = "pedon")

colnames(wells)[3] <- "pedon_distance"

chem <- read.csv("chemistry/WS3-water-chem.csv")

chem$site <- ifelse(chem$site  == "K1s", "K1S", chem$site)
chem$site <- ifelse(chem$site  == "K4s", "K4S", chem$site)
chem$site <- ifelse(chem$site  == "K6s", "K6S", chem$site)
chem$site <- ifelse(chem$site  == "K7s", "K7S", chem$site)
chem$site <- ifelse(chem$site  == "K1d", "K1D", chem$site)
chem$site <- ifelse(chem$site  == "K4d", "K4D", chem$site)
chem$site <- ifelse(chem$site  == "K6d", "K6D", chem$site)
chem$site <- ifelse(chem$site  == "K7d", "K7D", chem$site)


chem$site <- ifelse(chem$site  == "42_2s", "42_2_s1", chem$site)
chem$site <- ifelse(chem$site  == "42_3s", "42_3_s1", chem$site)
chem$site <- ifelse(chem$site  == "42_4d1", "42_4_d1", chem$site)
chem$site <- ifelse(chem$site  == "42_4d2", "42_4_d2", chem$site)
chem$site <- ifelse(chem$site  == "42_4s", "42_4_s1", chem$site)
chem$site <- ifelse(chem$site  == "52_2s", "52_2_s1", chem$site)
chem$site <- ifelse(chem$site  == "52_3s", "52_3_s1", chem$site)
chem$site <- ifelse(chem$site  == "52_4d1", "52_4_d1", chem$site)
chem$site <- ifelse(chem$site  == "52_4d2", "52_4_d2", chem$site)
chem$site <- ifelse(chem$site  == "52_4s", "52_4_s1", chem$site)
chem$site <- ifelse(chem$site  == "52_d2", "52_4_d1", chem$site)
chem$site <- ifelse(chem$site  == "86_2s", "86_2_s1", chem$site)
chem$site <- ifelse(chem$site  == "86_3s", "86_3_s1", chem$site)
chem$site <- ifelse(chem$site  == "86_4s", "86_4_s1", chem$site)

colnames(chem)[3] <- "Well_ID"

#Read out chem with fixed names
write.csv(chem, "chemistry/WS3-water-chem_CLEAN.csv")


chem <- chem %>%
  group_by(Well_ID) %>%
  summarise(chem_count = n(),
            .groups = 'drop'
            )

wells <- left_join(wells, chem, by = "Well_ID")

#Read out
write.csv(wells, "chemistry/wellinfo.csv")



