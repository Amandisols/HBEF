library(tidyverse)
library(lubridate)

# Retrieve datasets from EDI. 

# NOTES:
## For some reason the water level recordings R code doesn't work, need to download manually. 
#### Source: https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-hbr.161.4


################################################################################
###########################   CHEMISTRY   ######################################


# Package ID: knb-lter-hbr.317.3 Cataloging System:https://pasta.edirepository.org.
# Data set title: Hubbard Brook Experimental Forest: Watershed 3 Subsurface Water Chemistry.


inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/317/3/5ffa109381e37089a01ac26d86b1ecb0" 
infile1 <- tempfile()
try(download.file(inUrl1,infile1,method="curl"))
if (is.na(file.size(infile1))) download.file(inUrl1,infile1,method="auto")


dt1 <-read.csv(infile1,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "sample",     
                 "site",     
                 "time",     
                 "date",     
                 "wellID",     
                 "pH",     
                 "notes",     
                 "type",     
                 "watertable",     
                 "Ca",     
                 "Mg",     
                 "Na",     
                 "K",     
                 "T.hyphen.Al",     
                 "Si",     
                 "Mn.hyphen.MP",     
                 "Mn",     
                 "Fe.hyphen.MP",     
                 "Fe",     
                 "Zn.hyphen.MP",     
                 "Rb.hyphen.MP",     
                 "Sr.hyphen.MP",     
                 "Ba.hyphen.MP",     
                 "Pb.hyphen.MP",     
                 "F",     
                 "Cl",     
                 "NO3",     
                 "SO4",     
                 "DOC",     
                 "TDN",     
                 "NH4",     
                 "M.hyphen.Al",     
                 "O.hyphen.Al",     
                 "conductivity",     
                 "PO4",     
                 "Sr",     
                 "Zn"    ), check.names=TRUE)

unlink(infile1)

                                  
# Convert Date column to Date format
dt1$date <- ymd(dt1$date)


# Convert Missing Values to NA for non-dates
dt1[dt1 == -99.99] <- NA
dt1[dt1 == -99.999] <- NA
dt1[dt1 == -99.9999] <- NA

#dir.create("chemistry", recursive = TRUE)
write.csv(dt1, "chemistry/WS3-water-chem.csv")

################################################################################
################################################################################



################################################################################
#########################   LATWAG pedons   ####################################

# Package ID: knb-lter-hbr.361.3 Cataloging System:https://pasta.edirepository.org.

inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/361/3/bb91029a464278a2e47451aafec435c2" 
infile1 <- tempfile()
try(download.file(inUrl1,infile1,method="curl"))
if (is.na(file.size(infile1))) download.file(inUrl1,infile1,method="auto")


dt1 <-read.csv(infile1,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "pedon",     
                 "date",     
                 "observer",     
                 "project",     
                 "hpu",     
                 "easting",     
                 "northing",     
                 "water_table",     
                 "redox",     
                 "vegetation",     
                 "conditions",     
                 "base",     
                 "notes"    ), check.names=TRUE)

unlink(infile1)


# Convert Missing Values to NA for non-dates

dt1$easting <- ifelse((trimws(as.character(dt1$easting))==trimws("NA")),NA,dt1$easting)               
suppressWarnings(dt1$easting <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt1$easting))==as.character(as.numeric("NA"))),NA,dt1$easting))
dt1$northing <- ifelse((trimws(as.character(dt1$northing))==trimws("NA")),NA,dt1$northing)               
suppressWarnings(dt1$northing <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt1$northing))==as.character(as.numeric("NA"))),NA,dt1$northing))
dt1$water_table <- ifelse((trimws(as.character(dt1$water_table))==trimws("NA")),NA,dt1$water_table)               
suppressWarnings(dt1$water_table <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt1$water_table))==as.character(as.numeric("NA"))),NA,dt1$water_table))
dt1$redox <- ifelse((trimws(as.character(dt1$redox))==trimws("NA")),NA,dt1$redox)               
suppressWarnings(dt1$redox <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt1$redox))==as.character(as.numeric("NA"))),NA,dt1$redox))
dt1$vegetation <- as.factor(ifelse((trimws(as.character(dt1$vegetation))==trimws("NA")),NA,as.character(dt1$vegetation)))
dt1$conditions <- as.factor(ifelse((trimws(as.character(dt1$conditions))==trimws("NA")),NA,as.character(dt1$conditions)))
dt1$base <- as.factor(ifelse((trimws(as.character(dt1$base))==trimws("NA")),NA,as.character(dt1$base)))
dt1$notes <- as.factor(ifelse((trimws(as.character(dt1$notes))==trimws("NA")),NA,as.character(dt1$notes)))



inUrl2  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/361/3/cca9cc4a0a7218d0602aede8f3f8697e" 
infile2 <- tempfile()
try(download.file(inUrl2,infile2,method="curl"))
if (is.na(file.size(infile2))) download.file(inUrl2,infile2,method="auto")


dt2 <-read.csv(infile2,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "pedon",     
                 "genetic_horizon",     
                 "sample_horizon",     
                 "top_cm",     
                 "base_cm",     
                 "thickness",     
                 "major_color",     
                 "hue",     
                 "value",     
                 "chroma",     
                 "minor_color",     
                 "texture_mod",     
                 "texture",     
                 "structure",     
                 "consistence",     
                 "boundary",     
                 "fragments",     
                 "roots",     
                 "sample_collected",     
                 "notes"    ), check.names=TRUE)

unlink(infile2)


# Convert Missing Values to NA for non-dates

dt2$major_color <- as.factor(ifelse((trimws(as.character(dt2$major_color))==trimws("NA")),NA,as.character(dt2$major_color)))
dt2$hue <- as.factor(ifelse((trimws(as.character(dt2$hue))==trimws("NA")),NA,as.character(dt2$hue)))
dt2$value <- as.factor(ifelse((trimws(as.character(dt2$value))==trimws("-99")),NA,as.character(dt2$value)))
dt2$chroma <- as.factor(ifelse((trimws(as.character(dt2$chroma))==trimws("-99")),NA,as.character(dt2$chroma)))
dt2$minor_color <- as.factor(ifelse((trimws(as.character(dt2$minor_color))==trimws("NA")),NA,as.character(dt2$minor_color)))
dt2$texture_mod <- as.factor(ifelse((trimws(as.character(dt2$texture_mod))==trimws("NA")),NA,as.character(dt2$texture_mod)))
dt2$texture <- as.factor(ifelse((trimws(as.character(dt2$texture))==trimws("NA")),NA,as.character(dt2$texture)))
dt2$structure <- as.factor(ifelse((trimws(as.character(dt2$structure))==trimws("NA")),NA,as.character(dt2$structure)))
dt2$consistence <- as.factor(ifelse((trimws(as.character(dt2$consistence))==trimws("NA")),NA,as.character(dt2$consistence)))
dt2$boundary <- as.factor(ifelse((trimws(as.character(dt2$boundary))==trimws("NA")),NA,as.character(dt2$boundary)))
dt2$fragments <- ifelse((trimws(as.character(dt2$fragments))==trimws("-99")),NA,dt2$fragments)               
suppressWarnings(dt2$fragments <- ifelse(!is.na(as.numeric("-99")) & (trimws(as.character(dt2$fragments))==as.character(as.numeric("-99"))),NA,dt2$fragments))
dt2$roots <- as.factor(ifelse((trimws(as.character(dt2$roots))==trimws("NA")),NA,as.character(dt2$roots)))
dt2$notes <- as.factor(ifelse((trimws(as.character(dt2$notes))==trimws("NA")),NA,as.character(dt2$notes)))

dir.create("pedons", recursive = TRUE)
write.csv(dt1, "pedons/latwag_pedons.csv")
write.csv(dt2, "pedons/latwag_horizons.csv")



################################################################################
################################################################################



################################################################################
#########################    HBEF pedons    ####################################

# Package ID: knb-lter-hbr.210.2 Cataloging System:https://pasta.edirepository.org.
# Data set title: Hubbard Brook Experimental Forest: Soil Profiles (Pedons), 1995-2022.
# Data set creator:  Scott Bailey - Virginia Tech, Department of Forest Resources and Environmental Conservation 
# Contact:    - Information Manager Hubbard Brook Ecosystem Study  - hbr-im@lternet.edu
# Stylesheet v2.11 for metadata conversion into program: John H. Porter, Univ. Virginia, jporter@virginia.edu 

inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/210/2/42d7e94aea392080e7c40877c9a5df83" 
infile1 <- tempfile()
try(download.file(inUrl1,infile1,method="curl"))
if (is.na(file.size(infile1))) download.file(inUrl1,infile1,method="auto")


dt1 <-read.csv(infile1,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "pedon",     
                 "date",     
                 "observer",     
                 "project",     
                 "hpu",     
                 "easting",     
                 "northing",     
                 "pm",     
                 "depthclass",     
                 "notes"    ), check.names=TRUE)

unlink(infile1)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

if (class(dt1$pedon)!="factor") dt1$pedon<- as.factor(dt1$pedon)                                   
# attempting to convert dt1$date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
tmp1date<-as.Date(dt1$date,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(nrow(dt1[dt1$date != "",]) == length(tmp1date[!is.na(tmp1date)])){dt1$date <- tmp1date } else {print("Date conversion failed for dt1$date. Please inspect the data and do the date conversion yourself.")}                                                                    

if (class(dt1$observer)!="factor") dt1$observer<- as.factor(dt1$observer)
if (class(dt1$project)!="factor") dt1$project<- as.factor(dt1$project)
if (class(dt1$hpu)!="factor") dt1$hpu<- as.factor(dt1$hpu)
if (class(dt1$easting)!="factor") dt1$easting<- as.factor(dt1$easting)
if (class(dt1$northing)!="factor") dt1$northing<- as.factor(dt1$northing)
if (class(dt1$pm)!="factor") dt1$pm<- as.factor(dt1$pm)
if (class(dt1$depthclass)!="factor") dt1$depthclass<- as.factor(dt1$depthclass)
if (class(dt1$notes)!="factor") dt1$notes<- as.factor(dt1$notes)

# Convert Missing Values to NA for non-dates



inUrl2  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/210/2/407e3b6b8b88aaf095f15efeb865efd6" 
infile2 <- tempfile()
try(download.file(inUrl2,infile2,method="curl"))
if (is.na(file.size(infile2))) download.file(inUrl2,infile2,method="auto")


dt2 <-read.csv(infile2,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "pedon",     
                 "horizon",     
                 "top_cm",     
                 "base_cm",     
                 "major_color",     
                 "minor_color",     
                 "depl.",     
                 "conc.",     
                 "tex_mod",     
                 "tex",     
                 "structure",     
                 "consistence",     
                 "bound",     
                 "frags",     
                 "roots",     
                 "C_pct",     
                 "N_pct",     
                 "LOI",     
                 "pH_CaCl2",     
                 "pH_KCl",     
                 "acid_KCl",     
                 "Al_KCl",     
                 "Al_NH4Cl",     
                 "Ca_NH4Cl",     
                 "K_NH4Cl",     
                 "Mg_NH4Cl",     
                 "Mn_NH4Cl",     
                 "Na_NH4Cl",     
                 "Al_NH4OAc",     
                 "Ca_NH4OAc",     
                 "K_NH4OAc",     
                 "Mg_NH4OAc",     
                 "Mn_NH4OAc",     
                 "Na_NH4OAc",     
                 "P_NH4OAc",     
                 "Fe_d",     
                 "Mn_d",     
                 "Al_o",     
                 "Fe_o",     
                 "ODOE",     
                 "archive_g",     
                 "notes"    ), check.names=TRUE)

unlink(infile2)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

if (class(dt2$pedon)!="factor") dt2$pedon<- as.factor(dt2$pedon)
if (class(dt2$horizon)!="factor") dt2$horizon<- as.factor(dt2$horizon)
if (class(dt2$top_cm)=="factor") dt2$top_cm <-as.numeric(levels(dt2$top_cm))[as.integer(dt2$top_cm) ]               
if (class(dt2$top_cm)=="character") dt2$top_cm <-as.numeric(dt2$top_cm)
if (class(dt2$base_cm)=="factor") dt2$base_cm <-as.numeric(levels(dt2$base_cm))[as.integer(dt2$base_cm) ]               
if (class(dt2$base_cm)=="character") dt2$base_cm <-as.numeric(dt2$base_cm)
if (class(dt2$major_color)!="factor") dt2$major_color<- as.factor(dt2$major_color)
if (class(dt2$minor_color)!="factor") dt2$minor_color<- as.factor(dt2$minor_color)
if (class(dt2$depl.)!="factor") dt2$depl.<- as.factor(dt2$depl.)
if (class(dt2$conc.)!="factor") dt2$conc.<- as.factor(dt2$conc.)
if (class(dt2$tex_mod)!="factor") dt2$tex_mod<- as.factor(dt2$tex_mod)
if (class(dt2$tex)!="factor") dt2$tex<- as.factor(dt2$tex)
if (class(dt2$structure)!="factor") dt2$structure<- as.factor(dt2$structure)
if (class(dt2$consistence)!="factor") dt2$consistence<- as.factor(dt2$consistence)
if (class(dt2$bound)!="factor") dt2$bound<- as.factor(dt2$bound)
if (class(dt2$frags)=="factor") dt2$frags <-as.numeric(levels(dt2$frags))[as.integer(dt2$frags) ]               
if (class(dt2$frags)=="character") dt2$frags <-as.numeric(dt2$frags)
if (class(dt2$roots)!="factor") dt2$roots<- as.factor(dt2$roots)
if (class(dt2$C_pct)=="factor") dt2$C_pct <-as.numeric(levels(dt2$C_pct))[as.integer(dt2$C_pct) ]               
if (class(dt2$C_pct)=="character") dt2$C_pct <-as.numeric(dt2$C_pct)
if (class(dt2$N_pct)=="factor") dt2$N_pct <-as.numeric(levels(dt2$N_pct))[as.integer(dt2$N_pct) ]               
if (class(dt2$N_pct)=="character") dt2$N_pct <-as.numeric(dt2$N_pct)
if (class(dt2$LOI)=="factor") dt2$LOI <-as.numeric(levels(dt2$LOI))[as.integer(dt2$LOI) ]               
if (class(dt2$LOI)=="character") dt2$LOI <-as.numeric(dt2$LOI)
if (class(dt2$pH_CaCl2)=="factor") dt2$pH_CaCl2 <-as.numeric(levels(dt2$pH_CaCl2))[as.integer(dt2$pH_CaCl2) ]               
if (class(dt2$pH_CaCl2)=="character") dt2$pH_CaCl2 <-as.numeric(dt2$pH_CaCl2)
if (class(dt2$pH_KCl)=="factor") dt2$pH_KCl <-as.numeric(levels(dt2$pH_KCl))[as.integer(dt2$pH_KCl) ]               
if (class(dt2$pH_KCl)=="character") dt2$pH_KCl <-as.numeric(dt2$pH_KCl)
if (class(dt2$acid_KCl)=="factor") dt2$acid_KCl <-as.numeric(levels(dt2$acid_KCl))[as.integer(dt2$acid_KCl) ]               
if (class(dt2$acid_KCl)=="character") dt2$acid_KCl <-as.numeric(dt2$acid_KCl)
if (class(dt2$Al_KCl)=="factor") dt2$Al_KCl <-as.numeric(levels(dt2$Al_KCl))[as.integer(dt2$Al_KCl) ]               
if (class(dt2$Al_KCl)=="character") dt2$Al_KCl <-as.numeric(dt2$Al_KCl)
if (class(dt2$Al_NH4Cl)=="factor") dt2$Al_NH4Cl <-as.numeric(levels(dt2$Al_NH4Cl))[as.integer(dt2$Al_NH4Cl) ]               
if (class(dt2$Al_NH4Cl)=="character") dt2$Al_NH4Cl <-as.numeric(dt2$Al_NH4Cl)
if (class(dt2$Ca_NH4Cl)=="factor") dt2$Ca_NH4Cl <-as.numeric(levels(dt2$Ca_NH4Cl))[as.integer(dt2$Ca_NH4Cl) ]               
if (class(dt2$Ca_NH4Cl)=="character") dt2$Ca_NH4Cl <-as.numeric(dt2$Ca_NH4Cl)
if (class(dt2$K_NH4Cl)=="factor") dt2$K_NH4Cl <-as.numeric(levels(dt2$K_NH4Cl))[as.integer(dt2$K_NH4Cl) ]               
if (class(dt2$K_NH4Cl)=="character") dt2$K_NH4Cl <-as.numeric(dt2$K_NH4Cl)
if (class(dt2$Mg_NH4Cl)=="factor") dt2$Mg_NH4Cl <-as.numeric(levels(dt2$Mg_NH4Cl))[as.integer(dt2$Mg_NH4Cl) ]               
if (class(dt2$Mg_NH4Cl)=="character") dt2$Mg_NH4Cl <-as.numeric(dt2$Mg_NH4Cl)
if (class(dt2$Mn_NH4Cl)=="factor") dt2$Mn_NH4Cl <-as.numeric(levels(dt2$Mn_NH4Cl))[as.integer(dt2$Mn_NH4Cl) ]               
if (class(dt2$Mn_NH4Cl)=="character") dt2$Mn_NH4Cl <-as.numeric(dt2$Mn_NH4Cl)
if (class(dt2$Na_NH4Cl)=="factor") dt2$Na_NH4Cl <-as.numeric(levels(dt2$Na_NH4Cl))[as.integer(dt2$Na_NH4Cl) ]               
if (class(dt2$Na_NH4Cl)=="character") dt2$Na_NH4Cl <-as.numeric(dt2$Na_NH4Cl)
if (class(dt2$Al_NH4OAc)=="factor") dt2$Al_NH4OAc <-as.numeric(levels(dt2$Al_NH4OAc))[as.integer(dt2$Al_NH4OAc) ]               
if (class(dt2$Al_NH4OAc)=="character") dt2$Al_NH4OAc <-as.numeric(dt2$Al_NH4OAc)
if (class(dt2$Ca_NH4OAc)=="factor") dt2$Ca_NH4OAc <-as.numeric(levels(dt2$Ca_NH4OAc))[as.integer(dt2$Ca_NH4OAc) ]               
if (class(dt2$Ca_NH4OAc)=="character") dt2$Ca_NH4OAc <-as.numeric(dt2$Ca_NH4OAc)
if (class(dt2$K_NH4OAc)=="factor") dt2$K_NH4OAc <-as.numeric(levels(dt2$K_NH4OAc))[as.integer(dt2$K_NH4OAc) ]               
if (class(dt2$K_NH4OAc)=="character") dt2$K_NH4OAc <-as.numeric(dt2$K_NH4OAc)
if (class(dt2$Mg_NH4OAc)=="factor") dt2$Mg_NH4OAc <-as.numeric(levels(dt2$Mg_NH4OAc))[as.integer(dt2$Mg_NH4OAc) ]               
if (class(dt2$Mg_NH4OAc)=="character") dt2$Mg_NH4OAc <-as.numeric(dt2$Mg_NH4OAc)
if (class(dt2$Mn_NH4OAc)=="factor") dt2$Mn_NH4OAc <-as.numeric(levels(dt2$Mn_NH4OAc))[as.integer(dt2$Mn_NH4OAc) ]               
if (class(dt2$Mn_NH4OAc)=="character") dt2$Mn_NH4OAc <-as.numeric(dt2$Mn_NH4OAc)
if (class(dt2$Na_NH4OAc)=="factor") dt2$Na_NH4OAc <-as.numeric(levels(dt2$Na_NH4OAc))[as.integer(dt2$Na_NH4OAc) ]               
if (class(dt2$Na_NH4OAc)=="character") dt2$Na_NH4OAc <-as.numeric(dt2$Na_NH4OAc)
if (class(dt2$P_NH4OAc)=="factor") dt2$P_NH4OAc <-as.numeric(levels(dt2$P_NH4OAc))[as.integer(dt2$P_NH4OAc) ]               
if (class(dt2$P_NH4OAc)=="character") dt2$P_NH4OAc <-as.numeric(dt2$P_NH4OAc)
if (class(dt2$Fe_d)=="factor") dt2$Fe_d <-as.numeric(levels(dt2$Fe_d))[as.integer(dt2$Fe_d) ]               
if (class(dt2$Fe_d)=="character") dt2$Fe_d <-as.numeric(dt2$Fe_d)
if (class(dt2$Mn_d)=="factor") dt2$Mn_d <-as.numeric(levels(dt2$Mn_d))[as.integer(dt2$Mn_d) ]               
if (class(dt2$Mn_d)=="character") dt2$Mn_d <-as.numeric(dt2$Mn_d)
if (class(dt2$Al_o)=="factor") dt2$Al_o <-as.numeric(levels(dt2$Al_o))[as.integer(dt2$Al_o) ]               
if (class(dt2$Al_o)=="character") dt2$Al_o <-as.numeric(dt2$Al_o)
if (class(dt2$Fe_o)=="factor") dt2$Fe_o <-as.numeric(levels(dt2$Fe_o))[as.integer(dt2$Fe_o) ]               
if (class(dt2$Fe_o)=="character") dt2$Fe_o <-as.numeric(dt2$Fe_o)
if (class(dt2$ODOE)=="factor") dt2$ODOE <-as.numeric(levels(dt2$ODOE))[as.integer(dt2$ODOE) ]               
if (class(dt2$ODOE)=="character") dt2$ODOE <-as.numeric(dt2$ODOE)
if (class(dt2$archive_g)=="factor") dt2$archive_g <-as.numeric(levels(dt2$archive_g))[as.integer(dt2$archive_g) ]               
if (class(dt2$archive_g)=="character") dt2$archive_g <-as.numeric(dt2$archive_g)
if (class(dt2$notes)!="factor") dt2$notes<- as.factor(dt2$notes)

# Convert Missing Values to NA for non-dates

dt2$top_cm <- ifelse((trimws(as.character(dt2$top_cm))==trimws("NA")),NA,dt2$top_cm)               
suppressWarnings(dt2$top_cm <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$top_cm))==as.character(as.numeric("NA"))),NA,dt2$top_cm))
dt2$base_cm <- ifelse((trimws(as.character(dt2$base_cm))==trimws("NA")),NA,dt2$base_cm)               
suppressWarnings(dt2$base_cm <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$base_cm))==as.character(as.numeric("NA"))),NA,dt2$base_cm))
dt2$major_color <- as.factor(ifelse((trimws(as.character(dt2$major_color))==trimws("NA")),NA,as.character(dt2$major_color)))
dt2$minor_color <- as.factor(ifelse((trimws(as.character(dt2$minor_color))==trimws("NA")),NA,as.character(dt2$minor_color)))
dt2$depl. <- as.factor(ifelse((trimws(as.character(dt2$depl.))==trimws("NA")),NA,as.character(dt2$depl.)))
dt2$conc. <- as.factor(ifelse((trimws(as.character(dt2$conc.))==trimws("NA")),NA,as.character(dt2$conc.)))
dt2$tex_mod <- as.factor(ifelse((trimws(as.character(dt2$tex_mod))==trimws("NA")),NA,as.character(dt2$tex_mod)))
dt2$tex <- as.factor(ifelse((trimws(as.character(dt2$tex))==trimws("NA")),NA,as.character(dt2$tex)))
dt2$structure <- as.factor(ifelse((trimws(as.character(dt2$structure))==trimws("NA")),NA,as.character(dt2$structure)))
dt2$consistence <- as.factor(ifelse((trimws(as.character(dt2$consistence))==trimws("NA")),NA,as.character(dt2$consistence)))
dt2$bound <- as.factor(ifelse((trimws(as.character(dt2$bound))==trimws("NA")),NA,as.character(dt2$bound)))
dt2$frags <- ifelse((trimws(as.character(dt2$frags))==trimws("NA")),NA,dt2$frags)               
suppressWarnings(dt2$frags <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$frags))==as.character(as.numeric("NA"))),NA,dt2$frags))
dt2$roots <- as.factor(ifelse((trimws(as.character(dt2$roots))==trimws("NA")),NA,as.character(dt2$roots)))
dt2$C_pct <- ifelse((trimws(as.character(dt2$C_pct))==trimws("NA")),NA,dt2$C_pct)               
suppressWarnings(dt2$C_pct <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$C_pct))==as.character(as.numeric("NA"))),NA,dt2$C_pct))
dt2$N_pct <- ifelse((trimws(as.character(dt2$N_pct))==trimws("NA")),NA,dt2$N_pct)               
suppressWarnings(dt2$N_pct <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$N_pct))==as.character(as.numeric("NA"))),NA,dt2$N_pct))
dt2$LOI <- ifelse((trimws(as.character(dt2$LOI))==trimws("NA")),NA,dt2$LOI)               
suppressWarnings(dt2$LOI <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$LOI))==as.character(as.numeric("NA"))),NA,dt2$LOI))
dt2$pH_CaCl2 <- ifelse((trimws(as.character(dt2$pH_CaCl2))==trimws("NA")),NA,dt2$pH_CaCl2)               
suppressWarnings(dt2$pH_CaCl2 <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$pH_CaCl2))==as.character(as.numeric("NA"))),NA,dt2$pH_CaCl2))
dt2$pH_KCl <- ifelse((trimws(as.character(dt2$pH_KCl))==trimws("NA")),NA,dt2$pH_KCl)               
suppressWarnings(dt2$pH_KCl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$pH_KCl))==as.character(as.numeric("NA"))),NA,dt2$pH_KCl))
dt2$acid_KCl <- ifelse((trimws(as.character(dt2$acid_KCl))==trimws("NA")),NA,dt2$acid_KCl)               
suppressWarnings(dt2$acid_KCl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$acid_KCl))==as.character(as.numeric("NA"))),NA,dt2$acid_KCl))
dt2$Al_KCl <- ifelse((trimws(as.character(dt2$Al_KCl))==trimws("NA")),NA,dt2$Al_KCl)               
suppressWarnings(dt2$Al_KCl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Al_KCl))==as.character(as.numeric("NA"))),NA,dt2$Al_KCl))
dt2$Al_NH4Cl <- ifelse((trimws(as.character(dt2$Al_NH4Cl))==trimws("NA")),NA,dt2$Al_NH4Cl)               
suppressWarnings(dt2$Al_NH4Cl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Al_NH4Cl))==as.character(as.numeric("NA"))),NA,dt2$Al_NH4Cl))
dt2$Ca_NH4Cl <- ifelse((trimws(as.character(dt2$Ca_NH4Cl))==trimws("NA")),NA,dt2$Ca_NH4Cl)               
suppressWarnings(dt2$Ca_NH4Cl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Ca_NH4Cl))==as.character(as.numeric("NA"))),NA,dt2$Ca_NH4Cl))
dt2$K_NH4Cl <- ifelse((trimws(as.character(dt2$K_NH4Cl))==trimws("NA")),NA,dt2$K_NH4Cl)               
suppressWarnings(dt2$K_NH4Cl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$K_NH4Cl))==as.character(as.numeric("NA"))),NA,dt2$K_NH4Cl))
dt2$Mg_NH4Cl <- ifelse((trimws(as.character(dt2$Mg_NH4Cl))==trimws("NA")),NA,dt2$Mg_NH4Cl)               
suppressWarnings(dt2$Mg_NH4Cl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Mg_NH4Cl))==as.character(as.numeric("NA"))),NA,dt2$Mg_NH4Cl))
dt2$Mn_NH4Cl <- ifelse((trimws(as.character(dt2$Mn_NH4Cl))==trimws("NA")),NA,dt2$Mn_NH4Cl)               
suppressWarnings(dt2$Mn_NH4Cl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Mn_NH4Cl))==as.character(as.numeric("NA"))),NA,dt2$Mn_NH4Cl))
dt2$Na_NH4Cl <- ifelse((trimws(as.character(dt2$Na_NH4Cl))==trimws("NA")),NA,dt2$Na_NH4Cl)               
suppressWarnings(dt2$Na_NH4Cl <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Na_NH4Cl))==as.character(as.numeric("NA"))),NA,dt2$Na_NH4Cl))
dt2$Al_NH4OAc <- ifelse((trimws(as.character(dt2$Al_NH4OAc))==trimws("NA")),NA,dt2$Al_NH4OAc)               
suppressWarnings(dt2$Al_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Al_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$Al_NH4OAc))
dt2$Ca_NH4OAc <- ifelse((trimws(as.character(dt2$Ca_NH4OAc))==trimws("NA")),NA,dt2$Ca_NH4OAc)               
suppressWarnings(dt2$Ca_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Ca_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$Ca_NH4OAc))
dt2$K_NH4OAc <- ifelse((trimws(as.character(dt2$K_NH4OAc))==trimws("NA")),NA,dt2$K_NH4OAc)               
suppressWarnings(dt2$K_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$K_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$K_NH4OAc))
dt2$Mg_NH4OAc <- ifelse((trimws(as.character(dt2$Mg_NH4OAc))==trimws("NA")),NA,dt2$Mg_NH4OAc)               
suppressWarnings(dt2$Mg_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Mg_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$Mg_NH4OAc))
dt2$Mn_NH4OAc <- ifelse((trimws(as.character(dt2$Mn_NH4OAc))==trimws("NA")),NA,dt2$Mn_NH4OAc)               
suppressWarnings(dt2$Mn_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Mn_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$Mn_NH4OAc))
dt2$Na_NH4OAc <- ifelse((trimws(as.character(dt2$Na_NH4OAc))==trimws("NA")),NA,dt2$Na_NH4OAc)               
suppressWarnings(dt2$Na_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Na_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$Na_NH4OAc))
dt2$P_NH4OAc <- ifelse((trimws(as.character(dt2$P_NH4OAc))==trimws("NA")),NA,dt2$P_NH4OAc)               
suppressWarnings(dt2$P_NH4OAc <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$P_NH4OAc))==as.character(as.numeric("NA"))),NA,dt2$P_NH4OAc))
dt2$Fe_d <- ifelse((trimws(as.character(dt2$Fe_d))==trimws("NA")),NA,dt2$Fe_d)               
suppressWarnings(dt2$Fe_d <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Fe_d))==as.character(as.numeric("NA"))),NA,dt2$Fe_d))
dt2$Mn_d <- ifelse((trimws(as.character(dt2$Mn_d))==trimws("NA")),NA,dt2$Mn_d)               
suppressWarnings(dt2$Mn_d <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Mn_d))==as.character(as.numeric("NA"))),NA,dt2$Mn_d))
dt2$Al_o <- ifelse((trimws(as.character(dt2$Al_o))==trimws("NA")),NA,dt2$Al_o)               
suppressWarnings(dt2$Al_o <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Al_o))==as.character(as.numeric("NA"))),NA,dt2$Al_o))
dt2$Fe_o <- ifelse((trimws(as.character(dt2$Fe_o))==trimws("NA")),NA,dt2$Fe_o)               
suppressWarnings(dt2$Fe_o <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$Fe_o))==as.character(as.numeric("NA"))),NA,dt2$Fe_o))
dt2$ODOE <- ifelse((trimws(as.character(dt2$ODOE))==trimws("NA")),NA,dt2$ODOE)               
suppressWarnings(dt2$ODOE <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$ODOE))==as.character(as.numeric("NA"))),NA,dt2$ODOE))
dt2$archive_g <- ifelse((trimws(as.character(dt2$archive_g))==trimws("NA")),NA,dt2$archive_g)               
suppressWarnings(dt2$archive_g <- ifelse(!is.na(as.numeric("NA")) & (trimws(as.character(dt2$archive_g))==as.character(as.numeric("NA"))),NA,dt2$archive_g))

write.csv(dt1, "pedons/hbef_pedons.csv")
write.csv(dt2, "pedons/hbef_horizons.csv")

################################################################################
################################################################################





